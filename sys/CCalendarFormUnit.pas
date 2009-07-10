unit CCalendarFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, ExtCtrls, CComponents, ActnList, StdCtrls, CommCtrl;

type
  TCCalendarForm = class(TForm)
    MonthCalendar: TMonthCalendar;
    Bevel: TBevel;
    TrackBarTime: TTrackBar;
    CLabelToday: TCLabel;
    CLabelNow: TCLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MonthCalendarDblClick(Sender: TObject);
    procedure TrackBarTimeChange(Sender: TObject);
    procedure CLabelTodayMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure CLabelTodayClick(Sender: TObject);
    procedure CLabelNowClick(Sender: TObject);
  private
    FWithtime: Boolean;
    FChoosenDatetime: TDateTime;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WndProc(var Message: TMessage); override;
    procedure RefreshDatetimeControls;
  public
    procedure InitializeCalendar(ADateTime: TDateTime; AWithtime: Boolean; AParent: TWinControl);
  published
    property Withtime: Boolean read FWithtime write FWithtime;
    property ChoosenDatetime: TDateTime read FChoosenDatetime;
  end;

function ShowCalendar(AParent: TWinControl; var ADate: TDateTime; AWithtime: Boolean): Boolean;

implementation

uses DateUtils, Types, Math, StrUtils;

{$R *.dfm}

function ShowCalendar(AParent: TWinControl; var ADate: TDateTime; AWithtime: Boolean): Boolean;
begin
  Result := False;
  with TCCalendarForm.Create(Nil) do begin
    InitializeCalendar(ADate, AWithtime, AParent);
    Show;
    repeat
      Application.HandleMessage;
    until (ModalResult = mrOk) or (ModalResult = mrCancel);
    if ModalResult = mrOk then begin
      Result := True;
      ADate := ChoosenDatetime;
    end;
    Free;
  end;
end;

procedure TCCalendarForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then begin
    ModalResult := mrCancel;
  end else if Key = VK_RETURN then begin
    ModalResult := mrOk;
  end;
end;

procedure TCCalendarForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do begin
    Style := WS_POPUP or WS_DLGFRAME;
    if CheckWin32Version(5, 1) then begin
      WindowClass.Style := WindowClass.style or CS_DROPSHADOW;
    end;
  end;
end;

procedure TCCalendarForm.MonthCalendarDblClick(Sender: TObject);
var xPoint: TPoint;
    xH, xM, xS, xMs: Word;
begin
  DecodeTime(FChoosenDatetime, xH, xM, xS, xMs);
  xPoint := MonthCalendar.ScreenToClient(Mouse.CursorPos);
  if xPoint.Y > MonthCalendar.Height / 4 then begin
    FChoosenDatetime := RecodeTime(MonthCalendar.Date, xH, xM, xS, xMs);
    ModalResult := mrOk;
  end;
end;

procedure TCCalendarForm.WndProc(var Message: TMessage);
begin
  inherited WndProc(Message);
  if Message.Msg = WM_ACTIVATE then begin
    if Message.WParamLo = WA_INACTIVE then begin
      ModalResult := mrCancel;
    end;
  end;
end;

procedure TCCalendarForm.InitializeCalendar(ADateTime: TDateTime; AWithtime: Boolean; AParent: TWinControl);
var xR: TRect;
begin
  if HandleAllocated then begin
    SendMessage(MonthCalendar.Handle, MCM_GETMINREQRECT, 0, Longint(@xR));
  end;
  FWithtime := AWithtime;
  FChoosenDatetime := ADateTime;
  MonthCalendar.Date := FChoosenDatetime;
  Width := xR.Right - xR.Left + 24;
  Height := xR.Bottom - xR.Top + IfThen(AWithtime, 66, 46);
  TrackBarTime.Position := Trunc(1440 * TimeOf(FChoosenDatetime));
  RefreshDatetimeControls;
  Top := AParent.ClientOrigin.Y + AParent.Height + 2;
  Left := AParent.ClientOrigin.X + 4;
  if Left + Width > Screen.Width then begin
    Left := Screen.Width - Width - 5;
  end;
  TrackBarTime.Top := MonthCalendar.Top + (xR.Bottom - xR.Top) + 8;
  TrackBarTime.Left := MonthCalendar.Left + 4;
  TrackBarTime.Width := MonthCalendar.Width - 8;
  TrackBarTime.Visible := FWithtime;
  CLabelNow.Visible := FWithtime;
  if FWithtime then begin
    CLabelToday.Caption := 'Teraz';
    CLabelToday.Left := CLabelToday.Left + 5;
  end else begin
    CLabelToday.Top := MonthCalendar.Top + MonthCalendar.Height + 12;
  end;
  CLabelToday.Left := MonthCalendar.BoundsRect.Right - CLabelToday.Width - 12;
  CLabelNow.Left := 12;
end;

procedure TCCalendarForm.RefreshDatetimeControls;
begin
  CLabelNow.Caption := FormatDateTime('hh:nn', FChoosenDatetime);
  CLabelNow.Repaint;
end;

procedure TCCalendarForm.TrackBarTimeChange(Sender: TObject);
begin
  FChoosenDatetime := DateOf(FChoosenDatetime) + TrackBarTime.Position / 1440;
  RefreshDatetimeControls;
end;

procedure TCCalendarForm.CLabelTodayMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FChoosenDatetime := Now;
  MonthCalendar.Date := FChoosenDatetime;
  TrackBarTime.Position := Trunc(1440 * TimeOf(FChoosenDatetime));
  RefreshDatetimeControls;
end;

procedure TCCalendarForm.CLabelTodayClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TCCalendarForm.CLabelNowClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
