unit CChooseFutureFilterFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CChoosePeriodFilterFormUnit, StdCtrls, Buttons, CComponents,
  ExtCtrls, CDatabase;

type
  TCChooseFutureFilterForm = class(TCChoosePeriodFilterForm)
    GroupBox3: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    ComboBoxFuture: TComboBox;
    CDateTime3: TCDateTime;
    CDateTime4: TCDateTime;
    procedure ComboBoxFutureChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure GetFilterFutures(var AStartDate, AEndDate: TDateTime);
  end;

function ChooseFutureFilterByForm(var AStartDate, AEndDate, AStartFuture, AEndFuture: TDateTime; var AIdFilter: TDataGid; ACanBeEmpty: Boolean = False): Boolean;

implementation

uses CConfigFormUnit, DateUtils;

{$R *.dfm}

function ChooseFutureFilterByForm(var AStartDate, AEndDate, AStartFuture, AEndFuture: TDateTime; var AIdFilter: TDataGid; ACanBeEmpty: Boolean = False): Boolean;
var xForm: TCChooseFutureFilterForm;
begin
  xForm := TCChooseFutureFilterForm.Create(Nil);
  xForm.CanBeEmpty := ACanBeEmpty;
  Result := xForm.ShowConfig(coEdit);
  if Result then begin
    AStartDate := xForm.CDateTime1.Value;
    AEndDate := xForm.CDateTime2.Value;
    AStartFuture := xForm.CDateTime3.Value;
    AEndFuture := xForm.CDateTime4.Value;
    AIdFilter := xForm.CStaticFilter.DataId;
  end;
  xForm.Free;
end;

procedure TCChooseFutureFilterForm.ComboBoxFutureChange(Sender: TObject);
var xDf, xDe: TDateTime;
begin
  CDateTime3.Enabled := ComboBoxFuture.ItemIndex = 0;
  CDateTime4.Enabled := ComboBoxFuture.ItemIndex = 0;
  GetFilterFutures(xDf, xDe);
  CDateTime3.Value := xDf;
  CDateTime4.Value := xDe;
end;

procedure TCChooseFutureFilterForm.GetFilterFutures(var AStartDate, AEndDate: TDateTime);
var xId: Integer;
begin
  xId := ComboBoxFuture.ItemIndex;
  if xId = 0 then begin
    AStartDate := CDateTime3.Value;
    AEndDate := CDateTime4.Value;
  end else if xId = 1 then begin
    AStartDate := StartOfTheWeek(IncWeek(GWorkDate));
    AEndDate := EndOfTheWeek(IncWeek(GWorkDate));
  end else if xId = 2 then begin
    AStartDate := StartOfTheMonth(IncMonth(GWorkDate));
    AEndDate := EndOfTheMonth(IncMonth(GWorkDate));
  end else if xId = 3 then begin
    AStartDate := GetStartQuarterOfTheYear(IncMonth(GWorkDate, 3));
    AEndDate := GetEndQuarterOfTheYear(IncMonth(GWorkDate, 3));
  end else if xId = 4 then begin
    AStartDate := GetStartHalfOfTheYear(IncMonth(GWorkDate, 6));
    AEndDate := GetEndHalfOfTheYear(IncMonth(GWorkDate, 6));
  end else if xId = 5 then begin
    AStartDate := StartOfTheYear(IncYear(GWorkDate));
    AEndDate := EndOfTheYear(IncYear(GWorkDate));
  end else if xId = 6 then begin
    AStartDate := IncDay(GWorkDate);
    AEndDate := IncDay(GWorkDate, 7);
  end else if xId = 7 then begin
    AStartDate := IncDay(GWorkDate);
    AEndDate := IncDay(GWorkDate, 14);
  end else if xId = 8 then begin
    AStartDate := IncDay(GWorkDate);
    AEndDate := IncDay(GWorkDate, 30)
  end;
end;

procedure TCChooseFutureFilterForm.FormCreate(Sender: TObject);
begin
  inherited;
  ComboBoxFutureChange(ComboBoxPredefined);
end;

end.
