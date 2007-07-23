
unit CDataObjects;

interface

uses CDatabase, SysUtils, AdoDb, Classes, CConsts, CComponents, Math, Contnrs;

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
    function GetElementHint(AColumnIndex: Integer): String; override;
  published
    property name: TBaseName read Fname write Setname;
    property description: TBaseDescription read Fdescription write Setdescription;
    property cashpointType: TBaseEnumeration read FcashpointType write SetcashpointType;
  end;

  TCurrencyDef = class(TDataObject)
  private
    FpreviousSymbol: TBaseName;
    Fname: TBaseName;
    Fsymbol: TBaseName;
    Fiso: TBaseName;
    Fdescription: TBaseDescription;
    FisBase: Boolean;
    procedure Setdescription(const Value: TBaseDescription);
    procedure Setname(const Value: TBaseName);
    procedure Setiso(const Value: TBaseName);
    procedure Setsymbol(const Value: TBaseName);
    procedure SetisBase(const Value: Boolean);
  public
    procedure UpdateFieldList; override;
    procedure FromDataset(ADataset: TADOQuery); override;
    function GetElementText: String; override;
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean): String; override;
    function GetElementHint(AColumnIndex: Integer): String; override;
    class function CanBeDeleted(AId: ShortString): Boolean; override;
    class function FindByIso(AIso: TBaseName): TCurrencyDef;
    constructor Create(AStatic: Boolean); override;
    procedure AfterPost; override;
  published
    property name: TBaseName read Fname write Setname;
    property symbol: TBaseName read Fsymbol write Setsymbol;
    property iso: TBaseName read Fiso write Setiso;
    property description: TBaseDescription read Fdescription write Setdescription;
    property isBase: Boolean read FisBase write SetisBase;
  end;

  TCurrencyRate = class(TDataObject)
  private
    FidSourceCurrencyDef: TDataGid;
    FidTargetCurrencyDef: TDataGid;
    FidCashpoint: TDataGid;
    Fquantity: Integer;
    Frate: Currency;
    FbindingDate: TDateTime;
    Fdescription: TBaseDescription;
    FrateType: TBaseEnumeration;
    procedure SetbindingDate(const Value: TDateTime);
    procedure SetidCashpoint(const Value: TDataGid);
    procedure SetidSourceCurrencyDef(const Value: TDataGid);
    procedure SetidTargetCurrencyDef(const Value: TDataGid);
    procedure Setquantity(const Value: Integer);
    procedure Setrate(const Value: Currency);
    procedure Setdescription(const Value: TBaseDescription);
    procedure SetrateType(const Value: TBaseEnumeration);
  protected
    function OnDeleteObject(AProxy: TDataProxy): Boolean; override;
  public
    procedure UpdateFieldList; override;
    procedure FromDataset(ADataset: TADOQuery); override;
    function GetElementText: String; override;
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean): String; override;
    function GetElementHint(AColumnIndex: Integer): String; override;
    class function FindRate(ARateType: TBaseEnumeration; ASourceId, ATargetId, ACashpointId: TDataGid; ABindingDate: TDateTime): TCurrencyRate;
    class function GetTypeDesc(AType: TBaseEnumeration): String;
  published
    property idSourceCurrencyDef: TDataGid read FidSourceCurrencyDef write SetidSourceCurrencyDef;
    property idTargetCurrencyDef: TDataGid read FidTargetCurrencyDef write SetidTargetCurrencyDef;
    property idCashpoint: TDataGid read FidCashpoint write SetidCashpoint;
    property quantity: Integer read Fquantity write Setquantity;
    property rate: Currency read Frate write Setrate;
    property bindingDate: TDateTime read FbindingDate write SetbindingDate;
    property description: TBaseDescription read Fdescription write Setdescription;
    property rateType: TBaseEnumeration read FrateType write SetrateType;
  end;

  TCurrencyRateHelper = class(TObject)
  private
    Fquantity: Integer;
    Frate: Currency;
    Fdesc: string;
    FidSourceCurrencyDef: TDataGid;
    FidTargetCurrencyDef: TDataGid;
  public
    constructor Create(Aquantity: Integer; Arate: Currency; ADesc: String; ASourceId, ATargerId: TDataGid);
    function ExchangeCurrency(ACash: Currency; ASourceId, ATargerId: TDataGid): Currency;
    procedure Assign(Aquantity: Integer; Arate: Currency; ADesc: String; ASourceId, ATargerId: TDataGid);
  published
    property quantity: Integer read Fquantity write Fquantity;
    property rate: Currency read Frate write Frate;
    property desc: String read Fdesc write Fdesc;
    property idSourceCurrencyDef: TDataGid read FidSourceCurrencyDef write FidSourceCurrencyDef;
    property idTargetCurrencyDef: TDataGid read FidTargetCurrencyDef write FidTargetCurrencyDef;
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
    FidCurrencyDef: TDataGid;
    procedure Setdescription(const Value: TBaseDescription);
    procedure Setname(const Value: TBaseName);
    procedure Setcash(const Value: Currency);
    procedure SetaccountType(const Value: TBaseEnumeration);
    procedure SetaccountNumber(const Value: TAccountNumber);
    procedure SetidCashPoint(const Value: TDataGid);
    procedure SetinitialBalance(const Value: Currency);
    procedure SetidCurrencyDef(const Value: TDataGid);
  public
    procedure UpdateFieldList; override;
    procedure FromDataset(ADataset: TADOQuery); override;
    class function CanBeDeleted(AId: ShortString): Boolean; override;
    class function AccountBalanceOnDay(AIdAccount: TDataGid; ADateTime: TDateTime): Currency;
    class function GetMovementCount(AIdAccount: TDataGid): Integer;
    class function GetCurrencyDefinition(AIdAccount: TDataGid): TDataGid;
    function GetElementText: String; override;
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean): String; override;
    function GetElementCompare(AColumnIndex: Integer; ACompareWith: TCDataListElementObject): Integer; override;
    function GetElementHint(AColumnIndex: Integer): String; override;
  published
    property name: TBaseName read Fname write Setname;
    property description: TBaseDescription read Fdescription write Setdescription;
    property accountType: TBaseEnumeration read FaccountType write SetaccountType;
    property cash: Currency read Fcash write Setcash;
    property initialBalance: Currency read FinitialBalance write SetinitialBalance;
    property accountNumber: TAccountNumber read FaccountNumber write SetaccountNumber;
    property idCashPoint: TDataGid read FidCashPoint write SetidCashPoint;
    property idCurrencyDef: TDataGid read FidCurrencyDef write SetidCurrencyDef;
  end;

  TAccountExtraction = class(TDataObject)
  private
    FidAccount: TDataGid;
    FextractionState: TBaseEnumeration;
    FstartDate: TDateTime;
    FendDate: TDateTime;
    FregDate: TDateTime;
    Fdescription: TBaseDescription;
    procedure Setdescription(const Value: TBaseDescription);
    procedure SetendDate(const Value: TDateTime);
    procedure SetidAccount(const Value: TDataGid);
    procedure SetstartDate(const Value: TDateTime);
    procedure SetExtractionState(const Value: TBaseEnumeration);
    procedure SetregDate(const Value: TDateTime);
  public
    procedure UpdateFieldList; override;
    procedure FromDataset(ADataset: TADOQuery); override;
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean): String; override;
    function GetMovements: TDataObjectList;
    function GetColumnImage(AColumnIndex: Integer): Integer; override;
    function GetElementText: String; override;
  published
    property idAccount: TDataGid read FidAccount write SetidAccount;
    property extractionState: TBaseEnumeration read FextractionState write SetExtractionState;
    property startDate: TDateTime read FstartDate write SetstartDate;
    property endDate: TDateTime read FendDate write SetendDate;
    property regDate: TDateTime read FregDate write SetregDate;
    property description: TBaseDescription read Fdescription write Setdescription;
  end;

  TExtractionItem = class(TDataObject)
  private
    Fdescription: TBaseDescription;
    FregDate: TDateTime;
    FaccountingDate: TDateTime;
    FmovementType: TBaseEnumeration;
    FidCurrencyDef: TDataGid;
    FidAccountExtraction: TDataGid;
    Fcash: Currency;
    procedure Setcash(const Value: Currency);
    procedure Setdescription(const Value: TBaseDescription);
    procedure SetidCurrencyDef(const Value: TDataGid);
    procedure SetmovementType(const Value: TBaseEnumeration);
    procedure SetregDate(const Value: TDateTime);
    procedure SetidAccountExtraction(const Value: TDataGid);
    procedure SetaccountingDate(const Value: TDateTime);
  protected
    function OnDeleteObject(AProxy: TDataProxy): Boolean; override;
  public
    procedure UpdateFieldList; override;
    procedure FromDataset(ADataset: TADOQuery); override;
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean): String; override;
    function GetColumnImage(AColumnIndex: Integer): Integer; override;
    function GetElementText: String; override;
  published
    property description: TBaseDescription read Fdescription write Setdescription;
    property regDate: TDateTime read FregDate write SetregDate;
    property accountingDate: TDateTime read FaccountingDate write SetaccountingDate;
    property movementType: TBaseEnumeration read FmovementType write SetmovementType;
    property idCurrencyDef: TDataGid read FidCurrencyDef write SetidCurrencyDef;
    property cash: Currency read Fcash write Setcash;
    property idAccountExtraction: TDataGid read FidAccountExtraction write SetidAccountExtraction;
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
    function GetElementText: String; override;
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean): String; override;
    function GetElementHint(AColumnIndex: Integer): String; override;
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
    FidAccountCurrencyDef: TDataGid;
    FidExtractionItem: TDataGid;
    FisStated: Boolean;
    procedure Setdescription(const Value: TBaseDescription);
    procedure SetidAccount(const Value: TDataGid);
    procedure SetidCashPoint(const Value: TDataGid);
    procedure SetregDate(const Value: TDateTime);
    procedure SetmovementType(const Value: TBaseEnumeration);
    procedure SetidAccountCurrencyDef(const Value: TDataGid);
    procedure SetidExtractionItem(const Value: TDataGid);
    procedure SetisStated(const Value: Boolean);
  protected
    function OnDeleteObject(AProxy: TDataProxy): Boolean; override;
  public
    procedure UpdateFieldList; override;
    procedure FromDataset(ADataset: TADOQuery); override;
    function GetMovements: TDataObjectList;
    procedure DeleteObject; override;
    constructor Create(AStatic: Boolean); override;
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
    property idAccountCurrencyDef: TDataGid read FidAccountCurrencyDef write SetidAccountCurrencyDef;
    property idExtractionItem: TDataGid read FidExtractionItem write SetidExtractionItem;
    property isStated: Boolean read FisStated write SetisStated;
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
    FidAccountCurrencyDef: TDataGid;
    FidMovementCurrencyDef: TDataGid;
    FidCurrencyRate: TDataGid;
    FcurrencyQuantity: Integer;
    FcurrencyRate: Currency;
    FrateDescription: TBaseDescription;
    FmovementCash: Currency;
    FprevmovementCash: Currency;
    FidExtractionItem: TDataGid;
    FisStated: Boolean;
    FidSourceExtractionItem: TDataGid;
    FisSourceStated: Boolean;
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
    procedure SetcurrencyQuantity(const Value: Integer);
    procedure SetcurrencyRate(const Value: Currency);
    procedure SetidAccountCurrencyDef(const Value: TDataGid);
    procedure SetidCurrencyRate(const Value: TDataGid);
    procedure SetidMovementCurrencyDef(const Value: TDataGid);
    procedure SetmovementCash(const Value: Currency);
    procedure SetrateDescription(const Value: TBaseDescription);
    procedure SetidExtractionItem(const Value: TDataGid);
    procedure SetisStated(const Value: Boolean);
    procedure SetidSourceExtractionItem(const Value: TDataGid);
    procedure SetisSourceStated(const Value: Boolean);
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
    property idAccountCurrencyDef: TDataGid read FidAccountCurrencyDef write SetidAccountCurrencyDef;
    property idMovementCurrencyDef: TDataGid read FidMovementCurrencyDef write SetidMovementCurrencyDef;
    property idCurrencyRate: TDataGid read FidCurrencyRate write SetidCurrencyRate;
    property currencyQuantity: Integer read FcurrencyQuantity write SetcurrencyQuantity;
    property currencyRate: Currency read FcurrencyRate write SetcurrencyRate;
    property rateDescription: TBaseDescription read FrateDescription write SetrateDescription;
    property movementCash: Currency read FmovementCash write SetmovementCash;
    property idExtractionItem: TDataGid read FidExtractionItem write SetidExtractionItem;
    property isStated: Boolean read FisStated write SetisStated;
    property idSourceExtractionItem: TDataGid read FidSourceExtractionItem write SetidSourceExtractionItem;
    property isSourceStated: Boolean read FisSourceStated write SetisSourceStated;
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
    FfreeDays: TBaseEnumeration;
    FidMovementCurrencyDef: TDataGid;
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
    procedure SetfreeDays(const Value: TBaseEnumeration);
    procedure SetidMovementCurrencyDef(const Value: TDataGid);
  public
    procedure UpdateFieldList; override;
    procedure FromDataset(ADataset: TADOQuery); override;
    class function CanBeDeleted(AId: ShortString): Boolean; override;
    constructor Create(AStatic: Boolean); override;
    function GetboundaryDate(AtriggerDate: TDateTime): TDateTime;
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
    property freeDays: TBaseEnumeration read FfreeDays write SetfreeDays;
    property idMovementCurrencyDef: TDataGid read FidMovementCurrencyDef write SetidMovementCurrencyDef;
  end;

  TPlannedDone = class(TDataObject)
  private
    FtriggerDate: TDateTime;
    FdoneDate: TDateTime;
    FidPlannedMovement: TDataGid;
    FdoneState: TBaseEnumeration;
    Fdescription: TBaseDescription;
    Fcash: Currency;
    FidDoneCurrencyDef: TDataGid;
    procedure SetidPlannedMovement(const Value: TDataGid);
    procedure SettriggerDate(const Value: TDateTime);
    procedure SetdoneState(const Value: TBaseEnumeration);
    procedure SetdoneDate(const Value: TDateTime);
    procedure Setdescription(const Value: TBaseDescription);
    procedure Setcash(const Value: Currency);
    procedure SetidDoneCurrencyDef(const Value: TDataGid);
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
    property idDoneCurrencyDef: TDataGid read FidDoneCurrencyDef write SetidDoneCurrencyDef;
  end;

  TMovementFilter = class(TDataObject)
  private
    Fname: TBaseName;
    Fdescription: TBaseDescription;
    Faccounts: TStringList;
    Fproducts: TStringList;
    Fcashpoints: TStringList;
    FisLoaded: Boolean;
    FisTemp: Boolean;
    procedure Setdescription(const Value: TBaseDescription);
    procedure Setname(const Value: TBaseName);
    procedure Setaccounts(const Value: TStringList);
    procedure Setcashpoints(const Value: TStringList);
    procedure Setproducts(const Value: TStringList);
    procedure FillFilterList(AList: TStringList; AQuery: TADOQuery);
    procedure SetisTemp(const Value: Boolean);
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
    function GetElementText: String; override;
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean): String; override;
    function GetElementHint(AColumnIndex: Integer): String; override;
    class function CanBeDeleted(AId: ShortString): Boolean; override;
    class procedure DeleteIfTemporary(AId: TDataGid);
  published
    property name: TBaseName read Fname write Setname;
    property description: TBaseDescription read Fdescription write Setdescription;
    property accounts: TStringList read Faccounts write Setaccounts;
    property products: TStringList read Fproducts write Setproducts;
    property cashpoints: TStringList read Fcashpoints write Setcashpoints;
    property isTemp: Boolean read FisTemp write SetisTemp;
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
    function GetElementText: String; override;
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean): String; override;
    function GetElementHint(AColumnIndex: Integer): String; override;
  published
    property name: TBaseName read Fname write Setname;
    property description: TBaseDescription read Fdescription write Setdescription;
    property idAccount: TDataGid read FidAccount write SetidAccount;
    property idCashPoint: TDataGid read FidCashPoint write SetidCashPoint;
    property idProduct: TDataGid read FidProduct write SetidProduct;
  end;

  TMovementLimit = class(TDataObject)
  private
    Fname: TBaseName;
    Fdescription: TBaseDescription;
    FisActive: Boolean;
    FidFilter: TDataGid;
    FboundaryAmount: Currency;
    FboundaryType: TBaseEnumeration;
    FboundaryCondition: TBaseName;
    FboundaryDays: Integer;
    FsumType: TBaseEnumeration;
    FcurrentAmount: Currency;
    FisCalculated: Boolean;
    FidCurrencyDef: TDataGid;
    procedure SetboundaryAmount(const Value: Currency);
    procedure SetboundaryDays(const Value: Integer);
    procedure SetboundaryType(const Value: TBaseEnumeration);
    procedure Setdescription(const Value: TBaseDescription);
    procedure SetidFilter(const Value: TDataGid);
    procedure SetisActive(const Value: Boolean);
    procedure Setname(const Value: TBaseName);
    procedure SetboundaryCondition(const Value: TBaseName);
    procedure GetFilterDates(ADateTime: TDateTime; var ADateFrom, ADateTo: TDateTime);
    procedure SetsumType(const Value: TBaseEnumeration);
    procedure SetidCurrencyDef(const Value: TDataGid);
  public
    procedure UpdateFieldList; override;
    procedure FromDataset(ADataset: TADOQuery); override;
    function GetElementText: String; override;
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean): String; override;
    function GetElementHint(AColumnIndex: Integer): String; override;
    function IsSurpassed(ACurrentValue: Currency): Boolean;
    function GetCurrentAmount(ADate: TDateTime; AMustRecalculate: Boolean): Currency;
    constructor Create(AStatic: Boolean); override;
    function GetColumnImage(AColumnIndex: Integer): Integer; override;
  published
    property name: TBaseName read Fname write Setname;
    property description: TBaseDescription read Fdescription write Setdescription;
    property isActive: Boolean read FisActive write SetisActive;
    property idFilter: TDataGid read FidFilter write SetidFilter;
    property boundaryAmount: Currency read FboundaryAmount write SetboundaryAmount;
    property boundaryType: TBaseEnumeration read FboundaryType write SetboundaryType;
    property boundaryCondition: TBaseName read FboundaryCondition write SetboundaryCondition;
    property boundaryDays: Integer read FboundaryDays write SetboundaryDays;
    property sumType: TBaseEnumeration read FsumType write SetsumType;
    property idCurrencyDef: TDataGid read FidCurrencyDef write SetidCurrencyDef;
  end;

  TCurrCacheItem = class(TObject)
  private
    FCurrI: String;
    FCurrSymbol: String;
    FCurrIso: String;
    procedure SetCurrSymbol(const Value: String);
    procedure SetCurrIso(const Value: String);
  public
    constructor Create(AId, ASymbol, AIso: String);
  published
    property CurrSymbol: String read FCurrSymbol write SetCurrSymbol;
    property CurrIso: String read FCurrIso write SetCurrIso;
    property CurrId: String read FCurrI;
  end;

  TCurrCache = class(TObjectList)
  private
    function GetItems(AIndex: Integer): TCurrCacheItem;
    procedure SetItems(AIndex: Integer; const Value: TCurrCacheItem);
    function GetById(AId: String): TCurrCacheItem;
    function GetByIso(AIso: String): TCurrCacheItem;
  public
    procedure Change(AId, ASymbol, AIso: String);
    function GetSymbol(AId: String): String;
    function GetIso(AId: String): String;
    property Items[AIndex: Integer]: TCurrCacheItem read GetItems write SetItems;
    property ById[AId: String]: TCurrCacheItem read GetById;
    property ByIso[AIso: String]: TCurrCacheItem read GetByIso;
  end;

  TAccountCurrencyRule = class(TDataObject)
  private
    FmovementType: TBaseEnumeration;
    FrateType: TBaseEnumeration;
    FidAccount: TDataGid;
    FidCashPoint: TDataGid;
    procedure SetidAccount(const Value: TDataGid);
    procedure SetidCashPoint(const Value: TDataGid);
    procedure SetmovementType(const Value: TBaseEnumeration);
    procedure SetrateType(const Value: TBaseEnumeration);
  public
    procedure UpdateFieldList; override;
    procedure FromDataset(ADataset: TADOQuery); override;
    class procedure DeleteRules(AIdAccount: TDataGid);
    class function FindRule(AmovementType: TBaseEnumeration; AIdAccount: TDataGid): TAccountCurrencyRule;
    class function FindRateByRule(ADate: TDateTime; AmovementType: TBaseEnumeration; AIdAccount: TDataGid; ASourceCurrency: TDataGid): TCurrencyRate;
    class function FindRules(AIdAccount: TDataGid): TDataObjectList;
  published
    property movementType: TBaseEnumeration read FmovementType write SetmovementType;
    property rateType: TBaseEnumeration read FrateType write SetrateType;
    property idAccount: TDataGid read FidAccount write SetidAccount;
    property idCashPoint: TDataGid read FidCashPoint write SetidCashPoint;
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
    MovementLimitProxy: TDataProxy;
    CurrencyDefProxy: TDataProxy;
    CurrencyRateProxy: TDataProxy;
    AccountCurrencyRuleProxy: TDataProxy;
    AccountExtractionProxy: TDataProxy;
    ExtractionItemProxy: TDataProxy;


