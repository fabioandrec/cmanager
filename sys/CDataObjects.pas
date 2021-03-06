unit CDataObjects;

interface

uses CDatabase, SysUtils, AdoDb, Classes, CConsts, CComponents, Math, Contnrs,
     CTools, CTemplates;

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
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String; override;
    function GetElementHint(AColumnIndex: Integer): String; override;
    procedure DeleteObject; override;
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
    procedure Setdescription(const Value: TBaseDescription);
    procedure Setname(const Value: TBaseName);
    procedure Setiso(const Value: TBaseName);
    procedure Setsymbol(const Value: TBaseName);
  public
    procedure UpdateFieldList; override;
    procedure FromDataset(ADataset: TADOQuery); override;
    function GetElementText: String; override;
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String; override;
    function GetElementHint(AColumnIndex: Integer): String; override;
    class function CanBeDeleted(AId: ShortString): Boolean; override;
    class function FindByIso(AIso: TBaseName): TCurrencyDef;
    constructor Create(AStatic: Boolean); override;
    procedure AfterPost; override;
    procedure DeleteObject; override;
  published
    property name: TBaseName read Fname write Setname;
    property symbol: TBaseName read Fsymbol write Setsymbol;
    property iso: TBaseName read Fiso write Setiso;
    property description: TBaseDescription read Fdescription write Setdescription;
  end;

  TUnitDef = class(TDataObject)
  private
    Fname: TBaseName;
    Fsymbol: TBaseName;
    FpreviousSymbol: TBaseName;
    Fdescription: TBaseDescription;
    procedure Setdescription(const Value: TBaseDescription);
    procedure Setname(const Value: TBaseName);
    procedure Setsymbol(const Value: TBaseName);
  public
    procedure UpdateFieldList; override;
    procedure FromDataset(ADataset: TADOQuery); override;
    class function CanBeDeleted(AId: ShortString): Boolean; override;
    function GetElementText: String; override;
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String; override;
    function GetElementHint(AColumnIndex: Integer): String; override;
    procedure AfterPost; override;
  published
    property name: TBaseName read Fname write Setname;
    property symbol: TBaseName read Fsymbol write Setsymbol;
    property description: TBaseDescription read Fdescription write Setdescription;
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
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String; override;
    function GetElementHint(AColumnIndex: Integer): String; override;
    class function FindRate(ARateType: TBaseEnumeration; ASourceId, ATargetId, ACashpointId: TDataGid; ABindingDate: TDateTime; AExactlyAtBindingdate: Boolean = True): TCurrencyRate;
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
    FaccountState: TBaseEnumeration;
    procedure Setdescription(const Value: TBaseDescription);
    procedure Setname(const Value: TBaseName);
    procedure Setcash(const Value: Currency);
    procedure SetaccountType(const Value: TBaseEnumeration);
    procedure SetaccountNumber(const Value: TAccountNumber);
    procedure SetidCashPoint(const Value: TDataGid);
    procedure SetinitialBalance(const Value: Currency);
    procedure SetidCurrencyDef(const Value: TDataGid);
    procedure SetAccountState(const Value: TBaseEnumeration);
  public
    procedure UpdateFieldList; override;
    procedure FromDataset(ADataset: TADOQuery); override;
    class function CanBeDeleted(AId: ShortString): Boolean; override;
    class function AccountBalanceOnDay(AIdAccount: TDataGid; ADateTime: TDateTime): Currency;
    class function GetMovementCount(AIdAccount: TDataGid): Integer;
    class function GetCurrencyDefinition(AIdAccount: TDataGid): TDataGid;
    function GetElementText: String; override;
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String; override;
    function GetElementCompare(AColumnIndex: Integer; ACompareWith: TCDataListElementObject; AViewTextSelector: String): Integer; override;
    function GetElementHint(AColumnIndex: Integer): String; override;
    procedure DeleteObject; override;
  published
    property name: TBaseName read Fname write Setname;
    property description: TBaseDescription read Fdescription write Setdescription;
    property accountType: TBaseEnumeration read FaccountType write SetaccountType;
    property cash: Currency read Fcash write Setcash;
    property initialBalance: Currency read FinitialBalance write SetinitialBalance;
    property accountNumber: TAccountNumber read FaccountNumber write SetaccountNumber;
    property idCashPoint: TDataGid read FidCashPoint write SetidCashPoint;
    property idCurrencyDef: TDataGid read FidCurrencyDef write SetidCurrencyDef;
    property accountState: TBaseEnumeration read FaccountState write SetAccountState;
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
  protected
    function OnDeleteObject(AProxy: TDataProxy): Boolean; override;
  public
    procedure UpdateFieldList; override;
    procedure FromDataset(ADataset: TADOQuery); override;
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String; override;
    function GetMovements: TDataObjectList;
    function GetColumnImage(AColumnIndex: Integer): Integer; override;
    function GetElementText: String; override;
    class function FindAccountExtraction(AIdAccount: TDataGid; ARegDate: TDateTime): TAccountExtraction;
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
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String; override;
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
    FidUnitDef: TDataGid;
    procedure Setdescription(const Value: TBaseDescription);
    procedure Setname(const Value: TBaseName);
    procedure SetidParentProduct(const Value: TDataGid);
    function GettreeDesc: String;
    procedure SetproductType(const Value: TBaseEnumeration);
    procedure SetidUnitDef(const Value: TDataGid);
  public
    procedure UpdateFieldList; override;
    procedure FromDataset(ADataset: TADOQuery); override;
    class function CanBeDeleted(AId: ShortString): Boolean; override;
    class function CanChangeUnitdef(AId: ShortString): Boolean;
    class function HasSubcategory(AId: TDataGid): Boolean;
    class function HasQuantity(AId: TDataGid): TDataGid;
    function GetElementText: String; override;
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String; override;
    function GetElementHint(AColumnIndex: Integer): String; override;
    procedure DeleteObject; override;
  published
    property name: TBaseName read Fname write Setname;
    property description: TBaseDescription read Fdescription write Setdescription;
    property idParentProduct: TDataGid read FidParentProduct write SetidParentProduct;
    property treeDesc: String read GettreeDesc;
    property productType: TBaseEnumeration read FproductType write SetproductType;
    property idUnitDef: TDataGid read FidUnitDef write SetidUnitDef;
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
    procedure AfterPost; override;
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

  TQuickPattern = class(TDataObject)
  private
    Fname: TBaseName;
    Fdescription: TBaseDescription;
    FmovementType: TBaseEnumeration;
    FidAccount: TDataGid;
    FidSourceAccount: TDataGid;
    FidCashPoint: TDataGid;
    FidProduct: TDataGid;
    procedure Setdescription(const Value: TBaseDescription);
    procedure SetidAccount(const Value: TDataGid);
    procedure SetmovementType(const Value: TBaseEnumeration);
    procedure SetidSourceAccount(const Value: TDataGid);
    procedure SetidCashPoint(const Value: TDataGid);
    procedure SetidProduct(const Value: TDataGid);
    procedure Setname(const Value: TBaseName);
  public
    procedure UpdateFieldList; override;
    procedure FromDataset(ADataset: TADOQuery); override;
    constructor Create(AStatic: Boolean); override;
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String; override;
    function GetElementText: String; override;
    function GetElementHint(AColumnIndex: Integer): String; override;
  published
    property name: TBaseName read Fname write Setname;
    property description: TBaseDescription read Fdescription write Setdescription;
    property movementType: TBaseEnumeration read FmovementType write SetmovementType;
    property idAccount: TDataGid read FidAccount write SetidAccount;
    property idSourceAccount: TDataGid read FidSourceAccount write SetidSourceAccount;
    property idCashPoint: TDataGid read FidCashPoint write SetidCashPoint;
    property idProduct: TDataGid read FidProduct write SetidProduct;
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
    FprevIdAccountCurrencyDef: TDataGid;
    FprevIdMovementCurrencyDef: TDataGid;
    FprevIdCashPoint: TDataGid;
    FprevIdProduct: TDataGid;
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
    Fquantity: Double;
    FidUnitDef: TDataGid;
    FisInvestmentMovement: Boolean;
    FisDepositMovement: Boolean;
    FaccountName: TBaseName;
    FsourceAccountName: TBaseName;
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
    procedure Setquantity(const Value: Double);
    procedure SetidUnitDef(const Value: TDataGid);
    procedure SetisInvestmentMovement(const Value: Boolean);
    procedure SetidDepositMovement(const Value: Boolean);
  protected
    function OnDeleteObject(AProxy: TDataProxy): Boolean; override;
    function OnInsertObject(AProxy: TDataProxy): Boolean; override;
    function OnUpdateObject(AProxy: TDataProxy): Boolean; override;
  public
    procedure UpdateFieldList; override;
    procedure FromDataset(ADataset: TADOQuery); override;
    constructor Create(AStatic: Boolean); override;
    procedure AfterPost; override;
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
    property quantity: Double read Fquantity write Setquantity;
    property idUnitDef: TDataGid read FidUnitDef write SetidUnitDef;
    property isInvestmentMovement: Boolean read FisInvestmentMovement write SetisInvestmentMovement;
    property isDepositMovement: Boolean read FisDepositMovement write SetidDepositMovement;
    property accountName: TBaseName read FaccountName;
    property sourceAccountName: TBaseName read FsourceAccountName;
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
    Fquantity: Double;
    FidUnitDef: TDataGid;
    FidDestAccount: TDataGid;
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
    procedure Setquantity(const Value: Double);
    procedure SetidUnitDef(const Value: TDataGid);
    procedure SetidDestAccount(const Value: TDataGid);
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
    property quantity: Double read Fquantity write Setquantity;
    property idUnitDef: TDataGid read FidUnitDef write SetidUnitDef;
    property idDestAccount: TDataGid read FidDestAccount write SetidDestAccount;
  end;

  TPlannedDone = class(TDataObject)
  private
    FtriggerDate: TDateTime;
    FdueDate: TDateTime;
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
    procedure SetdueDate(const Value: TDateTime);
  public
    procedure UpdateFieldList; override;
    procedure FromDataset(ADataset: TADOQuery); override;
    constructor Create(AStatic: Boolean); override;
  published
    property triggerDate: TDateTime read FtriggerDate write SettriggerDate;
    property dueDate: TDateTime read FdueDate write SetdueDate;
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
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String; override;
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
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String; override;
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
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String; override;
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
    FComponentTag: Integer;
    FCurrId: String;
    FCurrSymbol: String;
    FCurrIso: String;
    procedure SetCurrSymbol(const Value: String);
    procedure SetCurrIso(const Value: String);
  public
    constructor Create(AComponentTag: Integer; AId, ASymbol, AIso: String);
  published
    property CurrSymbol: String read FCurrSymbol write SetCurrSymbol;
    property CurrIso: String read FCurrIso write SetCurrIso;
    property CurrId: String read FCurrId;
  end;

  TCurrCache = class(TObjectList)
  private
    FComponentTag: Integer;
    function GetItems(AIndex: Integer): TCurrCacheItem;
    procedure SetItems(AIndex: Integer; const Value: TCurrCacheItem);
    function GetById(AId: String): TCurrCacheItem;
    function GetByIso(AIso: String): TCurrCacheItem;
  public
    constructor Create(AComponentTag: Integer);
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
    FuseOldRates: Boolean;
    procedure SetidAccount(const Value: TDataGid);
    procedure SetidCashPoint(const Value: TDataGid);
    procedure SetmovementType(const Value: TBaseEnumeration);
    procedure SetrateType(const Value: TBaseEnumeration);
    procedure SetuseOldRates(const Value: Boolean);
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
    property useOldRates: Boolean read FuseOldRates write SetuseOldRates;
  end;

  TReportDef = class(TDataObject)
  private
    Fname: TBaseName;
    Fdescription: TBaseDescription;
    FqueryText: string;
    FparamsDefs: string;
    FxsltText: String;
    FxsltType: TBaseEnumeration;
    procedure Setdescription(const Value: TBaseDescription);
    procedure Setname(const Value: TBaseName);
    procedure SetparamsDefs(const Value: string);
    procedure SetqueryText(const Value: string);
    procedure SetxsltText(const Value: string);
    procedure SetxsltType(const Value: TBaseEnumeration);
  public
    procedure UpdateFieldList; override;
    procedure FromDataset(ADataset: TADOQuery); override;
  published
    property name: TBaseName read Fname write Setname;
    property description: TBaseDescription read Fdescription write Setdescription;
    property queryText: string read FqueryText write SetqueryText;
    property paramsDefs: string read FparamsDefs write SetparamsDefs;
    property xsltText: string read FxsltText write SetxsltText;
    property xsltType: TBaseEnumeration read FxsltType write SetxsltType;
  end;

  TInstrument = class(TDataObject)
  private
    Fsymbol: TBaseName;
    Fname: TBaseName;
    Fdescription: TBaseDescription;
    FidCashpoint: TDataGid;
    FidCurrencyDef: TDataGid;
    FinstrumentType: TBaseEnumeration;
    procedure SetidCashpoint(const Value: TDataGid);
    procedure SetidCurrencyDef(const Value: TDataGid);
    procedure Setdescription(const Value: TBaseDescription);
    procedure Setname(const Value: TBaseName);
    procedure SetinstrumentType(const Value: TBaseEnumeration);
    procedure Setsymbol(const Value: TBaseName);
  protected
    function GetHash(AHashId: Integer): String; override;
  public
    function GetElementText: String; override;
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String; override;
    function GetElementHint(AColumnIndex: Integer): String; override;
    procedure UpdateFieldList; override;
    procedure FromDataset(ADataset: TADOQuery); override;
    constructor Create(AStatic: Boolean); override;
    class function FindByName(AName: TBaseName): TInstrument;
    class function FindBySymbol(ASymbol: TBaseName): TInstrument;
    class function CanBeDeleted(AId: ShortString): Boolean; override;
    class function GetCurrencyDefinition(AIdInstrument: TDataGid): TDataGid;
  published
    property symbol: TBaseName read Fsymbol write Setsymbol;
    property name: TBaseName read Fname write Setname;
    property description: TBaseDescription read Fdescription write Setdescription;
    property idCashpoint: TDataGid read FidCashpoint write SetidCashpoint;
    property idCurrencyDef: TDataGid read FidCurrencyDef write SetidCurrencyDef;
    property instrumentType: TBaseEnumeration read FinstrumentType write SetinstrumentType;
  end;

  TInstrumentValue = class(TDataObject)
  private
    Fdescription: TBaseDescription;
    FidInstrument: TDataGid;
    FregDateTime: TDateTime;
    FvalueOf: Currency;
    FinstrumentType: TBaseEnumeration;
    FidCurrencyDef: TDataGid;
    procedure Setdescription(const Value: TBaseDescription);
    procedure SetidInstrument(const Value: TDataGid);
    procedure SetregDateTime(const Value: TDateTime);
    procedure SetvalueOf(const Value: Currency);
  protected
    function OnDeleteObject(AProxy: TDataProxy): Boolean; override;
  public
    function GetElementText: String; override;
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String; override;
    function GetElementHint(AColumnIndex: Integer): String; override;
    procedure UpdateFieldList; override;
    procedure FromDataset(ADataset: TADOQuery); override;
    constructor Create(AStatic: Boolean); override;
    class function FindValue(AIdInstrument: TDataGid; ADateTime: TDateTime): TInstrumentValue;
  published
    property description: TBaseDescription read Fdescription write Setdescription;
    property idInstrument: TDataGid read FidInstrument write SetidInstrument;
    property regDateTime: TDateTime read FregDateTime write SetregDateTime;
    property valueOf: Currency read FvalueOf write SetvalueOf;
    property instrumentType: TBaseEnumeration read FinstrumentType;
    property idCurrencyDef: TDataGid read FidCurrencyDef;
  end;

  TInvestmentItem = class(TDataObject)
  private
    FidAccount: TDataGid;
    FidInstrument: TDataGid;
    Fquantity: Double;
    procedure SetidInstrument(const Value: TDataGid);
    procedure SetidAccount(const Value: TDataGid);
    procedure Setquantity(const Value: Double);
  public
    constructor Create(AStatic: Boolean); override;
    procedure UpdateFieldList; override;
    procedure FromDataset(ADataset: TADOQuery); override;
    class function FindInvestmentItem(AIdInstrument, AIdAccount: TDataGid; AMinimumQuantity: Double = -1): TInvestmentItem;
    function GetInvestmentItems: TDataObjectList;
  published
    property idAccount: TDataGid read FidAccount write SetidAccount;
    property idInstrument: TDataGid read FidInstrument write SetidInstrument;
    property quantity: Double read Fquantity write Setquantity;
  end;

  TInvestmentMovement = class(TDataObject)
  private
    Fdescription: TBaseDescription;
    FmovementType: TBaseEnumeration;
    FregDateTime: TDateTime;
    FweekDate: TDateTime;
    FmonthDate: TDateTime;
    FyearDate: TDateTime;
    FidInstrument: TDataGid;
    FprevIdInstrument: TDataGid;
    FidInstrumentCurrencyDef: TDataGid;
    Fquantity: Double;
    FprevQuantity: Double;
    FidInstrumentValue: TDataGid;
    FvalueOf: Currency;
    FsummaryOf: Currency;
    FidAccount: TDataGid;
    FprevIdAccount: TDataGid;
    FidAccountCurrencyDef: TDataGid;
    FvalueOfAccount: Currency;
    FsummaryOfAccount: Currency;
    FidProduct: TDataGid;
    FidCurrencyRate: TDataGid;
    FcurrencyQuantity: Integer;
    FcurrencyRate: Currency;
    FrateDescription: TBaseDescription;
    FidBaseMovement: TDataGid;
    procedure Setdescription(const Value: TBaseDescription);
    procedure SetidAccount(const Value: TDataGid);
    procedure SetidAccountCurrencyDef(const Value: TDataGid);
    procedure SetidBaseMovement(const Value: TDataGid);
    procedure SetidCurrencyRate(const Value: TDataGid);
    procedure SetidInstrument(const Value: TDataGid);
    procedure SetidInstrumentCurrencyDef(const Value: TDataGid);
    procedure SetidInstrumentValue(const Value: TDataGid);
    procedure SetidProduct(const Value: TDataGid);
    procedure SetmovementType(const Value: TBaseEnumeration);
    procedure Setquantity(const Value: Double);
    procedure SetregDateTime(const Value: TDateTime);
    procedure SetsummaryOf(const Value: Currency);
    procedure SetsummaryOfAccount(const Value: Currency);
    procedure SetvalueOf(const Value: Currency);
    procedure SetvalueOfAccount(const Value: Currency);
    procedure SetcurrencyQuantity(const Value: Integer);
    procedure SetcurrencyRate(const Value: Currency);
    procedure SetrateDescription(const Value: TBaseDescription);
  protected
    function OnDeleteObject(AProxy: TDataProxy): Boolean; override;
    function OnInsertObject(AProxy: TDataProxy): Boolean; override;
    function OnUpdateObject(AProxy: TDataProxy): Boolean; override;
  public
    constructor Create(AStatic: Boolean); override;
    procedure UpdateFieldList; override;
    procedure FromDataset(ADataset: TADOQuery); override;
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String; override;
    function GetColumnImage(AColumnIndex: Integer): Integer; override;
    procedure AfterPost; override;
    function GetElementText: String; override;
  published
    property description: TBaseDescription read Fdescription write Setdescription;
    property movementType: TBaseEnumeration read FmovementType write SetmovementType;
    property regDateTime: TDateTime read FregDateTime write SetregDateTime;
    property weekDate: TDateTime read FweekDate;
    property monthDate: TDateTime read FmonthDate;
    property yearDate: TDateTime read FyearDate;
    property idInstrument: TDataGid read FidInstrument write SetidInstrument;
    property idInstrumentCurrencyDef: TDataGid read FidInstrumentCurrencyDef write SetidInstrumentCurrencyDef;
    property quantity: Double read Fquantity write Setquantity;
    property idInstrumentValue: TDataGid read FidInstrumentValue write SetidInstrumentValue;
    property valueOf: Currency read FvalueOf write SetvalueOf;
    property summaryOf: Currency read FsummaryOf write SetsummaryOf;
    property idAccount: TDataGid read FidAccount write SetidAccount;
    property idAccountCurrencyDef: TDataGid read FidAccountCurrencyDef write SetidAccountCurrencyDef;
    property valueOfAccount: Currency read FvalueOfAccount write SetvalueOfAccount;
    property summaryOfAccount: Currency read FsummaryOfAccount write SetsummaryOfAccount;
    property idProduct: TDataGid read FidProduct write SetidProduct;
    property idCurrencyRate: TDataGid read FidCurrencyRate write SetidCurrencyRate;
    property idBaseMovement: TDataGid read FidBaseMovement write SetidBaseMovement;
    property currencyQuantity: Integer read FcurrencyQuantity write SetcurrencyQuantity;
    property currencyRate: Currency read FcurrencyRate write SetcurrencyRate;
    property rateDescription: TBaseDescription read FrateDescription write SetrateDescription;
  end;

  TInvestmentPortfolio = class(TDataObject)
  private
    FidInstrument: TDataGid;
    FidCurrencyDef: TDataGid;
    FidAccount: TDataGid;
    FinstrumentName: TBaseName;
    FaccountName: TBaseName;
    FinstrumentType: TBaseEnumeration;
    Fquantity: Double;
    FvalueOf: Currency;
    function GetoverallValue: Currency;
  public
    procedure FromDataset(ADataset: TADOQuery); override;
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String; override;
    function GetElementText: String; override;
  published
    property idInstrument: TDataGid read FidInstrument;
    property idCurrencyDef: TDataGid read FIdCurrencyDef;
    property idAccount: TDataGid read FidAccount;
    property instrumentName: TBaseName read FinstrumentName;
    property accountName: TBaseName read FaccountName;
    property instrumentType: TBaseEnumeration read FinstrumentType;
    property quantity: Double read Fquantity;
    property valueOf: Currency read FvalueOf;
    property overallValue: Currency read GetoverallValue;
  end;

  TQuickPatternElement = class(TCDataListElementObject)
  private
    Fname: TBaseDescription;
    Fdescription: TBaseDescription;
    FmovementType: TBaseEnumeration;
    FidAccount: TDataGid;
    FidSourceAccount: TDataGid;
    FidCashPoint: TDataGid;
    FidProduct: TDataGid;
    FisStatistic: Boolean;
  public
    constructor Create(AName: TBaseDescription; ADesc: TBaseDescription; AMovementType: TBaseEnumeration;
                       AIdAccount, AIdSourceAccount, AIdCashpoint, AIdProduct: TDataGid; AIsStatistic: Boolean);
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String; override;
    function GetElementHint(AColumnIndex: Integer): String; override;
    function GetColumnImage(AColumnIndex: Integer): Integer; override;
  published
    property movementType: TBaseEnumeration read FmovementType;
    property idAccount: TDataGid read FidAccount;
    property idSourceAccount: TDataGid read FidSourceAccount;
    property idCashPoint: TDataGid read FidCashPoint;
    property idProduct: TDataGid read FidProduct;
    property isStatistic: Boolean read FisStatistic write FisStatistic;
  end;

  TDepositInvestment = class(TDataObject)
  private
    FdepositState: TBaseEnumeration;
    Fname: TBaseName;
    Fdescription: TBaseDescription;
    FidCashPoint: TDataGid;
    FidCurrencyDef: TDataGid;
    Fcash: Currency;
    FinterestRate: Currency;
    FnoncapitalizedInterest: Currency;
    FperiodCount: Integer;
    FperiodType: TBaseEnumeration;
    FperiodStartDate: TDateTime;
    FperiodEndDate: TDateTime;
    FperiodAction: TBaseEnumeration;
    FdueCount: Integer;
    FdueType: TBaseEnumeration;
    FdueStartDate: TDateTime;
    FdueEndDate: TDateTime;
    FdueAction: TBaseEnumeration;
    FcalcTax: Boolean;
    FtaxRate: Currency;
    procedure Setcash(const Value: Currency);
    procedure SetdepositState(const Value: TBaseEnumeration);
    procedure Setdescription(const Value: TBaseDescription);
    procedure SetdueAction(const Value: TBaseEnumeration);
    procedure SetdueCount(const Value: Integer);
    procedure SetdueStartDate(const Value: TDateTime);
    procedure SetdueEndDate(const Value: TDateTime);
    procedure SetdueType(const Value: TBaseEnumeration);
    procedure SetidCashPoint(const Value: TDataGid);
    procedure SetidCurrencyDef(const Value: TDataGid);
    procedure SetinterestRate(const Value: Currency);
    procedure Setname(const Value: TBaseName);
    procedure SetnoncapitalizedInterest(const Value: Currency);
    procedure SetperiodAction(const Value: TBaseEnumeration);
    procedure SetperiodCount(const Value: Integer);
    procedure SetperiodStartDate(const Value: TDateTime);
    procedure SetperiodEndDate(const Value: TDateTime);
    procedure SetperiodType(const Value: TBaseEnumeration);
    procedure SetcalcTax(const Value: Boolean);
    procedure SettaxRate(const Value: Currency);
  protected
    function OnDeleteObject(AProxy: TDataProxy): Boolean; override;
  public
    constructor Create(AStatic: Boolean); override;
    procedure FromDataset(ADataset: TADOQuery); override;
    procedure UpdateFieldList; override;
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String; override;
    class function EndPeriodDatetime(APeriodStartDateTime: TDateTime; APeriodCount: Integer; APeriodType: TBaseEnumeration): TDateTime;
    class function EndDueDatetime(ADueLastDatetime: TDateTime; ADueCount: Integer; ADueType: TBaseEnumeration): TDateTime;
    function GetElementHint(AColumnIndex: Integer): String; override;
    function GetElementText: String; override;
    function GetColumnImage(AColumnIndex: Integer): Integer; override;
    function GetDepositMovements: TDataObjectList;
    function GetDepositCashpointName: String;
    class function GetCurrencyDefinition(AIdDepositInvestment: TDataGid): TDataGid;
  published
    property depositState: TBaseEnumeration read FdepositState write SetdepositState;
    property name: TBaseName read Fname write Setname;
    property description: TBaseDescription read Fdescription write Setdescription;
    property idCashPoint: TDataGid read FidCashPoint write SetidCashPoint;
    property idCurrencyDef: TDataGid read FidCurrencyDef write SetidCurrencyDef;
    property cash: Currency read Fcash write Setcash;
    property interestRate: Currency read FinterestRate write SetinterestRate;
    property noncapitalizedInterest: Currency read FnoncapitalizedInterest write SetnoncapitalizedInterest;
    property periodCount: Integer read FperiodCount write SetperiodCount;
    property periodType: TBaseEnumeration read FperiodType write SetperiodType;
    property periodStartDate: TDateTime read FperiodStartDate write SetperiodStartDate;
    property periodEndDate: TDateTime read FperiodEndDate write SetperiodEndDate;
    property periodAction: TBaseEnumeration read FperiodAction write SetperiodAction;
    property dueCount: Integer read FdueCount write SetdueCount;
    property dueType: TBaseEnumeration read FdueType write SetdueType;
    property dueStartDate: TDateTime read FdueStartDate write SetdueStartDate;
    property dueEndDate: TDateTime read FdueEndDate write SetdueEndDate;
    property dueAction: TBaseEnumeration read FdueAction write SetdueAction;
    property calcTax: Boolean read FcalcTax write SetcalcTax;
    property taxRate: Currency read FtaxRate write SettaxRate;
  end;

  TDepositMovement = class(TDataObject)
  private
    FmovementType: TBaseEnumeration;
    FregDateTime: TDateTime;
    FregOrder: Integer;
    Fdescription: TBaseDescription;
    Fcash: Currency;
    Finterest: Currency;
    FdepositState: TBaseEnumeration;
    FidDepositInvestment: TDataGid;
    FidAccount: TDataGid;
    FidAccountCurrencyDef: TDataGid;
    FaccountCash: Currency;
    FidCurrencyRate: TDataGid;
    FcurrencyQuantity: Integer;
    FcurrencyRate: Currency;
    FrateDescription: TBaseDescription;
    FidProduct: TDataGid;
    FidBaseMovement: TDataGid;
    FidCurrencyDef: TDataGid;
    procedure Setcash(const Value: Currency);
    procedure Setdescription(const Value: TBaseDescription);
    procedure SetidDepositInvestment(const Value: TDataGid);
    procedure SetmovementType(const Value: TBaseEnumeration);
    procedure SetregDateTime(const Value: TDateTime);
    procedure SetaccountCash(const Value: Currency);
    procedure SetcurrencyQuantity(const Value: Integer);
    procedure SetcurrencyRate(const Value: Currency);
    procedure SetidAccount(const Value: TDataGid);
    procedure SetidAccountCurrencyDef(const Value: TDataGid);
    procedure SetidCurrencyRate(const Value: TDataGid);
    procedure SetidProduct(const Value: TDataGid);
    procedure SetrateDescription(const Value: TBaseDescription);
    procedure SetidBaseMovement(const Value: TDataGid);
    procedure SetregOrder(const Value: Integer);
    procedure SetdepositState(const Value: TBaseEnumeration);
    procedure Setinterest(const Value: Currency);
  protected
    function OnDeleteObject(AProxy: TDataProxy): Boolean; override;
  public
    constructor Create(AStatic: Boolean); override;
    procedure FromDataset(ADataset: TADOQuery); override;
    procedure UpdateFieldList; override;
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String; override;
    function GetElementText: String; override;
  published
    property movementType: TBaseEnumeration read FmovementType write SetmovementType;
    property regDateTime: TDateTime read FregDateTime write SetregDateTime;
    property regOrder: Integer read FregOrder write SetregOrder;
    property description: TBaseDescription read Fdescription write Setdescription;
    property cash: Currency read Fcash write Setcash;
    property idDepositInvestment: TDataGid read FidDepositInvestment write SetidDepositInvestment;
    property idAccount: TDataGid read FidAccount write SetidAccount;
    property idAccountCurrencyDef: TDataGid read FidAccountCurrencyDef write SetidAccountCurrencyDef;
    property accountCash: Currency read FaccountCash write SetaccountCash;
    property idCurrencyRate: TDataGid read FidCurrencyRate write SetidCurrencyRate;
    property currencyQuantity: Integer read FcurrencyQuantity write SetcurrencyQuantity;
    property currencyRate: Currency read FcurrencyRate write SetcurrencyRate;
    property rateDescription: TBaseDescription read FrateDescription write SetrateDescription;
    property idProduct: TDataGid read FidProduct write SetidProduct;
    property idBaseMovement: TDataGid read FidBaseMovement write SetidBaseMovement;
    property idCurrencyDef: TDataGid read FidCurrencyDef;
    property interest: Currency read Finterest write Setinterest;
    property depositState: TBaseEnumeration read FdepositState write SetdepositState;
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
    UnitDefProxy: TDataProxy;
    ReportDefProxy: TDataProxy;
    InstrumentProxy: TDataProxy;
    InstrumentValueProxy: TDataProxy;
    InvestmentItemProxy: TDataProxy;
    InvestmentMovementProxy: TDataProxy;
    InvestmentPortfolioProxy: TDataProxy;
    QuickPatternProxy: TDataProxy;
    DepositInvestmentProxy: TDataProxy;
    DepositMovementProxy: TDataProxy;

