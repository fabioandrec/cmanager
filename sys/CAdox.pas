unit CAdox;

interface

uses ShellApi, SysUtils, Classes, ComObj, Variants, AdoDb;

type
  TDbExecuteSqlProgress = procedure (AMin, AMax, AStep: Integer) of Object;

function DbCreateDatabase(AFilename: String; APassword: String; var AError: String): Boolean;
function DbCreateExcelFile(AFilename: String; var AError: String): OleVariant;
function DbCompactDatabase(AFilename: String; APassword: String; var AError: String): Boolean;
function DbChangeDatabasePassword(AFilename: String; APassword, ANewPassword: String; var AError: String): Boolean;
function DbConnectDatabase(AFilename: String; APassword: String; AConnection: TADOConnection; var AError: String; var ANativeError: Integer; AExclusive: Boolean): Boolean; overload;
function DbConnectDatabase(AConnectionString: String; AConnection: TADOConnection; var AError: String; var ANativeError: Integer; AExclusive: Boolean): Boolean; overload;
function DbExecuteSql(AConnection: TADOConnection; ASql: String; AOneStatement: Boolean; var AErrorText: String; ADbProgressEvent: TDbExecuteSqlProgress = Nil): Boolean;
function DbOpenSql(AConnection: TADOConnection; ASql: String; var AErrorText: String): TADOQuery;

var DbSqllogfile: String = '';
    DbLastStatement: String = '';
    DbLastError: String = '';

implementation

uses CTools;

const CConnectionString = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s';
      CConnectionStringWithPass = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s;Jet OLEDB:Database Password=%s';
      CCreateExcelFile = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s;Extended Properties="Excel 8.0"';

function DbConnectDatabase(AFilename: String; APassword: String; AConnection: TADOConnection; var AError: String; var ANativeError: Integer; AExclusive: Boolean): Boolean;
var xConnectionString: String;
begin
  Result := False;
  ANativeError := 0;
  try
    if APassword = '' then begin
      xConnectionString := Format(CConnectionString, [AFilename]);
    end else begin
      xConnectionString := Format(CConnectionStringWithPass, [AFilename, APassword]);
    end;
    if AConnection.Connected then begin
      AConnection.Close;
    end;
    AConnection.ConnectionString := xConnectionString;
    if AExclusive then begin
      AConnection.Mode := cmShareExclusive;
    end else begin
      AConnection.Mode := cmShareDenyNone;
    end;
    AConnection.LoginPrompt := False;
    AConnection.CursorLocation := clUseClient;
    AConnection.Open;
    Result := True;
  except
    on E: Exception do begin
      AError := E.Message;
      DbLastError := AError;
      if AConnection.Errors.Count > 0 then begin
        ANativeError := AConnection.Errors.Item[0].NativeError;
      end;
    end;
  end;
end;

function DbConnectDatabase(AConnectionString: String; AConnection: TADOConnection; var AError: String; var ANativeError: Integer; AExclusive: Boolean): Boolean; overload;
begin
  Result := False;
  ANativeError := 0;
  try
    if AConnection.Connected then begin
      AConnection.Close;
    end;
    AConnection.ConnectionString := AConnectionString;
    if AExclusive then begin
      AConnection.Mode := cmShareExclusive;
    end else begin
      AConnection.Mode := cmShareDenyNone;
    end;
    AConnection.LoginPrompt := False;
    AConnection.CursorLocation := clUseClient;
    AConnection.Open;
    Result := True;
  except
    on E: Exception do begin
      AError := E.Message;
      DbLastError := AError;
      if AConnection.Errors.Count > 0 then begin
        ANativeError := AConnection.Errors.Item[0].NativeError;
      end;
    end;
  end;
end;

function DbCreateDatabase(AFilename: String; APassword: String; var AError: String): Boolean;
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
        DbLastError := AError;
      end;
    end
  finally
    xCatalog := Unassigned;
  end;
end;

