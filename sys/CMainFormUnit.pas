unit CMainFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ComCtrls, ExtCtrls, XPStyleActnCtrls, ActnList, ActnMan, ToolWin,
  ActnCtrls, ActnMenus, StdCtrls, Buttons, Dialogs, CDatabase,
  CComponents, VirtualTrees, PngImageList, CXml, PngSpeedButton, ShellApi,
  CBaseFrameUnit, Menus, CInitializeProviderFormUnit;

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
    ActionCompactDatafile: TAction;
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
    ShortcutList: TCList;
    ActionBackup: TAction;
    ActionRestore: TAction;
    ActionCheckDatafile: TAction;
    ActionPreferences: TAction;
    ActionShortcutProfiles: TAction;
    ActionLoanCalc: TAction;
    ActionCheckUpdates: TAction;
    ActionExportDatafile: TAction;
    ActionRandom: TAction;
    ActionShortcutLimits: TAction;
    ActionShortcutCurrencydef: TAction;
    ActionShortcutCurrencyRate: TAction;
    ActionImportCurrencyRates: TAction;
    OpenDialogXml: TOpenDialog;
    ActionBug: TAction;
    ActionFutureRequest: TAction;
    ActionHistory: TAction;
    Splitter: TSplitter;
    ActionShortcutExtractions: TAction;
    ActionImportExtraction: TAction;
    ActionCss: TAction;
    ActionImportDatafile: TAction;
    ActionXsl: TAction;
    ActionShortcutInstruments: TAction;
    ActionShortcutExch: TAction;
    ActionImportStockExchanges: TAction;
    ActionShortcutInvestments: TAction;
    ActionShortcutInvestmentPortfolio: TAction;
    PopupMenuShortcutView: TPopupMenu;
    MenuItemSmallShortcut: TMenuItem;
    MenuItemBigShortcut: TMenuItem;
    ActionDiscForum: TAction;
    N1: TMenuItem;
    Ustawienialisty1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButtonCloseShortcutsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ActionShortcutsExecute(Sender: TObject);
    procedure CDateTimeChanged(Sender: TObject);
    procedure ShortcutListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure ShortcutListHotChange(Sender: TBaseVirtualTree; OldNode, NewNode: PVirtualNode);
    procedure ShortcutListClick(Sender: TObject);
    procedure ActionStatusbarExecute(Sender: TObject);
    procedure ActionAboutExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ActionCloseConnectionExecute(Sender: TObject);
    procedure ActionOpenConnectionExecute(Sender: TObject);
    procedure ActionCreateConnectionExecute(Sender: TObject);
    procedure ActionHelpExecute(Sender: TObject);
    procedure ActionCompactDatafileExecute(Sender: TObject);
    procedure ActionBackupExecute(Sender: TObject);
    procedure ActionRestoreExecute(Sender: TObject);
    procedure ActionCheckDatafileExecute(Sender: TObject);
    procedure ActionPreferencesExecute(Sender: TObject);
    procedure ActionLoanCalcExecute(Sender: TObject);
    procedure ActionCheckUpdatesExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ActionExportDatafileExecute(Sender: TObject);
    procedure ActionRandomExecute(Sender: TObject);
    procedure StatusBarClick(Sender: TObject);
    procedure ActionImportCurrencyRatesExecute(Sender: TObject);
    procedure ActionBugExecute(Sender: TObject);
    procedure ActionFutureRequestExecute(Sender: TObject);
    procedure ActionHistoryExecute(Sender: TObject);
    procedure ShortcutListGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
    procedure ActionImportExtractionExecute(Sender: TObject);
    procedure ActionCssExecute(Sender: TObject);
    procedure ActionImportDatafileExecute(Sender: TObject);
    procedure ActionXslExecute(Sender: TObject);
    procedure ActionImportStockExchangesExecute(Sender: TObject);
    procedure MenuItemBigShortcutClick(Sender: TObject);
    procedure MenuItemSmallShortcutClick(Sender: TObject);
    procedure ActionDiscForumExecute(Sender: TObject);
    procedure Ustawienialisty1Click(Sender: TObject);
    procedure ShortcutListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure ShortcutListGetRowPreferencesName(AHelper: TObject; var APrefname: String);
  private
    FShortcutList: TStringList;
    FShortcutsFrames: TStringList;
    FActiveFrame: TFrame;
    function GetShortcutsVisible: Boolean;
    procedure SetShortcutsVisible(const Value: Boolean);
    procedure PerformShortcutAction(AAction: TAction);
    procedure PerformDictionaryAction(AAction: TAction);
    procedure UpdateShortcutList;
    procedure UpdateDictionaryList;
    function GetStatusbarVisible: Boolean;
    procedure SetStatusbarVisible(const Value: Boolean);
    procedure UnhandledException(Sender: TObject; E: Exception);
    function CallHelp(ACommand: Word; AData: Longint; var ACallHelp: Boolean): Boolean;
    function GetSelectedId: String;
    function GetSelectedType: Integer;
  protected
    procedure WndProc(var Message: TMessage); override;
    function GetFrameClassForAction(AAction: TAction): TCBaseFrameClass;
  public
    procedure ActionShortcutExecute(ASender: TObject);
    procedure ActionDictionaryExecute(ASender: TObject);
    procedure ActionPluginsExecute(ASender: TObject);
    procedure UpdateStatusbar;
    procedure UpdatePluginsMenu;
    procedure ExecuteOnstartupPlugins;
    procedure ExecuteOnexitPlugins;
    procedure FinalizeMainForm;
  published
    property ShortcutsVisible: Boolean read GetShortcutsVisible write SetShortcutsVisible;
    property StatusbarVisible: Boolean read GetStatusbarVisible write SetStatusbarVisible;
    property ActiveFrame: TFrame read FActiveFrame write FActiveFrame;
  end;

