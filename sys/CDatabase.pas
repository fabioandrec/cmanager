unit CDatabase;

interface

uses Forms, Controls, Windows, Contnrs, SysUtils, AdoDb, ActiveX, Classes, ComObj, Variants, CConsts,
     Types, CComponents, AdoInt;

type
  TDataGid = ShortString;
  PDataGid = ^TDataGid;
  TDataCreationMode = (cmCreated, cmLoaded);
  TDataMemoryState = (msValid, msModified, msDeleted);
  TDataObject = class;
  TDataObjectClass = class of TDataObject;
  TInitializeProviderResult = (iprSuccess, iprCancelled, iprError);

  TDataGids = class(TStringList)
  public
    constructor Create; 
    constructor CreateFromGid(ADataGid: TDataGid);
    procedure MergeWithDataGids(AGids: TDataGids);
  end;

  TDataProvider = class(TObject)
  private
    FLastError: String;
    FLastStatemenet: String;
    FConnection: TADOConnection;
    FDataProxyList: TObjectList;
    function GetInTransaction: Boolean;
    function GetIsConnected: Boolean;
  public
    function OpenConnection(var ANativeErrorCode: Integer; ADatasource: String): Boolean;
    function ExportTable(ATableName: String; ACondition: String; AStrings: TStringList): Boolean;
    procedure ClearProxies(AForceClearStatic: Boolean);
    function PostProxies(AOnlyThisGid: TDataGid = ''): Boolean;
    constructor Create;
    destructor Destroy; override;
    procedure DisconnectFromDatabase;
    procedure BeginTransaction;
    procedure RollbackTransaction;
    function CommitTransaction: Boolean;
    function ExecuteSql(ASql: String; AShowError: Boolean = True; AOneStatement: Boolean = False): Boolean;
    function OpenSql(ASql: String; AShowError: Boolean = True): TADOQuery;
    function GetSqlInteger(ASql: String; ADefault: Integer): Integer;
    function GetSqlBoolean(ASql: String; ADefault: Boolean): Boolean;
    function GetSqlCurrency(ASql: String; ADefault: Currency): Currency;
    function GetSqlString(ASql: String; ADefault: String): String;
    function GetSqlStringList(ASql: String): TStringList;
    function GetCmanagerParam(AName: String; ADefault: String = ''): String;
    procedure SetCmanagerParam(AName: String; AValue: String);
  published
    property DataProxyList: TObjectList read FDataProxyList;
    property InTransaction: Boolean read GetInTransaction;
    property IsConnected: Boolean read GetIsConnected;
    property LastError: String read FLastError;
    property LastStatement: String read FLastStatemenet;
    property Connection: TADOConnection read FConnection;
  end;

  TDataObjectList = class(TObjectList)
  private
    function GetItems(AIndex: Integer): TDataObject;
    procedure SetItems(AIndex: Integer; const Value: TDataObject);
    function GetobjectById(AGid: TDataGid): TDataObject;
    function GetObjectByHash(AHash: String; AHashId: Integer): TDataObject;
  public
    property Items[AIndex: Integer]: TDataObject read GetItems write SetItems;
    property ObjectById[AGid: TDataGid]: TDataObject read GetobjectById;
    property ObjectByHash[AHash: String; AHashId: Integer]: TDataObject read GetObjectByHash;
  end;

  TDataProxy = class(TObject)
  private
    FDataProvider: TDataProvider;
    FIdFieldName: String;
    FTableName: String;
    FSelectTableName: String;
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
    constructor Create(ADataProvider: TDataProvider; ATableName: String; ASelectTableName: String = ''; AIdFieldName: String = ''; AParentDataProxy: TDataProxy = Nil);
    procedure AddDataObject(ADataObject: TDataObject);
    procedure DelDataObject(ADataObject: TDataObject);
    destructor Destroy; override;
  published
    property DataProvider: TDataProvider read FDataProvider;
    property TableName: String read FTableName;
    property IdFieldName: String read FIdFieldName;
    property SelectTableName: String read FTableName;
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
    function GetInsertSql(AId: TDataGid; ATableName: String; AIdFieldName: String): String;
    function GetUpdateSql(AId: TDataGid; ATableName: String; AIdFieldName: String): String;
    function GetDeleteSql(AId: TDataGid; ATableName: String; AIdFieldName: String): String;
    property Items[AIndex: Integer]: TDataField read GetItems write SetItems;
  end;

  TDataObject = class(TCDataListElementObject)
  private
    Fid: TDataGid;
    Fcreated: TDateTime;
    Fmodified: TDateTime;
    FCreationMode: TDataCreationMode;
    FMemoryState: TDataMemoryState;
    FIsStatic: Boolean;
    FDataProxy: TDataProxy;
    FDataFieldList: TDataFieldList;
    FIsRegistered: Boolean;
  protected
    function GetHash(AHashId: Integer): String; virtual;
    function OnDeleteObject(AProxy: TDataProxy): Boolean; virtual;
    function OnUpdateObject(AProxy: TDataProxy): Boolean; virtual;
    function OnInsertObject(AProxy: TDataProxy): Boolean; virtual;
    procedure SetState(AState: TDataMemoryState);
    procedure SetMode(AMode: TDataCreationMode);
  public
    procedure DeleteObject; virtual;
    constructor Create(AStatic: Boolean); virtual;
    constructor CreateObject(ADataProxy: TDataProxy; AIsStatic: Boolean); virtual;
    class function LoadObject(ADataProxy: TDataProxy; AId: TDataGid; AIsStatic: Boolean): TDataObject;
    class function FindByCondition(ADataProxy: TDataProxy; AACondition: String; AIsStatic: Boolean): TDataObject;
    procedure ReloadObject;
    class function GetList(AClass: TDataObjectClass; ADataProxy: TDataProxy; ASql: String): TDataObjectList;
    class function GetAllObjects(ADataProxy: TDataProxy): TDataObjectList;
    destructor Destroy; override;
    procedure UpdateFieldList; virtual;
    procedure FromDataset(ADataset: TADOQuery); virtual;
    procedure ForceUpdate;
    procedure AfterPost; virtual;
    function IsReadonly: Boolean; virtual;
    class function CanBeDeleted(AId: TDataGid): Boolean; virtual;
    function GetElementId: String; override;
    function GetElementType: String; override;
    function GetElementText: String; override;
    function GetColumnImage(AColumnIndex: Integer): Integer; override;
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String; override;
    procedure GetElementReload; override;
    function GetElementCompare(AColumnIndex: Integer; ACompareWith: TCDataListElementObject; AViewTextSelector: String): Integer; override;
    function GetElementHint(AColumnIndex: Integer): String; override;
    property Hash[AHashId: Integer]: String read GetHash;
  published
    property id: TDataGid read FId write Fid;
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

  TSumElementList = class;

  TSumElement = class(TObject)
  private
    Fid: String;
    FidCurrencyDef: String;
    Fname: String;
    FcashIn: Currency;
    FcashOut: Currency;
    Fchilds: TSumElementList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddChild(ASumElement: TSumElement);
  published
    property id: String read Fid write Fid;
    property idCurrencyDef: String read FidCurrencyDef write FidCurrencyDef;
    property name: String read Fname write Fname;
    property cashIn: Currency read FcashIn write FcashIn;
    property cashOut: Currency read FcashOut write FcashOut;
    property childs: TSumElementList read Fchilds write Fchilds;
  end;

  TSumElementList = class(TObjectList)
  public
    function FindSumObjectById(AId: String; ACreate: Boolean): TSumElement;
    function FindSumObjectByCur(AId: String; ACreate: Boolean): TSumElement;
  end;

