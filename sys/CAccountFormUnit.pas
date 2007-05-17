unit CAccountFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, ImgList,
  ComCtrls, CComponents, CDatabase, CBaseFrameUnit;

type
  TCAccountForm = class(TCDataobjectForm)
    GroupBoxAccountType: TGroupBox;
    ComboBoxType: TComboBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    EditName: TEdit;
    RichEditDesc: TRichEdit;
    CCurrEditCash: TCCurrEdit;
    LabelCash: TLabel;
    GroupBoxBank: TGroupBox;
    Label3: TLabel;
    EditNumber: TEdit;
    CStaticBank: TCStatic;
    Label4: TLabel;
    Label5: TLabel;
    CStaticCurrency: TCStatic;
    procedure FormCreate(Sender: TObject);
    procedure CStaticBankGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure ComboBoxTypeChange(Sender: TObject);
    procedure CStaticCurrencyGetDataId(var ADataGid, AText: String;
      var AAccepted: Boolean);
    procedure CStaticCurrencyChanged(Sender: TObject);
  private
    FmovementCount: Integer;
  protected
    procedure ReadValues; override;
    function GetDataobjectClass: TDataObjectClass; override;
    procedure FillForm; override;
    function CanAccept: Boolean; override;
    function GetUpdateFrameClass: TCBaseFrameClass; override;
    procedure InitializeForm; override;
  end;

implementation

uses CDataObjects, CInfoFormUnit, CConfigFormUnit, CFrameFormUnit,
  CCashpointsFrameUnit, CConsts, CAccountsFrameUnit, CRichtext,
  CCurrencydefFormUnit, CCurrencydefFrameUnit;

{$R *.dfm}

function TCAccountForm.CanAccept: Boolean;
begin
  Result := inherited CanAccept;
  if Trim(EditName.Text) = '' then begin
    Result := False;
    ShowInfo(itError, 'Nazwa konta nie mo¿e byæ pusta', '');
    EditName.SetFocus;
  end else if (ComboBoxType.ItemIndex = 1) and (CStaticBank.DataId = CEmptyDataGid) then begin
    Result := False;
    if ShowInfo(itQuestion, 'Nie wybrano banku prowadz¹cego konto. Czy wyœwietliæ listê teraz ?', '') then begin
      CStaticBank.DoGetDataId;
    end;
  end;
end;

procedure TCAccountForm.FillForm;
var xCashPoint: TCashPoint;
begin
  with TAccount(Dataobject) do begin
    EditName.Text := name;
    SimpleRichText(description, RichEditDesc);
    if accountType = CBankAccount then begin
      ComboBoxType.ItemIndex := 1;
    end else if accountType = CInvestmentAccount then begin
      ComboBoxType.ItemIndex := 2;
    end else begin
      ComboBoxType.ItemIndex := 0;
    end;
    CStaticCurrency.DataId := idCurrencyDef;
    CStaticCurrency.Caption := TCurrencyDef(TCurrencyDef.LoadObject(CurrencyDefProxy, idCurrencyDef, False)).GetElementText;
    CCurrEditCash.SetCurrencyDef(idCurrencyDef, GCurrencyCache.GetSymbol(idCurrencyDef));
    FmovementCount := GetMovementCount(id);
    if (Operation = coAdd) or (FmovementCount = 0) then begin
      LabelCash.Caption := 'Œrodki pocz¹tkowe';
      CCurrEditCash.Value := initialBalance;
      ComboBoxType.Enabled := True;
      CStaticCurrency.Enabled := True;
    end else begin
      LabelCash.Caption := 'Dostêpne œrodki';
      CCurrEditCash.Enabled := False;
      CCurrEditCash.Value := cash;
      ComboBoxType.Enabled := False;
      CStaticCurrency.Enabled := False;
    end;
    if idCashPoint <> CEmptyDataGid then begin
      CStaticBank.DataId := idCashPoint;
      xCashPoint := TCashPoint(TCashPoint.LoadObject(CashPointProxy, idCashPoint, True));
      CStaticBank.Caption := xCashPoint.name;
      xCashPoint.Free;
    end;
    EditNumber.Text := accountNumber;
    ComboBoxTypeChange(Nil);
  end;
end;

procedure TCAccountForm.FormCreate(Sender: TObject);
begin
  inherited;
  ComboBoxType.ItemIndex := 0;
  ComboBoxTypeChange(Nil);
end;

function TCAccountForm.GetDataobjectClass: TDataObjectClass;
begin
  Result := TAccount;
end;

procedure TCAccountForm.ReadValues;
begin
  inherited ReadValues;
  with TAccount(Dataobject) do begin
    name := EditName.Text;
    description := RichEditDesc.Text;
    if ComboBoxType.ItemIndex = 0 then begin
      accountType := CCashAccount;
    end else if ComboBoxType.ItemIndex = 1 then begin
      accountType := CBankAccount;
    end else begin
      accountType := CInvestmentAccount;
    end;
    if (Operation = coAdd) or (FmovementCount = 0) then begin
      cash := CCurrEditCash.Value;
      initialBalance := CCurrEditCash.Value;
    end;
    idCashPoint := CStaticBank.DataId;
    idCurrencyDef := CStaticCurrency.DataId;
    accountNumber := EditNumber.Text;
  end;
end;

procedure TCAccountForm.CStaticBankGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCCashpointsFrame, ADataGid, AText);
end;

function TCAccountForm.GetUpdateFrameClass: TCBaseFrameClass;
begin
  Result := TCAccountsFrame;
end;

procedure TCAccountForm.ComboBoxTypeChange(Sender: TObject);
begin
  Label3.Enabled := ComboBoxType.ItemIndex <> 0;
  EditNumber.Enabled := ComboBoxType.ItemIndex <> 0;
  Label4.Enabled := ComboBoxType.ItemIndex <> 0;
  CStaticBank.Enabled := ComboBoxType.ItemIndex <> 0;
end;

procedure TCAccountForm.InitializeForm;
begin
  inherited InitializeForm;
  if Operation = coAdd then begin
    CStaticCurrency.DataId := CCurrencyDefGid_PLN;
    CStaticCurrency.Caption := TCurrencyDef(TCurrencyDef.LoadObject(CurrencyDefProxy, CStaticCurrency.DataId, False)).GetElementText;
    CCurrEditCash.SetCurrencyDef(CCurrencyDefGid_PLN, GCurrencyCache.GetSymbol(CCurrencyDefGid_PLN));
  end;
end;

procedure TCAccountForm.CStaticCurrencyGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCCurrencydefFrame, ADataGid, AText);
end;

procedure TCAccountForm.CStaticCurrencyChanged(Sender: TObject);
begin
  CCurrEditCash.SetCurrencyDef(CStaticCurrency.DataId, GCurrencyCache.GetSymbol(CStaticCurrency.DataId));
end;

end.