var
  CMainForm: TCMainForm;

implementation

uses CDataObjects, CCashpointsFrameUnit, CFrameFormUnit, CAccountsFrameUnit,
     CProductsFrameUnit, CMovementFrameUnit, 
     CReportsFrameUnit, CPlannedFrameUnit, CDoneFrameUnit,
     CAboutFormUnit, CSettings, CFilterFrameUnit, CHomeFrameUnit,
     CInfoFormUnit, CCompactDatafileFormUnit,
     CProgressFormUnit, CConsts, CArchDatafileFormUnit, CCheckDatafileFormUnit,
     CPreferencesFormUnit, CImageListsUnit, Types, CPreferences,
     CProfileFrameUnit, CLoanCalculatorFormUnit, CDatatools, CHelp,
     CRandomFormUnit, CLimitsFrameUnit,
     CMemoFormUnit, CCurrencydefFrameUnit,
     CCurrencyRateFrameUnit, CPlugins, CPluginConsts,
     CExtractionsFrameUnit, CInstrumentFrameUnit,
     CInstrumentValueFrameUnit, CTools, CInvestmentMovementFrameUnit,
     CInvestmentPortfolioFrameUnit, CConfigFormUnit, Math,
     CCreateDatafileFormUnit, CListPreferencesFormUnit, StrUtils,
     CProgressXXXFormUnit, CImportExportDatafileFormUnit;
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
  UpdateDictionaryList;
  UpdateStatusbar;
  ShortcutList.RootNodeCount := FShortcutList.Count;
  if GBasePreferences.shortcutBarSmall then begin
    MenuItemSmallShortcut.Click;
  end;
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
    Splitter.Visible := True;
    PanelShortcuts.Visible := True;
    ActionShortcuts.Checked := True;
  end else begin
    PanelShortcuts.Visible := False;
    Splitter.Visible := False;
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
    xClass := GetFrameClassForAction(AAction);
    xFrame := xClass.Create(Self);
    xFrame.Name := AAction.Name + 'Frame';
    xFrame.Width := PanelFrames.Width;
    xFrame.Height := PanelFrames.Height;
    xFrame.DisableAlign;
    xFrame.Visible := False;
    xFrame.InitializeFrame(Self, Nil, Nil, Nil, True);
    xFrame.PrepareCheckStates;
    xFrame.Parent := PanelFrames;
    xFrame.EnableAlign;
    FShortcutsFrames.AddObject(AAction.Caption, xFrame);
  end else begin
    xFrame := TCBaseFrame(FShortcutsFrames.Objects[xIndex]);
  end;
  if FActiveFrame <> xFrame then begin
    if FActiveFrame <> Nil then begin
      TCBaseFrame(FActiveFrame).HideFrame;
    end;
    FActiveFrame := xFrame;
    FActiveFrame.Parent := PanelFrames;
    TCBaseFrame(FActiveFrame).ShowFrame;
    LabelShortcut.Caption := AAction.Caption;
    if AAction.ImageIndex <> -1 then begin
      if AAction.ImageIndex <= CImageLists.MainImageList16x16.PngImages.Count - 1 then begin
        PngImage.PngImage := CImageLists.MainImageList16x16.PngImages.Items[AAction.ImageIndex].PngImage;
      end;
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
  CellText := FShortcutList.Strings[Node.Index];
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
    xAction := TAction(FShortcutList.Objects[ShortcutList.FocusedNode.Index]);
    xAction.Execute;
  end;
