unit CMainFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ComCtrls, ExtCtrls, XPStyleActnCtrls, ActnList, ActnMan, ToolWin,
  ActnCtrls, ActnMenus, ImgList, StdCtrls, Buttons, Dialogs, CommCtrl,
  CComponents, VirtualTrees, ActnColorMaps, CConfigFormUnit, PngImageList,
  PngSpeedButton, ShellApi;

type
  TCMainForm = class(TForm)
    MenuBar: TActionMainMenuBar;
    StatusBar: TCStatusBar;
    ActionManager: TActionManager;
    ActionShortcuts: TAction;
    ActionShorcutOperations: TAction;
    ActionShortcutAccounts: TAction;
    ActionShortcutProducts: TAction;
    ActionShortcutCashpoints: TAction;
    ActionShortcutReports: TAction;
    ActionShortcutPlanned: TAction;
    ActionShortcutPlannedDone: TAction;
    ActionStatusbar: TAction;
    ActionAbout: TAction;
    ActionCloseConnection: TAction;
    ActionOpenConnection: TAction;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    ActionCreateConnection: TAction;
    ActionShortcutFilters: TAction;
    ActionShortcutStart: TAction;
    ActionCompact: TAction;
    ActionHelp: TAction;
    PanelNotconnected: TPanel;
    PanelMain: TPanel;
    BevelU2: TBevel;
    PanelTitle: TPanel;
    BevelU1: TBevel;
    LabelShortcut: TLabel;
    PngImage: TPngSpeedButton;
    CDateTime: TCDateTime;
    PanelFrames: TPanel;
    PanelShortcuts: TPanel;
    PanelShortcutsTitle: TPanel;
    SpeedButtonCloseShortcuts: TSpeedButton;
    ShortcutList: TVirtualStringTree;
    ActionBackup: TAction;
    ActionRestore: TAction;
    ActionCheckDatafile: TAction;
    ActionPreferences: TAction;
    ActionShortcutProfiles: TAction;
    ActionLoanCalc: TAction;
    ActionCheckUpdates: TAction;
    ActionExport: TAction;
    ActionRandom: TAction;
    ActionShortcutLimits: TAction;
    ActionShortcutCurrencydef: TAction;
    ActionShortcutCurrencyRate: TAction;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButtonCloseShortcutsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ActionShortcutsExecute(Sender: TObject);
    procedure CDateTimeChanged(Sender: TObject);
    procedure ShortcutListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure ShortcutListHotChange(Sender: TBaseVirtualTree; OldNode, NewNode: PVirtualNode);
    procedure ShortcutListClick(Sender: TObject);
    procedure ShortcutListAfterItemPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect);
    procedure ActionStatusbarExecute(Sender: TObject);
    procedure ActionAboutExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ActionCloseConnectionExecute(Sender: TObject);
    procedure ActionOpenConnectionExecute(Sender: TObject);
    procedure ActionCreateConnectionExecute(Sender: TObject);
    procedure ActionHelpExecute(Sender: TObject);
    procedure ActionCompactExecute(Sender: TObject);
    procedure ActionBackupExecute(Sender: TObject);
    procedure ActionRestoreExecute(Sender: TObject);
    procedure ActionCheckDatafileExecute(Sender: TObject);
    procedure ActionPreferencesExecute(Sender: TObject);
    procedure ShortcutListMeasureItem(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
    procedure ActionLoanCalcExecute(Sender: TObject);
    procedure ActionCheckUpdatesExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ActionExportExecute(Sender: TObject);
    procedure ActionRandomExecute(Sender: TObject);
    procedure StatusBarClick(Sender: TObject);
  private
    FShortcutList: TStringList;
    FShortcutsFrames: TStringList;
    FActiveFrame: TFrame;
    function GetShortcutsVisible: Boolean;
    procedure SetShortcutsVisible(const Value: Boolean);
    procedure PerformShortcutAction(AAction: TAction);
    procedure UpdateShortcutList;
    function GetStatusbarVisible: Boolean;
    procedure SetStatusbarVisible(const Value: Boolean);
    procedure UnhandledException(Sender: TObject; E: Exception);
    function CallHelp(ACommand: Word; AData: Longint; var ACallHelp: Boolean): Boolean;
  protected
    procedure WndProc(var Message: TMessage); override;
  public
    procedure ActionShortcutExecute(ASender: TObject);
    procedure ActionPluginsExecute(ASender: TObject);
    procedure UpdateStatusbar;
    procedure UpdatePluginsMenu;
    procedure FinalizeMainForm;
    function OpenConnection(AFilename: String; var AError: String; var ADesc: String): Boolean;
  published
    property ShortcutsVisible: Boolean read GetShortcutsVisible write SetShortcutsVisible;
    property StatusbarVisible: Boolean read GetStatusbarVisible write SetStatusbarVisible;
  end;

var
  CMainForm: TCMainForm;

implementation

uses CDataObjects, CDatabase, Math, CBaseFrameUnit,
     CCashpointsFrameUnit, CFrameFormUnit, CAccountsFrameUnit,
     CProductsFrameUnit, CMovementFrameUnit, CListFrameUnit, DateUtils,
     CReportsFrameUnit, CReports, CPlannedFrameUnit, CDoneFrameUnit,
     CAboutFormUnit, CSettings, CFilterFrameUnit, CHomeFrameUnit,
     CInfoFormUnit, CWaitFormUnit, CCompactDatafileFormUnit,
     CProgressFormUnit, CConsts, CArchFormUnit, CCheckDatafileFormUnit,
     CPreferencesFormUnit, CImageListsUnit, Types, CPreferences,
     CProfileFrameUnit, CLoanCalculatorFormUnit, CDatatools, CHelp,
     CExportDatafileFormUnit, CRandomFormUnit, CLimitsFrameUnit,
     CReportFormUnit, CMemoFormUnit, CCurrencydefFrameUnit,
     CCurrencyRateFrameUnit, CPlugins, CPluginConsts;

{$R *.dfm}

function FindActionClientByCaption(AActionClients: TActionClients; ACaption: String): TActionClientItem;
var xCount: Integer;
    xItem: TActionClientItem;
    xCaption: String;
begin
  Result := Nil;
  xCount := 0;
  xCaption := AnsiUpperCase(StringReplace(ACaption, '&', '', [rfReplaceAll, rfIgnoreCase]));
  while (Result = Nil) and (xCount <= AActionClients.Count - 1) do begin
    xItem := TActionClientItem(AActionClients.Items[xCount]);
    if AnsiUpperCase(StringReplace(xItem.Caption, '&', '', [rfReplaceAll, rfIgnoreCase])) = xCaption then begin
      Result := xItem;
    end else begin
      Result := FindActionClientByCaption(xItem.Items, ACaption);
    end;
    Inc(xCount);
  end;
end;

procedure TCMainForm.FormCreate(Sender: TObject);
begin
  Application.OnException := UnhandledException;
  Application.OnHelp := CallHelp;
  FShortcutsFrames := TStringList.Create;
  CDateTime.Value := GWorkDate;
  FShortcutList := TStringList.Create;
  ShortcutsVisible := GBasePreferences.showShortcutBar;
  StatusbarVisible := GBasePreferences.showStatusBar;
  ActionShortcuts.Checked := ShortcutsVisible;
  ActionStatusbar.Checked := StatusbarVisible;
  {$IFNDEF DEBUG}
  ActionRandom.Visible := False;
  {$ENDIF}
  UpdateShortcutList;
  UpdateStatusbar;
  ShortcutList.RootNodeCount := FShortcutList.Count + 1;
  PerformShortcutAction(ActionShortcutStart);
end;

function TCMainForm.GetShortcutsVisible: Boolean;
begin
  Result := PanelShortcuts.Visible;
end;

procedure TCMainForm.SetShortcutsVisible(const Value: Boolean);
begin
  DisableAlign;
  if Value then begin
    PanelShortcuts.Visible := True;
    ActionShortcuts.Checked := True;
  end else begin
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
  FShortcutList.Free;
end;

procedure TCMainForm.PerformShortcutAction(AAction: TAction);
var xFrame: TCBaseFrame;
    xIndex: Integer;
    xClass: TCBaseFrameClass;
begin
  xIndex := FShortcutsFrames.IndexOf(AAction.Caption);
  if xIndex = -1 then begin
    if AAction = ActionShortcutStart then begin
      xClass := TCHomeFrame;
    end else if AAction = ActionShorcutOperations then begin
      xClass := TCMovementFrame;
    end else if AAction = ActionShortcutPlanned then begin
      xClass := TCPlannedFrame;
    end else if AAction = ActionShortcutPlannedDone then begin
      xClass := TCDoneFrame;
    end else if AAction = ActionShortcutCashpoints then begin
      xClass := TCCashpointsFrame;
    end else if AAction = ActionShortcutAccounts then begin
      xClass := TCAccountsFrame;
    end else if AAction = ActionShortcutProducts then begin
      xClass := TCProductsFrame;
    end else if AAction = ActionShortcutReports then begin
      xClass := TCReportsFrame;
    end else if AAction = ActionShortcutFilters then begin
      xClass := TCFilterFrame;
    end else if AAction = ActionShortcutProfiles then begin
      xClass := TCProfileFrame;
    end else if AAction = ActionShortcutLimits then begin
      xClass := TCLimitsFrame;
    end else if AAction = ActionShortcutCurrencydef then begin
      xClass := TCCurrencydefFrame;
    end else if AAction = ActionShortcutCurrencyRate then begin
      xClass := TCCurrencyRateFrame;
    end else begin
      xClass := TCBaseFrame;
    end;
    xFrame := xClass.Create(Self);
    xFrame.Name := AAction.Name + 'Frame';
    xFrame.Width := PanelFrames.Width;
    xFrame.Height := PanelFrames.Height;
    xFrame.DisableAlign;
    xFrame.Visible := False;
    xFrame.InitializeFrame(Self, Nil, Nil, Nil);
    xFrame.PrepareCheckStates;
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
    if AAction.ImageIndex <> -1 then begin
      PngImage.PngImage := CImageLists.MainImageList16x16.PngImages.Items[AAction.ImageIndex].PngImage;
    end;
  end;
end;

procedure TCMainForm.ActionShortcutsExecute(Sender: TObject);
begin
  ShortcutsVisible := not ShortcutsVisible;
end;

procedure TCMainForm.CDateTimeChanged(Sender: TObject);
var xIndex: Integer;
begin
  xIndex := FShortcutsFrames.IndexOf(ActionShorcutOperations.Caption);
  if xIndex <> -1 then begin
    TCMovementFrame(FShortcutsFrames.Objects[xIndex]).ReloadToday;
    TCMovementFrame(FShortcutsFrames.Objects[xIndex]).ReloadSums;
  end;
end;

procedure TCMainForm.ShortcutListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
begin
  if Node.Index = 0 then begin
    CellText := '';
  end else begin
    CellText := FShortcutList.Strings[Node.Index - 1];
  end;
end;

procedure TCMainForm.ShortcutListHotChange(Sender: TBaseVirtualTree; OldNode, NewNode: PVirtualNode);
begin
  if NewNode <> Nil then begin
    if NewNode.Index <> 0 then begin
      Sender.Cursor := crHandPoint;
    end;
  end else begin
    Sender.Cursor := crDefault;
  end;
end;

procedure TCMainForm.ShortcutListClick(Sender: TObject);
var xAction: TAction;
begin
  if (ShortcutList.FocusedNode <> Nil) then begin
    if (ShortcutList.FocusedNode.Index <> 0) then begin
      xAction := TAction(FShortcutList.Objects[ShortcutList.FocusedNode.Index - 1]);
      xAction.Execute;
    end;
  end;
end;

procedure TCMainForm.UpdateShortcutList;
var xCount: Integer;
    xAction: TAction;
begin
  for xCount := 0 to ActionManager.ActionCount - 1 do begin
    xAction := TAction(ActionManager.Actions[xCount]);
    if xAction.Category = 'Skr�ty' then begin
      FShortcutList.AddObject(xAction.Caption, xAction);
      xAction.OnExecute := ActionShortcutExecute;
    end;
  end;
end;

procedure TCMainForm.ShortcutListAfterItemPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect);
var xIndex, xLeft, xTop: Integer;
begin
  if Node.Index <> 0 then begin
    xIndex := TAction(FShortcutList.Objects[Node.Index - 1]).ImageIndex;
    xLeft := ((ItemRect.Right - ItemRect.Left - CImageLists.MainImageList32x32.Width) div 2);
    xTop := 0;
    CImageLists.MainImageList32x32.Draw(TargetCanvas, xLeft, xTop, xIndex);
  end;
