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
    Label7: TLabel;
    CStaticPortfolio: TCStatic;
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
    procedure CStaticPortfolioChanged(Sender: TObject);
    procedure CStaticPortfolioGetDataId(var ADataGid, AText: String;
      var AAccepted: Boolean);
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
    procedure FillForm; override;
    function CanAccept: Boolean; override;
  public
    destructor Destroy; override;
    function ExpandTemplate(ATemplate: String): String; override;
  end;

implementation

uses CFrameFormUnit, CInstrumentFrameUnit, CInstrumentValueFrameUnit,
  CAccountsFrameUnit, CCurrencyRateFrameUnit, CProductsFrameUnit, CTools,
  CConsts, CInvestmentMovementFrameUnit, CConfigFormUnit,
  CDescpatternFormUnit, CPreferences, CTemplates, CRichtext, CInfoFormUnit,
  CInvestmentPortfolioFrameUnit;

{$R *.dfm}

procedure TCInvestmentMovementForm.CStaticInstrumentGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCInstrumentFrame, ADataGid, AText, TCInstrumentFrameAdditionalData.Create(True));
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
  UpdateDescription;
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
    CStaticInstrumentCurrency.Caption := GCurrencyCache.GetSymbol(xCurrencyId);
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
      xRate := TAccountCurrencyRule.FindRateByRule(GWorkDate,
                                                   IfThen(ComboBoxType.ItemIndex in [0, 2], CInvestmentBuyMovement, CInvestmentSellMovement),
                                                   CStaticInstrumentCurrency.DataId, CStaticAccountCurrency.DataId);
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
  CStaticCategory.Enabled := ComboBoxType.ItemIndex <= 1;
  CStaticCategory.HotTrack := CStaticCategory.Enabled;
  Label8.Enabled := CStaticCategory.Enabled;
  if not CStaticCategory.Enabled then begin
    CStaticCategory.DataId := CEmptyDataGid;
  end;
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
begin
  with TInvestmentMovement(Dataobject) do begin
    description := RichEditDesc.Text;
    movementType := IfThen(ComboBoxType.ItemIndex in [0, 2], CInvestmentBuyMovement, CInvestmentSellMovement);
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

function TCInvestmentMovementForm.ExpandTemplate(ATemplate: String): String;
begin
  Result := inherited ExpandTemplate(ATemplate);
  if ATemplate = '@dataoperacji@' then begin
    Result := GetFormattedDate(CDateTime.Value, 'yyyy-MM-dd');
  end else if ATemplate = '@rodzaj@' then begin
    Result := ComboBoxType.Text;
  end else if ATemplate = '@symbol@' then begin
    Result := '<symbol instrumentu>';
    if CStaticInstrument.DataId <> CEmptyDataGid then begin
      GDataProvider.BeginTransaction;
      Result := TInstrument(TInstrument.LoadObject(InstrumentProxy, CStaticInstrument.DataId, False)).symbol;
      GDataProvider.RollbackTransaction;
    end;
  end else if ATemplate = '@instrument@' then begin
    Result := '<instrument inwestycyjny>';
    if CStaticInstrument.DataId <> CEmptyDataGid then begin
      Result := CStaticInstrument.Caption;
    end;
  end else if ATemplate = '@dataczasoperacji@' then begin
    Result := GetFormattedDate(Now, 'yyyy-MM-dd') + ' ' + GetFormattedTime(Now, 'HH:mm');
  end else if ATemplate = '@konto@' then begin
    Result := '<konto>';
    if CStaticAccount.DataId <> CEmptyDataGid then begin
      Result := CStaticAccount.Caption;
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
  end;
end;

