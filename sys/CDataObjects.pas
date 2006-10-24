unit CDataObjects;

interface

uses CDatabase, SysUtils, AdoDb, Classes;

const
  CInMovement = 'I';
  COutMovement = 'O';
  CTransferMovement = 'T';
  CInProduct = 'I';
  COutProduct = 'O';
  CBankAccount = 'B';
  CCashAccount = 'C';
  CScheduleTypeOnce = 'O';
  CScheduleTypeCyclic = 'C';
  CEndConditionTimes = 'T';
  CEndConditionDate = 'D';
  CEndConditionNever = 'N';
  CTriggerTypeWeekly = 'W';
  CTriggerTypeMonthly = 'M';
  CDoneOperation = 'O';
  CDoneDeleted = 'D';
  CDoneAccepted = 'A';

type
  TBaseName = string[40];
  TBaseDescription = string[200];
  TAccountNumber = string[50];
  TBaseEnumeration = string[1];

  TCashPoint = class(TDataObject)
  private
    Fname: TBaseName;
    Fdescription: TBaseDescription;
    procedure Setdescription(const Value: TBaseDescription);
    procedure Setname(const Value: TBaseName);
  public
    procedure UpdateFieldList; override;
    procedure FromDataset(ADataset: TADOQuery); override;
    class function CanBeDeleted(AId: ShortString): Boolean; override;
  published
    property name: TBaseName read Fname write Setname;
    property description: TBaseDescription read Fdescription write Setdescription;
  end;

  TAccount = class(TDataObject)
  private
    Fname: TBaseName;
    Fdescription: TBaseDescription;
    FaccountType: TBaseEnumeration;
    Fcash: Currency;
    FaccountNumber: TAccountNumber;
    FidCashPoint: TDataGid;
    procedure Setdescription(const Value: TBaseDescription);
    procedure Setname(const Value: TBaseName);
    procedure Setcash(const Value: Currency);
    procedure SetaccountType(const Value: TBaseEnumeration);
    procedure SetaccountNumber(const Value: TAccountNumber);
    procedure SetidCashPoint(const Value: TDataGid);
  public
    procedure UpdateFieldList; override;
    procedure FromDataset(ADataset: TADOQuery); override;
    class function CanBeDeleted(AId: ShortString): Boolean; override;
  published
    property name: TBaseName read Fname write Setname;
    property description: TBaseDescription read Fdescription write Setdescription;
    property accountType: TBaseEnumeration read FaccountType write SetaccountType;
    property cash: Currency read Fcash write Setcash;
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
  published
    property name: TBaseName read Fname write Setname;
    property description: TBaseDescription read Fdescription write Setdescription;
    property idParentProduct: TDataGid read FidParentProduct write SetidParentProduct;
    property treeDesc: String read GettreeDesc;
    property productType: TBaseEnumeration read FproductType write SetproductType;
  end;

  TBaseMovement = class(TDataObject)
  private
    Fdescription: TBaseDescription;
    Fcash: Currency;
    FmovementType: TBaseEnumeration;
    FidAccount: TDataGid;
    FregDate: TDateTime;
    FweekNumber: Integer;
    FmonthNumber: Integer;
    FdayNumber: Integer;
    FyearNumber: Integer;
    FidSourceAccount: TDataGid;
    FidCashPoint: TDataGid;
    FidProduct: TDataGid;
    FidPlannedDone: TDataGid;
    procedure Setcash(const Value: Currency);
    procedure Setdescription(const Value: TBaseDescription);
    procedure SetidAccount(const Value: TDataGid);
    procedure SetmovementType(const Value: TBaseEnumeration);
    procedure SetregDate(const Value: TDateTime);
    procedure SetweekNumber(const Value: Integer);
    procedure SetidSourceAccount(const Value: TDataGid);
    procedure SetidCashPoint(const Value: TDataGid);
    procedure SetidProduct(const Value: TDataGid);
    procedure SetidPlannedDone(const Value: TDataGid);
    procedure SetdayNumber(const Value: Integer);
    procedure SetmonthNumber(const Value: Integer);
    procedure SetyearNumber(const Value: Integer);
  public
    procedure UpdateFieldList; override;
    procedure FromDataset(ADataset: TADOQuery); override;
  published
    property description: TBaseDescription read Fdescription write Setdescription;
    property cash: Currency read Fcash write Setcash;
    property movementType: TBaseEnumeration read FmovementType write SetmovementType;
    property idAccount: TDataGid read FidAccount write SetidAccount;
    property regDate: TDateTime read FregDate write SetregDate;
    property weekNumber: Integer read FweekNumber write SetweekNumber;
    property idSourceAccount: TDataGid read FidSourceAccount write SetidSourceAccount;
    property idCashPoint: TDataGid read FidCashPoint write SetidCashPoint;
    property idProduct: TDataGid read FidProduct write SetidProduct;
    property idPlannedDone: TDataGid read FidPlannedDone write SetidPlannedDone;
    property monthNumber: Integer read FmonthNumber write SetmonthNumber;
    property dayNumber: Integer read FdayNumber write SetdayNumber;
    property yearNumber: Integer read FyearNumber write SetyearNumber;
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
    procedure SetidPlannedMovement(const Value: TDataGid);
    procedure SettriggerDate(const Value: TDateTime);
    procedure SetdoneState(const Value: TBaseEnumeration);
    procedure SetdoneDate(const Value: TDateTime);
    procedure Setdescription(const Value: TBaseDescription);
  public
    procedure UpdateFieldList; override;
    procedure FromDataset(ADataset: TADOQuery); override;
  published
    property triggerDate: TDateTime read FtriggerDate write SettriggerDate;
    property idPlannedMovement: TDataGid read FidPlannedMovement write SetidPlannedMovement;
    property doneState: TBaseEnumeration read FdoneState write SetdoneState;
    property doneDate: TDateTime read FdoneDate write SetdoneDate;
    property description: TBaseDescription read Fdescription write Setdescription;
  end;


