unit StartupFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TStartupForm = class(TForm)
    Timer: TTimer;
    Label1: TLabel;
    Label2: TLabel;
    procedure TimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FStarttime: TDateTime;
    procedure UpdateTime;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
  end;

var GStartupForm: TStartupForm;
    GShutdownEvent: THandle;

implementation

uses DateUtils, Types;

{$R *.dfm}

procedure TStartupForm.TimerTimer(Sender: TObject);
begin
  UpdateTime;
end;

procedure TStartupForm.FormCreate(Sender: TObject);
begin
  FStarttime := Now;
  UpdateTime;
  Left := Screen.WorkAreaRect.Right - Width - 5;
  Top := Screen.WorkAreaRect.Bottom - Height - 5;
end;

procedure TStartupForm.UpdateTime;
var xSeconds: Int64;
begin
  xSeconds := SecondsBetween(Now, FStarttime);
  Label2.Caption := IntToStr(xSeconds) + ' sekund';
end;

procedure TStartupForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or WS_DLGFRAME;
  Params.ExStyle := Params.ExStyle or WS_EX_TOPMOST;
end;

end.
