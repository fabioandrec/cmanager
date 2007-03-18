unit CDataObjects;

interface

uses CDatabase, SysUtils, AdoDb, Classes, CConsts;

type
  TBaseName = string[40];
  TBaseDescription = string[200];
  TAccountNumber = string[50];
  TBaseEnumeration = string[1];
  TBaseMemo = string;

  TCashPoint = class(TDataObject)
  private
    Fname: TBaseName;
    Fdescription: TBaseDescription;
    FcashpointType: TBaseEnumeration;
    procedure Setdescription(const Value: TBaseDescription);
    procedure Setname(const Value: TBaseName);
    procedure SetcashpointType(const Value: TBaseEnumeration);
  public
    procedure UpdateFieldList; override;
    procedure FromDataset(ADataset: TADOQuery); override;
    class function CanBeDeleted(AId: ShortString): Boolean; override;
    function GetElementText: String; override;
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean): String; override;
  published
    property name: TBaseName read Fname write Setname;
    property description: TBaseDescription read Fdescription write Setdescription;
    property cashpointType: TBaseEnumeration read FcashpointType write SetcashpointType;
  end;

  TAccount = class(TDataObject)
  private
    Fname: TBaseName;
    Fdescription: TBaseDescription;
    FaccountType: TBaseEnumeration;
    Fcash: Currency;
    FinitialBalance: Currency;
    FaccountNumber: TAccountNumber;
    FidCashPoint: TDataGid;
    procedure Setdescription(const Value: TBaseDescription);
    procedure Setname(const Value: TBaseName);
    procedure Setcash(const Value: Currency);
    procedure SetaccountType(const Value: TBaseEnumeration);
    procedure SetaccountNumber(const Value: TAccountNumber);
    procedure SetidCashPoint(const Value: TDataGid);
    procedure SetinitialBalance(const Value: Currency);
  public
    procedure UpdateFieldList; override;
    procedure FromDataset(ADataset: TADOQuery); override;
    class function CanBeDeleted(AId: ShortString): Boolean; override;
    class function AccountBalanceOnDay(AIdAccount: TDataGid; ADateTime: TDateTime): Currency;
    class function GetMovementCount(AIdAccount: TDataGid): Integer;
  published
    property name: TBaseName read Fname write Setname;
    property description: TBaseDescription read Fdescription write Setdescription;
    property accountType: TBaseEnumeration read FaccountType write SetaccountType;
    property cash: Currency read Fcash write Setcash;
    property initialBalance: Currency read FinitialBalance write SetinitialBalance;
    property accountNumber: TAccountNumber read FaccountNumber write SetaccountNumber;
    property idCashPoint: TDataGid read FidCashPoint write SetidCashPoint;
  end;

  TProduct = class(TDataObject)
  private
    Fname: TBaseName;
    Fdescription: TBaseDescription;
    FidParentProduct: TDataGid;
    FproductType: TBaseEnumeration;
    procedure Setdescription(const Value: TBaseDescription);
    procedure Setname(const Value: TBaseName);
    procedure SetidParentProduct(const Value: TDataGid);
    function GettreeDesc: String;
    procedure SetproductType(const Value: TBaseEnumeration);
  public
    procedure UpdateFieldList; override;
    procedure FromDataset(ADataset: TADOQuery); override;
    class function CanBeDeleted(AId: ShortString): Boolean; override;
    class function HasSubcategory(AId: TDataGid): Boolean; 
  published
    property name: TBaseName read Fname write Setname;
    property description: TBaseDescription read Fdescription write Setdescription;
    property idParentProduct: TDataGid read FidParentProduct write SetidParentProduct;
    property treeDesc: String read GettreeDesc;
    property productType: TBaseEnumeration read FproductType write SetproductType;
  end;

  TMovementList = class(TDataObject)
  private
    Fdescription: TBaseDescription;
    FidAccount: TDataGid;
    FprevIdAccount: TDataGid;
    FidCashPoint: TDataGid;
    FregDate: TDateTime;
    FweekDate: TDateTime;
    FmonthDate: TDateTime;
    FyearDate: TDateTime;
    FmovementType: TBaseEnumeration;
    Fcash: Currency;
    FprevCash: Currency;
    procedure Setdescription(const Value: TBaseDescription);
    procedure SetidAccount(const Value: TDataGid);
    procedure SetidCashPoint(const Value: TDataGid);
    procedure SetregDate(const Value: TDateTime);
    procedure SetmovementType(const Value: TBaseEnumeration);
  protected
    function OnDeleteObject(AProxy: TDataProxy): Boolean; override;
  public
    procedure UpdateFieldList; override;
    procedure FromDataset(ADataset: TADOQuery); override;
    function GetMovements: TDataObjectList;
    procedure DeleteObject; override;
  published
    property description: TBaseDescription read Fdescription write Setdescription;
    property idAccount: TDataGid read FidAccount write SetidAccount;
    property idCashPoint: TDataGid read FidCashPoint write SetidCashPoint;
    property regDate: TDateTime read FregDate write SetregDate;
    property weekDate: TDateTime read FweekDate;
    property monthDate: TDateTime read FmonthDate;
    property yearDate: TDateTime read FyearDate;
    property movementType: TBaseEnumeration read FmovementType write SetmovementType;
    property cash: Currency read Fcash;
  end;

  TBaseMovement = class(TDataObject)
  private
    Fdescription: TBaseDescription;
    Fcash: Currency;
    FprevCash: Currency;
    FmovementType: TBaseEnumeration;
    FidAccount: TDataGid;
    FprevIdAccount: TDataGid;
    FregDate: TDateTime;
    FweekDate: TDateTime;
    FmonthDate: TDateTime;
    FyearDate: TDateTime;
    FidSourceAccount: TDataGid;
    FprevIdSourceAccount: TDataGid;
    FidCashPoint: TDataGid;
    FidProduct: TDataGid;
    FidPlannedDone: TDataGid;
    FidMovementList: TDataGid;
    procedure Setcash(const Value: Currency);
    procedure Setdescription(const Value: TBaseDescription);
    procedure SetidAccount(const Value: TDataGid);
    procedure SetmovementType(const Value: TBaseEnumeration);
    procedure SetregDate(const Value: TDateTime);
    procedure SetidSourceAccount(const Value: TDataGid);
    procedure SetidCashPoint(const Value: TDataGid);
    procedure SetidProduct(const Value: TDataGid);
    procedure SetidPlannedDone(const Value: TDataGid);
    procedure SetidMovementList(const Value: TDataGid);
  protected
    function OnDeleteObject(AProxy: TDataProxy): Boolean; override;
    function OnInsertObject(AProxy: TDataProxy): Boolean; override;
    function OnUpdateObject(AProxy: TDataProxy): Boolean; override;
  public
    procedure UpdateFieldList; override;
    procedure FromDataset(ADataset: TADOQuery); override;
    constructor Create(AStatic: Boolean); override;
  published
    property description: TBaseDescription read Fdescription write Setdescription;
    property cash: Currency read Fcash write Setcash;
    property movementType: TBaseEnumeration read FmovementType write SetmovementType;
    property idAccount: TDataGid read FidAccount write SetidAccount;
    property regDate: TDateTime read FregDate write SetregDate;
    property idSourceAccount: TDataGid read FidSourceAccount write SetidSourceAccount;
    property idCashPoint: TDataGid read FidCashPoint write SetidCashPoint;
    property idProduct: TDataGid read FidProduct write SetidProduct;
    property idPlannedDone: TDataGid read FidPlannedDone write SetidPlannedDone;
    property idMovementList: TDataGid read FidMovementList write SetidMovementList;
    property weekDate: TDateTime read FweekDate;
    property monthDate: TDateTime read FmonthDate;
    property yearDate: TDateTime read FyearDate;
  end;

  TPlannedMovement = class(TDataObject)
  private
    Fdescription: TBaseDescription;
    Fcash: Currency;
    FmovementType: TBaseEnumeration;
    FisActive: Boolean;
    FidAccount: TDataGid;
    FidCashPoint: TDataGid;
    FidProduct: TDataGid;
    FscheduleType: TBaseEnumeration;
    FscheduleDate: TDateTime;
    FendCondition: TBaseEnumeration;
    FendCount: Integer;
    FendDate: TDateTime;
    FtriggerType: TBaseEnumeration;
    FtriggerDay: Integer;
    FdoneCount: Integer;
    procedure Setcash(const Value: Currency);
    procedure Setdescription(const Value: TBaseDescription);
    procedure SetidAccount(const Value: TDataGid);
    procedure SetmovementType(const Value: TBaseEnumeration);
    procedure SetidCashPoint(const Value: TDataGid);
    procedure SetidProduct(const Value: TDataGid);
    procedure SetendCondition(const Value: TBaseEnumeration);
    procedure SetendCount(const Value: Integer);
    procedure SetendDate(const Value: TDateTime);
    procedure SetscheduleDate(const Value: TDateTime);
    procedure SetscheduleType(const Value: TBaseEnumeration);
    procedure SettriggerDay(const Value: Integer);
    procedure SettriggerType(const Value: TBaseEnumeration);
    procedure SetisActive(const Value: Boolean);
  public
    procedure UpdateFieldList; override;
    procedure FromDataset(ADataset: TADOQuery); override;
    class function CanBeDeleted(AId: ShortString): Boolean; override;
    constructor Create(AStatic: Boolean); override;
  published
    property description: TBaseDescription read Fdescription write Setdescription;
    property cash: Currency read Fcash write Setcash;
    property movementType: TBaseEnumeration read FmovementType write SetmovementType;
    property isActive: Boolean read FisActive write SetisActive;
    property idAccount: TDataGid read FidAccount write SetidAccount;
    property idCashPoint: TDataGid read FidCashPoint write SetidCashPoint;
    property idProduct: TDataGid read FidProduct write SetidProduct;
    property scheduleType: TBaseEnumeration read FscheduleType write SetscheduleType;
    property scheduleDate: TDateTime read FscheduleDate write SetscheduleDate;
    property endCondition: TBaseEnumeration read FendCondition write SetendCondition;
    property endCount: Integer read FendCount write SetendCount;
    property endDate: TDateTime read FendDate write SetendDate;
    property triggerType: TBaseEnumeration read FtriggerType write SettriggerType;
    property triggerDay: Integer read FtriggerDay write SettriggerDay;
    property doneCount: Integer read FdoneCount;
  end;

  TPlannedDone = class(TDataObject)
  private
    FtriggerDate: TDateTime;
    FdoneDate: TDateTime;
    FidPlannedMovement: TDataGid;
    FdoneState: TBaseEnumeration;
    Fdescription: TBaseDescription;
    Fcash: Currency;
    procedure SetidPlannedMovement(const Value: TDataGid);
    procedure SettriggerDate(const Value: TDateTime);
    procedure SetdoneState(const Value: TBaseEnumeration);
    procedure SetdoneDate(const Value: TDateTime);
    procedure Setdescription(const Value: TBaseDescription);
    procedure Setcash(const Value: Currency);
  public
    procedure UpdateFieldList; override;
    procedure FromDataset(ADataset: TADOQuery); override;
    constructor Create(AStatic: Boolean); override;
  published
    property triggerDate: TDateTime read FtriggerDate write SettriggerDate;
    property idPlannedMovement: TDataGid read FidPlannedMovement write SetidPlannedMovement;
    property doneState: TBaseEnumeration read FdoneState write SetdoneState;
    property doneDate: TDateTime read FdoneDate write SetdoneDate;
    property description: TBaseDescription read Fdescription write Setdescription;
    property cash: Currency read Fcash write Setcash;
  end;

  TMovementFilter = class(TDataObject)
  private
    Fname: TBaseName;
    Fdescription: TBaseDescription;
    Faccounts: TStringList;
    Fproducts: TStringList;
    Fcashpoints: TStringList;
    FisLoaded: Boolean;
    procedure Setdescription(const Value: TBaseDescription);
    procedure Setname(const Value: TBaseName);
    procedure Setaccounts(const Value: TStringList);
    procedure Setcashpoints(const Value: TStringList);
    procedure Setproducts(const Value: TStringList);
    procedure FillFilterList(AList: TStringList; AQuery: TADOQuery);
  protected
    procedure DeleteSubfilters;
    procedure UpdateSubfilters;
  public
    class function GetFilterCondition(AIdFilter: TDataGid; AWithAnd: Boolean = True; AAcountField: String = 'idAccount'; ACashpointField: String = 'idCashpoint'; ACategoryField: String = 'idProduct'): String;
    procedure LoadSubfilters;
    procedure UpdateFieldList; override;
    procedure FromDataset(ADataset: TADOQuery); override;
    destructor Destroy; override;
    constructor Create(AStatic: Boolean); override;
    procedure AfterPost; override;
    procedure DeleteObject; override;
    function IsValid(AAccountId, ACashpointId, AProductId: TDataGid): Boolean;
  published
    property name: TBaseName read Fname write Setname;
    property description: TBaseDescription read Fdescription write Setdescription;
    property accounts: TStringList read Faccounts write Setaccounts;
    property products: TStringList read Fproducts write Setproducts;
    property cashpoints: TStringList read Fcashpoints write Setcashpoints;
  end;

  TProfile = class(TDataObject)
  private
    Fname: TBaseName;
    Fdescription: TBaseDescription;
    FidAccount: TDataGid;
    FidCashPoint: TDataGid;
    FidProduct: TDataGid;
    procedure Setdescription(const Value: TBaseDescription);
    procedure Setname(const Value: TBaseName);
    procedure SetidAccount(const Value: TDataGid);
    procedure SetidCashPoint(const Value: TDataGid);
    procedure SetidProduct(const Value: TDataGid);
  public
    procedure UpdateFieldList; override;
    procedure FromDataset(ADataset: TADOQuery); override;
    procedure DeleteObject; override;
  published
    property name: TBaseName read Fname write Setname;
    property description: TBaseDescription read Fdescription write Setdescription;
    property idAccount: TDataGid read FidAccount write SetidAccount;
    property idCashPoint: TDataGid read FidCashPoint write SetidCashPoint;
    property idProduct: TDataGid read FidProduct write SetidProduct;
  end;

