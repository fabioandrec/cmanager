unit CBasics;

interface

uses Variants, Classes, SysUtils, Windows;

const
  QUEUE_SIZE_UNLIMITED = MaxInt;
  QUEUE_REMOVE_ALL = 0;
  QUEUE_NO_AUTOCLEAN = 0;

type
  TPoolObject = class(TObject)
  end;

  TLockState = (lsGranted, lsTimeout, lsError, lsRejected, lsHalted);

  TLock = class(TPoolObject)
  private
    FLockMutex: THandle;
    FHaltEvent: THandle;
    FOwnerId: Cardinal;
    function GetGotOwnership: TLockState;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Release;
    function Acquire(AWaitTime: Int64): TLockState;
    procedure Reject;
    procedure Accept;
  published
    property GotOwnership: TLockState read GetGotOwnership;
  end;

  TThreadStatus = (tsSuspended, tsRunning, tsFinished);

  TBaseThread = class(TPoolObject)
  private
    FHandle: THandle;
    FHaltEvent: THandle;
    FRunEvent: THandle;
    FId: Cardinal;
    FStatus: TThreadStatus;
    FExitCode: Cardinal;
    FFreeOnTerminate: Boolean;
    FIsCancelled: Boolean;
  protected
    function MainThreadProcedure: Cardinal; virtual; abstract;
    procedure ThreadFinished; virtual;
  public
    function InitThread: Boolean; virtual;
    function FinishThread(AWaitTime: Int64): Boolean; virtual;
    procedure CancelThread; virtual;
    constructor Create(AFreeOnTerminate: Boolean = False);
    destructor Destroy; override;
  published
    property Status: TThreadStatus read FStatus;
    property ExitCode: Cardinal read FExitCode;
    property HaltEvent: THandle read FHaltEvent;
    property RunEvent: Thandle read FRunEvent;
    property Handle: THandle read FHandle;
    property IsCancelled: Boolean read FIsCancelled;
  end;

  TBaseThreadList = class(TPoolObject)
  private
    FList: TList;
    FIsActive: Boolean;
  public
    constructor Create;
    function AddThread(AThread: TBaseThread): Boolean;
    function RemoveThread(AThread: TBaseThread): Boolean;
    procedure StartThreads;
    procedure StopThreads;
    procedure ClearThreads(AFreeAndNil: Boolean);
    destructor Destroy; override;
    property List: TList read FList;
  end;

  TPoolEntry = class(TObject)
  private
    FIsAuto: Boolean;
    FPoolObject: TPoolObject;
    FOwnerId: Cardinal;
  public
    constructor Create(AIsAuto: Boolean; APoolObject: TPoolObject);
    destructor Destroy; override;
  published
    property PoolObject: TPoolObject read FPoolObject;
    property OwnerId: Cardinal read FOwnerId write FOwnerId;
  end;

  TNeedPoolObject = function: TPoolObject of Object;

  TPool = class(TPoolObject)
  private
    FMaxPoolSize: Integer;
    FInitPoolSize: Integer;
    FList: TList;
    FLock: TLock;
    FCountSemaphore: THandle;
    FHaltEvent: THandle;
    FNeedPoolObject: TNeedPoolObject;
    FIsActive: Boolean;
    function RegisterPoolEntry(AObject: TPoolObject): TPoolEntry;
    function FindEntry(AObject: TPoolObject): TPoolEntry;
    function FirstIdle(AAutoOwn: Boolean): TPoolEntry;
  public
    constructor Create(AMaxPoolSize: Integer; AInitPoolSize: Integer);
    procedure ActivatePool;
    procedure DeactivatePool;
    destructor Destroy; override;
    procedure ClearPool;
    function RegisterObject(AObject: TPoolObject): Boolean;
    function UnregisterObject(AObject: TPoolObject): Boolean;
    function AcquireObject(AWaitForIdle: Int64): TPoolObject;
    function ReleaseObject(AObject: TPoolObject): Boolean;
    property OnNeedPoolObject: TNeedPoolObject read FNeedPoolObject write FNeedPoolObject;
  end;

  TQueuedMessage = class(TObject)
  protected
    function GetData: String; virtual; abstract;
    function GetDesc: String; virtual; abstract;
    function GetHash: String; virtual; abstract;
  published
    property Desc: String read GetDesc;
    property Data: String read GetData;
    property Hash: String read GetHash;
  end;

  TQueueEntry = class(TObject)
  private
    FQueuedMessage: TQueuedMessage;
    FCreationTime: TDateTime;
  public
    constructor Create(AMessage: TQueuedMessage);
    destructor Destroy; override;
  published
    property QueuedMessage: TQueuedMessage read FQueuedMessage;
    property CreationTime: TDateTime read FCreationTime;
  end;

  TMessageQueue = class;

  TQueueCleaner = class(TBaseThread)
  private
    FQueue: TMessageQueue;
    FInterval: Int64;
    FRemoveAge: Int64;
  protected
    function MainThreadProcedure: Cardinal; override;
  public
    constructor Create(AQueue: TMessageQueue; AInterval: Int64; ARemoveAge: Int64);
  end;

  TMessageQueue = class(TPoolObject)
  private
    FMaxQueueSize: Integer;
    FList: TList;
    FLock: TLock;
    FCountSemaphore: THandle;
    FAutoCleaner: TQueueCleaner;
    FHashList: TStringList;
    function IsMessageExists(AMessage: TQueuedMessage): Boolean;
  public
    constructor Create(AMaxSize: Integer = QUEUE_SIZE_UNLIMITED; AAutoCleanInterval: Integer = QUEUE_NO_AUTOCLEAN; AAutoRemoveAge: Int64 = 0);
    destructor Destroy; override;
    function RemoveMessage: TQueuedMessage;
    function InsertMessage(AMessage: TQueuedMessage; AFirstToRemove: Boolean = False; AOnlyWhenNotExists: Boolean = False): Boolean;
    procedure ClearMessages(ARemoveAge: Int64 = QUEUE_REMOVE_ALL);
  published
    property CountSemaphore: THandle read FCountSemaphore;
  end;

  TRemoveFromQueueWorker = class(TBaseThread)
  private
    FSourceQueue: TMessageQueue;
  protected
    function MainThreadProcedure: Cardinal; override;
    function ProcessMessage(AMessage: TQueuedMessage): Boolean; virtual; abstract;
  public
    constructor Create(ASourceQueue: TMessageQueue);
  end;

  TInsertToQueueWorker = class(TBaseThread)
  private
    FDestQueue: TMessageQueue;
  protected
    function MainThreadProcedure: Cardinal; override;
    function NeedMessage: TQueuedMessage; virtual; abstract;
  public
    constructor Create(ADestQueue: TMessageQueue);
  end;

  TMoveFromQueueToQueueWorker = class(TRemoveFromQueueWorker)
  private
    FDestQueue: TMessageQueue;
  protected
    function ProcessMessage(AMessage: TQueuedMessage): Boolean; override;
    function PrepareMessage(AMessage: TQueuedMessage; var ARemove: Boolean): TQueuedMessage; virtual;
  public
    constructor Create(ASourceQueue: TMessageQueue; ADestQueue: TMessageQueue); virtual;
  end;

