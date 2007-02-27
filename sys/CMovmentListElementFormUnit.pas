unit CMovmentListElementFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  CComponents, CDatabase, CDataObjects;

type
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
    FmovementType: TBaseEnumeration;
    function ChooseProduct(var AId, AText: String): Boolean;
  public
    procedure UpdateDescription;
  end;

implementation

uses CConsts, CDatatools, CHelp, CFrameFormUnit, CProductsFrameUnit;

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
  if FmovementType = COutMovement then begin
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

end.
