unit CDatatools;

interface

uses Windows, SysUtils, Classes;

type
  TBackupHeader = record
    hSize: Byte;
    archiveType: String[3];
    versionMS: DWORD;
    versionLS: DWORD;
    datetime: TDateTime;
    cSize: Int64;
    uSize: Int64;
  end;

function CreateDatabase(AFilename: String; var AError: String): Boolean;
function CompactDatabase(AFilename: String; var AError: String): Boolean;
function BackupDatabase(AFilename, ATargetFilename: String; var AError: String): Boolean;
function RestoreDatabase(AFilename, ATargetFilename: String; var AError: String): Boolean;
function CheckDatabase(AFilename: String; var AError: String): Boolean;
function FileVersion(AName: string): String;
function FileNumbers(AName: String; var AMS, ALS: DWORD): Boolean;

implementation

uses Variants, ComObj, CConsts, CWaitFormUnit, ZLib;

type
  TBackupRestore = class(TObject)
  private
    FInStream: TStream;
    FOutStream: TStream;
    procedure OnProgress(ASender: TObject);
  public
    function Compress(AInStream, AOutStream: TStream; var AError: String): Boolean;
    function Decompress(AInStream, AOutStream: TStream; var AError: String): Boolean;
    function ReadInfo(AInStream: TStream; var AHeader: TBackupHeader; var AError: String): Boolean;
    function CompressFile(AInFile, AOutFile: String; var AError: String): Boolean;
    function DecompressFile(AInFile, AOutFile: String; var AError: String): Boolean;
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
  ShowWaitForm(wtAnimate, 'Trwa kompaktowanie pliku danych. Proszê czekaæ...');
  try
    try
      xCompactedFilename := IncludeTrailingPathDelimiter(ExtractFilePath(AFilename)) + FormatDateTime('yyyymmddhhnnss', Now) + '.dat';
      xTempbackupFilename := ChangeFileExt(xCompactedFilename, '.bak');
      if FileExists(xCompactedFilename) then begin
        DeleteFile(xCompactedFilename);
      end;
      if FileExists(xTempbackupFilename) then begin
        DeleteFile(xTempbackupFilename);
      end;
      xJetEngine := CreateOleObject('JRO.JetEngine');
      xJetEngine.CompactDatabase(Format(CCompactDatabaseString, [AFilename]), Format(CCompactDatabaseString, [xCompactedFilename]));
      if RenameFile(AFilename, xTempbackupFilename) then begin
        if RenameFile(xCompactedFilename, AFilename) then begin
          DeleteFile(xTempbackupFilename);
          Result := True;
        end else begin
          RenameFile(xTempbackupFilename, AFilename);
        end;
      end else begin
      end;
    except
      on E: Exception do begin
        AError := E.Message;
      end;
    end
  finally
    xJetEngine := Unassigned;
  end;
  HideWaitForm;
end;

function BackupDatabase(AFilename, ATargetFilename: String; var AError: String): Boolean;
var xTool: TBackupRestore;
begin
  xTool := TBackupRestore.Create;
  try
    Result := xTool.CompressFile(AFilename, ATargetFilename, AError);
  finally
    xTool.Free;
  end;
end;

function RestoreDatabase(AFilename, ATargetFilename: String; var AError: String): Boolean;
var xTool: TBackupRestore;
begin
  xTool := TBackupRestore.Create;
  try
    Result := xTool.DecompressFile(AFilename, ATargetFilename, AError);
  finally
    xTool.Free;
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
  xToolStream := TCompressionStream.Create(clMax, AOutStream);
  xToolStream.OnProgress := OnProgress;
  AInStream.Seek(0, soFromBeginning);
  try
    try
      xToolStream.CopyFrom(AInStream, AInStream.Size);
      with xHead do begin
        hSize := SizeOf(TBackupHeader);
        archiveType := ARCHIVE_TYPE;
        FileNumbers(ParamStr(0), versionMS, versionLS);
        datetime := Now;
        uSize := FInStream.Size;
        cSize := FOutStream.Size;
      end;
      xToolStream.WriteBuffer(xHead, SizeOf(TBackupHeader));
      Result := True;
    except
      on E: Exception do begin
        AError := E.Message;
      end;
    end;
  finally
    xToolStream.Free;
  end;
end;

function TBackupRestore.CompressFile(AInFile, AOutFile: String; var AError: String): Boolean;
var xInStream, xOutStream: TFileStream;
begin
  Result := False;
  if FileExists(AInFile) then begin
    if not FileExists(AOutFile) then begin
      xInStream := TFileStream.Create(AInFile, fmOpenRead or fmShareExclusive);
      xOutStream := TFileStream.Create(AOutFile, fmCreate or fmShareExclusive);
      Result := Compress(xInStream, xOutStream, AError);
      xInStream.Free;
      xOutStream.Free;
    end else begin
      AError := 'Plik ' + AInFile + ' ju¿ istnieje';
    end;
  end else begin
    AError := 'Nie mo¿na odnaleŸæ pliku ' + AInFile;
  end;
end;

function TBackupRestore.Decompress(AInStream, AOutStream: TStream; var AError: String): Boolean;
var xToolStream: TDecompressionStream;
    xHeader: TBackupHeader;
begin
  Result := ReadInfo(AInStream, xHeader, AError);
  if Result then begin
    FInStream := AInStream;
    FOutStream := AOutStream;
    xToolStream := TDecompressionStream.Create(AInStream);
    xToolStream.OnProgress := OnProgress;
    AInStream.Seek(0, soFromBeginning);
    try
      try
        AOutStream.CopyFrom(AInStream, AInStream.Size - SizeOf(TBackupHeader));
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

function TBackupRestore.DecompressFile(AInFile, AOutFile: String; var AError: String): Boolean;
var xInStream, xOutStream: TFileStream;
begin
  Result := False;
  if FileExists(AInFile) then begin
    if not FileExists(AOutFile) then begin
      xInStream := TFileStream.Create(AInFile, fmOpenRead or fmShareExclusive);
      xOutStream := TFileStream.Create(AOutFile, fmCreate or fmShareExclusive);
      Result := Decompress(xInStream, xOutStream, AError);
      xInStream.Free;
      xOutStream.Free;
    end else begin
      AError := 'Plik ' + AInFile + ' ju¿ istnieje';
    end;
  end else begin
    AError := 'Nie mo¿na odnaleŸæ pliku ' + AInFile;
  end;
end;

procedure TBackupRestore.OnProgress(ASender: TObject);
begin
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

function TBackupRestore.ReadInfo(AInStream: TStream; var AHeader: TBackupHeader; var AError: String): Boolean;
var xRead: Integer;
    xSizeOfHead: Integer;
begin
  Result := False;
  xSizeOfHead := SizeOf(TBackupHeader);
  AInStream.Position := AInStream.Size - xSizeOfHead;
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

end.