var GActiveProfileId: TDataGid = CEmptyDataGid;
    GCurrencyCache: TCurrCache;

const CDatafileTables: array[0..19] of string =
            ('cashPoint', 'account', 'accountExtraction', 'extractionItem',
             'product', 'plannedMovement', 'plannedDone',
             'movementList', 'baseMovement', 'movementFilter', 'accountFilter',
             'cashpointFilter', 'productFilter', 'profile', 'cmanagerInfo',
             'cmanagerParams', 'movementLimit', 'currencyDef', 'currencyRate',
             'accountCurrencyRule');



const CCurrencyDefGid_PLN = '{00000000-0000-0000-0000-000000000001}';

procedure InitializeProxies;
function IsMultiCurrencyDataset(ADataset: TADOQuery; ACurDefFieldname: String; var AOneCurrDef: TDataGid): Boolean;
function GetDefsFromDataset(ADataset: TADOQuery; ACurDefFieldname: String): TDataGids;
function GetNamesFromDataset(ADataset: TADOQuery; ACurDefFieldname, ACurNameFieldName: String): TStringList;

implementation

uses DB, CInfoFormUnit, DateUtils, StrUtils, CPreferences, CBaseFrameUnit;

function GetDefsFromDataset(ADataset: TADOQuery; ACurDefFieldname: String): TDataGids;
var xGid: String;
begin
  ADataset.First;
  Result := TDataGids.Create;
  if not ADataset.IsEmpty then begin
    while (not ADataset.Eof) do begin
      xGid := ADataset.FieldByName(ACurDefFieldname).AsString;
      if Result.IndexOf(xGid) = -1 then begin
        Result.Add(xGid);
      end;
      ADataset.Next;
    end;
  end;
  ADataset.First;