var GCurrencyCache: TCurrCache;
    GUnitdefCache: TCurrCache;
    GActiveProfileId: TDataGid = CEmptyDataGid;
    GDefaultProfileId: TDataGid = CEmptyDataGid;
    GDefaultProductId: TDataGid = CEmptyDataGid;
    GDefaultAccountId: TDataGid = CEmptyDataGid;
    GDefaultCashpointId: TDataGid = CEmptyDataGid;

const CHASH_INSTRUMENT_SYMBOL = 0;
      CHASH_INSTRUMENT_NAME = 1;

var GDefaultCurrencyId: TDataGid = '';

procedure InitializeProxies(ADataProvider: TDataProvider);
function IsMultiCurrencyDataset(ADataset: TADOQuery; ACurDefFieldname: String; var AOneCurrDef: TDataGid): Boolean;
function IsUnitdefDataset(ADataset: TADOQuery; ACDefFieldname: String = 'idUnitdef'): Boolean;
function GetDefsFromDataset(ADataset: TADOQuery; ACurDefFieldname: String): TDataGids;
function GetNamesFromDataset(ADataset: TADOQuery; ACurDefFieldname, ACurNameFieldName: String): TStringList;

implementation

uses DB, CInfoFormUnit, DateUtils, StrUtils, CPreferences, CBaseFrameUnit,
  CBase64, CDatatools;

