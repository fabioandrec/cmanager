unit CDepositInvestmentFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  CComponents, CDatabase, CBaseFrameUnit, ActnList, ActnMan, CImageListsUnit,
  Contnrs, CDataObjects, XPStyleActnCtrls, Math, CDeposits;

type
  TCDepositInvestmentForm = class(TCDataobjectForm)
    GroupBox1: TGroupBox;
    Label3: TLabel;
    GroupBox2: TGroupBox;
    RichEditDesc: TCRichEdit;
    GroupBox3: TGroupBox;
    ActionManager: TActionManager;
    ActionAdd: TAction;
    CButton1: TCButton;
    ActionTemplate: TAction;
    CButton2: TCButton;
    ComboBoxTemplate: TComboBox;
    CDateTime: TCDateTime;
    Label1: TLabel;
    CStaticCashpoint: TCStatic;
    Label2: TLabel;
    EditName: TEdit;
    Label10: TLabel;
    CStaticCurrency: TCStatic;
    Label4: TLabel;
    CCurrEditRate: TCCurrEdit;
    Label6: TLabel;
    CIntEditPeriodCount: TCIntEdit;
    ComboBoxPeriodType: TComboBox;
    ComboBoxPeriodAction: TComboBox;
    Label7: TLabel;
    Label8: TLabel;
    ComboBoxDueMode: TComboBox;
    Label9: TLabel;
    CIntEditDueCount: TCIntEdit;
    ComboBoxDueType: TComboBox;
    Label11: TLabel;
    ComboBoxDueAction: TComboBox;
    Label15: TLabel;
    CCurrEditActualCash: TCCurrEdit;
    Label5: TLabel;
    CStaticFuture: TCStatic;
    Label12: TLabel;
    ComboBoxType: TComboBox;
    Label14: TLabel;
    CStaticAccount: TCStatic;
    Label17: TLabel;
    CStaticAccountCurrency: TCStatic;
    Label22: TLabel;
    CStaticCurrencyRate: TCStatic;
    Label21: TLabel;
    CCurrEditAccount: TCCurrEdit;
    Label13: TLabel;
    CStaticCategory: TCStatic;
    LabelState: TLabel;
    ComboBoxDepositState: TComboBox;
    Label16: TLabel;
    CCurrEditNoncapitalized: TCCurrEdit;
    CheckBoxBelka: TCheckBox;
    CCurrEditTaxRate: TCCurrEdit;
    procedure CDateTimeChanged(Sender: TObject);
    procedure ComboBoxPeriodTypeChange(Sender: TObject);
    procedure CIntEditPeriodCountChange(Sender: TObject);
    procedure ComboBoxDueModeChange(Sender: TObject);
    procedure CIntEditDueCountChange(Sender: TObject);
    procedure ComboBoxDueTypeChange(Sender: TObject);
    procedure CStaticCurrencyGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticCurrencyChanged(Sender: TObject);
    procedure CStaticAccountChanged(Sender: TObject);
    procedure CStaticAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticCashpointChanged(Sender: TObject);
    procedure CStaticCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure ActionAddExecute(Sender: TObject);
    procedure ActionTemplateExecute(Sender: TObject);
    procedure EditNameChange(Sender: TObject);
    procedure ComboBoxTemplateChange(Sender: TObject);
    procedure CStaticCategoryChanged(Sender: TObject);
    procedure CStaticCategoryGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure ComboBoxTypeChange(Sender: TObject);
    procedure CStaticCurrencyRateGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CCurrEditActualCashChange(Sender: TObject);
    procedure CStaticCurrencyRateChanged(Sender: TObject);
    procedure CCurrEditRateChange(Sender: TObject);
    procedure CStaticFutureGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CheckBoxBelkaClick(Sender: TObject);
    procedure CCurrEditTaxRateChange(Sender: TObject);
  private
    FDeposit: TDeposit;
    FPeriodEndDate: TDateTime;
    FDueEndDate: TDateTime;
    FRateHelper: TCurrencyRateHelper;
    procedure UpdateEndPeriodDatetime;
    procedure UpdateEndCapitalisationDatetime;
    procedure UpdateDescription;
    procedure UpdateCurrencyRates(AUpdateCurEdit: Boolean = True);
    procedure UpdateAccountCurEdit(ARate: TCStatic; ASourceEdit, ATargetEdit: TCCurrEdit; AHelper: TCurrencyRateHelper);
    procedure UpdateFuture;
    function GetPeriodType: TBaseEnumeration;
    function GetDueType: TBaseEnumeration;
    procedure SetDueType(const Value: TBaseEnumeration);
    procedure SetPeriodType(const Value: TBaseEnumeration);
  protected
    procedure ReadValues; override;
    procedure InitializeForm; override;
    function CanAccept: Boolean; override;
    function GetDataobjectClass: TDataObjectClass; override;
    function GetUpdateFrameClass: TCBaseFrameClass; override;
    procedure AfterCommitData; override;
    procedure EndFilling; override;
    procedure FillForm; override;
    function CanModifyValues: Boolean; override;
  public
    property formPeriodType: TBaseEnumeration read GetPeriodType write SetPeriodType;
    property formDueType: TBaseEnumeration read GetDueType write SetDueType;
    function ExpandTemplate(ATemplate: String): String; override;
    destructor Destroy; override;
  end;

