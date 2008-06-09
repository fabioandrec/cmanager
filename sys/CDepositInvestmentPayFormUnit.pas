unit CDepositInvestmentPayFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, CComponents, StrUtils,
  ComCtrls, ActnList, XPStyleActnCtrls, ActnMan, CTools, CDatatools, CDatabase, CDataObjects, DateUtils,
  CBaseFrameUnit, Contnrs;

type
  TDepositAdditionalData = class(TAdditionalData)
  private
    Fdeposit: TDepositInvestment;
  public
    constructor Create(ADeposit: TDepositInvestment);
  published
    property deposit: TDepositInvestment read Fdeposit;
  end;

  TCDepositInvestmentPayForm = class(TCDataobjectForm)
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label2: TLabel;
    Label12: TLabel;
    CDateTime: TCDateTime;
    ComboBoxType: TComboBox;
    CStaticDeposit: TCStatic;
    ActionManager: TActionManager;
    ActionAdd: TAction;
    ActionTemplate: TAction;
    GroupBox2: TGroupBox;
    CButton1: TCButton;
    CButton2: TCButton;
    RichEditDesc: TCRichedit;
    ComboBoxTemplate: TComboBox;
    GroupBox3: TGroupBox;
    Label14: TLabel;
    Label17: TLabel;
    Label22: TLabel;
    Label21: TLabel;
    Label13: TLabel;
    CStaticAccount: TCStatic;
    CStaticAccountCurrency: TCStatic;
    CStaticCurrencyRate: TCStatic;
    CCurrEditAccount: TCCurrEdit;
    CStaticCategory: TCStatic;
    Label15: TLabel;
    CCurrEditBeforeCap: TCCurrEdit;
    Label1: TLabel;
    CCurrEditBeforeInt: TCCurrEdit;
    Label4: TLabel;
    CCurrEditCash: TCCurrEdit;
    Label5: TLabel;
    CCurrEditAfterCap: TCCurrEdit;
    Label6: TLabel;
    CCurrEditAfterInt: TCCurrEdit;
    Label7: TLabel;
    CStaticDepositCurrency: TCStatic;
    procedure CStaticAccountChanged(Sender: TObject);
    procedure ComboBoxTypeChange(Sender: TObject);
    procedure CStaticDepositChanged(Sender: TObject);
    procedure CStaticDepositGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticCategoryChanged(Sender: TObject);
    procedure CStaticCategoryGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticCurrencyRateChanged(Sender: TObject);
    procedure CStaticCurrencyRateGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CCurrEditCashChange(Sender: TObject);
    procedure ActionAddExecute(Sender: TObject);
    procedure ActionTemplateExecute(Sender: TObject);
  private
    FRateHelper: TCurrencyRateHelper;
    procedure UpdateDescription;
    procedure UpdateCurrencyRates(AUpdateCurEdit: Boolean = True);
    procedure UpdateAccountCurEdit(ARate: TCStatic; ASourceEdit, ATargetEdit: TCCurrEdit; AHelper: TCurrencyRateHelper);
    procedure UpdateAfterCash;
  protected
    function GetDataobjectClass: TDataObjectClass; override;
    function GetUpdateFrameClass: TCBaseFrameClass; override;
    procedure InitializeForm; override;
    function CanAccept: Boolean; override;
    procedure AfterCommitData; override;
    procedure ReadValues; override;
    procedure FillForm; override;
  public
    destructor Destroy; override;
    function ExpandTemplate(ATemplate: String): String; override;
  end;

implementation

uses CConsts, CDescpatternFormUnit, CPreferences, CTemplates, CRichtext,
  CDepositInvestmentFrameUnit, CFrameFormUnit, CProductsFrameUnit,
  CAccountsFrameUnit, CCurrencyRateFrameUnit, Math, CInfoFormUnit,
  CConfigFormUnit, CSurpassedFormUnit, CMovementFrameUnit,
  CDepositMovementFrameUnit;

{$R *.dfm}

