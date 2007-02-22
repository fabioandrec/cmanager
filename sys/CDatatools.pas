unit CDatatools;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses Windows, SysUtils, Classes, Controls, ShellApi;

type
  TProgressEvent = procedure (AStepBy: Integer) of Object;

  TBackupHeader = packed record
    hSize: Byte;
    archiveType: array[1..3] of Char;
    versionMS: DWORD;
    versionLS: DWORD;
    datetime: TDateTime;
    cSize: Int64;
    uSize: Int64;
  end;

function CreateDatabase(AFilename: String; var AError: String): Boolean;
function CompactDatabase(AFilename: String; var AError: String): Boolean;
function BackupDatabase(AFilename, ATargetFilename: String; var AError: String; AOverwrite: Boolean; AProgressEvent: TProgressEvent = Nil): Boolean;
function RestoreDatabase(AFilename, ATargetFilename: String; var AError: String; AOverwrite: Boolean; AProgressEvent: TProgressEvent = Nil): Boolean;
function GetDefaultBackupFilename(ADatabaseName: String): String;
function CheckDatabase(AFilename: String; var AError: String; var AReport: TStringList; AProgressEvent: TProgressEvent = Nil): Boolean;
function CheckPendingInformations: Boolean;
procedure CheckForUpdates(AQuiet: Boolean);
function CheckDatabaseStructure(AFrom, ATo: Integer; var xError: String): Boolean;

implementation

uses Variants, ComObj, CConsts, CWaitFormUnit, ZLib, CProgressFormUnit,
  CDatabase, CDataObjects, CInfoFormUnit, CStartupInfoFormUnit, Forms,
  CTools;

type
  TBackupRestore = class(TObject)
  private
    FInStream: TStream;
    FOutStream: TStream;
    FProgressEvent: TProgressEvent;
    FOverwrite: Boolean;
    procedure OnCompressProgress(ASender: TObject);
    procedure OnDecompressProgress(ASender: TObject);
  public
    function Compress(AInStream, AOutStream: TStream; var AError: String): Boolean;
    function Decompress(AInStream, AOutStream: TStream; var AError: String): Boolean;
    function ReadInfo(AInStream: TStream; var AHeader: TBackupHeader; var AError: String): Boolean;
    function CompressFile(AInFile, AOutFile: String; var AError: String): Boolean;
    function DecompressFile(AInFile, AOutFile: String; var AError: String): Boolean;
    constructor Create(AOverwrite: Boolean; AProgressEvent: TProgressEvent = Nil);
  end;

const ARCHIVE_TYPE = 'CMB';

function CreateDatabase(AFilename: String; var AError: String): Boolean;
var xCatalog : OLEVariant;
begin
  Result := False;
  try
    try
      xCatalog := CreateOleObject('ADOX.Catalog');
      xCatalog.Create(Format(CCreateDatabaseString, [AFilename]));
      Result := True;
    except
      on E: Exception do begin
        AError := E.Message;
      end;
    end
  finally
    xCatalog := Unassigned;
  end;
end;

function CompactDatabase(AFilename: String; var AError: String): Boolean;
var xJetEngine: OLEVariant;
    xCompactedFilename: String;
    xTempbackupFilename: String;
begin
  Result := False;
  xCompactedFilename := IncludeTrailingPathDelimiter(ExtractFilePath(AFilename)) + FormatDateTime('yyyymmddhhnnss', Now) + '.dat';
  xTempbackupFilename := ChangeFileExt(xCompactedFilename, '.bak');
  if FileExists(xCompactedFilename) then begin
    DeleteFile(xCompactedFilename);
  end;
  if FileExists(xTempbackupFilename) then begin
    DeleteFile(xTempbackupFilename);
  end;
  try
    try
      xJetEngine := CreateOleObject('JRO.JetEngine');
      xJetEngine.CompactDatabase(Format(CCompactDatabaseString, [AFilename]), Format(CCompactDatabaseString, [xCompactedFilename]));
    except
      on E: Exception do begin
        AError := E.Message;
      end;
    end
  finally
    xJetEngine := Unassigned;
    if RenameFile(AFilename, xTempbackupFilename) then begin
      if RenameFile(xCompactedFilename, AFilename) then begin
        DeleteFile(xTempbackupFilename);
        Result := True;
      end else begin
        RenameFile(xTempbackupFilename, AFilename);
      end;
    end;
  end;
