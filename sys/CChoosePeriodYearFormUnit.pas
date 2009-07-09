unit CChoosePeriodYearFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CChoosePeriodFilterFormUnit, StdCtrls, Buttons, CComponents,
  ExtCtrls, CDatabase, CConfigFormUnit, AdoDb;

type
  TCChoosePeriodYearFilterForm = class(TCChoosePeriodFilterForm)
  public
    procedure FillPredefinedDates; override;
    procedure PredefinedChanged; override;
    procedure GetFilterDates(var AStartDate: TDateTime; var AEndDate: TDateTime); override;
  end;

function ChoosePeriodYearFilterByForm(var AStartDate, AEndDate: TDateTime; var AIdFilter: TDataGid; ACurrencyView: PChar; ACanBeEmpty: Boolean = False): Boolean;

implementation

uses CChoosePeriodFormUnit, CTools, DateUtils;

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
    Items.Add('Wszystkie lata w pliku danych');
    Items.Add('Wskazany okres');
    Items.EndUpdate;
    ItemIndex := 0;
  end;
end;

procedure TCChoosePeriodYearFilterForm.GetFilterDates(var AStartDate, AEndDate: TDateTime);
var xId: Integer;
    xYears: TADOQuery;
begin
  xId := ComboBoxPredefined.ItemIndex;
  if xId = 0 then begin
    AStartDate := StartOfTheYear(IncYear(GWorkDate, -1));
    AEndDate := EndOfTheYear(GWorkDate);
  end else if xId = 1 then begin
    AStartDate := StartOfTheYear(IncYear(GWorkDate, -2));
    AEndDate := EndOfTheYear(GWorkDate);
  end else if xId = 2 then begin
    xYears := GDataProvider.OpenSql('select min(yearDate) as minDate, max(yearDate) as maxDate from baseMovement');
    AStartDate := StartOfTheYear(xYears.FieldByName('minDate').AsDateTime);
    AEndDate := EndOfTheYear(xYears.FieldByName('maxDate').AsDateTime);
    xYears.Free;
  end else if xId = 3 then begin
    AStartDate := StartOfTheYear(CDateTime1.Value);
    AEndDate := EndOfTheYear(CDateTime2.Value);
  end;
end;

procedure TCChoosePeriodYearFilterForm.PredefinedChanged;
var xDf, xDe: TDateTime;
begin
  CDateTime1.Enabled := ComboBoxPredefined.ItemIndex = 3;
  CDateTime2.Enabled := ComboBoxPredefined.ItemIndex = 3;
  GetFilterDates(xDf, xDe);
  CDateTime1.Value := xDf;
  CDateTime2.Value := xDe;
  if ComboBoxPredefined.ItemIndex = 3 then begin
    if IsLowestDatetime(CDateTime1.Value) then begin
      CDateTime1.Value := GWorkDate;
    end;
    if IsHighestDatetime(CDateTime2.Value) then begin
      CDateTime2.Value := GWorkDate;
    end;
  end;
end;

end.
