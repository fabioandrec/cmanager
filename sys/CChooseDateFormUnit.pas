unit CChooseDateFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, CComponents;

type
  TCChooseDateForm = class(TCConfigForm)
    GroupBox1: TGroupBox;
    Label5: TLabel;
    ComboBoxPredefined: TComboBox;
    CDateTime1: TCDateTime;
    CDateTime2: TCDateTime;
    Label1: TLabel;
    Label2: TLabel;
    procedure ComboBoxPredefinedChange(Sender: TObject);
  private
    procedure GetFilterDates(var AStartDate, AEndDate: TDateTime);
  public
    { Public declarations }
  end;

function ChooseDateByForm(var AStartDate, AEndDate: TDateTime): Boolean;

implementation

uses CDatabase, DateUtils;

{$R *.dfm}

function ChooseDateByForm(var AStartDate, AEndDate: TDateTime): Boolean;
var xForm: TCChooseDateForm;
begin
  xForm := TCChooseDateForm.Create(Nil);
  with xForm do begin
    ComboBoxPredefinedChange(ComboBoxPredefined);
  end;
  Result := xForm.ShowConfig(coEdit);
  xForm.Free;
end;

procedure TCChooseDateForm.ComboBoxPredefinedChange(Sender: TObject);
var xDf, xDe: TDateTime;
begin
  CDateTime1.Enabled := ComboBoxPredefined.ItemIndex = 0;
  CDateTime2.Enabled := ComboBoxPredefined.ItemIndex = 0;
  GetFilterDates(xDf, xDe);
  CDateTime1.Value := xDf;
  CDateTime2.Value := xDe;
end;

procedure TCChooseDateForm.GetFilterDates(var AStartDate, AEndDate: TDateTime);
var xId: Integer;
begin
  xId := ComboBoxPredefined.ItemIndex;
  if xId = 0 then begin
    AStartDate := CDateTime1.Value;
    AEndDate := CDateTime2.Value;
  end else if xId = 1 then begin
    AStartDate := GWorkDate;
    AEndDate := GWorkDate;
  end else if xId = 2 then begin
    AStartDate := StartOfTheWeek(GWorkDate);
    AEndDate := EndOfTheWeek(GWorkDate);
  end else if xId = 3 then begin
    AStartDate := StartOfTheMonth(GWorkDate);
    AEndDate := EndOfTheMonth(GWorkDate);
  end else if xId = 4 then begin
    AStartDate := GetStartQuarterOfTheYear(GWorkDate);
    AEndDate := GetEndQuarterOfTheYear(GWorkDate);
  end else if xId = 5 then begin
    AStartDate := GetStartHalfOfTheYear(GWorkDate);
    AEndDate := GetEndHalfOfTheYear(GWorkDate);
  end else if xId = 6 then begin
    AStartDate := StartOfTheYear(GWorkDate);
    AEndDate := EndOfTheYear(GWorkDate);
  end else if xId = 7 then begin
    AStartDate := IncDay(GWorkDate, -6);
    AEndDate := GWorkDate;
  end else if xId = 8 then begin
    AStartDate := IncDay(GWorkDate, -13);
    AEndDate := GWorkDate;
  end else if xId = 9 then begin
    AStartDate := IncDay(GWorkDate, -29);
    AEndDate := GWorkDate;
  end;
end;

end.
