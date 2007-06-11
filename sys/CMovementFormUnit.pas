unit CMovementFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  CComponents, CDatabase, CBaseFrameUnit, ActnList, XPStyleActnCtrls,
  ActnMan, CImageListsUnit, Contnrs, CDataObjects;

type
  TMovementAdditionalData = class(TAdditionalData)
  private
    FtriggerDate: TDateTime;
    Fplanned: TDataObject;
  public
    constructor Create(ATriggerDate: TDateTime; APlanned: TDataObject);
  published
    property triggerDate: TDateTime read FtriggerDate write FtriggerDate;
    property planned: TDataObject read Fplanned write Fplanned;
  end;

  TCMovementForm = class(TCDataobjectForm)
    GroupBox1: TGroupBox;
    Label3: TLabel;
    GroupBox2: TGroupBox;
    RichEditDesc: TRichEdit;
    ComboBoxType: TComboBox;
    Label5: TLabel;
    GroupBox3: TGroupBox;
    PageControl: TPageControl;
    TabSheetInOutCyclic: TTabSheet;
    TabSheetTrans: TTabSheet;
    TabSheetInOutOnce: TTabSheet;
    Label4: TLabel;
    CStaticInoutOnceAccount: TCStatic;
    Label1: TLabel;
    CStaticInoutOnceCategory: TCStatic;
    Label2: TLabel;
    CStaticInoutOnceCashpoint: TCStatic;
    Label6: TLabel;
    CStaticTransSourceAccount: TCStatic;
    Label7: TLabel;
    CStaticTransDestAccount: TCStatic;
    Label9: TLabel;
    CCurrEditInoutOnceMovement: TCCurrEdit;
    Label11: TLabel;
    CStaticInoutCyclic: TCStatic;
    Label14: TLabel;
    CStaticInoutCyclicAccount: TCStatic;
    Label12: TLabel;
    CStaticInoutCyclicCategory: TCStatic;
    Label13: TLabel;
    CStaticInoutCyclicCashpoint: TCStatic;
    ActionManager: TActionManager;
    ActionAdd: TAction;
    CButton1: TCButton;
    ActionTemplate: TAction;
    CButton2: TCButton;
    ComboBoxTemplate: TComboBox;
    Label17: TLabel;
    CStaticInOutOnceCurrencyAccount: TCStatic;
    Label20: TLabel;
    CStaticInOutOnceMovementCurrency: TCStatic;
    Label21: TLabel;
    CCurrEditInOutOnceAccount: TCCurrEdit;
    Label22: TLabel;
    CStaticInOutOnceRate: TCStatic;
    Label10: TLabel;
    CStaticInOutCyclicMovementCurrency: TCStatic;
    Label18: TLabel;
    CCurrEditInoutCyclicMovement: TCCurrEdit;
    Label23: TLabel;
    CStaticInOutCyclicRate: TCStatic;
    Label24: TLabel;
    CStaticInOutCyclicCurrencyAccount: TCStatic;
    Label25: TLabel;
    CCurrEditInOutCyclicAccount: TCCurrEdit;
    Label8: TLabel;
    CStaticTransCurrencySource: TCStatic;
    Label19: TLabel;
    CCurrEditTransMovement: TCCurrEdit;
    Label26: TLabel;
    CStaticTransRate: TCStatic;
    Label27: TLabel;
    CStaticTransCurrencyDest: TCStatic;
    Label28: TLabel;
    CCurrEditTransAccount: TCCurrEdit;
    CDateTime: TCDateTime;
    procedure ComboBoxTypeChange(Sender: TObject);
    procedure CStaticInoutOnceAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticInoutCyclicAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticTransSourceAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticTransDestAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticInoutOnceCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticInoutCyclicCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticInoutCyclicCategoryGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticInoutOnceCategoryGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticInoutOnceAccountChanged(Sender: TObject);
    procedure CStaticInoutCyclicGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticInoutCyclicChanged(Sender: TObject);
    procedure ActionTemplateExecute(Sender: TObject);
    procedure ActionAddExecute(Sender: TObject);
    procedure CDateTimeChanged(Sender: TObject);
    procedure ComboBoxTemplateChange(Sender: TObject);
    procedure CStaticInOutOnceCurrencyAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticCurrencyCyclicGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticCurrencyTransGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticInOutOnceMovementCurrencyChanged(Sender: TObject);
    procedure CStaticInoutOnceCategoryChanged(Sender: TObject);
    procedure CStaticInoutOnceCashpointChanged(Sender: TObject);
    procedure CStaticInoutCyclicCashpointChanged(Sender: TObject);
    procedure CStaticInoutCyclicCategoryChanged(Sender: TObject);
    procedure CStaticInoutCyclicAccountChanged(Sender: TObject);
    procedure CStaticTransSourceAccountChanged(Sender: TObject);
    procedure CStaticTransDestAccountChanged(Sender: TObject);
    procedure CStaticInOutCyclicMovementCurrencyChanged(Sender: TObject);
    procedure CCurrEditTransMovementChange(Sender: TObject);
    procedure CCurrEditInoutOnceMovementChange(Sender: TObject);
    procedure CCurrEditInoutCyclicMovementChange(Sender: TObject);
    procedure CStaticInOutOnceRateGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticInOutOnceRateChanged(Sender: TObject);
    procedure CStaticInOutCyclicRateGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticInOutCyclicRateChanged(Sender: TObject);
    procedure CStaticTransRateGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticTransRateChanged(Sender: TObject);
  private
    FbaseAccount: TDataGid;
    FsourceAccount: TDataGid;
    FbaseList: TDataGid;
    FOnceRateHelper: TCurrencyRateHelper;
    FCyclicRateHelper: TCurrencyRateHelper;
    FTransferRateHelper: TCurrencyRateHelper;
  protected
    procedure UpdateCurrencyRates(AUpdateCurEdit: Boolean = True);
    procedure UpdateAccountCurEdit(ARate: TCStatic; ASourceEdit, ATargetEdit: TCCurrEdit; AHelper: TCurrencyRateHelper);
    procedure UpdateAccountCurDef(AAccountId: TDataGid; AStatic: TCStatic; ACurEdit: TCCurrEdit);
    procedure UpdateDescription;
    procedure InitializeForm; override;
    function ChooseAccount(var AId: String; var AText: String): Boolean;
    function ChooseCashpoint(var AId: String; var AText: String): Boolean;
    function ChooseProduct(var AId: String; var AText: String): Boolean;
    function ChoosePlanned(var AId: String; var AText: String): Boolean;
    function ChooseCurrencyDef(var AId: String; var AText: String): Boolean;
    function ChooseCurrencyRate(var AId: String; var AText: String; var AHelper: TCurrencyRateHelper; ASourceId, ATargetId: TDataGid): Boolean;
    procedure ReadValues; override;
    function GetDataobjectClass: TDataObjectClass; override;
    procedure FillForm; override;
    function CanAccept: Boolean; override;
    procedure UpdateFrames(ADataGid: TDataGid; AMessage, AOption: Integer); override;
    function GetUpdateFrameOption: Integer; override;
    function GetUpdateFrameClass: TCBaseFrameClass; override;
  public
    function ExpandTemplate(ATemplate: String): String; override;
    destructor Destroy; override;
  end;

implementation