implementation

uses DateUtils;

function ThreadExecutePorcedure(AParam: Pointer): Cardinal; stdcall;
begin
  TBaseThread(AParam).FStatus := tsRunning;
  Result := TBaseThread(AParam).MainThreadProcedure;
  TBaseThread(AParam).FStatus := tsFinished;
  if TBaseThread(AParam).IsCancelled then begin
    TBaseThread(AParam).FExitCode := ERROR_CANCELLED;
  end else begin
    TBaseThread(AParam).FExitCode := Result;
  end;
  TBaseThread(AParam).ThreadFinished;
  if TBaseThread(AParam).FFreeOnTerminate then begin
    FreeAndNil(TBaseThread(AParam));
  end;
  ExitThread(Result);
end;

procedure TLock.Accept;
begin
  ResetEvent(FHaltEvent);
end;

function TLock.Acquire(AWaitTime: Int64): TLockState;
var xRes: Cardinal;
    xHandles: array[0..1] of THandle;
begin
  Result := GotOwnership;
  if Result <> lsGranted then begin
    xHandles[0] := FHaltEvent;
    xHandles[1] := FLockMutex;
    xRes := WaitForMultipleObjects(2, @xHandles[0], False, AWaitTime);
    if xRes = WAIT_OBJECT_0 + 1 then begin
      if FOwnerId = 0 then begin
        FOwnerId := GetCurrentThreadId;
        Result := lsGranted;
      end else begin
        Result := lsRejected;
      end;
    end else if xRes = WAIT_OBJECT_0 then begin
      Result := lsHalted;
    end else if xRes = WAIT_TIMEOUT then begin
      Result := lsTimeout;
    end else begin
      Result := lsError;
    end;
  end;