var GDataProvider: TDataProvider;
    GWorkDate: TDateTime;
    GDatabaseName: String;
    GSqllogfile: String = '';
    GShutdownEvent: THandle;
    GLastUsedPassword: String = '';
    GLastUsedPasswordPresent: Boolean = False;

function InitializeDataProvider(ADatabaseName: String; var AError: String; var ADesc: String; ACanCreate: Boolean): TInitializeProviderResult;
function UpdateDatabase(AFromVersion, AToVersion: String): Boolean;
function UpdateConfiguration(AFromVersion, AToVersion: String): Boolean;
function CurrencyToString(ACurrency: Currency; ACurrencyId: String = ''; AWithSymbol: Boolean = True; ADecimal: Integer = 2): String;
function DatabaseToDatetime(ADatetime: String): TDateTime;
function GetFieldValueDef(ADataset: TADOQuery; AFieldname: String; ADefValue: Variant): Variant;
function GetStartQuarterOfTheYear(ADateTime: TDateTime): TDateTime;
function GetEndQuarterOfTheYear(ADateTime: TDateTime): TDateTime;
function GetQuarterOfTheYear(ADateTime: TDateTime): Integer;
function GetStartHalfOfTheYear(ADateTime: TDateTime): TDateTime;
function GetEndHalfOfTheYear(ADateTime: TDateTime): TDateTime;
function GetHalfOfTheYear(ADateTime: TDateTime): Integer;
function GetFormattedDate(ADate: TDateTime; AFormat: String): String;
function GetFormattedTime(ADate: TDateTime; AFormat: String): String;
function GetSystemPathname(AFilename: String): String;

implementation

uses CInfoFormUnit, DB, StrUtils, DateUtils, CBaseFrameUnit, CDatatools,
     CPreferences, CTools, CAdox, CDataObjects,
  CInitializeProviderFormUnit;


function CurrencyToString(ACurrency: Currency; ACurrencyId: String = ''; AWithSymbol: Boolean = True; ADecimal: Integer = 2): String;
var xCurSymbol: String;
begin
  if AWithSymbol then begin
    if ACurrencyId = '' then begin
      xCurSymbol := GCurrencyCache.GetSymbol(CCurrencyDefGid_PLN);
    end else begin
      xCurSymbol := GCurrencyCache.GetSymbol(ACurrencyId);
    end;
    Result := CurrToStrF(ACurrency, ffNumber, ADecimal) + ' ' + xCurSymbol;
  end else begin
    Result := CurrToStrF(ACurrency, ffNumber, ADecimal);
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