end;

procedure TCMainForm.ActionShortcutExecute(ASender: TObject);
begin
  PerformShortcutAction(TAction(ASender));
end;

procedure TCMainForm.ActionStatusbarExecute(Sender: TObject);
begin
  StatusbarVisible := not StatusbarVisible;
end;

function TCMainForm.GetStatusbarVisible: Boolean;
begin
  Result := StatusBar.Visible;
end;

procedure TCMainForm.SetStatusbarVisible(const Value: Boolean);
begin
  DisableAlign;
  if Value then begin
    StatusBar.Visible := True;
    ActionStatusbar.Checked := True;
  end else begin
    StatusBar.Visible := False;
    ActionStatusbar.Checked := False;
  end;
  EnableAlign;
end;

procedure TCMainForm.UpdateStatusbar;
var xCount: Integer;
    xAction: TAction;
begin
  PanelNotconnected.Visible := not GDataProvider.IsConnected;
  PanelNotconnected.Align := alClient;
  PanelMain.Visible := GDataProvider.IsConnected;
  if PanelMain.Visible then begin
    Caption := 'CManager - obs�uga finans�w (na dzie� ' + DateToStr(GWorkDate) + ')';
    StatusBar.Panels.Items[0].Text := ' Otwarty plik danych: ' + AnsiLowerCase(ExpandFileName(GDatabaseName));
  end else begin
    Caption := 'CManager - obs�uga finans�w';
    StatusBar.Panels.Items[0].Text := ' (brak otwartego pliku danych)';
  end;
  for xCount := 0 to ActionManager.ActionCount - 1 do begin
    xAction := TAction(ActionManager.Actions[xCount]);
    if xAction.Category = 'Skr�ty' then begin
      xAction.Visible := GDataProvider.IsConnected;
    end;
  end;
  TActionClient(ActionManager.ActionBars.ActionBars[1].Items.Items[2]).Visible := GDataProvider.IsConnected;
  ActionShortcuts.Visible := GDataProvider.IsConnected;
  ActionCloseConnection.Enabled := GDataProvider.IsConnected;
  ActionOpenConnection.Enabled := not GDataProvider.IsConnected;
  ActionCreateConnection.Enabled := not GDataProvider.IsConnected;
