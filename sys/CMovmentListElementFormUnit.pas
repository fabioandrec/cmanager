unit CMovmentListElementFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  CComponents, CDatabase, CDataObjects, ActnList, XPStyleActnCtrls, ActnMan;

type
  TMovementListElement = class(TObject)
  private
    FIsNew: Boolean;
    Fid: TDataGid;
    FproductId: TDataGid;
    FmovementType: TBaseEnumeration;
    Fdescription: TBaseDescription;
    Fcash: Currency;
    FmovementCash: Currency;
    FidAccount: TDataGid;
    FidCashpoint: TDataGid;
    FdateTime: TDateTime;
    FidAccountCurrencyDef: TDataGid;
    FidMovementCurrencyDef: TDataGid;
    FidCurrencyRate: TDataGid;
    FcurrencyQuantity: Integer;
    FcurrencyRate: Currency;
    FrateDescription: TBaseDescription;
  public
    constructor Create;
  published
    property id: TDataGid read Fid write Fid;
    property productId: TDataGid read FproductId write FproductId;
    property movementType: TBaseEnumeration read FmovementType write FmovementType;
    property description: TBaseDescription read Fdescription write Fdescription;
    property cash: Currency read Fcash write Fcash;
    property movementCash: Currency read FmovementCash write FmovementCash;
    property idAccountCurrencyDef: TDataGid read FidAccountCurrencyDef write FidAccountCurrencyDef;
    property idMovementCurrencyDef: TDataGid read FidMovementCurrencyDef write FidMovementCurrencyDef;
    property idCurrencyRate: TDataGid read FidCurrencyRate write FidCurrencyRate;
    property currencyQuantity: Integer read FcurrencyQuantity write FcurrencyQuantity;
    property currencyRate: Currency read FcurrencyRate write FcurrencyRate;
    property rateDescription: TBaseDescription read FrateDescription write FrateDescription;
    property isNew: Boolean read FIsNew write FIsNew;
    property idAccount: TDataGid read FidAccount write FidAccount;
    property idCashpoint: TDataGid read FidCashpoint write FidCashpoint;
    property dateTime: TDateTime read FdateTime write FdateTime;
  end;

  TCMovmentListElementForm = class(TCConfigForm)
    GroupBox2: TGroupBox;
    RichEditDesc: TRichEdit;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    CStaticCategory: TCStatic;
    ActionManager: TActionManager;
    ActionAdd: TAction;
    ActionTemplate: TAction;
    CButton1: TCButton;
    CButton2: TCButton;
    ComboBoxTemplate: TComboBox;
    Label20: TLabel;
    CStaticMovementCurrency: TCStatic;
    Label1: TLabel;
    CCurrEditMovement: TCCurrEdit;
    Label22: TLabel;
    CStaticRate: TCStatic;
    Label17: TLabel;
    CStaticAccountCurrency: TCStatic;
    Label21: TLabel;
    CCurrEditAccount: TCCurrEdit;
    procedure CStaticCategoryChanged(Sender: TObject);
    procedure CStaticCategoryGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure ActionAddExecute(Sender: TObject);
    procedure ActionTemplateExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ComboBoxTemplateChange(Sender: TObject);
    procedure CStaticMovementCurrencyGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticMovementCurrencyChanged(Sender: TObject);
    procedure CStaticRateGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CCurrEditMovementChange(Sender: TObject);
    procedure CStaticRateChanged(Sender: TObject);
  private
    Felement: TMovementListElement;
    FRateHelper: TCurrencyRateHelper;
    function ChooseProduct(var AId, AText: String): Boolean;
    procedure UpdateAccountCurEdit(ARate: TCStatic; ASourceEdit, ATargetEdit: TCCurrEdit; AHelper: TCurrencyRateHelper);
  protected
    procedure FillForm; override;
    procedure ReadValues; override;
    function CanAccept: Boolean; override;
    procedure UpdateAccountCurDef(AAccountId: TDataGid; AStatic: TCStatic; ACurEdit: TCCurrEdit);
    procedure UpdateCurrencyRates(AUpdateCurEdit: Boolean = True);
  public
    procedure UpdateDescription;
    constructor CreateFormElement(AOwner: TComponent; AElement: TMovementListElement);
    function ExpandTemplate(ATemplate: String): String; override;
    destructor Destroy; override;
  end;

implementation

uses CConsts, CDatatools, CHelp, CFrameFormUnit, CProductsFrameUnit,
     CInfoFormUnit, Contnrs, CTemplates, CDescpatternFormUnit, Math,
     CPreferences, CRichtext, CDataobjectFrameUnit, CCurrencydefFrameUnit,
  CCurrencyRateFrameUnit, CSurpassedFormUnit;

{$R *.dfm}