end;

procedure TCMainForm.UpdateShortcutList;
var xCount: Integer;
    xAction: TAction;
    xShortcutBand: TActionClient;
begin
  xShortcutBand :=  FindActionClientByCaption(ActionManager.ActionBars.ActionBars[1].Items, 'Skróty');
  if xShortcutBand <> Nil then begin
    xShortcutBand.Items.Clear;
  end;
  for xCount := 0 to ActionManager.ActionCount - 1 do begin
    xAction := TAction(ActionManager.Actions[xCount]);
    if xAction.Category = 'Skróty' then begin
      FShortcutList.AddObject(xAction.Caption, xAction);
      xAction.OnExecute := ActionShortcutExecute;
      if xShortcutBand <> Nil then begin
        with xShortcutBand.Items.Add do begin
          Action := xAction;
        end;
      end;
    end;
  end;
  ShortcutList.ViewPref := TViewPref(GViewsPreferences.ByPrefname[CFontPreferencesShortcuts]);
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
    Caption := 'CManager - obs³uga finansów (na dzieñ ' + Date2StrDate(GWorkDate) + ')';
    StatusBar.Panels.Items[0].Text := ' Otwarty plik danych: ' + AnsiLowerCase(ExpandFileName(GDataProvider.Filename));
  end else begin
    Caption := 'CManager - obs³uga finansów';
    StatusBar.Panels.Items[0].Text := ' (brak otwartego pliku danych)';
  end;
  for xCount := 0 to ActionManager.ActionCount - 1 do begin
    xAction := TAction(ActionManager.Actions[xCount]);
    if (xAction.Category = 'Skróty') or (xAction.Category = 'S³owniki') then begin
      xAction.Visible := GDataProvider.IsConnected;
    end;
  end;
  ActionImportCurrencyRates.Visible := GDataProvider.IsConnected;
  ActionCompactDatafile.Visible := GDataProvider.IsConnected;
  ActionRandom.Visible := GDataProvider.IsConnected;
  ActionCheckDatafile.Visible := GDataProvider.IsConnected;
  ActionImportDatafile.Visible := GDataProvider.IsConnected;
  ActionExportDatafile.Visible := GDataProvider.IsConnected;
  ActionImportExtraction.Visible := GDataProvider.IsConnected;
  ActionImportStockExchanges.Visible := GDataProvider.IsConnected;
  TActionClient(ActionManager.ActionBars.ActionBars[1].Items.Items[1]).Visible := GDataProvider.IsConnected;
  TActionClient(ActionManager.ActionBars.ActionBars[1].Items.Items[3]).Visible := GDataProvider.IsConnected;
  ActionShortcuts.Visible := GDataProvider.IsConnected;
  ActionCloseConnection.Enabled := GDataProvider.IsConnected;
  ActionOpenConnection.Enabled := not GDataProvider.IsConnected;
  ActionCreateConnection.Enabled := not GDataProvider.IsConnected;