function DbCreateExcelFile(AFilename: String; var AError: String): OleVariant;
begin
  VarClear(Result);
  try
    try
      Result := CreateOleObject('ADOX.Catalog');
      Result.ActiveConnection := Format(CCreateExcelFile, [AFilename]);
    except
      on E: Exception do begin
        AError := E.Message;
        DbLastError := AError;
        Result := Unassigned;
      end;
    end
  finally
  end;
end;

function DbCompactDatabase(AFilename: String; APassword: String; var AError: String): Boolean;
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
        DbLastError := AError;
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

function DbChangeDatabasePassword(AFilename: String; APassword, ANewPassword: String; var AError: String): Boolean;
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
        DbLastError := AError;
      end;
    end;
  finally
    xAdo := Unassigned;
  end;
end;

function DbExecuteSql(AConnection: TADOConnection; ASql: String; AOneStatement: Boolean; var AErrorText: String; ADbProgressEvent: TDbExecuteSqlProgress = Nil): Boolean;
var xFinished: Boolean;
    xPos: Integer;
    xSql, xRemains: String;
    xMax: Integer;
begin
  Result := True;
  if Trim(ReplaceLinebreaks(ASql)) <> '' then begin
    xRemains := ASql;
    xFinished := False;
    if not AOneStatement then begin
      xMax := Length(xRemains) - Length(StringReplace(xRemains, ';', '', [rfReplaceAll, rfIgnoreCase])) + 1;
      if Assigned(ADbProgressEvent) then begin
        ADbProgressEvent(0, xMax, 0);
      end;
      repeat
        xPos := Pos(';', xRemains);
        if xPos > 0 then begin
          xSql := Copy(xRemains, 1, xPos - 1);
          Delete(xRemains, 1, xPos);
        end else begin
          xSql := xRemains;
          xFinished := True;
        end;
        if Trim(xSql) <> '' then begin
          try
            SaveToLog('Wykonywanie "' + xSql + '"', DbSqllogfile);
            DbLastStatement := xSql;
            AConnection.Execute(xSql, cmdText, [eoExecuteNoRecords]);
          except
            on E: Exception do begin
              AErrorText := E.Message;
              DbLastError := AErrorText;
              Result := False;
              xFinished := True;
            end;
          end;
        end;
        if Assigned(ADbProgressEvent) then begin
          ADbProgressEvent(0, xMax, 1);
        end;
      until xFinished;
    end else begin
      if Assigned(ADbProgressEvent) then begin
        ADbProgressEvent(0, 1, 0);
      end;
      if Trim(ASql) <> '' then begin
        try
          SaveToLog('Wykonywanie "' + ASql + '"', DbSqllogfile);
          DbLastStatement := ASql;
          AConnection.Execute(ASql, cmdText, [eoExecuteNoRecords]);
        except
          on E: Exception do begin
            AErrorText := E.Message;
            DbLastError := AErrorText;
            Result := False;
          end;
        end;
      end;
      if Assigned(ADbProgressEvent) then begin
        ADbProgressEvent(0, 1, 1);
      end;
    end;
    if not Result then begin
      SaveToLog('B³¹d "' + AErrorText + '"', DbSqllogfile);
    end;
  end;
end;

function DbOpenSql(AConnection: TADOConnection; ASql: String; var AErrorText: String): TADOQuery;
begin
  SaveToLog('Otwieranie "' + ASql + '"', DbSqllogfile);
  Result := TADOQuery.Create(Nil);
  try
    Result.ParamCheck := False;
    Result.Connection := AConnection;
    Result.SQL.Text := ASql;
    DbLastStatement := ASql;
    Result.Prepared := True;
    Result.Open
  except
    on E: Exception do begin
      AErrorText := E.Message;
      DbLastError := AErrorText;
      FreeAndNil(Result);
    end;
  end;
  if Result = Nil then begin
    SaveToLog('B³¹d "' + AErrorText + '"', DbSqllogfile);
  end;
end;

end.