var CashPointProxy: TDataProxy;
    AccountProxy: TDataProxy;
    ProductProxy: TDataProxy;
    BaseMovementProxy: TDataProxy;
    PlannedMovementProxy: TDataProxy;
    PlannedDoneProxy: TDataProxy;
    MovementFilterProxy: TDataProxy;
    ProfileProxy: TDataProxy;
    MovementListProxy: TDataProxy;

var GActiveProfileId: TDataGid = CEmptyDataGid;

const CDatafileTables: array[0..12] of string =
            ('cashPoint', 'account', 'product', 'plannedMovement', 'plannedDone',
             'movementList', 'baseMovement', 'movementFilter', 'accountFilter',
             'cashpointFilter', 'productFilter', 'profile', 'cmanagerInfo');

procedure InitializeProxies;

implementation

uses DB, CInfoFormUnit, DateUtils;

procedure InitializeProxies;
begin
  CashPointProxy := TDataProxy.Create(GDataProvider, 'cashPoint', Nil);
  AccountProxy := TDataProxy.Create(GDataProvider, 'account', Nil);
  ProductProxy := TDataProxy.Create(GDataProvider, 'product', Nil);
  MovementListProxy :=  TDataProxy.Create(GDataProvider, 'movementList', Nil);
  BaseMovementProxy := TDataProxy.Create(GDataProvider, 'baseMovement', Nil);
  PlannedMovementProxy :=  TDataProxy.Create(GDataProvider, 'plannedMovement', Nil);
  PlannedDoneProxy :=  TDataProxy.Create(GDataProvider, 'plannedDone', Nil);
  MovementFilterProxy :=  TDataProxy.Create(GDataProvider, 'movementFilter', Nil);
  ProfileProxy :=  TDataProxy.Create(GDataProvider, 'profile', Nil);
