unit CMainFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ComCtrls, ExtCtrls, XPStyleActnCtrls, ActnList, ActnMan, ToolWin,
  ActnCtrls, ActnMenus, ImgList, StdCtrls, Buttons, Dialogs, CommCtrl,
  CComponents;

type
  TCMainForm = class(TForm)
    MenuBar: TActionMainMenuBar;
    StatusBar: TStatusBar;
    PanelTitle: TPanel;
    BevelU2: TBevel;
    PanelShortcuts: TPanel;
    Splitter: TSplitter;
    BevelU1: TBevel;
    PanelFrames: TPanel;
    PanelShortcutsTitle: TPanel;
    SpeedButtonCloseShortcuts: TSpeedButton;
    LabelShortcut: TLabel;
    ImageListActionManager: TImageList;
    ImageShortcut: TImage;
    ActionManager: TActionManager;
    ActionShortcuts: TAction;
    ActionShorcutDefault: TAction;
    ActionShortcutAccounts: TAction;
    ActionShortcutProducts: TAction;
    ActionShortcutCashpoints: TAction;
    ActionShortcutReports: TAction;
    CDateTime: TCDateTime;
    ActionShortcutPlanned: TAction;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButtonCloseShortcutsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ActionShortcutsExecute(Sender: TObject);
    procedure CDateTimeChanged(Sender: TObject);
  private
    FShortcutsFrames: TStringList;
    FActiveFrame: TFrame;
    function GetShortcutsVisible: Boolean;
    procedure SetShortcutsVisible(const Value: Boolean);
    procedure ActionShortcutExecute(Sender: TObject);
    procedure PerformShortcutAction(AAction: TAction);
  published
    property ShortcutsVisible: Boolean read GetShortcutsVisible write SetShortcutsVisible;
  end;

var
  CMainForm: TCMainForm;

implementation

uses CDataObjects, CDatabase, Math, CBaseFrameUnit,
     CCashpointsFrameUnit, CFrameFormUnit, CAccountsFrameUnit,
  CProductsFrameUnit, CTodayFrameUnit, CListFrameUnit, DateUtils,
  CReportsFrameUnit, CReports, CPlannedFrameUnit;

{$R *.dfm}

procedure TCMainForm.FormCreate(Sender: TObject);
var xCount: Integer;
    xAction: TContainedAction;
    xButton: TCButton;
    xIndex: Integer;
begin
  FShortcutsFrames := TStringList.Create;
  ActionShortcuts.Checked := ShortcutsVisible;
  xIndex := 0;
  for xCount := 0 to ActionManager.ActionCount - 1 do begin
    xAction := ActionManager.Actions[xCount];
    if AnsiUpperCase(xAction.Category) = 'SKRÓTY' then begin
      xAction.OnExecute := ActionShortcutExecute;
      xButton := TCButton.Create(Self);
      xButton.Width := 81;
      xButton.Height := 57;
      xButton.Left := 24;
      xButton.Top := 32 + xIndex * 67;
      xButton.Parent := PanelShortcuts;
      xButton.Action := xAction;
      Inc(xIndex);
    end;
  end;
  PerformShortcutAction(ActionShorcutDefault);
end;

function TCMainForm.GetShortcutsVisible: Boolean;
begin
  Result := PanelShortcuts.Visible;
end;

procedure TCMainForm.SetShortcutsVisible(const Value: Boolean);
begin
  DisableAlign;
  if Value then begin
    Splitter.Visible := True;
    PanelShortcuts.Visible := True;
    ActionShortcuts.Checked := True;
  end else begin
    Splitter.Visible := False;
    PanelShortcuts.Visible := False;
    ActionShortcuts.Checked := False;
  end;
  EnableAlign;
end;

procedure TCMainForm.SpeedButtonCloseShortcutsClick(Sender: TObject);
begin
  ShortcutsVisible := False;
end;

procedure TCMainForm.FormDestroy(Sender: TObject);
begin
  FShortcutsFrames.Free;
end;

procedure TCMainForm.PerformShortcutAction(AAction: TAction);
var xFrame: TCBaseFrame;
    xIndex: Integer;
    xBrush: HBRUSH;
    xClass: TCBaseFrameClass;
begin
  xIndex := FShortcutsFrames.IndexOf(AAction.Caption);
  if xIndex = -1 then begin
    if AAction = ActionShorcutDefault then begin
      xClass := TCTodayFrame;
    end else if AAction = ActionShortcutPlanned then begin
      xClass := TCPlannedFrame;
    end else if AAction = ActionShortcutCashpoints then begin
      xClass := TCCashpointsFrame;
    end else if AAction = ActionShortcutAccounts then begin
      xClass := TCAccountsFrame;
    end else if AAction = ActionShortcutProducts then begin
      xClass := TCProductsFrame;
    end else if AAction = ActionShortcutReports then begin
      xClass := TCReportsFrame;
    end else begin
      xClass := TCBaseFrame;
    end;
    xFrame := xClass.Create(Self);
    xFrame.Name := AAction.Name + 'Frame';
    xFrame.Width := PanelFrames.Width;
    xFrame.Height := PanelFrames.Height;
    xFrame.DisableAlign;
    xFrame.Visible := False;
    xFrame.InitializeFrame(Nil);
    xFrame.Parent := PanelFrames;
    xFrame.EnableAlign;
    FShortcutsFrames.AddObject(AAction.Caption, xFrame);
  end else begin
    xFrame := TCBaseFrame(FShortcutsFrames.Objects[xIndex]);
  end;
  if FActiveFrame <> xFrame then begin
    if FActiveFrame <> Nil then begin
      FActiveFrame.Hide;
    end;
    FActiveFrame := xFrame;
    FActiveFrame.Parent := PanelFrames;
    FActiveFrame.Show;
    LabelShortcut.Caption := AAction.Caption;
    xBrush := CreateSolidBrush(ColorToRGB(PanelTitle.Color));
    SelectObject(ImageShortcut.Canvas.Handle, xBrush);
    FillRect(ImageShortcut.Canvas.Handle, Rect(0, 0, ImageShortcut.Width, ImageShortcut.Height), xBrush);
    DeleteObject(xBrush);
    ImageList_Draw(ImageListActionManager.Handle, AAction.ImageIndex, ImageShortcut.Canvas.Handle, 0, 0, ILD_NORMAL);
  end;
end;

procedure TCMainForm.ActionShortcutExecute(Sender: TObject);
begin
  PerformShortcutAction(TAction(Sender));
end;

procedure TCMainForm.ActionShortcutsExecute(Sender: TObject);
begin
  ShortcutsVisible := not ShortcutsVisible;
end;

procedure TCMainForm.CDateTimeChanged(Sender: TObject);
var xIndex: Integer;
begin
  xIndex := FShortcutsFrames.IndexOf(ActionShorcutDefault.Caption);
  if xIndex <> -1 then begin
    TCTodayFrame(FShortcutsFrames.Objects[xIndex]).ReloadToday;
    TCTodayFrame(FShortcutsFrames.Objects[xIndex]).ReloadSums;
  end;
end;

end.