uses CAccountsFrameUnit, CFrameFormUnit, CCashpointsFrameUnit,
  CProductsFrameUnit, DateUtils, StrUtils, Math,
  CConfigFormUnit, CInfoFormUnit, CPlannedFrameUnit,
  CDoneFrameUnit, CConsts, CMovementFrameUnit, CDescpatternFormUnit,
  CTemplates, CPreferences, CRichtext, CDataobjectFrameUnit,
  CSurpassedFormUnit, CTools, CCurrencydefFrameUnit,
  CCurrencyRateFrameUnit;

{$R *.dfm}

function TCMovementForm.ChooseAccount(var AId: String; var AText: String): Boolean;
begin
  Result := TCFrameForm.ShowFrame(TCAccountsFrame, AId, AText);
end;

procedure TCMovementForm.ComboBoxTypeChange(Sender: TObject);
var xProfile: TProfile;
begin
  Caption := 'Operacja';
  if (ComboBoxType.ItemIndex = 0) or (ComboBoxType.ItemIndex = 1) then begin
    PageControl.ActivePage := TabSheetInOutOnce;
    if Operation = coAdd then begin
      if GActiveProfileId <> CEmptyDataGid then begin
        GDataProvider.BeginTransaction;
        xProfile := TProfile(TProfile.LoadObject(ProfileProxy, GActiveProfileId, False));
        Caption := Caption + ' - ' + xProfile.name;
        if xProfile.idAccount <> CEmptyDataGid then begin
          CStaticInoutOnceAccount.DataId := xProfile.idAccount;
          CStaticInoutOnceAccount.Caption := TAccount(TAccount.LoadObject(AccountProxy, xProfile.idAccount, False)).name;
        end;
        if xProfile.idCashPoint <> CEmptyDataGid then begin
          CStaticInoutOnceCashpoint.DataId := xProfile.idCashPoint;
          CStaticInoutOnceCashpoint.Caption := TCashPoint(TCashPoint.LoadObject(CashPointProxy, xProfile.idCashPoint, False)).name;
        end;
        if xProfile.idProduct <> CEmptyDataGid then begin
          CStaticInoutOnceCategory.DataId := xProfile.idProduct;
          CStaticInoutOnceCategory.Caption := TProduct(TProduct.LoadObject(ProductProxy, xProfile.idProduct, False)).name;
        end;
        GDataProvider.RollbackTransaction;
      end;
    end;
  end else if (ComboBoxType.ItemIndex = 3) or (ComboBoxType.ItemIndex = 4) then begin
    PageControl.ActivePage := TabSheetInOutCyclic;
  end else if (ComboBoxType.ItemIndex = 2) then begin
    PageControl.ActivePage := TabSheetTrans;
  end;
  UpdateCurrencyRates;
  UpdateDescription;
end;

procedure TCMovementForm.InitializeForm;
var xAdd: TMovementAdditionalData;
    xPlan: TPlannedMovement;
    xText: String;
begin
  FillCombo(ComboBoxType, CBaseMovementTypes);
  FOnceRateHelper := Nil;
  FCyclicRateHelper := Nil;
  FTransferRateHelper := Nil;
  CDateTime.Value := GWorkDate;
  FbaseAccount := CEmptyDataGid;
  FbaseList := CEmptyDataGid;
  FsourceAccount := CEmptyDataGid;
  if Operation = coAdd then begin
    CStaticInOutOnceMovementCurrency.DataId := CCurrencyDefGid_PLN;
    CStaticInOutOnceMovementCurrency.Caption := TCurrencyDef(TCurrencyDef.LoadObject(CurrencyDefProxy, CCurrencyDefGid_PLN, False)).GetElementText;
    CCurrEditInoutOnceMovement.SetCurrencyDef(CCurrencyDefGid_PLN, GCurrencyCache.GetSymbol(CCurrencyDefGid_PLN));
    CCurrEditInOutOnceAccount.SetCurrencyDef(CEmptyDataGid, '');
    CStaticInOutCyclicMovementCurrency.DataId := CCurrencyDefGid_PLN;
    CStaticInOutCyclicMovementCurrency.Caption := TCurrencyDef(TCurrencyDef.LoadObject(CurrencyDefProxy, CCurrencyDefGid_PLN, False)).GetElementText;
    CCurrEditInOutCyclicAccount.SetCurrencyDef(CEmptyDataGid, '');
    CCurrEditInoutCyclicMovement.SetCurrencyDef(CCurrencyDefGid_PLN, GCurrencyCache.GetSymbol(CCurrencyDefGid_PLN));
    CCurrEditTransMovement.SetCurrencyDef(CEmptyDataGid, '');
    CCurrEditTransAccount.SetCurrencyDef(CEmptyDataGid, '');
  end;
  if AdditionalData <> Nil then begin
    xAdd := TMovementAdditionalData(AdditionalData);
    xPlan := TPlannedMovement(xAdd.planned);
    if xPlan.movementType = CInMovement then begin
      ComboBoxType.ItemIndex := 4;
      xText := xPlan.description + ' (wp³yw do ' + DateToStr(xAdd.triggerDate) + ')'
    end else if xPlan.movementType = COutMovement then begin
      ComboBoxType.ItemIndex := 3;
      xText := xPlan.description + ' (p³atne do ' + DateToStr(xAdd.triggerDate) + ')'
    end;
    CStaticInoutCyclic.DataId := xPlan.id + '|' + DatetimeToDatabase(xAdd.triggerDate, False);
    CStaticInoutCyclic.Caption := xText;
    CStaticInoutCyclicChanged(CStaticInoutCyclic);
  end;
  ComboBoxTypeChange(ComboBoxType);
  UpdateDescription;
  UpdateCurrencyRates;
end;

procedure TCMovementForm.CStaticInoutOnceAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseAccount(ADataGid, AText);
end;

procedure TCMovementForm.CStaticInoutCyclicAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseAccount(ADataGid, AText);
end;

procedure TCMovementForm.CStaticTransSourceAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseAccount(ADataGid, AText);
end;

procedure TCMovementForm.CStaticTransDestAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseAccount(ADataGid, AText);
end;

function TCMovementForm.ChooseCashpoint(var AId, AText: String): Boolean;
var xCt: String;
begin
  if (ComboBoxType.ItemIndex = 0) or (ComboBoxType.ItemIndex = 3) then begin
    xCt := CCashpointTypeOut;
  end else if (ComboBoxType.ItemIndex = 1) or (ComboBoxType.ItemIndex = 4) then begin
    xCt := CCashpointTypeIn;
  end;
  Result := TCFrameForm.ShowFrame(TCCashpointsFrame, AId, AText, TCDataobjectFrameData.CreateWithFilter(xCt));
end;

procedure TCMovementForm.CStaticInoutOnceCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseCashpoint(ADataGid, AText);
end;

procedure TCMovementForm.CStaticInoutCyclicCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseCashpoint(ADataGid, AText);
end;

function TCMovementForm.ChooseProduct(var AId, AText: String): Boolean;
var xProd: String;
begin
  if (ComboBoxType.ItemIndex = 0) or (ComboBoxType.ItemIndex = 3) then begin
    xProd := COutProduct;
  end else begin
    xProd := CInProduct;
  end;
  Result := TCFrameForm.ShowFrame(TCProductsFrame, AId, AText, TCDataobjectFrameData.CreateWithFilter(xProd));