implementation

uses CConsts, CConfigFormUnit, CFrameFormUnit, CCurrencydefFrameUnit,
  CAccountsFrameUnit, CCashpointFormUnit, CCashpointsFrameUnit, CTemplates,
  CDescpatternFormUnit, CPreferences, CRichtext, CTools, CInfoFormUnit,
  CDepositInvestmentFrameUnit, CCurrencyRateFrameUnit, CMovementFrameUnit,
  CSurpassedFormUnit, CProductsFrameUnit, StrUtils,
  CDepositCalculatorFormUnit, CDatatools;

{$R *.dfm}

function TCDepositInvestmentForm.GetPeriodType: TBaseEnumeration;
begin
  if ComboBoxPeriodType.ItemIndex = 0 then begin
    Result := CDepositTypeDay;
  end else if ComboBoxPeriodType.ItemIndex = 1 then begin
    Result := CDepositTypeWeek;
  end else if ComboBoxPeriodType.ItemIndex = 2 then begin
    Result := CDepositTypeMonth;
  end else begin
    Result := CDepositTypeYear;
  end;
end;

procedure TCDepositInvestmentForm.InitializeForm;
begin
  inherited InitializeForm;
  FDeposit := TDeposit.Create;
  FRateHelper := nil;
  CDateTime.Value := Now;
  CStaticCurrency.DataId := GDefaultCurrencyId;
  CStaticCurrency.Caption := TCurrencyDef(TCurrencyDef.LoadObject(CurrencyDefProxy, GDefaultCurrencyId, False)).GetElementText;
  CCurrEditActualCash.SetCurrencyDef(GDefaultCurrencyId, GCurrencyCache.GetSymbol(GDefaultCurrencyId));
  CCurrEditAccount.SetCurrencyDef(CEmptyDataGid, '');
  LabelState.Visible := False;
  Label16.Visible := Operation = coEdit;
  CCurrEditNoncapitalized.Visible := Operation = coEdit;
  ComboBoxDepositState.Visible := False;
  ComboBoxDueModeChange(ComboBoxDueMode);
  ComboBoxTypeChange(ComboBoxType);
  UpdateEndPeriodDatetime;
  UpdateEndCapitalisationDatetime;
  UpdateFuture;
end;

procedure TCDepositInvestmentForm.ReadValues;
begin
  inherited ReadValues;
  with TDepositInvestment(Dataobject) do begin
    name := EditName.Text;
    description := RichEditDesc.Text;
    idCashPoint := CStaticCashpoint.DataId;
    cash := CCurrEditActualCash.Value;
    interestRate := CCurrEditRate.Value;
    if Operation = coAdd then begin
      depositState := CDepositInvestmentActive;
      idCurrencyDef := CStaticCurrency.DataId;
      periodCount := CIntEditPeriodCount.Value;
      dueCount := CIntEditDueCount.Value;
      dueStartDate := CDateTime.Value;
      periodStartDate := CDateTime.Value;
      dueEndDate := FDueEndDate;
      periodEndDate := FPeriodEndDate;
      dueType := formDueType;
      noncapitalizedInterest := CCurrEditNoncapitalized.Value;
      taxRate := CCurrEditTaxRate.Value;
      calcTax := CheckBoxBelka.Checked;
      if ComboBoxDueAction.ItemIndex = 0 then begin
        dueAction := CDepositDueActionAutoCapitalisation;
      end else begin
        dueAction := CDepositDueActionLeaveUncapitalised;
      end;
      periodType := formPeriodType;
      if ComboBoxPeriodAction.ItemIndex = 1 then begin
        periodAction := CDepositPeriodActionAutoRenew;
      end else begin
        periodAction := CDepositPeriodActionChangeInactive;
      end;
    end;
  end;
end;

procedure TCDepositInvestmentForm.UpdateEndCapitalisationDatetime;
var xNextDue: TDateTime;
begin
  if ComboBoxDueMode.ItemIndex = 0 then begin
    xNextDue := FPeriodEndDate;
  end else begin
    xNextDue := TDepositInvestment.EndDueDatetime(CDateTime.Value, CIntEditDueCount.Value, formDueType);
  end;
  FDueEndDate := xNextDue;
end;

procedure TCDepositInvestmentForm.UpdateEndPeriodDatetime;
begin
  FPeriodEndDate := TDepositInvestment.EndPeriodDatetime(CDateTime.Value, CIntEditPeriodCount.Value, formPeriodType)
end;

procedure TCDepositInvestmentForm.CDateTimeChanged(Sender: TObject);
begin
  UpdateEndPeriodDatetime;
  UpdateEndCapitalisationDatetime;
  UpdateDescription;
  UpdateFuture;
end;

