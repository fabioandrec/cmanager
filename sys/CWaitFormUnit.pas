unit CWaitFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Math;

type
  TWaitType = (wtProgressbar, wtAnimate);

  TWaitThread = class(TThread)
  protected
    procedure Execute; override;
  end;

  TCWaitForm = class(TForm)
    ProgressBar: TProgressBar;
    LabelText: TLabel;
    StaticText: TStaticText;
  private
    FWaitType: TWaitType;
    FWaitThread: TWaitThread;
    FWaitHandle: THandle;
    FCurLeft: Integer;
    FCurWidth: Integer;
  protected
    procedure DoAnimate;
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor Create(AOwner: TComponent); override;
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
      ProgressBar.Visible := True;
      ProgressBar.Min := AMin;
      ProgressBar.Position := AMin;
      ProgressBar.Max := AMax;
    end else begin
      //ProgressBar.Visible := False;
      FWaitHandle := CreateEvent(Nil, True, False, Nil);
      FWaitThread := TWaitThread.Create(True);
      FWaitThread.FreeOnTerminate := False;
      FWaitThread.Resume;
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
    with GWaitForm do begin
      if FWaitType = wtAnimate then begin
        FWaitThread.Terminate;
        SetEvent(FWaitHandle);
        FWaitThread.WaitFor;
        FWaitThread.Free;
      end;
    end;
    FreeAndNil(GWaitForm);
  end;
end;

constructor TCWaitForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCurLeft := 1;
  FCurWidth := 0;
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

procedure TWaitThread.Execute;
var xRes: Integer;
begin
  while not Terminated do begin
    xRes := WaitForSingleObject(GWaitForm.FWaitHandle, 5);
    if xRes = WAIT_TIMEOUT then begin
      GWaitForm.DoAnimate;
    end;
  end;
end;

procedure TCWaitForm.DoAnimate;
var xDC: HDC;
    xBrush: HBRUSH;
begin
  xDC := GetDC(StaticText.Handle);
  try
    xBrush := CreateSolidBrush(ColorToRGB(clBtnFace));
    FillRect(xDC, Rect(0, 1, StaticText.Width - 1, StaticText.Height - 3), xBrush);
    DeleteObject(xBrush);
    xBrush := CreateSolidBrush(ColorToRGB(clHighlight));
    if FCurWidth < (StaticText.Width div 2) then begin
      Inc(FCurWidth);
    end else begin
      if FCurLeft > StaticText.Width - 4 then begin
        FCurLeft := 1;
        FCurWidth := 0;
      end else begin
        Inc(FCurLeft);
      end;
    end;
    FillRect(xDC, Rect(FCurLeft, 1, Min(FCurLeft + FCurWidth - 1, StaticText.Width - 4), StaticText.Height - 3), xBrush);
    DeleteObject(xBrush);
  finally
    ReleaseDC(StaticText.Handle, xDC);
  end;
end;

initialization
finalization
  HideWaitForm;
end.