end;

function GetNamesFromDataset(ADataset: TADOQuery; ACurDefFieldname, ACurNameFieldName: String): TStringList;
begin
  ADataset.First;
  Result := TStringList.Create;
  if not ADataset.IsEmpty then begin
    while (not ADataset.Eof) do begin
      if Result.IndexOfName(ADataset.FieldByName(ACurDefFieldname).AsString) = -1 then begin
        Result.Values[ADataset.FieldByName(ACurDefFieldname).AsString] := ADataset.FieldByName(ACurNameFieldName).AsString;
      end;
      ADataset.Next;
    end;
  end;
  ADataset.First;
end;


function IsMultiCurrencyDataset(ADataset: TADOQuery; ACurDefFieldname: String; var AOneCurrDef: TDataGid): Boolean;
begin
  ADataset.First;
  Result := False;
  AOneCurrDef := '';
  if not ADataset.IsEmpty then begin
    AOneCurrDef := ADataset.FieldByName(ACurDefFieldname).AsString;
    while (not Result) and (not ADataset.Eof) do begin
      Result := (AOneCurrDef <> ADataset.FieldByName(ACurDefFieldname).AsString);
      ADataset.Next;
    end;
  end;
  ADataset.First;
  if Result then begin
    AOneCurrDef := '';
  end;
end;

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
  MovementLimitProxy :=  TDataProxy.Create(GDataProvider, 'movementLimit', Nil);
  CurrencyDefProxy :=  TDataProxy.Create(GDataProvider, 'currencyDef', Nil);
  CurrencyRateProxy :=  TDataProxy.Create(GDataProvider, 'currencyRate', Nil);
  AccountCurrencyRuleProxy := TDataProxy.Create(GDataProvider, 'accountCurrencyRule', Nil);
  AccountExtractionProxy := TDataProxy.Create(GDataProvider, 'accountExtraction', Nil);
  ExtractionItemProxy := TDataProxy.Create(GDataProvider, 'extractionItem', Nil);
end;

class function TCashPoint.CanBeDeleted(AId: ShortString): Boolean;
var xText: String;
begin
  Result := True;
  if GDataProvider.GetSqlInteger('select count(*) from account where idCashPoint = ' + DataGidToDatabase(AId), 0) <> 0 then begin
    xText := 'istniej� zwi�zane z nim konta bankowe';
  end else if GDataProvider.GetSqlInteger('select count(*) from plannedMovement where idCashPoint = ' + DataGidToDatabase(AId), 0) <> 0 then begin
    xText := 'istniej� zaplanowane operacje z jego udzia�em';
  end else if GDataProvider.GetSqlInteger('select count(*) from baseMovement where idCashPoint = ' + DataGidToDatabase(AId), 0) <> 0 then begin
    xText := 'istniej� wykonane operacje z jego udzia�em';
  end else if GDataProvider.GetSqlInteger('select count(*) from cashpointFilter where idCashPoint = ' + DataGidToDatabase(AId), 0) <> 0 then begin
    xText := 'istniej� zwi�zane z nim filtry';
  end else if GDataProvider.GetSqlInteger('select count(*) from profile where idCashPoint = ' + DataGidToDatabase(AId), 0) <> 0 then begin
    xText := 'istniej� zwi�zane z nim profile';
  end;
  if xText <> '' then begin
    ShowInfo(itError, 'Nie mo�na usun�� kontrahenta, gdy� ' + xText, '');
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

function TCashPoint.GetElementHint(AColumnIndex: Integer): String;
begin
  Result := Fdescription;
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
    FidCurrencyDef := FieldByName('idCurrencyDef').AsString;
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
    AddField('idCurrencyDef', DataGidToDatabase(FidCurrencyDef), False, 'account');
  end;
end;

class function TProduct.CanBeDeleted(AId: ShortString): Boolean;
var xText: String;
begin
  Result := True;
  if GDataProvider.GetSqlInteger('select count(*) from plannedMovement where idProduct = ' + DataGidToDatabase(AId), 0) <> 0 then begin
    xText := 'istniej� zwi�zane z ni� zaplanowane operacje';
  end else if GDataProvider.GetSqlInteger('select count(*) from baseMovement where idProduct = ' + DataGidToDatabase(AId), 0) <> 0 then begin
    xText := 'istniej� zwi�zane z ni� wykonane operacje';
  end else if GDataProvider.GetSqlInteger('select count(*) from product where idParentProduct = ' + DataGidToDatabase(AId), 0) <> 0 then begin
    xText := 'istniej� zwi�zane z ni� podkategorie';
  end else if GDataProvider.GetSqlInteger('select count(*) from productFilter where idProduct = ' + DataGidToDatabase(AId), 0) <> 0 then begin
    xText := 'istniej� zwi�zane z nim filtry';
  end else if GDataProvider.GetSqlInteger('select count(*) from profile where idProduct = ' + DataGidToDatabase(AId), 0) <> 0 then begin
    xText := 'istniej� zwi�zane z nim profile';
  end;
  if xText <> '' then begin
    ShowInfo(itError, 'Nie mo�na usun�� kategorii, gdy� ' + xText, '');
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

function TProduct.GetColumnText(AColumnIndex: Integer; AStatic: Boolean): String;
begin
  Result := Fname;
end;

function TProduct.GetElementHint(AColumnIndex: Integer): String;
begin
  Result := Fdescription;
end;