procedure TCDepositInvestmentForm.UpdateDescription;
var xDesc: String;
begin
  if ComboBoxTemplate.ItemIndex = 1 then begin
    xDesc := GDescPatterns.GetPattern(CDescPatternsKeys[9][0], '');
    if xDesc <> '' then begin
      xDesc := GBaseTemlatesList.ExpandTemplates(xDesc, Self);
      xDesc := GDepositInvestmentTemplatesList.ExpandTemplates(xDesc, Self);
      SimpleRichText(xDesc, RichEditDesc);
    end;
  end;
end;

procedure TCDepositInvestmentForm.ComboBoxPeriodTypeChange(Sender: TObject);
begin
  UpdateEndPeriodDatetime;
  UpdateEndCapitalisationDatetime;
  UpdateDescription;
  UpdateFuture;
end;

procedure TCDepositInvestmentForm.CIntEditPeriodCountChange(Sender: TObject);
begin
  UpdateEndPeriodDatetime;
  UpdateEndCapitalisationDatetime;
  UpdateDescription;
  UpdateFuture;
end;

procedure TCDepositInvestmentForm.ComboBoxDueModeChange(Sender: TObject);
begin
  Label9.Enabled := (ComboBoxDueMode.ItemIndex = 1) and (Operation = coAdd);
  CIntEditDueCount.Enabled := (ComboBoxDueMode.ItemIndex = 1) and (Operation = coAdd);
  ComboBoxDueType.Enabled := (ComboBoxDueMode.ItemIndex = 1) and (Operation = coAdd);
  UpdateEndCapitalisationDatetime;
  UpdateDescription;
  UpdateFuture;
end;

procedure TCDepositInvestmentForm.CIntEditDueCountChange(Sender: TObject);
begin
  UpdateEndCapitalisationDatetime;
  UpdateDescription;
  UpdateFuture;
end;

procedure TCDepositInvestmentForm.ComboBoxDueTypeChange(Sender: TObject);
begin
  UpdateEndCapitalisationDatetime;
  UpdateDescription;
  UpdateFuture;
end;

function TCDepositInvestmentForm.GetDueType: TBaseEnumeration;
begin
  if ComboBoxDueMode.ItemIndex = 0 then begin
    Result := CDepositDueTypeOnDepositEnd;
  end else begin
    if ComboBoxDueType.ItemIndex = 0 then begin
      Result := CDepositTypeDay;
    end else if ComboBoxDueType.ItemIndex = 1 then begin
      Result := CDepositTypeWeek;
    end else if ComboBoxDueType.ItemIndex = 2 then begin
      Result := CDepositTypeMonth;
    end else begin
      Result := CDepositTypeYear;
    end;
  end;
end;

procedure TCDepositInvestmentForm.CStaticCurrencyGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCCurrencydefFrame, ADataGid, AText);
end;

procedure TCDepositInvestmentForm.CStaticCurrencyChanged(Sender: TObject);
begin
  CCurrEditActualCash.SetCurrencyDef(CStaticCurrency.DataId, GCurrencyCache.GetSymbol(CStaticCurrency.DataId));
  UpdateDescription;
  UpdateFuture;
end;

procedure TCDepositInvestmentForm.CStaticAccountChanged(Sender: TObject);
var xCurrencyId: TDataGid;
begin
  if CStaticAccount.DataId <> CEmptyDataGid then begin
    xCurrencyId := TAccount.GetCurrencyDefinition(CStaticAccount.DataId);
    CStaticAccountCurrency.DataId := xCurrencyId;
    CStaticAccountCurrency.Caption := GCurrencyCache.GetIso(xCurrencyId);
    CCurrEditAccount.SetCurrencyDef(xCurrencyId, GCurrencyCache.GetSymbol(xCurrencyId));
  end else begin
    CStaticAccountCurrency.DataId := CEmptyDataGid;
    CCurrEditAccount.SetCurrencyDef(CEmptyDataGid, '');
  end;
  CStaticCurrencyRate.DataId := CEmptyDataGid;
  UpdateCurrencyRates;
  UpdateDescription;
end;

procedure TCDepositInvestmentForm.CStaticAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCAccountsFrame, ADataGid, AText);
end;

procedure TCDepositInvestmentForm.CStaticCashpointChanged(Sender: TObject);
begin
  UpdateDescription;
end;

procedure TCDepositInvestmentForm.CStaticCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCCashpointsFrame, ADataGid, AText);
end;

procedure TCDepositInvestmentForm.ActionAddExecute(Sender: TObject);
var xData: TObjectList;
begin
  xData := TObjectList.Create(False);
  xData.Add(GBaseTemlatesList);
  xData.Add(GDepositInvestmentTemplatesList);
  EditAddTemplate(xData, Self, RichEditDesc, True);
  xData.Free;
end;

procedure TCDepositInvestmentForm.ActionTemplateExecute(Sender: TObject);
var xPattern: String;
begin
  if EditDescPattern(CDescPatternsKeys[9][0], xPattern) then begin
    UpdateDescription;
  end;
end;