end;

constructor TLock.Create;
begin
  inherited Create;
  FLockMutex := CreateMutex(Nil, False, Nil);
  FHaltEvent := CreateEvent(Nil, True, False, Nil);
  FOwnerId := 0;
  Accept;
end;

destructor TLock.Destroy;
begin
  Reject;
  CloseHandle(FLockMutex);
  CloseHandle(FHaltEvent);
  inherited Destroy;
end;

function TLock.GetGotOwnership: TLockState;
begin
  if FOwnerId = GetCurrentThreadId then begin
    Result := lsGranted;
  end else begin
    Result := lsRejected;
  end;
end;

constructor TBaseThread.Create(AFreeOnTerminate: Boolean = False);
begin
  inherited Create;
  FHaltEvent := CreateEvent(Nil, True, False, Nil);
  FRunEvent := CreateEvent(Nil, True, False, Nil);
  FHandle := CreateThread(Nil, 0, @ThreadExecutePorcedure, Pointer(Self), CREATE_SUSPENDED, FId);
  FStatus := tsSuspended;
  IsMultiThread := True;
  FExitCode := 0;
  FFreeOnTerminate := AFreeOnTerminate;
end;

destructor TBaseThread.Destroy;
begin
  if FStatus = tsRunning then begin
    FinishThread(INFINITE);
  end;
  CloseHandle(FHandle);
  CloseHandle(FHaltEvent);
  CloseHandle(FRunEvent);
  inherited Destroy;
end;

function TBaseThread.InitThread: Boolean;
begin
  Result := False;
  if FStatus = tsSuspended then begin
    ResetEvent(FHaltEvent);
    SetEvent(FRunEvent);
    ResumeThread(FHandle);
    Result := True;
  end;
end;

function TBaseThread.FinishThread(AWaitTime: Int64): Boolean;
var xRes: Cardinal;
begin
  Result := FStatus = tsFinished;;
  if not Result then begin
    ResetEvent(FRunEvent);
    SetEvent(FHaltEvent);
    if FStatus = tsSuspended then begin
      ResumeThread(FHandle);
    end;
    xRes := WaitForSingleObject(FHandle, AWaitTime);
    if xRes = WAIT_OBJECT_0 then begin
      Result := True;
    end else if xRes = WAIT_TIMEOUT then begin
      Result := False;
    end else begin
      Result := False;
    end;
  end;
end;

function TBaseThreadList.AddThread(AThread: TBaseThread): Boolean;
begin
  Result := False;
  if not FIsActive then begin
    Result := FList.Add(AThread) >= 0;
  end;
end;

procedure TBaseThreadList.ClearThreads(AFreeAndNil: Boolean);
var xThread: TBaseThread;
begin
  if FIsActive then begin
    StopThreads;
  end;
  while (FList.Count <> 0) do begin
    xThread := TBaseThread(FList.Last);
    FList.Delete(FList.Count - 1);
    FreeAndNil(xThread);
  end;
end;

constructor TBaseThreadList.Create;
begin
  inherited Create;
  FList := TList.Create;
  FIsActive := False;
end;