procedure UpdateStatistics(AProvider: TDataProvider;
                           AmovementCount: Integer; Acash: Currency;  AmovementCash: Currency; AmovementType: TBaseEnumeration;
                           AidAccount: TDataGid; AidSourceAccount: TDataGid; AidCashPoint: TDataGid; AidProduct: TDataGid;
                           AidAccountCurrencyDef: TDataGid; AidMovementCurrencyDef: TDataGid);
begin
  if AProvider.GetSqlInteger(Format('select count(*) from movementStatistics where movementType = ''%s'' and idAccount %s and idSourceAccount %s and ' +
                          'idCashPoint %s and idProduct %s and idAccountCurrencyDef %s and idMovementCurrencyDef %s',
                          [AmovementType, IsNullCondition(DataGidToDatabase(AidAccount)), IsNullCondition(DataGidToDatabase(AidSourceAccount)),
                           IsNullCondition(DataGidToDatabase(AidCashPoint)), IsNullCondition(DataGidToDatabase(AidProduct)), IsNullCondition(DataGidToDatabase(AidAccountCurrencyDef)),
                           IsNullCondition(DataGidToDatabase(AidMovementCurrencyDef))]), 0) > 0 then begin
    AProvider.ExecuteSql(Format('update movementStatistics set movementCount = movementCount %s, cash = cash %s, movementCash = movementCash %s where movementType = ''%s'' and idAccount %s and idSourceAccount %s and ' +
                          'idCashPoint %s and idProduct %s and idAccountCurrencyDef %s and idMovementCurrencyDef %s',
                          [IntToStrWithSign(AmovementCount), CurrencyToDatabaseWithSign(Acash), CurrencyToDatabaseWithSign(AmovementCash), AmovementType, IsNullCondition(DataGidToDatabase(AidAccount)), IsNullCondition(DataGidToDatabase(AidSourceAccount)),
                           IsNullCondition(DataGidToDatabase(AidCashPoint)), IsNullCondition(DataGidToDatabase(AidProduct)), IsNullCondition(DataGidToDatabase(AidAccountCurrencyDef)),
                           IsNullCondition(DataGidToDatabase(AidMovementCurrencyDef))]));
  end else begin
    AProvider.ExecuteSql(Format('insert into movementStatistics (movementCount, cash, movementType, idAccount, idSourceAccount, idCashPoint, idProduct, idAccountCurrencyDef, idMovementCurrencyDef, movementCash) values (' +
    '%d, %s, ''%s'', %s, %s, %s, %s, %s, %s, %s)', [AmovementCount, CurrencyToDatabase(Acash), AmovementType,
      DataGidToDatabase(AidAccount), DataGidToDatabase(AidSourceAccount), DataGidToDatabase(AidCashPoint), DataGidToDatabase(AidProduct),
      DataGidToDatabase(AidAccountCurrencyDef), DataGidToDatabase(AidMovementCurrencyDef), CurrencyToDatabase(AmovementCash)]));
  end;
end;




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

function IsUnitdefDataset(ADataset: TADOQuery; ACDefFieldname: String = 'idUnitdef'): Boolean;
begin
  ADataset.First;
  Result := False;
  if not ADataset.IsEmpty then begin
    while (not Result) and (not ADataset.Eof) do begin
      Result := (ADataset.FieldByName(ACDefFieldname).AsString <> CEmptyDataGid);
      ADataset.Next;
    end;
  end;
  ADataset.First;
end;

procedure InitializeProxies(ADataProvider: TDataProvider);
begin
  CashPointProxy := TDataProxy.Create(ADataProvider, 'cashPoint');
  AccountProxy := TDataProxy.Create(ADataProvider, 'account');
  ProductProxy := TDataProxy.Create(ADataProvider, 'product');
  QuickPatternProxy := TDataProxy.Create(ADataProvider, 'quickPattern');
  PlannedDoneProxy :=  TDataProxy.Create(ADataProvider, 'plannedDone');
  MovementFilterProxy :=  TDataProxy.Create(ADataProvider, 'movementFilter');
  ProfileProxy :=  TDataProxy.Create(ADataProvider, 'profile');
  MovementLimitProxy :=  TDataProxy.Create(ADataProvider, 'movementLimit');
  CurrencyDefProxy :=  TDataProxy.Create(ADataProvider, 'currencyDef');
  CurrencyRateProxy :=  TDataProxy.Create(ADataProvider, 'currencyRate');
  AccountCurrencyRuleProxy := TDataProxy.Create(ADataProvider, 'accountCurrencyRule');
  AccountExtractionProxy := TDataProxy.Create(ADataProvider, 'accountExtraction');
  ExtractionItemProxy := TDataProxy.Create(ADataProvider, 'extractionItem');
  UnitDefProxy := TDataProxy.Create(ADataProvider, 'unitDef');
  ReportDefProxy := TDataProxy.Create(ADataProvider, 'reportDef');
  InstrumentProxy := TDataProxy.Create(ADataProvider, 'instrument');
  InstrumentValueProxy := TDataProxy.Create(ADataProvider, 'instrumentValue', 'StnInstrumentValue');
  InvestmentItemProxy := TDataProxy.Create(ADataProvider, 'investmentItem');
  InvestmentPortfolioProxy := TDataProxy.Create(ADataProvider, '', 'StnInvestmentPortfolio', 'idInvestmentItem');
  DepositInvestmentProxy := TDataProxy.Create(ADataProvider, 'depositInvestment');
  InvestmentMovementProxy := TDataProxy.Create(ADataProvider, 'investmentMovement');
  DepositMovementProxy := TDataProxy.Create(ADataProvider, 'depositMovement', 'StnDepositMovement');
  BaseMovementProxy := TDataProxy.Create(ADataProvider, 'baseMovement', 'StnBaseMovement');
  MovementListProxy :=  TDataProxy.Create(ADataProvider, 'movementList', 'StnMovementList');
  PlannedMovementProxy :=  TDataProxy.Create(ADataProvider, 'plannedMovement');
end;

class function TCashPoint.CanBeDeleted(AId: ShortString): Boolean;
var xText: String;
begin
  Result := True;
  xText := '';
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
  end else if GDataProvider.GetSqlInteger('select count(*) from instrument where idCashPoint = ' + DataGidToDatabase(AId), 0) <> 0 then begin
    xText := 'istniej� zwi�zane z nim instrumenty inwestycyjne';
  end;
  if xText <> '' then begin
    ShowInfo(itError, 'Nie mo�na usun�� kontrahenta, gdy� ' + xText, '');
    Result := False;
  end;
end;

procedure TCashPoint.DeleteObject;
begin
  GDataProvider.ExecuteSql('delete from movementStatistics where idCashpoint = ' + DataGidToDatabase(id));
  inherited DeleteObject;
  if GDefaultCashpointId = id then begin
    GDefaultCashpointId := CEmptyDataGid;
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

function TCashPoint.GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String;
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
    FaccountState := FieldByName('accountState').AsString;
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
    AddField('accountState', FaccountState, True, 'account');
  end;
end;

class function TProduct.CanBeDeleted(AId: ShortString): Boolean;
var xText: String;
begin
  Result := True;
  xText := '';
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

class function TProduct.CanChangeUnitdef(AId: ShortString): Boolean;
begin
  Result := (GDataProvider.GetSqlInteger('select count(*) from plannedMovement where idProduct = ' + DataGidToDatabase(AId), 0) = 0) and
            (GDataProvider.GetSqlInteger('select count(*) from baseMovement where idProduct = ' + DataGidToDatabase(AId), 0) = 0);
end;

procedure TProduct.DeleteObject;
begin
  GDataProvider.ExecuteSql('delete from movementStatistics where idProduct = ' + DataGidToDatabase(id));
  inherited DeleteObject;
  if GDefaultProductId = id then begin
    GDefaultProductId := CEmptyDataGid;
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
    FidUnitDef := FieldByName('idUnitDef').AsString;
  end;
end;

function TProduct.GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String;
begin
  if AColumnIndex = 1 then begin
    Result := GUnitdefCache.GetSymbol(idUnitDef);
  end else begin
    Result := Fname;
  end;
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

class function TProduct.HasQuantity(AId: TDataGid): TDataGid;
begin
  Result := GDataProvider.GetSqlString('select idUnitdef from product where idProduct = ' + DataGidToDatabase(AId), CEmptyDataGid);
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

procedure TProduct.SetidUnitDef(const Value: TDataGid);
begin
  if FidUnitDef <> Value then begin
    FidUnitDef := Value;
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
    AddField('idUnitDef', DataGidToDatabase(FidUnitDef), False, 'product');
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
    FidUnitDef := FieldByName('idUnitDef').AsString;
    Fquantity := FieldByName('quantity').AsFloat;
    FisInvestmentMovement := FieldByName('isInvestmentMovement').AsBoolean;
    FisDepositMovement := FieldByName('isDepositMovement').AsBoolean;
    FprevmovementCash := FmovementCash;
    FprevIdAccountCurrencyDef := FidAccountCurrencyDef;
    FprevIdMovementCurrencyDef := FidMovementCurrencyDef;
    FprevIdCashPoint := FidCashPoint;
    FprevIdProduct := FidProduct;
    FaccountName := FieldByName('accountName').AsString;
    FsourceAccountName := FieldByName('sourceAccountName').AsString;
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
    AddField('quantity', FloatToDatabase(Fquantity), False, 'baseMovement');
    AddField('idUnitDef', DataGidToDatabase(FidUnitDef), False, 'baseMovement');
    AddField('isInvestmentMovement', IntToStr(Integer(FisInvestmentMovement)), False, 'baseMovement');
    AddField('isDepositMovement', IntToStr(Integer(FisDepositMovement)), False, 'baseMovement');
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
  xText := '';
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
  Fquantity := 1;
  FidUnitDef := CEmptyDataGid;
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
    FidDestAccount := FieldByName('idDestAccount').AsString;
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
    Fquantity := FieldByName('quantity').AsFloat;
    FidUnitDef := FieldByName('idUnitDef').AsString;
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

procedure TPlannedMovement.SetidDestAccount(const Value: TDataGid);
begin
  if FidDestAccount <> Value then begin
    FidDestAccount := Value;
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

procedure TPlannedMovement.SetidUnitDef(const Value: TDataGid);
begin
  if FidUnitDef <> Value then begin
    FidUnitDef := Value;
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

procedure TPlannedMovement.Setquantity(const Value: Double);
begin
  if Fquantity <> Value then begin
    Fquantity := Value;
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
    AddField('quantity', FloatToDatabase(Fquantity), False, 'plannedMovement');
    AddField('idUnitDef', DataGidToDatabase(FidUnitDef), False, 'plannedMovement');
    AddField('idDestAccount', DataGidToDatabase(FidDestAccount), False, 'plannedMovement');
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
    FdueDate := FieldByName('dueDate').AsDateTime;
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