procedure TCMovmentListElementForm.UpdateDescription;
var xDesc: String;
begin
  if ComboBoxTemplate.ItemIndex = 1 then begin
    xDesc := GDescPatterns.GetPattern(CDescPatternsKeys[3][0], '');
    if xDesc <> '' then begin
      xDesc := GBaseTemlatesList.ExpandTemplates(xDesc, Self);
      xDesc := GMovementListElementsTemplatesList.ExpandTemplates(xDesc, Self);
      SimpleRichText(xDesc, RichEditDesc);
    end;
  end;
end;

procedure TCMovmentListElementForm.CStaticCategoryChanged(Sender: TObject);
begin
  UpdateDescription;
end;

function TCMovmentListElementForm.ChooseProduct(var AId, AText: String): Boolean;
var xProd: String;
begin
  if Felement.movementType = COutMovement then begin
    xProd := COutProduct;
  end else begin
    xProd := CInProduct;
  end;
  Result := TCFrameForm.ShowFrame(TCProductsFrame, AId, AText, TCDataobjectFrameData.CreateWithFilter(xProd));
end;

procedure TCMovmentListElementForm.CStaticCategoryGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseProduct(ADataGid, AText);
end;

constructor TCMovmentListElementForm.CreateFormElement(AOwner: TComponent; AElement: TMovementListElement);
begin
  inherited Create(AOwner);
  Felement := AElement;
  FRateHelper := Nil;
end;

procedure TCMovmentListElementForm.FillForm;
var xProduct: TProduct;
begin
  inherited FillForm;
  ComboBoxTemplate.ItemIndex := IfThen(Operation = coEdit, 0, 1);
  CCurrEditAccount.SetCurrencyDef(Felement.idAccountCurrencyDef, GCurrencyCache.GetSymbol(Felement.idAccountCurrencyDef));
  CStaticAccountCurrency.DataId := Felement.idAccountCurrencyDef;
  CStaticAccountCurrency.Caption := GCurrencyCache.GetIso(Felement.idAccountCurrencyDef);
  CCurrEditMovement.SetCurrencyDef(Felement.idMovementCurrencyDef, GCurrencyCache.GetSymbol(Felement.idMovementCurrencyDef));
  CStaticMovementCurrency.DataId := Felement.idMovementCurrencyDef;
  CStaticMovementCurrency.Caption := GCurrencyCache.GetIso(Felement.idMovementCurrencyDef);
  if Operation = coEdit then begin
    FRateHelper := TCurrencyRateHelper.Create(Felement.currencyQuantity, Felement.currencyRate, Felement.rateDescription, Felement.idAccountCurrencyDef, Felement.idMovementCurrencyDef);
    CCurrEditMovement.Value := Felement.movementCash;
    CCurrEditAccount.Value := Felement.cash;
    SimpleRichText(Felement.description, RichEditDesc);
    CStaticCategory.DataId := Felement.productId;
    CStaticRate.DataId := Felement.idCurrencyRate;
    CStaticRate.Caption := Felement.rateDescription;
    GDataProvider.BeginTransaction;
    xProduct := TProduct(TProduct.LoadObject(ProductProxy, Felement.productId, False));
    CStaticCategory.Caption := xProduct.name;
    GDataProvider.RollbackTransaction;
    CStaticMovementCurrency.DataId := Felement.idMovementCurrencyDef;
    CStaticMovementCurrency.Caption := GCurrencyCache.GetIso(Felement.idMovementCurrencyDef);
  end;
  CStaticRate.Enabled := CStaticMovementCurrency.DataId <> CStaticAccountCurrency.DataId;
end;

procedure TCMovmentListElementForm.ReadValues;
begin
  inherited ReadValues;
  Felement.description := RichEditDesc.Text;
  Felement.productId := CStaticCategory.DataId;
  Felement.cash := CCurrEditAccount.Value;
  Felement.movementCash := CCurrEditMovement.Value;
  Felement.idMovementCurrencyDef := CStaticMovementCurrency.DataId;
  Felement.rateDescription := CStaticRate.Caption;
  if FRateHelper <> Nil then begin
    Felement.currencyQuantity := FRateHelper.quantity;
    Felement.currencyRate := FRateHelper.rate;
  end else begin
    Felement.currencyQuantity := 1;
    Felement.currencyRate := 1;
  end;
  Felement.idCurrencyRate := CStaticRate.DataId;
end;

function TCMovmentListElementForm.CanAccept: Boolean;
begin
  Result := True;
  if CStaticCategory.DataId = CEmptyDataGid then begin
    Result := False;
    if ShowInfo(itQuestion, 'Nie wybrano kategorii operacji. Czy wyœwietliæ listê teraz ?', '') then begin
      CStaticCategory.DoGetDataId;
    end;
  end else if CCurrEditAccount.Value = 0 then begin
    Result := False;
    ShowInfo(itError, 'Kwota operacji nie mo¿e byæ zerowa', '');
    CCurrEditAccount.SetFocus;
  end;
end;

constructor TMovementListElement.Create;
var xGuid: TGUID;
begin
  inherited Create;
  FIsNew := False;
  CreateGUID(xGuid);
  Fid := GUIDToString(xGuid);
end;

