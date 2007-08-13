unit CProfileFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  CComponents, CDatabase, CBaseFrameUnit;

type
  TCProfileForm = class(TCDataobjectForm)
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    EditName: TEdit;
    RichEditDesc: TCRichEdit;
    GroupBox1: TGroupBox;
    Label14: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    CStaticAccount: TCStatic;
    CStaticCashpoint: TCStatic;
    CStaticProducts: TCStatic;
    procedure CStaticCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticProductsGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
  protected
    procedure ReadValues; override;
    function GetDataobjectClass: TDataObjectClass; override;
    procedure FillForm; override;
    function CanAccept: Boolean; override;
    function GetUpdateFrameClass: TCBaseFrameClass; override;
  end;

implementation

uses CDataObjects, CInfoFormUnit, CFrameFormUnit, CCashpointsFrameUnit,
  CAccountsFrameUnit, CProductsFrameUnit, CProfileFrameUnit, CConsts,
  CDatatools, CRichtext, CTools;

{$R *.dfm}

function TCProfileForm.CanAccept: Boolean;
begin
  Result := inherited CanAccept;
  if Trim(EditName.Text) = '' then begin
    Result := False;
    ShowInfo(itError, 'Nazwa profilu nie mo¿e byæ pusta', '');
    EditName.SetFocus;
  end;
end;

procedure TCProfileForm.FillForm;
begin
  with TProfile(Dataobject) do begin
    EditName.Text := name;
    SimpleRichText(description, RichEditDesc);
    if idAccount <> CEmptyDataGid then begin
      CStaticAccount.Caption := TAccount(TAccount.LoadObject(AccountProxy, idAccount, False)).name;
      CStaticAccount.DataId := idAccount;
    end;
    if idCashPoint <> CEmptyDataGid then begin
      CStaticCashpoint.Caption := TCashPoint(TCashPoint.LoadObject(CashPointProxy, idCashPoint, False)).name;
      CStaticCashpoint.DataId := idCashPoint;
    end;
    if idProduct <> CEmptyDataGid then begin
      CStaticProducts.Caption := TProduct(TProduct.LoadObject(ProductProxy, idProduct, False)).name;
      CStaticProducts.DataId := idProduct;
    end;
  end;
end;

function TCProfileForm.GetDataobjectClass: TDataObjectClass;
begin
  Result := TProfile;
end;

procedure TCProfileForm.ReadValues;
begin
  inherited ReadValues;
  with TProfile(Dataobject) do begin
    name := EditName.Text;
    description := RichEditDesc.Text;
    idAccount := CStaticAccount.DataId;
    idCashPoint := CStaticCashpoint.DataId;
    idProduct := CStaticProducts.DataId;
  end;
end;

procedure TCProfileForm.CStaticCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCCashpointsFrame, ADataGid, AText);
end;

procedure TCProfileForm.CStaticAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCAccountsFrame, ADataGid, AText);
end;

procedure TCProfileForm.CStaticProductsGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCProductsFrame, ADataGid, AText);
end;

function TCProfileForm.GetUpdateFrameClass: TCBaseFrameClass;
begin
  Result := TCProfileFrame;
end;

end.
 