end;

class function TCashPoint.CanBeDeleted(AId: ShortString): Boolean;
var xText: String;
begin
  Result := True;
  if GDataProvider.GetSqlInteger('select count(*) from account where idCashPoint = ' + DataGidToDatabase(AId), 0) <> 0 then begin
    xText := 'istniej¹ zwi¹zane z nim konta bankowe';
  end else if GDataProvider.GetSqlInteger('select count(*) from plannedMovement where idCashPoint = ' + DataGidToDatabase(AId), 0) <> 0 then begin
    xText := 'istniej¹ zaplanowane operacje z jego udzia³em';
  end else if GDataProvider.GetSqlInteger('select count(*) from baseMovement where idCashPoint = ' + DataGidToDatabase(AId), 0) <> 0 then begin
    xText := 'istniej¹ wykonane operacje z jego udzia³em';
  end else if GDataProvider.GetSqlInteger('select count(*) from cashpointFilter where idCashPoint = ' + DataGidToDatabase(AId), 0) <> 0 then begin
    xText := 'istniej¹ zwi¹zane z nim filtry';
  end else if GDataProvider.GetSqlInteger('select count(*) from profile where idCashPoint = ' + DataGidToDatabase(AId), 0) <> 0 then begin
    xText := 'istniej¹ zwi¹zane z nim profile';
  end;
  if xText <> '' then begin
    ShowInfo(itError, 'Nie mo¿na usun¹æ kontrahenta, gdy¿ ' + xText, '');
    Result := False;
  end;
end;

procedure TCashPoint.FromDataset(ADataset: TADOQuery);
begin
  inherited FromDataset(ADataset);
  with ADataset do begin
    Fname := FieldByName('name').AsString;
    Fdescription := FieldByName('description').AsString;
    FcashpointType := FieldByName('cashpointType').AsString;
  end;
end;

function TCashPoint.GetColumnText(AColumnIndex: Integer; AStatic: Boolean): String;
begin
  Result := Fname;
end;

function TCashPoint.GetElementText: String;
begin
  Result := Fname;
end;

procedure TCashPoint.SetcashpointType(const Value: TBaseEnumeration);
begin
  if FcashpointType <> Value then begin
    FcashpointType := Value;
    SetState(msModified);
  end;
end;

procedure TCashPoint.Setdescription(const Value: TBaseDescription);
begin
  if Fdescription <> Value then begin
    Fdescription := Value;
    SetState(msModified);
  end;
end;

procedure TCashPoint.Setname(const Value: TBaseName);
begin
  if Fname <> Value then begin
    Fname := Value;
    SetState(msModified);
  end;
end;

procedure TCashPoint.UpdateFieldList;
begin
  inherited UpdateFieldList;
  with DataFieldList do begin
    AddField('name', Fname, True, 'cashPoint');
    AddField('description', Fdescription, True, 'cashPoint');
    AddField('cashpointType', FcashpointType, True, 'cashPoint');
  end;
end;

procedure TAccount.FromDataset(ADataset: TADOQuery);
begin
  inherited FromDataset(ADataset);
  with ADataset do begin
    Fname := FieldByName('name').AsString;
    Fdescription := FieldByName('description').AsString;
    FaccountType := FieldByName('accountType').AsString;
    Fcash := FieldByName('cash').AsCurrency;
    FinitialBalance := FieldByName('initialBalance').AsCurrency;
    FaccountNumber := FieldByName('accountNumber').AsString;
    FidCashPoint := FieldByName('idCashPoint').AsString;
  end;
end;

procedure TAccount.Setcash(const Value: Currency);
begin
  if Fcash <> Value then begin
    Fcash := Value;
    SetState(msModified);
  end;
end;

procedure TAccount.Setdescription(const Value: TBaseDescription);
begin
  if Fdescription <> Value then begin
    Fdescription := Value;
    SetState(msModified);
  end;
end;

procedure TAccount.SetaccountType(const Value: TBaseEnumeration);
begin
  if FaccountType <> Value then begin
    FaccountType := Value;
    SetState(msModified);
  end;
end;

procedure TAccount.Setname(const Value: TBaseName);
begin
  if Fname <> Value then begin
    Fname := Value;
    SetState(msModified);
  end;
end;

procedure TAccount.UpdateFieldList;
begin
  inherited UpdateFieldList;
  with DataFieldList do begin
    AddField('name', Fname, True, 'account');
    AddField('description', Fdescription, True, 'account');
    AddField('accountType', FaccountType, True, 'account');
    AddField('cash', CurrencyToDatabase(Fcash), False, 'account');
    AddField('initialBalance', CurrencyToDatabase(FinitialBalance), False, 'account');
    AddField('accountNumber', FaccountNumber, True, 'account');
    AddField('idCashPoint', DataGidToDatabase(FidCashPoint), False, 'account');
  end;
end;

class function TProduct.CanBeDeleted(AId: ShortString): Boolean;
var xText: String;
begin
  Result := True;
  if GDataProvider.GetSqlInteger('select count(*) from plannedMovement where idProduct = ' + DataGidToDatabase(AId), 0) <> 0 then begin
    xText := 'istniej¹ zwi¹zane z ni¹ zaplanowane operacje';
  end else if GDataProvider.GetSqlInteger('select count(*) from baseMovement where idProduct = ' + DataGidToDatabase(AId), 0) <> 0 then begin
    xText := 'istniej¹ zwi¹zane z ni¹ wykonane operacje';
  end else if GDataProvider.GetSqlInteger('select count(*) from product where idParentProduct = ' + DataGidToDatabase(AId), 0) <> 0 then begin
    xText := 'istniej¹ zwi¹zane z ni¹ podkategorie';
  end else if GDataProvider.GetSqlInteger('select count(*) from productFilter where idProduct = ' + DataGidToDatabase(AId), 0) <> 0 then begin
    xText := 'istniej¹ zwi¹zane z nim filtry';
  end else if GDataProvider.GetSqlInteger('select count(*) from profile where idProduct = ' + DataGidToDatabase(AId), 0) <> 0 then begin
    xText := 'istniej¹ zwi¹zane z nim profile';
  end;
  if xText <> '' then begin
    ShowInfo(itError, 'Nie mo¿na usun¹æ kategorii, gdy¿ ' + xText, '');
    Result := False;
  end;
end;

procedure TProduct.FromDataset(ADataset: TADOQuery);
begin
  inherited FromDataset(ADataset);
  with ADataset do begin
    Fname := FieldByName('name').AsString;
    Fdescription := FieldByName('description').AsString;
    FidParentProduct := FieldByName('idParentProduct').AsString;
    FproductType := FieldByName('productType').AsString;
  end;
end;

