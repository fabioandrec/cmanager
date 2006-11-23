unit CDatabase;

interface

uses Windows, Contnrs, SysUtils, AdoDb, ActiveX, Classes;

const
  CEmptyDataGid = '';
  CDefaultConnectionString = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s;Persist Security Info=False';
  CDefaultFilename = 'CManager.dat';

type
  TDataGid = ShortString;
  PDataGid = ^TDataGid;
  TDataCreationMode = (cmCreated, cmLoaded);
  TDataMemoryState = (msValid, msModified, msDeleted);
  TDataObject = class;
  TDataObjectClass = class of TDataObject;

  TDataProvider = class(TObject)
  private
    FLastError: String;
    FConnection: TADOConnection;
    FDataProxyList: TObjectList;
    function GetInTransaction: Boolean;
    function GetIsConnected: Boolean;
  public
    procedure ClearProxies(AForceClearStatic: Boolean);
    function PostProxies(AOnlyThisGid: TDataGid = ''): Boolean;
    constructor Create;
    destructor Destroy; override;
    function ConnectToDatabase(AConnectionString: String): Boolean;
    procedure DisconnectFromDatabase;
    procedure BeginTransaction;
    procedure RollbackTransaction;
    function CommitTransaction: Boolean;
    function ExecuteSql(ASql: String): Boolean;
    function OpenSql(ASql: String; AShowError: Boolean = True): TADOQuery;
    function GetSqlInteger(ASql: String; ADefault: Integer): Integer;
  published
    property DataProxyList: TObjectList read FDataProxyList;
    property InTransaction: Boolean read GetInTransaction;
    property IsConnected: Boolean read GetIsConnected;
    property LastError: String read FLastError;
  end;

  TDataObjectList = class(TObjectList)
  private
    function GetItems(AIndex: Integer): TDataObject;
    procedure SetItems(AIndex: Integer; const Value: TDataObject);
  public
    property Items[AIndex: Integer]: TDataObject read GetItems write SetItems;
  end;

  TDataProxy = class(TObject)
  private
    FDataProvider: TDataProvider;
    FTableName: String;
    FDataObjects: TDataObjectList;
    FParentDataProxy: TDataProxy;
    function GetRootTableName: String;
  protected
    function InsertObjects(AOnlyThisGid: TDataGid = ''): Boolean;
    function UpdateObjects(AOnlyThisGid: TDataGid = ''): Boolean;
    function DeleteObjects(AOnlyThisGid: TDataGid = ''): Boolean;
    function GetLoadObjectDataset(AId: TDataGid): TADOQuery;
  public
    function FindInCache(AId: TDataGid): TDataObject;
    constructor Create(ADataProvider: TDataProvider; ATableName: String; AParentDataProxy: TDataProxy);
    procedure AddDataObject(ADataObject: TDataObject);
    procedure DelDataObject(ADataObject: TDataObject);
    destructor Destroy; override;
  published
    property DataProvider: TDataProvider read FDataProvider;
    property TableName: String read FTableName;
    property RootTableName: String read GetRootTableName;
    property ParentDataProxy: TDataProxy read FParentDataProxy;
    property DataObjects: TDataObjectList read FDataObjects;
  end;

  TDataField = class(TObject)
  private
    FName: String;
    FValue: String;
    FIsQuoted: Boolean;
    FTableName: String;
  public
    constructor Create(AName, AValue: String; AIsQuoted: Boolean; ATableName: String);
  published
    property Name: String read FName;
    property Value: String read FValue;
    property IsQuoted: Boolean read FIsQuoted;
    property TableName: String read FTableName;
  end;

  TDataFieldList = class(TObjectList)
  private
    function GetItems(AIndex: Integer): TDataField;
    procedure SetItems(AIndex: Integer; const Value: TDataField);
  public
    procedure AddField(AName: String; AValue: String; AIsQuoted: Boolean; ATableName: String);
    function GetInsertSql(AId: TDataGid; ATableName: String): String;
    function GetUpdateSql(AId: TDataGid; ATableName: String): String;
    function GetDeleteSql(AId: TDataGid; ATableName: String): String;
    property Items[AIndex: Integer]: TDataField read GetItems write SetItems;
  end;

  TDataObject = class(TObject)
  private
    Fid: TDataGid;
    Fcreated: TDateTime;
    Fmodified: TDateTime;
    FCreationMode: TDataCreationMode;
    FMemoryState: TDataMemoryState;
    FIsStatic: Boolean;
    FDataProxy: TDataProxy;
    FDataFieldList: TDataFieldList;
  protected
    procedure SetState(AState: TDataMemoryState);
    procedure SetMode(AMode: TDataCreationMode);
  public
    procedure DeleteObject; virtual;
    constructor Create(AStatic: Boolean); virtual;
    constructor CreateObject(ADataProxy: TDataProxy; AIsStatic: Boolean); virtual;
    class function LoadObject(ADataProxy: TDataProxy; AId: TDataGid; AIsStatic: Boolean): TDataObject;
    procedure ReloadObject;
    class function GetList(AClass: TDataObjectClass; ADataProxy: TDataProxy; ASql: String): TDataObjectList;
    destructor Destroy; override;
    procedure UpdateFieldList; virtual;
    procedure FromDataset(ADataset: TADOQuery); virtual;
    procedure ForceUpdate;
    procedure AfterPost; virtual;
    class function CanBeDeleted(AId: TDataGid): Boolean; virtual;
  published
    property id: TDataGid read FId;
    property created: TDateTime read Fcreated;
    property modified: TDateTime read Fmodified;
    property creationMode: TDataCreationMode read FCreationMode;
    property memoryState: TDataMemoryState read FMemoryState;
    property isStatic: Boolean read FIsStatic;
    property DataProxy: TDataProxy read FDataProxy;
    property DataFieldList: TDataFieldList read FDataFieldList;
  end;

  TTreeObjectList = class;

  TTreeObject = class(TObject)
  private
    FDataobject: TDataObject;
    FChildobjects: TTreeObjectList;
  public
    constructor Create;
    property Dataobject: TDataObject read FDataobject write FDataobject;
    property Childobjects: TTreeObjectList read FChildobjects write FChildobjects;
    destructor Destroy; override;
  end;

  TTreeObjectList = class(TObjectList)
  private
    function GetItems(AIndex: Integer): TTreeObject;
    procedure SetItems(AIndex: Integer; const Value: TTreeObject);
  public
    function FindDataId(ADataId: TDataGid; AList: TTreeObjectList): TTreeObject;
    property Items[AIndex: Integer]: TTreeObject read GetItems write SetItems;
  end;

  TSumElement = class(TObject)
  private
    Fid: TDataGid;
    Fname: String;
    FcashIn: Currency;
    FcashOut: Currency;
  public
    constructor Create;
  published
    property id: TDataGid read Fid write Fid;
    property name: String read Fname write Fname;
    property cashIn: Currency read FcashIn write FcashIn;
    property cashOut: Currency read FcashOut write FcashOut;
  end;

  TSumList = class(TObjectList)
  public
    function FindSumObject(AId: TDataGid; ACreate: Boolean): TSumElement;
  end;

