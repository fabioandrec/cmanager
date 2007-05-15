unit CCalendarFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, ExtCtrls, CComponents, ActnList;

type
  TCCalendarForm = class(TForm)
    CButton: TCButton;
    MonthCalendar: TMonthCalendar;
    Bevel: TBevel;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SpeedButton1Click(Sender: TObject);
    procedure MonthCalendarDblClick(Sender: TObject);
    procedure CButtonClick(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WndProc(var Message: TMessage); override;
  end;

function ShowCalendar(AParent: TWinControl; var ADate: TDateTime): Boolean;

implementation

uses DateUtils, Types;

{$R *.dfm}

function ShowCalendar(AParent: TWinControl; var ADate: TDateTime): Boolean;
begin
  Result := False;
  with TCCalendarForm.Create(Nil) do begin
    MonthCalendar.Date := ADate;
    Top := AParent.ClientOrigin.Y + AParent.Height + 2;
    Left := AParent.ClientOrigin.X + 4;
    if Left + Width > Screen.Width then begin
      Left := Screen.Width - Width - 5;
    end;
    Show;
    repeat
      Application.HandleMessage;
    until (ModalResult = mrOk) or (ModalResult = mrCancel);
    if ModalResult = mrOk then begin
      Result := True;
      ADate := MonthCalendar.Date;
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

procedure TCCalendarForm.SpeedButton1Click(Sender: TObject);
begin
  MonthCalendar.Date := Today;
  ModalResult := mrOk;
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
begin
  xPoint := MonthCalendar.ScreenToClient(Mouse.CursorPos);
  if xPoint.Y > MonthCalendar.Height / 4 then begin
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
  MonthCalendar.Date := Today;
  ModalResult := mrOk;
end;

end.
