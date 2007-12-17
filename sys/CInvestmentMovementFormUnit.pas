unit CInvestmentMovementFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, CComponents,
  ComCtrls, ActnList, XPStyleActnCtrls, ActnMan, Math, StrUtils, CDataObjects,
  CDatabase, CBaseFrameUnit, Contnrs;

type
  TCInvestmentMovementForm = class(TCDataobjectForm)
    GroupBox1: TGroupBox;
    Label5: TLabel;
    ComboBoxType: TComboBox;
    Label3: TLabel;
    CDateTime: TCDateTime;
    ActionManager: TActionManager;
    ActionAdd: TAction;
    ActionTemplate: TAction;
    GroupBox2: TGroupBox;
    CButton1: TCButton;
    CButton2: TCButton;
    RichEditDesc: TCRichedit;
    ComboBoxTemplate: TComboBox;
    GroupBox3: TGroupBox;
    Label4: TLabel;
    CStaticAccount: TCStatic;
    Label1: TLabel;
    CStaticInstrument: TCStatic;
    Label15: TLabel;
    CCurrEditQuantity: TCCurrEdit;
    Label2: TLabel;
    CStaticInstrumentValue: TCStatic;
    Label6: TLabel;
    CCurrEditValue: TCCurrEdit;
    Label9: TLabel;
    CCurrMovement: TCCurrEdit;
    Label8: TLabel;
    CStaticCategory: TCStatic;
    Label20: TLabel;
    CStaticInstrumentCurrency: TCStatic;
    Label22: TLabel;
    CStaticCurrencyRate: TCStatic;
    Label17: TLabel;
    CStaticAccountCurrency: TCStatic;
    Label21: TLabel;
    CCurrEditAccount: TCCurrEdit;
    procedure CStaticInstrumentGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticInstrumentValueGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticCategoryGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticCurrencyRateGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticAccountChanged(Sender: TObject);
    procedure CStaticInstrumentChanged(Sender: TObject);
    procedure ComboBoxTypeChange(Sender: TObject);
    procedure CCurrEditQuantityChange(Sender: TObject);
    procedure CCurrEditValueChange(Sender: TObject);
    procedure CStaticCurrencyRateChanged(Sender: TObject);
    procedure CStaticInstrumentValueChanged(Sender: TObject);
    procedure CDateTimeChanged(Sender: TObject);
    procedure CStaticInstrumentCurrencyChanged(Sender: TObject);
    procedure CStaticAccountCurrencyChanged(Sender: TObject);
    procedure CStaticCategoryChanged(Sender: TObject);
    procedure ActionAddExecute(Sender: TObject);
    procedure ActionTemplateExecute(Sender: TObject);
  private
    FRateHelper: TCurrencyRateHelper;
    procedure UpdateCurrencyInstrument;
    procedure UpdateOverallSum;
    procedure UpdateCurrencyRates(AUpdateCurEdit: Boolean = True);
    procedure UpdateAccountCurEdit(ARate: TCStatic; ASourceEdit, ATargetEdit: TCCurrEdit; AHelper: TCurrencyRateHelper);
  protected
    procedure InitializeForm; override;
    procedure ReadValues; override;
    function GetDataobjectClass: TDataObjectClass; override;
    function GetUpdateFrameClass: TCBaseFrameClass; override;
    procedure UpdateDescription;
  public
    destructor Destroy; override;
  end;

implementation

uses CFrameFormUnit, CInstrumentFrameUnit, CInstrumentValueFrameUnit,
  CAccountsFrameUnit, CCurrencyRateFrameUnit, CProductsFrameUnit, CTools,
  CConsts, CInvestmentMovementFrameUnit, CConfigFormUnit,
  CDescpatternFormUnit, CPreferences, CTemplates, CRichtext;

{$R *.dfm}

procedure TCInvestmentMovementForm.CStaticInstrumentGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCInstrumentFrame, ADataGid, AText);
end;

procedure TCInvestmentMovementForm.CStaticInstrumentValueGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCInstrumentValueFrame, ADataGid, AText);
end;

procedure TCInvestmentMovementForm.CStaticAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCAccountsFrame, ADataGid, AText);
end;

procedure TCInvestmentMovementForm.CStaticCategoryGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCProductsFrame, ADataGid, AText);
end;

procedure TCInvestmentMovementForm.CStaticCurrencyRateGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
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

procedure TCInvestmentMovementForm.CStaticAccountChanged(Sender: TObject);
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

