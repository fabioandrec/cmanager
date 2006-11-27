unit CWaitFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls;

const
  PBS_MARQUEE = $08;
  PBM_SETMARQUEE = (WM_USER + 10);


type
  TWaitType = (wtProgressbar, wtAnimate);

  TCWaitForm = class(TForm)
    ProgressBar: TProgressBar;
    LabelText: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    FWaitType: TWaitType;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  end;

procedure ShowWaitForm(AType: TWaitType; AText: String; AMin: Integer = 0; AMax: Integer = 0);
procedure StepWaitForm(AStep: Integer);
procedure HideWaitForm;

implementation

{$R *.dfm}

var GWaitForm: TCWaitForm;

procedure ShowWaitForm(AType: TWaitType; AText: String; AMin: Integer = 0; AMax: Integer = 0);
begin
  if GWaitForm <> Nil then begin
    FreeAndNil(GWaitForm);
  end;
  GWaitForm := TCWaitForm.Create(Nil);
  with GWaitForm do begin
    FWaitType := AType;
    LabelText.Caption := AText;
    if AType = wtProgressbar then begin
      ProgressBar.Min := AMin;
      ProgressBar.Position := AMin;
      ProgressBar.Max := AMax;
    end else begin
      ProgressBar.Min := 1;
      ProgressBar.Max := 20;
      ProgressBar.Position := 20;
      SendMessage(ProgressBar.Handle, PBM_SETMARQUEE, 1, 50);
    end;
  end;
  GWaitForm.Show;
  GWaitForm.Update;
end;

procedure StepWaitForm(AStep: Integer);
begin
  if GWaitForm <> Nil then begin
    if GWaitForm.FWaitType = wtProgressbar then begin
      GWaitForm.ProgressBar.StepBy(AStep);
    end;
  end;
end;

procedure HideWaitForm;
begin
  if GWaitForm <> Nil then begin
    FreeAndNil(GWaitForm);
  end;
end;

procedure TCWaitForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do begin
    WndParent := GetDesktopWindow;
    Style := WS_DLGFRAME or (WS_POPUP and (not WS_TABSTOP));
    ExStyle := WS_EX_TOPMOST or WS_EX_NOPARENTNOTIFY or WS_EX_TOOLWINDOW and (not WS_EX_APPWINDOW) or WS_EX_NOACTIVATE;
  end;
end;

procedure TCWaitForm.FormCreate(Sender: TObject);
var xLong: Integer;
begin
  xLong := GetWindowLong(ProgressBar.Handle, GWL_STYLE) or PBS_MARQUEE;
  SetWindowLong(ProgressBar.Handle, GWL_STYLE, xLong);
end;

initialization
finalization
  HideWaitForm;
end.