procedure TCDepositInvestmentPayForm.InitializeForm;
begin
  inherited InitializeForm;
  Caption := 'Lokata - Operacja';
  CDateTime.Value := Now;
  FRateHelper := nil;
  if AdditionalData <> Nil then begin
    with TDepositAdditionalData(AdditionalData) do begin
      CStaticDeposit.DataId := deposit.id;
      CStaticDeposit.Caption := deposit.GetElementText;
      CStaticDepositChanged(Nil);
    end;
  end;
  if Operation = coEdit then begin
    ComboBoxType.Items.Add('Za³o¿enie lokaty');
    ComboBoxType.Items.Add('Rejestracja lokaty');
    ComboBoxType.Items.Add('Zakoñczenie lokaty');
    ComboBoxType.Items.Add('Odnowienie lokaty');
    ComboBoxType.Items.Add('Naliczenie odsetek');
  end;
  ComboBoxTypeChange(Nil);
end;

procedure TCDepositInvestmentPayForm.CStaticAccountChanged(Sender: TObject);
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

procedure TCDepositInvestmentPayForm.UpdateCurrencyRates(AUpdateCurEdit: Boolean);
var xRate: TCurrencyRate;
begin
  if not (csLoading in ComponentState) then begin
    CStaticCurrencyRate.Enabled :=
      (CStaticDepositCurrency.DataId <> CStaticAccountCurrency.DataId) and
      (CStaticDepositCurrency.DataId <> CEmptyDataGid) and
      (CStaticAccountCurrency.DataId <> CEmptyDataGid);
    CStaticCurrencyRate.HotTrack := CStaticCurrencyRate.Enabled;
    Label22.Enabled := CStaticCurrencyRate.Enabled;
    if CStaticCurrencyRate.Enabled then begin
      GDataProvider.BeginTransaction;
      xRate := TAccountCurrencyRule.FindRateByRule(GWorkDate,
                                                   COutMovement,
                                                   CStaticDepositCurrency.DataId, CStaticAccountCurrency.DataId);
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
      UpdateAccountCurEdit(CStaticCurrencyRate, CCurrEditCash, CCurrEditAccount, FRateHelper);
    end;
  end;
end;

procedure TCDepositInvestmentPayForm.UpdateDescription;
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


procedure TCDepositInvestmentPayForm.UpdateAccountCurEdit(ARate: TCStatic; ASourceEdit, ATargetEdit: TCCurrEdit; AHelper: TCurrencyRateHelper);
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

procedure TCDepositInvestmentPayForm.ComboBoxTypeChange(Sender: TObject);
begin
  CCurrEditCash.Enabled := ComboBoxType.ItemIndex <> 1;
  UpdateAfterCash;
  UpdateCurrencyRates(False);
  UpdateDescription;
end;

constructor TDepositAdditionalData.Create(ADeposit: TDepositInvestment);
begin
  inherited Create;
  Fdeposit := ADeposit;
end;

procedure TCDepositInvestmentPayForm.CStaticDepositChanged(Sender: TObject);
var xCurrencyId: TDataGid;
    xDeposit: TDepositInvestment;
    xCap, xInt: Currency;
