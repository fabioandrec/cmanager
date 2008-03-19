unit CDatabase;

interface

uses Forms, Controls, Windows, Contnrs, SysUtils, AdoDb, ActiveX, Classes, ComObj, Variants, CConsts,
     Types, CComponents, AdoInt, CInitializeProviderFormUnit, CAdox;

type
  TDataGid = ShortString;
  PDataGid = ^TDataGid;
  TDataCreationMode = (cmCreated, cmLoaded);
  TDataMemoryState = (msValid, msModified, msDeleted);
  TDataObject = class;
  TDataObjectClass = class of TDataObject;

  TDataGids = class(TStringList)
  public
    constructor Create; 
    constructor CreateFromGid(ADataGid: TDataGid);
    procedure MergeWithDataGids(AGids: TDataGids);
  end;

  TDataProvider = class(TObject)
  private
    FConnection: TADOConnection;
    FDataProxyList: TObjectList;
    FFilename: String;
    FPassword: String;
    function GetInTransaction: Boolean;
    function GetIsConnected: Boolean;
  public
    procedure ReloadCaches;
    function ExportTable(ATableName: String; ACondition: String; AOrderBy: String; AStrings: TStringList): Boolean;
    procedure ClearProxies(AForceClearStatic: Boolean);
    function PostProxies(AOnlyThisGid: TDataGid = ''): Boolean;
    constructor Create;
    destructor Destroy; override;
    procedure BeginTransaction;
    procedure RollbackTransaction;
    function CommitTransaction: Boolean;
    function ExecuteSql(ASql: String; AShowError: Boolean = True; AOneStatement: Boolean = False; ADbProgressEvent: TDbExecuteSqlProgress = Nil): Boolean;
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
    property Connection: TADOConnection read FConnection;
    property Filename: String read FFilename write FFilename;
    property Password: String read FPassword write FPassword;
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

  TTreeObject = class(TCListDataElement)
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
    GShutdownEvent: THandle;

function InitializeDataProvider(ADatabaseName: String; APassword: String; ADataProvider: TDataProvider): TInitializeProviderResult;
procedure FinalizeDataProvider(ADataProvider: TDataProvider);

implementation

uses CInfoFormUnit, DB, StrUtils, DateUtils, CBaseFrameUnit, CDatatools,
     CPreferences, CTools, CDataObjects,
     CAdotools, CUpdateDatafileFormUnit;

function InitializeDataProvider(ADatabaseName: String; APassword: String; ADataProvider: TDataProvider): TInitializeProviderResult;
var xCommand: String;
    xFromVersion: String;
    xToVersion: String;
    xDatabaseName: String;
    xPassword: String;
begin
  xCommand := '';
  xDatabaseName := ExpandFileName(ADatabaseName);
  if ADataProvider.IsConnected then begin
    FinalizeDataProvider(ADataProvider);
  end;
  xPassword := APassword;
  Result := ConnectToDatabase(xDatabaseName, xPassword, ADataProvider.Connection);
  if Result = iprSuccess then begin
    if UpdateDatafileWithWizard(xDatabaseName, ADataProvider.Connection, xFromVersion, xToVersion) then begin
      if not UpdateConfiguration(GBasePreferences.configFileVersion, xFromVersion, xToVersion) then begin
        Result := iprError;
        ShowInfo(itError, 'Plik "' + xDatabaseName + '" nie jest poprawnym plikiem danych', '');
      end;
    end else begin
      Result := iprError;
    end;
  end;
  if Result = iprSuccess then begin
    ADataProvider.Filename := xDatabaseName;
    ADataProvider.Password := xPassword;
    GBasePreferences.lastOpenedDatafilename := ADataProvider.Filename;
    ADataProvider.ReloadCaches;
  end;
end;

procedure FinalizeDataProvider(ADataProvider: TDataProvider);
begin
  ADataProvider.ClearProxies(True);
  ADataProvider.Connection.Connected := False;
  ADataProvider.Filename := '';
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
  SaveToLog('begin transaction', DbSqllogfile);
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
      SaveToLog('commit transaction', DbSqllogfile);
    end else begin
      FConnection.RollbackTrans;
    end;
  end;
  ClearProxies(False);
end;

constructor TDataProvider.Create;
begin
  inherited Create;
  FDataProxyList := TObjectList.Create(True);
  FConnection := TADOConnection.Create(Nil);
end;

destructor TDataProvider.Destroy;
begin
  ClearProxies(True);
  FDataProxyList.Free;
  FConnection.Free;
  inherited Destroy;
end;

function TDataProvider.ExecuteSql(ASql: String; AShowError: Boolean = True; AOneStatement: Boolean = False; ADbProgressEvent: TDbExecuteSqlProgress = Nil): Boolean;
var xError: String;
begin
  Result := DbExecuteSql(FConnection, ASql, AOneStatement, xError, ADbProgressEvent);
  if (not Result) and AShowError then begin
    ShowInfo(itError, 'Podczas wykonywania komendy wyst¹pi³ b³¹d', xError);
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
var xError: String;
begin
  Result := DbOpenSql(FConnection, ASql, xError);
  if (Result = Nil) and AShowError then begin
    ShowInfo(itError, 'Podczas wykonywania komendy wyst¹pi³ b³¹d', xError);
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
    SaveToLog('rollback transaction', DbSqllogfile);
  end;
  ClearProxies(False);
end;

function TDataProvider.ExportTable(ATableName: String; ACondition: String; AOrderBy: String; AStrings: TStringList): Boolean;
var xDataset: TADOQuery;
    xStrSchema, xStr: String;
    xCount: Integer;
    xField: TField;
    xVal: String;
begin
  Result := False;
  xDataset := OpenSql('select * from ' + ATableName +
                          IfThen(ACondition <> '', ' where ' + ACondition, '') +
                          IfThen(AOrderBy <> '', ' order by ' + AOrderBy, ''),
                          False);
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
            DbLastError := 'Podczas eksportu tabeli ' + ATableName + ' nie uda³o siê przetworzyæ pola ' + xField.FieldName;
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
    raise Exception.Create('Metoda LoadObject zwróci³a pusty zbiór danych');
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
  inherited Create(False, Nil, Nil, False, False);
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

procedure TDataProvider.ReloadCaches;
var xC: TDataObjectList;
    xCount: Integer;
    xCur: TCurrencyDef;
    xUni: TUnitDef;
begin
  if IsConnected then begin
    xC := TCurrencyDef.GetAllObjects(CurrencyDefProxy);
    for xCount := 0 to xC.Count - 1 do begin
      xCur := TCurrencyDef(xC.Items[xCount]);
      GCurrencyCache.Change(xCur.id, xCur.symbol, xCur.iso);
    end;
    xC.Free;
    xC := TUnitDef.GetAllObjects(UnitDefProxy);
    for xCount := 0 to xC.Count - 1 do begin
      xUni := TUnitDef(xC.Items[xCount]);
      GUnitdefCache.Change(xUni.id, xUni.symbol, '');
    end;
    xC.Free;
    GActiveProfileId := CEmptyDataGid;
    GDefaultProfileId := GetCmanagerParam('GActiveProfileId', CEmptyDataGid);
    GDefaultProductId := GetCmanagerParam('GDefaultProductId', CEmptyDataGid);
    GDefaultAccountId := GetCmanagerParam('GDefaultAccountId', CEmptyDataGid);
    GDefaultCashpointId := GetCmanagerParam('GDefaultCashpointId', CEmptyDataGid);
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