end;

procedure TCMainForm.ActionAboutExecute(Sender: TObject);
begin
  ShowAbout;
end;

procedure TCMainForm.FormShow(Sender: TObject);
var xNode: ICXMLDOMNode;
begin
  xNode := LoadFormPosition(Self);
  if xNode <> Nil then begin
    PanelShortcuts.Width := GetXmlAttribute('shortcutWidth', xNode, PanelShortcuts.Width);
  end;
end;

procedure TCMainForm.WndProc(var Message: TMessage);
var xGid: TDataGid;
begin
  inherited WndProc(Message);
  if Message.Msg = WM_FORMMAXIMIZE then begin
    WindowState := wsMaximized;
  end else if Message.Msg = WM_FORMMINIMIZE then begin
    WindowState := wsMaximized;
  end else if Message.Msg = WM_PREFERENCESCHANGED then begin
    ShortcutsVisible := GBasePreferences.showShortcutBar;
    StatusbarVisible := GBasePreferences.showStatusBar;
    SetEvenListColors(GBasePreferences.evenListColor, GBasePreferences.oddListColor);
    if GBasePreferences.shortcutBarSmall then begin
      MenuItemSmallShortcut.Click;
    end else begin
      MenuItemBigShortcut.Click;
    end;
    Invalidate;
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
    StatusBar.Panels.Items[1].Text := 'Poprawnie wykonano kopiê pliku danych';
    TCStatusPanel(StatusBar.Panels.Items[1]).ImageIndex := 2;
    TCStatusPanel(StatusBar.Panels.Items[1]).Clickable := True;
  end else if Message.Msg = WM_STATBACKUPFINISHEDERR then begin
    StatusBar.Panels.Items[1].Text := 'Podczas wykonywania kopii pliku danych wyst¹pi³ b³¹d';
    TCStatusPanel(StatusBar.Panels.Items[1]).ImageIndex := 3;
    TCStatusPanel(StatusBar.Panels.Items[1]).Clickable := True;
  end else if Message.Msg = WM_GETSELECTEDTYPE then begin
    Message.Result := GetSelectedType;
  end else if Message.Msg = WM_GETSELECTEDID then begin
    xGid := GetSelectedId;
    Message.Result := Integer(@xGid);
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
    FinalizeDataProvider(GDataProvider);
    UpdateStatusbar;
    Refresh;
  end;
end;

procedure TCMainForm.ActionOpenConnectionExecute(Sender: TObject);
var xError, xDesc: String;
    xStatus: TInitializeProviderResult;
begin
  if OpenDialog.Execute then begin
    xStatus := InitializeDataProvider(OpenDialog.FileName, '', GDataProvider);
    if xStatus = iprError then begin
      ShowInfo(itError, xError, xDesc)
    end else if xStatus = iprSuccess then begin
      ActionShortcutExecute(ActionShortcutStart);
      UpdateStatusbar;
      Refresh;
    end;
  end;
end;

procedure TCMainForm.ActionCreateConnectionExecute(Sender: TObject);
var xFilename, xPassword: String;
    xStatus: TInitializeProviderResult;
begin
  if CreateDatafileWithWizard(xFilename, xPassword) then begin
    xStatus := InitializeDataProvider(xFilename, '', GDataProvider);
    if xStatus = iprSuccess then begin
      ActionShortcutExecute(ActionShortcutStart);
      UpdateStatusbar;
      Refresh;
    end;
  end;
end;

procedure TCMainForm.ActionHelpExecute(Sender: TObject);
begin
  HelpShowDefault;
end;