end;

procedure TCMovementForm.CStaticInoutCyclicCategoryGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseProduct(ADataGid, AText);
end;

procedure TCMovementForm.CStaticInoutOnceCategoryGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseProduct(ADataGid, AText);
end;

procedure TCMovementForm.UpdateDescription;
var xDesc: String;
begin
  if ComboBoxTemplate.ItemIndex = 1 then begin
    xDesc := GDescPatterns.GetPattern(CDescPatternsKeys[0][ComboBoxType.ItemIndex], '');
    if xDesc <> '' then begin
      xDesc := GBaseTemlatesList.ExpandTemplates(xDesc, Self);
      xDesc := GBaseMovementTemplatesList.ExpandTemplates(xDesc, Self);
      SimpleRichText(xDesc, RichEditDesc);
    end;
  end;
end;

procedure TCMovementForm.CStaticInoutOnceAccountChanged(Sender: TObject);
begin
  UpdateAccountCurDef(CStaticInoutOnceAccount.DataId, CStaticInOutOnceCurrencyAccount, CCurrEditInOutOnceAccount);
  CStaticInOutOnceRate.DataId := CEmptyDataGid;
  UpdateDescription;
  UpdateCurrencyRates;
end;

function TCMovementForm.CanAccept: Boolean;
var xI: Integer;
begin
  Result := True;
  xI := ComboBoxType.ItemIndex;
  if (xI = 0) or (xI = 1) then begin
    if CStaticInoutOnceAccount.DataId = CEmptyDataGid then begin
      Result := False;
      if ShowInfo(itQuestion, 'Nie wybrano konta operacji. Czy wyœwietliæ listê teraz ?', '') then begin
        CStaticInoutOnceAccount.DoGetDataId;
      end;
    end else if CStaticInoutOnceCategory.DataId = CEmptyDataGid then begin
      Result := False;
      if ShowInfo(itQuestion, 'Nie wybrano kategorii operacji. Czy wyœwietliæ listê teraz ?', '') then begin
        CStaticInoutOnceCategory.DoGetDataId;
      end;
    end else if CStaticInoutOnceCashpoint.DataId = CEmptyDataGid then begin
      Result := False;
      if ShowInfo(itQuestion, 'Nie wybrano kontrahenta operacji. Czy wyœwietliæ listê teraz ?', '') then begin
        CStaticInoutOnceCashpoint.DoGetDataId;
      end;
    end else if CStaticInOutOnceMovementCurrency.DataId = CEmptyDataGid then begin
      Result := False;
      if ShowInfo(itQuestion, 'Nie wybrano waluty operacji. Czy wyœwietliæ listê teraz ?', '') then begin
        CStaticInOutOnceMovementCurrency.DoGetDataId;
      end;
    end else if (CStaticInOutOnceRate.DataId = CEmptyDataGid) and (CStaticInOutOnceRate.Enabled) then begin
      Result := False;
      if ShowInfo(itQuestion, 'Nie wybrano przelicznika waluty. Czy wyœwietliæ listê teraz ?', '') then begin
        CStaticInOutOnceRate.DoGetDataId;
      end;
    end else if CCurrEditInOutOnceAccount.Value = 0 then begin
      Result := False;
      ShowInfo(itError, 'Kwota operacji nie mo¿e byæ zerowa', '');
      CCurrEditInOutOnceAccount.SetFocus;
    end;
  end else if xI = 2 then begin
    if CStaticTransSourceAccount.DataId = CEmptyDataGid then begin
      Result := False;
      if ShowInfo(itQuestion, 'Nie wybrano konta Ÿród³owego. Czy wyœwietliæ listê teraz ?', '') then begin
        CStaticTransSourceAccount.DoGetDataId;
      end;
    end else if CStaticTransDestAccount.DataId = CEmptyDataGid then begin
      Result := False;
      if ShowInfo(itQuestion, 'Nie wybrano konta docelowego. Czy wyœwietliæ listê teraz ?', '') then begin
        CStaticTransDestAccount.DoGetDataId;
      end;
    end else if CStaticTransDestAccount.DataId = CStaticTransSourceAccount.DataId then begin
      Result := False;
      ShowInfo(itError, 'Konto Ÿród³owe nie mo¿e byæ kontem docelowym', '');
    end else if CStaticTransCurrencySource.DataId = CEmptyDataGid then begin
      Result := False;
      if ShowInfo(itQuestion, 'Nie wybrano waluty operacji. Czy wyœwietliæ listê teraz ?', '') then begin
        CStaticTransCurrencySource.DoGetDataId;
      end;
    end else if (CStaticTransRate.DataId = CEmptyDataGid) and (CStaticTransRate.Enabled) then begin
      Result := False;
      if ShowInfo(itQuestion, 'Nie wybrano przelicznika waluty. Czy wyœwietliæ listê teraz ?', '') then begin
        CStaticTransRate.DoGetDataId;
      end;
    end else if CCurrEditTransAccount.Value = 0 then begin
      Result := False;
      ShowInfo(itError, 'Kwota transferu nie mo¿e byæ zerowa', '');
      CCurrEditTransAccount.SetFocus;
    end;
  end else if (xI = 3) or (xI = 4) then begin
    if CStaticInoutCyclic.DataId = CEmptyDataGid then begin
      Result := False;
      if ShowInfo(itQuestion, 'Nie wybrano planowanej operacji. Czy wyœwietliæ listê teraz ?', '') then begin
        CStaticInoutCyclic.DoGetDataId;
      end;
    end else if CStaticInoutCyclicAccount.DataId = CEmptyDataGid then begin
      Result := False;
      if ShowInfo(itQuestion, 'Nie wybrano konta operacji. Czy wyœwietliæ listê teraz ?', '') then begin
        CStaticInoutCyclicAccount.DoGetDataId;
      end;
    end else if CStaticInoutCyclicCategory.DataId = CEmptyDataGid then begin
      Result := False;
      if ShowInfo(itQuestion, 'Nie wybrano kategorii operacji. Czy wyœwietliæ listê teraz ?', '') then begin
        CStaticInoutCyclicCategory.DoGetDataId;
      end;
    end else if CStaticInoutCyclicCashpoint.DataId = CEmptyDataGid then begin
      Result := False;
      if ShowInfo(itQuestion, 'Nie wybrano kontrahenta operacji. Czy wyœwietliæ listê teraz ?', '') then begin
        CStaticInoutCyclicCashpoint.DoGetDataId;
      end;
    end else if CStaticInOutCyclicMovementCurrency.DataId = CEmptyDataGid then begin
      Result := False;
      if ShowInfo(itQuestion, 'Nie wybrano waluty operacji. Czy wyœwietliæ listê teraz ?', '') then begin
        CStaticInOutCyclicMovementCurrency.DoGetDataId;
      end;
    end else if (CStaticInOutCyclicRate.DataId = CEmptyDataGid) and (CStaticInOutCyclicRate.Enabled) then begin
      Result := False;
      if ShowInfo(itQuestion, 'Nie wybrano przelicznika waluty. Czy wyœwietliæ listê teraz ?', '') then begin
        CStaticInOutCyclicRate.DoGetDataId;
      end;
    end;
  end;
  if Result then begin
    if (xI = 0) or (xI = 1) then begin
      Result := CheckSurpassedLimits(IfThen(xI = 0, COutMovement, CInMovement), CDateTime.Value,
                                     TDataGids.CreateFromGid(CStaticInoutOnceAccount.DataId),
                                     TDataGids.CreateFromGid(CStaticInoutOnceCashpoint.DataId),
                                     TSumList.CreateWithSum(CStaticInoutOnceCategory.DataId, CCurrEditInOutOnceAccount.Value));
    end else if (xI = 3) or (xI = 4) then begin
      Result := CheckSurpassedLimits(IfThen(xI = 3, COutMovement, CInMovement), CDateTime.Value,
                                     TDataGids.CreateFromGid(CStaticInoutCyclicAccount.DataId),
                                     TDataGids.CreateFromGid(CStaticInoutCyclicCategory.DataId),
                                     TSumList.CreateWithSum(CStaticInoutCyclicCategory.DataId, CCurrEditInOutCyclicAccount.Value));
    end;
  end;