begin
  if CStaticDeposit.DataId <> CEmptyDataGid then begin
    GDataProvider.BeginTransaction;
    xDeposit := TDepositInvestment(TDepositInvestment.LoadObject(DepositInvestmentProxy, CStaticDeposit.DataId, False));
    xCurrencyId := xDeposit.idCurrencyDef;
    xCap := xDeposit.cash;
    xInt := xDeposit.noncapitalizedInterest;
    GDataProvider.RollbackTransaction;
    CStaticDepositCurrency.DataId := xCurrencyId;
    CStaticDepositCurrency.Caption := GCurrencyCache.GetIso(xCurrencyId);
    CCurrEditBeforeCap.SetCurrencyDef(xCurrencyId, GCurrencyCache.GetSymbol(xCurrencyId));
    CCurrEditBeforeCap.Value := xCap;
    CCurrEditBeforeInt.SetCurrencyDef(xCurrencyId, GCurrencyCache.GetSymbol(xCurrencyId));
    CCurrEditBeforeInt.Value := xInt;
    CCurrEditAfterCap.SetCurrencyDef(xCurrencyId, GCurrencyCache.GetSymbol(xCurrencyId));
    CCurrEditAfterInt.SetCurrencyDef(xCurrencyId, GCurrencyCache.GetSymbol(xCurrencyId));
    CCurrEditCash.SetCurrencyDef(xCurrencyId, GCurrencyCache.GetSymbol(xCurrencyId));
  end else begin
    CCurrEditBeforeCap.SetCurrencyDef(CEmptyDataGid, '');
    CCurrEditBeforeInt.SetCurrencyDef(CEmptyDataGid, '');
    CCurrEditAfterCap.SetCurrencyDef(CEmptyDataGid, '');
    CCurrEditAfterInt.SetCurrencyDef(CEmptyDataGid, '');
    CCurrEditCash.SetCurrencyDef(CEmptyDataGid, '');
    CStaticDepositCurrency.DataId := CEmptyDataGid;
  end;
  CStaticCurrencyRate.DataId := CEmptyDataGid;
  UpdateCurrencyRates;
  UpdateDescription;
end;

procedure TCDepositInvestmentPayForm.CStaticDepositGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCDepositInvestmentFrame, ADataGid, AText, TCDepositFrameAdditionalData.Create(CEmptyDataGid, True));
end;

procedure TCDepositInvestmentPayForm.CStaticCategoryChanged(Sender: TObject);
begin
  UpdateDescription;
end;

procedure TCDepositInvestmentPayForm.CStaticCategoryGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCProductsFrame, ADataGid, AText);
end;

procedure TCDepositInvestmentPayForm.CStaticAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCAccountsFrame, ADataGid, AText);
end;

procedure TCDepositInvestmentPayForm.CStaticCurrencyRateChanged(Sender: TObject);
begin
  UpdateCurrencyRates;
  UpdateDescription;
end;

procedure TCDepositInvestmentPayForm.CStaticCurrencyRateGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
var xCurrencyRate: TCurrencyRate;
begin
  AAccepted := TCFrameForm.ShowFrame(TCCurrencyRateFrame, ADataGid, AText, TRateFrameAdditionalData.CreateRateData(CStaticAccountCurrency.DataId, CStaticDepositCurrency.DataId));
  if AAccepted then begin
    xCurrencyRate := TCurrencyRate(TCurrencyRate.LoadObject(CurrencyRateProxy, ADataGid, False));
    if FRateHelper = Nil then begin
      FRateHelper := TCurrencyRateHelper.Create(xCurrencyRate.quantity, xCurrencyRate.rate, xCurrencyRate.description, xCurrencyRate.idSourceCurrencyDef, xCurrencyRate.idTargetCurrencyDef);
    end else begin
      FRateHelper.Assign(xCurrencyRate.quantity, xCurrencyRate.rate, xCurrencyRate.description, xCurrencyRate.idSourceCurrencyDef, xCurrencyRate.idTargetCurrencyDef);
    end;
  end;
end;

destructor TCDepositInvestmentPayForm.Destroy;
begin
  if FRateHelper <> Nil then begin
    FRateHelper.Free;
  end;
  inherited Destroy;
end;

procedure TCDepositInvestmentPayForm.UpdateAfterCash;
begin
  if ComboBoxType.ItemIndex = 0 then begin
    CCurrEditAfterCap.Value := CCurrEditBeforeCap.Value + CCurrEditCash.Value;
    CCurrEditAfterInt.Value := CCurrEditBeforeInt.Value;
  end else if ComboBoxType.ItemIndex = 1 then begin
    CCurrEditAfterCap.Value := 0;
    CCurrEditAfterInt.Value := 0;
    CCurrEditCash.Value := CCurrEditBeforeCap.Value + CCurrEditBeforeInt.Value;
  end else if ComboBoxType.ItemIndex = 2 then begin
    CCurrEditAfterInt.Value := Max(0, CCurrEditBeforeInt.Value - CCurrEditCash.Value);
    CCurrEditAfterCap.Value := CCurrEditBeforeCap.Value;
  end;