procedure TCMovmentListElementForm.ActionAddExecute(Sender: TObject);
var xData: TObjectList;
begin
  xData := TObjectList.Create(False);
  xData.Add(GBaseTemlatesList);
  xData.Add(GMovementListElementsTemplatesList);
  EditAddTemplate(xData, Self, RichEditDesc, True);
  xData.Free;
end;

procedure TCMovmentListElementForm.ActionTemplateExecute(Sender: TObject);
var xPattern: String;
begin
  if EditDescPattern(CDescPatternsKeys[3][IfThen(Felement.movementType = COutMovement, 0, 1)], xPattern) then begin
    UpdateDescription;
  end;
end;

function TCMovmentListElementForm.ExpandTemplate(ATemplate: String): String;
begin
  Result := inherited ExpandTemplate(ATemplate);
  if ATemplate = '@kategoria@' then begin
    Result := '<kategoria>';
    if CStaticCategory.DataId <> CEmptyDataGid then begin
      Result := CStaticCategory.Caption;
    end;
  end else if ATemplate = '@pelnakategoria@' then begin
    Result := '<pelnakategoria>';
    if CStaticCategory.DataId <> CEmptyDataGid then begin
      Result := TProduct(TProduct.LoadObject(ProductProxy, CStaticCategory.DataId, False)).treeDesc;
    end;
  end;
end;

procedure TCMovmentListElementForm.FormShow(Sender: TObject);
begin
  inherited;
  UpdateDescription;
end;

procedure TCMovmentListElementForm.ComboBoxTemplateChange(Sender: TObject);
begin
  UpdateDescription;
end;

procedure TCMovmentListElementForm.UpdateAccountCurDef(AAccountId: TDataGid; AStatic: TCStatic; ACurEdit: TCCurrEdit);
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

procedure TCMovmentListElementForm.CStaticMovementCurrencyGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCCurrencydefFrame, ADataGid, AText);
end;

procedure TCMovmentListElementForm.CStaticMovementCurrencyChanged(Sender: TObject);
begin
  CStaticRate.DataId := CEmptyDataGid;
  UpdateCurrencyRates;
  CCurrEditMovement.SetCurrencyDef(CStaticMovementCurrency.DataId, GCurrencyCache.GetSymbol(CStaticMovementCurrency.DataId));
end;

procedure TCMovmentListElementForm.UpdateCurrencyRates(AUpdateCurEdit: Boolean = True);
begin
  CStaticRate.Enabled :=
    (CStaticAccountCurrency.DataId <> CStaticMovementCurrency.DataId) and
    (CStaticMovementCurrency.DataId <> CEmptyDataGid) and
    (CStaticAccountCurrency.DataId <> CEmptyDataGid);
  CStaticRate.HotTrack := CStaticRate.Enabled;
  Label22.Enabled := CStaticRate.Enabled;
  Label17.Enabled := CStaticRate.Enabled;
  Label21.Enabled := CStaticRate.Enabled;
  if AUpdateCurEdit then begin
    UpdateAccountCurEdit(CStaticRate, CCurrEditMovement, CCurrEditAccount, FRateHelper);
  end;
end;

procedure TCMovmentListElementForm.UpdateAccountCurEdit(ARate: TCStatic; ASourceEdit, ATargetEdit: TCCurrEdit; AHelper: TCurrencyRateHelper);
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

destructor TCMovmentListElementForm.Destroy;
begin
  if FRateHelper <> Nil then begin
    FRateHelper.Free;
  end;
  inherited Destroy;
end;

procedure TCMovmentListElementForm.CStaticRateGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
var xCurrencyRate: TCurrencyRate;
begin
  AAccepted := TCFrameForm.ShowFrame(TCCurrencyRateFrame, ADataGid, AText, TRateFrameAdditionalData.CreateRateData(CStaticAccountCurrency.DataId, CStaticMovementCurrency.DataId));
  if AAccepted then begin
    xCurrencyRate := TCurrencyRate(TCurrencyRate.LoadObject(CurrencyRateProxy, ADataGid, False));
    if FRateHelper = Nil then begin
      FRateHelper := TCurrencyRateHelper.Create(xCurrencyRate.quantity, xCurrencyRate.rate, xCurrencyRate.description, xCurrencyRate.idSourceCurrencyDef, xCurrencyRate.idTargetCurrencyDef);
    end else begin
      FRateHelper.Assign(xCurrencyRate.quantity, xCurrencyRate.rate, xCurrencyRate.description, xCurrencyRate.idSourceCurrencyDef, xCurrencyRate.idTargetCurrencyDef);
    end;
  end;
end;

procedure TCMovmentListElementForm.CCurrEditMovementChange(Sender: TObject);
begin
  UpdateAccountCurEdit(CStaticRate, CCurrEditMovement, CCurrEditAccount, FRateHelper);
end;

procedure TCMovmentListElementForm.CStaticRateChanged(Sender: TObject);
begin
  UpdateCurrencyRates;
end;

end.