end;

procedure TCMovementForm.FillForm;
var xI: Integer;
    xD: TPlannedDone;
    xM: TPlannedMovement;
begin
  with TBaseMovement(Dataobject) do begin
    ComboBoxTemplate.ItemIndex := IfThen(Operation = coEdit, 0, 1);
    if (movementType = CInMovement) or (movementType = COutMovement) then begin
      if idPlannedDone = CEmptyDataGid then begin
        xI := IfThen(movementType = COutMovement, 0, 1);
      end else begin
        xI := IfThen(movementType = COutMovement, 3, 4);
      end;
    end else if (movementType = CTransferMovement) then begin
      xI := 2;
    end else begin
      xI := -1;
    end;
    ComboBoxType.ItemIndex := xI;
    ComboBoxType.Enabled := False;
    CStaticInoutCyclic.Enabled := False;
    ComboBoxTypeChange(ComboBoxType);
    GDataProvider.BeginTransaction;
    if idMovementList <> CEmptyDataGid then begin
      CDateTime.Enabled := False;
      CStaticInoutOnceAccount.Enabled := False;
      CStaticInoutOnceCashpoint.Enabled := False;
      Caption := Caption + ' - Lista - ' + TMovementList(TMovementList.LoadObject(MovementListProxy, idMovementList, False)).description;
    end;
    if (movementType = COutMovement) or (movementType = CInMovement) then begin
      if idPlannedDone = CEmptyDataGid then begin
        CStaticInoutOnceAccount.DataId := idAccount;
        CStaticInoutOnceAccount.Caption := TAccount(TAccount.LoadObject(AccountProxy, idAccount, False)).name;
        CStaticInoutOnceCashpoint.DataId := idCashPoint;
        CStaticInoutOnceCashpoint.Caption := TCashPoint(TCashPoint.LoadObject(CashPointProxy, idCashPoint, False)).name;
        CStaticInoutOnceCategory.DataId := idProduct;
        CStaticInoutOnceCategory.Caption := TProduct(TProduct.LoadObject(ProductProxy, idProduct, False)).name;
        CStaticInOutOnceCurrencyAccount.DataId := idAccountCurrencyDef;
        CStaticInOutOnceCurrencyAccount.Caption := GCurrencyCache.GetIso(idAccountCurrencyDef);
        CStaticInOutOnceMovementCurrency.DataId := idMovementCurrencyDef;
        CStaticInOutOnceMovementCurrency.Caption := GCurrencyCache.GetIso(idMovementCurrencyDef);
        if idCurrencyRate <> CEmptyDataGid then begin
          CStaticInOutOnceRate.DataId := idCurrencyRate;
          CStaticInOutOnceRate.Caption := rateDescription;
        end;
        FOnceRateHelper := TCurrencyRateHelper.Create(currencyQuantity, currencyRate, rateDescription, idAccountCurrencyDef, idMovementCurrencyDef);
        CCurrEditInoutOnceMovement.Value := movementCash;
        CCurrEditInoutOnceMovement.SetCurrencyDef(idMovementCurrencyDef, GCurrencyCache.GetSymbol(idMovementCurrencyDef));
        CCurrEditInOutOnceAccount.Value := cash;
        CCurrEditInOutOnceAccount.SetCurrencyDef(idAccountCurrencyDef, GCurrencyCache.GetSymbol(idAccountCurrencyDef));
      end else begin
        CStaticInoutCyclicAccount.DataId := idAccount;
        CStaticInoutCyclicAccount.Caption := TAccount(TAccount.LoadObject(AccountProxy, idAccount, False)).name;
        CStaticInoutCyclicCashpoint.DataId := idCashPoint;
        CStaticInoutCyclicCashpoint.Caption := TCashPoint(TCashPoint.LoadObject(CashPointProxy, idCashPoint, False)).name;
        CStaticInoutCyclicCategory.DataId := idProduct;
        CStaticInoutCyclicCategory.Caption := TProduct(TProduct.LoadObject(ProductProxy, idProduct, False)).name;
        CStaticInoutCyclic.DataId := idPlannedDone;
        xD := TPlannedDone(TPlannedDone.LoadObject(PlannedDoneProxy, idPlannedDone, False));
        xM := TPlannedMovement(TPlannedMovement.LoadObject(PlannedMovementProxy, xD.idPlannedMovement, False));
        if movementType = COutMovement then begin
          CStaticInoutCyclic.Caption := xM.description + ' (p³atne do ' + DateToStr(xD.triggerDate) + ')';
        end else begin
          CStaticInoutCyclic.Caption := xM.description + ' (wp³yw do ' + DateToStr(xD.triggerDate) + ')'
        end;
        CStaticInOutCyclicCurrencyAccount.DataId := idAccountCurrencyDef;
        CStaticInOutCyclicCurrencyAccount.Caption := GCurrencyCache.GetIso(idAccountCurrencyDef);
        CStaticInOutCyclicMovementCurrency.DataId := idMovementCurrencyDef;
        CStaticInOutCyclicMovementCurrency.Caption := GCurrencyCache.GetIso(idMovementCurrencyDef);
        if idCurrencyRate <> CEmptyDataGid then begin
          CStaticInOutCyclicRate.DataId := idCurrencyRate;
          CStaticInOutCyclicRate.Caption := rateDescription;
        end;
        FCyclicRateHelper := TCurrencyRateHelper.Create(currencyQuantity, currencyRate, rateDescription, idAccountCurrencyDef, idMovementCurrencyDef);
        CCurrEditInoutCyclicMovement.Value := movementCash;
        CCurrEditInoutCyclicMovement.SetCurrencyDef(idMovementCurrencyDef, GCurrencyCache.GetSymbol(idMovementCurrencyDef));
        CCurrEditInOutCyclicAccount.Value := cash;
        CCurrEditInOutCyclicAccount.SetCurrencyDef(idAccountCurrencyDef, GCurrencyCache.GetSymbol(idAccountCurrencyDef));
      end;
      FbaseAccount := idAccount;
    end else if (movementType = CTransferMovement) then begin
      CStaticTransDestAccount.DataId := idAccount;
      CStaticTransDestAccount.Caption := TAccount(TAccount.LoadObject(AccountProxy, idAccount, False)).name;
      CStaticTransSourceAccount.DataId := idSourceAccount;
      CStaticTransSourceAccount.Caption := TAccount(TAccount.LoadObject(AccountProxy, idSourceAccount, False)).name;
      CStaticTransCurrencyDest.DataId := idAccountCurrencyDef;
      CStaticTransCurrencyDest.Caption := GCurrencyCache.GetIso(idAccountCurrencyDef);
      CStaticTransCurrencySource.DataId := idMovementCurrencyDef;
      CStaticTransCurrencySource.Caption := GCurrencyCache.GetIso(idMovementCurrencyDef);
      if idCurrencyRate <> CEmptyDataGid then begin
        CStaticTransRate.DataId := idCurrencyRate;
        CStaticTransRate.Caption := rateDescription;
      end;
      FTransferRateHelper := TCurrencyRateHelper.Create(currencyQuantity, currencyRate, rateDescription, idAccountCurrencyDef, idMovementCurrencyDef);
      CCurrEditTransMovement.Value := movementCash;
      CCurrEditTransMovement.SetCurrencyDef(idMovementCurrencyDef, GCurrencyCache.GetSymbol(idMovementCurrencyDef));
      CCurrEditTransAccount.Value := cash;
      CCurrEditTransAccount.SetCurrencyDef(idAccountCurrencyDef, GCurrencyCache.GetSymbol(idAccountCurrencyDef));
      FbaseAccount := idAccount;
      FsourceAccount := idSourceAccount;
    end;
    GDataProvider.RollbackTransaction;
    CDateTime.Value := regDate;
    SimpleRichText(description, RichEditDesc);
    FbaseList := idMovementList;
    UpdateCurrencyRates(False);
  end;
