unit CQuickpatternFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  CComponents, CDatabase, CBaseFrameUnit;

type
  TCQuickpatternForm = class(TCDataobjectForm)
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
    Label5: TLabel;
    ComboBoxType: TComboBox;
    Label6: TLabel;
    CStaticDestAccount: TCStatic;
    procedure CStaticCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticProductsGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure ComboBoxTypeChange(Sender: TObject);
  protected
    procedure ReadValues; override;
    function GetDataobjectClass: TDataObjectClass; override;
    procedure FillForm; override;
    function CanAccept: Boolean; override;
    function GetUpdateFrameClass: TCBaseFrameClass; override;
    procedure InitializeForm; override;
    procedure UpdateFrames(ADataGid: ShortString; AMessage: Integer; AOption: Integer); override;
  end;

implementation

uses CDataObjects, CInfoFormUnit, CFrameFormUnit, CCashpointsFrameUnit,
  CAccountsFrameUnit, CProductsFrameUnit, CConsts,
  CDatatools, CRichtext, CTools, CQuickpatternFrameUnit, StrUtils,
  CMovementFrameUnit;

{$R *.dfm}

function TCQuickpatternForm.CanAccept: Boolean;
begin
  Result := inherited CanAccept;
  if Trim(EditName.Text) = '' then begin
    Result := False;
    ShowInfo(itError, 'Nazwa szybkiej operacji nie mo¿e byæ pusta', '');
    EditName.SetFocus;
  end;
end;

procedure TCQuickpatternForm.FillForm;
begin
  with TQuickPattern(Dataobject) do begin
    EditName.Text := name;
    SimpleRichText(description, RichEditDesc);
    if movementType = CInMovement then begin
      ComboBoxType.ItemIndex := 1;
    end else if movementType = COutMovement then begin
      ComboBoxType.ItemIndex := 0;
    end else begin
      ComboBoxType.ItemIndex := 2;
    end;
    ComboBoxTypeChange(Nil);
    if movementType = CTransferMovement then begin
      if idSourceAccount <> CEmptyDataGid then begin
        CStaticAccount.Caption := TAccount(TAccount.LoadObject(AccountProxy, idSourceAccount, False)).name;
        CStaticAccount.DataId := idSourceAccount;
      end;
      if idAccount <> CEmptyDataGid then begin
        CStaticDestAccount.Caption := TAccount(TAccount.LoadObject(AccountProxy, idAccount, False)).name;
        CStaticDestAccount.DataId := idAccount;
      end;
    end else begin
      if idAccount <> CEmptyDataGid then begin
        CStaticAccount.Caption := TAccount(TAccount.LoadObject(AccountProxy, idAccount, False)).name;
        CStaticAccount.DataId := idAccount;
      end;
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

function TCQuickpatternForm.GetDataobjectClass: TDataObjectClass;
begin
  Result := TQuickPattern;
end;

procedure TCQuickpatternForm.ReadValues;
begin
  inherited ReadValues;
  with TQuickPattern(Dataobject) do begin
    name := EditName.Text;
    description := RichEditDesc.Text;
    if ComboBoxType.ItemIndex = 0 then begin
      movementType := COutMovement;
    end else if ComboBoxType.ItemIndex = 1 then begin
      movementType := CInMovement;
    end else begin
      movementType := CTransferMovement;
    end;
    if movementType = CTransferMovement then begin
      idSourceAccount := CStaticAccount.DataId;
      idAccount := CStaticDestAccount.DataId;
    end else begin
      idAccount := CStaticAccount.DataId;
    end;
    idCashPoint := CStaticCashpoint.DataId;
    idProduct := CStaticProducts.DataId;
  end;
end;

procedure TCQuickpatternForm.CStaticCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCCashpointsFrame, ADataGid, AText);
end;

procedure TCQuickpatternForm.CStaticAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCAccountsFrame, ADataGid, AText);
end;

procedure TCQuickpatternForm.CStaticProductsGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCProductsFrame, ADataGid, AText);
end;

function TCQuickpatternForm.GetUpdateFrameClass: TCBaseFrameClass;
begin
  Result := TCQuickpatternFrame;
end;

procedure TCQuickpatternForm.ComboBoxTypeChange(Sender: TObject);
begin
  CStaticCashpoint.Visible := ComboBoxType.ItemIndex <> 2;
  CStaticProducts.Visible := ComboBoxType.ItemIndex <> 2;
  Label3.Visible := ComboBoxType.ItemIndex <> 2;
  Label4.Visible := ComboBoxType.ItemIndex <> 2;
  CStaticDestAccount.Visible := ComboBoxType.ItemIndex = 2;
  Label6.Visible := ComboBoxType.ItemIndex = 2;
end;

procedure TCQuickpatternForm.InitializeForm;
begin
  inherited InitializeForm;
  ComboBoxTypeChange(Nil);
end;

procedure TCQuickpatternForm.UpdateFrames(ADataGid: ShortString; AMessage, AOption: Integer);
begin
  inherited UpdateFrames(ADataGid, AMessage, AOption);
  SendMessageToFrames(TCMovementFrame, WM_NOTIFYMESSAGE, 0, WMOPT_REFRESHQUICKPATTERNS);
end;

end.
 