function TCDepositInvestmentForm.ExpandTemplate(ATemplate: String): String;
begin
  Result := inherited ExpandTemplate(ATemplate);
  if ATemplate = '@data@' then begin
    Result := GetFormattedDate(CDateTime.Value, 'yyyy-MM-dd');
  end else if ATemplate = '@stan@' then begin
    Result := 'Aktywna';
  end else if ATemplate = '@operacja@' then begin
    Result := ComboBoxType.Text;
  end else if ATemplate = '@nazwa@' then begin
    if EditName.Text = '' then begin
      Result := '<nazwa lokaty>';
    end else begin
      Result := EditName.Text;
    end;
  end else if ATemplate = '@konto@' then begin
    Result := '<konto stowarzyszone>';
    if CStaticAccount.DataId <> CEmptyDataGid then begin
      Result := CStaticAccount.Caption;
    end;
  end else if ATemplate = '@kontrahent@' then begin
    Result := '<prowadz¹cy lokatê>';
    if CStaticCashpoint.DataId <> CEmptyDataGid then begin
      Result := CStaticCashpoint.Caption;
    end;
  end else if ATemplate = '@kategoria@' then begin
    Result := '<kategoria>';
    if CStaticCategory.DataId <> CEmptyDataGid then begin
      Result := CStaticCategory.Caption;
    end;
  end else if ATemplate = '@pelnakategoria@' then begin
    Result := '<pelnakategoria>';
    if CStaticCategory.DataId <> CEmptyDataGid then begin
      GDataProvider.BeginTransaction;
      Result := TProduct(TProduct.LoadObject(ProductProxy, CStaticCategory.DataId, False)).treeDesc;
      GDataProvider.RollbackTransaction;
    end;
  end else if ATemplate = '@isowaluty@' then begin
    Result := '<iso waluty lokaty>';
    if CStaticCurrency.DataId <> CEmptyDataGid then begin
      Result := GCurrencyCache.GetIso(CStaticCurrency.DataId);
    end;
  end else if ATemplate = '@symbolwaluty@' then begin
    Result := '<symbol waluty lokaty>';
    if CStaticCurrency.DataId <> CEmptyDataGid then begin
      Result := GCurrencyCache.GetSymbol(CStaticCurrency.DataId);
    end;
  end else if ATemplate = '@iloscOkres@' then begin
    Result := IntToStr(CIntEditPeriodCount.Value);
  end else if ATemplate = '@typOkres@' then begin
    Result := ComboBoxPeriodType.Text;
  end else if ATemplate = '@iloscOdsetki@' then begin
    Result := IntToStr(CIntEditDueCount.Value);
  end else if ATemplate = '@typOdsetki@' then begin
    if ComboBoxDueMode.ItemIndex = 0 then begin
      Result := ComboBoxDueMode.Text;
    end else begin
      Result := ComboBoxDueType.Text;
    end;
  end;
end;

procedure TCDepositInvestmentForm.EditNameChange(Sender: TObject);
begin
  UpdateDescription;
end;

function TCDepositInvestmentForm.CanAccept: Boolean;
var xPrevCash: Currency;
begin
  Result := inherited CanAccept;
  if Trim(EditName.Text) = '' then begin
    Result := False;
    ShowInfo(itError, 'Nazwa lokaty nie mo¿e byæ pusta', '');
    EditName.SetFocus;
  end else if CStaticCashpoint.DataId = CEmptyDataGid then begin
    Result := False;
    if ShowInfo(itQuestion, 'Nie wybrano kontrahenta prowadz¹cego lokatê. Czy wyœwietliæ listê teraz ?', '') then begin
      CStaticCashpoint.DoGetDataId;
    end;
  end else if CStaticCurrency.DataId = CEmptyDataGid then begin
    Result := False;
    if ShowInfo(itQuestion, 'Nie wybrano waluty lokaty. Czy wyœwietliæ listê teraz ?', '') then begin
      CStaticCurrency.DoGetDataId;
    end;
  end else if ComboBoxDueMode.ItemIndex <> 0 then begin
    if FDueEndDate > FPeriodEndDate then begin
      Result := False;
      ShowInfo(itError, 'Okres naliczania odsetek nie byæ wiêkszy od czasu trwania lokaty', '');
      ComboBoxDueType.SetFocus;
    end;
  end else if (CStaticCurrencyRate.DataId = CEmptyDataGid) and (CStaticCurrencyRate.Enabled) then begin
    Result := False;
    if ShowInfo(itQuestion, 'Nie wybrano przelicznika waluty. Czy wyœwietliæ listê teraz ?', '') then begin
      CStaticCurrencyRate.DoGetDataId;
    end;
  end;
  if Result and (ComboBoxType.ItemIndex = 0) and (Operation = coAdd) then begin
    if CStaticCategory.DataId = CEmptyDataGid then begin
      Result := False;
      if ShowInfo(itQuestion, 'Nie wybrano kategorii operacji. Czy wyœwietliæ listê teraz ?', '') then begin
        CStaticCategory.DoGetDataId;
      end;
    end else if CStaticAccount.DataId = CEmptyDataGid then begin
      Result := False;
      if ShowInfo(itQuestion, 'Nie wybrano konta operacji. Czy wyœwietliæ listê teraz ?', '') then begin
        CStaticAccount.DoGetDataId;
      end;
    end else begin
      if Operation = coEdit then begin
        xPrevCash := TDepositMovement(Dataobject).cash;
      end else begin
        xPrevCash := 0;
      end;
      Result := CheckSurpassedLimits(COutMovement, CDateTime.Value,
                                     TDataGids.CreateFromGid(CStaticAccount.DataId),
                                     TDataGids.CreateFromGid(CStaticCashpoint.DataId),
                                     TSumList.CreateWithSum(CStaticCategory.DataId, CCurrEditActualCash.Value - xPrevCash, CStaticCurrency.DataId));
    end;
  end;
