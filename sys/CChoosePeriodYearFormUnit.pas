unit CChoosePeriodYearFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CChoosePeriodFilterFormUnit, StdCtrls, Buttons, CComponents,
  ExtCtrls, CDatabase, CConfigFormUnit;

type
  TCChoosePeriodYearFilterForm = class(TCChoosePeriodFilterForm)
  public
    procedure FillPredefinedDates; override;
  end;

function ChoosePeriodYearFilterByForm(var AStartDate, AEndDate: TDateTime; var AIdFilter: TDataGid; ACurrencyView: PChar; ACanBeEmpty: Boolean = False): Boolean;

implementation

uses CChoosePeriodFormUnit;

{$R *.dfm}

function ChoosePeriodYearFilterByForm(var AStartDate, AEndDate: TDateTime; var AIdFilter: TDataGid; ACurrencyView: PChar; ACanBeEmpty: Boolean = False): Boolean;
var xForm: TCChoosePeriodYearFilterForm;
    xData: String;
begin
  xForm := TCChoosePeriodYearFilterForm.Create(Nil);
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
    if ACurrencyView <> Nil then begin
      xData := xForm.CStaticCurrencyView.DataId[1];
      CopyMemory(ACurrencyView, @xData[1], 1);
    end;
  end;
  xForm.Free;
end;

procedure TCChoosePeriodYearFilterForm.FillPredefinedDates;
begin
  ComboBoxPredefined.Clear;
  with ComboBoxPredefined do begin
    Items.BeginUpdate;
    Items.Add('Aktualny i poprzedni rok');
    Items.Add('Ostatnie 3 lata');
    Items.Add('Pe³ny zakres operacji');
    Items.Add('Wskazany okres');
    Items.EndUpdate;
    ItemIndex := 0;
  end;
end;

end.