function InitializeDataProvider(ADatabaseName: String; var AError: String; var ADesc: String; ACanCreate: Boolean): TInitializeProviderResult;
var xResStream: TResourceStream;
    xCommand: String;
    xDataset: TADOQuery;
    xError: String;
    xDataVersion: String;
    xNativeErrorCode: Integer;
    xFileVersion: String;
    xValid: Boolean;
begin
  xCommand := '';
  AError := '';
  Result := iprError;
  if (not FileExists(ADatabaseName)) then begin
    if ACanCreate then begin
      xValid := CreateDatabase(ADatabaseName, xError);
      if xValid then begin
        xResStream := TResourceStream.Create(HInstance, 'SQLPATTERN', RT_RCDATA);
        SetLength(xCommand, xResStream.Size);
        CopyMemory(@xCommand[1], xResStream.Memory, xResStream.Size);
        xResStream.Free;
      end else begin
        AError := 'Nie uda�o si� utworzy� pliku danych. Kontynuacja nie jest mo�liwa.';
        ADesc := xError;
      end;
    end else begin
      AError := 'Nie odnaleziono pliku danych ' + ADatabaseName + '.';
    end;
  end;
  if AError = '' then begin
    if GDataProvider.IsConnected then begin
      GDataProvider.DisconnectFromDatabase;
    end;
    if not GDataProvider.OpenConnection(xNativeErrorCode, ADatabaseName) then begin
      if (xNativeErrorCode = CProviderErrorCodeInvalidPassword) then begin
        if ConnectToDatabaseWithPassword(ADatabaseName) then begin
          Result := iprSuccess;
        end else begin
          Result := iprCancelled;
        end;
      end;
    end else begin
      Result := iprSuccess;
    end;
    if Result = iprError then begin
      AError := 'Nie uda�o si� otworzy� pliku danych ' + ADatabaseName + '.';
      ADesc := GDataProvider.LastError;
    end else if Result = iprSuccess then begin
      if xCommand <> '' then begin
        xValid := GDataProvider.ExecuteSql(xCommand, False) and
                  GDataProvider.ExecuteSql(Format('insert into cmanagerInfo (version, created) values (''%s'', %s)', [FileVersion(ParamStr(0)), DatetimeToDatabase(Now, True)]), False);
        if not xValid then begin
          AError := 'Nie uda�o si� utworzy� schematu danych. Kontynuacja nie jest mo�liwa.';
          ADesc := GDataProvider.LastError;
          GDataProvider.DisconnectFromDatabase;
          DeleteFile(ADatabaseName);
          Result := iprError;
        end else begin
          GDatabaseName := ADatabaseName;
          if ShowInfo(itQuestion, 'Utworzono nowy plik danych. Czy chcesz wype�ni� go podstawowymi ustawieniami?', '') then begin
            SetDatabaseDefaultData;
          end;
        end;
      end else begin
        GDatabaseName := ADatabaseName;
        xDataset := GDataProvider.OpenSql('select * from cmanagerInfo', False);
        if xDataset = Nil then begin
          AError := 'Plik ' + ADatabaseName + ' nie jest poprawnym plikiem danych';
          ADesc := '';
          GDataProvider.DisconnectFromDatabase;
          Result := iprError;
        end else begin
          xDataVersion := xDataset.FieldByName('version').AsString;
          xFileVersion := FileVersion(ParamStr(0));
          if xFileVersion <> xDataVersion then begin
            if not (UpdateDatabase(xDataVersion, xFileVersion) or UpdateConfiguration(xDataVersion, xFileVersion)) then begin
              Result := iprError;
            end;
          end;
          xDataset.Free;
        end;
      end;
    end;
    if Result = iprSuccess then begin
      GBasePreferences.lastOpenedDatafilename := GDatabaseName;
      ReloadCaches;
    end;
  end;
end;

procedure TDataProxy.AddDataObject(ADataObject: TDataObject);
begin
  FDataObjects.Add(ADataObject);
end;

constructor TDataProxy.Create(ADataProvider: TDataProvider; ATableName: String; ASelectTableName: String = ''; AIdFieldName: String = ''; AParentDataProxy: TDataProxy = Nil);
begin
  inherited Create;
  FDataProvider := ADataProvider;
  FTableName := ATableName;
  FSelectTableName := IfThen(ASelectTableName = '', FTableName, ASelectTableName);
  FIdFieldName := IfThen(AIdFieldName = '', 'id' + FTableName, AIdFieldName);
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