end;

function TCDepositInvestmentForm.GetDataobjectClass: TDataObjectClass;
begin
  Result := TDepositInvestment;
end;

function TCDepositInvestmentForm.GetUpdateFrameClass: TCBaseFrameClass;
begin
  Result := TCDepositInvestmentFrame;
end;

procedure TCDepositInvestmentForm.SetDueType(const Value: TBaseEnumeration);
begin
  if Value = CDepositDueTypeOnDepositEnd then begin
    ComboBoxDueMode.ItemIndex := 0;
  end else begin
    ComboBoxDueMode.ItemIndex := 1;
    if Value = CDepositTypeDay then begin
      ComboBoxDueType.ItemIndex := 0;
    end else if Value = CDepositTypeWeek then begin
      ComboBoxDueType.ItemIndex := 1;
    end else if Value = CDepositTypeMonth then begin
      ComboBoxDueType.ItemIndex := 2;
    end else if Value = CDepositTypeYear then begin
      ComboBoxDueType.ItemIndex := 3;
    end;
  end;
  ComboBoxDueModeChange(Nil);
end;

procedure TCDepositInvestmentForm.SetPeriodType(const Value: TBaseEnumeration);
begin
  if Value = CDepositTypeDay then begin
    ComboBoxPeriodType.ItemIndex := 0;
  end else if Value = CDepositTypeWeek then begin
    ComboBoxPeriodType.ItemIndex := 1;
  end else if Value = CDepositTypeMonth then begin
    ComboBoxPeriodType.ItemIndex := 2;
  end else if Value = CDepositTypeYear then begin
    ComboBoxPeriodType.ItemIndex := 3;
  end;
end;

procedure TCDepositInvestmentForm.ComboBoxTemplateChange(Sender: TObject);
begin
  UpdateDescription;
end;

procedure TCDepositInvestmentForm.AfterCommitData;
var xMove: TDepositMovement;
    xBase: TBaseMovement;
    xDeposit: TDepositInvestment;
    xAccount: TAccount;
    xProduct: TProduct;
    xBaseId, xMoveId: TDataGid;
begin
  inherited AfterCommitData;
  if Operation = coAdd then begin
    xDeposit := TDepositInvestment(Dataobject);
    GDataProvider.BeginTransaction;
    xMove := TDepositMovement.CreateObject(DepositMovementProxy, False);
    xMoveId := xMove.id;
    xMove.movementType := IfThen(ComboBoxType.ItemIndex = 0, CDepositMovementCreate, CDepositMovementRegister);
    xMove.regDateTime := CDateTime.Value;
    xMove.regOrder := 0;
    xMove.description := RichEditDesc.Text;
    xMove.cash := xDeposit.cash;
    xMove.depositState := CDepositInvestmentActive;
    xMove.interest := 0;
    xMove.idDepositInvestment := xDeposit.id;
    xMove.idAccount := CStaticAccount.DataId;
    xMove.idAccountCurrencyDef := CStaticAccountCurrency.DataId;
    xMove.idProduct := CStaticCategory.DataId;
    if CStaticCurrencyRate.Enabled then begin
      xMove.idCurrencyRate := CStaticCurrencyRate.DataId;
      xMove.rateDescription := FRateHelper.desc;
      xMove.currencyQuantity := FRateHelper.quantity;
      xMove.currencyRate := FRateHelper.rate;
    end else begin
      xMove.idCurrencyRate := CEmptyDataGid;
      xMove.rateDescription := '';
      xMove.currencyQuantity := 1;
      xMove.currencyRate := 1;
    end;
    xMove.accountCash := CCurrEditAccount.Value;
    GDataProvider.CommitTransaction;
    if CStaticCategory.DataId <> CEmptyDataGid then begin
      GDataProvider.BeginTransaction;
      xAccount := TAccount(TAccount.LoadObject(AccountProxy, CStaticAccount.DataId, False));
      xProduct := TProduct(TProduct.LoadObject(ProductProxy, CStaticCategory.DataId, False));
      xBase := TBaseMovement.CreateObject(BaseMovementProxy, False);
      xBase.regDate := CDateTime.Value;
      xBase.movementType := COutMovement;
      xBase.description := RichEditDesc.Text;
      xBase.idAccountCurrencyDef := CStaticAccountCurrency.DataId;
      xBase.idAccount := CStaticAccount.DataId;
      xBase.idSourceAccount := CEmptyDataGid;
      xBase.idCashPoint := CStaticCashpoint.DataId;
      xBase.idPlannedDone := CEmptyDataGid;
      xBase.isStated := xAccount.accountType = CCashAccount;
      xBase.idExtractionItem := CEmptyDataGid;
      if CStaticCurrencyRate.Enabled then begin
        xBase.idCurrencyRate := CStaticCurrencyRate.DataId;
        xBase.rateDescription := FRateHelper.desc;
        xBase.currencyQuantity := FRateHelper.quantity;
        xBase.currencyRate := FRateHelper.rate;
      end else begin
        xBase.idCurrencyRate := CEmptyDataGid;
        xBase.rateDescription := '';
        xBase.currencyQuantity := 1;
        xBase.currencyRate := 1;
      end;
      xBase.idProduct := CStaticCategory.DataId;
      xBase.quantity := 1;
      xBase.idUnitDef := xProduct.idUnitDef;
      xBase.movementCash := CCurrEditActualCash.Value;
      xBase.idMovementCurrencyDef := CStaticCurrency.DataId;
      xBase.cash := CCurrEditAccount.Value;
      xBase.isDepositMovement := True;
      xBase.isInvestmentMovement := False;
      xBaseId := xBase.id;
      GDataProvider.CommitTransaction;
      GDataProvider.ExecuteSql('update depositMovement set idBaseMovement = ' + DataGidToDatabase(xBaseId) + ' where idDepositMovement = ' + DataGidToDatabase(xMoveId));
      if Operation = coEdit then begin
        SendMessageToFrames(TCMovementFrame, WM_DATAOBJECTEDITED, Integer(@xBaseId), WMOPT_BASEMOVEMENT);
      end else begin
        SendMessageToFrames(TCMovementFrame, WM_DATAOBJECTADDED, Integer(@xBaseId), WMOPT_BASEMOVEMENT);
      end;
    end;
    SendMessageToFrames(TCAccountsFrame, WM_DATAREFRESH, 0, 0);
    if CDateTime.Value <= GWorkDate then begin
      UpdateDepositInvestments(GDataProvider);
    end;
  end;