destructor TBaseThreadList.Destroy;
begin
  if FIsActive then begin
    StopThreads;
  end;
  ClearThreads(True);
  FList.Free;
  inherited Destroy;
end;

function TBaseThreadList.RemoveThread(AThread: TBaseThread): Boolean;
var xIndex: Integer;
begin
  xIndex := FList.IndexOf(AThread);
  Result := xIndex >= 0;
  if Result then begin
    FList.Delete(xIndex);
  end;
end;

procedure TBaseThreadList.StartThreads;
var xCount: Integer;
begin
  FIsActive := True;
  for xCount := 0 to FList.Count - 1 do begin
    TBaseThread(FList.Items[xCount]).InitThread;
  end;
end;

procedure TBaseThreadList.StopThreads;
var xCount: Integer;
begin
  for xCount := 0 to FList.Count - 1 do begin
    TBaseThread(FList.Items[xCount]).FinishThread(INFINITE);
  end;
  FIsActive := False;
end;

procedure TLock.Reject;
begin
  SetEvent(FHaltEvent);
end;

procedure TLock.Release;
begin
  if GotOwnership = lsGranted then begin
    FOwnerId := 0;
    ReleaseMutex(FLockMutex);
  end;
end;

constructor TQueueEntry.Create(AMessage: TQueuedMessage);
begin
  inherited Create;
  FQueuedMessage := AMessage;
  FCreationTime := Now;
end;

procedure TMessageQueue.ClearMessages(ARemoveAge: Int64 = QUEUE_REMOVE_ALL);
var xLock: TLockState;
    xEntry: TQueueEntry;
    xMessage: TQueuedMessage;
    xCount: Integer;
    xRemove: Boolean;
begin
  xLock := FLock.Acquire(INFINITE);
  if xLock in [lsGranted, lsHalted] then begin
    try
      for xCount := FList.Count - 1 downto 0 do begin
        xEntry := TQueueEntry(FList.Items[xCount]);
        xMessage := xEntry.QueuedMessage;
        xRemove := (ARemoveAge = QUEUE_REMOVE_ALL);
        if not xRemove then begin
          xRemove := MilliSecondsBetween(Now, xEntry.FCreationTime) >= ARemoveAge;
        end;
        if xRemove then begin
          FList.Delete(FList.Count - 1);
          FHashList.Delete(FHashList.IndexOf(xMessage.Hash));
          FreeAndNil(xEntry);
          FreeAndNil(xMessage);
          WaitForSingleObject(FCountSemaphore, 0);
        end;
      end;
    finally
      if xLock = lsGranted then begin
        FLock.Release;
      end;
    end;
  end;
end;

constructor TMessageQueue.Create(AMaxSize: Integer = QUEUE_SIZE_UNLIMITED; AAutoCleanInterval: Integer = QUEUE_NO_AUTOCLEAN; AAutoRemoveAge: Int64 = 0);
begin
  inherited Create;
  FHashList := TStringList.Create;
  FHashList.Sorted := True;
  FHashList.Duplicates := dupAccept;
  FMaxQueueSize := AMaxSize;
  FLock := TLock.Create;
  FList := TList.Create;
  FCountSemaphore := CreateSemaphore(Nil, 0, FMaxQueueSize, Nil);
  if AAutoCleanInterval <> QUEUE_NO_AUTOCLEAN then begin
    FAutoCleaner := TQueueCleaner.Create(Self, AAutoCleanInterval, AAutoRemoveAge);
    FAutoCleaner.InitThread;
  end else begin
    FAutoCleaner := Nil;
  end;
end;

destructor TMessageQueue.Destroy;
begin
  if FAutoCleaner <> Nil then begin
    FAutoCleaner.FinishThread(INFINITE);
    FAutoCleaner.Free;
  end;
  ClearMessages;
  FHashList.Free;
  FList.Free;
  FLock.Free;
  CloseHandle(FCountSemaphore);
  inherited Destroy;
end;

