unit CDatatools;

interface

function CreateDatabase(AFilename: String; var AError: String): Boolean;
function CompactDatabase(AFilename: String; var AError: String): Boolean;
function BackupDatabase(AFilename, ATargetFilename: String; var AError: String): Boolean;
function RestoreDatabase(AFilename, ATargetFilename: String; var AError: String): Boolean;
function CheckDatabase(AFilename: String; var AError: String): Boolean;

implementation

uses Variants, ComObj, SysUtils, CConsts, CWaitFormUnit;

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
begin
  Result := False;
end;

function RestoreDatabase(AFilename, ATargetFilename: String; var AError: String): Boolean;
begin
  Result := False;
end;

function CheckDatabase(AFilename: String; var AError: String): Boolean;
begin
  Result := False;
end;

end.
