unit CInvestmentPortfolioFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, CComponents;

type
  TCInvestmentPortfolioForm = class(TCDataobjectForm)
    GroupBox1: TGroupBox;
    Label4: TLabel;
    CStaticAccount: TCStatic;
    Label1: TLabel;
    CStaticInstrument: TCStatic;
    Label2: TLabel;
    EditType: TEdit;
    GroupBox2: TGroupBox;
    Label15: TLabel;
    CIntQuantity: TCIntEdit;
    Label6: TLabel;
    CCurrEditValue: TCCurrEdit;
  protected
    procedure FillForm; override;
  end;

implementation

uses CDataObjects, CDatabase;

{$R *.dfm}

procedure TCInvestmentPortfolioForm.FillForm;
begin
  with TInvestmentPortfolio(Dataobject) do begin
    CStaticAccount.DataId := idAccount;
    CStaticAccount.Caption := accountName;
    CStaticInstrument.DataId := idInstrument;
    CStaticInstrument.Caption := instrumentName;
    GDataProvider.BeginTransaction;
    EditType.Text := TInstrument(TInstrument.LoadObject(InstrumentProxy, idInstrument, False)).GetColumnText(2, False, '');
    GDataProvider.RollbackTransaction;
    CCurrEditValue.SetCurrencyDef(idCurrencyDef, GCurrencyCache.GetSymbol(idCurrencyDef));
    CCurrEditValue.Value := overallValue;
    CIntQuantity.Value := quantity;
  end;
end;

end.