end;

function BackupDatabase(AFilename, ATargetFilename: String; var AError: String; AOverwrite: Boolean; AProgressEvent: TProgressEvent = Nil): Boolean;
var xTool: TBackupRestore;
begin
  if not Assigned(AProgressEvent) then begin
    ShowWaitForm(wtProgressbar, 'Trwa wykonywanie kopii pliku danych. Proszê czekaæ...');
  end;
  xTool := TBackupRestore.Create(AOverwrite, AProgressEvent);
  try
    Result := xTool.CompressFile(AFilename, ATargetFilename, AError);
  finally
    xTool.Free;
  end;
  if not Assigned(AProgressEvent) then begin
    HideWaitForm;
  end;
end;

function RestoreDatabase(AFilename, ATargetFilename: String; var AError: String; AOverwrite: Boolean; AProgressEvent: TProgressEvent = Nil): Boolean;
var xTool: TBackupRestore;
begin
  if not Assigned(AProgressEvent) then begin
    ShowWaitForm(wtProgressbar, 'Trwa odtwarzanie kopii pliku danych. Proszê czekaæ...');
  end;
  xTool := TBackupRestore.Create(AOverwrite, AProgressEvent);
  try
    Result := xTool.DecompressFile(AFilename, ATargetFilename, AError);
  finally
    xTool.Free;
  end;
  if not Assigned(AProgressEvent) then begin
    HideWaitForm;
  end;
end;

function CheckDatabase(AFilename: String; var AError: String; var AReport: TStringList; AProgressEvent: TProgressEvent = Nil): Boolean;
var xError, xDesc: String;
    xAccounts: TDataObjectList;
    xAccount: TAccount;
    xStep, xCount: Integer;
    xSum: Currency;
    xSuspectedCount: Integer;
begin
  xSuspectedCount := 0;
  Result := InitializeDataProvider(AFilename, xError, xDesc, False);
  if Result then begin
    GDataProvider.BeginTransaction;
    xAccounts := TAccount.GetList(TAccount, AccountProxy, 'select * from account');
    if xAccounts.Count > 0 then begin
      xStep := Trunc(100 / xAccounts.Count);
      for xCount := 0 to xAccounts.Count - 1 do begin
        xAccount := TAccount(xAccounts.Items[xCount]);
        AReport.Add(FormatDateTime('hh:nn:ss', Now) + ' Sprawdzanie konta ' + xAccount.name);
        xSum := GDataProvider.GetSqlCurrency('select sum(cash) as cash from transactions where idAccount = ' + DataGidToDatabase(xAccount.id), 0);
        if xSum + xAccount.initialBalance <> xAccount.cash then begin
          AReport.Add(FormatDateTime('hh:nn:ss', Now) + ' Stan konta ' + xAccount.name +
                  Format(' wynosi %.2f, powinien wynosiæ %.2f', [xAccount.cash, xSum + xAccount.initialBalance]));
          xAccount.cash := xAccount.initialBalance + xSum;
          AReport.Add(FormatDateTime('hh:nn:ss', Now) + ' Zmodyfikowano stan konta ' + xAccount.name);
          inc(xSuspectedCount);
        end else begin
          AReport.Add(FormatDateTime('hh:nn:ss', Now) + ' Stan konta ' + xAccount.name + ' jest poprawny');
        end;
        AProgressEvent(xStep);
      end;
    end;
    xAccounts.Free;
    if Result then begin
      GDataProvider.CommitTransaction;
    end else begin
      GDataProvider.RollbackTransaction;
    end;
    GDataProvider.DisconnectFromDatabase;
    if xSuspectedCount = 0 then begin
      AReport.Add(FormatDateTime('hh:nn:ss', Now) + ' Nie znaleziono ¿adnych nieprawid³owoœci');
    end else begin
      AReport.Add(FormatDateTime('hh:nn:ss', Now) + Format(' Skorygowano %d nieprawid³owoœci', [xSuspectedCount]));
    end;
  end else begin
    AReport.Add(FormatDateTime('hh:nn:ss', Now) + ' ' + xError);
    AReport.Add(FormatDateTime('hh:nn:ss', Now) + ' ' + xDesc);
  end;