procedure TCMainForm.ActionCompactDatafileExecute(Sender: TObject);
begin
  CProgressXXXFormUnit.ShowProgressForm(TCCompactDatafileForm, TCProgressSimpleAdditionalData.Create(GDataProvider));
end;

procedure TCMainForm.ActionBackupExecute(Sender: TObject);
begin
  CProgressXXXFormUnit.ShowProgressForm(TCArchDatafileForm, TCArchAdditionalData.Create(GDataProvider, aoBackup));
end;

procedure TCMainForm.ActionRestoreExecute(Sender: TObject);
begin
  CProgressXXXFormUnit.ShowProgressForm(TCArchDatafileForm, TCArchAdditionalData.Create(GDataProvider, aoRestore));
end;

procedure TCMainForm.ActionCheckDatafileExecute(Sender: TObject);
begin
  CProgressXXXFormUnit.ShowProgressForm(TCCheckDatafileForm, TCProgressSimpleAdditionalData.Create(GDataProvider));
end;

procedure TCMainForm.ActionPreferencesExecute(Sender: TObject);
var xPrefs: TCPreferencesForm;
begin
  xPrefs := TCPreferencesForm.Create(Nil);
  xPrefs.ShowPreferences;
  xPrefs.Free;
end;

procedure TCMainForm.UnhandledException(Sender: TObject; E: Exception);
begin
  SetEvent(GShutdownEvent);
  CMainForm.ActionCloseConnection.Execute;
  ShowInfo(itError, 'Podczas pracy wyst¹pi³ wyj¹tek programowy. CManager zostanie zamkniêty', E.Message);
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
    xNode: ICXMLDOMNode;
begin
  ExecuteOnexitPlugins;
  for xCount := 0 to FShortcutsFrames.Count - 1 do begin
    TCBaseFrame(FShortcutsFrames.Objects[xCount]).SaveColumns;
  end;
  xNode := SaveFormPosition(Self);
  if xNode <> Nil then begin
    SetXmlAttribute('shortcutWidth', xNode, PanelShortcuts.Width);
  end;
end;

function TCMainForm.CallHelp(ACommand: Word; AData: Integer; var ACallHelp: Boolean): Boolean;
begin
  ShowMessage('Help');
  ACallHelp := False;
  Result := True;
end;

procedure TCMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  GCmanagerState := CMANAGERSTATE_CLOSING;
  SetEvent(GShutdownEvent);
  HelpCloseAll;
end;

procedure TCMainForm.ActionExportDatafileExecute(Sender: TObject);
begin
  CProgressXXXFormUnit.ShowProgressForm(TCImportExportDatafileForm, TCImportExportAdditionalData.Create(GDataProvider, ieoExport));
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
  xMax := GPlugins.GetCountOfType(CPLUGINTYPE_CURRENCYRATE) +
          GPlugins.GetCountOfType(CPLUGINTYPE_JUSTEXECUTE) +
          GPlugins.GetCountOfType(CPLUGINTYPE_EXTRACTION) +
          GPlugins.GetCountOfType(CPLUGINTYPE_STOCKEXCHANGE);
  if xMax > 0 then begin
    xPluginBand :=  FindActionClientByCaption(ActionManager.ActionBars.ActionBars[1].Items, 'Wtyczki');
    if xPluginBand <> Nil then begin
      for xCount := 0 to GPlugins.Count - 1 do begin
        xPlugin := TCPlugin(GPlugins.Items[xCount]);
        if (xPlugin.isTypeof[CPLUGINTYPE_CURRENCYRATE] or
           (xPlugin.isTypeof[CPLUGINTYPE_JUSTEXECUTE] and ((xPlugin.pluginType and CJUSTEXECUTE_DISABLEONDEMAND) = 0)) or
           xPlugin.isTypeof[CPLUGINTYPE_EXTRACTION] or
           xPlugin.isTypeof[CPLUGINTYPE_STOCKEXCHANGE]) and xPlugin.pluginIsEnabled then begin
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
    xOutput: OleVariant;