end;

procedure TCMainForm.ActionAboutExecute(Sender: TObject);
var xAbout: TCAboutForm;
begin
  xAbout := TCAboutForm.Create(Nil);
  xAbout.ShowConfig(coNone);
  xAbout.Free;
end;

procedure TCMainForm.FormShow(Sender: TObject);
begin
  LoadFormPosition(Self);
end;

procedure TCMainForm.WndProc(var Message: TMessage);
begin
  inherited WndProc(Message);
  if Message.Msg = WM_FORMMAXIMIZE then begin
    WindowState := wsMaximized;
  end else if Message.Msg = WM_FORMMINIMIZE then begin
    WindowState := wsMaximized;
  end else if Message.Msg = WM_PREFERENCESCHANGED then begin
    ShortcutsVisible := GBasePreferences.showShortcutBar;
    StatusbarVisible := GBasePreferences.showStatusBar;
    Invalidate;
  end else if Message.Msg = WM_OPENCONNECTION then begin
  end else if Message.Msg = WM_CLOSECONNECTION then begin
    ActionCloseConnection.Execute;
  end else if Message.Msg = WM_STATCLEAR then begin
    StatusBar.Panels.Items[1].Text := '';
    TCStatusPanel(StatusBar.Panels.Items[1]).ImageIndex := -1;
    TCStatusPanel(StatusBar.Panels.Items[1]).Clickable := False;
  end else if Message.Msg = WM_STATBACKUPSTARTED then begin
    StatusBar.Panels.Items[1].Text := 'Trwa automatyczne wykonywanie kopii pliku danych. Wykonano 0%';
    TCStatusPanel(StatusBar.Panels.Items[1]).ImageIndex := 1;
  end else if Message.Msg = WM_STATPROGRESS then begin
    StatusBar.Panels.Items[1].Text := 'Trwa automatyczne wykonywanie kopii pliku danych. Wykonano ' + IntToStr(Message.LParam) + '%';
  end else if Message.Msg = WM_STATBACKUPFINISHEDSUCC then begin
    StatusBar.Panels.Items[1].Text := 'Poprawnie wykonano kopi� pliku danych';
    TCStatusPanel(StatusBar.Panels.Items[1]).ImageIndex := 2;
    TCStatusPanel(StatusBar.Panels.Items[1]).Clickable := True;
  end else if Message.Msg = WM_STATBACKUPFINISHEDERR then begin
    StatusBar.Panels.Items[1].Text := 'Podczas wykonywania kopii pliku danych wyst�pi� b��d';
    TCStatusPanel(StatusBar.Panels.Items[1]).ImageIndex := 3;
    TCStatusPanel(StatusBar.Panels.Items[1]).Clickable := True;
  end;
