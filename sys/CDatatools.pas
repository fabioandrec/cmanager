unit CDatatools;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses Windows, SysUtils, Classes;

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
function FileVersion(AName: string): String;
function FileNumbers(AName: String; var AMS, ALS: DWORD): Boolean;
function FileSize(AName: String): Int64;
function GetDefaultBackupFilename(ADatabaseName: String): String;

implementation

uses Variants, ComObj, CConsts, CWaitFormUnit, ZLib, CProgressFormUnit;

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

function CheckDatabase(AFilename: String; var AError: String): Boolean;
begin
  Result := False;
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

function FileVersion(AName: string): String;
var xProductVersionMS: DWORD;
    xProductVersionLS: DWORD;
begin
  FileNumbers(ParamStr(0), xProductVersionMS, xProductVersionLS);
  Result := IntToStr(HiWord(xProductVersionMS)) + '.' + IntToStr(LoWord(xProductVersionMS)) + '.' + IntToStr(HiWord(xProductVersionLS)) + '.' + IntToStr(LoWord(xProductVersionLS));
end;

function FileNumbers(AName: String; var AMS, ALS: DWORD): Boolean;
var xVersionBuffer: Pointer;
    xVersionSize, xDummy: DWord;
    xSize: Integer;
    xVSFixedFileInfo: PVSFixedFileInfo;
begin
  Result := False;
  AMS := 0;
  ALS := 0;
  xVersionSize := GetFileVersionInfoSize(PChar(AName), xDummy);
  if xVersionSize <> 0 then begin
    xSize := xVersionSize;
    GetMem(xVersionBuffer, xSize);
    try
      if GetFileVersionInfo(PChar(AName), xDummy, xVersionSize, xVersionBuffer) and VerQueryValue(xVersionBuffer, '', Pointer(xVSFixedFileInfo), xVersionSize) then begin
        AMS := xVSFixedFileInfo^.dwProductVersionMS;
        ALS := xVSFixedFileInfo^.dwProductVersionLS;
        Result := True;
      end;
    finally
      FreeMem(xVersionBuffer, xSize);
    end;
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

function FileSize(AName: String): Int64;
var xS: TSearchRec;
begin
  Result := 0;
  if FindFirst(AName, faAnyFile, xS) = 0 then begin
    Result := Int64(xS.FindData.nFileSizeHigh) shl Int64(32) + Int64(xS.FindData.nFileSizeLow);
  end;
  SysUtils.FindClose(xS);
end;

function GetDefaultBackupFilename(ADatabaseName: String): String;
var xFilename: String;
begin
  xFilename := FormatDateTime('yymmdd_hhnnss', Now) + '.cmb';
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(ADatabaseName)) + xFilename;
end;

end.