begin
  xPlugin := TCPlugin(GPlugins.Items[TAction(ASender).Tag]);
  xOutput := xPlugin.Execute;
  if not VarIsEmpty(xOutput) then begin
    if xPlugin.isTypeof[CPLUGINTYPE_CURRENCYRATE] then begin
      UpdateCurrencyRates(xOutput);
    end else if xPlugin.isTypeof[CPLUGINTYPE_EXTRACTION] then begin
      UpdateExtractions(xOutput);
    end else if xPlugin.isTypeof[CPLUGINTYPE_STOCKEXCHANGE] then begin
      UpdateExchanges(xOutput);
    end;
  end;
end;

procedure TCMainForm.ActionImportCurrencyRatesExecute(Sender: TObject);
var xStr: TStringList;
begin
  if OpenDialogXml.Execute then begin
    xStr := TStringList.Create;
    try
      try
        xStr.LoadFromFile(OpenDialogXml.FileName);
        UpdateCurrencyRates(xStr.Text);
      except
        on E: Exception do begin
          ShowInfo(itError, 'Nie uda³o siê otworzyæ pliku ' + OpenDialogXml.FileName, E.Message);
        end;
      end;
    finally
      xStr.Free;
    end;
  end;
end;

procedure TCMainForm.ActionBugExecute(Sender: TObject);
begin
  ShellExecute(0, nil, 'http://sourceforge.net/tracker/?func=add&group_id=178670&atid=886066', nil, nil, SW_SHOWNORMAL);
end;

procedure TCMainForm.ActionFutureRequestExecute(Sender: TObject);
begin
  ShellExecute(0, nil, 'http://sourceforge.net/tracker/?func=add&group_id=178670&atid=886069', nil, nil, SW_SHOWNORMAL);
end;

procedure TCMainForm.ActionHistoryExecute(Sender: TObject);
begin
  if FileExists(GetSystemPathname('changelog')) then begin
    ShellExecute(0, Nil, 'notepad.exe', PChar(GetSystemPathname('changelog')), Nil, SW_SHOWNORMAL);
  end else begin
    ShowInfo(itError, 'Nie odnaleziono pliku "changelog". Sprawdz poprawnoœæ instalacji CManager-a.', '');
  end;
end;

procedure TCMainForm.ShortcutListGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
begin
  ImageIndex := TAction(FShortcutList.Objects[Node.Index]).ImageIndex;
end;

procedure TCMainForm.ActionImportExtractionExecute(Sender: TObject);
var xStr: TStringList;
begin
  if OpenDialogXml.Execute then begin
    xStr := TStringList.Create;
    try
      try
        xStr.LoadFromFile(OpenDialogXml.FileName);
        UpdateExtractions(xStr.Text);
      except
        on E: Exception do begin
          ShowInfo(itError, 'Nie uda³o siê otworzyæ pliku ' + OpenDialogXml.FileName, E.Message);
        end;
      end;
    finally
      xStr.Free;
    end;
  end;
end;

procedure TCMainForm.ActionCssExecute(Sender: TObject);
begin
  if not FileExists(GetSystemPathname(CCSSReportFile)) then begin
    GetFileFromResource('REPCSS', RT_RCDATA, GetSystemPathname(CCSSReportFile));
  end;
  if FileExists(GetSystemPathname(CCSSReportFile)) then begin
    ShellExecute(0, Nil, 'notepad.exe', PChar(GetSystemPathname(CCSSReportFile)), Nil, SW_SHOWNORMAL);
  end else begin
    ShowInfo(itError, 'Nie odnaleziono pliku "report.css". Sprawdz poprawnoœæ instalacji CManager-a.', '');
  end;
end;

function TCMainForm.GetSelectedId: String;
begin
  Result := '';
  if FActiveFrame <> Nil then begin
    if FActiveFrame.InheritsFrom(TCBaseFrame) then begin
      Result := TCBaseFrame(FActiveFrame).SelectedId;
    end;
  end;
end;