function TProduct.GetElementText: String;
begin
  Result := Fname;
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
    FidAccountCurrencyDef := FieldByName('idAccountCurrencyDef').AsString;
    FidMovementCurrencyDef := FieldByName('idMovementCurrencyDef').AsString;
    FidCurrencyRate := FieldByName('idCurrencyRate').AsString;
    FcurrencyQuantity := FieldByName('currencyQuantity').AsInteger;
    FcurrencyRate := FieldByName('currencyRate').AsCurrency;
    FrateDescription := FieldByName('rateDescription').AsString;
    FmovementCash := FieldByName('movementCash').AsCurrency;
    FidExtractionItem := FieldByName('idExtractionItem').AsString;
    FisStated := FieldByName('isStated').AsBoolean;
    FidSourceExtractionItem := FieldByName('idSourceExtractionItem').AsString;
    FisSourceStated := FieldByName('isSourceStated').AsBoolean;
    FprevmovementCash := FmovementCash;
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
    AddField('idAccountCurrencyDef', DataGidToDatabase(FidAccountCurrencyDef), False, 'baseMovement');
    AddField('idMovementCurrencyDef', DataGidToDatabase(FidMovementCurrencyDef), False, 'baseMovement');
    AddField('idCurrencyRate', DataGidToDatabase(FidCurrencyRate), False, 'baseMovement');
    AddField('currencyQuantity', IntToStr(FcurrencyQuantity), False, 'baseMovement');
    AddField('currencyRate', CurrencyToDatabase(FcurrencyRate), False, 'baseMovement');
    AddField('rateDescription', FrateDescription, True, 'baseMovement');
    AddField('movementCash', CurrencyToDatabase(FmovementCash), False, 'baseMovement');
    AddField('idExtractionItem', DataGidToDatabase(FidExtractionItem), False, 'baseMovement');
    AddField('isStated', IntToStr(Integer(FisStated)), False, 'baseMovement');
    AddField('idSourceExtractionItem', DataGidToDatabase(FidSourceExtractionItem), False, 'baseMovement');
    AddField('isSourceStated', IntToStr(Integer(FisSourceStated)), False, 'baseMovement');
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
    xText := 'istniej� zwi�zane z ni� operacje wykonane';
  end;
  if xText <> '' then begin
    ShowInfo(itError, 'Nie mo�na usun�� zaplanowanej operacji, gdy� ' + xText, '');
    Result := False;
  end;
end;

constructor TPlannedMovement.Create(AStatic: Boolean);
begin
  inherited Create(AStatic);
  FidAccount := CEmptyDataGid;
  FidCashPoint := CEmptyDataGid;
  FidProduct := CEmptyDataGid;
  FidMovementCurrencyDef := CEmptyDataGid;
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
    FfreeDays := FieldByName('freeDays').AsString;
    xField := FindField('doneCount');
    if xField <> Nil then begin
      FdoneCount := xField.AsInteger;
    end;
    FidMovementCurrencyDef := FieldByName('idMovementCurrencyDef').AsString;
  end;
end;

function TPlannedMovement.GetboundaryDate(AtriggerDate: TDateTime): TDateTime;
begin
  Result := AtriggerDate;
  if (FscheduleType = CScheduleTypeCyclic) and (FtriggerType = CTriggerTypeMonthly) then begin
    if FfreeDays = CFreeDayIncrements then begin
      Result := GetWorkDay(AtriggerDate, True);
    end else if FfreeDays = CFreeDayDecrements then begin
      Result := GetWorkDay(AtriggerDate, False);
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

procedure TPlannedMovement.SetfreeDays(const Value: TBaseEnumeration);
begin
  if FfreeDays <> Value then begin
    FfreeDays := Value;
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

procedure TPlannedMovement.SetidMovementCurrencyDef(const Value: TDataGid);
begin
  if FidMovementCurrencyDef <> Value then begin
    FidMovementCurrencyDef := Value;
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
    AddField('freeDays', FfreeDays, True, 'plannedMovement');
    AddField('idMovementCurrencyDef', DataGidToDatabase(FidMovementCurrencyDef), False, 'plannedMovement');
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
    FidDoneCurrencyDef := FieldByName('idDoneCurrencyDef').AsString;
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

procedure TPlannedDone.SetidDoneCurrencyDef(const Value: TDataGid);
begin
  if FidDoneCurrencyDef <> Value then begin
    FidDoneCurrencyDef := Value;
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
    AddField('idDoneCurrencyDef', DataGidToDatabase(FidDoneCurrencyDef), False, 'plannedDone');
  end;
end;

class function TAccount.CanBeDeleted(AId: ShortString): Boolean;
var xText: String;
begin
  Result := True;
  if GDataProvider.GetSqlInteger('select count(*) from plannedMovement where idAccount = ' + DataGidToDatabase(AId), 0) <> 0 then begin
    xText := 'istniej� zwi�zane z nim zaplanowane operacje';
  end else if GDataProvider.GetSqlInteger('select count(*) from baseMovement where idAccount = ' + DataGidToDatabase(AId), 0) <> 0 then begin
    xText := 'istniej� zwi�zane z nim wykonane operacje';
  end else if GDataProvider.GetSqlInteger('select count(*) from accountFilter where idAccount = ' + DataGidToDatabase(AId), 0) <> 0 then begin
    xText := 'istniej� zwi�zane z nim filtry';
  end else if GDataProvider.GetSqlInteger('select count(*) from profile where idAccount = ' + DataGidToDatabase(AId), 0) <> 0 then begin
    xText := 'istniej� zwi�zane z nim profile';
  end;
  if xText <> '' then begin
    ShowInfo(itError, 'Nie mo�na usun�� konta, gdy� ' + xText, '');
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

class function TMovementFilter.CanBeDeleted(AId: ShortString): Boolean;
var xText: String;
begin
  Result := True;
  if GDataProvider.GetSqlInteger('select count(*) from movementLimit where idmovementFilter = ' + DataGidToDatabase(AId), 0) <> 0 then begin
    xText := 'istniej� zwi�zane z nim limity';
  end;
  if xText <> '' then begin
    ShowInfo(itError, 'Nie mo�na usun�� filtru, gdy� ' + xText, '');
    Result := False;
  end;
end;

constructor TMovementFilter.Create(AStatic: Boolean);
begin
  inherited Create(AStatic);
  Faccounts := TStringList.Create;
  Fproducts := TStringList.Create;
  Fcashpoints := TStringList.Create;
  FisLoaded := False;
end;

class procedure TMovementFilter.DeleteIfTemporary(AId: TDataGid);
var xFilter: TMovementFilter;
begin
  GDataProvider.BeginTransaction;
  xFilter := TMovementFilter(TMovementFilter.LoadObject(MovementFilterProxy, AId, False));
  if xFilter.isTemp then begin
    xFilter.DeleteObject;
  end;
  GDataProvider.CommitTransaction;
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
    FisTemp := FieldByName('isTemp').AsBoolean;
  end;
end;

function TMovementFilter.GetColumnText(AColumnIndex: Integer; AStatic: Boolean): String;
begin
  Result := Fname;
end;

function TMovementFilter.GetElementHint(AColumnIndex: Integer): String;
begin
  Result := Fdescription;
end;

function TMovementFilter.GetElementText: String;
begin
  Result := Fname;
end;

class function TMovementFilter.GetFilterCondition(AIdFilter: TDataGid; AWithAnd: Boolean; AAcountField, ACashpointField, ACategoryField: String): String;
var xFilter: TMovementFilter;
    xAccountsPart, xCashpointsPart, xProductsPart: String;
    xInTr: Boolean;
begin
  Result := '';
  if AIdFilter <> CEmptyDataGid then begin
    xInTr := GDataProvider.InTransaction;
    if not xInTr then begin
      GDataProvider.BeginTransaction;
    end;
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
    if not xInTr then begin
      GDataProvider.RollbackTransaction;
    end;
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

procedure TMovementFilter.SetisTemp(const Value: Boolean);
begin
  if FisTemp <> Value then begin
    FisTemp := Value;
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
    AddField('isTemp', IntToStr(Integer(FisTemp)), False, 'movementFilter');
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

function TProfile.GetColumnText(AColumnIndex: Integer; AStatic: Boolean): String;
begin
  Result := Fname;
end;

function TProfile.GetElementHint(AColumnIndex: Integer): String;
begin
  Result := Fdescription;
end;

function TProfile.GetElementText: String;
begin
  Result := Fname;
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
    FidAccountCurrencyDef := FieldByName('idAccountCurrencyDef').AsString;
    FidExtractionItem := FieldByName('idExtractionItem').AsString;
    FisStated := FieldByName('isStated').AsBoolean;
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

procedure TMovementList.SetidAccountCurrencyDef(const Value: TDataGid);
begin
  if FidAccountCurrencyDef <> Value then begin
    FidAccountCurrencyDef := Value;
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
    AddField('idAccountCurrencyDef', DataGidToDatabase(FidAccountCurrencyDef), False, 'movementList');
    AddField('idExtractionItem', DataGidToDatabase(FidExtractionItem), False, 'movementList');
    AddField('isStated', IntToStr(Integer(FisStated)), False, 'movementList');
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
  FidAccountCurrencyDef := CEmptyDataGid;
  FidMovementCurrencyDef := CEmptyDataGid;
  FidCurrencyRate := CEmptyDataGid;
  FidExtractionItem := CEmptyDataGid;
  FisStated := False;
  FidSourceExtractionItem := CEmptyDataGid;
  FisSourceStated := False;
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
    AProxy.DataProvider.ExecuteSql('update account set cash = cash + ' + CurrencyToDatabase(movementCash) + ' where idAccount = ' + DataGidToDatabase(idSourceAccount));
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
    AProxy.DataProvider.ExecuteSql('update account set cash = cash - ' + CurrencyToDatabase(movementCash) + ' where idAccount = ' + DataGidToDatabase(idSourceAccount));
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
      AProxy.DataProvider.ExecuteSql('update account set cash = cash + ' + CurrencyToDatabase(FprevmovementCash) + ' where idAccount = ' + DataGidToDatabase(FprevIdSourceAccount));
      AProxy.DataProvider.ExecuteSql('update account set cash = cash - ' + CurrencyToDatabase(movementCash) + ' where idAccount = ' + DataGidToDatabase(FidSourceAccount));
    end else begin
      AProxy.DataProvider.ExecuteSql('update account set cash = cash - ' + CurrencyToDatabase(movementCash - FprevmovementCash) + ' where idAccount = ' + DataGidToDatabase(FidSourceAccount));
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
                 [DataGidToDatabase(AIdAccount), DataGidToDatabase(AIdAccount)]), 0) +
            GDataProvider.GetSqlInteger(Format('select count(*) from movementList where idAccount = %s',
                 [DataGidToDatabase(AIdAccount), DataGidToDatabase(AIdAccount)]), 0);
end;

procedure TAccount.SetinitialBalance(const Value: Currency);
begin
  if FinitialBalance <> Value then begin
    FinitialBalance := Value;
    SetState(msModified);
  end;
end;