end;

procedure TCDepositInvestmentPayForm.CCurrEditCashChange(Sender: TObject);
begin
  UpdateAfterCash;
  UpdateCurrencyRates;
end;

function TCDepositInvestmentPayForm.CanAccept: Boolean;
var xNoncapInt, xPrevCash: Currency;
begin
  Result := True;
  if Operation = coAdd then begin
    if CStaticDeposit.DataId = CEmptyDataGid then begin
      Result := False;
      if ShowInfo(itQuestion, 'Nie wybrano lokaty. Czy wyœwietliæ listê teraz ?', '') then begin
        CStaticDeposit.DoGetDataId;
      end;
    end else if (CStaticCurrencyRate.DataId = CEmptyDataGid) and (CStaticCurrencyRate.Enabled) then begin
      Result := False;
      if ShowInfo(itQuestion, 'Nie wybrano przelicznika waluty. Czy wyœwietliæ listê teraz ?', '') then begin
        CStaticCurrencyRate.DoGetDataId;
      end;
    end;
    if Result and (ComboBoxType.ItemIndex = 2) then begin
      GDataProvider.BeginTransaction;
      xNoncapInt := TDepositInvestment(TDepositInvestment.LoadObject(DepositInvestmentProxy, CStaticDeposit.DataId, False)).noncapitalizedInterest;
      GDataProvider.RollbackTransaction;
      if xNoncapInt < CCurrEditCash.Value then begin
        Result := False;
        ShowInfo(itError, 'Kwota odsetek do wyp³aty nie mo¿e byæ wiêksza od kwoty wolnych odsetek', '');
        CCurrEditCash.SetFocus;
      end;
    end;
    if Result then begin
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
        Result := CheckSurpassedLimits(IfThen(ComboBoxType.ItemIndex = 0, COutMovement, CInMovement), CDateTime.Value,
                                       TDataGids.CreateFromGid(CStaticAccount.DataId),
                                       TDataGids.CreateFromGid(CEmptyDataGid),
                                       TSumList.CreateWithSum(CStaticCategory.DataId, CCurrEditCash.Value - xPrevCash, CStaticDepositCurrency.DataId));
      end;
    end;
  end;
end;

procedure TCDepositInvestmentPayForm.AfterCommitData;
var xInvest: TDepositMovement;
    xBase:  TBaseMovement;
    xDeposit: TDepositInvestment;
    xAccount: TAccount;
    xProduct: TProduct;
    xDepositId, xBaseId, xAccountId: TDataGid;