procedure TPlannedDone.SetdueDate(const Value: TDateTime);
begin
  if FdueDate <> Value then begin
    FdueDate := Value;
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
    AddField('dueDate', DatetimeToDatabase(FdueDate, False), False, 'plannedDone');
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
  xText := '';
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
  xText := '';
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

function TMovementFilter.GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String;
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
    if (xFilter.Faccounts.Count <> 0) and (AAcountField <> '') then begin
      xAccountsPart := AAcountField + ' in (select idAccount from accountFilter where idMovementFilter = ' + DataGidToDatabase(AIdFilter) + ')';
    end else begin
      xAccountsPart := '';
    end;
    if (xFilter.Fcashpoints.Count <> 0) and (ACashpointField <> '') then begin
      xCashpointsPart := ACashpointField + ' in (select idCashpoint from cashpointFilter where idMovementFilter = ' + DataGidToDatabase(AIdFilter) + ')';
    end else begin
      xCashpointsPart := '';
    end;
    if (xFilter.Fproducts.Count <> 0) and (ACategoryField <> '') then begin
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
  if GDefaultProfileId = id then begin
    GDefaultProfileId := CEmptyDataGid;
  end;
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

function TProfile.GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String;
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
  Result := TMovementList.GetList(TBaseMovement, BaseMovementProxy, 'select * from StnBaseMovement where idmovementList = ' + DataGidToDatabase(id));
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
  Fquantity := 1;
  FidUnitDef := CEmptyDataGid;
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
  UpdateStatistics(AProxy.DataProvider, -1, (-1) * Fcash, (-1) * FmovementCash, FmovementType,
                   FidAccount, FidSourceAccount, FidCashPoint, FidProduct,
                   FidAccountCurrencyDef, FidMovementCurrencyDef);
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
  UpdateStatistics(AProxy.DataProvider, 1, Fcash, FmovementCash, FmovementType,
                   FidAccount, FidSourceAccount, FidCashPoint, FidProduct,
                   FidAccountCurrencyDef, FidMovementCurrencyDef);
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
  UpdateStatistics(AProxy.DataProvider, -1, (-1) * Fcash, (-1) * FmovementCash, FmovementType,
                   FprevIdAccount, FprevIdSourceAccount, FprevIdCashPoint, FprevIdProduct,
                   FprevIdAccountCurrencyDef, FprevIdMovementCurrencyDef);
  UpdateStatistics(AProxy.DataProvider, 1, Fcash, FmovementCash, FmovementType,
                   FidAccount, FidSourceAccount, FidCashPoint, FidProduct,
                   FidAccountCurrencyDef, FidMovementCurrencyDef);
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

function TAccount.GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String;
begin
  if AColumnIndex = 4 then begin
    if FaccountState = CAccountStateActive then begin
      Result := CAccountStateActiveDesc;
    end else if FaccountState = CAccountStateClosed then begin
      Result := CAccountStateClosedDesc;
    end else begin
      Result := FaccountState;
    end;
  end else if AColumnIndex = 3 then begin
    Result := GCurrencyCache.GetSymbol(FidCurrencyDef);
  end else if AColumnIndex = 2 then begin
    Result := CurrencyToString(Fcash, FidCurrencyDef, False);
  end else if AColumnIndex = 1 then begin
    if FaccountType = CCashAccount then begin
      Result := CCashAccountDesc;
    end else if FaccountType = CBankAccount then begin
      Result := CBankAccountDesc;
    end else if FaccountType = CInvestmentAccount then begin
      Result := CInvestmentAccountDesc;
    end else begin
      Result := FaccountType;
    end;
  end else begin
    Result := Fname;
  end;
end;

function TAccount.GetElementText: String;
begin
  Result := Fname;
end;

function TAccount.GetElementCompare(AColumnIndex: Integer; ACompareWith: TCDataListElementObject; AViewTextSelector: String): Integer;
begin
  if AColumnIndex = 2 then begin
    Result := Sign(Fcash - TAccount(ACompareWith).cash);
  end else begin
    Result := inherited GetElementCompare(AColumnIndex, ACompareWith, AViewTextSelector);
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

function TMovementLimit.GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String;
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
    FpreviousSymbol := Fsymbol;
  end;
  inherited AfterPost;
end;

class function TCurrencyDef.CanBeDeleted(AId: ShortString): Boolean;
var xText: String;
begin
  Result := True;
  xText := '';
  if GDefaultCurrencyId = AId then begin
    xText := 'jest ona walut� domy�ln�';
  end else if GDataProvider.GetSqlInteger('select count(*) from currencyRate where ' +
      '(idSourceCurrencyDef = ' + DataGidToDatabase(AId) + ') or ' +
      '(idTargetCurrencyDef = ' + DataGidToDatabase(AId) + ')', 0) <> 0 then begin
    xText := 'istniej� zwi�zane z ni� kursy';
  end else if GDataProvider.GetSqlInteger('select count(*) from account where idCurrencyDef = ' + DataGidToDatabase(AId), 0) <> 0 then begin
    xText := 'istniej� zwi�zane z ni� konta';
  end else if GDataProvider.GetSqlInteger('select count(*) from instrument where idCurrencyDef = ' + DataGidToDatabase(AId), 0) <> 0 then begin
    xText := 'istniej� zwi�zane z ni� instrumenty inwestycyjne';
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

procedure TCurrencyDef.DeleteObject;
begin
  GDataProvider.ExecuteSql('delete from movementStatistics where idAccountCurrencyDef = ' + DataGidToDatabase(id) + ' or idMovementCurrencyDef = ' + DataGidToDatabase(id));
  inherited DeleteObject;
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
  end;
end;

function TCurrencyDef.GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String;
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

function TCurrencyRate.GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String;
begin
  if AColumnIndex = 0 then begin
    Result := Date2StrDate(FbindingDate);
  end else if AColumnIndex = 1 then begin
    Result := GetDescText(Fdescription);
  end else if AColumnIndex = 3 then begin
    Result := GetTypeDesc(FrateType);
  end else begin
    Result := CurrencyToString(rate, '', False, 4);
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

class function TCurrencyRate.FindRate(ARateType: TBaseEnumeration; ASourceId, ATargetId, ACashpointId: TDataGid; ABindingDate: TDateTime; AExactlyAtBindingdate: Boolean = True): TCurrencyRate;
var xSql: String;
begin
  if AExactlyAtBindingdate then begin
    xSql := Format('select * from currencyRate where rateType = ''%s'' and bindingDate = %s and ' +
      '((idSourceCurrencyDef = %s and idTargetCurrencyDef = %s) or (idSourceCurrencyDef = %s and idTargetCurrencyDef = %s))' +
      ' and idCashpoint = %s',
                   [ARateType,
                    DatetimeToDatabase(ABindingDate, False),
                    DataGidToDatabase(ASourceId), DataGidToDatabase(ATargetId),
                    DataGidToDatabase(ATargetId), DataGidToDatabase(ASourceId),
                    DataGidToDatabase(ACashpointId)]);
  end else begin
    xSql := Format('select top 1 * from currencyRate where rateType = ''%s'' and bindingDate <= %s and ' +
      '((idSourceCurrencyDef = %s and idTargetCurrencyDef = %s) or (idSourceCurrencyDef = %s and idTargetCurrencyDef = %s))' +
      ' and idCashpoint = %s order by bindingDate desc',
                   [ARateType,
                    DatetimeToDatabase(ABindingDate, False),
                    DataGidToDatabase(ASourceId), DataGidToDatabase(ATargetId),
                    DataGidToDatabase(ATargetId), DataGidToDatabase(ASourceId),
                    DataGidToDatabase(ACashpointId)]);
  end;
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

constructor TCurrCacheItem.Create(AComponentTag: Integer; AId, ASymbol, AIso: String);
begin
  inherited Create;
  FCurrId := AId;
  FCurrSymbol := ASymbol;
  FComponentTag := AComponentTag;
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
    SetCurrencySymbol(FCurrId, FCurrSymbol, FComponentTag);
    SendMessageToFrames(Nil, WM_MUSTREPAINT, 0, 0);
  end;
end;

procedure TCurrCache.Change(AId, ASymbol, AIso: String);
var xCur: TCurrCacheItem;
begin
  xCur := ById[AId];
  if xCur = Nil then begin
    xCur := TCurrCacheItem.Create(FComponentTag, AId, ASymbol, AIso);
    Add(xCur);
  end else begin
    xCur.CurrSymbol := ASymbol;
    xCur.CurrIso := AIso;
  end;
end;

constructor TCurrCache.Create(AComponentTag: Integer);
begin
  inherited Create(True);
  FComponentTag := AComponentTag;
end;

function TCurrCache.GetById(AId: String): TCurrCacheItem;
var xCount: Integer;
begin
  Result := Nil;
  xCount := 0;
  while (Result = Nil) and (xCount <= Count - 1) do begin
    if AId = Items[xCount].FCurrId then begin
      Result := Items[xCount];
    end;
    Inc(xCount);
  end;
end;

function TCurrCache.GetByIso(AIso: String): TCurrCacheItem;
var xCount: Integer;
begin
  Result := Nil;
  xCount := 0;
  while (Result = Nil) and (xCount <= Count - 1) do begin
    if AIso = Items[xCount].FCurrIso then begin
      Result := Items[xCount];
    end;
    Inc(xCount);
  end;
end;

function TCurrCache.GetIso(AId: String): String;
var xCur: TCurrCacheItem;
begin
  Result := '';
  if AId <> CEmptyDataGid then begin
    xCur := ById[AId];
    if xCur <> Nil then begin
      Result := xCur.CurrIso;
    end;
  end;
end;

function TCurrCache.GetItems(AIndex: Integer): TCurrCacheItem;
begin
  Result := TCurrCacheItem(inherited Items[AIndex]);
end;

function TCurrCache.GetSymbol(AId: String): String;
var xCur: TCurrCacheItem;
begin
  Result := '';
  if AId <> CEmptyDataGid then begin
    xCur := ById[AId];
    if xCur <> Nil then begin
      Result := xCur.CurrSymbol;
    end;
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
    Result := RoundCurrency(ACash * Frate / Fquantity);
  end else if (ASourceId = FidTargetCurrencyDef) and (ATargerId = FidSourceCurrencyDef) then begin
    Result := RoundCurrency(Fquantity * ACash / Frate);
  end else begin
    Result := 0;
  end;
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
  AProxy.DataProvider.ExecuteSql('update investmentMovement set idCurrencyRate = null where idCurrencyRate = ' + DataGidToDatabase(id));
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
    Result := TCurrencyRate.FindRate(xRule.rateType, TAccount.GetCurrencyDefinition(AIdAccount), ASourceCurrency, xRule.idCashPoint, ADate, not xRule.FuseOldRates);
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
    FuseOldRates := FieldByName('useOldRates').AsBoolean;
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

procedure TAccountCurrencyRule.SetuseOldRates(const Value: Boolean);
begin
  if FuseOldRates <> Value then begin
    FuseOldRates := Value;
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
    AddField('useOldRates', IntToStr(Integer(FuseOldRates)), False, 'accountCurrencyRule');
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

function TExtractionItem.GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String;
begin
  if AColumnIndex = 1 then begin
    Result := Date2StrDate(FregDate);
  end else if AColumnIndex = 2 then begin
    Result := GetDescText(Fdescription);
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
  AProxy.DataProvider.ExecuteSql('update baseMovement set isStated = 0, idExtractionItem = null where idExtractionItem = ' + DataGidToDatabase(id));
  AProxy.DataProvider.ExecuteSql('update movementList set isStated = 0, idExtractionItem = null where idExtractionItem = ' + DataGidToDatabase(id));
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

function TAccountExtraction.GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String;
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
    Result := Date2StrDate(FendDate);
  end else if AColumnIndex = 2 then begin
    Result := Date2StrDate(FstartDate);
  end else if AColumnIndex = 1 then begin
    Result := GetDescText(Fdescription);
  end else begin
    Result := Date2StrDate(FregDate);
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

class function TAccountExtraction.FindAccountExtraction(AIdAccount: TDataGid; ARegDate: TDateTime): TAccountExtraction;
begin
  Result := TAccountExtraction(TAccountExtraction.FindByCondition(AccountExtractionProxy,
     'select * from accountExtraction where idAccount = ' + DataGidToDatabase(AIdAccount) + ' and regDate = ' + DatetimeToDatabase(ARegDate, False), False));
end;

function TAccountExtraction.OnDeleteObject(AProxy: TDataProxy): Boolean;
begin
  Result := inherited OnDeleteObject(AProxy);
  AProxy.DataProvider.ExecuteSql('update baseMovement set isStated = 0, idExtractionItem = null where idExtractionItem in (select idExtractionItem from extractionItem where idAccountExtraction = ' + DataGidToDatabase(id) + ')');
  AProxy.DataProvider.ExecuteSql('update movementList set isStated = 0, idExtractionItem = null where idExtractionItem in (select idExtractionItem from extractionItem where idAccountExtraction = ' + DataGidToDatabase(id) + ')');
end;

procedure TUnitDef.AfterPost;
begin
  if Fsymbol <> FpreviousSymbol then begin
    GUnitdefCache.Change(id, symbol, '');
    FpreviousSymbol := Fsymbol;
  end;
  inherited AfterPost;
end;

class function TUnitDef.CanBeDeleted(AId: ShortString): Boolean;
var xText: String;
begin
  Result := True;
  xText := '';
  if GDataProvider.GetSqlInteger('select count(*) from product where idUnitDef = ' + DataGidToDatabase(AId), 0) <> 0 then begin
    xText := 'istniej� zwi�zane z ni� kategorie';
  end;
  if xText <> '' then begin
    ShowInfo(itError, 'Nie mo�na usun�� jednostki miary, gdy� ' + xText, '');
    Result := False;
  end;
end;

procedure TUnitDef.FromDataset(ADataset: TADOQuery);
begin
  inherited FromDataset(ADataset);
  with ADataset do begin
    Fname := FieldByName('name').AsString;
    Fdescription := FieldByName('description').AsString;
    Fsymbol := FieldByName('symbol').AsString;
    FpreviousSymbol := Fsymbol;
  end;
end;

function TUnitDef.GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String;
begin
  Result := Fname;
end;

function TUnitDef.GetElementHint(AColumnIndex: Integer): String;
begin
  Result := Fdescription;
end;

function TUnitDef.GetElementText: String;
begin
  Result := Fname;
end;

