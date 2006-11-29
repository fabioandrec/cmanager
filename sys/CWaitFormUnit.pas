unit CWaitFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Math, CProgressFormUnit;

type
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
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

procedure ShowWaitForm(AType: TWaitType; AText: String; AMin: Integer = 0; AMax: Integer = 100);
procedure StepWaitForm(AStep: Integer);
procedure PositionWaitForm(APosition: Integer);
procedure HideWaitForm;

implementation

{$R *.dfm}

var GWaitForm: TCWaitForm;

procedure ShowWaitForm(AType: TWaitType; AText: String; AMin: Integer = 0; AMax: Integer = 100);
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
      StaticText.Visible := False;
      ProgressBar.Min := AMin;
      ProgressBar.Position := AMin;
      ProgressBar.Max := AMax;
    end else begin
      ProgressBar.Visible := False;
      StaticText.Visible := True;
      FWaitHandle := CreateEvent(Nil, True, False, Nil);
      FWaitThread := TWaitThread.Create(FWaitHandle, StaticText);
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

procedure PositionWaitForm(APosition: Integer);
begin
  if GWaitForm <> Nil then begin
    if GWaitForm.FWaitType = wtProgressbar then begin
      GWaitForm.ProgressBar.Position := APosition;
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

initialization
finalization
  HideWaitForm;
end.