procedure TCInvestmentMovementForm.InitializeForm;
begin
  inherited InitializeForm;
  FRateHelper := nil;
  CStaticAccountCurrency.DataId := CEmptyDataGid;
  CCurrEditAccount.SetCurrencyDef(CEmptyDataGid, '');
  CStaticInstrument.DataId := CEmptyDataGid;
  CCurrEditQuantity.SetCurrencyDef(CEmptyDataGid, '');
  UpdateCurrencyInstrument;
  UpdateCurrencyRates;
  CDateTime.Value := Now;
end;

procedure TCInvestmentMovementForm.CStaticInstrumentChanged(Sender: TObject);
begin
  UpdateCurrencyInstrument;
  CStaticCurrencyRate.DataId := CEmptyDataGid;
  UpdateCurrencyRates;
  UpdateDescription;
end;

procedure TCInvestmentMovementForm.UpdateCurrencyInstrument;
var xCurrencyId: TDataGid;
begin
  if CStaticInstrument.DataId <> CEmptyDataGid then begin
    xCurrencyId := TInstrument.GetCurrencyDefinition(CStaticInstrument.DataId);
    CStaticInstrumentCurrency.DataId := xCurrencyId;
    CStaticInstrumentCurrency.Caption := GCurrencyCache.GetIso(xCurrencyId);
    CCurrEditValue.SetCurrencyDef(xCurrencyId, GCurrencyCache.GetSymbol(xCurrencyId));
    CCurrMovement.SetCurrencyDef(xCurrencyId, GCurrencyCache.GetSymbol(xCurrencyId));
  end else begin
    CStaticInstrumentCurrency.DataId := CEmptyDataGid;
    CCurrEditValue.SetCurrencyDef(CEmptyDataGid, '');
    CCurrMovement.SetCurrencyDef(CEmptyDataGid, '');
  end;
end;

procedure TCInvestmentMovementForm.UpdateCurrencyRates(AUpdateCurEdit: Boolean);
var xRate: TCurrencyRate;
begin
  if not (csLoading in ComponentState) then begin
    CStaticCurrencyRate.Enabled :=
      (CStaticInstrumentCurrency.DataId <> CStaticAccountCurrency.DataId) and
      (CStaticInstrumentCurrency.DataId <> CEmptyDataGid) and
      (CStaticAccountCurrency.DataId <> CEmptyDataGid);
    CStaticCurrencyRate.HotTrack := CStaticCurrencyRate.Enabled;
    Label22.Enabled := CStaticCurrencyRate.Enabled;
    Label17.Enabled := CStaticCurrencyRate.Enabled;
    Label21.Enabled := CStaticCurrencyRate.Enabled;
    if CStaticCurrencyRate.Enabled then begin
      GDataProvider.BeginTransaction;
      xRate := TAccountCurrencyRule.FindRateByRule(GWorkDate, IfThen(ComboBoxType.ItemIndex = 0, COutMovement, CInMovement), CStaticInstrumentCurrency.DataId, CStaticAccountCurrency.DataId);
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
      UpdateAccountCurEdit(CStaticCurrencyRate, CCurrMovement, CCurrEditAccount, FRateHelper);
    end;
  end;
end;

procedure TCInvestmentMovementForm.UpdateAccountCurEdit(ARate: TCStatic; ASourceEdit, ATargetEdit: TCCurrEdit; AHelper: TCurrencyRateHelper);
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

procedure TCInvestmentMovementForm.ComboBoxTypeChange(Sender: TObject);
begin
  UpdateCurrencyRates;
  UpdateDescription;
end;

procedure TCInvestmentMovementForm.CCurrEditQuantityChange(Sender: TObject);
begin
  UpdateOverallSum;
end;

procedure TCInvestmentMovementForm.UpdateOverallSum;
begin
  if not (csLoading in ComponentState) then begin
    if (CCurrEditQuantity.Value <> 0) and (CCurrEditValue.Value <> 0) then begin
      CCurrMovement.Value := SimpleRoundTo(CCurrEditQuantity.Value * CCurrEditValue.Value, -2);
    end else begin
      CCurrMovement.Value := 0;
    end;
  end;
  UpdateCurrencyRates;
end;

procedure TCInvestmentMovementForm.CCurrEditValueChange(Sender: TObject);
begin
  UpdateOverallSum;
end;

procedure TCInvestmentMovementForm.CStaticCurrencyRateChanged(Sender: TObject);
begin
  UpdateCurrencyRates;
  UpdateDescription;
end;

destructor TCInvestmentMovementForm.Destroy;
begin
  if FRateHelper <> Nil then begin
    FRateHelper.Free;
  end;
  inherited Destroy;
end;