end;

function TBackupRestore.Compress(AInStream, AOutStream: TStream; var AError: String): Boolean;
var xToolStream: TCompressionStream;
    xHead: TBackupHeader;
begin
  Result := False;
  FInStream := AInStream;
  FOutStream := AOutStream;
  if AInStream.Size > 0 then begin
    xToolStream := TCompressionStream.Create(clMax, AOutStream);
    xToolStream.OnProgress := OnCompressProgress;
    AInStream.Seek(0, soFromBeginning);
    try
      try
        Result := xToolStream.CopyFrom(AInStream, 0) = AInStream.Size;
      except
        on E: Exception do begin
          AError := E.Message;
        end;
      end;
    finally
      xToolStream.Free;
    end;
  end else begin
    Result := True;
  end;
  if Result then begin
    with xHead do begin
      hSize := SizeOf(TBackupHeader);
      archiveType := ARCHIVE_TYPE;
      FileNumbers(ParamStr(0), versionMS, versionLS);
      datetime := Now;
      uSize := FInStream.Size;
      cSize := FOutStream.Size;
    end;
    Result := AOutStream.Write(xHead, SizeOf(TBackupHeader)) = xHead.hSize;
  end;
end;

function TBackupRestore.CompressFile(AInFile, AOutFile: String; var AError: String): Boolean;
var xInStream, xOutStream: TFileStream;
    xExists: Boolean;
begin
  Result := False;
  if FileExists(AInFile) then begin
    xExists := FileExists(AOutFile);
    if FOverwrite and xExists then begin
      xExists := not DeleteFile(AOutFile);
    end;
    if not xExists then begin
      xInStream := TFileStream.Create(AInFile, fmOpenRead or fmShareExclusive);
      xOutStream := TFileStream.Create(AOutFile, fmCreate or fmShareExclusive);
      Result := Compress(xInStream, xOutStream, AError);
      if not Result then begin
        DeleteFile(AOutFile);
      end;
      xInStream.Free;
      xOutStream.Free;
    end else begin
      AError := 'Plik ' + AOutFile + ' ju¿ istnieje';
    end;
  end else begin
    AError := 'Nie mo¿na odnaleŸæ pliku ' + AInFile;
  end;
end;

constructor TBackupRestore.Create(AOverwrite: Boolean; AProgressEvent: TProgressEvent);
begin
  inherited Create;
  FProgressEvent := AProgressEvent;
  FOverwrite := AOverwrite;
end;

function TBackupRestore.Decompress(AInStream, AOutStream: TStream; var AError: String): Boolean;
var xToolStream: TDecompressionStream;
    xHeader: TBackupHeader;
begin
  Result := ReadInfo(AInStream, xHeader, AError);
  if Result then begin
    FInStream := AInStream;
    FOutStream := AOutStream;
    if AInStream.Size > SizeOf(TBackupHeader) then begin
      xToolStream := TDecompressionStream.Create(AInStream);
      xToolStream.OnProgress := OnDecompressProgress;
      AInStream.Seek(0, soFromBeginning);
      try
        try
          AOutStream.CopyFrom(xToolStream, xHeader.uSize);
        except
          on E: Exception do begin
            AError := E.Message;
            Result := False;
          end;
        end;
      finally
        xToolStream.Free;
      end;
    end;
  end;