function TProduct.GettreeDesc: String;
var xStr: TStringList;
    xProdId: TDataGid;
    xProd: TProduct;
    xCount: Integer;
begin
  xStr := TStringList.Create;
  xStr.Add(name);
  xProdId := Self.idParentProduct;
  while (xProdId <> CEmptyDataGid) do begin
    xProd := TProduct(TProduct.LoadObject(ProductProxy, xProdId, False));
    xStr.Add(xProd.name);
    xProdId := xProd.idParentProduct;
    xProd.Free;
  end;
  Result := '';
  for xCount := xStr.Count - 1 downto 0 do begin
    Result := Result + xStr.Strings[xCount];
    if xCount <> 0 then begin
      Result := Result + '\';
    end;
  end;
  xStr.Free;
end;

class function TProduct.HasSubcategory(AId: TDataGid): Boolean;
begin
  Result := GDataProvider.GetSqlInteger('select count(*) from product where idParentProduct = ' + DataGidToDatabase(AId), 0) <> 0;
end;

procedure TProduct.Setdescription(const Value: TBaseDescription);
begin
  if Fdescription <> Value then begin
    Fdescription := Value;
    SetState(msModified);
  end;
end;

procedure TProduct.SetidParentProduct(const Value: TDataGid);
begin
  if FidParentProduct <> Value then begin
    FidParentProduct := Value;
    SetState(msModified);
  end;
end;

procedure TProduct.Setname(const Value: TBaseName);
begin
  if Fname <> Value then begin
    Fname := Value;
    SetState(msModified);
  end;
end;

procedure TProduct.SetproductType(const Value: TBaseEnumeration);
begin
  if FproductType <> Value then begin
    FproductType := Value;
    SetState(msModified);
  end;
end;

procedure TProduct.UpdateFieldList;
begin
  inherited UpdateFieldList;
  with DataFieldList do begin
    AddField('name', Fname, True, 'product');
    AddField('description', Fdescription, True, 'product');
    AddField('idParentProduct', DataGidToDatabase(FidParentProduct), False, 'product');
    AddField('productType', FproductType, True, 'product');
  end;
end;

procedure TBaseMovement.FromDataset(ADataset: TADOQuery);
begin
  inherited FromDataset(ADataset);
  with ADataset do begin
    Fdescription := FieldByName('description').AsString;
    Fcash := FieldByName('cash').AsCurrency;
    FprevCash := Fcash;
    FmovementType := FieldByName('movementType').AsString;
    FidAccount := FieldByName('idAccount').AsString;
    FprevIdAccount := FidAccount;
    FregDate := FieldByName('regDate').AsDateTime;
    FweekDate := FieldByName('weekDate').AsDateTime;
    FmonthDate := FieldByName('monthDate').AsDateTime;
    FyearDate := FieldByName('yearDate').AsDateTime;
    FidSourceAccount := FieldByName('idSourceAccount').AsString;
    FprevIdSourceAccount := FidSourceAccount;
    FidCashPoint := FieldByName('idCashPoint').AsString;
    FidProduct := FieldByName('idProduct').AsString;
    FidPlannedDone := FieldByName('idPlannedDone').AsString;
    FidMovementList := FieldByName('idMovementList').AsString;
  end;
end;

procedure TBaseMovement.Setcash(const Value: Currency);
begin
  if Fcash <> Value then begin
    Fcash := Value;
    SetState(msModified);
  end;
end;

procedure TBaseMovement.Setdescription(const Value: TBaseDescription);
begin
  if Fdescription <> Value then begin
    Fdescription := Value;
    SetState(msModified);
  end;
end;

procedure TBaseMovement.SetidAccount(const Value: TDataGid);
begin
  if FidAccount <> Value then begin
    FidAccount := Value;
    SetState(msModified);
  end;
end;

procedure TBaseMovement.SetidSourceAccount(const Value: TDataGid);
begin
  if FidSourceAccount <> Value then begin
    FidSourceAccount := Value;
    SetState(msModified);
  end;
end;

procedure TBaseMovement.SetmovementType(const Value: TBaseEnumeration);
begin
  if FmovementType <> Value then begin
    FmovementType := Value;
    SetState(msModified);
  end;
end;

procedure TBaseMovement.SetregDate(const Value: TDateTime);
begin
  if FregDate <> Value then begin
    FregDate := Value;
    FyearDate := StartOfTheYear(FregDate);
    FmonthDate := StartOfTheMonth(FregDate);
    FweekDate := StartOfTheWeek(FregDate);
    SetState(msModified);
  end;
end;

procedure TBaseMovement.UpdateFieldList;
begin
  inherited UpdateFieldList;
  with DataFieldList do begin
    AddField('description', Fdescription, True, 'baseMovement');
    AddField('cash', CurrencyToDatabase(Fcash), False, 'baseMovement');
    AddField('movementType', FmovementType, True, 'baseMovement');
    AddField('idAccount', DataGidToDatabase(FidAccount), False, 'baseMovement');
    AddField('regDate', DatetimeToDatabase(FregDate, False), False, 'baseMovement');
    AddField('weekDate', DatetimeToDatabase(FweekDate, False), False, 'baseMovement');
    AddField('yearDate', DatetimeToDatabase(FyearDate, False), False, 'baseMovement');
    AddField('monthDate', DatetimeToDatabase(FmonthDate, False), False, 'baseMovement');
    AddField('idSourceAccount', DataGidToDatabase(FidSourceAccount), False, 'baseMovement');
    AddField('idCashPoint', DataGidToDatabase(FidCashPoint), False, 'baseMovement');
    AddField('idProduct', DataGidToDatabase(FidProduct), False, 'baseMovement');
    AddField('idPlannedDone', DataGidToDatabase(FidPlannedDone), False, 'baseMovement');
    AddField('idMovementList', DataGidToDatabase(FidMovementList), False, 'baseMovement');
  end;
end;

procedure TBaseMovement.SetidCashPoint(const Value: TDataGid);
begin
  if FidCashPoint <> Value then begin
    FidCashPoint := Value;
    SetState(msModified);
  end;
end;

procedure TBaseMovement.SetidProduct(const Value: TDataGid);
begin
  if FidProduct <> Value then begin
    FidProduct := Value;
    SetState(msModified);
  end;
end;

procedure TAccount.SetaccountNumber(const Value: TAccountNumber);
begin
  if FaccountNumber <> Value then begin
    FaccountNumber := Value;
    SetState(msModified);
  end;
end;

procedure TAccount.SetidCashPoint(const Value: TDataGid);
begin
  if FidCashPoint <> Value then begin
    FidCashPoint := Value;
    SetState(msModified);
  end;
end;

procedure TBaseMovement.SetidPlannedDone(const Value: TDataGid);
begin
  if FidPlannedDone <> Value then begin
    FidPlannedDone := Value;
    SetState(msModified);
  end;
end;

class function TPlannedMovement.CanBeDeleted(AId: ShortString): Boolean;
var xText: String;
begin
  Result := True;
  if GDataProvider.GetSqlInteger('select count(*) from plannedDone where idPlannedMovement = ' + DataGidToDatabase(AId), 0) <> 0 then begin
    xText := 'istniej¹ zwi¹zane z ni¹ operacje wykonane';
  end;
  if xText <> '' then begin
    ShowInfo(itError, 'Nie mo¿na usun¹æ zaplanowanej operacji, gdy¿ ' + xText, '');
    Result := False;
  end;
end;

constructor TPlannedMovement.Create(AStatic: Boolean);
begin
  inherited Create(AStatic);
  FidAccount := CEmptyDataGid;
  FidCashPoint := CEmptyDataGid;
  FidProduct := CEmptyDataGid;