end;

procedure TCMainForm.ActionCloseConnectionExecute(Sender: TObject);
var xCount: Integer;
begin
  if GDataProvider.IsConnected then begin
    for xCount := 0 to FShortcutsFrames.Count - 1 do begin
      FShortcutsFrames.Objects[xCount].Free;
      FShortcutsFrames.Objects[xCount] := Nil;
    end;
    FShortcutsFrames.Clear;
    FActiveFrame := Nil;
    GDataProvider.DisconnectFromDatabase;
    UpdateStatusbar;
  end;
end;

procedure TCMainForm.ActionOpenConnectionExecute(Sender: TObject);
var xError, xDesc: String;
begin
  if OpenDialog.Execute then begin
    if not OpenConnection(OpenDialog.FileName, xError, xDesc) then begin
      ShowInfo(itError, xError, xDesc)
    end else begin
      ActionShortcutExecute(ActionShortcutStart);
      UpdateStatusbar;
    end;
  end;
end;

procedure TCMainForm.ActionCreateConnectionExecute(Sender: TObject);
var xError, xDesc: String;
begin
  if SaveDialog.Execute then begin
    if InitializeDataProvider(SaveDialog.FileName, xError, xDesc, True) then begin
      ActionShortcutExecute(ActionShortcutStart);
      UpdateStatusbar;
    end else begin
      ShowInfo(itError, xError, xDesc);
    end;
  end;