function TCMainForm.GetSelectedType: Integer;
begin
  Result := CSELECTEDITEM_INCORRECT;
  if FActiveFrame <> Nil then begin
    if FActiveFrame.InheritsFrom(TCBaseFrame) then begin
      Result := TCBaseFrame(FActiveFrame).SelectedType;
    end;
  end;
end;

procedure TCMainForm.ExecuteOnstartupPlugins;
var xCount: Integer;
    xPlugin: TCPlugin;
begin
  for xCount := 0 to GPlugins.Count - 1 do begin
    xPlugin := TCPlugin(GPlugins.Items[xCount]);
    if xPlugin.pluginIsEnabled and
       ((xPlugin.isTypeof[CPLUGINTYPE_JUSTEXECUTE]) and
       ((xPlugin.pluginType and CJUSTEXECUTE_EXECUTEONSTART) = CJUSTEXECUTE_EXECUTEONSTART)) then begin
      xPlugin.Execute;
    end;
  end;
end;

procedure TCMainForm.ExecuteOnexitPlugins;
var xCount: Integer;
    xPlugin: TCPlugin;
begin
  for xCount := 0 to GPlugins.Count - 1 do begin
    xPlugin := TCPlugin(GPlugins.Items[xCount]);
    if xPlugin.pluginIsEnabled and 
       ((xPlugin.isTypeof[CPLUGINTYPE_JUSTEXECUTE]) and
       ((xPlugin.pluginType and CJUSTEXECUTE_EXECUTEONEXIT) = CJUSTEXECUTE_EXECUTEONEXIT)) then begin
      xPlugin.Execute;
    end;
  end;
end;


procedure TCMainForm.ActionImportDatafileExecute(Sender: TObject);
begin
  CProgressXXXFormUnit.ShowProgressForm(TCImportExportDatafileForm, TCImportExportAdditionalData.Create(GDataProvider, ieoImport));
end;

procedure TCMainForm.ActionXslExecute(Sender: TObject);
begin
  if not FileExists(GetSystemPathname(CXSLReportFile)) then begin
    GetFileFromResource('REPXSL', RT_RCDATA, GetSystemPathname(CXSLReportFile));
  end;
  if FileExists(GetSystemPathname(CXSLReportFile)) then begin
    ShellExecute(0, Nil, 'notepad.exe', PChar(GetSystemPathname(CXSLReportFile)), Nil, SW_SHOWNORMAL);
  end else begin
    ShowInfo(itError, 'Nie odnaleziono pliku "' + CXSLReportFile + '". Sprawdz poprawnoœæ instalacji CManager-a.', '');
  end;
end;

procedure TCMainForm.ActionImportStockExchangesExecute(Sender: TObject);
var xStr: TStringList;
begin
  if OpenDialogXml.Execute then begin
    xStr := TStringList.Create;
    try
      try
        xStr.LoadFromFile(OpenDialogXml.FileName);
        UpdateExchanges(xStr.Text);
      except
        on E: Exception do begin
          ShowInfo(itError, 'Nie uda³o siê otworzyæ pliku ' + OpenDialogXml.FileName, E.Message);
        end;
      end;
    finally
      xStr.Free;
    end;
  end;
end;

procedure TCMainForm.UpdateDictionaryList;
var xCount: Integer;
    xAction: TAction;
    xDictBand: TActionClient;
begin
  xDictBand :=  FindActionClientByCaption(ActionManager.ActionBars.ActionBars[1].Items, 'S³owniki');
  if xDictBand <> Nil then begin
    xDictBand.Items.Clear;
    for xCount := 0 to ActionManager.ActionCount - 1 do begin
      xAction := TAction(ActionManager.Actions[xCount]);
      if xAction.Category = 'S³owniki' then begin
        xAction.OnExecute := ActionDictionaryExecute;
        with xDictBand.Items.Add do begin
          Action := xAction;
        end;
      end;
    end;
  end;
end;