end;

procedure TPlannedMovement.FromDataset(ADataset: TADOQuery);
var xField: TField;
begin
  inherited FromDataset(ADataset);
  with ADataset do begin
    Fdescription := FieldByName('description').AsString;
    Fcash := FieldByName('cash').AsCurrency;
    FmovementType := FieldByName('movementType').AsString;
    FisActive := FieldByName('isActive').AsBoolean;
    FidAccount := FieldByName('idAccount').AsString;
    FidCashPoint := FieldByName('idCashPoint').AsString;
    FidProduct := FieldByName('idProduct').AsString;
    FscheduleType := FieldByName('scheduleType').AsString;
    FscheduleDate := FieldByName('scheduleDate').AsDateTime;
    FendCondition := FieldByName('endCondition').AsString;
    FendCount := FieldByName('endCount').AsInteger;
    FendDate := FieldByName('endDate').AsDateTime;
    FtriggerType := FieldByName('triggerType').AsString;
    FtriggerDay := FieldByName('triggerDay').AsInteger;
    xField := FindField('doneCount');
    if xField <> Nil then begin
      FdoneCount := xField.AsInteger;
    end;
  end;
end;

procedure TPlannedMovement.Setcash(const Value: Currency);
begin
  if Fcash <> Value then begin
    Fcash := Value;
    SetState(msModified);
  end;
end;

procedure TPlannedMovement.Setdescription(const Value: TBaseDescription);
begin
  if Fdescription <> Value then begin
    Fdescription := Value;
    SetState(msModified);
  end;
end;

procedure TPlannedMovement.SetendCondition(const Value: TBaseEnumeration);
begin
  if FendCondition <> Value then begin
    FendCondition := Value;
    SetState(msModified);
  end;
end;

procedure TPlannedMovement.SetendCount(const Value: Integer);
begin
  if FendCount <> Value then begin
    FendCount := Value;
    SetState(msModified);
  end;
end;

procedure TPlannedMovement.SetendDate(const Value: TDateTime);
begin
  if FendDate <> Value then begin
    FendDate := Value;
    SetState(msModified);
  end;
end;

procedure TPlannedMovement.SetidAccount(const Value: TDataGid);
begin
  if FidAccount <> Value then begin
    FidAccount := Value;
    SetState(msModified);
  end;
end;

procedure TPlannedMovement.SetidCashPoint(const Value: TDataGid);
begin
  if FidCashPoint <> Value then begin
    FidCashPoint := Value;
    SetState(msModified);
  end;
end;

procedure TPlannedMovement.SetidProduct(const Value: TDataGid);
begin
  if FidProduct <> Value then begin
    FidProduct := Value;
    SetState(msModified);
  end;
end;

procedure TPlannedMovement.SetisActive(const Value: Boolean);
begin
  if FisActive <> Value then begin
    FisActive := Value;
    SetState(msModified);
  end;
end;

procedure TPlannedMovement.SetmovementType(const Value: TBaseEnumeration);
begin
  if FmovementType <> Value then begin
    FmovementType := Value;
    SetState(msModified);
  end;
end;

procedure TPlannedMovement.SetscheduleDate(const Value: TDateTime);
begin
  if FscheduleDate <> Value then begin
    FscheduleDate := Value;
    SetState(msModified);
  end;
end;

procedure TPlannedMovement.SetscheduleType(const Value: TBaseEnumeration);
begin
  if FscheduleType <> Value then begin
    FscheduleType := Value;
    SetState(msModified);
  end;
end;

procedure TPlannedMovement.SettriggerDay(const Value: Integer);
begin
  if FtriggerDay <> Value then begin
    FtriggerDay := Value;
    SetState(msModified);
  end;
end;

procedure TPlannedMovement.SettriggerType(const Value: TBaseEnumeration);
begin
  if FtriggerType <> Value then begin
    FtriggerType := Value;
    SetState(msModified);
  end;
end;

procedure TPlannedMovement.UpdateFieldList;
begin
  inherited UpdateFieldList;
  with DataFieldList do begin
    AddField('description', Fdescription, True, 'plannedMovement');
    AddField('cash', CurrencyToDatabase(Fcash), False, 'plannedMovement');
    AddField('movementType', FmovementType, True, 'plannedMovement');
    AddField('isActive', IntToStr(Integer(FisActive)), False, 'plannedMovement');
    AddField('idAccount', DataGidToDatabase(FidAccount), False, 'plannedMovement');
    AddField('idCashPoint', DataGidToDatabase(FidCashPoint), False, 'plannedMovement');
    AddField('idProduct', DataGidToDatabase(FidProduct), False, 'plannedMovement');
    AddField('scheduleType', FscheduleType, True, 'plannedMovement');
    AddField('scheduleDate', DatetimeToDatabase(FscheduleDate, False), False, 'plannedMovement');
    AddField('endCondition', FendCondition, True, 'plannedMovement');
    AddField('endCount', IntToStr(FendCount), False, 'plannedMovement');
    AddField('endDate', DatetimeToDatabase(FendDate, False), False, 'plannedMovement');
    AddField('triggerType', FtriggerType, True, 'plannedMovement');
    AddField('triggerDay', IntToStr(FtriggerDay), False, 'plannedMovement');
  end;
end;

constructor TPlannedDone.Create(AStatic: Boolean);
begin
  inherited Create(AStatic);
  FidPlannedMovement := CEmptyDataGid;
end;

procedure TPlannedDone.FromDataset(ADataset: TADOQuery);
begin
  inherited FromDataset(ADataset);
  with ADataset do begin
    FtriggerDate := FieldByName('triggerDate').AsDateTime;
    FdoneDate := FieldByName('doneDate').AsDateTime;
    FidPlannedMovement := FieldByName('idPlannedMovement').AsString;
    FdoneState := FieldByName('doneState').AsString;
    Fdescription := FieldByName('description').AsString;
    Fcash := FieldByName('cash').AsCurrency;
  end;
end;

procedure TPlannedDone.Setcash(const Value: Currency);
begin
  if Fcash <> Value then begin
    Fcash := Value;
    SetState(msModified);
  end;
end;

procedure TPlannedDone.Setdescription(const Value: TBaseDescription);
begin
  if Fdescription <> Value then begin
    Fdescription := Value;
    SetState(msModified);
  end;
end;

procedure TPlannedDone.SetdoneDate(const Value: TDateTime);
begin
  if FdoneDate <> Value then begin
    FdoneDate := Value;
    SetState(msModified);
  end;
end;

procedure TPlannedDone.SetdoneState(const Value: TBaseEnumeration);
begin
  if FdoneState <> Value then begin
    FdoneState := Value;
    SetState(msModified);
  end;
end;

procedure TPlannedDone.SetidPlannedMovement(const Value: TDataGid);
begin
  if FidPlannedMovement <> Value then begin
    FidPlannedMovement := Value;
    SetState(msModified);
  end;
end;

procedure TPlannedDone.SettriggerDate(const Value: TDateTime);
begin
  if FtriggerDate <> Value then begin
    FtriggerDate := Value;
    SetState(msModified);
  end;
end;

procedure TPlannedDone.UpdateFieldList;
begin
  inherited UpdateFieldList;
  with DataFieldList do begin
    AddField('triggerDate', DatetimeToDatabase(FtriggerDate, False), False, 'plannedDone');
    AddField('doneDate', DatetimeToDatabase(FdoneDate, False), False, 'plannedDone');
    AddField('idPlannedMovement', DataGidToDatabase(FidPlannedMovement), False, 'plannedDone');
    AddField('doneState', FdoneState, True, 'plannedDone');
    AddField('description', Fdescription, True, 'plannedDone');
    AddField('cash', CurrencyToDatabase(Fcash), False, 'plannedDone');
  end;