function TAccount.GetColumnText(AColumnIndex: Integer; AStatic: Boolean): String;
begin
  if AColumnIndex = 3 then begin
    Result := GCurrencyCache.GetSymbol(FidCurrencyDef);
  end else if AColumnIndex = 2 then begin
    Result := CurrencyToString(Fcash, FidCurrencyDef, False);
  end else if AColumnIndex = 1 then begin
    Result := IfThen(FaccountType = CCashAccount, 'got�wkowe', 'bankowe');
  end else begin
    Result := Fname;
  end;
end;

function TAccount.GetElementText: String;
begin
  Result := Fname;
end;

function TAccount.GetElementCompare(AColumnIndex: Integer; ACompareWith: TCDataListElementObject): Integer;
begin
  if AColumnIndex = 2 then begin
    Result := Sign(Fcash - TAccount(ACompareWith).cash);
  end else begin
    Result := inherited GetElementCompare(AColumnIndex, ACompareWith);
  end;
end;

function TAccount.GetElementHint(AColumnIndex: Integer): String;
begin
  Result := Fdescription;
end;

constructor TMovementLimit.Create(AStatic: Boolean);
begin
  inherited Create(AStatic);
  FisCalculated := False;
  FidCurrencyDef := CEmptyDataGid;
  FidFilter := CEmptyDataGid;
end;

procedure TMovementLimit.FromDataset(ADataset: TADOQuery);
begin
  inherited FromDataset(ADataset);
  with ADataset do begin
    Fname := FieldByName('name').AsString;
    Fdescription := FieldByName('description').AsString;
    FidFilter := FieldByName('idMovementFilter').AsString;
    FboundaryAmount := FieldByName('boundaryAmount').AsCurrency;
    FboundaryType := FieldByName('boundaryType').AsString;
    FboundaryCondition := FieldByName('boundaryCondition').AsString;
    FboundaryDays := FieldByName('boundaryDays').AsInteger;
    FisActive := FieldByName('isActive').AsBoolean;
    FsumType := FieldByName('sumType').AsString;
    FidCurrencyDef := FieldByName('idCurrencyDef').AsString;
  end;
end;

function TMovementLimit.GetColumnImage(AColumnIndex: Integer): Integer;
begin
  Result := -1;
  if AColumnIndex = 2 then begin
    if FsumType = CLimitSumtypeOut then begin
      Result := 1;
    end else if FsumType = CLimitSumtypeIn then begin
      Result := 0;
    end else begin
      Result := 7;
    end;
  end;
end;

function TMovementLimit.GetColumnText(AColumnIndex: Integer; AStatic: Boolean): String;
begin
  if AColumnIndex = 2 then begin
    if FsumType = CLimitSumtypeOut then begin
      Result := CLimitSumtypeOutDescription;
    end else if FsumType = CLimitSumtypeIn then begin
      Result := CLimitSumtypeInDescription;
    end else begin
      Result := CLimitSumtypeBalanceDescription;
    end;
  end else if AColumnIndex = 1 then begin
    if FisActive then begin
      Result := 'Aktywny';
    end else begin
      Result := 'Wy��czony';
    end;
  end else begin
    Result := Fname;
  end;
end;

function TMovementLimit.GetCurrentAmount(ADate: TDateTime; AMustRecalculate: Boolean): Currency;
var xSd, xEd: TDateTime;
    xSql: String;
    xQ: TADOQuery;
begin
  if (not FisCalculated) or AMustRecalculate then begin
    Result := 0;
    GetFilterDates(ADate, xSd, xEd);
    xSql := Format('select sum(movementIncome) as income, sum(movementExpense) as expense from balances where idMovementCurrencyDef = %s and movementType <> ''%s'' and regDate between %s and %s %s',
            [DataGidToDatabase(idCurrencyDef),
             CTransferMovement,
             DatetimeToDatabase(xSd, False),
             DatetimeToDatabase(xEd, False),
             TMovementFilter.GetFilterCondition(idFilter, True)]);
    xQ := GDataProvider.OpenSql(xSql);
    if xQ <> Nil then begin
      if not xQ.IsEmpty then begin
        if FsumType = CLimitSumtypeOut then begin
          Result := xQ.FieldByName('expense').AsCurrency;
        end else if FsumType = CLimitSumtypeIn then begin
          Result := xQ.FieldByName('income').AsCurrency;
        end else begin
          Result := xQ.FieldByName('income').AsCurrency - xQ.FieldByName('expense').AsCurrency;
        end;
      end;
      xQ.Free;
    end;
    FcurrentAmount := Result;
  end else begin
    Result := FcurrentAmount;
  end;
end;

function TMovementLimit.GetElementHint(AColumnIndex: Integer): String;
begin
  Result := Fdescription;
end;

function TMovementLimit.GetElementText: String;
begin
  Result := Fname;
end;

procedure TMovementLimit.GetFilterDates(ADateTime: TDateTime; var ADateFrom, ADateTo: TDateTime);
begin
  ADateFrom := 0;
  ADateTo := 0;
  if boundaryType = CLimitBoundaryTypeToday then begin
    ADateFrom := ADateTime;
    ADateTo := ADateTime;
  end else if boundaryType = CLimitBoundaryTypeWeek then begin
    ADateFrom := StartOfTheWeek(ADateTime);
    ADateTo := EndOfTheWeek(ADateTime);
  end else if boundaryType = CLimitBoundaryTypeMonth then begin
    ADateFrom := StartOfTheMonth(ADateTime);
    ADateTo := EndOfTheMonth(ADateTime);
  end else if boundaryType = CLimitBoundaryTypeQuarter then begin
    ADateFrom := GetStartQuarterOfTheYear(ADateTime);
    ADateTo := GetEndQuarterOfTheYear(ADateTime);
  end else if boundaryType = CLimitBoundaryTypeHalfyear then begin
    ADateFrom := GetStartHalfOfTheYear(ADateTime);
    ADateTo := GetEndHalfOfTheYear(ADateTime);
  end else if boundaryType = CLimitBoundaryTypeYear then begin
    ADateFrom := StartOfTheYear(ADateTime);
    ADateTo := EndOfTheYear(ADateTime);
  end else if boundaryType = CLimitBoundaryTypeDays then begin
    ADateFrom := ADateTime;
    ADateTo := IncDay(ADateTime, - (boundaryDays - 1));
  end;
end;

function TMovementLimit.IsSurpassed(ACurrentValue: Currency): Boolean;
begin
  if boundaryCondition = CLimitBoundaryCondLess then begin
    Result := ACurrentValue < FboundaryAmount;
  end else if boundaryCondition = CLimitBoundaryCondLessEqual then begin
    Result := ACurrentValue <= FboundaryAmount;
  end else if boundaryCondition =  CLimitBoundaryCondGreater then begin
    Result := ACurrentValue > FboundaryAmount;
  end else if boundaryCondition = CLimitBoundaryCondGreaterEqual then begin
    Result := ACurrentValue >= FboundaryAmount;
  end else begin
    Result := ACurrentValue = boundaryAmount;
  end;
end;

procedure TMovementLimit.SetboundaryAmount(const Value: Currency);
begin
  if FboundaryAmount <> Value then begin
    FboundaryAmount := Value;
    SetState(msModified);
  end;
end;

procedure TMovementLimit.SetboundaryCondition(const Value: TBaseName);
begin
  if FboundaryCondition <> Value then begin
    FboundaryCondition := Value;
    SetState(msModified);
  end;
end;

procedure TMovementLimit.SetboundaryDays(const Value: Integer);
begin
  if FboundaryDays <> Value then begin
    FboundaryDays := Value;
    SetState(msModified);
  end;
end;

procedure TMovementLimit.SetboundaryType(const Value: TBaseEnumeration);
begin
  if FboundaryType <> Value then begin
    FboundaryType := Value;
    SetState(msModified);
  end;
end;

procedure TMovementLimit.Setdescription(const Value: TBaseDescription);
begin
  if Fdescription <> Value then begin
    Fdescription := Value;
    SetState(msModified);
  end;
end;

procedure TMovementLimit.SetidCurrencyDef(const Value: TDataGid);
begin
  if FidCurrencyDef <> Value then begin
    FidCurrencyDef := Value;
    SetState(msModified);
  end;
end;

procedure TMovementLimit.SetidFilter(const Value: TDataGid);
begin
  if FidFilter <> Value then begin
    FidFilter := Value;
    SetState(msModified);
  end;
end;

procedure TMovementLimit.SetisActive(const Value: Boolean);
begin
  if FisActive <> Value then begin
    FisActive := Value;
    SetState(msModified);
  end;
end;

procedure TMovementLimit.Setname(const Value: TBaseName);
begin
  if Fname <> Value then begin
    Fname := Value;
    SetState(msModified);
  end;
end;

procedure TMovementLimit.SetsumType(const Value: TBaseEnumeration);
begin
  if FsumType <> Value then begin
    FsumType := Value;
    SetState(msModified);
  end;
end;

procedure TMovementLimit.UpdateFieldList;
begin
  inherited UpdateFieldList;
  with DataFieldList do begin
    AddField('isActive', IntToStr(Integer(FisActive)), False, 'movementLimit');
    AddField('description', Fdescription, True, 'movementLimit');
    AddField('name', Fname, True, 'movementLimit');
    AddField('idmovementFilter', DataGidToDatabase(FidFilter), False, 'movementLimit');
    AddField('boundaryAmount', CurrencyToDatabase(FboundaryAmount), False, 'movementLimit');
    AddField('boundaryType', FboundaryType, True, 'movementLimit');
    AddField('boundaryCondition', FboundaryCondition, True, 'movementLimit');
    AddField('boundaryDays', IntToStr(FboundaryDays), False, 'movementLimit');
    AddField('sumType', FsumType, True, 'movementLimit');
    AddField('idCurrencyDef', DataGidToDatabase(FidCurrencyDef), False, 'movementLimit');
  end;
end;

