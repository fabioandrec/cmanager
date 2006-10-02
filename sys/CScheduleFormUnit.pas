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
  published
    property Schedule: TSchedule read FSchedule write FSchedule;
  end;

function GetSchedule(ASchedule: TSchedule): Boolean;

implementation

uses StrUtils;

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
  
end;

function TSchedule.GetAsString: String;
begin
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
    Height := Height - 234;
  end else begin
    GroupBox2.Visible := True;
    GroupBox3.Visible := True;
    Height := Height + 234;
  end;
end;

procedure TCScheduleForm.FillForm;
begin
  CDateTime.Value := GWorkDate;
  CDateTimeEnd.Value := GWorkDate;
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

end.