end;

procedure TCMainForm.ActionHelpExecute(Sender: TObject);
begin
  HelpShowDefault;
end;

procedure TCMainForm.ActionCompactExecute(Sender: TObject);
begin
  ShowProgressForm(TCCompactDatafileForm);
end;

function TCMainForm.OpenConnection(AFilename: String; var AError: String; var ADesc: String): Boolean;
begin
  Result := InitializeDataProvider(AFilename, AError, ADesc, False);
end;

procedure TCMainForm.ActionBackupExecute(Sender: TObject);
var xOperation: TArchOperation;
begin
  xOperation := aoBackup;
  ShowProgressForm(TCArchForm, @xOperation);
end;

procedure TCMainForm.ActionRestoreExecute(Sender: TObject);
var xOperation: TArchOperation;
begin
  xOperation := aoRestore;
  ShowProgressForm(TCArchForm, @xOperation);
end;

procedure TCMainForm.ActionCheckDatafileExecute(Sender: TObject);
begin
  ShowProgressForm(TCCheckDatafileFormUnit);
end;

procedure TCMainForm.ActionPreferencesExecute(Sender: TObject);
var xPrefs: TCPreferencesForm;
begin
  xPrefs := TCPreferencesForm.Create(Nil);
  xPrefs.ShowPreferences;
  xPrefs.Free;