procedure TCurrencyDef.AfterPost;
begin
  if Fsymbol <> FpreviousSymbol then begin
    GCurrencyCache.Change(id, symbol, iso);
  end;
  inherited AfterPost;
end;

class function TCurrencyDef.CanBeDeleted(AId: ShortString): Boolean;
var xText: String;
begin
  Result := True;
  if GDataProvider.GetSqlBoolean('select isBase from currencyDef where idCurrencyDef = ' + DataGidToDatabase(AId), False) then begin
    xText := 'jest ona walut� podstawow�';
  end else if GDataProvider.GetSqlInteger('select count(*) from currencyRate where ' +
      '(idSourceCurrencyDef = ' + DataGidToDatabase(AId) + ') or ' +
      '(idTargetCurrencyDef = ' + DataGidToDatabase(AId) + ')', 0) <> 0 then begin
    xText := 'istniej� zwi�zane z ni� kursy';
  end else if GDataProvider.GetSqlInteger('select count(*) from account where idCurrencyDef = ' + DataGidToDatabase(AId), 0) <> 0 then begin
    xText := 'istniej� zwi�zane z ni� konta';
  end;
  if xText <> '' then begin
    ShowInfo(itError, 'Nie mo�na usun�� waluty, gdy� ' + xText, '');
    Result := False;
  end;
end;

constructor TCurrencyDef.Create(AStatic: Boolean);
begin
  inherited Create(AStatic);
  FpreviousSymbol := '';
end;