function TDataFieldList.GetDeleteSql(AId: TDataGid; ATableName: String; AIdFieldName: String): String;
begin
  Result := 'delete from ' + ATableName + ' where id' + ATableName + ' = ''' + AId + '''';
end;

function TDataFieldList.GetInsertSql(AId: TDataGid; ATableName: String; AIdFieldName: String): String;
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
  Result := Result + AIdFieldName + ') values (';
  for xCount := 0 to Count - 1 do begin
    if (Items[xCount].TableName = xTableName) then begin
      if Items[xCount].IsQuoted then begin
        Result := Result + QuotedStr(Items[xCount].Value) + ',';
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

function TDataFieldList.GetUpdateSql(AId: TDataGid; ATableName: String; AIdFieldName: String): String;
var xCount: Integer;
    xTableName: String;
begin
  xTableName := AnsiUpperCase(ATableName);
  Result := 'update ' + ATableName + ' set ';
  for xCount := 0 to Count - 1 do begin
    if (Items[xCount].TableName = xTableName) then begin
     Result := Result + Items[xCount].Name + ' = ';
      if Items[xCount].IsQuoted then begin
        Result := Result + QuotedStr(Items[xCount].Value);
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
  if FMemoryState <> msDeleted then begin
    SetState(msValid);
  end;
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
  FIsRegistered := False;
end;

constructor TDataObject.CreateObject(ADataProxy: TDataProxy; AIsStatic: Boolean);
var xGuid: TGUID;
begin
  Create(AIsStatic);
  FDataProxy := ADataProxy;
  CreateGUID(xGuid);
  Fid := GUIDToString(xGuid);
  DataProxy.AddDataObject(Self);
  FIsRegistered := True;
end;

procedure TDataObject.DeleteObject;
begin
  FMemoryState := msDeleted;
end;

destructor TDataObject.Destroy;
begin
  if FIsRegistered then begin
    FDataProxy.DelDataObject(Self);
  end;
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
    xIdFieldNames: TStringList;
    xCountSql: Integer;
begin
  Result := True;
  if FTableName <> '' then begin
    xCount := 0;
    while Result and (xCount <= FDataObjects.Count - 1) do begin
      xObj := FDataObjects.Items[xCount];
      if not xObj.IsReadonly then begin
        if (xObj.CreationMode = cmLoaded) and (xObj.MemoryState = msDeleted) and ((AOnlyThisGid = '') or (AOnlyThisGid = xObj.id)) then begin
          xObj.UpdateFieldList;
          xTableNames := TStringList.Create;
          xIdFieldNames := TStringList.Create;
          xProxy := Self;
          repeat
            xTableNames.Add(xProxy.TableName);
            xIdFieldNames.Add(xProxy.IdFieldName);
            xProxy := xProxy.ParentDataProxy;
          until (xProxy = Nil);
          xCountSql := 0;
          while Result and (xCountSql <= xTableNames.Count - 1) do begin
            Result := xObj.OnDeleteObject(Self);
            if Result then begin
              xSql := xObj.DataFieldList.GetDeleteSql(xObj.Id, xTableNames.Strings[xCountSql], xIdFieldNames.Strings[xCountSql]);
              Result := FDataProvider.ExecuteSql(xSql, True, True);
            end;
            Inc(xCountSql);
          end;
          xTableNames.Free;
          xIdFieldNames.Free;
        end;
        Inc(xCount);
      end;
    end;
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
  SaveToLog('begin transaction', GSqllogfile);
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
      SaveToLog('commit transaction', GSqllogfile);
    end else begin
      FConnection.RollbackTrans;
    end;
  end;
  ClearProxies(False);
end;

function TDataProvider.OpenConnection(var ANativeErrorCode: Integer; ADatasource: String): Boolean;
var xConnectionString: String;
begin
  Result := False;
  ANativeErrorCode := 0;
  if FConnection.Connected then begin
    FConnection.Close;
  end;
  if GLastUsedPasswordPresent then begin
    xConnectionString := Format(CDefaultConnectionStringWithPass, [ADatasource, GLastUsedPassword]);
  end else begin
    xConnectionString := Format(CDefaultConnectionString, [ADatasource]);
  end;
  FConnection.ConnectionString := xConnectionString;
  FConnection.Mode := cmShareDenyNone;
  FConnection.LoginPrompt := False;
  FConnection.CursorLocation := clUseClient;
  try
    FConnection.Open;
    Result := True;
  except
    on E: Exception do begin
      FLastError := E.Message;
      if FConnection.Errors.Count > 0 then begin
        ANativeErrorCode := FConnection.Errors.Item[0].NativeError;
      end;
    end;
  end;
end;

constructor TDataProvider.Create;
begin
  inherited Create;
  FDataProxyList := TObjectList.Create(True);
  FConnection := TADOConnection.Create(Nil);
  FLastError := '';
  FLastStatemenet := '';
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
  ClearProxies(True);
  FConnection.Connected := False;
  GDatabaseName := '';
end;

function TDataProvider.ExecuteSql(ASql: String; AShowError: Boolean = True; AOneStatement: Boolean = False): Boolean;
var xFinished: Boolean;
    xPos: Integer;
    xSql, xRemains: String;
begin
  Result := True;
  xRemains := ASql;
  xFinished := False;
  if not AOneStatement then begin
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
          SaveToLog('Wykonywanie "' + xSql + '"', GSqllogfile);
          FLastStatemenet := StringReplace(xSql, sLineBreak, '', [rfReplaceAll, rfIgnoreCase]);
          FConnection.Execute(xSql, cmdText, [eoExecuteNoRecords]);
        except
          on E: Exception do begin
            if AShowError then begin
               ShowInfo(itError, 'Podczas wykonywania komendy wyst�pi� b��d', E.Message);
            end;
            FLastError := E.Message;
            Result := False;
            xFinished := True;
          end;
        end;
      end;
    until xFinished;
  end else begin
    if Trim(ASql) <> '' then begin
      try
        SaveToLog('Wykonywanie "' + ASql + '"', GSqllogfile);
        FLastStatemenet := StringReplace(ASql, sLineBreak, '', [rfReplaceAll, rfIgnoreCase]);
        FConnection.Execute(ASql, cmdText, [eoExecuteNoRecords]);
      except
        on E: Exception do begin
          if AShowError then begin
             ShowInfo(itError, 'Podczas wykonywania komendy wyst�pi� b��d', E.Message);
          end;
          FLastError := E.Message;
          Result := False;
        end;
      end;
    end;
  end;
  if not Result then begin
    SaveToLog('B��d "' + FLastError + '"', GSqllogfile);
  end;
end;

function TDataProvider.GetInTransaction: Boolean;
begin
  Result := FConnection.InTransaction;
end;

function TDataProvider.GetIsConnected: Boolean;
begin
  Result := FConnection.Connected;
end;

function TDataProvider.GetSqlCurrency(ASql: String; ADefault: Currency): Currency;
var xQ: TADOQuery;
begin
  Result := ADefault;
  xQ := OpenSql(ASql);
  if xQ <> Nil then begin
    if not xQ.IsEmpty then begin
      Result := xQ.Fields[0].AsCurrency;
    end;
    xQ.Free;
  end;
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
  SaveToLog('Otwieranie "' + ASql + '"', GSqllogfile);
  Result := TADOQuery.Create(Nil);
  try
    Result.ParamCheck := False;
    Result.Connection := FConnection;
    Result.SQL.Text := ASql;
    FLastStatemenet := StringReplace(ASql, sLineBreak, '', [rfReplaceAll, rfIgnoreCase]);;    
    Result.Prepared := True;
    Result.Open
  except
    on E: Exception do begin
      if AShowError then begin
        ShowInfo(itError, 'Podczas wykonywania komendy wyst�pi� b��d', E.Message);
      end;
      FLastError := E.Message;
      FreeAndNil(Result);
    end;
  end;
  if Result = Nil then begin
    SaveToLog('B��d "' + FLastError + '"', GSqllogfile);
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
    SaveToLog('rollback transaction', GSqllogfile);
  end;
  ClearProxies(False);
end;

function TDataProvider.ExportTable(ATableName: String; ACondition: String; AStrings: TStringList): Boolean;
var xDataset: TADOQuery;
    xStrSchema, xStr: String;
    xCount: Integer;
    xField: TField;
    xVal: String;
begin
  Result := False;
  xDataset := OpenSql('select * from ' + ATableName + IfThen(ACondition <> '', ' where ' + ACondition, ''), False);
  if xDataset <> Nil then begin
    Result := True;
    xStrSchema := 'insert into ' + ATableName + ' (';
    for xCount := 0 to xDataset.FieldCount - 1 do begin
      xStrSchema := xStrSchema + xDataset.Fields.Fields[xCount].FieldName;
      if xCount <> xDataset.FieldCount - 1 then begin
        xStrSchema := xStrSchema + ', ';
      end;
    end;
    xStrSchema := xStrSchema + ') values (%s);';
    while not xDataset.Eof do begin
      xCount := 0;
      xStr := '';
      while Result and (xCount <= xDataset.FieldCount - 1) do begin
        xField := xDataset.Fields.Fields[xCount];
        if not xField.IsNull then begin
          if xField.DataType in [ftString, ftMemo, ftFmtMemo, ftFixedChar, ftWideString, ftGuid] then begin
            xVal := '''' + xField.AsString + '''';
          end else if xField.DataType in [ftSmallint, ftInteger, ftWord, ftLargeint] then begin
            xVal := xField.AsString;
          end else if xField.DataType in [ftDateTime] then begin
            xVal := DatetimeToDatabase(xField.AsDateTime, True);
          end else if xField.DataType in [ftCurrency, ftFloat, ftBCD] then begin
            xVal := CurrencyToDatabase(xField.AsCurrency);
          end else if xField.DataType in [ftBoolean] then begin
            xVal := IntToStr(Integer(xField.AsBoolean));
          end else begin
            Result := False;
            FLastError := 'Podczas eksportu tabeli ' + ATableName + ' nie uda�o si� przetworzy� pola ' + xField.FieldName;
          end;
        end else begin
          xVal := 'null';
        end;
        xStr := xStr + xVal;
        if xCount <> xDataset.FieldCount - 1 then begin
          xStr := xStr + ', ';
        end;
        Inc(xCount);
      end;
      AStrings.Add(Format(xStrSchema, [xStr]));
      xDataset.Next;
    end;
    xDataset.Free;
  end;
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
  xSelect := FSelectTableName;
  xWhere := FSelectTableName + '.' + FIdFieldName + ' = ''' + AId + '''';
  xProxy := FParentDataProxy;
  while (xProxy <> Nil) do begin
    xSelect := xSelect + ', ' + xProxy.SelectTableName;
    xWhere := xWhere + ' and ' + xProxy.SelectTableName + '.' + xProxy.idFieldName + ' = ''' + AId + '''';
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
    xIdFieldNames: TStringList;
    xCountSql: Integer;
begin
  Result := True;
  if FTableName <> '' then begin
    xCount := 0;
    while Result and (xCount <= FDataObjects.Count - 1) do begin
      xObj := FDataObjects.Items[xCount];
      if not xObj.IsReadonly then begin
        if (xObj.CreationMode = cmCreated) and (xObj.MemoryState <> msDeleted) and ((AOnlyThisGid = '') or (AOnlyThisGid = xObj.id)) then begin
          xObj.UpdateFieldList;
          xTableNames := TStringList.Create;
          xIdFieldNames := TStringList.Create;
          xProxy := Self;
          repeat
            xTableNames.Add(xProxy.TableName);
            xIdFieldNames.Add(xProxy.IdFieldName);
            xProxy := xProxy.ParentDataProxy;
          until (xProxy = Nil);
          xCountSql := xTableNames.Count - 1;
          while Result and (xCountSql >= 0) do begin
            Result := xObj.OnInsertObject(Self);
            if Result then begin
              xSql := xObj.DataFieldList.GetInsertSql(xObj.Id, xTableNames.Strings[xCountSql], xIdFieldNames.Strings[xCountSql]);
              Result := FDataProvider.ExecuteSql(xSql, True, True);
            end;
            if Result then begin
              xObj.AfterPost;
            end;
            Dec(xCountSql);
          end;
          xTableNames.Free;
          xIdFieldNames.Free;
          xObj.SetMode(cmLoaded);
        end;
      end;
      Inc(xCount);
    end;
  end;
end;

function TDataProxy.UpdateObjects(AOnlyThisGid: TDataGid = ''): Boolean;
var xCount: Integer;
    xObj: TDataObject;
    xSql: String;
    xProxy: TDataProxy;
    xTableNames: TStringList;
    xIdFieldNames: TStringList;
    xCountSql: Integer;
begin
  Result := True;
  if FTableName <> '' then begin
    xCount := 0;
    while Result and (xCount <= FDataObjects.Count - 1) do begin
      xObj := FDataObjects.Items[xCount];
      if not xObj.IsReadonly then begin
        if (xObj.CreationMode = cmLoaded) and (xObj.MemoryState = msModified) and ((AOnlyThisGid = '') or (AOnlyThisGid = xObj.id)) then begin
          xObj.UpdateFieldList;
          xTableNames := TStringList.Create;
          xIdFieldNames := TStringList.Create;
          xProxy := Self;
          repeat
            xTableNames.Add(xProxy.TableName);
            xIdFieldNames.Add(xProxy.IdFieldName);
            xProxy := xProxy.ParentDataProxy;
          until (xProxy = Nil);
          xCountSql := xTableNames.Count - 1;
          while Result and (xCountSql >= 0) do begin
            Result := xObj.OnUpdateObject(Self);
            if Result then begin
              xSql := xObj.DataFieldList.GetUpdateSql(xObj.Id, xTableNames.Strings[xCountSql], xIdFieldNames.Strings[xCountSql]);
              Result := FDataProvider.ExecuteSql(xSql, True, True);
            end;
            if Result then begin
              xObj.AfterPost;
            end;
            Dec(xCountSql);
          end;
          xTableNames.Free;
          xIdFieldNames.Free;
        end;
      end;
      Inc(xCount);
    end;
  end;
end;

class function TDataObject.FindByCondition(ADataProxy: TDataProxy; AACondition: String; AIsStatic: Boolean): TDataObject;
var xDataset: TADOQuery;
begin
  Result := Nil;
  xDataset := ADataProxy.DataProvider.OpenSql(AACondition);
  if not xDataset.IsEmpty then begin
    Result := CreateObject(ADataProxy, AIsStatic);
    Result.FromDataset(xDataset);
  end;
  xDataset.Free;
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
    Fid := FieldByName(FDataProxy.IdFieldName).AsString;
    Fcreated := FieldByName('created').AsDateTime;
    Fmodified := FieldByName('modified').AsDateTime;
  end;
end;

class function TDataObject.GetAllObjects(ADataProxy: TDataProxy): TDataObjectList;
begin
  Result := GetList(Self, ADataProxy, 'select * from ' + ADataProxy.SelectTableName)
end;

function TDataObject.GetColumnImage(AColumnIndex: Integer): Integer;
begin
  Result := -1;
end;

function TDataObject.GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String;
begin
  Result := '';
end;

function TDataObject.GetElementCompare(AColumnIndex: Integer; ACompareWith: TCDataListElementObject; AViewTextSelector: String): Integer;
var xV1, xV2: String;
begin
  xV1 := GetColumnText(AColumnIndex, False, AViewTextSelector);
  xV2 := ACompareWith.GetColumnText(AColumnIndex, False, AViewTextSelector);
  Result := AnsiCompareStr(xV1, xV2);
end;

function TDataObject.GetElementHint(AColumnIndex: Integer): String;
begin
  Result := '';
end;

function TDataObject.GetElementId: String;
begin
  Result := Fid;
end;

procedure TDataObject.GetElementReload;
begin
  ReloadObject;
end;

function TDataObject.GetElementText: String;
begin
  Result := '';
end;

function TDataObject.GetElementType: String;
begin
  Result := ClassName;
end;

function TDataObject.GetHash(AHashId: Integer): String;
begin
  Result := '';
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

function TDataObject.IsReadonly: Boolean;
begin
  Result := False;
end;

class function TDataObject.LoadObject(ADataProxy: TDataProxy; AId: TDataGid; AIsStatic: Boolean): TDataObject;
var xDataset: TADOQuery;
begin
  xDataset := ADataProxy.GetLoadObjectDataset(AId);
  Result := CreateObject(ADataProxy, AIsStatic);
  if not xDataset.IsEmpty then begin
    Result.FromDataset(xDataset);
  end else begin
    raise Exception.Create('Metoda LoadObject zwr�ci�a pusty zbi�r danych');
  end;
  xDataset.Free;
end;

function TDataObject.OnDeleteObject(AProxy: TDataProxy): Boolean;
begin
  Result := True;
end;

function TDataObject.OnInsertObject(AProxy: TDataProxy): Boolean;
begin
  Result := True;
end;

function TDataObject.OnUpdateObject(AProxy: TDataProxy): Boolean;
begin
  Result := True;
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

function TDataObjectList.GetObjectByHash(AHash: String; AHashId: Integer): TDataObject;
var xCount: Integer;
begin
  Result := Nil;
  xCount := 0;
  while (xCount <= Count - 1) and (Result = Nil) do begin
    if Items[xCount].Hash[AHashId] = AHash then begin
      Result := Items[xCount];
    end;
    Inc(xCount);
  end;
end;

function TDataObjectList.GetobjectById(AGid: TDataGid): TDataObject;
var xCount: Integer;
begin
  Result := Nil;
  xCount := 0;
  while (xCount <= Count - 1) and (Result = Nil) do begin
    if Items[xCount].Id = AGid then begin
      Result := Items[xCount];
    end;
    Inc(xCount);
  end;
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

procedure TSumElement.AddChild(ASumElement: TSumElement);
begin
  Fchilds.Add(ASumElement);
  FcashIn := FcashIn + ASumElement.cashIn;
  FcashOut := FcashOut + ASumElement.cashOut;
end;

constructor TSumElement.Create;
begin
  inherited Create;
  Fid := '';
  Fname := '';
  FcashIn := 0;
  FcashOut := 0;
  Fchilds := TSumElementList.Create(True);
end;

function TSumElementList.FindSumObjectById(AId: String; ACreate: Boolean): TSumElement;
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

function TSumElementList.FindSumObjectByCur(AId: String; ACreate: Boolean): TSumElement;
var xCount: Integer;
begin
  Result := Nil;
  xCount := 0;
  while (xCount <= Count - 1) and (Result = Nil) do begin
    if TSumElement(Items[xCount]).idCurrencyDef = AId then begin
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

function GetFormattedTime(ADate: TDateTime; AFormat: String): String;
var xTime: TSystemTime;
    xRes: PChar;
begin
  GetMem(xRes, $FF);
  DateTimeToSystemTime(ADate, xTime);
  if GetTimeFormat(GetThreadLocale, 0, @xTime, PChar(AFormat), xRes, $FF) <> 0 then begin
    Result := String(xRes);
  end;
  FreeMem(xRes);
end;

function GetSystemPathname(AFilename: String): String;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + ExtractFileName(AFilename);
end;

function UpdateDatabase(AFromVersion, AToVersion: String): Boolean;
var xCurDbversion: Integer;
    xToDbversion: Integer;
    xCurDynArray, xToDynArray: TStringDynArray;
    xText: String;
    xError: String;
begin
  Result := True;
  xCurDynArray := StringToStringArray(AFromVersion, '.');
  xToDynArray := StringToStringArray(AToVersion, '.');
  if Length(xCurDynArray) <> 4 then begin
    ShowInfo(itError, 'Plik ' + GDatabaseName + ' nie jest poprawnym plikiem danych', '');
    Result := False;
  end else begin
    xCurDbversion := StrToIntDef(xCurDynArray[1], -1);
    xToDbversion := StrToIntDef(xToDynArray[1], -1);
    if xCurDbversion < xToDbversion then begin
      xText := 'Otwierany plik danych ma struktur� ' + AFromVersion + ' i musi by� uaktualniony do wersji ' + AToVersion + '\n' +
               'Czy rozpocz�� uaktualnianie pliku danych ?';
      Result := ShowInfo(itQuestion, xText, '');
      if Result then begin
        Result := True;
        GSqllogfile := GetSystemPathname(ChangeFileExt(GDatabaseName, '') + '_update.log');
        SaveToLog('Sesja uaktualnienia z ' + AFromVersion + ' do ' + AToVersion, GSqllogfile);
        while Result and (xCurDbversion <> xToDbversion) do begin
          SaveToLog(IntToStr(xCurDbversion) + ' -> ' + IntToStr(xCurDbversion + 1), GSqllogfile);
          Result := CheckDatabaseStructure(xCurDbversion, xCurDbversion + 1, xError);
          Inc(xCurDbversion);
        end;
        if not Result then begin
          xText := 'Podczas uaktualniania pliku danych z wersji ' + AFromVersion + ' do ' + AToVersion + ' wyst�pi� b��d' + '\n' +
                   'Aby rozwi�za� problem skontaktuj si� z autorem CManager-a';
          ShowInfo(itError, xText, xError);
        end;
        GSqllogfile := '';
      end;
    end;
    if Result then begin
      GDataProvider.ExecuteSql('update cmanagerInfo set version = ''' + AToVersion + '''');
    end;
  end;
end;

function UpdateConfiguration(AFromVersion, AToVersion: String): Boolean;
var xCurDbversion: Integer;
    xToDbversion: Integer;
    xCurDynArray, xToDynArray: TStringDynArray;
begin
  Result := True;
  xCurDynArray := StringToStringArray(AFromVersion, '.');
  xToDynArray := StringToStringArray(AToVersion, '.');
  if Length(xCurDynArray) <> 4 then begin
    ShowInfo(itError, 'Plik ' + GDatabaseName + ' nie jest poprawnym plikiem danych', '');
    Result := False;
  end else begin
    xCurDbversion := StrToIntDef(xCurDynArray[1], -1);
    xToDbversion := StrToIntDef(xToDynArray[1], -1);
    if (xCurDbversion < 4) and (xToDbversion = 4) then begin
      ShowInfo(itInfo, 'W zwi�zku ze zmianami wewn�trznymi pliku konfiguracji skasowane zostan�\n' +
                       'ustawienia (szeroko��, widoczno��, pozycja) kolumn dla wszystkich list\n' +
                       'wy�wietlaj�cych dane w programie, oraz ustawienia wykres�w. Zastosowane\n' +
                       'zostan� domy�lne ustawienia.', '');
      GColumnsPreferences.Clear;
      GChartPreferences.Clear;
    end;
  end;
end;

function TDataProvider.GetCmanagerParam(AName, ADefault: String): String;
begin
  Result := GetSqlString('select paramValue from cmanagerParams where paramName = ''' + AName + '''', ADefault);
end;

function TDataProvider.GetSqlString(ASql, ADefault: String): String;
var xQ: TADOQuery;
begin
  Result := ADefault;
  xQ := OpenSql(ASql);
  if xQ <> Nil then begin
    if not xQ.IsEmpty then begin
      Result := xQ.Fields[0].AsString;
    end;
    xQ.Free;
  end;
end;

procedure TDataProvider.SetCmanagerParam(AName, AValue: String);
var xCount: Integer;
    xSql: String;
begin
  xCount := GetSqlInteger('select count(*) from cmanagerParams where paramName = ''' + AName + '''', 0);
  if xCount = 0 then begin
    xSql := Format('insert into cmanagerParams (paramName, paramValue) values (''%s'', ''%s'')', [AName, AValue]);
  end else begin
    xSql := Format('update cmanagerParams set paramValue = ''%s'' where paramName = ''%s''', [AValue, AName]);
  end;
  ExecuteSql(xSql);
