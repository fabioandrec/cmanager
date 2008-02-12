unit CAdox;

interface

uses ShellApi, SysUtils, Classes, ComObj, Variants;

function CreateDatabase(AFilename: String; APassword: String; var AError: String): Boolean;
function CreateExcelFile(AFilename: String; var AError: String): OleVariant;
function CompactDatabase(AFilename: String; APassword: String; var AError: String): Boolean;
function ChangeDatabasePassword(AFilename: String; APassword, ANewPassword: String; var AError: String): Boolean;

implementation

const
  CConnectionString = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s';
  CConnectionStringWithPass = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s;Jet OLEDB:Database Password=%s';
  CCreateExcelFile = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s;Extended Properties="Excel 8.0"';

function CreateDatabase(AFilename: String; APassword: String; var AError: String): Boolean;
var xCatalog : OLEVariant;
    xConnectionString: String;
begin
  Result := False;
  try
    try
      xCatalog := CreateOleObject('ADOX.Catalog');
      if APassword = '' then begin
        xConnectionString := Format(CConnectionString, [AFilename]);
      end else begin
        xConnectionString := Format(CConnectionStringWithPass, [AFilename, APassword]);
      end;
      xCatalog.Create(xConnectionString);
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

function CompactDatabase(AFilename: String; APassword: String; var AError: String): Boolean;
var xJetEngine: OLEVariant;
    xCompactedFilename: String;
    xTempbackupFilename: String;
    xConnectionString, xConnectionCompacted: String;
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
      if APassword = '' then begin
        xConnectionString := Format(CConnectionString, [AFilename]);
        xConnectionCompacted := Format(CConnectionString, [xCompactedFilename]);
      end else begin
        xConnectionString := Format(CConnectionStringWithPass, [AFilename, APassword]);
        xConnectionCompacted := Format(CConnectionStringWithPass, [xCompactedFilename, APassword]);
      end;
      xJetEngine.CompactDatabase(xConnectionString, xConnectionCompacted);
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

function ChangeDatabasePassword(AFilename: String; APassword, ANewPassword: String; var AError: String): Boolean;
var xAdo: OLEVariant;
    xConnectionString: String;
    xOldPass, xNewPass: String;
begin
  Result := False;
  try
    try
      if APassword = '' then begin
        xConnectionString := Format(CConnectionString, [AFilename]);
        xOldPass := 'null';
      end else begin
        xConnectionString := Format(CConnectionStringWithPass, [AFilename, APassword]);
        xOldPass := APassword;
      end;
      if ANewPassword <> '' then begin
        xNewPass := ANewPassword;
      end else begin
        xNewPass := 'null';
      end;
      xAdo := CreateOleObject('ADODB.connection');
      xAdo.ConnectionString := xConnectionString;
      xAdo.Mode := 12;
      xAdo.Open;
      xAdo.Execute('alter database password ' + xNewPass + ' ' + xOldPass);
      Result := True;
    except
      on E: Exception do begin
        AError := E.Message;
      end;
    end;
  finally
    xAdo := Unassigned;
  end;
end;

end.
