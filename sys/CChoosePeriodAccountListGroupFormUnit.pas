unit CChoosePeriodAccountListGroupFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CChoosePeriodAccountListFormUnit, StdCtrls, Buttons,
  CComponents, ExtCtrls;

type
  TCChoosePeriodAccountListGroupForm = class(TCChoosePeriodAccountListForm)
    GroupBox3: TGroupBox;
    Label3: TLabel;
    ComboBoxSums: TComboBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ChoosePeriodAccountListGroupByForm(var AStartDate, AEndDate: TDateTime; var AIdAccounts: TStringList; var AGroupBy: String): Boolean;

implementation

uses CConsts, CConfigFormUnit;

{$R *.dfm}

function ChoosePeriodAccountListGroupByForm(var AStartDate, AEndDate: TDateTime; var AIdAccounts: TStringList; var AGroupBy: String): Boolean;
var xForm: TCChoosePeriodAccountListGroupForm;
begin
  xForm := TCChoosePeriodAccountListGroupForm.Create(Nil);
  Result := xForm.ShowConfig(coEdit);
  if Result then begin
    AStartDate := xForm.CDateTime1.Value;
    AEndDate := xForm.CDateTime2.Value;
    AIdAccounts.Text := xForm.CStaticAccount.DataId;
    if xForm.ComboBoxSums.ItemIndex = 0 then begin
      AGroupBy := CGroupByDay;
    end else if xForm.ComboBoxSums.ItemIndex = 1 then begin
      AGroupBy := CGroupByWeek;
    end else begin
      AGroupBy := CGroupByMonth;
    end;
  end;
  xForm.Free;
end;

end.
