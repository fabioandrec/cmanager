unit CInvestmentWalletFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  ImgList, CComponents, CDatabase, CBaseFrameUnit;

type
  TCInvestmentWalletForm = class(TCDataobjectForm)
    GroupBox2: TGroupBox;
    EditName: TEdit;
    Label1: TLabel;
    RichEditDesc: TCRichEdit;
    Label2: TLabel;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    CStaticAccount: TCStatic;
    procedure CStaticAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
  protected
    procedure ReadValues; override;
    function GetDataobjectClass: TDataObjectClass; override;
    procedure FillForm; override;
    function CanAccept: Boolean; override;
    function GetUpdateFrameClass: TCBaseFrameClass; override;
    procedure InitializeForm; override;
  end;

implementation

uses CDataObjects, CInfoFormUnit, CConsts, CRichtext, CInvestmentWalletFrameUnit,
  CDatatools, CTools, CFrameFormUnit, CAccountsFrameUnit;

{$R *.dfm}

function TCInvestmentWalletForm.CanAccept: Boolean;
begin
  Result := inherited CanAccept;
  if Trim(EditName.Text) = '' then begin
    Result := False;
    ShowInfo(itError, 'Nazwa portfela inwestycyjnego nie mo¿e byæ pusta', '');
    EditName.SetFocus;
  end;
end;

procedure TCInvestmentWalletForm.FillForm;
begin
  with TInvestmentWallet(Dataobject) do begin
    EditName.Text := name;
    SimpleRichText(description, RichEditDesc);
    if idAccount <> CEmptyDataGid then begin
      GDataProvider.BeginTransaction;
      CStaticAccount.DataId := idAccount;
      CStaticAccount.Caption := TAccount(TAccount.LoadObject(AccountProxy, idAccount, False)).name;
      GDataProvider.RollbackTransaction;
    end;
  end;
end;

function TCInvestmentWalletForm.GetDataobjectClass: TDataObjectClass;
begin
  Result := TInvestmentWallet;
end;

function TCInvestmentWalletForm.GetUpdateFrameClass: TCBaseFrameClass;
begin
  Result := TCInvestmentWalletFrame;
end;

procedure TCInvestmentWalletForm.InitializeForm;
begin
  inherited InitializeForm;
  CStaticAccount.DataId := CEmptyDataGid;
end;

procedure TCInvestmentWalletForm.ReadValues;
begin
  inherited ReadValues;
  with TInvestmentWallet(Dataobject) do begin
    name := EditName.Text;
    description := RichEditDesc.Text;
    idAccount := CStaticAccount.DataId;
  end;
end;

procedure TCInvestmentWalletForm.CStaticAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCAccountsFrame, ADataGid, AText);
end;

end.
