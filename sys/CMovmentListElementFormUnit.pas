unit CMovmentListElementFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  CComponents, CDatabase, CDataObjects;

type
  TMovementListElement = class(TObject)
  private
    Fid: TDataGid;
    FproductId: TDataGid;
    FmovementType: TBaseEnumeration;
    Fdescription: TBaseDescription;
    Fcash: Currency;
  public
    constructor Create;
  published
    property id: TDataGid read Fid write Fid;
    property productId: TDataGid read FproductId write FproductId;
    property movementType: TBaseEnumeration read FmovementType write FmovementType;
    property description: TBaseDescription read Fdescription write Fdescription;
    property cash: Currency read Fcash write Fcash;
  end;

  TCMovmentListElementForm = class(TCConfigForm)
    GroupBox2: TGroupBox;
    RichEditDesc: TRichEdit;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    Label9: TLabel;
    CStaticCategory: TCStatic;
    CCurrEdit: TCCurrEdit;
    procedure CStaticCategoryChanged(Sender: TObject);
    procedure CStaticCategoryGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
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
  end;

implementation

uses CConsts, CDatatools, CHelp, CFrameFormUnit, CProductsFrameUnit,
     CInfoFormUnit;

{$R *.dfm}

procedure TCMovmentListElementForm.UpdateDescription;
begin
  //TODO
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
  Result := TCFrameForm.ShowFrame(TCProductsFrame, AId, AText, TProductsFrameAdditionalData.Create(xProd));
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
  if Operation = coEdit then begin
    RichEditDesc.Text := Felement.description;
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

end.
