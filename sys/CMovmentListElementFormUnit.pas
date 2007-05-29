unit CMovmentListElementFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  CComponents, CDatabase, CDataObjects, ActnList, XPStyleActnCtrls, ActnMan;

type
  TMovementListElement = class(TObject)
  private
    Fid: TDataGid;
    FproductId: TDataGid;
    FmovementType: TBaseEnumeration;
    Fdescription: TBaseDescription;
    Fcash: Currency;
    FmovementCash: Currency;
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
  end;

  TCMovmentListElementForm = class(TCConfigForm)
    GroupBox2: TGroupBox;
    RichEditDesc: TRichEdit;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    Label9: TLabel;
    CStaticCategory: TCStatic;
    CCurrEdit: TCCurrEdit;
    ActionManager: TActionManager;
    ActionAdd: TAction;
    ActionTemplate: TAction;
    CButton1: TCButton;
    CButton2: TCButton;
    ComboBoxTemplate: TComboBox;
    procedure CStaticCategoryChanged(Sender: TObject);
    procedure CStaticCategoryGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure ActionAddExecute(Sender: TObject);
    procedure ActionTemplateExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ComboBoxTemplateChange(Sender: TObject);
  private
    Felement: TMovementListElement;
    function ChooseProduct(var AId, AText: String): Boolean;
  protected
    procedure FillForm; override;
    procedure ReadValues; override;
    function CanAccept: Boolean; override;
  public
    procedure UpdateDescription;
    constructor CreateFormElement(AOwner: TComponent; AElement: TMovementListElement);
    function ExpandTemplate(ATemplate: String): String; override;
  end;

implementation

uses CConsts, CDatatools, CHelp, CFrameFormUnit, CProductsFrameUnit,
     CInfoFormUnit, Contnrs, CTemplates, CDescpatternFormUnit, Math,
     CPreferences, CRichtext, CDataobjectFrameUnit;

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
end;

procedure TCMovmentListElementForm.FillForm;
var xProduct: TProduct;
begin
  inherited FillForm;
  ComboBoxTemplate.ItemIndex := IfThen(Operation = coEdit, 0, 1);
  CCurrEdit.SetCurrencyDef(Felement.idCurrencyDef, GCurrencyCache.GetSymbol(Felement.idCurrencyDef));
  if Operation = coEdit then begin
    AssignRichText(Felement.description, RichEditDesc);
    CCurrEdit.Value := Felement.cash;
    CStaticCategory.DataId := Felement.productId;
    GDataProvider.BeginTransaction;
    xProduct := TProduct(TProduct.LoadObject(ProductProxy, Felement.productId, False));
    CStaticCategory.Caption := xProduct.name;
    GDataProvider.RollbackTransaction;
  end;
end;

procedure TCMovmentListElementForm.ReadValues;
begin
  inherited ReadValues;
  Felement.description := RichEditDesc.Text;
  Felement.productId := CStaticCategory.DataId;
  Felement.cash := CCurrEdit.Value;
end;

function TCMovmentListElementForm.CanAccept: Boolean;
begin
  Result := True;
  if CStaticCategory.DataId = CEmptyDataGid then begin
    Result := False;
    if ShowInfo(itQuestion, 'Nie wybrano kategorii operacji. Czy wyœwietliæ listê teraz ?', '') then begin
      CStaticCategory.DoGetDataId;
    end;
  end else if CCurrEdit.Value = 0 then begin
    Result := False;
    ShowInfo(itError, 'Kwota operacji nie mo¿e byæ zerowa', '');
    CCurrEdit.SetFocus;
  end;
end;

constructor TMovementListElement.Create;
var xGuid: TGUID;
begin
  inherited Create;
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

end.
