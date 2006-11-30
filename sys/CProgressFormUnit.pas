unit CProgressFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Math, ComCtrls, ImgList,
  PngImageList, CComponents;

const
  CIMAGE_OK = 0;
  CIMAGE_ERROR = 1;

type
  TProgressClass = class of TCProgressForm;

  TWaitType = (wtProgressbar, wtAnimate);

  TWaitThread = class(TThread)
  private
    FProgress: TStaticText;
    FWaitHandle: THandle;
    FCurLeft: Integer;
    FCurWidth: Integer;
  protected
    procedure DoAnimate;
    procedure Execute; override;
  public
    constructor Create(AWaitHandle: THandle; AProgress: TStaticText);
    property Progress: TStaticText read FProgress write FProgress;
    property WaitHandle: THandle read FWaitHandle write FWaitHandle;
  end;

  TCProgressForm = class(TForm)
    PanelButtons: TPanel;
    BitBtnOk: TBitBtn;
    BitBtnCancel: TBitBtn;
    PanelConfig: TPanel;
    PageControl: TPageControl;
    TabSheetStart: TTabSheet;
    TabSheetWork: TTabSheet;
    TabSheetEnd: TTabSheet;
    StaticText: TStaticText;
    ProgressBar: TProgressBar;
    PngImageList: TPngImageList;
    CImageStart: TCImage;
    CImageWork: TCImage;
    CImageEnd: TCImage;
    procedure BitBtnOkClick(Sender: TObject);
    procedure BitBtnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FWaitThread: TWaitThread;
    FWaitHandle: THandle;
    FWaitType: TWaitType;
    FReport: TStringList;
    procedure InitializeProgress(AWaitType: TWaitType; AMin: Integer = 0; AMax: Integer = 100);
    procedure FinalizeProgress;
    function GetDisabled: Boolean;
    procedure SetDisabled(const Value: Boolean);
  protected
    procedure InitializeForm; virtual;
    function GetMin: Integer; virtual;
    function GetMax: Integer; virtual;
    function GetProgressType: TWaitType; virtual;
    function DoWork: Boolean; virtual; 
    procedure NextTab;
    procedure AddToReport(AText: String);
  public
    property Disabled: Boolean read GetDisabled write SetDisabled;
    property Report: TStringList read FReport;
  end;

procedure ShowProgressForm(AClass: TProgressClass);

implementation

{$R *.dfm}

constructor TWaitThread.Create(AWaitHandle: THandle; AProgress: TStaticText);
begin
  inherited Create(True);
  FreeOnTerminate := False;
  FProgress := AProgress;
  FWaitHandle := AWaitHandle;
  FCurLeft := 1;
  FCurWidth := 0;
end;

procedure TWaitThread.DoAnimate;
var xDC: HDC;
    xBrush: HBRUSH;
begin
  xDC := GetDC(FProgress.Handle);
  try
    xBrush := CreateSolidBrush(ColorToRGB(clBtnFace));
    FillRect(xDC, Rect(0, 1, FProgress.Width - 1, FProgress.Height - 3), xBrush);
    DeleteObject(xBrush);
    xBrush := CreateSolidBrush(ColorToRGB(clHighlight));
    if FCurWidth < (FProgress.Width div 2) then begin
      Inc(FCurWidth);
    end else begin
      if FCurLeft > FProgress.Width - 4 then begin
        FCurLeft := 1;
        FCurWidth := 0;
      end else begin
        Inc(FCurLeft);
      end;
    end;
    FillRect(xDC, Rect(FCurLeft, 1, Min(FCurLeft + FCurWidth - 1, FProgress.Width - 4), FProgress.Height - 3), xBrush);
    DeleteObject(xBrush);
  finally
    ReleaseDC(FProgress.Handle, xDC);
  end;
end;

procedure TWaitThread.Execute;
var xRes: Integer;
begin
  while not Terminated do begin
    xRes := WaitForSingleObject(FWaitHandle, 5);
    if xRes = WAIT_TIMEOUT then begin
      DoAnimate;
    end;
  end;
end;

procedure TCProgressForm.BitBtnOkClick(Sender: TObject);
var xRes: Boolean;
begin
  NextTab;
  Disabled := True;
  InitializeProgress(GetProgressType, GetMin, GetMax);
  xRes := DoWork;
  FinalizeProgress;
  NextTab;
  if xRes then begin
    CImageEnd.ImageIndex := CIMAGE_OK;
  end else begin
    CImageEnd.ImageIndex := CIMAGE_ERROR;
  end;
  Disabled := False;
  BitBtnOk.Visible := False;
  BitBtnCancel.Caption := '&Zamknij';
  BitBtnCancel.Default := True;
  BitBtnCancel.SetFocus;
end;

procedure TCProgressForm.FinalizeProgress;
begin
  StaticText.Visible := False;
  ProgressBar.Visible := False;
  if FWaitType = wtAnimate then begin
    FWaitThread.Terminate;
    SetEvent(FWaitHandle);
    FWaitThread.WaitFor;
    FWaitThread.Free;
  end;
end;

function TCProgressForm.GetDisabled: Boolean;
begin
  Result := not BitBtnCancel.Enabled;
end;

function TCProgressForm.GetMax: Integer;
begin
  Result := 100;
end;

function TCProgressForm.GetMin: Integer;
begin
  Result := 0;
end;

procedure TCProgressForm.InitializeProgress(AWaitType: TWaitType; AMin, AMax: Integer);
begin
  FWaitType := AWaitType;
  if AWaitType = wtProgressbar then begin
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


procedure TCProgressForm.SetDisabled(const Value: Boolean);
var hMenu: THandle;
    xOpt: Cardinal;
begin
  BitBtnOk.Enabled := not Value;
  BitBtnCancel.Enabled := not Value;
  hMenu := GetSystemMenu(Handle, False);
  if Value then begin
    xOpt := MF_DISABLED + MF_GRAYED;
  end else begin
    xOpt := MF_ENABLED;
  end;
  EnableMenuItem(hMenu, SC_CLOSE, xOpt);
end;

procedure ShowProgressForm(AClass: TProgressClass);
var xForm: TCProgressForm;
begin
  xForm := AClass.Create(Nil);
  xForm.ShowModal;
  xForm.Free;
end;

procedure TCProgressForm.BitBtnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TCProgressForm.FormCreate(Sender: TObject);
begin
  InitializeForm;
  PageControl.ActivePageIndex := 0;
  StaticText.Visible := False;
  ProgressBar.Visible := False;
  FReport := TStringList.Create;
end;

procedure TCProgressForm.NextTab;
begin
  PageControl.ActivePageIndex := PageControl.ActivePageIndex + 1;
  PageControl.ActivePage.Refresh;
end;

procedure TCProgressForm.InitializeForm;
begin
end;

procedure TCProgressForm.FormDestroy(Sender: TObject);
begin
  FReport.Free;
end;

procedure TCProgressForm.AddToReport(AText: String);
begin
  FReport.Add(FormatDateTime('hh:nn:ss', Now) + ' ' + AText);
end;

function TCProgressForm.DoWork: Boolean;
begin
  Result := True;
end;

function TCProgressForm.GetProgressType: TWaitType;
begin
  Result := wtAnimate;
end;

end.