begin
  inherited AfterCommitData;
  if CStaticCategory.DataId <> CEmptyDataGid then begin
    xInvest := TDepositMovement(Dataobject);
    xDepositId := CStaticDeposit.DataId;
    GDataProvider.BeginTransaction;
    xDeposit := TDepositInvestment(TDepositInvestment.LoadObject(DepositInvestmentProxy, CStaticDeposit.DataId, False));
    xAccount := TAccount(TAccount.LoadObject(AccountProxy, CStaticAccount.DataId, False));
    xProduct := TProduct(TProduct.LoadObject(ProductProxy, CStaticCategory.DataId, False));
    if Operation = coAdd then begin
      xBase := TBaseMovement.CreateObject(BaseMovementProxy, False);
    end else begin
      xBase := TBaseMovement(TBaseMovement.LoadObject(BaseMovementProxy, TDepositMovement(Dataobject).idBaseMovement, False));
    end;
    xBase.regDate := DateOf(xInvest.regDateTime);
    if xInvest.movementType = CDepositMovementAddCash then begin
      xBase.movementType := COutMovement;
    end else if xInvest.movementType = CDepositMovementClose then begin
      xBase.movementType := CInMovement;
      xDeposit.depositState := CDepositInvestmentClosed;
    end else if xInvest.movementType = CDepositMovementGetInterest then begin
      xBase.movementType := CInMovement;
    end;
    xDeposit.cash := CCurrEditAfterCap.Value;
    xDeposit.noncapitalizedInterest := CCurrEditAfterInt.Value;
    xBase.description := RichEditDesc.Text;
    xBase.idAccountCurrencyDef := CStaticAccountCurrency.DataId;
    xBase.idAccount := CStaticAccount.DataId;
    xBase.idSourceAccount := CEmptyDataGid;
    xBase.idCashPoint := xDeposit.idCashPoint;
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
    if xProduct.idUnitDef <> CEmptyDataGid then begin
      xBase.quantity := 1;
      xBase.idUnitDef := xProduct.idUnitDef;
    end else begin
      xBase.quantity := 1;
      xBase.idUnitDef := CEmptyDataGid;
    end;
    xBase.movementCash := CCurrEditCash.Value;
    xBase.idMovementCurrencyDef := CStaticDepositCurrency.DataId;
    xBase.cash := CCurrEditAccount.Value;
    xBase.isInvestmentMovement := True;
    xBase.isDepositMovement := False;
    xBaseId := xBase.id;
    xAccountId := xBase.idAccount;
    GDataProvider.CommitTransaction;
    GDataProvider.ExecuteSql('update depositMovement set idBaseMovement = ' + DataGidToDatabase(xBaseId) + ' where idDepositMovement = ' + DataGidToDatabase(Dataobject.id));
    if Operation = coEdit then begin
      SendMessageToFrames(TCMovementFrame, WM_DATAOBJECTEDITED, Integer(@xBaseId), WMOPT_BASEMOVEMENT);
    end else begin
      SendMessageToFrames(TCMovementFrame, WM_DATAOBJECTADDED, Integer(@xBaseId), WMOPT_BASEMOVEMENT);
    end;
    SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTEDITED, Integer(@xAccountId), WMOPT_NONE);
    SendMessageToFrames(TCDepositInvestmentFrame, WM_DATAOBJECTEDITED, Integer(@xDepositId), WMOPT_NONE);
  end;
end;

procedure TCDepositInvestmentPayForm.ReadValues;
begin
  with TDepositMovement(Dataobject) do begin
    if Operation = coAdd then begin
      regDateTime := CDateTime.Value;
      regOrder := 0;
      description := RichEditDesc.Text;
      if ComboBoxType.ItemIndex = 0 then begin
        cash := CCurrEditCash.Value;
        interest := 0;
      end else if ComboBoxType.ItemIndex = 1 then begin
        cash := CCurrEditBeforeCap.Value;
        interest := CCurrEditBeforeInt.Value;
      end else if ComboBoxType.ItemIndex = 2 then begin
        cash := 0;
        interest := CCurrEditCash.Value;
      end;
      depositState := TDepositInvestment(TDepositInvestment.LoadObject(DepositInvestmentProxy, CStaticDeposit.DataId, False)).depositState;
      idDepositInvestment := CStaticDeposit.DataId;
      idAccount := CStaticAccount.DataId;
      idAccountCurrencyDef := CStaticAccountCurrency.DataId;
      accountCash := CCurrEditAccount.Value;
      if CStaticCurrencyRate.Enabled then begin
        idCurrencyRate := CStaticCurrencyRate.DataId;
        rateDescription := FRateHelper.desc;
        currencyQuantity := FRateHelper.quantity;
        currencyRate := FRateHelper.rate;
      end else begin
        idCurrencyRate := CEmptyDataGid;
        rateDescription := '';
        currencyQuantity := 1;
        currencyRate := 1;
      end;
      idProduct := CStaticCategory.DataId;
      if ComboBoxType.ItemIndex = 0 then begin
        movementType := CDepositMovementAddCash;
      end else if ComboBoxType.ItemIndex = 1 then begin
        movementType := CDepositMovementClose;
      end else if ComboBoxType.ItemIndex = 2 then begin
        movementType := CDepositMovementGetInterest;
      end;
    end else begin
      description := RichEditDesc.Text;
    end;
  end;
