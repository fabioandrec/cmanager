unit CScheduleFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, CComponents, CDatabase,
  CDataObjects;

type
  TSchedule = class(TObject)
  private
    FscheduleType: TBaseEnumeration;
    FscheduleDate: TDateTime;
    FendCondition: TBaseEnumeration;
    FendCount: Integer;
    FendDate: TDateTime;
    FtriggerType: TBaseEnumeration;
    FtriggerDay: Integer;
    function GetAsString: String;
  public
    constructor Create;
  published
    property AsString: String read GetAsString;
    property scheduleType: TBaseEnumeration read FscheduleType write FscheduleType;
    property scheduleDate: TDateTime read FscheduleDate write FscheduleDate;
    property endCondition: TBaseEnumeration read FendCondition write FendCondition;
    property endCount: Integer read FendCount write FendCount;
    property endDate: TDateTime read FendDate write FendDate;
    property triggerType: TBaseEnumeration read FtriggerType write FtriggerType;
    property triggerDay: Integer read FtriggerDay write FtriggerDay;
  end;

  TCScheduleForm = class(TCConfigForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    ComboBoxType: TComboBox;
    Label3: TLabel;
    CDateTime: TCDateTime;
    GroupBox2: TGroupBox;
    RadioButtonTimes: TRadioButton;
    RadioButtonEnd: TRadioButton;
    RadioButtonAlways: TRadioButton;
    Label2: TLabel;
    CDateTimeEnd: TCDateTime;
    Label4: TLabel;
    CIntEditTimes: TCIntEdit;
    GroupBox3: TGroupBox;
    Label5: TLabel;
    ComboBoxInterval: TComboBox;
    Label6: TLabel;
    ComboBoxWeekday: TComboBox;
    ComboBoxMonthday: TComboBox;
    Label7: TLabel;
    procedure ComboBoxTypeChange(Sender: TObject);
    procedure RadioButtonTimesClick(Sender: TObject);
    procedure ComboBoxIntervalChange(Sender: TObject);
  private
    FSchedule: TSchedule;
  protected
    procedure FillForm; override;
    procedure ChangeEndCondition;
    procedure ReadValues; override;
    function CanAccept: Boolean; override;
  published
    property Schedule: TSchedule read FSchedule write FSchedule;
  end;

function GetSchedule(ASchedule: TSchedule): Boolean;

implementation

uses StrUtils, Math, DateUtils, CInfoFormUnit, CConsts;

{$R *.dfm}

function GetSchedule(ASchedule: TSchedule): Boolean;
var xForm: TCScheduleForm;
begin
  xForm := TCScheduleForm.Create(Nil);
  xForm.Schedule := ASchedule;
  Result := xForm.ShowConfig(coEdit);
  xForm.Free;
end;

constructor TSchedule.Create;
begin
  inherited Create;
  FscheduleType := CScheduleTypeCyclic;
  FscheduleDate := GWorkDate;
  FendCondition := CEndConditionNever;
  FendCount := 12;
  FendDate := 0;
  FtriggerType := CTriggerTypeMonthly;
  FtriggerDay := 0;
end;

function TSchedule.GetAsString: String;
var xDayNumber: Integer;
begin
  if FscheduleType = CScheduleTypeOnce then begin
    Result := 'Jednorazowo, ' + DateToStr(FscheduleDate);
  end else begin
    Result := 'Cyklicznie, od ' + DateToStr(FscheduleDate);
    if FendCondition = CEndConditionTimes then begin
      Result := Result + ', ' + IntToStr(FendCount) + ' raz/y';
    end else if FendCondition = CEndConditionDate then begin
      Result := Result + ', do ' + DateToStr(FendDate);
    end;
    if FtriggerType = CTriggerTypeWeekly then begin
      xDayNumber := FtriggerDay + 2;
      if xDayNumber > 7 then begin
        xDayNumber := xDayNumber - 6;
      end;
      Result := Result + ', ka¿dy ' + ShortDayNames[xDayNumber];
    end else begin
      Result := Result + ', ka¿dy ' + IfThen(FtriggerDay = 0, 'ostatni', IntToStr(FtriggerDay)) + ' dzieñ mies.';
    end;
  end;
end;

procedure TCScheduleForm.ChangeEndCondition;
begin
  CDateTimeEnd.Enabled := RadioButtonEnd.Checked;
  CIntEditTimes.Enabled := RadioButtonTimes.Checked;
end;

procedure TCScheduleForm.ComboBoxTypeChange(Sender: TObject);
begin
  Label3.Caption := IfThen(ComboBoxType.ItemIndex = 0, 'Data wykonania', 'Data rozpoczêcia');
  if ComboBoxType.ItemIndex = 0 then begin
    GroupBox2.Visible := False;
    GroupBox3.Visible := False;
    Height := 167;
  end else begin
    GroupBox2.Visible := True;
    GroupBox3.Visible := True;
    Height := 401;
  end;
end;

procedure TCScheduleForm.FillForm;
begin
  with FSchedule do begin
    ComboBoxType.ItemIndex := IfThen(scheduleType = CScheduleTypeOnce, 0, 1);
    CDateTime.Value := scheduleDate;
    RadioButtonTimes.Checked := endCondition = CEndConditionTimes;
    RadioButtonEnd.Checked := endCondition = CEndConditionDate;
    RadioButtonAlways.Checked := endCondition = CEndConditionNever;
    if endDate = 0 then begin
      CDateTimeEnd.Value := EndOfTheYear(GWorkDate);
    end else begin
      CDateTimeEnd.Value := endDate;
    end;
    CIntEditTimes.Text := IntToStr(endCount);
    if triggerType = CTriggerTypeWeekly then begin
      ComboBoxWeekday.ItemIndex := triggerDay;
      ComboBoxMonthday.ItemIndex := 0;
    end else begin
      ComboBoxWeekday.ItemIndex := 0;
      ComboBoxMonthday.ItemIndex := triggerDay;
    end;
    ComboBoxInterval.ItemIndex := IfThen(triggerType = CTriggerTypeWeekly, 0, 1);
  end;
  ChangeEndCondition;
  ComboBoxTypeChange(ComboBoxType);
  ComboBoxIntervalChange(ComboBoxInterval);
end;

procedure TCScheduleForm.RadioButtonTimesClick(Sender: TObject);
begin
  ChangeEndCondition;
end;

procedure TCScheduleForm.ComboBoxIntervalChange(Sender: TObject);
begin
  if ComboBoxInterval.ItemIndex = 0 then begin
    ComboBoxWeekday.Visible := True;
    ComboBoxMonthday.Visible := False;
    Label7.Visible := False;
  end else begin
    ComboBoxWeekday.Visible := False;
    ComboBoxMonthday.Visible := True;
    Label7.Visible := True;
  end;
end;

procedure TCScheduleForm.ReadValues;
begin
  with FSchedule do begin
    scheduleType := IfThen(ComboBoxType.ItemIndex = 0, CScheduleTypeOnce, CScheduleTypeCyclic);
    scheduleDate := CDateTime.Value;
    if RadioButtonTimes.Checked then begin
      endCondition := CEndConditionTimes;
    end else if RadioButtonEnd.Checked then begin
      endCondition := CEndConditionDate;
    end else begin
      endCondition := CEndConditionNever;
    end;
    if endCondition = CEndConditionDate then begin
      endDate := CDateTimeEnd.Value;
    end else begin
      endDate := 0;
    end;
    endCount := CIntEditTimes.Value;
    triggerType := IfThen(ComboBoxInterval.ItemIndex = 0, CTriggerTypeWeekly, CTriggerTypeMonthly);
    if triggerType = CTriggerTypeWeekly then begin
      triggerDay := ComboBoxWeekday.ItemIndex;
    end else begin
      triggerDay := ComboBoxMonthday.ItemIndex;
    end;
  end;
end;

function TCScheduleForm.CanAccept: Boolean;
begin
  Result := True;
  if RadioButtonTimes.Checked and (StrToIntDef(CIntEditTimes.Text, -1) <= 0) then begin
    Result := False;
    ShowInfo(itError, 'Niepoprana iloœæ wykonañ planowanej operacji', '');
    CIntEditTimes.SetFocus;
  end else if RadioButtonEnd.Checked and (CDateTime.Value > CDateTimeEnd.Value) then begin
    Result := False;
    ShowInfo(itError, 'Data rozpoczêcia nie mo¿e byæ wiêksza od daty zakoñczenia', '');
  end;
end;

end.