function TCMainForm.GetFrameClassForAction(AAction: TAction): TCBaseFrameClass;
begin
  if AAction = ActionShortcutStart then begin
    Result := TCHomeFrame;
  end else if AAction = ActionShorcutOperations then begin
    Result := TCMovementFrame;
  end else if AAction = ActionShortcutPlanned then begin
    Result := TCPlannedFrame;
  end else if AAction = ActionShortcutPlannedDone then begin
    Result := TCDoneFrame;
  end else if AAction = ActionShortcutCashpoints then begin
    Result := TCCashpointsFrame;
  end else if AAction = ActionShortcutAccounts then begin
    Result := TCAccountsFrame;
  end else if AAction = ActionShortcutProducts then begin
    Result := TCProductsFrame;
  end else if AAction = ActionShortcutReports then begin
    Result := TCReportsFrame;
  end else if AAction = ActionShortcutFilters then begin
    Result := TCFilterFrame;
  end else if AAction = ActionShortcutProfiles then begin
    Result := TCProfileFrame;
  end else if AAction = ActionShortcutLimits then begin
    Result := TCLimitsFrame;
  end else if AAction = ActionShortcutCurrencydef then begin
    Result := TCCurrencydefFrame;
  end else if AAction = ActionShortcutCurrencyRate then begin
    Result := TCCurrencyRateFrame;
  end else if AAction = ActionShortcutExtractions then begin
    Result := TCExtractionsFrame;
  end else if AAction = ActionShortcutInstruments then begin
    Result := TCInstrumentFrame;
  end else if AAction = ActionShortcutExch then begin
    Result := TCInstrumentValueFrame;
  end else if AAction = ActionShortcutInvestments then begin
    Result := TCInvestmentMovementFrame;
  end else if AAction = ActionShortcutInvestmentPortfolio then begin
    Result := TCInvestmentPortfolioFrame;
  end else begin
    Result := TCBaseFrame;
  end;
end;

procedure TCMainForm.PerformDictionaryAction(AAction: TAction);
var xClass: TCBaseFrameClass;
    xGid, xText: String;
begin
  xClass := GetFrameClassForAction(AAction);
  TCFrameForm.ShowFrame(xClass, xGid, xText, nil, nil, nil, nil, False);
end;

procedure TCMainForm.ActionDictionaryExecute(ASender: TObject);
begin
  PerformDictionaryAction(TAction(ASender));
end;

procedure TCMainForm.MenuItemBigShortcutClick(Sender: TObject);
begin
  with ShortcutList do begin
    Images := CImageLists.MainImageList32x32;
    MenuItemBigShortcut.Checked := True;
    ReinitNode(RootNode, True);
    Repaint;
    GBasePreferences.shortcutBarSmall := False;
  end;
end;

procedure TCMainForm.MenuItemSmallShortcutClick(Sender: TObject);
begin
  with ShortcutList do begin
    Images := CImageLists.MainImageList16x16;
    MenuItemSmallShortcut.Checked := True;
    ReinitNode(RootNode, True);
    Repaint;
    GBasePreferences.shortcutBarSmall := True;
  end;
end;

procedure TCMainForm.ActionDiscForumExecute(Sender: TObject);
begin
  ShellExecute(0, nil, 'http://sourceforge.net/forum/forum.php?forum_id=617716', nil, nil, SW_SHOWNORMAL);
end;

procedure TCMainForm.Ustawienialisty1Click(Sender: TObject);
var xPrefs: TCListPreferencesForm;
begin
  xPrefs := TCListPreferencesForm.Create(Nil);
  if xPrefs.ShowListPreferences(ShortcutList.ViewPref) then begin
    ShortcutList.ReinitNode(ShortcutList.RootNode, True);
    ShortcutList.Repaint;
  end;
  xPrefs.Free;
end;

procedure TCMainForm.ShortcutListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TObject);
end;

procedure TCMainForm.ShortcutListGetRowPreferencesName(AHelper: TObject; var APrefname: String);
begin
  APrefname := IfThen(MenuItemBigShortcut.Checked, 'B', 'S');
end;

end.