end;

class function TAccount.CanBeDeleted(AId: ShortString): Boolean;
var xText: String;
begin
  Result := True;
  if GDataProvider.GetSqlInteger('select count(*) from plannedMovement where idAccount = ' + DataGidToDatabase(AId), 0) <> 0 then begin
    xText := 'istniej¹ zwi¹zane z nim zaplanowane operacje';
  end else if GDataProvider.GetSqlInteger('select count(*) from baseMovement where idAccount = ' + DataGidToDatabase(AId), 0) <> 0 then begin
    xText := 'istniej¹ zwi¹zane z nim wykonane operacje';
  end else if GDataProvider.GetSqlInteger('select count(*) from accountFilter where idAccount = ' + DataGidToDatabase(AId), 0) <> 0 then begin
    xText := 'istniej¹ zwi¹zane z nim filtry';
  end else if GDataProvider.GetSqlInteger('select count(*) from profile where idAccount = ' + DataGidToDatabase(AId), 0) <> 0 then begin
    xText := 'istniej¹ zwi¹zane z nim profile';
  end;
  if xText <> '' then begin
    ShowInfo(itError, 'Nie mo¿na usun¹æ konta, gdy¿ ' + xText, '');
    Result := False;
  end;
end;

class function TAccount.AccountBalanceOnDay(AIdAccount: TDataGid; ADateTime: TDateTime): Currency;
var xQ: TADOQuery;
begin
  xQ := GDataProvider.OpenSql(Format(
             'select tr.*, a.cash as base from (select sum(cash) as inout from transactions where idAccount = %s and regDate > %s) as tr, ' +
             '                         account a where idAccount = %s',
             [DataGidToDatabase(AIdAccount), DatetimeToDatabase(ADateTime, False), DataGidToDatabase(AIdAccount)]));
  if not xQ.IsEmpty then begin
    Result := xQ.FieldByName('base').AsCurrency  - xQ.FieldByName('inout').AsCurrency;
  end else begin
    Result := 0;
  end;
  xQ.Free;
end;

procedure TMovementFilter.AfterPost;
begin
  inherited AfterPost;
  UpdateSubfilters;
end;

constructor TMovementFilter.Create(AStatic: Boolean);
begin
  inherited Create(AStatic);
  Faccounts := TStringList.Create;
  Fproducts := TStringList.Create;
  Fcashpoints := TStringList.Create;
  FisLoaded := False;
end;

procedure TMovementFilter.DeleteObject;
begin
  inherited DeleteObject;
  DeleteSubfilters;
end;

procedure TMovementFilter.DeleteSubfilters;
begin
  GDataProvider.ExecuteSql('delete from accountFilter where idMovementFilter = ' + DataGidToDatabase(id));
  GDataProvider.ExecuteSql('delete from cashpointFilter where idMovementFilter = ' + DataGidToDatabase(id));
  GDataProvider.ExecuteSql('delete from productFilter where idMovementFilter = ' + DataGidToDatabase(id));
end;

destructor TMovementFilter.Destroy;
begin
  Fproducts.Free;
  Faccounts.Free;
  Fcashpoints.Free;
  inherited Destroy;
end;

procedure TMovementFilter.FillFilterList(AList: TStringList; AQuery: TADOQuery);
begin
  AList.Clear;
  while not AQuery.Eof do begin
    AList.Add(AQuery.FieldByName('filtered').AsString);
    AQuery.Next;
  end;
end;

procedure TMovementFilter.FromDataset(ADataset: TADOQuery);
begin
  inherited FromDataset(ADataset);
  with ADataset do begin
    Fname := FieldByName('name').AsString;
    Fdescription := FieldByName('description').AsString;
  end;
end;

class function TMovementFilter.GetFilterCondition(AIdFilter: TDataGid; AWithAnd: Boolean; AAcountField, ACashpointField, ACategoryField: String): String;
var xFilter: TMovementFilter;
    xAccountsPart, xCashpointsPart, xProductsPart: String;
begin
  Result := '';
  if AIdFilter <> CEmptyDataGid then begin
    GDataProvider.BeginTransaction;
    xFilter := TMovementFilter(TMovementFilter.LoadObject(MovementFilterProxy, AIdFilter, False));
    xFilter.LoadSubfilters;
    if xFilter.Faccounts.Count <> 0 then begin
      xAccountsPart := AAcountField + ' in (select idAccount from accountFilter where idMovementFilter = ' + DataGidToDatabase(AIdFilter) + ')';
    end else begin
      xAccountsPart := '';
    end;
    if xFilter.Fcashpoints.Count <> 0 then begin
      xCashpointsPart := ACashpointField + ' in (select idCashpoint from cashpointFilter where idMovementFilter = ' + DataGidToDatabase(AIdFilter) + ')';
    end else begin
      xCashpointsPart := '';
    end;
    if xFilter.Fproducts.Count <> 0 then begin
      xProductsPart := ACategoryField + ' in (select idProduct from productFilter where idMovementFilter = ' + DataGidToDatabase(AIdFilter) + ')';
    end else begin
      xProductsPart := '';
    end;
    Result := xAccountsPart;
    if xCashpointsPart <> '' then begin
      if Result <> '' then begin
        Result := Result + ' and ';
      end;
      Result := Result + xCashpointsPart;
    end;
    if xProductsPart <> '' then begin
      if Result <> '' then begin
        Result := Result + ' and ';
      end;
      Result := Result + xProductsPart;
    end;
    if (Result <> '') and AWithAnd then begin
      Result := ' and ' + Result;
    end;
    GDataProvider.RollbackTransaction;
  end;
end;

function TMovementFilter.IsValid(AAccountId, ACashpointId, AProductId: TDataGid): Boolean;
begin
  Result := True;
  if Result and (AAccountId <> CEmptyDataGid) and (Faccounts.Count > 0) then begin
    Result := Faccounts.IndexOf(AAccountId) > -1;
  end;
  if Result and (ACashpointId <> CEmptyDataGid) and (Fcashpoints.Count > 0) then begin
    Result := Faccounts.IndexOf(ACashpointId) > -1;
  end;
  if Result and (AProductId <> CEmptyDataGid) and (Fproducts.Count > 0) then begin
    Result := Fproducts.IndexOf(AProductId) > -1;
  end;
end;

procedure TMovementFilter.LoadSubfilters;
var xQ: TADOQuery;
begin
  if not FisLoaded then begin
    xQ := GDataProvider.OpenSql('select idAccount as filtered from accountFilter where idMovementFilter = ' + DataGidToDatabase(id));
    FillFilterList(Faccounts, xQ);
    xQ.Free;
    xQ := GDataProvider.OpenSql('select idCashpoint as filtered from cashpointFilter where idMovementFilter = ' + DataGidToDatabase(id));
    FillFilterList(Fcashpoints, xQ);
    xQ.Free;
    xQ := GDataProvider.OpenSql('select idProduct as filtered from productFilter where idMovementFilter = ' + DataGidToDatabase(id));
    FillFilterList(Fproducts, xQ);
    xQ.Free;
    FisLoaded := True;
  end;
end;

procedure TMovementFilter.Setaccounts(const Value: TStringList);
begin
  if Faccounts.Text <> Value.Text then begin
    Faccounts.Text := Value.Text;
    SetState(msModified);
  end;
end;