end;

function TCMovementForm.GetDataobjectClass: TDataObjectClass;
begin
  Result := TBaseMovement;
end;

procedure TCMovementForm.ReadValues;
var xI: Integer;
    xDone: TPlannedDone;
    xTrDate: TDateTime;
    xTrMove: TDataGid;
    xPos: Integer;
begin
  with TBaseMovement(Dataobject) do begin
    regDate := CDateTime.Value;
    description := RichEditDesc.Text;
    xI := ComboBoxType.ItemIndex;
    if (xI = 0) or (xI = 1) then begin
      movementType := IfThen(xI = 0, COutMovement, CInMovement);
      if CStaticInOutOnceRate.Enabled then begin
        idCurrencyRate := CStaticInOutOnceRate.DataId;
        rateDescription := FOnceRateHelper.desc;
        currencyQuantity := FOnceRateHelper.quantity;
        currencyRate := FOnceRateHelper.rate;
      end else begin
        idCurrencyRate := CEmptyDataGid;
        rateDescription := '';
        currencyQuantity := 1;
        currencyRate := 1;
      end;
      movementCash := CCurrEditInoutOnceMovement.Value;
      idAccountCurrencyDef := CStaticInOutOnceCurrencyAccount.DataId;
      idMovementCurrencyDef := CStaticInOutOnceMovementCurrency.DataId;
      cash := CCurrEditInOutOnceAccount.Value;
      idAccount := CStaticInoutOnceAccount.DataId;
      idSourceAccount := CEmptyDataGid;
      idCashPoint := CStaticInoutOnceCashpoint.DataId;
      idProduct := CStaticInoutOnceCategory.DataId;
      idPlannedDone := CEmptyDataGid;
    end else if (xI = 2) then begin
      movementType := CTransferMovement;
      if CStaticTransRate.Enabled then begin
        idCurrencyRate := CStaticTransRate.DataId;
        rateDescription := FTransferRateHelper.desc;
        currencyQuantity := FTransferRateHelper.quantity;
        currencyRate := FTransferRateHelper.rate;
      end else begin
        idCurrencyRate := CEmptyDataGid;
        rateDescription := '';
        currencyQuantity := 1;
        currencyRate := 1;
      end;
      movementCash := CCurrEditTransMovement.Value;
      idAccountCurrencyDef := CStaticTransCurrencyDest.DataId;
      idMovementCurrencyDef := CStaticTransCurrencySource.DataId;
      cash := CCurrEditTransAccount.Value;
      idAccount := CStaticTransDestAccount.DataId;
      idSourceAccount := CStaticTransSourceAccount.DataId;
      idCashPoint := CEmptyDataGid;
      idProduct := CEmptyDataGid;
      idPlannedDone := CEmptyDataGid;
    end else if (xI = 3) or (xI = 4) then begin
      movementType := IfThen(xI = 3, COutMovement, CInMovement);
      if CStaticInOutCyclicRate.Enabled then begin
        idCurrencyRate := CStaticInOutCyclicRate.DataId;
        rateDescription := FCyclicRateHelper.desc;
        currencyQuantity := FCyclicRateHelper.quantity;
        currencyRate := FCyclicRateHelper.rate;
      end else begin
        idCurrencyRate := CEmptyDataGid;
        rateDescription := '';
        currencyQuantity := 1;
        currencyRate := 1;
      end;
      movementCash := CCurrEditInoutCyclicMovement.Value;
      idAccountCurrencyDef := CStaticInOutCyclicCurrencyAccount.DataId;
      idMovementCurrencyDef := CStaticInOutCyclicMovementCurrency.DataId;
      cash := CCurrEditInOutCyclicAccount.Value;
      idAccount := CStaticInoutCyclicAccount.DataId;
      idSourceAccount := CEmptyDataGid;
      idCashPoint := CStaticInoutCyclicCashpoint.DataId;
      idProduct := CStaticInoutCyclicCategory.DataId;
      if Operation = coAdd then begin
        xPos := Pos('|', CStaticInoutCyclic.DataId);
        xTrMove := Copy(CStaticInoutCyclic.DataId, 1, xPos - 1);
        xTrDate := DatabaseToDatetime(Copy(CStaticInoutCyclic.DataId, xPos + 1, MaxInt));
        xDone := TPlannedDone.CreateObject(PlannedDoneProxy, False);
        xDone.idPlannedMovement := xTrMove;
        xDone.triggerDate := xTrDate;
        xDone.doneState := CDoneOperation;
        xDone.doneDate := regDate;
        xDone.description := description;
        xDone.cash := movementCash;
        idPlannedDone := xDone.id;
        xDone.idDoneCurrencyDef := idMovementCurrencyDef;
      end else begin
        xDone := TPlannedDone(TPlannedDone.LoadObject(PlannedDoneProxy, idPlannedDone, False));
        xDone.cash := movementCash;
        xDone.description := description;
        xDone.doneDate := regDate;
        xDone.idDoneCurrencyDef := idMovementCurrencyDef;
      end;
    end;
  end;
end;

function TCMovementForm.ChoosePlanned(var AId, AText: String): Boolean;
var xType: TBaseEnumeration;
begin
  if (ComboBoxType.ItemIndex = 3) then begin
    xType := COutProduct;
  end else begin
    xType := CInProduct;
  end;
  Result := TCFrameForm.ShowFrame(TCDoneFrame, AId, AText, TDoneFrameAdditionalData.Create(xType));
end;

procedure TCMovementForm.CStaticInoutCyclicGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChoosePlanned(ADataGid, AText);
end;

procedure TCMovementForm.CStaticInoutCyclicChanged(Sender: TObject);
var xId: TDataGid;
    xPos: Integer;
    xPlan: TPlannedMovement;
