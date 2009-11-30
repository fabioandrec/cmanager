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
    Label2: TLabel;
    ComboBoxUseOld: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure ComboBoxTypeChange(Sender: TObject);
    procedure ComboBoxRateChange(Sender: TObject);
    procedure CStaticBankChanged(Sender: TObject);
    procedure CStaticBankGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure ComboBoxUseOldChange(Sender: TObject);
  private
    FRules: TStringList;
  end;

function ShowRules(var ARulesString: TStringList): Boolean;

implementation

uses CTools, CConsts, CDatabase, CDataObjects, CFrameFormUnit,
  CCashpointsFrameUnit, Math;

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
      xForm.FRules.Values[CSimpleMovementSymbols[xCount]] := CCurrencyRateTypeAverage + 'N';
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
    xUseOld: String;
begin
  xRateType := Copy(FRules.ValueFromIndex[ComboBoxType.ItemIndex], 1, 1);
  xUseOld := Copy(FRules.ValueFromIndex[ComboBoxType.ItemIndex], 2, 1);
  xCashpoint := Copy(FRules.ValueFromIndex[ComboBoxType.ItemIndex], 3, Maxint);
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
  ComboBoxUseOld.ItemIndex := IfThen(xUseOld = 'T', 1, 0);
end;

procedure TCAccountCurrencyForm.ComboBoxRateChange(Sender: TObject);
var xRateType: String;
    xCashpoint: String;
    xUseOld: String;
begin
  xCashpoint := Copy(FRules.ValueFromIndex[ComboBoxType.ItemIndex], 3, Maxint);
  if ComboBoxRate.ItemIndex = 0 then begin
    xRateType := CCurrencyRateTypeAverage;
  end else if ComboBoxRate.ItemIndex = 1 then begin
    xRateType := CCurrencyRateTypeBuy;
  end else if ComboBoxRate.ItemIndex = 2 then begin
    xRateType := CCurrencyRateTypeSell;
  end;
  if ComboBoxUseOld.ItemIndex = 0 then begin
    xUseOld := 'N';
  end else begin
    xUseOld := 'T';
  end;
  FRules.ValueFromIndex[ComboBoxType.ItemIndex] := xRateType + xUseOld + xCashpoint;
end;

procedure TCAccountCurrencyForm.CStaticBankChanged(Sender: TObject);
var xRateType, xUseOld: String;
begin
  xRateType := Copy(FRules.ValueFromIndex[ComboBoxType.ItemIndex], 1, 1);
  xUseOld := Copy(FRules.ValueFromIndex[ComboBoxType.ItemIndex], 2, 1);
  FRules.ValueFromIndex[ComboBoxType.ItemIndex] := xRateType + xUseOld + CStaticBank.DataId;
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

procedure TCAccountCurrencyForm.ComboBoxUseOldChange(Sender: TObject);
var xRateType: String;
    xCashpoint: String;
    xUseOld: String;
begin
  xCashpoint := Copy(FRules.ValueFromIndex[ComboBoxType.ItemIndex], 3, Maxint);
  if ComboBoxRate.ItemIndex = 0 then begin
    xRateType := CCurrencyRateTypeAverage;
  end else if ComboBoxRate.ItemIndex = 1 then begin
    xRateType := CCurrencyRateTypeBuy;
  end else if ComboBoxRate.ItemIndex = 2 then begin
    xRateType := CCurrencyRateTypeSell;
  end;
  if ComboBoxUseOld.ItemIndex = 0 then begin
    xUseOld := 'N';
  end else begin
    xUseOld := 'T';
  end;
  FRules.ValueFromIndex[ComboBoxType.ItemIndex] := xRateType + xUseOld + xCashpoint;
end;

end.