procedure TCInvestmentMovementForm.FillForm;
begin
  with TInvestmentMovement(Dataobject) do begin
    ComboBoxTemplate.ItemIndex := IfThen(Operation = coEdit, 0, 1);
    CDateTime.Value := regDateTime;
    if idProduct <> CEmptyDataGid then begin
      ComboBoxType.ItemIndex := IfThen(movementType = CInvestmentBuyMovement, 0, 1);
    end else begin
      ComboBoxType.ItemIndex := IfThen(movementType = CInvestmentBuyMovement, 2, 3);
    end;
    ComboBoxType.Enabled := False;
    SimpleRichText(description, RichEditDesc);
    CCurrEditQuantity.Value := quantity;
    CCurrEditValue.Value := valueOf;
    CCurrMovement.Value := summaryOf;
    CCurrEditAccount.Value := summaryOfAccount;
    GDataProvider.BeginTransaction;
    CStaticInstrument.DataId := idInstrument;
    CStaticInstrument.Caption := TInstrument(TInstrument.LoadObject(InstrumentProxy, idInstrument, False)).GetElementText;
    CStaticInstrumentCurrency.DataId := idInstrumentCurrencyDef;
    CStaticInstrumentCurrency.Caption := GCurrencyCache.GetIso(idInstrumentCurrencyDef);
    CCurrEditValue.SetCurrencyDef(idInstrumentCurrencyDef, GCurrencyCache.GetSymbol(idInstrumentCurrencyDef));
    CCurrMovement.SetCurrencyDef(idInstrumentCurrencyDef, GCurrencyCache.GetSymbol(idInstrumentCurrencyDef));
    CStaticAccount.DataId := idAccount;
    CStaticAccount.Caption := TAccount(TAccount.LoadObject(AccountProxy, idAccount, False)).GetElementText;
    CStaticAccountCurrency.DataId := idAccountCurrencyDef;
    CStaticAccountCurrency.Caption := GCurrencyCache.GetIso(idAccountCurrencyDef);
    CCurrEditAccount.SetCurrencyDef(idAccountCurrencyDef, GCurrencyCache.GetSymbol(idAccountCurrencyDef));
    CStaticCategory.DataId := idProduct;
    if idProduct <> CEmptyDataGid then begin
      CStaticCategory.Caption := TProduct(TProduct.LoadObject(ProductProxy, idProduct, False)).GetElementText;
    end;
    if idCurrencyRate <> CEmptyDataGid then begin
      CStaticCurrencyRate.DataId := idCurrencyRate;
      CStaticCurrencyRate.Caption := rateDescription;
      CStaticCurrencyRate.Enabled := True;
      Label22.Enabled := True;
    end;
    FRateHelper := TCurrencyRateHelper.Create(currencyQuantity, currencyRate, rateDescription, idAccountCurrencyDef, idInstrumentCurrencyDef);
    CStaticInstrumentValue.DataId := idInstrumentValue;
    if idInstrumentValue <> CEmptyDataGid then begin
      CStaticInstrumentValue.Caption := TInstrumentValue(TInstrumentValue.LoadObject(InstrumentValueProxy, idInstrumentValue, False)).GetElementText;
    end;
    GDataProvider.RollbackTransaction;
    ComboBoxTypeChange(Nil);
  end;
end;

function TCInvestmentMovementForm.CanAccept: Boolean;
var xIlosc: Integer;
    xInvestment: TInvestmentItem;