var CashPointProxy: TDataProxy;
    AccountProxy: TDataProxy;
    ProductProxy: TDataProxy;
    BaseMovementProxy: TDataProxy;
    PlannedMovementProxy: TDataProxy;
    PlannedDoneProxy: TDataProxy;

procedure InitializeProxies;

implementation

uses DB, CInfoFormUnit;

procedure InitializeProxies;
begin
  CashPointProxy := TDataProxy.Create(GDataProvider, 'cashPoint', Nil);
  AccountProxy := TDataProxy.Create(GDataProvider, 'account', Nil);
  ProductProxy := TDataProxy.Create(GDataProvider, 'product', Nil);
  BaseMovementProxy := TDataProxy.Create(GDataProvider, 'baseMovement', Nil);
  PlannedMovementProxy :=  TDataProxy.Create(GDataProvider, 'plannedMovement', Nil);
  PlannedDoneProxy :=  TDataProxy.Create(GDataProvider, 'plannedDone', Nil);
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
      Result := Result + '/';
    end;
  end;
  xStr.Free;
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
    FmovementType := FieldByName('movementType').AsString;
    FidAccount := FieldByName('idAccount').AsString;
    FregDate := FieldByName('regDate').AsDateTime;
    FweekNumber := FieldByName('weekNumber').AsInteger;
    FmonthNumber := FieldByName('monthNumber').AsInteger;
    FyearNumber := FieldByName('yearNumber').AsInteger;
    FdayNumber := FieldByName('dayNumber').AsInteger;
    FidSourceAccount := FieldByName('idSourceAccount').AsString;
    FidCashPoint := FieldByName('idCashPoint').AsString;
    FidProduct := FieldByName('idProduct').AsString;
    FidPlannedDone := FieldByName('idPlannedDone').AsString;
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
    SetState(msModified);
  end;
end;

procedure TBaseMovement.SetweekNumber(const Value: Integer);
begin
  if FweekNumber <> Value then begin
    FweekNumber := Value;
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
    AddField('regDate', DatetimeToDatabase(FregDate), False, 'baseMovement');
    AddField('weekNumber', IntToStr(FweekNumber), False, 'baseMovement');
    AddField('yearNumber', IntToStr(FyearNumber), False, 'baseMovement');
    AddField('monthNumber', IntToStr(FmonthNumber), False, 'baseMovement');
    AddField('dayNumber', IntToStr(FdayNumber), False, 'baseMovement');
    AddField('idSourceAccount', DataGidToDatabase(FidSourceAccount), False, 'baseMovement');
    AddField('idCashPoint', DataGidToDatabase(FidCashPoint), False, 'baseMovement');
    AddField('idProduct', DataGidToDatabase(FidProduct), False, 'baseMovement');
    AddField('idPlannedDone', DataGidToDatabase(FidPlannedDone), False, 'baseMovement');
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
    AddField('scheduleDate', DatetimeToDatabase(FscheduleDate), False, 'plannedMovement');
    AddField('endCondition', FendCondition, True, 'plannedMovement');
    AddField('endCount', IntToStr(FendCount), False, 'plannedMovement');
    AddField('endDate', DatetimeToDatabase(FendDate), False, 'plannedMovement');
    AddField('triggerType', FtriggerType, True, 'plannedMovement');
    AddField('triggerDay', IntToStr(FtriggerDay), False, 'plannedMovement');
  end;
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
    AddField('triggerDate', DatetimeToDatabase(FtriggerDate), False, 'plannedDone');
    AddField('doneDate', DatetimeToDatabase(FdoneDate), False, 'plannedDone');
    AddField('idPlannedMovement', DataGidToDatabase(FidPlannedMovement), False, 'plannedDone');
    AddField('doneState', FdoneState, True, 'plannedDone');
    AddField('description', Fdescription, True, 'plannedDone');
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
  end;
  if xText <> '' then begin
    ShowInfo(itError, 'Nie mo¿na usun¹æ konta, gdy¿ ' + xText, '');
    Result := False;
  end;
end;

procedure TBaseMovement.SetdayNumber(const Value: Integer);
begin
  if FdayNumber <> Value then begin
    FdayNumber := Value;
    SetState(msModified);
  end;
end;

procedure TBaseMovement.SetmonthNumber(const Value: Integer);
begin
  if FmonthNumber <> Value then begin
    FmonthNumber := Value;
    SetState(msModified);
  end;
end;

procedure TBaseMovement.SetyearNumber(const Value: Integer);
begin
  if FyearNumber <> Value then begin
    FyearNumber := Value;
    SetState(msModified);
  end;
end;

end.
