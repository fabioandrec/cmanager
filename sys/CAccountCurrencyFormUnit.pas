unit CAccountCurrencyFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, CComponents;

type
  TCAccountCurrencyForm = class(TCConfigForm)
    GroupBox1: TGroupBox;
    Label7: TLabel;
    ComboBoxType: TComboBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    ComboBoxRate: TComboBox;
    Label4: TLabel;
    CStaticBank: TCStatic;
    procedure FormCreate(Sender: TObject);
    procedure ComboBoxTypeChange(Sender: TObject);
    procedure ComboBoxRateChange(Sender: TObject);
    procedure CStaticBankChanged(Sender: TObject);
    procedure CStaticBankGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure FormDestroy(Sender: TObject);
  private
    FRules: TStringList;
  end;

function ShowRules(var ARulesString: TStringList): Boolean;

implementation

uses CTools, CConsts, CDatabase, CDataObjects, CFrameFormUnit,
  CCashpointsFrameUnit;

{$R *.dfm}

procedure TCAccountCurrencyForm.FormCreate(Sender: TObject);
begin
  FRules := TStringList.Create;
  FillCombo(ComboBoxType, CSimpleMovementTypes);
end;

function ShowRules(var ARulesString: TStringList): Boolean;
var xForm: TCAccountCurrencyForm;
    xCount: Integer;
begin
  xForm := TCAccountCurrencyForm.Create(Application);
  xForm.FRules.Assign(ARulesString);
  for xCount := Low(CSimpleMovementTypes) to High(CSimpleMovementTypes) do begin
    if xForm.FRules.IndexOfName(CSimpleMovementSymbols[xCount]) = -1 then begin
      xForm.FRules.Values[CSimpleMovementSymbols[xCount]] := CCurrencyRateTypeAverage;
    end;
  end;
  xForm.ComboBoxTypeChange(Nil);
  Result := xForm.ShowConfig(coEdit);
  if Result then begin
    ARulesString.Assign(xForm.FRules);
  end;
  xForm.Free;
end;

procedure TCAccountCurrencyForm.ComboBoxTypeChange(Sender: TObject);
var xRateType: String;
    xCashpoint: String;
begin
  xRateType := Copy(FRules.ValueFromIndex[ComboBoxType.ItemIndex], 1, 1);
  xCashpoint := Copy(FRules.ValueFromIndex[ComboBoxType.ItemIndex], 2, Maxint);
  if xRateType = CCurrencyRateTypeAverage then begin
    ComboBoxRate.ItemIndex := 0;
  end else if xRateType = CCurrencyRateTypeBuy then begin
    ComboBoxRate.ItemIndex := 1;
  end else if xRateType = CCurrencyRateTypeSell then begin
    ComboBoxRate.ItemIndex := 2;
  end;
  CStaticBank.DataId := xCashpoint;
  if xCashpoint <> '' then begin
    GDataProvider.BeginTransaction;
    CStaticBank.Caption := TCashPoint(TCashPoint.LoadObject(CashPointProxy, CStaticBank.DataId, False)).name;
    GDataProvider.RollbackTransaction;
  end;
end;

procedure TCAccountCurrencyForm.ComboBoxRateChange(Sender: TObject);
var xRateType: String;
    xCashpoint: String;
begin
  xCashpoint := Copy(FRules.ValueFromIndex[ComboBoxType.ItemIndex], 2, Maxint);
  if ComboBoxRate.ItemIndex = 0 then begin
    xRateType := CCurrencyRateTypeAverage;
  end else if ComboBoxRate.ItemIndex = 1 then begin
    xRateType := CCurrencyRateTypeBuy;
  end else if ComboBoxRate.ItemIndex = 2 then begin
    xRateType := CCurrencyRateTypeSell;
  end;
  FRules.ValueFromIndex[ComboBoxType.ItemIndex] := xRateType + xCashpoint;
end;

procedure TCAccountCurrencyForm.CStaticBankChanged(Sender: TObject);
var xRateType: String;
begin
  xRateType := Copy(FRules.ValueFromIndex[ComboBoxType.ItemIndex], 1, 1);
  FRules.ValueFromIndex[ComboBoxType.ItemIndex] := xRateType + CStaticBank.DataId;
end;

procedure TCAccountCurrencyForm.CStaticBankGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCCashpointsFrame, ADataGid, AText);
end;

procedure TCAccountCurrencyForm.FormDestroy(Sender: TObject);
begin
  FRules.Free;
  inherited;
end;

end.
