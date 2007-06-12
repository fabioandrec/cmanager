unit CAdox;

interface

uses ShellApi, SysUtils, Classes, ComObj, Variants;

function CreateDatabase(AFilename: String; var AError: String): Boolean;
function CreateExcelFile(AFilename: String; var AError: String): OleVariant;
function CompactDatabase(AFilename: String; var AError: String): Boolean;

implementation

const
  CCreateDatabaseString = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s';
  CCompactDatabaseString = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s';
  CCreateExcelFile = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s;Extended Properties="Excel 8.0"';

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

function CreateExcelFile(AFilename: String; var AError: String): OleVariant;
begin
  VarClear(Result);
  try
    try
      Result := CreateOleObject('ADOX.Catalog');
      Result.ActiveConnection := Format(CCreateExcelFile, [AFilename]);
    except
      on E: Exception do begin
        AError := E.Message;
        Result := Unassigned;
      end;
    end
  finally
  end;
end;

function CompactDatabase(AFilename: String; var AError: String): Boolean;
var xJetEngine: OLEVariant;
    xCompactedFilename: String;
    xTempbackupFilename: String;
begin
  Result := False;
  xCompactedFilename := IncludeTrailingPathDelimiter(ExtractFilePath(ExpandFileName(AFilename))) + FormatDateTime('yyyymmddhhnnss', Now) + '.dat';
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

end.