begin
  GDataProvider.BeginTransaction;
  xPos := Pos('|', CStaticInoutCyclic.DataId);
  xId := Copy(CStaticInoutCyclic.DataId, 1, xPos - 1);
  xPlan := TPlannedMovement(TPlannedMovement.LoadObject(PlannedMovementProxy, xId, False));
  CStaticInoutCyclicAccount.DataId := xPlan.idAccount;
  if xPlan.idAccount <> CEmptyDataGid then begin
    CStaticInoutCyclicAccount.Caption := TAccount(TAccount.LoadObject(AccountProxy, xPlan.idAccount, False)).name;
    CStaticInOutCyclicCurrencyAccount.DataId := TAccount.GetCurrencyDefinition(xPlan.idAccount);
    CStaticInOutCyclicCurrencyAccount.Caption := GCurrencyCache.GetIso(CStaticInOutCyclicCurrencyAccount.DataId);
    CCurrEditInOutCyclicAccount.SetCurrencyDef(CStaticInOutCyclicCurrencyAccount.DataId, GCurrencyCache.GetSymbol(CStaticInOutCyclicCurrencyAccount.DataId));
  end;
  CStaticInoutCyclicCategory.DataId := xPlan.idProduct;
  if xPlan.idProduct <> CEmptyDataGid then begin
    CStaticInoutCyclicCategory.Caption := TProduct(TProduct.LoadObject(ProductProxy, xPlan.idProduct, False)).name;
  end;
  CStaticInoutCyclicCashpoint.DataId := xPlan.idCashPoint;
  if xPlan.idCashPoint <> CEmptyDataGid then begin
    CStaticInoutCyclicCashpoint.Caption := TCashPoint(TCashPoint.LoadObject(CashPointProxy, xPlan.idCashPoint, False)).name;
  end;
  CCurrEditInoutCyclicMovement.Value := xPlan.cash;
  CStaticInOutCyclicMovementCurrency.DataId := xPlan.idMovementCurrencyDef;
  CStaticInOutCyclicMovementCurrency.Caption := GCurrencyCache.GetIso(xPlan.idMovementCurrencyDef);
  CCurrEditInoutCyclicMovement.SetCurrencyDef(xPlan.idMovementCurrencyDef, GCurrencyCache.GetSymbol(xPlan.idMovementCurrencyDef));
  GDataProvider.RollbackTransaction;
  UpdateDescription;
end;

constructor TMovementAdditionalData.Create(ATriggerDate: TDateTime; APlanned: TDataObject);
begin
  inherited Create;
  FtriggerDate := ATriggerDate;
  Fplanned := APlanned;
end;

procedure TCMovementForm.UpdateFrames(ADataGid: TDataGid; AMessage, AOption: Integer);
var xId: TDataGid;
    xI: Integer;
begin
  inherited UpdateFrames(ADataGid, AMessage, AOption);
  xI := ComboBoxType.ItemIndex;
  if (xI = 0) or (xI = 1) then begin
    xId := CStaticInoutOnceAccount.DataId;
    SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTEDITED, Integer(@xId), 0);
    if Operation = coEdit then begin
      if FbaseAccount <> xId then begin
        SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTEDITED, Integer(@FbaseAccount), 0);
      end;
    end;
  end else if (xI = 2) then begin
    xId := CStaticTransDestAccount.DataId;
    SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTEDITED, Integer(@xId), 0);
    if Operation = coEdit then begin
      if FbaseAccount <> xId then begin
        SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTEDITED, Integer(@FbaseAccount), 0);
      end;
    end;
    xId := CStaticTransSourceAccount.DataId;
    SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTEDITED, Integer(@xId), 0);
    if Operation = coEdit then begin
      if FsourceAccount <> xId then begin
        SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTEDITED, Integer(@FsourceAccount), 0);
      end;
    end;
  end else if (xI = 3) or (xI = 4) then begin
    xId := CStaticInoutCyclicAccount.DataId;
    SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTEDITED, Integer(@xId), 0);
    if Operation = coEdit then begin
      if FbaseAccount <> xId then begin
        SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTEDITED, Integer(@FbaseAccount), 0);
      end;
    end;
    SendMessageToFrames(TCDoneFrame, WM_DATAREFRESH, 0, 0);
  end;
  if FbaseList <> CEmptyDataGid then begin
    SendMessageToFrames(TCMovementFrame, WM_DATAOBJECTEDITED, Integer(@FBaseList), WMOPT_MOVEMENTLIST);
  end;
end;

function TCMovementForm.GetUpdateFrameOption: Integer;
begin
  Result := WMOPT_BASEMOVEMENT;
end;

function TCMovementForm.GetUpdateFrameClass: TCBaseFrameClass;
begin
  Result := TCMovementFrame;
end;

procedure TCMovementForm.ActionTemplateExecute(Sender: TObject);
var xPattern: String;
begin
  if EditDescPattern(CDescPatternsKeys[0][ComboBoxType.ItemIndex], xPattern) then begin
    UpdateDescription;
  end;
end;

procedure TCMovementForm.ActionAddExecute(Sender: TObject);
var xData: TObjectList;
begin
  xData := TObjectList.Create(False);
  xData.Add(GBaseTemlatesList);
  xData.Add(GBaseMovementTemplatesList);
  EditAddTemplate(xData, Self, RichEditDesc, True);
  xData.Free;
end;

procedure TCMovementForm.CDateTimeChanged(Sender: TObject);
begin
  UpdateDescription;
end;

function TCMovementForm.ExpandTemplate(ATemplate: String): String;
begin
  Result := inherited ExpandTemplate(ATemplate);
  if ATemplate = '@dataoperacji@' then begin
    Result := GetFormattedDate(CDateTime.Value, 'yyyy-MM-dd');
  end else if ATemplate = '@rodzaj@' then begin
    Result := ComboBoxType.Text;
  end else if ATemplate = '@kontozrodlowe@' then begin
    Result := '<konto Ÿród³owe>';
    if (ComboBoxType.ItemIndex = 0) or (ComboBoxType.ItemIndex = 1) then begin
      if CStaticInoutOnceAccount.DataId <> CEmptyDataGid then begin
        Result := CStaticInoutOnceAccount.Caption;
      end;
    end else if (ComboBoxType.ItemIndex = 3) or (ComboBoxType.ItemIndex = 4) then begin
      if CStaticInoutCyclicAccount.DataId <> CEmptyDataGid then begin
        Result := CStaticInoutCyclicAccount.Caption;
      end;
    end else if (ComboBoxType.ItemIndex = 2) then begin
      if CStaticTransSourceAccount.DataId <> CEmptyDataGid then begin
        Result := CStaticTransSourceAccount.Caption;
      end;
    end;
  end else if ATemplate = '@kontodocelowe@' then begin
    Result := '<konto docelowe>';
    if (ComboBoxType.ItemIndex = 2) then begin
      if CStaticTransDestAccount.DataId <> CEmptyDataGid then begin
        Result := CStaticTransDestAccount.Caption;
      end;
    end;
  end else if ATemplate = '@kategoria@' then begin
    Result := '<kategoria>';
    if (ComboBoxType.ItemIndex = 0) or (ComboBoxType.ItemIndex = 1) then begin
      if CStaticInoutOnceCategory.DataId <> CEmptyDataGid then begin
        Result := CStaticInoutOnceCategory.Caption;
      end;
    end else if (ComboBoxType.ItemIndex = 3) or (ComboBoxType.ItemIndex = 4) then begin
      if CStaticInoutCyclicCategory.DataId <> CEmptyDataGid then begin
        Result := CStaticInoutCyclicCategory.Caption;
      end;
    end;
  end else if ATemplate = '@pelnakategoria@' then begin
    Result := '<pelnakategoria>';
    if (ComboBoxType.ItemIndex = 0) or (ComboBoxType.ItemIndex = 1) then begin
      if CStaticInoutOnceCategory.DataId <> CEmptyDataGid then begin
        Result := TProduct(TProduct.LoadObject(ProductProxy, CStaticInoutOnceCategory.DataId, False)).treeDesc;
      end;
    end else if (ComboBoxType.ItemIndex = 3) or (ComboBoxType.ItemIndex = 4) then begin
      if CStaticInoutCyclicCategory.DataId <> CEmptyDataGid then begin
        TProduct(TProduct.LoadObject(ProductProxy, CStaticInoutCyclicCategory.DataId, False)).treeDesc;
      end;
    end;
  end else if ATemplate = '@kontrahent@' then begin
    Result := '<kontrahent>';
    if (ComboBoxType.ItemIndex = 0) or (ComboBoxType.ItemIndex = 1) then begin
      if CStaticInoutOnceCashpoint.DataId <> CEmptyDataGid then begin
        Result := CStaticInoutOnceCashpoint.Caption;
      end;
    end else if (ComboBoxType.ItemIndex = 3) or (ComboBoxType.ItemIndex = 4) then begin
      if CStaticInoutCyclicCashpoint.DataId <> CEmptyDataGid then begin
        Result := CStaticInoutCyclicCashpoint.Caption;
      end;
    end;
  end;