end;

function TCDepositInvestmentPayForm.GetDataobjectClass: TDataObjectClass;
begin
  Result := TDepositMovement;
end;

function TCDepositInvestmentPayForm.GetUpdateFrameClass: TCBaseFrameClass;
begin
  Result := TCDepositMovementFrame;
end;

procedure TCDepositInvestmentPayForm.ActionAddExecute(Sender: TObject);
var xData: TObjectList;
begin
  xData := TObjectList.Create(False);
  xData.Add(GBaseTemlatesList);
  xData.Add(GDepositInvestmentTemplatesList);
  EditAddTemplate(xData, Self, RichEditDesc, True);
  xData.Free;
end;

procedure TCDepositInvestmentPayForm.ActionTemplateExecute(Sender: TObject);
var xPattern: String;
begin
  if EditDescPattern(CDescPatternsKeys[9][0], xPattern) then begin
    UpdateDescription;
  end;
end;

function TCDepositInvestmentPayForm.ExpandTemplate(ATemplate: String): String;
begin
  Result := inherited ExpandTemplate(ATemplate);
  if ATemplate = '@data@' then begin
    Result := GetFormattedDate(CDateTime.Value, 'yyyy-MM-dd');
  end else if ATemplate = '@stan@' then begin
    Result := 'Aktywna';
  end else if ATemplate = '@operacja@' then begin
    Result := ComboBoxType.Text;
  end else if ATemplate = '@nazwa@' then begin
    if CStaticDeposit.DataId = '' then begin
      Result := '<nazwa lokaty>';
    end else begin
      Result := CStaticDeposit.Caption;
    end;
  end else if ATemplate = '@konto@' then begin
    Result := '<konto stowarzyszone>';
    if CStaticAccount.DataId <> CEmptyDataGid then begin
      Result := CStaticAccount.Caption;
    end;
  end else if ATemplate = '@kontrahent@' then begin
    Result := '<prowadz¹cy lokatê>';
    if CStaticDeposit.DataId <> CEmptyDataGid then begin
      GDataProvider.BeginTransaction;
      Result := TDepositInvestment(TDepositInvestment.LoadObject(DepositInvestmentProxy, CStaticDeposit.DataId, False)).GetDepositCashpointName;
      GDataProvider.RollbackTransaction;
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
    if CStaticDepositCurrency.DataId <> CEmptyDataGid then begin
      Result := GCurrencyCache.GetIso(CStaticDepositCurrency.DataId);
    end;
  end else if ATemplate = '@symbolwaluty@' then begin
    Result := '<symbol waluty lokaty>';
    if CStaticDepositCurrency.DataId <> CEmptyDataGid then begin
      Result := GCurrencyCache.GetSymbol(CStaticDepositCurrency.DataId);
    end;
  end;
end;

