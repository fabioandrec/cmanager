unit CChoosePeriodFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, CComponents;

type
  TCChoosePeriodForm = class(TCConfigForm)
    GroupBox1: TGroupBox;
    Label5: TLabel;
    ComboBoxPredefined: TComboBox;
    CDateTime1: TCDateTime;
    CDateTime2: TCDateTime;
    Label1: TLabel;
    Label2: TLabel;
    GroupBoxView: TGroupBox;
    LabelView: TLabel;
    CStaticCurrencyView: TCStatic;
    procedure ComboBoxPredefinedChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CStaticCurrencyViewGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure FormShow(Sender: TObject);
  public
    procedure GetFilterDates(var AStartDate, AEndDate: TDateTime); virtual;
    procedure FillPredefinedDates; virtual;
    procedure PredefinedChanged; virtual;
  end;

function ChoosePeriodByForm(var AStartDate, AEndDate: TDateTime; ACurrencyView: PChar): Boolean;

implementation

uses CDatabase, DateUtils, CListFrameUnit, CTools;

{$R *.dfm}

function ChoosePeriodByForm(var AStartDate, AEndDate: TDateTime; ACurrencyView: PChar): Boolean;
var xForm: TCChoosePeriodForm;
    xData: String;
    xList: TList;
begin
  xForm := TCChoosePeriodForm.Create(Nil);
  if ACurrencyView = Nil then begin
    xForm.GroupBoxView.Visible := False;
    xForm.Height := xForm.Height - xForm.GroupBoxView.Height - 15;
    xList := TList.Create;
    xForm.GetTabOrderList(xList);
    xForm.GroupBoxView.TabOrder := xList.Count;
    xList.Free;
  end;
  if (AStartDate = GWorkDate) and (AEndDate = GWorkDate) then begin
    xForm.ComboBoxPredefined.ItemIndex := 1;
    xForm.ComboBoxPredefinedChange(xForm.ComboBoxPredefined);
  end;
  Result := xForm.ShowConfig(coEdit);
  if Result then begin
    AStartDate := xForm.CDateTime1.Value;
    AEndDate := xForm.CDateTime2.Value;
    if ACurrencyView <> Nil then begin
      xData := xForm.CStaticCurrencyView.DataId[1];
      CopyMemory(ACurrencyView, @xData[1], 1);
    end;
  end;
  xForm.Free;
end;

procedure TCChoosePeriodForm.ComboBoxPredefinedChange(Sender: TObject);
begin
  PredefinedChanged;
end;

procedure TCChoosePeriodForm.GetFilterDates(var AStartDate, AEndDate: TDateTime);
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

procedure TCChoosePeriodForm.FormCreate(Sender: TObject);
begin
  inherited;
  Caption := 'Parametry raportu';
  FillPredefinedDates;
end;

procedure TCChoosePeriodForm.CStaticCurrencyViewGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ShowCurrencyViewTypeBaseMovement(ADataGid, AText);
end;

procedure TCChoosePeriodForm.FormShow(Sender: TObject);
begin
  inherited;
  ComboBoxPredefinedChange(ComboBoxPredefined);
end;

procedure TCChoosePeriodForm.FillPredefinedDates;
begin
end;

procedure TCChoosePeriodForm.PredefinedChanged;
var xDf, xDe: TDateTime;
begin
  CDateTime1.Enabled := ComboBoxPredefined.ItemIndex = 0;
  CDateTime2.Enabled := ComboBoxPredefined.ItemIndex = 0;
  GetFilterDates(xDf, xDe);
  CDateTime1.Value := xDf;
  CDateTime2.Value := xDe;
  if ComboBoxPredefined.ItemIndex = 0 then begin
    if IsLowestDatetime(CDateTime1.Value) then begin
      CDateTime1.Value := GWorkDate;
    end;
    if IsHighestDatetime(CDateTime2.Value) then begin
      CDateTime2.Value := GWorkDate;
    end;
  end;
  if CDateTime1.Withtime then begin
    CDateTime1.Value := StartOfTheDay(CDateTime1.Value);
  end;
  if CDateTime2.Withtime then begin
    CDateTime2.Value := EndOfTheDay(CDateTime2.Value);
  end;
end;

end.