procedure TCInvestmentMovementForm.CStaticInstrumentValueChanged(Sender: TObject);
var xValueOf: Currency;
begin
  if CStaticInstrumentValue.DataId <> CEmptyDataGid then begin
    GDataProvider.BeginTransaction;
    xValueOf := TInstrumentValue(TInstrumentValue.LoadObject(InstrumentValueProxy, CStaticInstrumentValue.DataId, False)).valueOf;
    GDataProvider.RollbackTransaction;
    CCurrEditValue.Value := xValueOf;
  end else begin
    CCurrEditValue.Value := 0;
  end;
  UpdateOverallSum;
  UpdateDescription;  
end;

procedure TCInvestmentMovementForm.ReadValues;
var xInvestmentItem: TInvestmentItem;
begin
  with TInvestmentMovement(Dataobject) do begin
    description := RichEditDesc.Text;
    movementType := IfThen(ComboBoxType.ItemIndex = 0, COutMovement, CInMovement);
    regDateTime := CDateTime.Value;
    idInstrument := CStaticInstrument.DataId;
    idInstrumentCurrencyDef := CStaticInstrumentCurrency.DataId;
    quantity := Trunc(CCurrEditQuantity.Value);
    idInstrumentValue := CStaticInstrumentValue.DataId;
    valueOf := CCurrEditValue.Value;
    summaryOf := CCurrMovement.Value;
    idAccount := CStaticAccount.DataId;
    idAccountCurrencyDef := CStaticAccountCurrency.DataId;
    summaryOfAccount := CCurrEditAccount.Value;
    valueOfAccount := SimpleRoundTo(summaryOfAccount / quantity, -4);
    idProduct := CStaticCategory.DataId;
    idCurrencyRate := CStaticCurrencyRate.DataId;
    if Operation = coAdd then begin
      xInvestmentItem := TInvestmentItem.CreateObject(InvestmentItemProxy, False);
      idInvestmentItem := xInvestmentItem.id;
    end else begin
      xInvestmentItem := TInvestmentItem(TInvestmentItem.LoadObject(InvestmentItemProxy, idInvestmentItem, False));
    end;
    xInvestmentItem.idAccount := idAccount;
    xInvestmentItem.idInstrument := idInstrument;
    xInvestmentItem.quantity := quantity;
    xInvestmentItem.buyPrice := valueOf;
    xInvestmentItem.regDateTime := regDateTime;
    idBaseMovement := CEmptyDataGid;
  end;
end;

function TCInvestmentMovementForm.GetDataobjectClass: TDataObjectClass;
begin
  Result := TInvestmentMovement;
end;

function TCInvestmentMovementForm.GetUpdateFrameClass: TCBaseFrameClass;
begin
  Result := TCInvestmentMovementFrame;
end;

procedure TCInvestmentMovementForm.CDateTimeChanged(Sender: TObject);
begin
  UpdateDescription;
end;

procedure TCInvestmentMovementForm.UpdateDescription;
var xDesc: String;
begin
  if ComboBoxTemplate.ItemIndex = 1 then begin
    xDesc := GDescPatterns.GetPattern(CDescPatternsKeys[8][ComboBoxType.ItemIndex], '');
    if xDesc <> '' then begin
      xDesc := GBaseTemlatesList.ExpandTemplates(xDesc, Self);
      xDesc := GInvestmentMovementTemplatesList.ExpandTemplates(xDesc, Self);
      SimpleRichText(xDesc, RichEditDesc);
    end;
  end;
end;

procedure TCInvestmentMovementForm.CStaticInstrumentCurrencyChanged(Sender: TObject);
begin
  UpdateDescription;
end;

procedure TCInvestmentMovementForm.CStaticAccountCurrencyChanged(Sender: TObject);
begin
  UpdateDescription;
end;

procedure TCInvestmentMovementForm.CStaticCategoryChanged(Sender: TObject);
begin
  UpdateDescription;
end;

procedure TCInvestmentMovementForm.ActionAddExecute(Sender: TObject);
var xData: TObjectList;
begin
  xData := TObjectList.Create(False);
  xData.Add(GBaseTemlatesList);
  xData.Add(GInvestmentMovementTemplatesList);
  EditAddTemplate(xData, Self, RichEditDesc, True);
  xData.Free;
end;

procedure TCInvestmentMovementForm.ActionTemplateExecute(Sender: TObject);
var xPattern: String;
begin
  if EditDescPattern(CDescPatternsKeys[8][ComboBoxType.ItemIndex], xPattern) then begin
    UpdateDescription;
  end;
end;

end.

