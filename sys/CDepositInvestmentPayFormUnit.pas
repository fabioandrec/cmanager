unit CDepositInvestmentPayFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, CComponents, StrUtils,
  ComCtrls, ActnList, XPStyleActnCtrls, ActnMan, CTools, CDatatools, CDatabase, CDataObjects, DateUtils,
  CBaseFrameUnit;

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
  public
    destructor Destroy; override;
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
  Caption := 'Lokata - Wyp³ata';
  CDateTime.Value := Now;
  FRateHelper := nil;
  if AdditionalData <> Nil then begin
    with TDepositAdditionalData(AdditionalData) do begin
      CStaticDeposit.DataId := deposit.id;
      CStaticDeposit.Caption := deposit.GetElementText;
      CStaticDepositChanged(Nil);
    end;
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
  AAccepted := TCFrameForm.ShowFrame(TCDepositInvestmentFrame, ADataGid, AText);
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
var xNoncapInt: Currency;
begin
  Result := True;
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
      Result := CheckSurpassedLimits(IfThen(ComboBoxType.ItemIndex = 0, COutMovement, CInMovement), CDateTime.Value,
                                     TDataGids.CreateFromGid(CStaticAccount.DataId),
                                     TDataGids.CreateFromGid(CEmptyDataGid),
                                     TSumList.CreateWithSum(CStaticCategory.DataId, CCurrEditCash.Value, CStaticDepositCurrency.DataId));
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
    xDeposit := TDepositAdditionalData(AdditionalData).deposit;
    xAccount := TAccount(TAccount.LoadObject(AccountProxy, CStaticAccount.DataId, False));
    xProduct := TProduct(TProduct.LoadObject(ProductProxy, CStaticCategory.DataId, False));
    xBase := TBaseMovement.CreateObject(BaseMovementProxy, False);
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
    regDateTime := CDateTime.Value;
    regOrder := 0;
    description := RichEditDesc.Text;
    cash := CCurrEditCash.Value;
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

end.