end;

procedure TCDepositInvestmentForm.UpdateFuture;
var xFuture: String;
begin
  if not (csLoading in ComponentState) and (not Filling) then begin
    with FDeposit do begin
      cash := CCurrEditActualCash.Value;
      interestRate := CCurrEditRate.Value;
      noncapitalizedInterest := 0;
      periodCount := CIntEditPeriodCount.Value;
      periodType := formPeriodType;
      dueType := formDueType;
      dueCount := CIntEditDueCount.Value;
      periodStartDate := CDateTime.Value;
      periodEndDate := FPeriodEndDate;
      dueStartDate := CDateTime.Value;
      dueEndDate := FDueEndDate;
      progEndDate := FPeriodEndDate;
      calcTax := CheckBoxBelka.Checked;
      taxRate := CCurrEditTaxRate.Value;
      if ComboBoxPeriodAction.ItemIndex = 1 then begin
        periodAction := CDepositPeriodActionAutoRenew;
      end else begin
        periodAction := CDepositPeriodActionChangeInactive;
      end;
      if ComboBoxDueAction.ItemIndex = 0 then begin
        dueAction := CDepositDueActionAutoCapitalisation;
      end else begin
        dueAction := CDepositDueActionLeaveUncapitalised;
      end;
    end;
    if FDeposit.CalculateProg then begin
      xFuture := 'Data koñca ' + Date2StrDate(FPeriodEndDate, False) +
        ', do wyp³aty ' + CurrencyToString(FDeposit.cash + FDeposit.noncapitalizedInterest, CStaticCurrency.DataId) +
        ', podatek ' + CurrencyToString(FDeposit.overallTax, CStaticCurrency.DataId);
    end else begin
      xFuture := '<brak danych do utworzenia prognozy>';
    end;
    CStaticFuture.Caption := xFuture;
  end;
end;

procedure TCDepositInvestmentForm.CStaticCategoryChanged(Sender: TObject);
begin
  UpdateDescription;
end;

procedure TCDepositInvestmentForm.CStaticCategoryGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCProductsFrame, ADataGid, AText);
end;

procedure TCDepositInvestmentForm.ComboBoxTypeChange(Sender: TObject);
begin
  Label14.Enabled := ComboBoxType.ItemIndex = 0;
  CStaticAccount.Enabled := ComboBoxType.ItemIndex = 0;
  Label17.Enabled := ComboBoxType.ItemIndex = 0;
  Label22.Enabled := ComboBoxType.ItemIndex = 0;
  CStaticCurrencyRate.Enabled := ComboBoxType.ItemIndex = 0;
  Label21.Enabled := ComboBoxType.ItemIndex = 0;
  Label13.Enabled := ComboBoxType.ItemIndex = 0;
  CStaticCategory.Enabled := ComboBoxType.ItemIndex = 0;
  if ComboBoxType.ItemIndex = 0 then begin
    UpdateCurrencyRates(False);
  end;
  UpdateDescription;
end;

