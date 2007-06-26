unit CChoosePeriodFilterGroupFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CChoosePeriodFilterFormUnit, StdCtrls, Buttons, CComponents,
  ExtCtrls, CDatabase, CConfigFormUnit;

type
  TCChoosePeriodFilterGroupForm = class(TCChoosePeriodFilterForm)
    GroupBox3: TGroupBox;
    Label3: TLabel;
    ComboBoxSums: TComboBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ChoosePeriodFilterGroupByForm(var AStartDate, AEndDate: TDateTime; var AIdFilter: TDataGid; var AGroupBy: String; ACurrencyView: PChar; ACanBeEmpty: Boolean = False): Boolean;

implementation

uses CConsts;

{$R *.dfm}

function ChoosePeriodFilterGroupByForm(var AStartDate, AEndDate: TDateTime; var AIdFilter: TDataGid; var AGroupBy: String; ACurrencyView: PChar; ACanBeEmpty: Boolean = False): Boolean;
var xForm: TCChoosePeriodFilterGroupForm;
    xData: String;
begin
  xForm := TCChoosePeriodFilterGroupForm.Create(Nil);
  xForm.CanBeEmpty := ACanBeEmpty;
  if ACurrencyView = Nil then begin
    xForm.GroupBoxView.Visible := False;
    xForm.Height := xForm.Height - xForm.GroupBoxView.Height - 23;
  end;
  if (AStartDate = GWorkDate) and (AEndDate = GWorkDate) then begin
    xForm.ComboBoxPredefined.ItemIndex := 1;
    xForm.ComboBoxPredefinedChange(xForm.ComboBoxPredefined);
  end;
  Result := xForm.ShowConfig(coEdit);
  if Result then begin
    AStartDate := xForm.CDateTime1.Value;
    AEndDate := xForm.CDateTime2.Value;
    AIdFilter := xForm.CStaticFilter.DataId;
    if xForm.ComboBoxSums.ItemIndex = 0 then begin
      AGroupBy := CGroupByDay;
    end else if xForm.ComboBoxSums.ItemIndex = 1 then begin
      AGroupBy := CGroupByWeek;
    end else begin
      AGroupBy := CGroupByMonth;
    end;
    if ACurrencyView <> Nil then begin
      xData := xForm.CStaticCurrencyView.DataId[1];
      CopyMemory(ACurrencyView, @xData[1], 1);
    end;
  end;
  xForm.Free;
end;

end.
 