class function TCurrencyDef.FindByIso(AIso: TBaseName): TCurrencyDef;
begin
  Result := TCurrencyDef(TCurrencyDef.FindByCondition(CurrencyDefProxy, 'select * from currencyDef where iso = ''' + AIso + '''', False));
end;

procedure TCurrencyDef.FromDataset(ADataset: TADOQuery);
begin
  inherited FromDataset(ADataset);
  with ADataset do begin
    Fname := FieldByName('name').AsString;
    Fdescription := FieldByName('description').AsString;
    Fsymbol := FieldByName('symbol').AsString;
    FpreviousSymbol := Fsymbol;
    Fiso := FieldByName('iso').AsString;
    FisBase := FieldByName('isBase').AsBoolean;
  end;
end;

function TCurrencyDef.GetColumnText(AColumnIndex: Integer; AStatic: Boolean): String;
begin
  if AColumnIndex = 1 then begin
    Result := Fsymbol;
  end else if AColumnIndex = 2 then begin
    Result := Fiso;
  end else begin
    Result := Fname;
  end;
end;

function TCurrencyDef.GetElementHint(AColumnIndex: Integer): String;
begin
  Result := Fdescription;
end;

function TCurrencyDef.GetElementText: String;
begin
  Result := Fiso;
end;

procedure TCurrencyDef.Setdescription(const Value: TBaseDescription);
begin
  if Fdescription <> Value then begin
    Fdescription := Value;
    SetState(msModified);
  end;
end;

procedure TCurrencyDef.SetisBase(const Value: Boolean);
begin
  if FisBase <> Value then begin
    FisBase := Value;
    SetState(msModified);
  end;
end;

procedure TCurrencyDef.Setiso(const Value: TBaseName);
begin
  if Fiso <> Value then begin
    Fiso := Value;
    SetState(msModified);
  end;
end;

procedure TCurrencyDef.Setname(const Value: TBaseName);
begin
  if Fname <> Value then begin
    Fname := Value;
    SetState(msModified);
  end;
end;

procedure TCurrencyDef.Setsymbol(const Value: TBaseName);
begin
  if Fsymbol <> Value then begin
    Fsymbol := Value;
    SetState(msModified);
  end;
end;

procedure TCurrencyDef.UpdateFieldList;
begin
  inherited UpdateFieldList;
  with DataFieldList do begin
    AddField('name', Fname, True, 'currencyDef');
    AddField('symbol', Fsymbol, True, 'currencyDef');
    AddField('iso', Fiso, True, 'currencyDef');
    AddField('description', Fdescription, True, 'currencyDef');
    AddField('isBase', IntToStr(Integer(FIsBase)), False, 'currencyDef');
  end;
end;

procedure TCurrencyRate.FromDataset(ADataset: TADOQuery);
begin
  inherited FromDataset(ADataset);
  with ADataset do begin
    FidSourceCurrencyDef := FieldByName('idSourceCurrencyDef').AsString;
    FidTargetCurrencyDef := FieldByName('idTargetCurrencyDef').AsString;
    FidCashpoint := FieldByName('idCashpoint').AsString;
    Fquantity := FieldByName('quantity').AsInteger;
    Frate := FieldByName('rate').AsCurrency;
    FbindingDate := FieldByName('bindingDate').AsDateTime;
    Fdescription := FieldByName('description').AsString;
    FrateType := FieldByName('rateType').AsString;
  end;
end;

procedure TCurrencyRate.SetbindingDate(const Value: TDateTime);
begin
  if FbindingDate <> Value then begin
    FbindingDate := Value;
    SetState(msModified);
  end;
end;

procedure TCurrencyRate.SetidCashpoint(const Value: TDataGid);
begin
  if FidCashpoint <> Value then begin
    FidCashpoint := Value;
    SetState(msModified);
  end;
end;

procedure TCurrencyRate.SetidSourceCurrencyDef(const Value: TDataGid);
begin
  if FidSourceCurrencyDef <> Value then begin
    FidSourceCurrencyDef := Value;
    SetState(msModified);
  end;
end;

procedure TCurrencyRate.SetidTargetCurrencyDef(const Value: TDataGid);
begin
  if FidTargetCurrencyDef <> Value then begin
    FidTargetCurrencyDef := Value;
    SetState(msModified);
  end;
end;

procedure TCurrencyRate.Setquantity(const Value: Integer);
begin
  if Fquantity <> Value then begin
    Fquantity := Value;
    SetState(msModified);
  end;
end;

procedure TCurrencyRate.Setrate(const Value: Currency);
begin
  if Frate <> Value then begin
    Frate := Value;
    SetState(msModified);
  end;
end;

procedure TCurrencyRate.Setdescription(const Value: TBaseDescription);
begin
  if Fdescription <> Value then begin
    Fdescription := Value;
    SetState(msModified);
  end;
end;

procedure TCurrencyRate.UpdateFieldList;
begin
  inherited UpdateFieldList;
  with DataFieldList do begin
    AddField('idCashPoint', DataGidToDatabase(FidCashPoint), False, 'currencyRate');
    AddField('idSourceCurrencyDef', DataGidToDatabase(FidSourceCurrencyDef), False, 'currencyRate');
    AddField('idTargetCurrencyDef', DataGidToDatabase(FidTargetCurrencyDef), False, 'currencyRate');
    AddField('quantity', IntToStr(Fquantity), False, 'currencyRate');
    AddField('rate', CurrencyToDatabase(Frate), False, 'currencyRate');
    AddField('bindingDate', DatetimeToDatabase(FbindingDate, False), False, 'currencyRate');
    AddField('description', Fdescription, True, 'currencyRate');
    AddField('rateType', FrateType, True, 'currencyRate');
  end;
end;

function TCurrencyRate.GetColumnText(AColumnIndex: Integer; AStatic: Boolean): String;
begin
  if AColumnIndex = 0 then begin
    Result := DateToStr(FbindingDate);
  end else if AColumnIndex = 1 then begin
    Result := Fdescription;
  end else if AColumnIndex = 3 then begin
    Result := GetTypeDesc(FrateType);
  end else begin
    Result := CurrencyToString(rate);
  end;
end;

function TCurrencyRate.GetElementHint(AColumnIndex: Integer): String;
begin
  Result := Fdescription;
end;

function TCurrencyRate.GetElementText: String;
begin
  Result := Fdescription;
end;

class function TCurrencyRate.FindRate(ARateType: TBaseEnumeration; ASourceId, ATargetId, ACashpointId: TDataGid; ABindingDate: TDateTime): TCurrencyRate;
var xSql: String;
begin
  xSql := Format('select * from currencyRate where rateType = ''%s'' and bindingDate = %s and ' +
    '((idSourceCurrencyDef = %s and idTargetCurrencyDef = %s) or (idSourceCurrencyDef = %s and idTargetCurrencyDef = %s))' +
    ' and idCashpoint = %s',
                 [ARateType,
                  DatetimeToDatabase(ABindingDate, False),
                  DataGidToDatabase(ASourceId), DataGidToDatabase(ATargetId),
                  DataGidToDatabase(ATargetId), DataGidToDatabase(ASourceId),
                  DataGidToDatabase(ACashpointId)]);
  Result := TCurrencyRate(TCurrencyRate.FindByCondition(CurrencyRateProxy, xSql, False));
end;

procedure TCurrencyRate.SetrateType(const Value: TBaseEnumeration);
begin
  if FrateType <> Value then begin
    FrateType := Value;
    SetState(msModified);
  end;
end;

class function TCurrencyRate.GetTypeDesc(AType: TBaseEnumeration): String;
begin
  if AType = CCurrencyRateTypeSell then begin
    Result := CCurrencyRateTypeSellDesc;
  end else if AType = CCurrencyRateTypeBuy then begin
    Result := CCurrencyRateTypeBuyDesc;
  end else begin
    Result := CCurrencyRateTypeAverageDesc;
  end;
end;

procedure TAccount.SetidCurrencyDef(const Value: TDataGid);
begin
  if FidCurrencyDef <> Value then begin
    FidCurrencyDef := Value;
    SetState(msModified);
  end;
end;

constructor TCurrCacheItem.Create(AId, ASymbol, AIso: String);
begin
  inherited Create;
  FCurrI := AId;
  FCurrSymbol := ASymbol;
  FCurrIso := AIso;
end;

procedure TCurrCacheItem.SetCurrIso(const Value: String);
begin
  if FCurrIso <> Value then begin
    FCurrIso := Value;
  end;
end;

procedure TCurrCacheItem.SetCurrSymbol(const Value: String);
begin
  if FCurrSymbol <> Value then begin
    FCurrSymbol := Value;
    SetCurrencySymbol(FCurrI, FCurrSymbol);
    SendMessageToFrames(Nil, WM_MUSTREPAINT, 0, 0);
  end;
end;

procedure TCurrCache.Change(AId, ASymbol, AIso: String);
var xCur: TCurrCacheItem;
begin
  xCur := ById[AId];
  if xCur = Nil then begin
    xCur := TCurrCacheItem.Create(AId, ASymbol, AIso);
    Add(xCur);
  end else begin
    xCur.CurrSymbol := ASymbol;
    xCur.CurrIso := AIso;
  end;
end;

function TCurrCache.GetById(AId: String): TCurrCacheItem;
var xCount: Integer;
begin
  Result := Nil;
  xCount := 0;
  while (Result = Nil) and (xCount <= GCurrencyCache.Count - 1) do begin
    if AId = GCurrencyCache.Items[xCount].FCurrI then begin
      Result := GCurrencyCache.Items[xCount];
    end;
    Inc(xCount);
  end;
end;

function TCurrCache.GetByIso(AIso: String): TCurrCacheItem;
var xCount: Integer;
begin
  Result := Nil;
  xCount := 0;
  while (Result = Nil) and (xCount <= GCurrencyCache.Count - 1) do begin
    if AIso = GCurrencyCache.Items[xCount].FCurrIso then begin
      Result := GCurrencyCache.Items[xCount];
    end;
    Inc(xCount);
  end;
end;

function TCurrCache.GetIso(AId: String): String;
var xCur: TCurrCacheItem;
begin
  xCur := ById[AId];
  if xCur <> Nil then begin
    Result := xCur.CurrIso;
  end else begin
    Result := '';
  end;
end;

function TCurrCache.GetItems(AIndex: Integer): TCurrCacheItem;
begin
  Result := TCurrCacheItem(inherited Items[AIndex]);
end;

function TCurrCache.GetSymbol(AId: String): String;
var xCur: TCurrCacheItem;
begin
  xCur := ById[AId];
  if xCur <> Nil then begin
    Result := xCur.CurrSymbol;
  end else begin
    Result := '';
  end;
end;

procedure TCurrCache.SetItems(AIndex: Integer; const Value: TCurrCacheItem);
begin
  inherited Items[AIndex] := Value;
end;

class function TAccount.GetCurrencyDefinition(AIdAccount: TDataGid): TDataGid;
begin
  Result := GDataProvider.GetSqlString(Format('select idCurrencyDef from account where idAccount = %s', [DataGidToDatabase(AIdAccount)]), '');
end;

procedure TCurrencyRateHelper.Assign(Aquantity: Integer; Arate: Currency; ADesc: String; ASourceId, ATargerId: TDataGid);
begin
  Fquantity := Aquantity;
  Frate := Arate;
  Fdesc := ADesc;
  FidSourceCurrencyDef := ASourceId;
  FidTargetCurrencyDef := ATargerId;
end;

constructor TCurrencyRateHelper.Create(Aquantity: Integer; Arate: Currency; ADesc: String; ASourceId, ATargerId: TDataGid);
begin
  inherited Create;
  Fquantity := Aquantity;
  Frate := Arate;
  Fdesc := ADesc;
  FidSourceCurrencyDef := ASourceId;
  FidTargetCurrencyDef := ATargerId;
end;

function TCurrencyRateHelper.ExchangeCurrency(ACash: Currency; ASourceId, ATargerId: TDataGid): Currency;
begin
  if (ASourceId = FidSourceCurrencyDef) and (ATargerId = FidTargetCurrencyDef) then begin
    Result := SimpleRoundTo(ACash * Frate / Fquantity, -4);
  end else if (ASourceId = FidTargetCurrencyDef) and (ATargerId = FidSourceCurrencyDef) then begin
    Result := SimpleRoundTo(Fquantity * ACash / Frate, -4);
  end else begin
    Result := 0;
  end;
  Result := SimpleRoundTo(Result, -2);
end;

procedure TBaseMovement.SetcurrencyQuantity(const Value: Integer);
begin
  if FcurrencyQuantity <> Value then begin
    FcurrencyQuantity := Value;
    SetState(msModified);
  end;
end;

procedure TBaseMovement.SetcurrencyRate(const Value: Currency);
begin
  if FcurrencyRate <> Value then begin
    FcurrencyRate := Value;
    SetState(msModified);
  end;
end;

procedure TBaseMovement.SetidAccountCurrencyDef(const Value: TDataGid);
begin
  if FidAccountCurrencyDef <> Value then begin
    FidAccountCurrencyDef := Value;
    SetState(msModified);
  end;
end;

procedure TBaseMovement.SetidCurrencyRate(const Value: TDataGid);
begin
  if FidCurrencyRate <> Value then begin
    FidCurrencyRate := Value;
    SetState(msModified);
  end;
end;

procedure TBaseMovement.SetidMovementCurrencyDef(const Value: TDataGid);
begin
  if FidMovementCurrencyDef <> Value then begin
    FidMovementCurrencyDef := Value;
    SetState(msModified);
  end;
end;

procedure TBaseMovement.SetmovementCash(const Value: Currency);
begin
  if FmovementCash <> Value then begin
    FmovementCash := Value;
    SetState(msModified);
  end;
end;

procedure TBaseMovement.SetrateDescription(const Value: TBaseDescription);
begin
  if FrateDescription <> Value then begin
    FrateDescription := Value;
    SetState(msModified);
  end;
end;

function TCurrencyRate.OnDeleteObject(AProxy: TDataProxy): Boolean;
begin
  Result := inherited OnDeleteObject(AProxy);
  AProxy.DataProvider.ExecuteSql('update baseMovement set idCurrencyRate = null where idCurrencyRate = ' + DataGidToDatabase(id));
end;

class procedure TAccountCurrencyRule.DeleteRules(AIdAccount: TDataGid);
begin
  AccountCurrencyRuleProxy.DataProvider.ExecuteSql('delete from accountCurrencyRule where idAccount = ' + DataGidToDatabase(AIdAccount));
end;

class function TAccountCurrencyRule.FindRateByRule(ADate: TDateTime; AmovementType: TBaseEnumeration; AIdAccount, ASourceCurrency: TDataGid): TCurrencyRate;
var xTr: Boolean;
    xRule: TAccountCurrencyRule;
begin
  Result := Nil;
  xTr := GDataProvider.InTransaction;
  if not xTr then begin
    GDataProvider.BeginTransaction;
  end;
  xRule := FindRule(AmovementType, AIdAccount);
  if xRule <> Nil then begin
    Result := TCurrencyRate.FindRate(xRule.rateType, TAccount.GetCurrencyDefinition(AIdAccount), ASourceCurrency, xRule.idCashPoint, ADate);
  end;
  if not xTr then begin
    GDataProvider.RollbackTransaction;
  end;
end;

class function TAccountCurrencyRule.FindRule(AmovementType: TBaseEnumeration; AIdAccount: TDataGid): TAccountCurrencyRule;
var xD: TDataObjectList;
begin
  xD := TDataObject.GetList(TAccountCurrencyRule, AccountCurrencyRuleProxy,
           Format('select * from accountCurrencyRule where movementType = ''%s'' and idAccount = %s',
                  [AmovementType, DataGidToDatabase(AIdAccount)]));
  if xD.Count > 0 then begin
    Result := TAccountCurrencyRule(xD.Items[0]);
  end else begin
    Result := Nil;
  end;
  xD.Free;
end;

class function TAccountCurrencyRule.FindRules(AIdAccount: TDataGid): TDataObjectList;
begin
  Result := TDataObject.GetList(TAccountCurrencyRule, AccountCurrencyRuleProxy,
            Format('select * from accountCurrencyRule where idAccount = %s',
                  [DataGidToDatabase(AIdAccount)]));
end;

procedure TAccountCurrencyRule.FromDataset(ADataset: TADOQuery);
begin
  inherited FromDataset(ADataset);
  with ADataset do begin
    FidCashPoint := FieldByName('idCashPoint').AsString;
    FidAccount := FieldByName('idAccount').AsString;
    FrateType := FieldByName('rateType').AsString;
    FmovementType := FieldByName('movementType').AsString;
  end;
end;

procedure TAccountCurrencyRule.SetidAccount(const Value: TDataGid);
begin
  if FidAccount <> Value then begin
    FidAccount := Value;
    SetState(msModified);
  end;
end;

procedure TAccountCurrencyRule.SetidCashPoint(const Value: TDataGid);
begin
  if FidCashPoint <> Value then begin
    FidCashPoint := Value;
    SetState(msModified);
  end;
end;

procedure TAccountCurrencyRule.SetmovementType(const Value: TBaseEnumeration);
begin
  if movementType <> Value then begin
    FmovementType := Value;
    SetState(msModified);
  end;
end;

procedure TAccountCurrencyRule.SetrateType(const Value: TBaseEnumeration);
begin
  if FrateType <> Value then begin
    FrateType := Value;
    SetState(msModified);
  end;
end;

procedure TAccountCurrencyRule.UpdateFieldList;
begin
  inherited UpdateFieldList;
  with DataFieldList do begin
    AddField('idCashPoint', DataGidToDatabase(FidCashPoint), False, 'accountCurrencyRule');
    AddField('idAccount', DataGidToDatabase(FidAccount), False, 'accountCurrencyRule');
    AddField('rateType', FrateType, True, 'accountCurrencyRule');
    AddField('movementType', FmovementType, True, 'accountCurrencyRule');
  end;
end;

procedure TBaseMovement.SetidExtractionItem(const Value: TDataGid);
begin
  if FidExtractionItem <> Value then begin
    FidExtractionItem := Value;
    if FidExtractionItem <> CEmptyDataGid then begin
      FisStated := True;
    end else begin
      FisStated := False;
    end;
    SetState(msModified);
  end;
end;

procedure TAccountExtraction.Setdescription(const Value: TBaseDescription);
begin
  if Fdescription <> Value then begin
    Fdescription := Value;
    SetState(msModified);
  end;
end;

procedure TAccountExtraction.SetendDate(const Value: TDateTime);
begin
  if FendDate <> Value then begin
    FendDate := Value;
    SetState(msModified);
  end;
end;

procedure TAccountExtraction.SetidAccount(const Value: TDataGid);
begin
  if FidAccount <> Value then begin
    FidAccount := Value;
    SetState(msModified);
  end;
end;

procedure TAccountExtraction.SetstartDate(const Value: TDateTime);
begin
  if FstartDate <> Value then begin
    FstartDate := Value;
    SetState(msModified);
  end;
end;

procedure TAccountExtraction.SetExtractionState(const Value: TBaseEnumeration);
begin
  if FextractionState <> Value then begin
    FextractionState := Value;
    SetState(msModified);
  end;
end;

procedure TExtractionItem.FromDataset(ADataset: TADOQuery);
begin
  inherited FromDataset(ADataset);
  with ADataset do begin
    Fdescription := FieldByName('description').AsString;
    FregDate := FieldByName('regDate').AsDateTime;
    FaccountingDate := FieldByName('accountingDate').AsDateTime;
    FmovementType := FieldByName('movementType').AsString;
    FidCurrencyDef := FieldByName('idCurrencyDef').AsString;
    FidAccountExtraction := FieldByName('idAccountExtraction').AsString;
    Fcash := FieldByName('cash').AsCurrency;
  end;
end;

function TExtractionItem.GetColumnImage(AColumnIndex: Integer): Integer;
begin
  Result := -1;
  if AColumnIndex = 5 then begin
    Result := IfThen(FmovementType = CInMovement, 0, 1);
  end;
end;

function TExtractionItem.GetColumnText(AColumnIndex: Integer; AStatic: Boolean): String;
begin
  if AColumnIndex = 1 then begin
    Result := DateToStr(FregDate);
  end else if AColumnIndex = 2 then begin
    Result := Fdescription;
  end else if AColumnIndex = 3 then begin
    Result := CurrencyToString(IfThen(FmovementType = CInMovement, 1, -1) * cash, '', False);
  end else if AColumnIndex = 4 then begin
    Result := GCurrencyCache.GetSymbol(FidCurrencyDef);
  end else if AColumnIndex = 5 then begin
    Result := IfThen(FmovementType = CInMovement, 'Uznanie', 'Obci��enie');
  end;
end;

function TExtractionItem.GetElementText: String;
begin
  Result := Fdescription;
end;

function TExtractionItem.OnDeleteObject(AProxy: TDataProxy): Boolean;
begin
  Result := inherited OnDeleteObject(AProxy);
  AProxy.DataProvider.ExecuteSql('update baseMovement set idExtractionItem = null where idExtractionItem = ' + DataGidToDatabase(id));
  AProxy.DataProvider.ExecuteSql('update movementList set idExtractionItem = null where idExtractionItem = ' + DataGidToDatabase(id));
end;

procedure TExtractionItem.SetaccountingDate(const Value: TDateTime);
begin
  if FaccountingDate <> Value then begin
    FaccountingDate := Value;
    SetState(msModified);
  end;
end;

procedure TExtractionItem.Setcash(const Value: Currency);
begin
  if Fcash <> Value then begin
    Fcash := Value;
    SetState(msModified);
  end;
end;

procedure TExtractionItem.Setdescription(const Value: TBaseDescription);
begin
  if Fdescription <> Value then begin
    Fdescription := Value;
    SetState(msModified);
  end;
end;

procedure TExtractionItem.SetidAccountExtraction(const Value: TDataGid);
begin
  if FidAccountExtraction <> Value then begin
    FidAccountExtraction := Value;
    SetState(msModified);
  end;
end;

procedure TExtractionItem.SetidCurrencyDef(const Value: TDataGid);
begin
  if FidCurrencyDef <> Value then begin
    FidCurrencyDef := Value;
    SetState(msModified);
  end;
end;

procedure TExtractionItem.SetmovementType(const Value: TBaseEnumeration);
begin
  if FmovementType <> Value then begin
    FmovementType := Value;
    SetState(msModified);
  end;
end;

procedure TExtractionItem.SetregDate(const Value: TDateTime);
begin
  if FregDate <> Value then begin
    FregDate := Value;
    SetState(msModified);
  end;
end;

procedure TAccountExtraction.FromDataset(ADataset: TADOQuery);
begin
  inherited FromDataset(ADataset);
  with ADataset do begin
    FidAccount := FieldByName('idAccount').AsString;
    FextractionState := FieldByName('state').AsString;
    FstartDate := FieldByName('startDate').AsDateTime;
    FendDate := FieldByName('endDate').AsDateTime;
    FregDate := FieldByName('regDate').AsDateTime;
    Fdescription := FieldByName('description').AsString;
  end;
end;

procedure TAccountExtraction.UpdateFieldList;
begin
  inherited UpdateFieldList;
  with DataFieldList do begin
    AddField('idAccount', FidAccount, True, 'accountExtraction');
    AddField('state', FextractionState, True, 'accountExtraction');
    AddField('startDate', DatetimeToDatabase(FstartDate, False), False, 'accountExtraction');
    AddField('endDate', DatetimeToDatabase(FendDate, False), False, 'accountExtraction');
    AddField('regDate', DatetimeToDatabase(FregDate, False), False, 'accountExtraction');
    AddField('description', Fdescription, True, 'accountExtraction');
  end;
end;

procedure TExtractionItem.UpdateFieldList;
begin
  inherited UpdateFieldList;
  with DataFieldList do begin
    AddField('description', Fdescription, True, 'extractionItem');
    AddField('regDate', DatetimeToDatabase(FregDate, False), False, 'extractionItem');
    AddField('accountingDate', DatetimeToDatabase(FaccountingDate, False), False, 'extractionItem');
    AddField('movementType', FmovementType, True, 'extractionItem');
    AddField('idCurrencyDef', DataGidToDatabase(FidCurrencyDef), False, 'extractionItem');
    AddField('idAccountExtraction', DataGidToDatabase(FidAccountExtraction), False, 'extractionItem');
    AddField('cash', CurrencyToDatabase(Fcash), False, 'extractionItem');
  end;
end;

procedure TAccountExtraction.SetregDate(const Value: TDateTime);
begin
  if FregDate <> Value then begin
    FregDate := Value;
    SetState(msModified);
  end;
end;

function TAccountExtraction.GetColumnText(AColumnIndex: Integer; AStatic: Boolean): String;
begin
  if AColumnIndex = 4 then begin
    if FextractionState = CExtractionStateOpen then begin
      Result := CExtractionStateOpenDescription;
    end else if FextractionState = CExtractionStateClose then begin
      Result := CExtractionStateCloseDescription;
    end else begin
      Result := CExtractionStateStatedDescription;
    end;
  end else if AColumnIndex = 3 then begin
    Result := DateToStr(FendDate);
  end else if AColumnIndex = 2 then begin
    Result := DateToStr(FstartDate);
  end else if AColumnIndex = 1 then begin
    Result := description; 
  end else begin
    Result := DateToStr(FregDate);
  end;
end;

function TAccountExtraction.GetMovements: TDataObjectList;
begin
  Result := TExtractionItem.GetList(TExtractionItem, ExtractionItemProxy, 'select * from extractionItem where idAccountExtraction = ' + DataGidToDatabase(id));
end;

procedure TMovementList.SetidExtractionItem(const Value: TDataGid);
begin
  if FidExtractionItem <> Value then begin
    FidExtractionItem := Value;
    if FidExtractionItem <> CEmptyDataGid then begin
      FisStated := True;
    end else begin
      FisStated := False;
    end;
    SetState(msModified);
  end;
end;

function TAccountExtraction.GetColumnImage(AColumnIndex: Integer): Integer;
begin
  Result := -1;
  if AColumnIndex = 4 then begin
    if FextractionState = CExtractionStateOpen then begin
      Result := 0;
    end else if FextractionState = CExtractionStateClose then begin
      Result := 1;
    end else begin
      Result := 2;
    end;
  end;
end;

procedure TMovementList.SetisStated(const Value: Boolean);
begin
  if FisStated <> Value then begin
    FisStated := Value;
    if not FisStated then begin
      FidExtractionItem := CEmptyDataGid;
    end;
    SetState(msModified);
  end;
end;

procedure TBaseMovement.SetisStated(const Value: Boolean);
begin
  if FisStated <> Value then begin
    FisStated := Value;
    if not FisStated then begin
      FidExtractionItem := CEmptyDataGid;
    end;
    SetState(msModified);
  end;
end;

constructor TMovementList.Create(AStatic: Boolean);
begin
  inherited Create(AStatic);
  FidAccount := CEmptyDataGid;
  FidCashPoint := CEmptyDataGid;
  FidAccountCurrencyDef := CEmptyDataGid;
  FidExtractionItem := CEmptyDataGid;
  FisStated := False;
end;

procedure TBaseMovement.SetidSourceExtractionItem(const Value: TDataGid);
begin
  if FidSourceExtractionItem <> Value then begin
    FidSourceExtractionItem := Value;
    if FidSourceExtractionItem <> CEmptyDataGid then begin
      FisSourceStated := True;
    end else begin
      FisSourceStated := False;
    end;
    SetState(msModified);
  end;
end;

procedure TBaseMovement.SetisSourceStated(const Value: Boolean);
begin
  if FisSourceStated <> Value then begin
    FisSourceStated := Value;
    if not FisSourceStated then begin
      FidSourceExtractionItem := CEmptyDataGid;
    end;
    SetState(msModified);
  end;
end;

function TAccountExtraction.GetElementText: String;
begin
  Result := Fdescription;
end;

initialization
  GCurrencyCache := TCurrCache.Create(True);
finalization
  GCurrencyCache.Free;
end.