var GDataProvider: TDataProvider;
    GWorkDate: TDateTime;
    GTodayCashIn: Currency;
    GTodayCashOut: Currency;
    GDatabaseName: String;

function InitializeDataProvider(ADatabaseName: String): Boolean;
function CurrencyToDatabase(ACurrency: Currency): String;
function CurrencyToString(ACurrency: Currency): String;
function DatetimeToDatabase(ADatetime: TDateTime; AWithTime: Boolean): String;
function DatabaseToDatetime(ADatetime: String): TDateTime;
function FileVersion(AName: string): String;
function GetStartQuarterOfTheYear(ADateTime: TDateTime): TDateTime;
function GetEndQuarterOfTheYear(ADateTime: TDateTime): TDateTime;
function GetQuarterOfTheYear(ADateTime: TDateTime): Integer;
function GetStartHalfOfTheYear(ADateTime: TDateTime): TDateTime;
function GetEndHalfOfTheYear(ADateTime: TDateTime): TDateTime;
function GetHalfOfTheYear(ADateTime: TDateTime): Integer;
function GetFormattedDate(ADate: TDateTime; AFormat: String): String;

function DataGidToDatabase(ADataGid: TDataGid): String;

implementation

uses CInfoFormUnit, DB, StrUtils, DateUtils, CBaseFrameUnit;

function FileVersion(AName: string): String;
var xProductVersionMS: DWORD;
    xProductVersionLS: DWORD;
    xVersionBuffer: Pointer;
    xVersionSize, xDummy: DWord;
    xSize: Integer;
    xVSFixedFileInfo: PVSFixedFileInfo;