begin
  Result := True;
  if CStaticInstrument.DataId = CEmptyDataGid then begin
    Result := False;
    if ShowInfo(itQuestion, 'Nie wybrano instrumentu inwestycyjnego. Czy wyœwietliæ listê teraz ?', '') then begin
      CStaticInstrument.DoGetDataId;
    end;
  end else if CStaticAccount.DataId = CEmptyDataGid then begin
    Result := False;
    if ShowInfo(itQuestion, 'Nie wybrano konta operacji. Czy wyœwietliæ listê teraz ?', '') then begin
      CStaticAccount.DoGetDataId;
    end;
  end else if (CStaticCurrencyRate.DataId = CEmptyDataGid) and (CStaticCurrencyRate.Enabled) then begin
    Result := False;
    if ShowInfo(itQuestion, 'Nie wybrano przelicznika waluty. Czy wyœwietliæ listê teraz ?', '') then begin
      CStaticCurrencyRate.DoGetDataId;
    end;
  end else if CCurrEditQuantity.Value = 0 then begin
    Result := False;
    ShowInfo(itError, 'Iloœæ nie mo¿e byæ zerowa', '');
    CCurrEditQuantity.SetFocus;
  end else begin
    if (ComboBoxType.ItemIndex in [1, 3]) then begin
      Result := False;
      GDataProvider.BeginTransaction;
      xInvestment := TInvestmentItem.FindInvestmentItem(CStaticInstrument.DataId, CStaticAccount.DataId);
      if Operation = coEdit then begin
        if (CStaticAccount.DataId = TInvestmentMovement(Dataobject).idAccount) and
           (CStaticInstrument.DataId = TInvestmentMovement(Dataobject).idInstrument) then begin
          if xInvestment = Nil then begin
            xIlosc := 0;
          end else begin
            xIlosc := TInvestmentMovement(Dataobject).quantity + xInvestment.quantity;
            Result := CCurrEditQuantity.Value <= xIlosc;
          end;
        end else begin
          if xInvestment = Nil then begin
            xIlosc := 0;
          end else begin
            xIlosc := xInvestment.quantity;
            Result := CCurrEditQuantity.Value <= xIlosc;
          end;
        end;
      end else begin
        if xInvestment = Nil then begin
          xIlosc := 0;
        end else begin
          xIlosc := xInvestment.quantity;
          Result := CCurrEditQuantity.Value <= xIlosc;
        end;
      end;
      GDataProvider.RollbackTransaction;
      if not Result then begin
        if xIlosc = 0 then begin
          ShowInfo(itWarning, 'W portfelu inwestycyjnym "' + CStaticAccount.Caption + '" nie ma instrumentów "' + CStaticInstrument.Caption + '".', '');
        end else begin
          ShowInfo(itWarning, 'W portfelu inwestycyjnym "' + CStaticAccount.Caption + '" nie ma takiej iloœci instrumentów "' + CStaticInstrument.Caption + '".\n' +
                               'Maksymalna iloœæ wynosi ' + IntToStr(xIlosc) + '.', '');
        end;
      end;
    end;
  end;
  if Result and (ComboBoxType.ItemIndex in [0, 1]) and (CStaticCategory.DataId = CEmptyDataGid) then begin
    Result := False;
    if ShowInfo(itQuestion, 'Nie wybrano kategorii operacji. Czy wyœwietliæ listê teraz ?', '') then begin
      CStaticCategory.DoGetDataId;
    end;
  end;
end;

procedure TCInvestmentMovementForm.CStaticPortfolioChanged(Sender: TObject);
begin
  UpdateDescription;
end;

procedure TCInvestmentMovementForm.CStaticPortfolioGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
var xPortfolio: TInvestmentPortfolio;
    xAccount: TAccount;
    xInstrument: TInstrument;
begin
  AAccepted := TCFrameForm.ShowFrame(TCInvestmentPortfolioFrame, ADataGid, AText);
  if AAccepted then begin
    GDataProvider.BeginTransaction;
    xPortfolio := TInvestmentPortfolio(TInvestmentPortfolio.LoadObject(InvestmentPortfolioProxy, ADataGid, False));
    xAccount := TAccount(TAccount.LoadObject(AccountProxy, xPortfolio.idAccount, False));
    xInstrument := TInstrument(TInstrument.LoadObject(InstrumentProxy, xPortfolio.idInstrument, False));
    CStaticAccount.DataId := xAccount.id;
    CStaticAccount.Caption := xAccount.GetElementText;
    CStaticInstrument.DataId := xInstrument.id;
    CStaticInstrument.Caption := xInstrument.GetElementText;
    GDataProvider.RollbackTransaction;
    CStaticAccountChanged(Nil);
    CStaticInstrumentChanged(Nil);
  end;
end;

end.

