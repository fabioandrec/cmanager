unit CBackups;

interface

uses Windows, Classes, ZLib, SysUtils, CTools;

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

function CmbBackup(AFilename: String; ABackupname: String; ACanoverride: Boolean; var AError: string; AProgressEvent: TProgressEvent): Boolean;
function CmbRestore(AFilename: String; ABackupname: String; ACanoverride: Boolean; var AError: string; AProgressEvent: TProgressEvent): Boolean;

implementation

function TBackupRestore.Compress(AInStream, AOutStream: TStream; var AError: String): Boolean;
var xToolStream: TCompressionStream;
    xHead: TBackupHeader;
begin
  Result := False;
  FInStream := AInStream;
  FOutStream := AOutStream;
  if AInStream.Size > 0 then begin
    xToolStream := TCompressionStream.Create(clMax, AOutStream);
    AInStream.Seek(0, soFromBeginning);
    xToolStream.OnProgress := OnCompressProgress;
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
    xWasError: Boolean;
begin
  Result := False;
  if FileExists(AInFile) then begin
    xExists := FileExists(AOutFile);
    if FOverwrite and xExists then begin
      xExists := not DeleteFile(AOutFile);
    end;
    if not xExists then begin
      xInStream := Nil;
      xOutStream := Nil;
      try
        xWasError := False;
        try
          xInStream := TFileStream.Create(AInFile, fmOpenRead or fmShareDenyNone);
        except
          on E: Exception do begin
            AError := E.Message;
            xWasError := True;
          end;
        end;
        try
          xOutStream := TFileStream.Create(AOutFile, fmCreate or fmShareDenyNone);
        except
          on E: Exception do begin
            AError := E.Message;
            xWasError := True;
          end;
        end;
        if not xWasError then begin
          Result := Compress(xInStream, xOutStream, AError);
        end;
        if not Result then begin
          DeleteFile(AOutFile);
        end;
      finally
        if xInStream <> Nil then begin
          xInStream.Free;
        end;
        if xOutStream <> Nil then begin
          xOutStream.Free;
        end;
      end;
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
      xInStream := TFileStream.Create(AInFile, fmOpenRead or fmShareDenyNone);
      xOutStream := TFileStream.Create(AOutFile, fmCreate or fmShareDenyNone);
      Result := Decompress(xInStream, xOutStream, AError);
      xInStream.Free;
      xOutStream.Free;
      if not Result then begin
        DeleteFile(AOutFile);
      end;
    end else begin
      AError := 'Plik ' + AOutFile + ' ju¿ istnieje';
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
  end;
end;


procedure TBackupRestore.OnDecompressProgress(ASender: TObject);
var xPosition: Integer;
begin
  xPosition := Round((FInStream.Position / FInStream.Size) * 100);
  if Assigned(FProgressEvent) then begin
    FProgressEvent(xPosition);
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

function CmbBackup(AFilename: String; ABackupname: String; ACanoverride: Boolean; var AError: string; AProgressEvent: TProgressEvent): Boolean;
var xBackup: TBackupRestore;
begin
  xBackup := TBackupRestore.Create(ACanoverride, AProgressEvent);
  Result := xBackup.CompressFile(AFilename, ABackupname, AError);
  xBackup.Free;
end;

function CmbRestore(AFilename: String; ABackupname: String; ACanoverride: Boolean; var AError: string; AProgressEvent: TProgressEvent): Boolean;
var xBackup: TBackupRestore;
begin
  xBackup := TBackupRestore.Create(ACanoverride, AProgressEvent);
  Result := xBackup.DecompressFile(ABackupname, AFilename, AError);
  xBackup.Free;
end;

end.