procedure TCDepositInvestmentPayForm.FillForm;
begin
  with TDepositMovement(Dataobject) do begin
    ComboBoxType.Enabled := False;
    if movementType = CDepositMovementCreate then begin
      ComboBoxType.ItemIndex := 3;
    end else if movementType = CDepositMovementRegister then begin
      ComboBoxType.ItemIndex := 4;
    end else if movementType = CDepositMovementInactivate then begin
      ComboBoxType.ItemIndex := 5;
    end else if movementType = CDepositMovementRenew then begin
      ComboBoxType.ItemIndex := 6;
    end else if movementType = CDepositMovementDue then begin
      ComboBoxType.ItemIndex := 7;
    end else if movementType = CDepositMovementAddCash then begin
      ComboBoxType.ItemIndex := 0;
    end else if movementType = CDepositMovementClose then begin
      ComboBoxType.ItemIndex := 1;
    end else if movementType = CDepositMovementGetInterest then begin
      ComboBoxType.ItemIndex := 2;
    end;
    Label14.Visible := (movementType = CDepositMovementCreate) or (movementType = CDepositMovementClose) or
                       (movementType = CDepositMovementAddCash) or (movementType = CDepositMovementGetInterest);
    CStaticAccount.Visible := Label14.Visible;
    Label17.Visible := Label14.Visible;
    CStaticAccountCurrency.Visible := Label14.Visible;
    Label22.Visible := Label14.Visible;
    CStaticCurrencyRate.Visible := Label14.Visible;
    Label21.Visible := Label14.Visible;
    CCurrEditAccount.Visible := Label14.Visible;
    Label13.Visible := Label14.Visible;
    CStaticCategory.Visible := Label14.Visible;
    Label15.Visible := False;
    CCurrEditBeforeCap.Visible := False;
    Label1.Visible := False;
    CCurrEditBeforeInt.Visible := False;
    Label5.Visible := False;
    CCurrEditAfterCap.Visible := False;
    Label6.Visible := False;
    CCurrEditAfterInt.Visible := False;
    CDateTime.Value := regDateTime;
    CCurrEditCash.Value := cash + interest;
    CCurrEditCash.SetCurrencyDef(idCurrencyDef, GCurrencyCache.GetSymbol(idCurrencyDef));
    CCurrEditAccount.Value := accountCash;
    CCurrEditAccount.SetCurrencyDef(idAccountCurrencyDef, GCurrencyCache.GetSymbol(idAccountCurrencyDef));
    GDataProvider.BeginTransaction;
    CStaticDeposit.DataId := idDepositInvestment;
    CStaticDeposit.Caption := TDepositInvestment(TDepositInvestment.LoadObject(DepositInvestmentProxy, idDepositInvestment, False)).GetElementText;
    CStaticDepositCurrency.DataId := idCurrencyDef;
    CStaticDepositCurrency.Caption := GCurrencyCache.GetIso(idCurrencyDef);
    if idAccount <> CEmptyDataGid then begin
      CStaticAccount.DataId := idAccount;
      CStaticAccount.Caption := TAccount(TAccount.LoadObject(AccountProxy, idAccount, False)).GetElementText;
      CStaticAccountCurrency.DataId := idAccountCurrencyDef;
      CStaticAccountCurrency.Caption := GCurrencyCache.GetIso(idAccountCurrencyDef);
    end;
    if idProduct <> CEmptyDataGid then begin
      CStaticCategory.DataId := idAccount;
      CStaticCategory.Caption := TProduct(TProduct.LoadObject(ProductProxy, idProduct, False)).GetElementText;
    end;
    if idCurrencyRate <> CEmptyDataGid then begin
      CStaticCurrencyRate.DataId := idCurrencyRate;
      CStaticCurrencyRate.Caption := rateDescription;
    end;
    FRateHelper := TCurrencyRateHelper.Create(currencyQuantity, currencyRate, rateDescription, idAccountCurrencyDef, idCurrencyDef);
    GDataProvider.RollbackTransaction;
    ComboBoxTemplate.ItemIndex := IfThen(Operation = coEdit, 0, 1);
    SimpleRichText(description, RichEditDesc);
    UpdateCurrencyRates(False);
    CCurrEditBeforeCap.Enabled := False;
    CCurrEditBeforeInt.Enabled := False;
    CCurrEditCash.Enabled := False;
    CCurrEditAfterInt.Enabled := False;
    CCurrEditAfterCap.Enabled := False;
    CStaticAccount.Enabled := False;
    CStaticCurrencyRate.Enabled := False;
    CStaticCategory.Enabled := False;
    CCurrEditAccount.Enabled := False;
    CStaticAccountCurrency.Enabled := False;
    CStaticDeposit.Enabled := False;
    CDateTime.Enabled := False;
    ComboBoxType.Enabled := False;
    CStaticDepositCurrency.Enabled := False;
  end;
end;

end.
