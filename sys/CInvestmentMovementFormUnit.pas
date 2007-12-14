unit CInvestmentMovementFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, CComponents,
  ComCtrls, ActnList, XPStyleActnCtrls, ActnMan;

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
    CCurrEditOnceQuantity: TCCurrEdit;
    Label2: TLabel;
    CStaticInstrumentValue: TCStatic;
    Label6: TLabel;
    CCurrEditValue: TCCurrEdit;
    Label9: TLabel;
    CCurrEditInoutOnceMovement: TCCurrEdit;
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
  private
  protected
    procedure InitializeForm; override;
  public
  end;

implementation

uses CFrameFormUnit, CInstrumentFrameUnit, CInstrumentValueFrameUnit,
  CAccountsFrameUnit, CCurrencyRateFrameUnit, CProductsFrameUnit, CDatabase,
  CTools, CDataObjects;

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
begin
  AAccepted := TCFrameForm.ShowFrame(TCCurrencyRateFrame, ADataGid, AText);
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
end;

procedure TCInvestmentMovementForm.InitializeForm;
begin
  inherited InitializeForm;
  CStaticAccountCurrency.DataId := CEmptyDataGid;
  CCurrEditAccount.SetCurrencyDef(CEmptyDataGid, '');
end;

end.
 