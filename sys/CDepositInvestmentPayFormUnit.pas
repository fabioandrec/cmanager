unit CDepositInvestmentPayFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, CComponents,
  ComCtrls, ActnList, XPStyleActnCtrls, ActnMan, CTools, CDatatools, CDatabase, CDataObjects;

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
    procedure InitializeForm; override;
  public
    destructor Destroy; override;
  end;

implementation

uses CConsts, CDescpatternFormUnit, CPreferences, CTemplates, CRichtext,
  CDepositInvestmentFrameUnit, CFrameFormUnit, CProductsFrameUnit,
  CAccountsFrameUnit, CCurrencyRateFrameUnit, Math;

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

end.