end;

procedure TCMovementForm.ComboBoxTemplateChange(Sender: TObject);
begin
  UpdateDescription;
end;

procedure TCMovementForm.CStaticInOutOnceCurrencyAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseCurrencyDef(ADataGid, AText);
end;

function TCMovementForm.ChooseCurrencyDef(var AId, AText: String): Boolean;
begin
  Result := TCFrameForm.ShowFrame(TCCurrencydefFrame, AId, AText);
end;

procedure TCMovementForm.CStaticCurrencyCyclicGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseCurrencyDef(ADataGid, AText);
end;

procedure TCMovementForm.CStaticCurrencyTransGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseCurrencyDef(ADataGid, AText);
end;

procedure TCMovementForm.CStaticInOutOnceMovementCurrencyChanged(Sender: TObject);
begin
  CStaticInOutOnceRate.DataId := CEmptyDataGid;
  UpdateCurrencyRates;
  CCurrEditInoutOnceMovement.SetCurrencyDef(CStaticInOutOnceMovementCurrency.DataId, GCurrencyCache.GetSymbol(CStaticInOutOnceMovementCurrency.DataId));
end;

procedure TCMovementForm.UpdateCurrencyRates(AUpdateCurEdit: Boolean = True);
var xI: Integer;
    xRate: TCurrencyRate;
begin
  xI := ComboBoxType.ItemIndex;
  if (xI = 0) or (xI = 1) then begin
    CStaticInOutOnceRate.Enabled :=
      (CStaticInOutOnceCurrencyAccount.DataId <> CStaticInOutOnceMovementCurrency.DataId) and
      (CStaticInOutOnceCurrencyAccount.DataId <> CEmptyDataGid) and
      (CStaticInOutOnceMovementCurrency.DataId <> CEmptyDataGid);
    CStaticInOutOnceRate.HotTrack := CStaticInOutOnceRate.Enabled;
    Label22.Enabled := CStaticInOutOnceRate.Enabled;
    Label17.Enabled := CStaticInOutOnceRate.Enabled;
    Label21.Enabled := CStaticInOutOnceRate.Enabled;
    if CStaticInOutOnceRate.Enabled then begin
      GDataProvider.BeginTransaction;
      xRate := TAccountCurrencyRule.FindRateByRule(GWorkDate, IfThen(xI = 0, COutMovement, CInMovement), CStaticInoutOnceAccount.DataId, CStaticInOutOnceMovementCurrency.DataId);
      if xRate <> Nil then begin
        if FOnceRateHelper = Nil then begin
          FOnceRateHelper := TCurrencyRateHelper.Create(0, 0, '', '', '');
        end;
        FOnceRateHelper.Assign(xRate.quantity, xRate.rate, xRate.description, xRate.idSourceCurrencyDef, xRate.idTargetCurrencyDef);
        CStaticInOutOnceRate.DataId := xRate.id;
        CStaticInOutOnceRate.Caption := xRate.description;
      end;
      GDataProvider.RollbackTransaction;
    end;
    if AUpdateCurEdit then begin
      UpdateAccountCurEdit(CStaticInOutOnceRate, CCurrEditInoutOnceMovement, CCurrEditInoutOnceAccount, FOnceRateHelper);
    end;
  end else if (xI = 2) then begin
    CStaticTransRate.Enabled :=
      (CStaticTransCurrencySource.DataId <> CStaticTransCurrencyDest.DataId) and
      (CStaticTransCurrencySource.DataId <> CEmptyDataGid) and
      (CStaticTransCurrencyDest.DataId <> CEmptyDataGid);
    CStaticTransRate.HotTrack := CStaticTransRate.Enabled;
    Label8.Enabled := CStaticTransRate.Enabled;
    Label26.Enabled := CStaticTransRate.Enabled;
    Label27.Enabled := CStaticTransRate.Enabled;
    Label28.Enabled := CStaticTransRate.Enabled;
    if CStaticTransRate.Enabled then begin
      GDataProvider.BeginTransaction;
      xRate := TAccountCurrencyRule.FindRateByRule(GWorkDate, CTransferMovement, CStaticTransSourceAccount.DataId, CStaticTransCurrencyDest.DataId);
      if xRate <> Nil then begin
        if FTransferRateHelper = Nil then begin
          FTransferRateHelper := TCurrencyRateHelper.Create(0, 0, '', '', '');
        end;
        FTransferRateHelper.Assign(xRate.quantity, xRate.rate, xRate.description, xRate.idSourceCurrencyDef, xRate.idTargetCurrencyDef);
        CStaticTransRate.DataId := xRate.id;
        CStaticTransRate.Caption := xRate.description;
      end;
      GDataProvider.RollbackTransaction;
    end;


    if AUpdateCurEdit then begin
      UpdateAccountCurEdit(CStaticTransRate, CCurrEditTransMovement, CCurrEditTransAccount, FTransferRateHelper);
    end;
  end else if (xI = 3) or (xI = 4) then begin
    CStaticInOutCyclicRate.Enabled :=
      (CStaticInOutCyclicCurrencyAccount.DataId <> CStaticInOutCyclicMovementCurrency.DataId) and
      (CStaticInOutCyclicCurrencyAccount.DataId <> CEmptyDataGid) and
      (CStaticInOutCyclicMovementCurrency.DataId <> CEmptyDataGid);
    CStaticInOutCyclicRate.HotTrack := CStaticInOutCyclicRate.Enabled;
    Label23.Enabled := CStaticInOutCyclicRate.Enabled;
    Label24.Enabled := CStaticInOutCyclicRate.Enabled;
    Label25.Enabled := CStaticInOutCyclicRate.Enabled;
    if AUpdateCurEdit then begin
      UpdateAccountCurEdit(CStaticInOutCyclicRate, CCurrEditInoutCyclicMovement, CCurrEditInoutCyclicAccount, FCyclicRateHelper);
    end;
  end;
