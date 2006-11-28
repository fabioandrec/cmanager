unit CWaitFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls;

type
  TWaitType = (wtProgressbar, wtAnimate);

  TWaitThread = class(TThread)
  protected
    procedure Execute; override;
  end;

  TCWaitForm = class(TForm)
    ProgressBar: TProgressBar;
    LabelText: TLabel;
  private
    FWaitType: TWaitType;
    FWaitThread: TWaitThread;
    FWaitHandle: THandle;
  protected
    procedure DoAnimate;
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
      ProgressBar.Visible := True;
      ProgressBar.Min := AMin;
      ProgressBar.Position := AMin;
      ProgressBar.Max := AMax;
    end else begin
      ProgressBar.Visible := False;
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

procedure TCWaitForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do begin
    WndParent := GetDesktopWindow;
    Style := WS_DLGFRAME or (WS_POPUP and (not WS_TABSTOP));
    ExStyle := WS_EX_TOPMOST or WS_EX_NOPARENTNOTIFY or WS_EX_TOOLWINDOW and (not WS_EX_APPWINDOW) or WS_EX_NOACTIVATE;
  end;
end;

{ TWaitThread }

procedure TWaitThread.Execute;
var xRes: Integer;
begin
  while not Terminated do begin
    xRes := WaitForSingleObject(GWaitForm.FWaitHandle, 10);
    if xRes = WAIT_TIMEOUT then begin
      GWaitForm.DoAnimate;
    end;
  end;
end;

procedure TCWaitForm.DoAnimate;
begin
end;

initialization
finalization
  HideWaitForm;
end.