end;

function TBackupRestore.DecompressFile(AInFile, AOutFile: String; var AError: String): Boolean;
var xInStream, xOutStream: TFileStream;
    xExists: Boolean;
begin
  Result := False;
  if FileExists(AInFile) then begin
    xExists := FileExists(AOutFile);
    if FOverwrite and xExists then begin
      xExists := not DeleteFile(AOutFile);
    end;
    if not xExists then begin
      xInStream := TFileStream.Create(AInFile, fmOpenRead or fmShareExclusive);
      xOutStream := TFileStream.Create(AOutFile, fmCreate or fmShareExclusive);
      Result := Decompress(xInStream, xOutStream, AError);
      if not Result then begin
        DeleteFile(AOutFile);
      end;
      xInStream.Free;
      xOutStream.Free;
    end else begin
      AError := 'Plik ' + AInFile + ' ju¿ istnieje';
    end;
  end else begin
    AError := 'Nie mo¿na odnaleŸæ pliku ' + AInFile;
  end;
end;

procedure TBackupRestore.OnCompressProgress(ASender: TObject);
var xPosition: Integer;
begin
  xPosition := Round((FInStream.Position / FInStream.Size) * 100);
  if Assigned(FProgressEvent) then begin
    FProgressEvent(xPosition);
  end else begin
    PositionWaitForm(xPosition);
  end;
end;


procedure TBackupRestore.OnDecompressProgress(ASender: TObject);
var xPosition: Integer;
begin
  xPosition := Round((FInStream.Position / FInStream.Size) * 100);
  if Assigned(FProgressEvent) then begin
    FProgressEvent(xPosition);
  end else begin
    PositionWaitForm(xPosition);
  end;
end;

function TBackupRestore.ReadInfo(AInStream: TStream; var AHeader: TBackupHeader; var AError: String): Boolean;
var xRead: Integer;
    xSizeOfHead: Integer;
begin
  Result := False;
  xSizeOfHead := SizeOf(TBackupHeader);
  AInStream.Position := AInStream.Size - xSizeOfHead;
  FillChar(AHeader, xSizeOfHead, #0);
  try
    xRead := AInStream.Read(AHeader, xSizeOfHead);
    if xRead = xSizeOfHead then begin
      if (AHeader.hSize = xSizeOfHead) and (AHeader.archiveType = ARCHIVE_TYPE) then begin
        Result := True;
      end else begin
        AError := 'Niepoprawna zawartoœæ nag³ówka kopii';
      end;
    end else begin
      AError := 'Nie mo¿na odczytaæ nag³ówka kopii';
    end;
  except
    on E: Exception do begin
      AError := E.Message;
    end;
  end;
  AInStream.Seek(soFromBeginning, 0);
end;

function GetDefaultBackupFilename(ADatabaseName: String): String;
var xFilename: String;
begin
  xFilename := FormatDateTime('yymmdd_hhnnss', Now) + '.cmb';
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(ADatabaseName)) + xFilename;
end;

function CheckPendingInformations: Boolean;
var xInfo: TCStartupInfoForm;
begin
  xInfo := TCStartupInfoForm.Create(Nil);
  Result := xInfo.PrepareInfoFrame;
  if Result then begin
    Result := xInfo.ShowModal = mrOk;
  end;
  xInfo.Free;
end;

procedure CheckForUpdates(AQuiet: Boolean);
var xQuiet: String;
begin
  if AQuiet then begin
    xQuiet := '/quiet';
  end else begin
    xQuiet := '';
  end;
  ShellExecute(0, 'open', PChar('cupdate.exe'), PChar(xQuiet), '.', SW_SHOW)
end;

function CheckDatabaseStructure(AFrom, ATo: Integer; var xError: String): Boolean;
begin
  Result := True;
end;

end.