end;

procedure TCMovementForm.CStaticInoutOnceCategoryChanged(Sender: TObject);
begin
  UpdateDescription;
end;

procedure TCMovementForm.CStaticInoutOnceCashpointChanged(Sender: TObject);
begin
  UpdateDescription;
end;

procedure TCMovementForm.CStaticInoutCyclicCashpointChanged(Sender: TObject);
begin
  UpdateDescription;
end;

procedure TCMovementForm.CStaticInoutCyclicCategoryChanged(Sender: TObject);
begin
  UpdateDescription;
end;

procedure TCMovementForm.CStaticInoutCyclicAccountChanged(Sender: TObject);
begin
  CStaticInOutCyclicRate.DataId := CEmptyDataGid;
  UpdateAccountCurDef(CStaticInoutCyclicAccount.DataId, CStaticInOutCyclicCurrencyAccount, CCurrEditInOutCyclicAccount);
  UpdateDescription;
  UpdateCurrencyRates;
end;

procedure TCMovementForm.CStaticTransSourceAccountChanged(Sender: TObject);
begin
  CStaticTransRate.DataId := CEmptyDataGid;
  UpdateAccountCurDef(CStaticTransSourceAccount.DataId, CStaticTransCurrencySource, CCurrEditTransMovement);
  UpdateDescription;
  UpdateCurrencyRates;
end;

procedure TCMovementForm.CStaticTransDestAccountChanged(Sender: TObject);
begin
  CStaticTransRate.DataId := CEmptyDataGid;
  UpdateAccountCurDef(CStaticTransDestAccount.DataId, CStaticTransCurrencyDest, CCurrEditTransAccount);
  UpdateDescription;
  UpdateCurrencyRates;
end;

procedure TCMovementForm.CStaticInOutCyclicMovementCurrencyChanged(Sender: TObject);
begin
  CStaticInOutCyclicRate.DataId := CEmptyDataGid;
  UpdateCurrencyRates;
  CCurrEditInoutCyclicMovement.SetCurrencyDef(CStaticInOutCyclicMovementCurrency.DataId, GCurrencyCache.GetSymbol(CStaticInOutCyclicMovementCurrency.DataId));
end;

procedure TCMovementForm.CCurrEditTransMovementChange(Sender: TObject);
begin
  UpdateAccountCurEdit(CStaticTransRate, CCurrEditTransMovement, CCurrEditTransAccount, FTransferRateHelper);
end;

procedure TCMovementForm.UpdateAccountCurEdit(ARate: TCStatic; ASourceEdit, ATargetEdit: TCCurrEdit; AHelper: TCurrencyRateHelper);
begin
  if ASourceEdit.CurrencyId <> ATargetEdit.CurrencyId then begin
    if ARate.DataId <> CEmptyDataGid then begin
      if AHelper <> Nil then begin
        ATargetEdit.Value := AHelper.ExchangeCurrency(ASourceEdit.Value, ASourceEdit.CurrencyId, ATargetEdit.CurrencyId);
      end else begin
        ATargetEdit.Value := 0;
      end;
    end else begin
      ATargetEdit.Value := 0;
    end;
  end else begin
    ATargetEdit.Value := ASourceEdit.Value;
  end;
end;

procedure TCMovementForm.CCurrEditInoutOnceMovementChange(Sender: TObject);
begin
  UpdateAccountCurEdit(CStaticInOutOnceRate, CCurrEditInoutOnceMovement, CCurrEditInoutOnceAccount, FOnceRateHelper);
end;

procedure TCMovementForm.CCurrEditInoutCyclicMovementChange(Sender: TObject);
begin
  UpdateAccountCurEdit(CStaticInOutCyclicRate, CCurrEditInoutCyclicMovement, CCurrEditInoutCyclicAccount, FCyclicRateHelper);
end;

destructor TCMovementForm.Destroy;
begin
  if FOnceRateHelper <> Nil then begin
    FOnceRateHelper.Free;
  end;
  if FCyclicRateHelper <> Nil then begin
    FCyclicRateHelper.Free;
  end;
  if FTransferRateHelper <> Nil then begin
    FTransferRateHelper.Free;
  end;
  inherited Destroy;
end;

function TCMovementForm.ChooseCurrencyRate(var AId, AText: String; var AHelper: TCurrencyRateHelper; ASourceId, ATargetId: TDataGid): Boolean;
var xCurrencyRate: TCurrencyRate;
begin
  Result := TCFrameForm.ShowFrame(TCCurrencyRateFrame, AId, AText, TRateFrameAdditionalData.CreateRateData(ASourceId, ATargetId));
  if Result then begin
    xCurrencyRate := TCurrencyRate(TCurrencyRate.LoadObject(CurrencyRateProxy, AId, False));
    if AHelper = Nil then begin
      AHelper := TCurrencyRateHelper.Create(xCurrencyRate.quantity, xCurrencyRate.rate, xCurrencyRate.description, xCurrencyRate.idSourceCurrencyDef, xCurrencyRate.idTargetCurrencyDef);
    end else begin
      AHelper.Assign(xCurrencyRate.quantity, xCurrencyRate.rate, xCurrencyRate.description, xCurrencyRate.idSourceCurrencyDef, xCurrencyRate.idTargetCurrencyDef);
    end;
  end;
end;

procedure TCMovementForm.CStaticInOutOnceRateGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseCurrencyRate(ADataGid, AText, FOnceRateHelper, CStaticInOutOnceCurrencyAccount.DataId, CStaticInOutOnceMovementCurrency.DataId);
end;

procedure TCMovementForm.CStaticInOutOnceRateChanged(Sender: TObject);
begin
  UpdateCurrencyRates;
end;

procedure TCMovementForm.CStaticInOutCyclicRateGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseCurrencyRate(ADataGid, AText, FCyclicRateHelper, CStaticInOutCyclicCurrencyAccount.DataId, CStaticInOutCyclicMovementCurrency.DataId);
end;

procedure TCMovementForm.CStaticInOutCyclicRateChanged(Sender: TObject);
begin
  UpdateCurrencyRates;
end;

procedure TCMovementForm.CStaticTransRateGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseCurrencyRate(ADataGid, AText, FTransferRateHelper, CStaticTransCurrencyDest.DataId, CStaticTransCurrencySource.DataId);
end;

procedure TCMovementForm.CStaticTransRateChanged(Sender: TObject);
begin
  UpdateCurrencyRates;
end;

procedure TCMovementForm.UpdateAccountCurDef(AAccountId: TDataGid; AStatic: TCStatic; ACurEdit: TCCurrEdit);
var xCurrencyId: TDataGid;
begin
  if AAccountId <> CEmptyDataGid then begin
    xCurrencyId := TAccount.GetCurrencyDefinition(AAccountId);
    AStatic.DataId := xCurrencyId;
    AStatic.Caption := GCurrencyCache.GetIso(xCurrencyId);
    ACurEdit.SetCurrencyDef(xCurrencyId, GCurrencyCache.GetSymbol(xCurrencyId));
  end else begin
    AStatic.DataId := CEmptyDataGid;
    ACurEdit.SetCurrencyDef(CEmptyDataGid, '');
  end;
end;

end.