function TMessageQueue.InsertMessage(AMessage: TQueuedMessage; AFirstToRemove: Boolean = False; AOnlyWhenNotExists: Boolean = False): Boolean;
begin
  Result := False;
  if FLock.Acquire(INFINITE) = lsGranted then begin
    try
      if (FMaxQueueSize = QUEUE_SIZE_UNLIMITED) or (FList.Count < FMaxQueueSize) then begin
        if (not AOnlyWhenNotExists) or (not IsMessageExists(AMessage)) then begin
          if AFirstToRemove then begin
            FList.Add(TQueueEntry.Create(AMessage));
          end else begin
            FList.Insert(0, TQueueEntry.Create(AMessage));
          end;
          FHashList.AddObject(AMessage.Hash, AMessage);
          Result := True;
        end;
      end;
    finally
      FLock.Release;
    end;
  end;
  if Result then begin
    ReleaseSemaphore(FCountSemaphore, 1, Nil);
  end;
end;

function TMessageQueue.IsMessageExists(AMessage: TQueuedMessage): Boolean;
begin
  Result := FHashList.IndexOf(AMessage.Hash) <> -1;
end;

function TMessageQueue.RemoveMessage: TQueuedMessage;
var xEntry: TQueueEntry;
begin
  Result := Nil;
  if FLock.Acquire(INFINITE) = lsGranted then begin
    try
      if FList.Count > 0 then begin
        xEntry := TQueueEntry(FList.Last);
        if xEntry <> Nil then begin
          Result := xEntry.QueuedMessage;
          FList.Remove(xEntry);
          FreeAndNil(xEntry);
          FHashList.Delete(FHashList.IndexOf(Result.Hash));
        end;
      end;
    finally
      FLock.Release;
    end;
  end;
end;

constructor TRemoveFromQueueWorker.Create(ASourceQueue: TMessageQueue);
begin
  inherited Create;
  FSourceQueue := ASourceQueue;
end;

function TRemoveFromQueueWorker.MainThreadProcedure: Cardinal;
var xHandles: array[0..1] of THandle;
    xRes: Cardinal;
    xMessage: TQueuedMessage;
begin
  Result := 0;
  xHandles[0] := HaltEvent;
  xHandles[1] := FSourceQueue.CountSemaphore;
  repeat
    xRes := WaitForMultipleObjects(2, @xHandles[0], False, INFINITE);
    if xRes = WAIT_OBJECT_0 + 1 then begin
      xMessage := FSourceQueue.RemoveMessage;
      if xMessage <> Nil then begin
        if not ProcessMessage(xMessage) then begin
          FSourceQueue.InsertMessage(xMessage)
        end;
      end;
    end;
  until (xRes <> WAIT_OBJECT_0 + 1);
end;

constructor TInsertToQueueWorker.Create(ADestQueue: TMessageQueue);
begin
  inherited Create;
  FDestQueue := ADestQueue;
end;

function TInsertToQueueWorker.MainThreadProcedure: Cardinal;
var xHandles: array[0..1] of THandle;
    xRes: Cardinal;
    xMessage: TQueuedMessage;
begin
  Result := 0;
  xHandles[0] := HaltEvent;
  xHandles[1] := RunEvent;
  repeat
    xRes := WaitForMultipleObjects(2, @xHandles[0], False, INFINITE);
    if xRes = WAIT_OBJECT_0 + 1 then begin
      xMessage := NeedMessage;
      if xMessage <> Nil then begin
        FDestQueue.InsertMessage(xMessage);
      end;
    end;
  until (xRes <> WAIT_OBJECT_0 + 1);
end;

constructor TMoveFromQueueToQueueWorker.Create(ASourceQueue, ADestQueue: TMessageQueue);
begin
  inherited Create(ASourceQueue);
  FDestQueue := ADestQueue;
end;

function TMoveFromQueueToQueueWorker.PrepareMessage(AMessage: TQueuedMessage; var ARemove: Boolean): TQueuedMessage;
begin
  Result := AMessage;
  ARemove := True;
end;

function TMoveFromQueueToQueueWorker.ProcessMessage(AMessage: TQueuedMessage): Boolean;
var xMessage: TQueuedMessage;
    xRemove: Boolean;