procedure TMovementFilter.Setcashpoints(const Value: TStringList);
begin
  if Fcashpoints.Text <> Value.Text then begin
    Fcashpoints.Text := Value.Text;
    SetState(msModified);
  end;
end;

procedure TMovementFilter.Setdescription(const Value: TBaseDescription);
begin
  if Value <> Fdescription then begin
    Fdescription := Value;
    SetState(msModified);
  end;
end;

procedure TMovementFilter.Setname(const Value: TBaseName);
begin
  if Value <> Fname then begin
    Fname := Value;
    SetState(msModified);
  end;
end;

procedure TMovementFilter.Setproducts(const Value: TStringList);
begin
  if Fproducts.Text <> Value.Text then begin
    Fproducts.Text := Value.Text;
    SetState(msModified);
  end;
end;

procedure TMovementFilter.UpdateFieldList;
begin
  inherited UpdateFieldList;
  with DataFieldList do begin
    AddField('name', Fname, True, 'movementFilter');
    AddField('description', Fdescription, True, 'movementFilter');
  end;
end;

procedure TMovementFilter.UpdateSubfilters;
var xCount: Integer;
begin
  DeleteSubfilters;
  for xCount := 0 to FProducts.Count - 1 do begin
    GDataProvider.ExecuteSql(Format(
           'insert into productFilter (idMovementFilter, idProduct) values (%s, %s)',
           [DataGidToDatabase(id), DataGidToDatabase(FProducts.Strings[xCount])]));
  end;
  for xCount := 0 to FAccounts.Count - 1 do begin
    GDataProvider.ExecuteSql(Format(
           'insert into accountFilter (idMovementFilter, idAccount) values (%s, %s)',
           [DataGidToDatabase(id), DataGidToDatabase(FAccounts.Strings[xCount])]));
  end;
  for xCount := 0 to FCashpoints.Count - 1 do begin
    GDataProvider.ExecuteSql(Format(
           'insert into cashpointFilter (idMovementFilter, idCashpoint) values (%s, %s)',
           [DataGidToDatabase(id), DataGidToDatabase(FCashpoints.Strings[xCount])]));
  end;
end;

procedure TProfile.DeleteObject;
begin
  if GActiveProfileId = id then begin
    GActiveProfileId := CEmptyDataGid;
  end;
  inherited DeleteObject;
end;

procedure TProfile.FromDataset(ADataset: TADOQuery);
begin
  inherited FromDataset(ADataset);
  with ADataset do begin
    Fname := FieldByName('name').AsString;
    Fdescription := FieldByName('description').AsString;
    FidAccount := FieldByName('idAccount').AsString;
    FidCashPoint := FieldByName('idCashPoint').AsString;
    FidProduct := FieldByName('idProduct').AsString;
  end;
end;

procedure TProfile.Setdescription(const Value: TBaseDescription);
begin
  if Fdescription <> Value then begin
    Fdescription := Value;
    SetState(msModified);
  end;
end;

procedure TProfile.SetidAccount(const Value: TDataGid);
begin
  if FidAccount <> Value then begin
    FidAccount := Value;
    SetState(msModified);
  end;
end;

procedure TProfile.SetidCashPoint(const Value: TDataGid);
begin
  if FidCashPoint <> Value then begin
    FidCashPoint := Value;
    SetState(msModified);
  end;
end;

procedure TProfile.SetidProduct(const Value: TDataGid);
begin
  if FidProduct <> Value then begin
    FidProduct := Value;
    SetState(msModified);
  end;
end;

procedure TProfile.Setname(const Value: TBaseName);
begin
  if Fname <> Value then begin
    Fname := Value;
    SetState(msModified);
  end;
end;

procedure TProfile.UpdateFieldList;
begin
  inherited UpdateFieldList;
  with DataFieldList do begin
    AddField('name', Fname, True, 'profile');
    AddField('description', Fdescription, True, 'profile');
    AddField('idAccount', DataGidToDatabase(FidAccount), False, 'profile');
    AddField('idCashPoint', DataGidToDatabase(FidCashPoint), False, 'profile');
    AddField('idProduct', DataGidToDatabase(FidProduct), False, 'profile');
  end;
end;

procedure TBaseMovement.SetidMovementList(const Value: TDataGid);
begin
  if FidMovementList <> Value then begin
    FidMovementList := Value;
    SetState(msModified);
  end;
end;

procedure TMovementList.DeleteObject;
begin
  GDataProvider.ExecuteSql('delete from baseMovement where idMovementList = ' + DataGidToDatabase(id));
  inherited DeleteObject;
end;

procedure TMovementList.FromDataset(ADataset: TADOQuery);
begin
  inherited FromDataset(ADataset);
  with ADataset do begin
    Fdescription := FieldByName('description').AsString;
    FidAccount := FieldByName('idAccount').AsString;
    FprevIdAccount := FidAccount;
    FregDate := FieldByName('regDate').AsDateTime;
    FweekDate := FieldByName('weekDate').AsDateTime;
    FmonthDate := FieldByName('monthDate').AsDateTime;
    FyearDate := FieldByName('yearDate').AsDateTime;
    FidCashPoint := FieldByName('idCashPoint').AsString;
    FmovementType := FieldByName('movementType').AsString;
    Fcash := FieldByName('cash').AsCurrency;
    FprevCash := Fcash;
  end;
end;

function TMovementList.GetMovements: TDataObjectList;
begin
  Result := TMovementList.GetList(TBaseMovement, BaseMovementProxy, 'select * from baseMovement where idmovementList = ' + DataGidToDatabase(id));
end;

function TMovementList.OnDeleteObject(AProxy: TDataProxy): Boolean;
begin
  Result := inherited OnDeleteObject(AProxy);
  AProxy.DataProvider.ExecuteSql('delete from baseMovement where idMovementList = ' + DataGidToDatabase(id));
  if movementType = CInMovement then begin
    AProxy.DataProvider.ExecuteSql('update account set cash = cash - ' + CurrencyToDatabase(cash) + ' where idAccount = ' + DataGidToDatabase(idAccount));
  end else if movementType = COutMovement then begin
    AProxy.DataProvider.ExecuteSql('update account set cash = cash + ' + CurrencyToDatabase(cash) + ' where idAccount = ' + DataGidToDatabase(idAccount));
  end;
end;

procedure TMovementList.Setdescription(const Value: TBaseDescription);
begin
  if Fdescription <> Value then begin
    Fdescription := Value;
    SetState(msModified);
  end;
end;

procedure TMovementList.SetidAccount(const Value: TDataGid);
begin
  if FidAccount <> Value then begin
    FidAccount := Value;
    SetState(msModified);
  end;
end;

procedure TMovementList.SetidCashPoint(const Value: TDataGid);
begin
  if FidCashPoint <> Value then begin
    FidCashPoint := Value;
    SetState(msModified);
  end;
end;

procedure TMovementList.SetmovementType(const Value: TBaseEnumeration);
begin
  if FmovementType <> Value then begin
    FmovementType := Value;
    SetState(msModified);
  end;
end;

procedure TMovementList.SetregDate(const Value: TDateTime);
begin
  if FregDate <> Value then begin
    FregDate := Value;
    FyearDate := StartOfTheYear(FregDate);
    FmonthDate := StartOfTheMonth(FregDate);
    FweekDate := StartOfTheWeek(FregDate);
    SetState(msModified);
  end;
end;