begin
  xProductVersionLS := 0;
  xProductVersionMS := 0;
  xVersionSize := GetFileVersionInfoSize(PChar(AName), xDummy);
  if xVersionSize <> 0 then begin
    xSize := xVersionSize;
    GetMem(xVersionBuffer, xSize);
    try
      if GetFileVersionInfo(PChar(AName), xDummy, xVersionSize, xVersionBuffer) and VerQueryValue(xVersionBuffer, '', Pointer(xVSFixedFileInfo), xVersionSize) then begin
        xProductVersionMS := xVSFixedFileInfo^.dwProductVersionMS;
        xProductVersionLS := xVSFixedFileInfo^.dwProductVersionLS;
      end;
    finally
      FreeMem(xVersionBuffer, xSize);
    end;
  end;
  Result := IntToStr(HiWord(xProductVersionMS)) + '.' + IntToStr(LoWord(xProductVersionMS)) + '.' + IntToStr(HiWord(xProductVersionLS)) + '.' + IntToStr(LoWord(xProductVersionLS));
end;

function DataGidToDatabase(ADataGid: TDataGid): String;
begin
  Result := IfThen(ADataGid = CEmptyDataGid, 'Null', '''' + ADataGid + '''');
end;

function CurrencyToDatabase(ACurrency: Currency): String;
var xFormat: TFormatSettings;
begin
  GetLocaleFormatSettings(LOCALE_USER_DEFAULT, xFormat);
  xFormat.DecimalSeparator := '.';
  Result := CurrToStr(ACurrency, xFormat);
end;

function CurrencyToString(ACurrency: Currency): String;
begin
  Result := CurrToStrF(ACurrency, ffCurrency, 2);
end;

function DatetimeToDatabase(ADatetime: TDateTime; AWithTime: Boolean): String;
begin
  if ADatetime = 0 then begin
    Result := 'Null';
  end else begin
    if not AWithTime then begin
      Result := '#' + FormatDateTime('yyyy-mm-dd', ADatetime) + '#';
    end else begin
      Result := '#' + FormatDateTime('yyyy-mm-dd hh:nn:ss', ADatetime) + '#';
    end;
  end;
end;

function DatabaseToDatetime(ADatetime: String): TDateTime;
var xY, xM, xD: Word;
    xDs: String;
begin
  xDs := StringReplace(ADatetime, '''', '', [rfReplaceAll, rfIgnoreCase]);
  xDs := StringReplace(xDs, '-', '', [rfReplaceAll, rfIgnoreCase]);
  xDs := StringReplace(xDs, '#', '', [rfReplaceAll, rfIgnoreCase]);
  xY := StrToIntDef(Copy(xDs, 1, 4), 0);
  xM := StrToIntDef(Copy(xDs, 5, 2), 0);
  xD := StrToIntDef(Copy(xDs, 7, 2), 0);
  try
    Result := EncodeDate(xY, xM, xD);
  except
    Result := 0;
  end;
end;

function InitializeDataProvider(ADatabaseName: String): Boolean;
var xResStream: TResourceStream;
    xCommand: String;
    xDataset: TADOQuery;
begin
  xCommand := '';
  Result := FileExists(ADatabaseName);
  if not Result then begin
    try
      xResStream := TResourceStream.Create(HInstance, 'DBPATTERN', RT_RCDATA);
      xResStream.SaveToFile(ADatabaseName);
      xResStream.Free;
      xResStream := TResourceStream.Create(HInstance, 'SQLPATTERN', RT_RCDATA);
      SetLength(xCommand, xResStream.Size);
      CopyMemory(@xCommand[1], xResStream.Memory, xResStream.Size);
      xResStream.Free;
      Result := True;
    except
      on E: Exception do begin
        Result := False;
        ShowInfo(itError, 'Nie uda³o siê utworzyæ pliku danych. Kontynuacja nie jest mo¿liwa.', E.Message);
      end;
    end;
  end;
  if Result then begin
    Result := GDataProvider.ConnectToDatabase(Format(CDefaultConnectionString, [ADatabaseName]));
    if not Result then begin
      ShowInfo(itError, 'Nie uda³o siê otworzyæ pliku danych.', GDataProvider.LastError);
    end else begin
      if xCommand <> '' then begin
        Result := GDataProvider.ExecuteSql(xCommand) and
                  GDataProvider.ExecuteSql(Format('insert into cmanagerInfo (version, created) values (''%s'', %s)', [FileVersion(ParamStr(0)), DatetimeToDatabase(Now, True)]));
        if not Result then begin
          ShowInfo(itError, 'Nie uda³o siê utworzyæ schematu danych. Kontynuacja nie jest mo¿liwa.', GDataProvider.LastError);
          GDataProvider.DisconnectFromDatabase;
          DeleteFile(ADatabaseName);
        end else begin
          GDatabaseName := ADatabaseName;
        end;
      end else begin
        GDatabaseName := ADatabaseName;
        xDataset := GDataProvider.OpenSql('select * from cmanagerInfo', False);
        if xDataset = Nil then begin
          ShowInfo(itError, 'Wybrany plik nie jest poprawnym plikiem danych', '');
          GDataProvider.DisconnectFromDatabase;
          Result := False;
        end else begin
          xDataset.Free;
        end;
      end;
    end;
  end;
end;

procedure TDataProxy.AddDataObject(ADataObject: TDataObject);
begin
  FDataObjects.Add(ADataObject);
end;

constructor TDataProxy.Create(ADataProvider: TDataProvider; ATableName: String; AParentDataProxy: TDataProxy);
begin
  inherited Create;
  FDataProvider := ADataProvider;
  FTableName := ATableName;
  FParentDataProxy := AParentDataProxy;
  FDataObjects := TDataObjectList.Create(False);
  FDataProvider.DataProxyList.Add(Self);
end;

constructor TDataField.Create(AName, AValue: String; AIsQuoted: Boolean; ATableName: String);
begin
  inherited Create;
  FName := AName;
  FValue := AValue;
  FIsQuoted := AIsQuoted;
  FTableName := ATableName;
end;

procedure TDataFieldList.AddField(AName, AValue: String; AIsQuoted: Boolean; ATableName: String);
begin
  Add(TDataField.Create(AName, AValue, AIsQuoted, AnsiUpperCase(ATableName)));
end;

function TDataFieldList.GetDeleteSql(AId: TDataGid; ATableName: String): String;
begin
  Result := 'delete from ' + ATableName + ' where id' + ATableName + ' = ''' + AId + '''';
end;

function TDataFieldList.GetInsertSql(AId: TDataGid; ATableName: String): String;
var xCount: Integer;
    xTableName: String;
begin
  xTableName := AnsiUpperCase(ATableName);
  Result := 'insert into ' + ATableName + ' (';
  for xCount := 0 to Count - 1 do begin
    if (AnsiUpperCase(Items[xCount].TableName) = xTableName) then begin
      Result := Result + Items[xCount].Name + ', ';
    end;
  end;
  Result := Result + 'id' + ATableName + ') values (';
  for xCount := 0 to Count - 1 do begin
    if (Items[xCount].TableName = xTableName) then begin
      if Items[xCount].IsQuoted then begin
        Result := Result + '''' + Items[xCount].Value + ''', ';
      end else begin
        Result := Result + Items[xCount].Value + ', ';
      end;
    end;
  end;
  Result := Result + '''' + AId + ''')';
end;

function TDataFieldList.GetItems(AIndex: Integer): TDataField;
begin
  Result := TDataField(inherited Items[AIndex]);
end;

function TDataFieldList.GetUpdateSql(AId: TDataGid; ATableName: String): String;
var xCount: Integer;
    xTableName: String;
begin
  xTableName := AnsiUpperCase(ATableName);
  Result := 'update ' + ATableName + ' set ';
  for xCount := 0 to Count - 1 do begin
    if (Items[xCount].TableName = xTableName) then begin
     Result := Result + Items[xCount].Name + ' = ';
      if Items[xCount].IsQuoted then begin
        Result := Result + '''' + Items[xCount].Value + '''';
      end else begin
        Result := Result + Items[xCount].Value;
      end;
      Result := Result + ',';
    end;
  end;
  if Result[Length(Result)] = ',' then begin
    System.Delete(Result, Length(Result), 1);
  end;
  Result := Result + ' where id' + ATableName + ' = ''' + AId + '''';
end;

procedure TDataFieldList.SetItems(AIndex: Integer; const Value: TDataField);
begin
  inherited Items[AIndex] := Value;
end;

procedure TDataObject.AfterPost;
begin
end;

class function TDataObject.CanBeDeleted(AId: TDataGid): Boolean;
begin
  Result := True;
end;

constructor TDataObject.Create(AStatic: Boolean);
begin
  inherited Create;
  FCreationMode := cmCreated;
  FMemoryState := msValid;
  FDataFieldList := TDataFieldList.Create(True);
  Fcreated := Now;
  Fmodified := 0;
  FIsStatic := AStatic;
end;

constructor TDataObject.CreateObject(ADataProxy: TDataProxy; AIsStatic: Boolean);
var xGuid: TGUID;
begin
  Create(AIsStatic);
  FDataProxy := ADataProxy;
  CreateGUID(xGuid);
  Fid := GUIDToString(xGuid);
  DataProxy.AddDataObject(Self);
end;

procedure TDataObject.DeleteObject;
begin
  FMemoryState := msDeleted;
end;

destructor TDataObject.Destroy;
begin
  FDataProxy.DelDataObject(Self);
  FDataFieldList.Free;
  inherited Destroy;
end;

procedure TDataProxy.DelDataObject(ADataObject: TDataObject);
begin
  FDataObjects.Remove(ADataObject);
end;

function TDataProxy.DeleteObjects(AOnlyThisGid: TDataGid = ''): Boolean;
var xCount: Integer;
    xObj: TDataObject;
    xSql: String;
    xProxy: TDataProxy;
    xTableNames: TStringList;
    xCountSql: Integer;
begin
  Result := True;
  xCount := 0;
  while Result and (xCount <= FDataObjects.Count - 1) do begin
    xObj := FDataObjects.Items[xCount];
    if (xObj.CreationMode = cmLoaded) and (xObj.MemoryState = msDeleted) and ((AOnlyThisGid = '') or (AOnlyThisGid = xObj.id)) then begin
      xObj.UpdateFieldList;
      xTableNames := TStringList.Create;
      xProxy := Self;
      repeat
        xTableNames.Add(xProxy.TableName);
        xProxy := xProxy.ParentDataProxy;
      until (xProxy = Nil);
      xCountSql := 0;
      while Result and (xCountSql <= xTableNames.Count - 1) do begin
        xSql := xObj.DataFieldList.GetDeleteSql(xObj.Id, xTableNames.Strings[xCountSql]);
        Result := FDataProvider.ExecuteSql(xSql);
        Inc(xCountSql);
      end;
      xTableNames.Free;
    end;
    Inc(xCount);
  end;
end;

destructor TDataProxy.Destroy;
begin
  FDataProvider.DataProxyList.Remove(Self);
  FDataObjects.Free;
  inherited Destroy;
end;

procedure TDataProvider.BeginTransaction;
begin
  if not FConnection.InTransaction then begin
    FConnection.BeginTrans;
  end;
end;

procedure TDataProvider.ClearProxies(AForceClearStatic: Boolean);
var xCountP, xCountO: Integer;
    xList: TObjectList;
    xDataObject: TDataObject;
begin
  for xCountP := 0 to FDataProxyList.Count - 1 do begin
    xList := TDataProxy(FDataProxyList.Items[xCountP]).DataObjects;
    for xCountO := xList.Count - 1 downto 0 do begin
      xDataObject := TDataObject(xList.Items[xCountO]);
      if (not xDataObject.isStatic) or AForceClearStatic then begin
        xList.Delete(xCountO);
        xDataObject.Free;
      end;
    end;
  end;
end;

function TDataProvider.CommitTransaction: Boolean;
begin
  Result := PostProxies;
  if FConnection.InTransaction then begin
    if Result then begin
      FConnection.CommitTrans;
    end else begin
      FConnection.RollbackTrans;
    end;
  end;
  ClearProxies(False);
end;

function TDataProvider.ConnectToDatabase(AConnectionString: String): Boolean;
begin
  Result := True;
  if FConnection.Connected then begin
    FConnection.Close;
  end;
  FConnection.ConnectionString := AConnectionString;
  FConnection.LoginPrompt := False;
  FConnection.CursorLocation := clUseClient;
  try
    FConnection.Open;
  except
    on E: Exception do begin
      FLastError := E.Message;
      Result := False;
    end;
  end;
end;

constructor TDataProvider.Create;
begin
  inherited Create;
  FDataProxyList := TObjectList.Create(True);
  FConnection := TADOConnection.Create(Nil);
  FLastError := '';
end;

destructor TDataProvider.Destroy;
begin
  ClearProxies(True);
  FDataProxyList.Free;
  FConnection.Free;
  inherited Destroy;
end;

procedure TDataProvider.DisconnectFromDatabase;
begin
  FConnection.Connected := False;
end;

function TDataProvider.ExecuteSql(ASql: String): Boolean;
var xSqls: TStringList;
    xCount: Integer;
begin
  Result := True;
  xSqls := TStringList.Create;
  xSqls.Text := StringReplace(StringReplace(ASql, sLineBreak, '', [rfReplaceAll, rfIgnoreCase]), ';', sLineBreak, [rfReplaceAll, rfIgnoreCase]);
  xCount := 0;
  while Result and (xCount <= xSqls.Count - 1) do begin
    try
      FConnection.Execute(xSqls.Strings[xCount], cmdText, [eoExecuteNoRecords]);
    except
      on E: Exception do begin
        ShowInfo(itError, 'Podczas wykonywania komendy wyst¹pi³ b³¹d', E.Message);
        FLastError := E.Message;
        Result := False;
      end;
    end;
    Inc(xCount);
  end;
  xSqls.Free;
end;

function TDataProvider.GetInTransaction: Boolean;
begin
  Result := FConnection.InTransaction;
end;

function TDataProvider.GetIsConnected: Boolean;
begin
  Result := FConnection.Connected;
end;

function TDataProvider.GetSqlInteger(ASql: String; ADefault: Integer): Integer;
var xQ: TADOQuery;
begin
  Result := ADefault;
  xQ := OpenSql(ASql);
  if xQ <> Nil then begin
    if not xQ.IsEmpty then begin
      Result := xQ.Fields[0].AsInteger;
    end;
    xQ.Free;
  end;
end;

function TDataProvider.OpenSql(ASql: String; AShowError: Boolean = True): TADOQuery;
begin
  Result := TADOQuery.Create(Nil);
  try
    Result.Connection := FConnection;
    Result.SQL.Text := ASql;
    Result.Prepared := True;
    Result.Open
  except
    on E: Exception do begin
      if AShowError then begin
        ShowInfo(itError, 'Podczas wykonywania komendy wyst¹pi³ b³¹d', E.Message);
      end;
      FLastError := E.Message;
      FreeAndNil(Result);
    end;
  end;
end;

function TDataProvider.PostProxies(AOnlyThisGid: TDataGid = ''): Boolean;
var xCount: Integer;
    xProxy: TDataProxy;
begin
  Result := True;
  xCount := 0;
  while Result and (xCount <= FDataProxyList.Count - 1) do begin
    xProxy := TDataProxy(FDataProxyList.Items[xCount]);
    Result := xProxy.InsertObjects(AOnlyThisGid);
    Inc(xCount);
  end;
  xCount := 0;
  while Result and (xCount <= FDataProxyList.Count - 1) do begin
    xProxy := TDataProxy(FDataProxyList.Items[xCount]);
    Result := xProxy.UpdateObjects(AOnlyThisGid);
    Inc(xCount);
  end;
  xCount := 0;
  while Result and (xCount <= FDataProxyList.Count - 1) do begin
    xProxy := TDataProxy(FDataProxyList.Items[xCount]);
    Result := xProxy.DeleteObjects(AOnlyThisGid);
    Inc(xCount);
  end;
end;

procedure TDataProvider.RollbackTransaction;
begin
  if FConnection.InTransaction then begin
    FConnection.RollbackTrans;
  end;
  ClearProxies(False);
end;

function TDataProxy.FindInCache(AId: TDataGid): TDataObject;
var xCount: Integer;
begin
  Result := Nil;
  xCount := 0;
  while (xCount <= FDataObjects.Count - 1) and (Result = Nil) do begin
    if FDataObjects.Items[xCount].Id = AId then begin
      Result := FDataObjects.Items[xCount];
    end;
    Inc(xCount);
  end;
end;

function TDataProxy.GetLoadObjectDataset(AId: TDataGid): TADOQuery;
var xSelect: String;
    xWhere: String;
    xProxy: TDataProxy;
begin
  xSelect := FTableName;
  xWhere := FTableName + '.id' + FTableName + ' = ''' + AId + '''';
  xProxy := FParentDataProxy;
  while (xProxy <> Nil) do begin
    xSelect := xSelect + ', ' + xProxy.TableName;
    xWhere := xWhere + ' and ' + xProxy.TableName + '.id' + xProxy.TableName + ' = ''' + AId + '''';
    xProxy := xProxy.ParentDataProxy;
  end;
  Result := DataProvider.OpenSql('select * from ' + xSelect + ' where ' + xWhere);
end;

function TDataProxy.GetRootTableName: String;
var xDataProxy: TDataProxy;
begin
  xDataProxy := Self;
  repeat
    Result := xDataProxy.TableName;
    xDataProxy := xDataProxy.ParentDataProxy;
  until (xDataProxy = Nil);
end;

function TDataProxy.InsertObjects(AOnlyThisGid: TDataGid = ''): Boolean;
var xCount: Integer;
    xObj: TDataObject;
    xSql: String;
    xProxy: TDataProxy;
    xTableNames: TStringList;
    xCountSql: Integer;
begin
  Result := True;
  xCount := 0;
  while Result and (xCount <= FDataObjects.Count - 1) do begin
    xObj := FDataObjects.Items[xCount];
    if (xObj.CreationMode = cmCreated) and (xObj.MemoryState <> msDeleted) and ((AOnlyThisGid = '') or (AOnlyThisGid = xObj.id)) then begin
      xObj.UpdateFieldList;
      xTableNames := TStringList.Create;
      xProxy := Self;
      repeat
        xTableNames.Add(xProxy.TableName);
        xProxy := xProxy.ParentDataProxy;
      until (xProxy = Nil);
      xCountSql := xTableNames.Count - 1;
      while Result and (xCountSql >= 0) do begin
        xSql := xObj.DataFieldList.GetInsertSql(xObj.Id, xTableNames.Strings[xCountSql]);
        Result := FDataProvider.ExecuteSql(xSql);
        if Result then begin
          xObj.AfterPost;
        end;
        Dec(xCountSql);
      end;
      xTableNames.Free;
      xObj.SetMode(cmLoaded);
    end;
    Inc(xCount);
  end;
end;

function TDataProxy.UpdateObjects(AOnlyThisGid: TDataGid = ''): Boolean;
var xCount: Integer;
    xObj: TDataObject;
    xSql: String;
    xProxy: TDataProxy;
    xTableNames: TStringList;
    xCountSql: Integer;
begin
  Result := True;
  xCount := 0;
  while Result and (xCount <= FDataObjects.Count - 1) do begin
    xObj := FDataObjects.Items[xCount];
    if (xObj.CreationMode = cmLoaded) and (xObj.MemoryState = msModified) and ((AOnlyThisGid = '') or (AOnlyThisGid = xObj.id)) then begin
      xObj.UpdateFieldList;
      xTableNames := TStringList.Create;
      xProxy := Self;
      repeat
        xTableNames.Add(xProxy.TableName);
        xProxy := xProxy.ParentDataProxy;
      until (xProxy = Nil);
      xCountSql := xTableNames.Count - 1;
      while Result and (xCountSql >= 0) do begin
        xSql := xObj.DataFieldList.GetUpdateSql(xObj.Id, xTableNames.Strings[xCountSql]);
        Result := FDataProvider.ExecuteSql(xSql);
        if Result then begin
          xObj.AfterPost;
        end;
        Dec(xCountSql);
      end;
      xTableNames.Free;
    end;
    Inc(xCount);
  end;
end;

procedure TDataObject.ForceUpdate;
begin
  FDataProxy.DataProvider.PostProxies(Fid);
end;

procedure TDataObject.FromDataset(ADataset: TADOQuery);
begin
  FMemoryState := msValid;
  FCreationMode := cmLoaded;
  with ADataset do begin
    Fid := FieldByName('id' + FDataProxy.TableName).AsString;
    Fcreated := FieldByName('created').AsDateTime;
    Fmodified := FieldByName('modified').AsDateTime;
  end;
end;

class function TDataObject.GetList(AClass: TDataObjectClass; ADataProxy: TDataProxy; ASql: String): TDataObjectList;
var xDataset: TADOQuery;
    xObj: TDataObject;
begin
  Result := TDataObjectList.Create(True);
  xDataset := ADataProxy.DataProvider.OpenSql(ASql);
  while not xDataset.Eof do begin
    xObj := AClass.CreateObject(ADataProxy, True);
    xObj.FromDataset(xDataset);
    Result.Add(xObj);
    xDataset.Next;
  end;
  xDataset.Free;
end;

class function TDataObject.LoadObject(ADataProxy: TDataProxy; AId: TDataGid; AIsStatic: Boolean): TDataObject;
var xDataset: TADOQuery;
begin
  xDataset := ADataProxy.GetLoadObjectDataset(AId);
  Result := CreateObject(ADataProxy, AIsStatic);
  Result.FromDataset(xDataset);
  xDataset.Free;
end;

procedure TDataObject.ReloadObject;
var xDataset: TADOQuery;
begin
  xDataset := FDataProxy.GetLoadObjectDataset(id);
  FromDataset(xDataset);
  xDataset.Free;
end;

procedure TDataObject.SetMode(AMode: TDataCreationMode);
begin
  FCreationMode := AMode;
  SetState(msValid);
end;

procedure TDataObject.SetState(AState: TDataMemoryState);
begin
  if FMemoryState <> AState then begin
    FModified := Now;
    FMemoryState := AState;
  end;
end;

procedure TDataObject.UpdateFieldList;
begin
  with FDataFieldList do begin
    Clear;
    AddField('created', DatetimeToDatabase(Fcreated, True), False, FDataProxy.GetRootTableName);
    AddField('modified', DatetimeToDatabase(Fmodified, True), False, FDataProxy.GetRootTableName);
  end;
end;

function TDataObjectList.GetItems(AIndex: Integer): TDataObject;
begin
  Result := TDataObject(inherited Items[AIndex]);
end;

procedure TDataObjectList.SetItems(AIndex: Integer; const Value: TDataObject);
begin
  inherited Items[AIndex] := Value;
end;

constructor TTreeObject.Create;
begin
  inherited Create;
  FChildobjects := TTreeObjectList.Create(True);
end;

destructor TTreeObject.Destroy;
begin
  FChildobjects.Free;
  inherited Destroy;
end;

function TTreeObjectList.FindDataId(ADataId: TDataGid; AList: TTreeObjectList): TTreeObject;
var xCount: Integer;
begin
  Result := Nil;
  xCount := 0;
  while (Result = Nil) and (xCount <= AList.Count - 1) do begin
    if AList.Items[xCount].Dataobject.id = ADataId then begin
      Result := AList.Items[xCount];
    end else begin
      Inc(xCount);
    end;
  end;
  xCount := 0;
  while (Result = Nil) and (xCount <= AList.Count - 1) do begin
    Result := FindDataId(ADataId, AList.Items[xCount].Childobjects);
    Inc(xCount);
  end;
end;

function TTreeObjectList.GetItems(AIndex: Integer): TTreeObject;
begin
  Result := TTreeObject(inherited Items[AIndex]);
end;

procedure TTreeObjectList.SetItems(AIndex: Integer; const Value: TTreeObject);
begin
  inherited Items[AIndex] := Value;
end;

constructor TSumElement.Create;
begin
  inherited Create;
  Fid := '';
  Fname := '';
  FcashIn := 0;
  FcashOut := 0;
end;

function TSumList.FindSumObject(AId: TDataGid; ACreate: Boolean): TSumElement;
var xCount: Integer;
begin
  Result := Nil;
  xCount := 0;
  while (xCount <= Count - 1) and (Result = Nil) do begin
    if TSumElement(Items[xCount]).id = AId then begin
      Result := TSumElement(Items[xCount]);
    end;
    Inc(xCount);
  end;
  if (Result = Nil) and ACreate then begin
    Result := TSumElement.Create;
    Add(Result);
  end;
end;

function GetStartQuarterOfTheYear(ADateTime: TDateTime): TDateTime;
var xQuarter: Integer;
begin
  xQuarter := GetQuarterOfTheYear(ADateTime);
  Result := EncodeDate(YearOf(ADateTime), (xQuarter - 1) * 3 + 1, 1);
end;

function GetEndQuarterOfTheYear(ADateTime: TDateTime): TDateTime;
var xQuarter: Integer;
begin
  xQuarter := GetQuarterOfTheYear(ADateTime);
  Result := EncodeDate(YearOf(ADateTime), xQuarter * 3, DayOf(EndOfAMonth(YearOf(ADateTime), xQuarter * 3)));
end;

function GetQuarterOfTheYear(ADateTime: TDateTime): Integer;
var xMonth: Integer;
begin
  xMonth := MonthOf(ADateTime);
  Result := ((xMonth - 1) div 3) + 1;
end;

function GetStartHalfOfTheYear(ADateTime: TDateTime): TDateTime;
var xHalf: Integer;
begin
  xHalf := GetHalfOfTheYear(ADateTime);
  Result := EncodeDate(YearOf(ADateTime), (xHalf - 1) * 6 + 1, 1);
end;

function GetEndHalfOfTheYear(ADateTime: TDateTime): TDateTime;
var xHalf: Integer;
begin
  xHalf := GetHalfOfTheYear(ADateTime);
  Result := EncodeDate(YearOf(ADateTime), xHalf * 6, DayOf(EndOfAMonth(YearOf(ADateTime), xHalf * 6)));
end;

function GetHalfOfTheYear(ADateTime: TDateTime): Integer;
var xMonth: Integer;
begin
  xMonth := MonthOf(ADateTime);
  Result := ((xMonth - 1) div 6) + 1;
end;

function GetFormattedDate(ADate: TDateTime; AFormat: String): String;
var xTime: TSystemTime;
    xRes: PChar;
begin
  GetMem(xRes, $FF);
  DateTimeToSystemTime(ADate, xTime);
  if GetDateFormat(GetThreadLocale, 0, @xTime, PChar(AFormat), xRes, $FF) <> 0 then begin
    Result := String(xRes);
  end;
  FreeMem(xRes);
end;

procedure SaveToLog(AFile, AText: String);


initialization
  CoInitialize(Nil);
  GDataProvider := TDataProvider.Create;
  GWorkDate := Today;
  GTodayCashIn := 0;
  GTodayCashOut := 0;
finalization
  GDataProvider.Free;
  CoUninitialize;
end.