procedure TCDepositInvestmentForm.UpdateAccountCurEdit(ARate: TCStatic; ASourceEdit, ATargetEdit: TCCurrEdit; AHelper: TCurrencyRateHelper);
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
    if (ASourceEdit.CurrencyId <> CEmptyDataGid) and (ATargetEdit.CurrencyId <> CEmptyDataGid) then begin
      ATargetEdit.Value := ASourceEdit.Value;
    end;
  end;
end;

procedure TCDepositInvestmentForm.UpdateCurrencyRates(AUpdateCurEdit: Boolean);
var xRate: TCurrencyRate;
begin
  if not (csLoading in ComponentState) then begin
    CStaticCurrencyRate.Enabled :=
      (CStaticCurrency.DataId <> CStaticAccountCurrency.DataId) and
      (CStaticCurrency.DataId <> CEmptyDataGid) and
      (CStaticAccountCurrency.DataId <> CEmptyDataGid);
    CStaticCurrencyRate.HotTrack := CStaticCurrencyRate.Enabled;
    Label22.Enabled := CStaticCurrencyRate.Enabled;
    if CStaticCurrencyRate.Enabled then begin
      GDataProvider.BeginTransaction;
      xRate := TAccountCurrencyRule.FindRateByRule(GWorkDate,
                                                   COutMovement,
                                                   CStaticCurrency.DataId, CStaticAccountCurrency.DataId);
      if xRate <> Nil then begin
        if FRateHelper = Nil then begin
          FRateHelper := TCurrencyRateHelper.Create(0, 0, '', '', '');
        end;
        FRateHelper.Assign(xRate.quantity, xRate.rate, xRate.description, xRate.idSourceCurrencyDef, xRate.idTargetCurrencyDef);
        CStaticCurrencyRate.DataId := xRate.id;
        CStaticCurrencyRate.Caption := xRate.description;
      end;
      GDataProvider.RollbackTransaction;
    end;
    if AUpdateCurEdit then begin
      UpdateAccountCurEdit(CStaticCurrencyRate, CCurrEditActualCash, CCurrEditAccount, FRateHelper);
    end;
  end;
end;

procedure TCDepositInvestmentForm.CStaticCurrencyRateGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
var xCurrencyRate: TCurrencyRate;
begin
  AAccepted := TCFrameForm.ShowFrame(TCCurrencyRateFrame, ADataGid, AText);
  if AAccepted then begin
    xCurrencyRate := TCurrencyRate(TCurrencyRate.LoadObject(CurrencyRateProxy, ADataGid, False));
    if FRateHelper = Nil then begin
      FRateHelper := TCurrencyRateHelper.Create(xCurrencyRate.quantity, xCurrencyRate.rate, xCurrencyRate.description, xCurrencyRate.idSourceCurrencyDef, xCurrencyRate.idTargetCurrencyDef);
    end else begin
      FRateHelper.Assign(xCurrencyRate.quantity, xCurrencyRate.rate, xCurrencyRate.description, xCurrencyRate.idSourceCurrencyDef, xCurrencyRate.idTargetCurrencyDef);
    end;
  end;
end;

destructor TCDepositInvestmentForm.Destroy;
begin
  if FRateHelper <> Nil then begin
    FRateHelper.Free;
  end;
  FDeposit.Free;
  inherited Destroy;
end;

procedure TCDepositInvestmentForm.CCurrEditActualCashChange(Sender: TObject);
begin
  UpdateCurrencyRates;
  UpdateFuture;
end;

procedure TCDepositInvestmentForm.CStaticCurrencyRateChanged(Sender: TObject);
begin
  UpdateCurrencyRates;
  UpdateDescription;
end;

procedure TCDepositInvestmentForm.CCurrEditRateChange(Sender: TObject);
begin
  UpdateFuture;
end;

procedure TCDepositInvestmentForm.CStaticFutureGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  with FDeposit do begin
    cash := CCurrEditActualCash.Value;
    interestRate := CCurrEditRate.Value;
    noncapitalizedInterest := 0;
    periodCount := CIntEditPeriodCount.Value;
    periodType := formPeriodType;
    dueType := formDueType;
    dueCount := CIntEditDueCount.Value;
    periodStartDate := CDateTime.Value;
    periodEndDate := FPeriodEndDate;
    dueStartDate := CDateTime.Value;
    dueEndDate := FDueEndDate;
    progEndDate := FPeriodEndDate;
    if ComboBoxPeriodAction.ItemIndex = 1 then begin
      periodAction := CDepositPeriodActionAutoRenew;
    end else begin
      periodAction := CDepositPeriodActionChangeInactive;
    end;
    if ComboBoxDueAction.ItemIndex = 0 then begin
      dueAction := CDepositDueActionAutoCapitalisation;
    end else begin
      dueAction := CDepositDueActionLeaveUncapitalised;
    end;
    if ShowDepositCalculator(Operation = coAdd, FDeposit) then begin
      BeginFilling;
      CCurrEditActualCash.Value := cash;
      CCurrEditRate.Value := interestRate;
      CIntEditPeriodCount.Value := periodCount;
      CIntEditDueCount.Value := dueCount;
      CDateTime.Value := periodStartDate;
      FPeriodEndDate := periodEndDate;
      FDueEndDate := dueEndDate;
      formPeriodType := periodType;
      formDueType := dueType;
      if periodAction = CDepositPeriodActionAutoRenew then begin
        ComboBoxPeriodAction.ItemIndex := 1;
      end else begin
        ComboBoxPeriodAction.ItemIndex := 0;
      end;
      if dueAction = CDepositDueActionAutoCapitalisation then begin
        ComboBoxDueAction.ItemIndex := 0;
      end else begin
        ComboBoxDueAction.ItemIndex := 1;
      end;
      EndFilling;
    end;
  end;