procedure TUnitDef.Setdescription(const Value: TBaseDescription);
begin
  if Fdescription <> Value then begin
    Fdescription := Value;
    SetState(msModified);
  end;
end;

procedure TUnitDef.Setname(const Value: TBaseName);
begin
  if Fname <> Value then begin
    Fname := Value;
    SetState(msModified);
  end;
end;

procedure TUnitDef.Setsymbol(const Value: TBaseName);
begin
  if Fsymbol <> Value then begin
    Fsymbol := Value;
    SetState(msModified);
  end;
end;

procedure TUnitDef.UpdateFieldList;
begin
  inherited UpdateFieldList;
  with DataFieldList do begin
    AddField('name', Fname, True, 'unitDef');
    AddField('symbol', Fsymbol, True, 'unitDef');
    AddField('description', Fdescription, True, 'unitDef');
  end;
end;

procedure TBaseMovement.Setquantity(const Value: Double);
begin
  if Fquantity <> Value then begin
    Fquantity := Value;
    SetState(msModified);
  end;
end;

procedure TBaseMovement.SetidUnitDef(const Value: TDataGid);
begin
  if FidUnitDef <> Value then begin
    FidUnitDef := Value;
    SetState(msModified);
  end;
end;

procedure TReportDef.FromDataset(ADataset: TADOQuery);
begin
  inherited FromDataset(ADataset);
  with ADataset do begin
    Fname := FieldByName('name').AsString;
    Fdescription := FieldByName('description').AsString;
    FqueryText := FieldByName('queryText').AsString;
    FparamsDefs := FieldByName('paramsDefs').AsString;
    FxsltText := FieldByName('xsltText').AsString;
    FxsltType := FieldByName('xsltType').AsString;
  end;
end;

procedure TReportDef.Setdescription(const Value: TBaseDescription);
begin
  if Fdescription <> Value then begin
    Fdescription := Value;
    SetState(msModified);
  end;
end;

procedure TReportDef.Setname(const Value: TBaseName);
begin
  if Fname <> Value then begin
    Fname := Value;
    SetState(msModified);
  end;
end;

procedure TReportDef.SetparamsDefs(const Value: string);
begin
  if FparamsDefs <> Value then begin
    FparamsDefs := Value;
    SetState(msModified);
  end;
end;

procedure TReportDef.SetqueryText(const Value: string);
begin
  if FqueryText <> Value then begin
    FqueryText := Value;
    SetState(msModified);
  end;
end;

procedure TReportDef.SetxsltText(const Value: string);
begin
  if FxsltText <> Value then begin
    FxsltText := Value;
    SetState(msModified);
  end;
end;

procedure TReportDef.SetxsltType(const Value: TBaseEnumeration);
begin
  if FxsltType <> Value then begin
    FxsltType := Value;
    SetState(msModified);
  end;
end;

procedure TReportDef.UpdateFieldList;
begin
  inherited UpdateFieldList;
  with DataFieldList do begin
    AddField('name', Fname, True, 'reportDef');
    AddField('description', Fdescription, True, 'reportDef');
    AddField('queryText', FqueryText, True, 'reportDef');
    AddField('paramsDefs', FparamsDefs, True, 'reportDef');
    AddField('xsltText', FxsltText, True, 'reportDef');
    AddField('xsltType', FxsltType, True, 'reportDef');
  end;
end;

constructor TInstrument.Create(AStatic: Boolean);
begin
  inherited Create(AStatic);
  FidCashpoint := CEmptyDataGid;
  FidCurrencyDef := CEmptyDataGid;
end;

procedure TInstrument.FromDataset(ADataset: TADOQuery);
begin
  inherited FromDataset(ADataset);
  with ADataset do begin
    Fname := FieldByName('name').AsString;
    Fsymbol := FieldByName('symbol').AsString;
    Fdescription := FieldByName('description').AsString;
    FinstrumentType := FieldByName('instrumentType').AsString;
    FidCashpoint := FieldByName('idCashpoint').AsString;
    FidCurrencyDef := FieldByName('idCurrencyDef').AsString;
  end;
end;

function TInstrument.GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String;
begin
  Result := '';
  if AColumnIndex = 0 then begin
    Result := Fsymbol;
  end else if AColumnIndex = 1 then begin
    Result := Fname;
  end else if AColumnIndex = 2 then begin
    if FinstrumentType = CInstrumentTypeIndex then begin
      Result := CInstrumentTypeIndexDesc;
    end else if FinstrumentType = CInstrumentTypeStock then begin
      Result := CInstrumentTypeStockDesc;
    end else if FinstrumentType = CInstrumentTypeBond then begin
      Result := CInstrumentTypeBondDesc;
    end else if FinstrumentType = CInstrumentTypeFundinv then begin
      Result := CInstrumentTypeFundinvDesc;
    end else if FinstrumentType = CInstrumentTypeFundret then begin
      Result := CInstrumentTypeFundretDesc;
    end else if FinstrumentType = CInstrumentTypeUndefined then begin
      Result := CInstrumentTypeUndefinedDesc;
    end
  end;
end;

function TInstrument.GetElementHint(AColumnIndex: Integer): String;
begin
  Result := Fdescription;
end;

function TInstrument.GetElementText: String;
begin
  Result := Fname;
end;

procedure TInstrument.Setdescription(const Value: TBaseDescription);
begin
  if Fdescription <> Value then begin
    Fdescription := Value;
    SetState(msModified);
  end;
end;

procedure TInstrument.SetidCashpoint(const Value: TDataGid);
begin
  if FidCashpoint <> Value then begin
    FidCashpoint := Value;
    SetState(msModified);
  end;
end;

procedure TInstrument.SetidCurrencyDef(const Value: TDataGid);
begin
  if FidCurrencyDef <> Value then begin
    FidCurrencyDef := Value;
    SetState(msModified);
  end;
end;

procedure TInstrument.SetinstrumentType(const Value: TBaseEnumeration);
begin
  if FinstrumentType <> Value then begin
    FinstrumentType := Value;
    SetState(msModified);
  end;
end;

procedure TInstrument.Setname(const Value: TBaseName);
begin
  if Fname <> Value then begin
    Fname := Value;
    SetState(msModified);
  end;
end;