end;

constructor TDataGids.Create;
begin
  inherited Create;
  Sorted := True;
end;

constructor TDataGids.CreateFromGid(ADataGid: TDataGid);
begin
  inherited Create;
  Add(ADataGid);
end;

function TDataProvider.GetSqlStringList(ASql: String): TStringList;
var xQ: TADOQuery;
begin
  Result := TStringList.Create;
  xQ := OpenSql(ASql);
  if xQ <> Nil then begin
    while not xQ.Eof do begin
      Result.Add(xQ.Fields[0].AsString);
      xQ.Next;
    end;
    xQ.Free;
  end;
end;

function TDataProvider.GetSqlBoolean(ASql: String; ADefault: Boolean): Boolean;
var xQ: TADOQuery;
begin
  Result := ADefault;
  xQ := OpenSql(ASql);
  if xQ <> Nil then begin
    if not xQ.IsEmpty then begin
      Result := xQ.Fields[0].AsBoolean;
    end;
    xQ.Free;
  end;
end;

destructor TSumElement.Destroy;
begin
  Fchilds.Free;
  inherited Destroy;
end;

procedure TDataGids.MergeWithDataGids(AGids: TDataGids);
begin
  Duplicates := dupIgnore;
  AddStrings(AGids);
end;

function GetFieldValueDef(ADataset: TADOQuery; AFieldname: String; ADefValue: Variant): Variant;
var xField: TField;
begin
  xField := ADataset.FindField(AFieldname);
  if xField <> Nil then begin
    Result := xField.AsVariant;
  end else begin
    Result := ADefValue;
  end;
end;

initialization
  CoInitialize(Nil);
  GDataProvider := TDataProvider.Create;
  GWorkDate := Today;
  GShutdownEvent := CreateEvent(Nil, True, False, Nil);
finalization
  CloseHandle(GShutdownEvent);
  GDataProvider.Free;
  CoUninitialize;
end.