end;

procedure TCMainForm.ShortcutListMeasureItem(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
begin
  if Node.Index = 0 then begin
    NodeHeight := 40;
  end else begin
    NodeHeight := 80;
  end;
end;

procedure TCMainForm.UnhandledException(Sender: TObject; E: Exception);
begin
  CMainForm.ActionCloseConnection.Execute;
  ShowInfo(itError, 'Podczas pracy wyst�pi� wyj�tek programowy. CManager zostanie zamkni�ty', E.Message);
  Application.Terminate;
end;

procedure TCMainForm.ActionLoanCalcExecute(Sender: TObject);
begin
  ShowLoanCalculator(False);
end;

procedure TCMainForm.ActionCheckUpdatesExecute(Sender: TObject);
begin
  CheckForUpdates(False);
end;

procedure TCMainForm.FinalizeMainForm;
var xCount: Integer;
begin
  for xCount := 0 to FShortcutsFrames.Count - 1 do begin
    TCBaseFrame(FShortcutsFrames.Objects[xCount]).SaveColumns;
  end;
  SaveFormPosition(Self);
end;

function TCMainForm.CallHelp(ACommand: Word; AData: Integer; var ACallHelp: Boolean): Boolean;
begin
  ShowMessage('Help');
  ACallHelp := False;
  Result := True;
end;

procedure TCMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  HelpCloseAll;
end;

procedure TCMainForm.ActionExportExecute(Sender: TObject);
begin
  ShowProgressForm(TCExportDatafileForm);
end;

procedure TCMainForm.ActionRandomExecute(Sender: TObject);
begin
  FillDatabaseExampleData;
end;

procedure TCMainForm.StatusBarClick(Sender: TObject);
var xPanel: TCStatusPanel;
begin
  xPanel := TCStatusPanel(StatusBar.GetPanelWithMouse);
  if xPanel = StatusBar.Panels.Items[1] then begin
    if GBackupThread <> Nil then begin
      xPanel.Clickable := False;
      xPanel.ImageIndex := -1;
      xPanel.Text := '';
      ShowReport('Raport z wykonania kopii pliku danych', GBackupThread.Report.Text, 400, 300);
    end;
  end;
end;

procedure TCMainForm.UpdatePluginsMenu;
var xMax, xCount: Integer;
    xAction: TAction;
    xPlugin: TCPlugin;
    xPluginBand: TActionClientItem;
begin
  xMax := GPlugins.GetCurrencyRatePluginCount;
  if xMax > 0 then begin
    xPluginBand :=  FindActionClientByCaption(ActionManager.ActionBars.ActionBars[1].Items, 'Wtyczki');
    if xPluginBand <> Nil then begin
      for xCount := 0 to GPlugins.Count - 1 do begin
        xPlugin := TCPlugin(GPlugins.Items[xCount]);
        if xPlugin.pluginType = CPLUGINTYPE_CURRENCYRATE then begin
          xAction := TAction.Create(Self);
          xAction.ActionList := ActionManager;
          xAction.Caption := xPlugin.pluginMenu;
          xAction.Tag := xCount;
          xAction.OnExecute := ActionPluginsExecute;
          with xPluginBand.Items.Add do begin
            Action := xAction;
          end;
        end;
      end;
    end;
  end;
end;

procedure TCMainForm.ActionPluginsExecute(ASender: TObject);
var xPlugin: TCPlugin;
    xConfig, xOutput: String;
    xPluginPref: TPluginPref;
begin
  xPlugin := TCPlugin(GPlugins.Items[TAction(ASender).Tag]);
  xPluginPref := TPluginPref(GPluginsPreferences.ByPrefname[xPlugin.fileName]);
  if xPluginPref = Nil then begin
    xConfig := '';
  end else begin
    xConfig := xPluginPref.configuration;
  end;
  if xPlugin.Execute(xConfig, xOutput) then begin
    UpdateCurrencyRates(xOutput);
  end;
end;

end.