procedure TMovementList.UpdateFieldList;
begin
  inherited UpdateFieldList;
  with DataFieldList do begin
    AddField('description', Fdescription, True, 'movementList');
    AddField('idAccount', DataGidToDatabase(FidAccount), False, 'movementList');
    AddField('regDate', DatetimeToDatabase(FregDate, False), False, 'movementList');
    AddField('weekDate', DatetimeToDatabase(FweekDate, False), False, 'movementList');
    AddField('yearDate', DatetimeToDatabase(FyearDate, False), False, 'movementList');
    AddField('monthDate', DatetimeToDatabase(FmonthDate, False), False, 'movementList');
    AddField('idCashPoint', DataGidToDatabase(FidCashPoint), False, 'movementList');
    AddField('movementType', FmovementType, True, 'movementList');
    AddField('cash', CurrencyToDatabase(Fcash), False, 'movementList');
  end;
end;

constructor TBaseMovement.Create(AStatic: Boolean);
begin
  inherited Create(AStatic);
  FidMovementList := CEmptyDataGid;
  FidAccount := CEmptyDataGid;
  FidSourceAccount := CEmptyDataGid;
  FidCashPoint := CEmptyDataGid;
  FidPlannedDone := CEmptyDataGid;
  FidProduct := CEmptyDataGid;
end;

function TBaseMovement.OnDeleteObject(AProxy: TDataProxy): Boolean;
begin
  Result := inherited OnDeleteObject(AProxy);
  if idMovementList <> CEmptyDataGid then begin
    AProxy.DataProvider.ExecuteSql('update movementList set cash = cash - ' + CurrencyToDatabase(cash) + ' where idmovementList = ' + DataGidToDatabase(idMovementList));
  end;
  if idPlannedDone <> CEmptyDataGid then begin
    AProxy.DataProvider.ExecuteSql('delete from plannedDone where idPlannedDone = ' + DataGidToDatabase(idPlannedDone));
  end;
  if movementType = CTransferMovement then begin
    AProxy.DataProvider.ExecuteSql('update account set cash = cash - ' + CurrencyToDatabase(cash) + ' where idAccount = ' + DataGidToDatabase(idAccount));
    AProxy.DataProvider.ExecuteSql('update account set cash = cash + ' + CurrencyToDatabase(cash) + ' where idAccount = ' + DataGidToDatabase(idSourceAccount));
  end else if movementType = CInMovement then begin
    AProxy.DataProvider.ExecuteSql('update account set cash = cash - ' + CurrencyToDatabase(cash) + ' where idAccount = ' + DataGidToDatabase(idAccount));
  end else if movementType = COutMovement then begin
    AProxy.DataProvider.ExecuteSql('update account set cash = cash + ' + CurrencyToDatabase(cash) + ' where idAccount = ' + DataGidToDatabase(idAccount));
  end;
end;

function TBaseMovement.OnInsertObject(AProxy: TDataProxy): Boolean;
begin
  Result := inherited OnDeleteObject(AProxy);
  if idMovementList <> CEmptyDataGid then begin
    AProxy.DataProvider.ExecuteSql('update movementList set cash = cash + ' + CurrencyToDatabase(cash) + ' where idmovementList = ' + DataGidToDatabase(idMovementList));
  end;
  if movementType = CTransferMovement then begin
    AProxy.DataProvider.ExecuteSql('update account set cash = cash + ' + CurrencyToDatabase(cash) + ' where idAccount = ' + DataGidToDatabase(idAccount));
    AProxy.DataProvider.ExecuteSql('update account set cash = cash - ' + CurrencyToDatabase(cash) + ' where idAccount = ' + DataGidToDatabase(idSourceAccount));
  end else if movementType = CInMovement then begin
    AProxy.DataProvider.ExecuteSql('update account set cash = cash + ' + CurrencyToDatabase(cash) + ' where idAccount = ' + DataGidToDatabase(idAccount));
  end else if movementType = COutMovement then begin
    AProxy.DataProvider.ExecuteSql('update account set cash = cash - ' + CurrencyToDatabase(cash) + ' where idAccount = ' + DataGidToDatabase(idAccount));
  end;
end;

function TBaseMovement.OnUpdateObject(AProxy: TDataProxy): Boolean;
begin
  Result := inherited OnUpdateObject(AProxy);
  if idMovementList <> CEmptyDataGid then begin
    AProxy.DataProvider.ExecuteSql('update movementList set cash = cash + ' + CurrencyToDatabase(cash - FprevCash) + ' where idmovementList = ' + DataGidToDatabase(idMovementList));
  end;
  if movementType = CTransferMovement then begin
    if FidAccount <> FprevIdAccount then begin
      AProxy.DataProvider.ExecuteSql('update account set cash = cash - ' + CurrencyToDatabase(FprevCash) + ' where idAccount = ' + DataGidToDatabase(FprevIdAccount));
      AProxy.DataProvider.ExecuteSql('update account set cash = cash + ' + CurrencyToDatabase(cash) + ' where idAccount = ' + DataGidToDatabase(FidAccount));
    end else begin
      AProxy.DataProvider.ExecuteSql('update account set cash = cash + ' + CurrencyToDatabase(cash - FprevCash) + ' where idAccount = ' + DataGidToDatabase(FidAccount));
    end;
    if FidSourceAccount <> FprevIdSourceAccount then begin
      AProxy.DataProvider.ExecuteSql('update account set cash = cash + ' + CurrencyToDatabase(FprevCash) + ' where idAccount = ' + DataGidToDatabase(FprevIdSourceAccount));
      AProxy.DataProvider.ExecuteSql('update account set cash = cash - ' + CurrencyToDatabase(cash) + ' where idAccount = ' + DataGidToDatabase(FidSourceAccount));
    end else begin
      AProxy.DataProvider.ExecuteSql('update account set cash = cash - ' + CurrencyToDatabase(cash - FprevCash) + ' where idAccount = ' + DataGidToDatabase(FidSourceAccount));
    end;
  end else if movementType = CInMovement then begin
    if FidAccount <> FprevIdAccount then begin
      AProxy.DataProvider.ExecuteSql('update account set cash = cash - ' + CurrencyToDatabase(FprevCash) + ' where idAccount = ' + DataGidToDatabase(FprevIdAccount));
      AProxy.DataProvider.ExecuteSql('update account set cash = cash + ' + CurrencyToDatabase(cash) + ' where idAccount = ' + DataGidToDatabase(idAccount));
    end else begin
      AProxy.DataProvider.ExecuteSql('update account set cash = cash + ' + CurrencyToDatabase(cash - FprevCash) + ' where idAccount = ' + DataGidToDatabase(idAccount));
    end;
  end else if movementType = COutMovement then begin
    if FidAccount <> FprevIdAccount then begin
      AProxy.DataProvider.ExecuteSql('update account set cash = cash + ' + CurrencyToDatabase(FprevCash) + ' where idAccount = ' + DataGidToDatabase(FprevIdAccount));
      AProxy.DataProvider.ExecuteSql('update account set cash = cash - ' + CurrencyToDatabase(cash) + ' where idAccount = ' + DataGidToDatabase(idAccount));
    end else begin
      AProxy.DataProvider.ExecuteSql('update account set cash = cash - ' + CurrencyToDatabase(cash - FprevCash) + ' where idAccount = ' + DataGidToDatabase(idAccount));
    end;
  end;
end;

class function TAccount.GetMovementCount(AIdAccount: TDataGid): Integer;
begin
  Result := GDataProvider.GetSqlInteger(Format('select count(*) from baseMovement where idAccount = %s or idSourceAccount = %s',
      [DataGidToDatabase(AIdAccount), DataGidToDatabase(AIdAccount)]), 0);
end;

procedure TAccount.SetinitialBalance(const Value: Currency);
begin
  if FinitialBalance <> Value then begin
    FinitialBalance := Value;
    SetState(msModified);
  end;
end;

end.