class function TInstrument.FindByName(AName: TBaseName): TInstrument;
begin
  Result := TInstrument(TInstrument.FindByCondition(InstrumentProxy, 'select * from instrument where name = ''' + AName + '''', False));
end;

procedure TInstrument.UpdateFieldList;
begin
  inherited UpdateFieldList;
  with DataFieldList do begin
    AddField('name', Fname, True, 'instrument');
    AddField('symbol', Fsymbol, True, 'instrument');
    AddField('instrumentType', FinstrumentType, True, 'instrument');
    AddField('description', Fdescription, True, 'instrument');
    AddField('idCurrencyDef', DataGidToDatabase(FidCurrencyDef), False, 'instrument');
    AddField('idCashpoint', DataGidToDatabase(FidCashpoint), False, 'instrument');
  end;
end;

constructor TInstrumentValue.Create(AStatic: Boolean);
begin
  inherited Create(AStatic);
  FidInstrument := CEmptyDataGid;
end;

class function TInstrumentValue.FindValue(AIdInstrument: TDataGid; ADateTime: TDateTime): TInstrumentValue;
var xSql: String;
begin
  xSql := Format('select * from StnInstrumentValue where regDateTime = %s and idInstrument = %s',
                 [DatetimeToDatabase(DateTimeUptoMinutes(ADateTime), True),
                  DataGidToDatabase(AIdInstrument)]);
  Result := TInstrumentValue(TInstrumentValue.FindByCondition(InstrumentValueProxy, xSql, False));
end;

procedure TInstrumentValue.FromDataset(ADataset: TADOQuery);
begin
  inherited FromDataset(ADataset);
  with ADataset do begin
    Fdescription := FieldByName('description').AsString;
    FidInstrument := FieldByName('idInstrument').AsString;
    FregDateTime := FieldByName('regDateTime').AsDateTime;
    FvalueOf := FieldByName('valueOf').AsCurrency;
    FinstrumentType := FieldByName('instrumentType').AsString;
    FidCurrencyDef := FieldByName('idCurrencyDef').AsString;
  end;
end;

function TInstrumentValue.GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String;
begin
  Result := '';
  if AColumnIndex = 0 then begin
    Result := Date2StrDate(FregDateTime, True);
  end else if AColumnIndex = 1 then begin
    Result := GetDescText(Fdescription);
  end else if AColumnIndex = 2 then begin
    Result := CurrencyToString(FvalueOf, '', False, 4);
  end else if AColumnIndex = 3 then begin
    Result := GCurrencyCache.GetSymbol(idCurrencyDef);
  end else if AColumnIndex = 4 then begin
    if FinstrumentType = CInstrumentTypeIndex then begin
      Result := CInstrumentTypeIndexDesc;
    end else if FinstrumentType = CInstrumentTypeStock then begin
      Result := CInstrumentTypeStockDesc;
    end else if FinstrumentType = CInstrumentTypeBond then begin
      Result := CInstrumentTypeBondDesc;
    end else if FinstrumentType = CInstrumentTypeFundinv then begin
      Result := CInstrumentTypeFundinvDesc;
    end else if FinstrumentType = CInstrumentTypeFundret then begin
      Result := CInstrumentTypeFundretDesc;
    end else if FinstrumentType = CInstrumentTypeUndefined then begin
      Result := CInstrumentTypeUndefinedDesc;
    end
  end;
end;

function TInstrumentValue.GetElementHint(AColumnIndex: Integer): String;
begin
  Result := Fdescription;
end;

function TInstrumentValue.GetElementText: String;
begin
  Result := Fdescription;
end;

function TInstrumentValue.OnDeleteObject(AProxy: TDataProxy): Boolean;
begin
  Result := inherited OnDeleteObject(AProxy);
  AProxy.DataProvider.ExecuteSql('update investmentMovement set idInstrumentValue = null where idInstrumentValue = ' + DataGidToDatabase(id));
end;

procedure TInstrumentValue.Setdescription(const Value: TBaseDescription);
begin
  if Fdescription <> Value then begin
    Fdescription := Value;
    SetState(msModified);
  end;
end;

procedure TInstrumentValue.SetidInstrument(const Value: TDataGid);
begin
  if FidInstrument <> Value then begin
    FidInstrument := Value;
    SetState(msModified);
  end;
end;

procedure TInstrumentValue.SetregDateTime(const Value: TDateTime);
begin
  if FregDateTime <> Value then begin
    FregDateTime := Value;
    SetState(msModified);
  end;
end;

procedure TInstrumentValue.SetvalueOf(const Value: Currency);
begin
  if FvalueOf <> Value then begin
    FvalueOf := Value;
    SetState(msModified);
  end;
end;

procedure TInstrumentValue.UpdateFieldList;
begin
  inherited UpdateFieldList;
  with DataFieldList do begin
    AddField('description', Fdescription, True, 'instrumentValue');
    AddField('idInstrument', DataGidToDatabase(FidInstrument), False, 'instrumentValue');
    AddField('regDateTime', DatetimeToDatabase(DateTimeUptoMinutes(FregDateTime), True), False, 'instrumentValue');
    AddField('valueOf', CurrencyToDatabase(FvalueOf), False, 'instrumentValue');
  end;
end;

class function TInstrument.CanBeDeleted(AId: ShortString): Boolean;
var xText: String;
begin
  Result := True;
  xText := '';
  if GDataProvider.GetSqlInteger('select count(*) from instrumentValue where idInstrument = ' + DataGidToDatabase(AId), 0) <> 0 then begin
    xText := 'istniej� zwi�zane z nim notowania';
  end;
  if xText <> '' then begin
    ShowInfo(itError, 'Nie mo�na usun�� instrumentu inwestycyjnego, gdy� ' + xText, '');
    Result := False;
  end;
end;

procedure TInstrument.Setsymbol(const Value: TBaseName);
begin
  if Fsymbol <> Value then begin
    Fsymbol := Value;
    SetState(msModified);
  end;
end;

class function TInstrument.FindBySymbol(ASymbol: TBaseName): TInstrument;
begin
  Result := TInstrument(TInstrument.FindByCondition(InstrumentProxy, 'select * from instrument where symbol = ''' + ASymbol + '''', False));
end;

function TInstrument.GetHash(AHashId: Integer): String;
begin
  if AHashId = CHASH_INSTRUMENT_NAME then begin
    Result := Fname;
  end else if AHashId = CHASH_INSTRUMENT_SYMBOL then begin
    Result := Fsymbol;
  end else begin
    Result := inherited GetHash(AHashId);
  end;
end;

constructor TInvestmentItem.Create(AStatic: Boolean);
begin
  inherited Create(AStatic);
  FidAccount := CEmptyDataGid;
  FidInstrument := CEmptyDataGid;
end;

procedure TInvestmentItem.FromDataset(ADataset: TADOQuery);
begin
  inherited FromDataset(ADataset);
  with ADataset do begin
    FidAccount := FieldByName('idAccount').AsString;
    FidInstrument := FieldByName('idInstrument').AsString;
    Fquantity := FieldByName('quantity').AsFloat;
  end;
end;

procedure TInvestmentItem.SetidInstrument(const Value: TDataGid);
begin
  if FidInstrument <> Value then begin
    FidInstrument := Value;
    SetState(msModified);
  end;
end;

procedure TInvestmentItem.SetidAccount(const Value: TDataGid);
begin
  if FidAccount <> Value then begin
    FidAccount := Value;
    SetState(msModified);
  end;
end;

procedure TInvestmentItem.Setquantity(const Value: Double);
begin
  if Fquantity <> Value then begin
    Fquantity := Value;
    SetState(msModified);
  end;
end;

procedure TInvestmentItem.UpdateFieldList;
begin
  inherited UpdateFieldList;
  with DataFieldList do begin
    AddField('idAccount', DataGidToDatabase(FidAccount), False, 'investmentItem');
    AddField('idInstrument', DataGidToDatabase(FidInstrument), False, 'investmentItem');
    AddField('quantity', FloatToDatabase(Fquantity), False, 'investmentItem');
  end;
end;

procedure TInvestmentMovement.AfterPost;
begin
  FprevIdInstrument := FidInstrument;
  FprevQuantity := Fquantity;
  FprevIdAccount := FidAccount;
  inherited AfterPost;
end;

constructor TInvestmentMovement.Create(AStatic: Boolean);
begin
  inherited Create(AStatic);
  FidInstrument := CEmptyDataGid;
  FidInstrumentCurrencyDef := CEmptyDataGid;
  FidInstrumentValue := CEmptyDataGid;
  FidAccount := CEmptyDataGid;
  FidAccountCurrencyDef := CEmptyDataGid;
  FidProduct := CEmptyDataGid;
  FidCurrencyRate := CEmptyDataGid;
  FidBaseMovement := CEmptyDataGid;
end;

procedure TInvestmentMovement.FromDataset(ADataset: TADOQuery);
begin
  inherited FromDataset(ADataset);
  with ADataset do begin
    Fdescription := FieldByName('description').AsString;
    FmovementType := FieldByName('movementType').AsString;
    FregDateTime := FieldByName('regDateTime').AsDateTime;
    FweekDate := FieldByName('weekDate').AsDateTime;
    FmonthDate := FieldByName('monthDate').AsDateTime;
    FyearDate := FieldByName('yearDate').AsDateTime;
    FidInstrument := FieldByName('idInstrument').AsString;
    FidInstrumentCurrencyDef := FieldByName('idInstrumentCurrencyDef').AsString;
    Fquantity := FieldByName('quantity').AsFloat;
    FidInstrumentValue := FieldByName('idInstrumentValue').AsString;
    FvalueOf := FieldByName('valueOf').AsCurrency;
    FsummaryOf := FieldByName('summaryOf').AsCurrency;
    FidAccount := FieldByName('idAccount').AsString;
    FprevIdInstrument := FidInstrument;
    FprevQuantity := Fquantity;
    FprevIdAccount := FidAccount;
    FidAccountCurrencyDef := FieldByName('idAccountCurrencyDef').AsString;
    FvalueOfAccount := FieldByName('valueOfAccount').AsCurrency;
    FsummaryOfAccount := FieldByName('summaryOfAccount').AsCurrency;
    FidProduct := FieldByName('idProduct').AsString;
    FidCurrencyRate := FieldByName('idCurrencyRate').AsString;
    FcurrencyQuantity := FieldByName('currencyQuantity').AsInteger;
    FcurrencyRate := FieldByName('currencyRate').AsCurrency;
    FrateDescription := FieldByName('rateDescription').AsString;
    FidBaseMovement := FieldByName('idBaseMovement').AsString;
  end;
end;

function TInvestmentMovement.GetColumnImage(AColumnIndex: Integer): Integer;
begin
  if AColumnIndex = 6 then begin
    if FmovementType = CInvestmentSellMovement then begin
      Result := 0;
    end else begin
      Result := 1;
    end;
  end else begin
    Result := -1;
  end;
end;

function TInvestmentMovement.GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String;
begin
  if AColumnIndex = 1 then begin
    Result := GetDescText(Fdescription);
  end else if AColumnIndex = 2 then begin
    Result := Date2StrDate(FregDateTime, True);
  end else if AColumnIndex = 3 then begin
    Result := FloatToString(Fquantity, 6);
  end else if AColumnIndex = 4 then begin
    if AViewTextSelector = CCurrencyViewInvestmentAccounts then begin
      Result := CurrencyToString(FsummaryOfAccount, FidAccountCurrencyDef, False);
    end else begin
      Result := CurrencyToString(FsummaryOf, FidInstrumentCurrencyDef, False);
    end;
  end else if AColumnIndex = 5 then begin
    if AViewTextSelector = CCurrencyViewInvestmentAccounts then begin
      Result := GCurrencyCache.GetSymbol(FidAccountCurrencyDef);
    end else begin
      Result := GCurrencyCache.GetSymbol(FidInstrumentCurrencyDef);
    end;
  end else if AColumnIndex = 6 then begin
    if idProduct <> CEmptyDataGid then begin
      if FmovementType = CInvestmentSellMovement then begin
        Result := 'Sprzeda�';
      end else begin
        Result := 'Zakup';
      end;
    end else begin
      if FmovementType = CInvestmentSellMovement then begin
        Result := 'Wydanie z portfela';
      end else begin
        Result := 'Przyj�cie do portfela';
      end;
    end;
  end;;
end;

function TInvestmentMovement.GetElementText: String;
begin
  Result := GetDescText(Fdescription);
end;

function TInvestmentMovement.OnDeleteObject(AProxy: TDataProxy): Boolean;
var xSql: String;
begin
  Result := inherited OnDeleteObject(AProxy);
  xSql := Format('update investmentItem set quantity = quantity %s where idInstrument = %s and idAccount = %s',
                 [FloatToDatabaseWithSign(IfThen(FmovementType = CInvestmentSellMovement, 1, -1) * Fquantity),
                  DataGidToDatabase(FidInstrument), DataGidToDatabase(FidAccount)]);
  AProxy.DataProvider.ExecuteSql(xSql);
end;

function TInvestmentMovement.OnInsertObject(AProxy: TDataProxy): Boolean;
var xSql: String;
    xItem: TInvestmentItem;
begin
  Result := inherited OnInsertObject(AProxy);
  if GDataProvider.GetSqlInteger(Format('select count(*) from investmentItem where idInstrument = %s and idAccount = %s',
                                        [DataGidToDatabase(FidInstrument), DataGidToDatabase(FidAccount)]), 0) = 0 then begin
    xItem := TInvestmentItem.CreateObject(InvestmentItemProxy, False);
    xItem.idAccount := FidAccount;
    xItem.idInstrument := FidInstrument;
    xItem.quantity := IfThen(FmovementType = CInvestmentSellMovement, -1, 1) * Fquantity;
    xItem.ForceUpdate;
  end else begin
    xSql := Format('update investmentItem set quantity = quantity %s where idInstrument = %s and idAccount = %s',
                   [FloatToDatabaseWithSign(IfThen(FmovementType = CInvestmentSellMovement, -1, 1) * Fquantity),
                    DataGidToDatabase(FidInstrument), DataGidToDatabase(FidAccount)]);
    AProxy.DataProvider.ExecuteSql(xSql);
  end;
end;

function TInvestmentMovement.OnUpdateObject(AProxy: TDataProxy): Boolean;
var xSql: String;
begin
  Result := inherited OnUpdateObject(AProxy);
  if (FprevIdInstrument = FidInstrument) and (FprevIdAccount = FidAccount) then begin
    xSql := Format('update investmentItem set quantity = quantity %s where idInstrument = %s and idAccount = %s',
                   [FloatToDatabaseWithSign(IfThen(FmovementType = CInvestmentSellMovement, -1, 1) * (Fquantity - FprevQuantity)),
                    DataGidToDatabase(FidInstrument), DataGidToDatabase(FidAccount)]);
    AProxy.DataProvider.ExecuteSql(xSql);
  end else begin
    xSql := Format('update investmentItem set quantity = quantity %s where idInstrument = %s and idAccount = %s',
                   [FloatToDatabaseWithSign(IfThen(FmovementType = CInvestmentSellMovement, 1, -1) * FprevQuantity),
                    DataGidToDatabase(FprevIdInstrument), DataGidToDatabase(FprevIdAccount)]);
    AProxy.DataProvider.ExecuteSql(xSql);
    OnInsertObject(AProxy);
  end;
end;

procedure TInvestmentMovement.SetcurrencyQuantity(const Value: Integer);
begin
  if FcurrencyQuantity <> Value then begin
    FcurrencyQuantity := Value;
    SetState(msModified);
  end;
end;

procedure TInvestmentMovement.SetcurrencyRate(const Value: Currency);
begin
  if FcurrencyRate <> Value then begin
    FcurrencyRate := Value;
    SetState(msModified);
  end;
end;

procedure TInvestmentMovement.Setdescription(const Value: TBaseDescription);
begin
  if Fdescription <> Value then begin
    Fdescription := Value;
    SetState(msModified);
  end;
end;

procedure TInvestmentMovement.SetidAccount(const Value: TDataGid);
begin
  if FidAccount <> Value then begin
    FidAccount := Value;
    SetState(msModified);
  end;
end;

procedure TInvestmentMovement.SetidAccountCurrencyDef(const Value: TDataGid);
begin
  if FidAccountCurrencyDef <> Value then begin
    FidAccountCurrencyDef := Value;
    SetState(msModified);
  end;
end;

procedure TInvestmentMovement.SetidBaseMovement(const Value: TDataGid);
begin
  if FidBaseMovement <> Value then begin
    FidBaseMovement := Value;
    SetState(msModified);
  end;
end;

procedure TInvestmentMovement.SetidCurrencyRate(const Value: TDataGid);
begin
  if FidCurrencyRate <> Value then begin
    FidCurrencyRate := Value;
    SetState(msModified);
  end;
end;

procedure TInvestmentMovement.SetidInstrument(const Value: TDataGid);
begin
  if FidInstrument <> Value then begin
    FidInstrument := Value;
    SetState(msModified);
  end;
end;

procedure TInvestmentMovement.SetidInstrumentCurrencyDef(const Value: TDataGid);
begin
  if FidInstrumentCurrencyDef <> Value then begin
    FidInstrumentCurrencyDef := Value;
    SetState(msModified);
  end;
end;

procedure TInvestmentMovement.SetidInstrumentValue(const Value: TDataGid);
begin
  if FidInstrumentValue <> Value then begin
    FidInstrumentValue := Value;
    SetState(msModified);
  end;
end;

procedure TInvestmentMovement.SetidProduct(const Value: TDataGid);
begin
  if FidProduct <> Value then begin
    FidProduct := Value;
    SetState(msModified);
  end;
end;

procedure TInvestmentMovement.SetmovementType(const Value: TBaseEnumeration);
begin
  if FmovementType <> Value then begin
    FmovementType := Value;
    SetState(msModified);
  end;
end;

procedure TInvestmentMovement.Setquantity(const Value: Double);
begin
  if Fquantity <> Value then begin
    Fquantity := Value;
    SetState(msModified);
  end;
end;

procedure TInvestmentMovement.SetrateDescription(const Value: TBaseDescription);
begin
  if FrateDescription <> Value then begin
    FrateDescription := Value;
    SetState(msModified);
  end;
end;

procedure TInvestmentMovement.SetregDateTime(const Value: TDateTime);
begin
  if FregDateTime <> Value then begin
    FregDateTime := Value;
    FyearDate := StartOfTheYear(FregDateTime);
    FmonthDate := StartOfTheMonth(FregDateTime);
    FweekDate := StartOfTheWeek(FregDateTime);
    SetState(msModified);
  end;
end;

procedure TInvestmentMovement.SetsummaryOf(const Value: Currency);
begin
  if FsummaryOf <> Value then begin
    FsummaryOf := Value;
    SetState(msModified);
  end;
end;

procedure TInvestmentMovement.SetsummaryOfAccount(const Value: Currency);
begin
  if FsummaryOfAccount <> Value then begin
    FsummaryOfAccount := Value;
    SetState(msModified);
  end;
end;

procedure TInvestmentMovement.SetvalueOf(const Value: Currency);
begin
  if FvalueOf <> Value then begin
    FvalueOf := Value;
    SetState(msModified);
  end;
end;

procedure TInvestmentMovement.SetvalueOfAccount(const Value: Currency);
begin
  if FvalueOfAccount <> Value then begin
    FvalueOfAccount := Value;
    SetState(msModified);
  end;
end;

procedure TInvestmentMovement.UpdateFieldList;
begin
  inherited UpdateFieldList;
  with DataFieldList do begin
    AddField('description', Fdescription, True, 'investmentMovement');
    AddField('movementType', FmovementType, True, 'investmentMovement');
    AddField('regDateTime', DatetimeToDatabase(FregDateTime, True), False, 'investmentMovement');
    AddField('weekDate', DatetimeToDatabase(FweekDate, False), False, 'investmentMovement');
    AddField('monthDate', DatetimeToDatabase(FmonthDate, False), False, 'investmentMovement');
    AddField('yearDate', DatetimeToDatabase(FyearDate, False), False, 'investmentMovement');
    AddField('idInstrument', DataGidToDatabase(FidInstrument), False, 'investmentMovement');
    AddField('idInstrumentCurrencyDef', DataGidToDatabase(FidInstrumentCurrencyDef), False, 'investmentMovement');
    AddField('quantity', FloatToDatabase(Fquantity), False, 'investmentMovement');
    AddField('idInstrumentValue', DataGidToDatabase(FidInstrumentValue), False, 'investmentMovement');
    AddField('valueOf', CurrencyToDatabase(FvalueOf), False, 'investmentMovement');
    AddField('summaryOf', CurrencyToDatabase(FsummaryOf), False, 'investmentMovement');
    AddField('idAccount', DataGidToDatabase(FidAccount), False, 'investmentMovement');
    AddField('idAccountCurrencyDef', DataGidToDatabase(FidAccountCurrencyDef), False, 'investmentMovement');
    AddField('valueOfAccount', CurrencyToDatabase(FvalueOfAccount), False, 'investmentMovement');
    AddField('summaryOfAccount', CurrencyToDatabase(FsummaryOfAccount), False, 'investmentMovement');
    AddField('idProduct', DataGidToDatabase(FidProduct), False, 'investmentMovement');
    AddField('idCurrencyRate', DataGidToDatabase(FidCurrencyRate), False, 'investmentMovement');
    AddField('currencyQuantity', IntToStr(FcurrencyQuantity), False, 'investmentMovement');
    AddField('currencyRate', CurrencyToDatabase(FcurrencyRate), False, 'investmentMovement');
    AddField('rateDescription', FrateDescription, True, 'investmentMovement');
    AddField('idBaseMovement', DataGidToDatabase(FidBaseMovement), False, 'investmentMovement');
  end;
end;

class function TInstrument.GetCurrencyDefinition(AIdInstrument: TDataGid): TDataGid;
begin
  Result := GDataProvider.GetSqlString(Format('select idCurrencyDef from instrument where idInstrument = %s', [DataGidToDatabase(AIdInstrument)]), '');
end;

procedure TBaseMovement.SetisInvestmentMovement(const Value: Boolean);
begin
  if FisInvestmentMovement <> Value then begin
    FisInvestmentMovement := Value;
    SetState(msModified);
  end;
end;

class function TInvestmentItem.FindInvestmentItem(AIdInstrument, AIdAccount: TDataGid; AMinimumQuantity: Double = -1): TInvestmentItem;
var xSql: String;
begin
  xSql := Format('select * from investmentItem where idInstrument = %s and idAccount = %s',
             [DataGidToDatabase(AIdInstrument), DataGidToDatabase(AIdAccount)]);
  if AMinimumQuantity <> -1 then begin
    xSql := xSql + ' and quantity >= ' + FloatToDatabase(AMinimumQuantity);
  end;
  Result := TInvestmentItem(TInvestmentItem.FindByCondition(InvestmentItemProxy, xSql, False));
end;

procedure TInvestmentPortfolio.FromDataset(ADataset: TADOQuery);
begin
  inherited FromDataset(ADataset);
  with ADataset do begin
    FidInstrument := FieldByName('idInstrument').AsString;
    FidCurrencyDef := FieldByName('idCurrencyDef').AsString;
    FidAccount := FieldByName('idAccount').AsString;
    FinstrumentName := FieldByName('instrumentName').AsString;
    FaccountName := FieldByName('accountName').AsString;
    FinstrumentType := FieldByName('instrumentType').AsString;
    Fquantity := FieldByName('quantity').AsFloat;
    FvalueOf := FieldByName('valueOf').AsCurrency;
  end;
end;

function TInvestmentPortfolio.GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String;
begin
  if AColumnIndex = 0 then begin
    Result := FaccountName;
  end else if AColumnIndex = 1 then begin
    Result := FinstrumentName;
  end else if AColumnIndex = 2 then begin
    Result := FloatToString(Fquantity, 6);
  end else if AColumnIndex = 3 then begin
    Result := CurrencyToString(RoundCurrency(FvalueOf * Fquantity), FidCurrencyDef, False);
  end else if AColumnIndex = 4 then begin
    Result := GCurrencyCache.GetSymbol(FidCurrencyDef);
  end;
end;

function TInvestmentPortfolio.GetElementText: String;
begin
  Result := FaccountName + ' - ' + FinstrumentName;
end;

function TInvestmentPortfolio.GetoverallValue: Currency;
begin
  Result := RoundCurrency(Fquantity * FvalueOf);
end;

procedure TMovementList.AfterPost;
begin
  FprevIdAccount := FidAccount;
  FprevCash := Fcash;
  inherited AfterPost;
end;

procedure TBaseMovement.AfterPost;
begin
  FprevCash := Fcash;
  FprevIdAccount := FidAccount;
  FprevIdSourceAccount := FidSourceAccount;
  FprevmovementCash := FmovementCash;
  inherited AfterPost;
end;

procedure TAccount.DeleteObject;
begin
 GDataProvider.ExecuteSql('delete from movementStatistics where idAccount = ' + DataGidToDatabase(id) + ' or idSourceAccount = ' + DataGidToDatabase(id));
 inherited DeleteObject;
  if GDefaultAccountId = id then begin
    GDefaultAccountId := CEmptyDataGid;
  end;
end;

constructor TQuickPattern.Create(AStatic: Boolean);
begin
  inherited Create(AStatic);
  FidAccount := CEmptyDataGid;
  FidSourceAccount := CEmptyDataGid;
  FidCashPoint := CEmptyDataGid;
  FidProduct := CEmptyDataGid;
end;

procedure TQuickPattern.FromDataset(ADataset: TADOQuery);
begin
  inherited FromDataset(ADataset);
  with ADataset do begin
    Fname := FieldByName('name').AsString;
    Fdescription := FieldByName('description').AsString;
    FmovementType := FieldByName('movementType').AsString;
    FidAccount := FieldByName('idAccount').AsString;
    FidSourceAccount := FieldByName('idSourceAccount').AsString;
    FidCashPoint := FieldByName('idCashPoint').AsString;
    FidProduct := FieldByName('idProduct').AsString;
  end;
end;

function TQuickPattern.GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String;
begin
  Result := Fname;
end;

function TQuickPattern.GetElementHint(AColumnIndex: Integer): String;
begin
  Result := Fdescription;
end;

function TQuickPattern.GetElementText: String;
begin
  Result := Fname;
end;

procedure TQuickPattern.Setdescription(const Value: TBaseDescription);
begin
  if Fdescription <> Value then begin
    Fdescription := Value;
    SetState(msModified);
  end;
end;

procedure TQuickPattern.SetidAccount(const Value: TDataGid);
begin
  if FidAccount <> Value then begin
    FidAccount := Value;
    SetState(msModified);
  end;
end;

procedure TQuickPattern.SetidCashPoint(const Value: TDataGid);
begin
  if FidCashPoint <> Value then begin
    FidCashPoint := Value;
    SetState(msModified);
  end;
end;

procedure TQuickPattern.SetidProduct(const Value: TDataGid);
begin
  if FidProduct <> Value then begin
    FidProduct := Value;
    SetState(msModified);
  end;
end;

procedure TQuickPattern.SetidSourceAccount(const Value: TDataGid);
begin
  if FidSourceAccount <> Value then begin
    FidSourceAccount := Value;
    SetState(msModified);
  end;
end;

procedure TQuickPattern.SetmovementType(const Value: TBaseEnumeration);
begin
  if FmovementType <> Value then begin
    FmovementType := Value;
    SetState(msModified);
  end;
end;

procedure TQuickPattern.Setname(const Value: TBaseName);
begin
  if Fname <> Value then begin
    Fname := Value;
    SetState(msModified);
  end;
end;

procedure TQuickPattern.UpdateFieldList;
begin
  inherited UpdateFieldList;
  with DataFieldList do begin
    AddField('name', Fname, True, 'quickPattern');
    AddField('description', Fdescription, True, 'quickPattern');
    AddField('movementType', FmovementType, True, 'quickPattern');
    AddField('idAccount', DataGidToDatabase(FidAccount), False, 'quickPattern');
    AddField('idSourceAccount', DataGidToDatabase(FidSourceAccount), False, 'quickPattern');
    AddField('idCashPoint', DataGidToDatabase(FidCashPoint), False, 'quickPattern');
    AddField('idProduct', DataGidToDatabase(FidProduct), False, 'quickPattern');
  end;
end;

constructor TQuickPatternElement.Create(AName: TBaseDescription; ADesc: TBaseDescription; AMovementType: TBaseEnumeration;
                                        AIdAccount, AIdSourceAccount, AIdCashpoint, AIdProduct: TDataGid; AIsStatistic: Boolean);
begin
  inherited Create;
  Fname := AName;
  Fdescription := ADesc;
  FmovementType := AMovementType;
  FidAccount := AIdAccount;
  FidSourceAccount := AidSourceAccount;
  FidCashPoint := AIdCashpoint;
  FidProduct := AIdProduct;
  FisStatistic := AIsStatistic;
end;

function TQuickPatternElement.GetColumnImage(AColumnIndex: Integer): Integer;
begin
  if FmovementType = CTransferMovement then begin
    Result := 2;
  end else if FmovementType = CInMovement then begin
    Result := 0;
  end else begin
    Result := 1;
  end;
end;

function TQuickPatternElement.GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String;
begin
  Result := Fname;
end;

function TQuickPatternElement.GetElementHint(AColumnIndex: Integer): String;
begin
  Result := Fdescription;
end;

constructor TDepositInvestment.Create(AStatic: Boolean);
begin
  inherited Create(AStatic);
  FidCashPoint := CEmptyDataGid;
  FidCurrencyDef := CEmptyDataGid;
end;

procedure TDepositInvestment.FromDataset(ADataset: TADOQuery);
begin
  inherited FromDataset(ADataset);
  with ADataset do begin
    FdepositState := FieldByName('depositState').AsString;
    Fname := FieldByName('name').AsString;
    Fdescription := FieldByName('description').AsString;
    FidCashPoint := FieldByName('idCashPoint').AsString;
    FidCurrencyDef := FieldByName('idCurrencyDef').AsString;
    Fcash := FieldByName('cash').AsCurrency;
    FinterestRate := FieldByName('interestRate').AsCurrency;
    FnoncapitalizedInterest := FieldByName('noncapitalizedInterest').AsCurrency;
    FperiodCount := FieldByName('periodCount').AsInteger;
    FperiodType := FieldByName('periodType').AsString;
    FperiodStartDate := FieldByName('periodStartDate').AsDateTime;
    FperiodEndDate := FieldByName('periodEndDate').AsDateTime;
    FperiodAction := FieldByName('periodAction').AsString;
    FdueCount := FieldByName('dueCount').AsInteger;
    FdueType := FieldByName('dueType').AsString;
    FdueStartDate := FieldByName('dueStartDate').AsDateTime;
    FdueEndDate := FieldByName('dueEndDate').AsDateTime;
    FdueAction := FieldByName('dueAction').AsString;
    FcalcTax := FieldByName('calcTax').AsBoolean;
    FtaxRate := FieldByName('taxRate').AsCurrency;
  end;
end;

function TDepositInvestment.GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String;
begin
  Result := '';
  if AColumnIndex = 0 then begin
    Result := Fname;
  end else if AColumnIndex = 1 then begin
    if FdepositState = CDepositInvestmentActive then begin
      Result := 'Aktywna';
    end else if FdepositState = CDepositInvestmentInactive then begin
      Result := 'Nieaktywna';
    end else begin
      Result := 'Zamkni�ta';
    end;
  end else if AColumnIndex = 2 then begin
    Result := CurrencyToString(Fcash, '', False);
  end else if AColumnIndex = 3 then begin
    Result := GCurrencyCache.GetSymbol(FidCurrencyDef);
  end else if AColumnIndex = 4 then begin
    if FdepositState = CDepositInvestmentActive then begin
      Result := Date2StrDate(FperiodEndDate);
    end else begin
      Result := '';
    end;
  end else if AColumnIndex = 5 then begin
    if FdepositState = CDepositInvestmentActive then begin
      Result := Date2StrDate(FdueEndDate);
    end else begin
      Result := '';
    end;
  end;
end;

function TDepositInvestment.GetElementHint(AColumnIndex: Integer): String;
begin
  Result := Fdescription;
end;

function TDepositInvestment.GetElementText: String;
begin
  Result := Fname;
end;

class function TDepositInvestment.EndDueDatetime(ADueLastDatetime: TDateTime; ADueCount: Integer; ADueType: TBaseEnumeration): TDateTime;
begin
  Result := ADueLastDatetime;
  if ADueType = CDepositTypeDay then begin
    Result := IncDay(ADueLastDatetime, ADueCount);
  end else if ADueType = CDepositTypeWeek then begin
    Result := IncWeek(ADueLastDatetime, ADueCount);
  end else if ADueType = CDepositTypeMonth then begin
    Result := CustomIncMonth(ADueLastDatetime, ADueCount);
  end else if ADueType = CDepositTypeYear then begin
    Result := IncYear(ADueLastDatetime, ADueCount);
  end;
  Result := IncDay(Result, -1);
end;

class function TDepositInvestment.EndPeriodDatetime(APeriodStartDateTime: TDateTime; APeriodCount: Integer; APeriodType: TBaseEnumeration): TDateTime;
begin
  Result := APeriodStartDateTime;
  if APeriodType = CDepositTypeDay then begin
    Result := IncDay(Result, APeriodCount);
  end else if APeriodType = CDepositTypeWeek then begin
    Result := IncWeek(Result, APeriodCount);
  end else if APeriodType = CDepositTypeMonth then begin
    Result := CustomIncMonth(Result, APeriodCount);
  end else if APeriodType = CDepositTypeYear then begin
    Result := IncYear(Result, APeriodCount);
  end;
  Result := IncDay(Result, -1);
end;

function TDepositInvestment.OnDeleteObject(AProxy: TDataProxy): Boolean;
begin
  Result := inherited OnDeleteObject(AProxy);
  AProxy.DataProvider.ExecuteSql(Format('update baseMovement set isDepositMovement = 0 where idBaseMovement in (select idBaseMovement from depositMovement where idDepositInvestment = %s and idBaseMovement is not null)', [DataGidToDatabase(id)]));
  AProxy.DataProvider.ExecuteSql(Format('delete from depositMovement where idDepositInvestment = %s', [DataGidToDatabase(id)]));
end;

procedure TDepositInvestment.Setcash(const Value: Currency);
begin
  if Fcash <> Value then begin
    Fcash := Value;
    SetState(msModified);
  end;
end;

procedure TDepositInvestment.SetdepositState(const Value: TBaseEnumeration);
begin
  if FdepositState <> Value then begin
    FdepositState := Value;
    SetState(msModified);
  end;
end;

procedure TDepositInvestment.Setdescription(const Value: TBaseDescription);
begin
  if Fdescription <> Value then begin
    Fdescription := Value;
    SetState(msModified);
  end;
end;

procedure TDepositInvestment.SetdueAction(const Value: TBaseEnumeration);
begin
  if FdueAction <> Value then begin
    FdueAction := Value;
    SetState(msModified);
  end;
end;

procedure TDepositInvestment.SetdueCount(const Value: Integer);
begin
  if FdueCount <> Value then begin
    FdueCount := Value;
    SetState(msModified);
  end;
end;

procedure TDepositInvestment.SetdueStartDate(const Value: TDateTime);
begin
  if FdueStartDate <> Value then begin
    FdueStartDate := Value;
    SetState(msModified);
  end;
end;

procedure TDepositInvestment.SetdueEndDate(const Value: TDateTime);
begin
  if FdueEndDate <> Value then begin
    FdueEndDate := Value;
    SetState(msModified);
  end;
end;

procedure TDepositInvestment.SetdueType(const Value: TBaseEnumeration);
begin
  if FdueType <> Value then begin
    FdueType := Value;
    SetState(msModified);
  end;
end;

procedure TDepositInvestment.SetidCashPoint(const Value: TDataGid);
begin
  if FidCashPoint <> Value then begin
    FidCashPoint := Value;
    SetState(msModified);
  end;
end;

procedure TDepositInvestment.SetidCurrencyDef(const Value: TDataGid);
begin
  if FidCurrencyDef <> Value then begin
    FidCurrencyDef := Value;
    SetState(msModified);
  end;
end;

procedure TDepositInvestment.SetinterestRate(const Value: Currency);
begin
  if FinterestRate <> Value then begin
    FinterestRate := Value;
    SetState(msModified);
  end;
end;

procedure TDepositInvestment.Setname(const Value: TBaseName);
begin
  if Fname <> Value then begin
    Fname := Value;
    SetState(msModified);
  end;
end;

procedure TDepositInvestment.SetnoncapitalizedInterest(const Value: Currency);
begin
  if FnoncapitalizedInterest <> Value then begin
    FnoncapitalizedInterest := Value;
    SetState(msModified);
  end;
end;

procedure TDepositInvestment.SetperiodAction(const Value: TBaseEnumeration);
begin
  if FperiodAction <> Value then begin
    FperiodAction := Value;
    SetState(msModified);
  end;
end;

procedure TDepositInvestment.SetperiodCount(const Value: Integer);
begin
  if FperiodCount <> Value then begin
    FperiodCount := Value;
    SetState(msModified);
  end;
end;

procedure TDepositInvestment.SetperiodEndDate(const Value: TDateTime);
begin
  if FperiodEndDate <> Value then begin
    FperiodEndDate := Value;
    SetState(msModified);
  end;
end;

procedure TDepositInvestment.SetperiodStartDate(const Value: TDateTime);
begin
  if FperiodStartDate <> Value then begin
    FperiodStartDate := Value;
    SetState(msModified);
  end;
end;

procedure TDepositInvestment.SetperiodType(const Value: TBaseEnumeration);
begin
  if FperiodType <> Value then begin
    FperiodType := Value;
    SetState(msModified);
  end;
end;

procedure TDepositInvestment.UpdateFieldList;
begin
  inherited UpdateFieldList;
  with DataFieldList do begin
    AddField('depositState', FdepositState, True, 'depositInvestment');
    AddField('name', Fname, True, 'depositInvestment');
    AddField('description', Fdescription, True, 'depositInvestment');
    AddField('idCashPoint', DataGidToDatabase(FidCashPoint), False, 'depositInvestment');
    AddField('idCurrencyDef', DataGidToDatabase(FidCurrencyDef), False, 'depositInvestment');
    AddField('cash', CurrencyToDatabase(Fcash), False, 'depositInvestment');
    AddField('interestRate', CurrencyToDatabase(FinterestRate), False, 'depositInvestment');
    AddField('noncapitalizedInterest', CurrencyToDatabase(FnoncapitalizedInterest), False, 'depositInvestment');
    AddField('periodCount', IntToStr(FperiodCount), False, 'depositInvestment');
    AddField('periodType', FperiodType, True, 'depositInvestment');
    AddField('periodStartDate', DatetimeToDatabase(FperiodStartDate, False), False, 'depositInvestment');
    AddField('periodEndDate', DatetimeToDatabase(FperiodEndDate, False), False, 'depositInvestment');
    AddField('periodAction', FperiodAction, True, 'depositInvestment');
    AddField('dueCount', IntToStr(FdueCount), False, 'depositInvestment');
    AddField('dueType', FdueType, True, 'depositInvestment');
    AddField('dueStartDate', DatetimeToDatabase(FdueStartDate, False), False, 'depositInvestment');
    AddField('dueEndDate', DatetimeToDatabase(FdueEndDate, False), False, 'depositInvestment');
    AddField('dueAction', FdueAction, True, 'depositInvestment');
    AddField('calcTax', IntToStr(Integer(FcalcTax)), False, 'depositInvestment');
    AddField('taxRate', CurrencyToDatabase(FtaxRate), False, 'depositInvestment');
  end;
end;

constructor TDepositMovement.Create(AStatic: Boolean);
begin
  inherited Create(AStatic);
  FidDepositInvestment := CEmptyDataGid;
  FidAccount := CEmptyDataGid;
  FidAccountCurrencyDef := CEmptyDataGid;
  FidCurrencyRate := CEmptyDataGid;
  FidProduct := CEmptyDataGid;
  idBaseMovement := CEmptyDataGid;
end;

procedure TDepositMovement.FromDataset(ADataset: TADOQuery);
begin
  inherited FromDataset(ADataset);
  with ADataset do begin
    FmovementType := FieldByName('movementType').AsString;
    FregDateTime := FieldByName('regDateTime').AsDateTime;
    FregOrder := FieldByName('regOrder').AsInteger;
    Fdescription := FieldByName('description').AsString;
    Fcash := FieldByName('cash').AsCurrency;
    Finterest := FieldByName('interest').AsCurrency;
    FdepositState := FieldByName('depositState').AsString;
    FidDepositInvestment := FieldByName('idDepositInvestment').AsString;
    FidAccount := FieldByName('idAccount').AsString;
    FidAccountCurrencyDef := FieldByName('idAccountCurrencyDef').AsString;
    FaccountCash := FieldByName('accountCash').AsCurrency;
    FidCurrencyRate := FieldByName('idCurrencyRate').AsString;
    FcurrencyQuantity := FieldByName('currencyQuantity').AsInteger;
    FcurrencyRate := FieldByName('currencyRate').AsCurrency;
    FrateDescription := FieldByName('rateDescription').AsString;
    FidProduct := FieldByName('idProduct').AsString;
    FidBaseMovement := FieldByName('idBaseMovement').AsString;
    FidCurrencyDef := FieldByName('idCurrencyDef').AsString;
  end;
end;

function TDepositMovement.GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String;
begin
  Result := '';
  if AColumnIndex = 1 then begin
    Result := Date2StrDate(FregDateTime, False);
  end else if AColumnIndex = 2 then begin
    Result := GetDescText(Fdescription);
  end else if AColumnIndex = 3 then begin
    Result := CurrencyToString(Fcash + Finterest, FidCurrencyDef);
  end else if AColumnIndex = 4 then begin
    if FmovementType = CDepositMovementCreate then begin
      Result := 'Za�o�enie lokaty';
    end else if FmovementType = CDepositMovementRegister then begin
      Result := 'Rejestracja lokaty';
    end else if FmovementType = CDepositMovementInactivate then begin
      Result := 'Zako�czenie lokaty';
    end else if FmovementType = CDepositMovementRenew then begin
      Result := 'Odnowienie lokaty';
    end else if FmovementType = CDepositMovementDue then begin
      Result := 'Naliczenie odsetek';
    end else if FmovementType = CDepositMovementAddCash then begin
      Result := 'Dop�ata do lokaty';
    end else if FmovementType = CDepositMovementClose then begin
      Result := 'Likwidacja lokaty';
    end else if FmovementType = CDepositMovementGetInterest then begin
      Result := 'Wyp�ata odsetek';
    end;
  end;
end;

function TDepositMovement.GetElementText: String;
begin
  Result := Fdescription;
end;

function TDepositMovement.OnDeleteObject(AProxy: TDataProxy): Boolean;
begin
  Result := inherited OnDeleteObject(AProxy);
  if (movementType = CDepositMovementAddCash) then begin
    AProxy.DataProvider.ExecuteSql('update depositInvestment set cash = cash - ' + CurrencyToDatabase(cash) + ' where idDepositInvestment = ' + DataGidToDatabase(idDepositInvestment));
  end else if (movementType = CDepositMovementGetInterest) then begin
    AProxy.DataProvider.ExecuteSql('update depositInvestment set noncapitalizedInterest = noncapitalizedInterest + ' + CurrencyToDatabase(interest) + ' where idDepositInvestment = ' + DataGidToDatabase(idDepositInvestment));
  end else if (movementType = CDepositMovementClose) then begin
    AProxy.DataProvider.ExecuteSql('update depositInvestment set noncapitalizedInterest = ' + CurrencyToDatabase(interest) + ', ' +
                                   'cash = ' + CurrencyToDatabase(cash) + ', depositState = ''' + FdepositState + '''' +
                                   ' where idDepositInvestment = ' + DataGidToDatabase(idDepositInvestment));
  end;
end;

procedure TDepositMovement.SetaccountCash(const Value: Currency);
begin
  if FaccountCash <> Value then begin
    FaccountCash := Value;
    SetState(msModified);
  end;
end;

procedure TDepositMovement.Setcash(const Value: Currency);
begin
  if Fcash <> Value then begin
    Fcash := Value;
    SetState(msModified);
  end;
end;

procedure TDepositMovement.SetcurrencyQuantity(const Value: Integer);
begin
  if FcurrencyQuantity <> Value then begin
    FcurrencyQuantity := Value;
    SetState(msModified);
  end;
end;

procedure TDepositMovement.SetcurrencyRate(const Value: Currency);
begin
  if FcurrencyRate <> Value then begin
    FcurrencyRate := Value;
    SetState(msModified);
  end;
end;

procedure TDepositMovement.SetdepositState(const Value: TBaseEnumeration);
begin
  if FdepositState <> Value then begin
    FdepositState := Value;
    SetState(msModified);
  end;
end;

procedure TDepositMovement.Setdescription(const Value: TBaseDescription);
begin
  if Fdescription <> Value then begin
    Fdescription := Value;
    SetState(msModified);
  end;
end;

procedure TDepositMovement.SetidAccount(const Value: TDataGid);
begin
  if FidAccount <> Value then begin
    FidAccount := Value;
    SetState(msModified);
  end;
end;

procedure TDepositMovement.SetidAccountCurrencyDef(const Value: TDataGid);
begin
  if FidAccountCurrencyDef <> Value then begin
    FidAccountCurrencyDef := Value;
    SetState(msModified);
  end;
end;

procedure TDepositMovement.SetidBaseMovement(const Value: TDataGid);
begin
  if FidBaseMovement <> Value then begin
    FidBaseMovement := Value;
    SetState(msModified);
  end;
end;

procedure TDepositMovement.SetidCurrencyRate(const Value: TDataGid);
begin
  if FidCurrencyRate <> Value then begin
    FidCurrencyRate := Value;
    SetState(msModified);
  end;
end;

procedure TDepositMovement.SetidDepositInvestment(const Value: TDataGid);
begin
  if FidDepositInvestment <> Value then begin
    FidDepositInvestment := Value;
    SetState(msModified);
  end;
end;

procedure TDepositMovement.SetidProduct(const Value: TDataGid);
begin
  if FidProduct <> Value then begin
    FidProduct := Value;
    SetState(msModified);
  end;
end;

procedure TDepositMovement.Setinterest(const Value: Currency);
begin
  if Finterest <> Value then begin
    Finterest := Value;
    SetState(msModified);
  end;
end;

procedure TDepositMovement.SetmovementType(const Value: TBaseEnumeration);
begin
  if FmovementType <> Value then begin
    FmovementType := Value;
    SetState(msModified);
  end;
end;

procedure TDepositMovement.SetrateDescription(const Value: TBaseDescription);
begin
  if FrateDescription <> Value then begin
    FrateDescription := Value;
    SetState(msModified);
  end;
end;

procedure TDepositMovement.SetregDateTime(const Value: TDateTime);
begin
  if FregDateTime <> Value then begin
    FregDateTime := Value;
    SetState(msModified);
  end;
end;

procedure TDepositMovement.SetregOrder(const Value: Integer);
begin
  if FregOrder <> Value then begin
    FregOrder := Value;
    SetState(msModified);
  end;
end;

procedure TDepositMovement.UpdateFieldList;
begin
  inherited UpdateFieldList;
  with DataFieldList do begin
    AddField('movementType', FmovementType, True, 'depositMovement');
    AddField('regDateTime', DatetimeToDatabase(FregDateTime, False), False, 'depositMovement');
    AddField('regOrder', IntToStr(FregOrder), False, 'depositMovement');
    AddField('description', Fdescription, True, 'depositMovement');
    AddField('cash', CurrencyToDatabase(Fcash), False, 'depositMovement');
    AddField('interest', CurrencyToDatabase(Finterest), False, 'depositMovement');
    AddField('depositState', FdepositState, True, 'depositMovement');
    AddField('idDepositInvestment', DataGidToDatabase(FidDepositInvestment), False, 'depositMovement');
    AddField('idAccount', DataGidToDatabase(FidAccount), False, 'depositMovement');
    AddField('idAccountCurrencyDef', DataGidToDatabase(FidAccountCurrencyDef), False, 'depositMovement');
    AddField('accountCash', CurrencyToDatabase(FaccountCash), False, 'depositMovement');
    AddField('idCurrencyRate', DataGidToDatabase(FidCurrencyRate), False, 'depositMovement');
    AddField('currencyQuantity', IntToStr(FcurrencyQuantity), False, 'depositMovement');
    AddField('currencyRate', CurrencyToDatabase(FcurrencyRate), False, 'depositMovement');
    AddField('rateDescription', FrateDescription, True, 'depositMovement');
    AddField('idProduct', DataGidToDatabase(FidProduct), False, 'depositMovement');
    AddField('idBaseMovement', DataGidToDatabase(FidBaseMovement), False, 'depositMovement');
  end;
end;

procedure TBaseMovement.SetidDepositMovement(const Value: Boolean);
begin
  if FisDepositMovement <> Value then begin
    FisDepositMovement := Value;
    SetState(msModified);
  end;
end;

function TDepositInvestment.GetColumnImage(AColumnIndex: Integer): Integer;
begin
  Result := inherited GetColumnImage(AColumnIndex);
  if AColumnIndex = 1 then begin
    if FdepositState = CDepositInvestmentActive then begin
      Result := 0;
    end else if FdepositState = CDepositInvestmentClosed then begin
      Result := 1;
    end else begin
      Result := 2;
    end;
  end;
end;

function TInvestmentItem.GetInvestmentItems: TDataObjectList;
begin
  Result := TInvestmentMovement.GetList(TInvestmentMovement, InvestmentMovementProxy,
     Format('select * from investmentMovement where idInstrument = %s and idAccount = %s', [DataGidToDatabase(idInstrument), DataGidToDatabase(idAccount)]));
end;

function TDepositInvestment.GetDepositMovements: TDataObjectList;
begin
  Result := TDepositMovement.GetList(TDepositMovement, DepositMovementProxy,
     Format('select * from StnDepositMovement where idDepositInvestment = %s', [DataGidToDatabase(id)]));
end;

class function TDepositInvestment.GetCurrencyDefinition(AIdDepositInvestment: TDataGid): TDataGid;
begin
  Result := GDataProvider.GetSqlString(Format('select idCurrencyDef from depositInvestment where idDepositInvestment = %s', [DataGidToDatabase(AIdDepositInvestment)]), '');
end;

function TDepositInvestment.GetDepositCashpointName: String;
begin
  Result := GDataProvider.GetSqlString(Format('select name from cashpoint where idCashpoint = %s', [DataGidToDatabase(idCashPoint)]), '');
end;

procedure TAccount.SetAccountState(const Value: TBaseEnumeration);
begin
  if FaccountState <> Value then begin
    FaccountState := Value;
    SetState(msModified);
  end;
end;

procedure TDepositInvestment.SetcalcTax(const Value: Boolean);
begin
  if FcalcTax <> Value then begin
    FcalcTax := Value;
    SetState(msModified);
  end;
end;

procedure TDepositInvestment.SettaxRate(const Value: Currency);
begin
  if FtaxRate <> Value then begin
    FtaxRate := Value;
    SetState(msModified);
  end;
end;

initialization
  GCurrencyCache := TCurrCache.Create(0);
  GUnitdefCache := TCurrCache.Create(1);
finalization
  GCurrencyCache.Free;
  GUnitdefCache.Free;
end.