end;

procedure TCDepositInvestmentForm.EndFilling;
begin
  inherited EndFilling;
  UpdateEndPeriodDatetime;
  UpdateEndCapitalisationDatetime;
  UpdateDescription;
  UpdateFuture;
end;

procedure TCDepositInvestmentForm.FillForm;
begin
  with TDepositInvestment(Dataobject) do begin
    LabelState.Visible := True;
    ComboBoxDepositState.Visible := True;
    if depositState = CDepositInvestmentActive then begin
      ComboBoxDepositState.ItemIndex := 0;
    end else if depositState = CDepositInvestmentInactive then begin
      ComboBoxDepositState.ItemIndex := 1;
    end else begin
      ComboBoxDepositState.ItemIndex := 2;
    end;
    CDateTime.Enabled := False;
    Label12.Visible := False;
    ComboBoxType.Visible := False;
    Label14.Visible := False;
    CStaticAccount.Visible := False;
    Label17.Visible := False;
    CStaticAccountCurrency.Visible := False;
    Label22.Visible := False;
    CStaticCurrencyRate.Visible := False;
    Label21.Visible := False;
    CCurrEditAccount.Visible := False;
    Label13.Visible := False;
    CStaticCategory.Visible := False;
    CStaticCurrency.Enabled := False;
    CIntEditPeriodCount.Enabled := False;
    ComboBoxPeriodType.Enabled := False;
    ComboBoxPeriodAction.Enabled := False;
    ComboBoxDueMode.Enabled := False;
    CIntEditDueCount.Enabled := False;
    ComboBoxDueType.Enabled := False;
    ComboBoxDueAction.Enabled := False;
    GroupBox3.Height := 281;
    CCurrEditNoncapitalized.Value := noncapitalizedInterest;
    GroupBox2.Top := GroupBox3.Top + GroupBox3.Height + 16;
    Height := Height - 106;
    SimpleRichText(description, RichEditDesc);
    EditName.Text := name;
    GDataProvider.BeginTransaction;
    CStaticCashpoint.DataId := idCashPoint;
    CStaticCashpoint.Caption := TCashPoint(TCashPoint.LoadObject(CashPointProxy, idCashPoint, False)).name;
    CStaticCurrency.DataId := idCurrencyDef;
    CStaticCurrency.Caption := GCurrencyCache.GetIso(idCurrencyDef);
    CCurrEditActualCash.SetCurrencyDef(idCurrencyDef, GCurrencyCache.GetSymbol(idCurrencyDef));
    GDataProvider.RollbackTransaction;
    CCurrEditRate.Value := interestRate;
    CCurrEditActualCash.Value := cash;
    CDateTime.Value := periodStartDate;
    CIntEditPeriodCount.Value := periodCount;
    CIntEditDueCount.Value := dueCount;
    CheckBoxBelka.Checked := calcTax;
    CCurrEditTaxRate.Value := taxRate;
    CCurrEditTaxRate.Enabled := CheckBoxBelka.Checked;
    formPeriodType := periodType;
    formDueType := dueType;
    if dueAction = CDepositDueActionAutoCapitalisation then begin
      ComboBoxDueAction.ItemIndex := 0;
    end else begin
      ComboBoxDueAction.ItemIndex := 1;
    end;
    if periodAction = CDepositPeriodActionAutoRenew then begin
      ComboBoxPeriodAction.ItemIndex := 1;
    end else begin
      ComboBoxPeriodAction.ItemIndex := 0;
    end;
    ComboBoxTemplate.ItemIndex := IfThen(Operation = coEdit, 0, 1);
  end;
  update
end;

function TCDepositInvestmentForm.CanModifyValues: Boolean;
begin
  Result := inherited CanModifyValues;
  if Result and (Operation = coEdit) then begin
    if TDepositInvestment(Dataobject).depositState <> CDepositInvestmentActive then begin
      ShowInfoPanel(50, 'Edycja lokaty nieaktywnej lub wyp³aconej nie jest mo¿liwa', clWindowText, [fsBold], iitNone);
      Result := False;
    end;
  end;
end;

procedure TCDepositInvestmentForm.CheckBoxBelkaClick(Sender: TObject);
begin
  CCurrEditTaxRate.Enabled := CheckBoxBelka.Checked;
  UpdateFuture;
end;

procedure TCDepositInvestmentForm.CCurrEditTaxRateChange(Sender: TObject);
begin
  UpdateFuture;
end;

end.
