unit CCalendarFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, ExtCtrls, CComponents, ActnList, StdCtrls;

type
  TCCalendarForm = class(TForm)
    CButton: TCButton;
    MonthCalendar: TMonthCalendar;
    Bevel: TBevel;
    TrackBar1: TTrackBar;
    CButtonChoose: TCButton;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MonthCalendarDblClick(Sender: TObject);
    procedure CButtonClick(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure CButtonChooseClick(Sender: TObject);
    procedure CButtonMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
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

procedure TCCalendarForm.CButtonClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TCCalendarForm.InitializeCalendar(ADateTime: TDateTime; AWithtime: Boolean; AParent: TWinControl);
begin
  FWithtime := AWithtime;
  FChoosenDatetime := ADateTime;
  MonthCalendar.Date := FChoosenDatetime;
  TrackBar1.Position := Trunc(1440 * TimeOf(FChoosenDatetime));
  RefreshDatetimeControls;
  Top := AParent.ClientOrigin.Y + AParent.Height + 2;
  Left := AParent.ClientOrigin.X + 4;
  if Left + Width > Screen.Width then begin
    Left := Screen.Width - Width - 5;
  end;
  TrackBar1.Visible := FWithtime;
  CButtonChoose.Visible := FWithtime;
  if FWithtime then begin
    CButton.Caption := 'Teraz';
    CButton.Left := CButton.Left + 5;
  end else begin
    Height := Height - 20;
    CButton.Top := CButton.Top - 20;
  end;
end;

procedure TCCalendarForm.RefreshDatetimeControls;
begin
  CButtonChoose.Caption := FormatDateTime('hh:nn', FChoosenDatetime);
  CButtonChoose.Repaint;
end;

procedure TCCalendarForm.TrackBar1Change(Sender: TObject);
begin
  FChoosenDatetime := DateOf(FChoosenDatetime) + TrackBar1.Position / 1440;
  RefreshDatetimeControls;
end;

procedure TCCalendarForm.CButtonChooseClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TCCalendarForm.CButtonMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FChoosenDatetime := Now;
  MonthCalendar.Date := FChoosenDatetime;
  TrackBar1.Position := Trunc(1440 * TimeOf(FChoosenDatetime));
  RefreshDatetimeControls;
end;

end.
