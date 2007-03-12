unit CProductFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, ComCtrls, CDatabase,
  CBaseFrameUnit;

type
  TCProductAdditionalData = class(TAdditionalData)
  private
    FParentGid: TDataGid;
    FProductType: String;
  public
    constructor Create(AParentGid: TDataGid; AProductType: String);
  published
    property ParentGid: TDataGid read FParentGid;
    property ProductType: String read FProductType;
  end;

  TCProductForm = class(TCDataobjectForm)
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    EditName: TEdit;
    RichEditDesc: TRichEdit;
    GroupBoxAccountType: TGroupBox;
    ComboBoxType: TComboBox;
  protected
    procedure ReadValues; override;
    function GetDataobjectClass: TDataObjectClass; override;
    procedure FillForm; override;
    function CanAccept: Boolean; override;
    procedure InitializeForm; override;
    function GetUpdateFrameClass: TCBaseFrameClass; override;
  end;

implementation

uses CDataObjects, CInfoFormUnit, CConsts, CProductsFrameUnit, CRichtext;

{$R *.dfm}

function TCProductForm.CanAccept: Boolean;
begin
  Result := inherited CanAccept;
  if Trim(EditName.Text) = '' then begin
    Result := False;
    ShowInfo(itError, 'Nazwa kategorii nie mo¿e byæ pusta', '');
    EditName.SetFocus;
  end;
end;

procedure TCProductForm.FillForm;
begin
  with TProduct(Dataobject) do begin
    EditName.Text := name;
    SimpleRichText(description, RichEditDesc);
    if productType = CInProduct then begin
      ComboBoxType.ItemIndex := 1;
    end else begin
      ComboBoxType.ItemIndex := 0;
    end;
  end;
end;

function TCProductForm.GetDataobjectClass: TDataObjectClass;
begin
  Result := TProduct;
end;

function TCProductForm.GetUpdateFrameClass: TCBaseFrameClass;
begin
  Result := TCProductsFrame;
end;

procedure TCProductForm.InitializeForm;
var xIdParent: TDataGid;
    xProductType: String;
    xProd: TProduct;
begin
  inherited InitializeForm;
  ComboBoxType.Enabled := AdditionalData = Nil;
  if AdditionalData <> Nil then begin
    xIdParent := TCProductAdditionalData(AdditionalData).ParentGid;
    xProductType := TCProductAdditionalData(AdditionalData).ProductType;
    if xIdParent <> '' then begin
      xProd := TProduct(TProduct.LoadObject(ProductProxy, xIdParent, True));
      if xProd.productType = CInProduct then begin
        ComboBoxType.ItemIndex := 1;
      end else begin
        ComboBoxType.ItemIndex := 0;
      end;
      xProd.Free;
    end else if xProductType <> '' then begin
      if xProductType = CInProduct then begin
        ComboBoxType.ItemIndex := 1;
      end else begin
        ComboBoxType.ItemIndex := 0;
      end;
    end;
  end;
end;

procedure TCProductForm.ReadValues;
begin
  inherited ReadValues;
  with TProduct(Dataobject) do begin
    name := EditName.Text;
    description := RichEditDesc.Text;
    if ComboBoxType.ItemIndex = 0 then begin
      productType := COutProduct;
    end else begin
      productType := CInProduct;
    end;
    if AdditionalData <> Nil then begin
      idParentProduct := TCProductAdditionalData(AdditionalData).ParentGid;
    end;
  end;
end;

constructor TCProductAdditionalData.Create(AParentGid: TDataGid; AProductType: String);
begin
  inherited Create;
  FParentGid := AParentGid;
  FProductType := AProductType;
end;

end.