begin
  xMessage := PrepareMessage(AMessage, xRemove);
  Result := (xMessage <> Nil) or xRemove;
  if xMessage <> Nil then begin
    FDestQueue.InsertMessage(xMessage);
  end;
end;

destructor TQueueEntry.Destroy;
begin
  inherited Destroy;
end;

constructor TPoolEntry.Create(AIsAuto: Boolean; APoolObject: TPoolObject);
begin
  inherited Create;
  FIsAuto := AIsAuto;
  FPoolObject := APoolObject;
  FOwnerId := 0;
end;

destructor TPoolEntry.Destroy;
begin
  if FIsAuto then begin
    FreeAndNil(FPoolObject);
  end;
  inherited Destroy;
end;

constructor TPool.Create(AMaxPoolSize, AInitPoolSize: Integer);
begin
  inherited Create;
  FMaxPoolSize := AMaxPoolSize;
  FInitPoolSize := AInitPoolSize;
  FLock := TLock.Create;
  FList := TList.Create;
  FCountSemaphore := CreateSemaphore(Nil, 0, FMaxPoolSize, Nil);
  FHaltEvent := CreateEvent(Nil, True, True, Nil);
  FIsActive := False;
end;

destructor TPool.Destroy;
begin
  ClearPool;
  FList.Free;
  FLock.Free;
  CloseHandle(FCountSemaphore);
  CloseHandle(FHaltEvent);
  inherited Destroy;
end;

function TPool.RegisterPoolEntry(AObject: TPoolObject): TPoolEntry;
var xObject: TPoolObject;
    xIsAuto: Boolean;
    xInfo: String;
begin
  if AObject = Nil then begin
    xObject := FNeedPoolObject;
    xIsAuto := True;
    xInfo := 'Registered internal pool object';
  end else begin
    xObject := AObject;
    xIsAuto := False;
    xInfo := 'Registered external pool object';
  end;
  if xObject <> Nil then begin
    Result := TPoolEntry.Create(xIsAuto, xObject);
    FList.Add(Result);
    xInfo := xInfo + ' (current size=' + IntToStr(FList.Count) + ')';
  end else begin
    Result := Nil;
  end;
end;

procedure TPool.ClearPool;
var xLock: TLockState;
    xEntry: TPoolEntry;
begin
  xLock := FLock.Acquire(INFINITE);
  if xLock in [lsGranted, lsHalted] then begin
    try
      while (FList.Count <> 0) do begin
        xEntry := TPoolEntry(FList.Last);
        FList.Delete(FList.Count - 1);
        FreeAndNil(xEntry);
      end;
    finally
      if xLock = lsGranted then begin
        FLock.Release;
      end;
    end;
  end;
end;

function TPool.RegisterObject(AObject: TPoolObject): Boolean;
begin
  Result := FLock.Acquire(INFINITE) in [lsGranted, lsHalted];
  if Result then begin
    try
      if FList.Count < FMaxPoolSize then begin
        Result := RegisterPoolEntry(AObject) <> Nil;
      end;
    finally
      FLock.Release;
    end;
  end;
  if Result then begin
    ReleaseSemaphore(FCountSemaphore, 1, Nil);
  end;
end;

function TPool.UnregisterObject(AObject: TPoolObject): Boolean;
var xEntry: TPoolEntry;
begin
  Result := FLock.Acquire(INFINITE) in [lsGranted, lsHalted];
  if Result then begin
    try
      xEntry := FindEntry(AObject);
      if xEntry <> Nil then begin
        if (xEntry.FOwnerId = GetCurrentThreadId) or (xEntry.FOwnerId = 0) then begin
          FList.Remove(xEntry);
          FreeAndNil(xEntry);
        end;
      end;
    finally
      FLock.Release;
    end;
  end;
  if Result then begin
    WaitForSingleObject(FCountSemaphore, 0);
  end;
end;

function TPool.FindEntry(AObject: TPoolObject): TPoolEntry;
var xCount: Integer;
    xEntry: TPoolEntry;
begin
  xCount := 0;
  Result := Nil;
  while (xCount <= FList.Count - 1) and (Result = Nil) do begin
    xEntry := TPoolEntry(FList.Items[xCount]);
    if xEntry.FPoolObject = AObject then begin
      Result := xEntry;
    end else begin
      Inc(xCount);
    end;
  end;
end;

function TPool.AcquireObject(AWaitForIdle: Int64): TPoolObject;
var xEntry: TPoolEntry;
    xHandles: array[0..1] of THandle;
    xRes: Cardinal;
begin
  Result := Nil;
  xHandles[0] := FHaltEvent;
  xHandles[1] := FCountSemaphore;
  xRes := WaitForMultipleObjects(2, @xHandles[0], False, AWaitForIdle);
  if (xRes = WAIT_OBJECT_0 + 1) or (xRes = WAIT_TIMEOUT) then begin
    if FLock.Acquire(INFINITE) = lsGranted then begin
      try
        if xRes = WAIT_TIMEOUT then begin
          xEntry := FirstIdle(True);
          if xEntry = Nil then begin
            if FList.Count < FMaxPoolSize then begin
              xEntry := RegisterPoolEntry(Nil);
              xEntry.OwnerId := GetCurrentThreadId;
            end else begin
              xEntry := Nil;
            end;
          end;
        end else begin
          xEntry := FirstIdle(True);
        end;
        if xEntry <> Nil then begin
          Result := xEntry.FPoolObject;
        end;
      finally
        FLock.Release;
      end;
    end;
  end;
end;

function TPool.ReleaseObject(AObject: TPoolObject): Boolean;
var xEntry: TPoolEntry;
begin
  Result := False;
  if FLock.Acquire(INFINITE) = lsGranted then begin
    try
      xEntry := FindEntry(AObject);
      if xEntry <> Nil then begin
        if xEntry.FOwnerId = GetCurrentThreadId then begin
          Result := True;
          xEntry.FOwnerId := 0;
        end;
      end;
    finally
      FLock.Release;
    end;
  end;
  if Result then begin
    ReleaseSemaphore(FCountSemaphore, 1, Nil);
  end;
end;

function TPool.FirstIdle(AAutoOwn: Boolean): TPoolEntry;
var xCount: Integer;
    xEntry: TPoolEntry;
begin
  xCount := 0;
  Result := Nil;
  while (xCount <= FList.Count - 1) and (Result = Nil) do begin
    xEntry := TPoolEntry(FList.Items[xCount]);
    if (xEntry.FOwnerId = 0) or (xEntry.FOwnerId = GetCurrentThreadId) then begin
      Result := xEntry;
      if AAutoOwn then begin
        Result.FOwnerId := GetCurrentThreadId;
      end;
    end else begin
      Inc(xCount);
    end;
  end;
end;

procedure TPool.ActivatePool;
var xCount: Integer;
begin
  if not FIsActive then begin
    for xCount := 1 to FInitPoolSize do begin
      RegisterPoolEntry(Nil);
    end;
    ResetEvent(FHaltEvent);
    FIsActive := True;
  end;
end;

procedure TPool.DeactivatePool;
begin
  if FIsActive then begin
    SetEvent(FHaltEvent);
    FIsActive := False;
  end;
end;

constructor TQueueCleaner.Create(AQueue: TMessageQueue; AInterval, ARemoveAge: Int64);
begin
  inherited Create;
  FQueue := AQueue;
  FInterval := AInterval;
  FRemoveAge := ARemoveAge;
end;

function TQueueCleaner.MainThreadProcedure: Cardinal;
var xRes: Cardinal;
begin
  Result := 0;
  repeat
    xRes := WaitForSingleObject(HaltEvent, FInterval);
    if xRes = WAIT_TIMEOUT then begin
      FQueue.ClearMessages(FRemoveAge);
    end;
  until (xRes = WAIT_OBJECT_0);
end;

procedure TBaseThread.CancelThread;
begin
  FIsCancelled := True;
  ResetEvent(FRunEvent);
  SetEvent(FHaltEvent);
end;

procedure TBaseThread.ThreadFinished;
begin
end;

end.
