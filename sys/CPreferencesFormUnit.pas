unit CPreferencesFormUnit;

interface

{$WARN UNIT_PLATFORM OFF}

uses  CConfigFormUnit, StdCtrls, Dialogs, ImgList, Controls,
  PngImageList, Classes, ActnList, XPStyleActnCtrls, ActnMan, CComponents,
  ComCtrls, Buttons, ExtCtrls, Windows, Messages, SysUtils, Variants, Graphics,
  Forms, VirtualTrees, CPreferences, Contnrs, Menus;

const
  CPreferencesFirstTab = 0;

type
  TCPreferencesForm = class(TCConfigForm)
    PanelMain: TCPanel;
    PanelShortcuts: TCPanel;
    PanelShortcutsTitle: TCPanel;
    Panel1: TCPanel;
    Panel2: TCPanel;
    PageControl: TPageControl;
    ActionManager1: TActionManager;
    Action1: TAction;
    CategoryImageList: TPngImageList;
    Action2: TAction;
    TabSheetBase: TTabSheet;
    TabSheetView: TTabSheet;
    GroupBox1: TGroupBox;
    RadioButtonLast: TRadioButton;
    RadioButtonNever: TRadioButton;
    RadioButtonThis: TRadioButton;
    CStaticFileName: TCStatic;
    OpenDialog: TOpenDialog;
    GroupBox2: TGroupBox;
    CheckBoxShortcutVisible: TCheckBox;
    CheckBoxStatusVisible: TCheckBox;
    Action3: TAction;
    TabSheetAutostart: TTabSheet;
    GroupBox3: TGroupBox;
    ComboBoxDays: TComboBox;
    Label4: TLabel;
    CIntEditDays: TCIntEdit;
    CheckBoxAutoIn: TCheckBox;
    CheckBoxAutoOut: TCheckBox;
    Label1: TLabel;
    GroupBox4: TGroupBox;
    PngImageList: TPngImageList;
    CButton4: TCButton;
    ActionManager2: TActionManager;
    Action4: TAction;
    Action5: TAction;
    Action6: TAction;
    Action7: TAction;
    CButton5: TCButton;
    CButton6: TCButton;
    CButton7: TCButton;
    CheckBoxCheckForupdates: TCheckBox;
    GroupBox5: TGroupBox;
    CheckBoxMon: TCheckBox;
    CheckBoxFri: TCheckBox;
    CheckBoxTue: TCheckBox;
    CheckBoxSat: TCheckBox;
    CheckBoxWed: TCheckBox;
    CheckBoxSun: TCheckBox;
    CheckBoxThu: TCheckBox;
    GroupBox6: TGroupBox;
    ComboBoxBackupAction: TComboBox;
    CStaticBackupCat: TCStatic;
    CIntEditBackupAge: TCIntEdit;
    LabelAge: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    EditBackupName: TEdit;
    ActionManager: TActionManager;
    ActionAdd: TAction;
    CButton8: TCButton;
    CheckBoxCanOverwrite: TCheckBox;
    TabSheetPlugins: TTabSheet;
    Action8: TAction;
    Panel3: TCPanel;
    List: TCDataList;
    CButton10: TCButton;
    Action9: TAction;
    CButton11: TCButton;
    Action10: TAction;
    GroupBox7: TGroupBox;
    Panel4: TCPanel;
    Panel5: TCPanel;
    ColorDialog: TColorDialog;
    CheckBoxSmallIcons: TCheckBox;
    CButton12: TCButton;
    Action11: TAction;
    Label7: TLabel;
    Action12: TAction;
    TabSheetOperations: TTabSheet;
    GroupBox8: TGroupBox;
    Label8: TLabel;
    CStaticAccount: TCStatic;
    Label9: TLabel;
    CStaticCategory: TCStatic;
    Label10: TLabel;
    CStaticCashpoint: TCStatic;
    Label11: TLabel;
    CStaticProfile: TCStatic;
    Label12: TLabel;
    ComboBoxWhen: TComboBox;
    ShortcutList: TCList;
    PopupMenuShortcutView: TPopupMenu;
    Ustawienialisty1: TMenuItem;
    GroupBox9: TGroupBox;
    CheckBoxAutostartOperations: TCheckBox;
    CheckBoxAutoAlways: TCheckBox;
    CheckBoxAutoTrans: TCheckBox;
    Label13: TLabel;
    GroupBox10: TGroupBox;
    CheckBoxAutoOldIn: TCheckBox;
    CheckBoxAutoOldOut: TCheckBox;
    CheckBoxAutoOldTrans: TCheckBox;
    GroupBox11: TGroupBox;
    CheckBoxSurpassed: TCheckBox;
    CheckBoxValid: TCheckBox;
    CheckBoxExtractions: TCheckBox;
    Label3: TLabel;
    CIntEditOldDays: TCIntEdit;
    Label14: TLabel;
    Label15: TLabel;
    CStaticDefaultCurrency: TCStatic;
    GroupBox12: TGroupBox;
    Label16: TLabel;
    ComboBoxListAsColors: TComboBox;
    ComboBoxListAsFonts: TComboBox;
    Label17: TLabel;
    procedure CStaticFileNameGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure RadioButtonLastClick(Sender: TObject);
    procedure RadioButtonThisClick(Sender: TObject);
    procedure RadioButtonNeverClick(Sender: TObject);
    procedure ComboBoxDaysChange(Sender: TObject);
    procedure CheckBoxAutostartOperationsClick(Sender: TObject);
    procedure Action4Execute(Sender: TObject);
    procedure Action5Execute(Sender: TObject);
    procedure Action6Execute(Sender: TObject);
    procedure Action7Execute(Sender: TObject);
    procedure ComboBoxBackupActionChange(Sender: TObject);
    procedure ActionAddExecute(Sender: TObject);
    procedure CStaticBackupCatGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure ListCDataListReloadTree(Sender: TCDataList; ARootElement: TCListDataElement);
    procedure ListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure Action9Execute(Sender: TObject);
    procedure ListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure ListChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure Action10Execute(Sender: TObject);
    procedure Panel4Click(Sender: TObject);
    procedure Panel5Click(Sender: TObject);
    procedure Action11Execute(Sender: TObject);
    procedure CStaticAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticCategoryGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticProfileGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure ShortcutListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure ShortcutListHotChange(Sender: TBaseVirtualTree; OldNode, NewNode: PVirtualNode);
    procedure ShortcutListGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
    procedure ShortcutListClick(Sender: TObject);
    procedure Ustawienialisty1Click(Sender: TObject);
    procedure CStaticDefaultCurrencyGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
  private
    FPrevWorkDays: String;
    FActiveAction: TAction;
    FViewPrefs: TPrefList;
    FBasePrefs: TBasePref;
    FPluginPrefs: TPrefList;
    FRestartInfo: String;
    procedure SetActiveAction(const Value: TAction);
    procedure ActionExecute(Sender: TObject);
    procedure UpdateFilenameState;
  protected
    procedure FillForm; override;
    procedure ReadValues; override;
    function CanAccept: Boolean; override;
  public
    function ShowPreferences(ATab: Integer = CPreferencesFirstTab): Boolean;
    property ActiveAction: TAction read FActiveAction write SetActiveAction;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

uses CListPreferencesFormUnit, StrUtils, FileCtrl, CConsts,
  CMovementFrameUnit, CBaseFormUnit, CBaseFrameUnit, CDoneFrameUnit,
  CPlannedFrameUnit, CStartupInfoFrameUnit, Registry, CInfoFormUnit,
  CTemplates, CDescpatternFormUnit, CPlugins, CExtractionItemFormUnit,
  CExtractionsFrameUnit, CFrameFormUnit, CAccountsFrameUnit,
  CProductsFrameUnit, CCashpointsFrameUnit, CProfileFrameUnit, CDatabase,
  CDataObjects, CTools, Math, CImageListsUnit, CCurrencydefFrameUnit;

{$R *.dfm}

function TCPreferencesForm.ShowPreferences(ATab: Integer): Boolean;
begin
  Action1.OnExecute := ActionExecute;
  Action2.OnExecute := ActionExecute;
  Action3.OnExecute := ActionExecute;
  Action8.OnExecute := ActionExecute;
  Action12.OnExecute := ActionExecute;
  ActiveAction := TAction(ActionManager1.Actions[ATab]);
  FViewPrefs.Clone(GViewsPreferences);
  FBasePrefs.Clone(GBasePreferences);
  FPluginPrefs.Clone(GPluginsPreferences);
  FRestartInfo := '';
  ShortcutList.ViewPref := TViewPref(GViewsPreferences.ByPrefname[CFontPreferencesPreferencesShortcut]);
  ShortcutList.RootNodeCount := 5;
  Result := ShowConfig(coEdit);
  if Result then begin
    GViewsPreferences.Clone(FViewPrefs);
    GBasePreferences.Clone(FBasePrefs);
    GPluginsPreferences.Clone(FPluginPrefs);
    if FPrevWorkDays <> FBasePrefs.workDays then begin
      SendMessageToFrames(TCDoneFrame, WM_DATAREFRESH, 0, 0);
    end;
    Application.MainForm.Perform(WM_PREFERENCESCHANGED, 0, 0);
  end;
end;

procedure TCPreferencesForm.SetActiveAction(const Value: TAction);
begin
  PanelShortcutsTitle.Caption := '  ' + Value.Caption;
  PageControl.ActivePage := PageControl.Pages[Value.Index];
end;

procedure TCPreferencesForm.ActionExecute(Sender: TObject);
begin
  ActiveAction := TAction(Sender);
end;

procedure TCPreferencesForm.CStaticFileNameGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := OpenDialog.Execute;
  if AAccepted then begin
    ADataGid := OpenDialog.FileName;
    AText := MinimizeName(ADataGid, CStaticFileName.Canvas, CStaticFileName.Width);
  end;
end;

procedure TCPreferencesForm.UpdateFilenameState;
begin
  CStaticFileName.Enabled := RadioButtonThis.Checked;
end;

procedure TCPreferencesForm.RadioButtonLastClick(Sender: TObject);
begin
  UpdateFilenameState;
end;

procedure TCPreferencesForm.RadioButtonThisClick(Sender: TObject);
begin
  UpdateFilenameState;
end;

procedure TCPreferencesForm.RadioButtonNeverClick(Sender: TObject);
begin
  UpdateFilenameState;
end;

constructor TCPreferencesForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBasePrefs := TBasePref.Create('baseprefs');
  FViewPrefs := TPrefList.Create(TViewPref);
  FPluginPrefs := TPrefList.Create(TPluginPref);
  SetSystemCustomColors(ColorDialog);
end;

destructor TCPreferencesForm.Destroy;
begin
  FPluginPrefs.Free;
  FViewPrefs.Free;
  FBasePrefs.Free;
  inherited Destroy;
end;

procedure TCPreferencesForm.FillForm;
var xNode: PVirtualNode;
    xChecked: Boolean;
    xPref: TPluginPref;
begin
  inherited FillForm;
  with FBasePrefs do begin
    if startupDatafileMode = CStartupFilemodeNeveropen then begin
      RadioButtonNever.Checked := True;
    end else if startupDatafileMode = CStartupFilemodeThisfile then begin
      RadioButtonThis.Checked := True;
    end else begin
      RadioButtonLast.Checked := True;
    end;
    CStaticFileName.DataId := startupDatafileName;
    CStaticFileName.Caption := MinimizeName(startupDatafileName, CStaticFileName.Canvas, CStaticFileName.Width);
    CheckBoxShortcutVisible.Checked := showShortcutBar;
    CheckBoxSmallIcons.Checked := shortcutBarSmall;
    CheckBoxStatusVisible.Checked := showStatusBar;
    CheckBoxAutostartOperations.Checked := startupInfo;
    ComboBoxDays.ItemIndex := startupInfoType;
    CIntEditDays.Text := IntToStr(startupInfoDays);
    CheckBoxAutoIn.Checked := startupInfoIn;
    CheckBoxAutoOut.Checked := startupInfoOut;
    CheckBoxAutoTrans.Checked := startupInfoTran;
    CheckBoxAutoAlways.Checked := startupInfoAlways;
    CheckBoxAutoOldIn.Checked := startupInfoOldIn;
    CheckBoxAutoOldOut.Checked := startupInfoOldOut;
    CheckBoxAutoOldTrans.Checked := startupInfoOldTran;
    CheckBoxCheckForupdates.Checked := startupCheckUpdates;
    CheckBoxSurpassed.Checked := startupInfoSurpassedLimit;
    CheckBoxValid.Checked := startupInfoValidLimits;
    CheckBoxMon.Checked := workDays[1] = '+';
    CheckBoxTue.Checked := workDays[2] = '+';
    CheckBoxWed.Checked := workDays[3] = '+';
    CheckBoxThu.Checked := workDays[4] = '+';
    CheckBoxFri.Checked := workDays[5] = '+';
    CheckBoxSat.Checked := workDays[6] = '+';
    CheckBoxSun.Checked := workDays[7] = '+';
    CIntEditOldDays.Value := startupInfoOldDays;
    FPrevWorkDays := workDays;
    ComboBoxBackupAction.ItemIndex := backupAction;
    ComboBoxWhen.ItemIndex := IfThen(backupOnStart, 0, 1);
    CIntEditBackupAge.Text := IntToStr(backupDaysOld);
    CStaticBackupCat.DataId := backupDirectory;
    CStaticBackupCat.Caption := MinimizeName(backupDirectory, CStaticBackupCat.Canvas, CStaticBackupCat.Width);
    EditBackupName.Text := backupFileName;
    CheckBoxCanOverwrite.Checked := backupOverwrite;
    CheckBoxExtractions.Checked := startupUncheckedExtractions;
    Panel5.Color := oddListColor;
    Panel4.Color := evenListColor;
    ComboBoxListAsColors.ItemIndex := IfThen(listAsReportUseColors, 1, 0);
    ComboBoxListAsFonts.ItemIndex := IfThen(listAsReportUseFonts, 1, 0);
  end;
  GDataProvider.BeginTransaction;
  if GDefaultAccountId <> CEmptyDataGid then begin
    CStaticAccount.DataId := GDefaultAccountId;
    CStaticAccount.Caption := TAccount(TAccount.LoadObject(AccountProxy, GDefaultAccountId, False)).name;
  end;
  if GDefaultProductId <> CEmptyDataGid then begin
    CStaticCategory.DataId := GDefaultProductId;
    CStaticCategory.Caption := TProduct(TProduct.LoadObject(ProductProxy, GDefaultProductId, False)).name;
  end;
  if GDefaultCashpointId <> CEmptyDataGid then begin
    CStaticCashpoint.DataId := GDefaultCashpointId;
    CStaticCashpoint.Caption := TCashPoint(TCashPoint.LoadObject(CashPointProxy, GDefaultCashpointId, False)).name;
  end;
  if GDefaultProfileId <> CEmptyDataGid then begin
    CStaticProfile.DataId := GDefaultProfileId;
    CStaticProfile.Caption := TProfile(TProfile.LoadObject(ProfileProxy, GDefaultProfileId, False)).name;
  end;
  if GDefaultCurrencyId <> CEmptyDataGid then begin
    CStaticDefaultCurrency.DataId := GDefaultCurrencyId;
    CStaticDefaultCurrency.Caption := GCurrencyCache.GetIso(GDefaultCurrencyId);
  end;
  GDataProvider.RollbackTransaction;
  CheckBoxAutostartOperationsClick(Nil);
  ComboBoxBackupActionChange(Nil);
  UpdateFilenameState;
  List.ReloadTree;
  xNode := List.GetFirst;
  while xNode <> Nil do begin
    xPref := TPluginPref(FPluginPrefs.ByPrefname[TCPlugin(GPlugins.Items[xNode.Index]).fileName]);
    if xPref <> Nil then begin
      xChecked := xPref.isEnabled;
    end else begin
      xChecked := True;
    end;
    if xChecked then begin
      xNode.CheckState := csCheckedNormal;
    end else begin
      xNode.CheckState := csUncheckedNormal;
    end;
    xNode := List.GetNext(xNode);
  end;
  ListFocusChanged(List, Nil, 0);
end;

procedure TCPreferencesForm.ReadValues;
var xReg: TRegistry;
    xPref: TPluginPref;
    xPlugin: TCPlugin;
    xNode: PVirtualNode;
begin
  inherited ReadValues;
  with FBasePrefs do begin
    if RadioButtonNever.Checked then begin
      startupDatafileMode := CStartupFilemodeNeveropen;
    end else if RadioButtonThis.Checked then begin
      startupDatafileMode := CStartupFilemodeThisfile;
    end else begin
      startupDatafileMode := CStartupFilemodeLastOpened;
    end;
    startupDatafileName := CStaticFileName.DataId;
    showShortcutBar := CheckBoxShortcutVisible.Checked;
    shortcutBarSmall := CheckBoxSmallIcons.Checked;
    showStatusBar := CheckBoxStatusVisible.Checked;
    startupInfo := CheckBoxAutostartOperations.Checked;
    startupInfoType := ComboBoxDays.ItemIndex;
    startupInfoDays := CIntEditDays.Value;
    startupInfoIn := CheckBoxAutoIn.Checked;
    startupInfoOut := CheckBoxAutoOut.Checked;
    startupInfoTran := CheckBoxAutoTrans.Checked;
    startupInfoAlways := CheckBoxAutoAlways.Checked;
    startupInfoOldIn := CheckBoxAutoOldIn.Checked;
    startupInfoOldOut := CheckBoxAutoOldOut.Checked;
    startupInfoOldTran := CheckBoxAutoOldTrans.Checked;
    startupCheckUpdates := CheckBoxCheckForupdates.Checked;
    startupInfoSurpassedLimit := CheckBoxSurpassed.Checked;
    startupInfoValidLimits := CheckBoxValid.Checked;
    startupInfoOldDays := CIntEditOldDays.Value;
    workDays := ifThen(CheckBoxMon.Checked, '+', '-');
    workDays := workDays + ifThen(CheckBoxTue.Checked, '+', '-');
    workDays := workDays + ifThen(CheckBoxWed.Checked, '+', '-');
    workDays := workDays + ifThen(CheckBoxThu.Checked, '+', '-');
    workDays := workDays + ifThen(CheckBoxFri.Checked, '+', '-');
    workDays := workDays + ifThen(CheckBoxSat.Checked, '+', '-');
    workDays := workDays + ifThen(CheckBoxSun.Checked, '+', '-');
    backupAction := ComboBoxBackupAction.ItemIndex;
    backupOnStart := ComboBoxWhen.ItemIndex = 0;
    backupDaysOld := CIntEditBackupAge.Value;
    backupDirectory := CStaticBackupCat.DataId;;
    backupFileName := EditBackupName.Text;
    backupOverwrite := CheckBoxCanOverwrite.Checked;
    startupUncheckedExtractions := CheckBoxExtractions.Checked;
    listAsReportUseColors := ComboBoxListAsColors.ItemIndex = 1;
    listAsReportUseFonts := ComboBoxListAsFonts.ItemIndex = 1;
    oddListColor := Panel5.Color;
    evenListColor := Panel4.Color;
    xReg := TRegistry.Create;
    try
      xReg.RootKey := HKEY_CURRENT_USER;
      if xReg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', False) then begin
        if startupInfo then begin
          xReg.WriteString('CManagerCheckOnly', '"' + ExpandFileName(ParamStr(0)) + '" /checkonly');
        end else begin
          xReg.DeleteValue('CManagerCheckOnly');
        end;
        xReg.CloseKey;
      end;
    finally
      xReg.Free;
    end;
    xNode := List.GetFirst;
    while xNode <> Nil do begin
      xPlugin := TCPlugin(GPlugins.Items[xNode.Index]);
      xPref := TPluginPref(FPluginPrefs.ByPrefname[xPlugin.fileName]);
      if xPref = Nil then begin
        xPref := TPluginPref.CreatePluginPref(xPlugin.fileName, xPlugin.pluginConfiguration);
        FPluginPrefs.Add(xPref, True);
      end;
      xPref.isEnabled := xNode.CheckState = csCheckedNormal;
      xNode := List.GetNext(xNode);
    end;
    GDefaultProfileId := CStaticProfile.DataId;
    GDefaultProductId := CStaticCategory.DataId;
    GDefaultAccountId := CStaticAccount.DataId;
    GDefaultCashpointId := CStaticCashpoint.DataId;
    GDefaultCurrencyId := CStaticDefaultCurrency.DataId;
    GDataProvider.BeginTransaction;
    GDataProvider.SetCmanagerParam('GActiveProfileId', GDefaultProfileId);
    GDataProvider.SetCmanagerParam('GDefaultProductId', GDefaultProductId);
    GDataProvider.SetCmanagerParam('GDefaultAccountId', GDefaultAccountId);
    GDataProvider.SetCmanagerParam('GDefaultCashpointId', GDefaultCashpointId);
    GDataProvider.SetCmanagerParam('GDefaultCurrencyId', GDefaultCurrencyId);
    GDataProvider.CommitTransaction;
  end;
end;

procedure TCPreferencesForm.ComboBoxDaysChange(Sender: TObject);
begin
  CIntEditDays.Enabled := (ComboBoxDays.ItemIndex = ComboBoxDays.Items.Count - 1);
  Label4.Enabled := CIntEditDays.Enabled;
  Label1.Enabled := CIntEditDays.Enabled;
end;

procedure TCPreferencesForm.CheckBoxAutostartOperationsClick(Sender: TObject);
begin
  CheckBoxAutoAlways.Enabled := CheckBoxAutostartOperations.Checked;
  ComboBoxDaysChange(Nil);
end;

procedure TCPreferencesForm.Action4Execute(Sender: TObject);
var xPrefs: TCListPreferencesForm;
begin
  xPrefs := TCListPreferencesForm.Create(Nil);
  if xPrefs.ShowListPreferences(TViewPref(FViewPrefs.ByPrefname[TCMovementFrame.GetPrefname])) then begin
    SendMessageToFrames(TCMovementFrame, WM_MUSTREPAINT, 0, 0);
  end;
  xPrefs.Free;
end;

procedure TCPreferencesForm.Action5Execute(Sender: TObject);
var xPrefs: TCListPreferencesForm;
begin
  xPrefs := TCListPreferencesForm.Create(Nil);
  if xPrefs.ShowListPreferences(TViewPref(FViewPrefs.ByPrefname[TCDoneFrame.GetPrefname])) then begin
    SendMessageToFrames(TCDoneFrame, WM_MUSTREPAINT, 0, 0);
  end;
  xPrefs.Free;
end;

procedure TCPreferencesForm.Action6Execute(Sender: TObject);
var xPrefs: TCListPreferencesForm;
begin
  xPrefs := TCListPreferencesForm.Create(Nil);
  if xPrefs.ShowListPreferences(TViewPref(FViewPrefs.ByPrefname[TCPlannedFrame.GetPrefname])) then begin
    SendMessageToFrames(TCPlannedFrame, WM_MUSTREPAINT, 0, 0);
  end;
  xPrefs.Free;
end;

procedure TCPreferencesForm.Action7Execute(Sender: TObject);
var xPrefs: TCListPreferencesForm;
begin
  xPrefs := TCListPreferencesForm.Create(Nil);
  if xPrefs.ShowListPreferences(TViewPref(FViewPrefs.ByPrefname[TCStartupInfoFrame.GetPrefname])) then begin
    SendMessageToFrames(TCStartupInfoFrame, WM_MUSTREPAINT, 0, 0);
  end;
  xPrefs.Free;
end;

function TCPreferencesForm.CanAccept: Boolean;
begin
  Result := True;
  if not (CheckBoxMon.Checked or CheckBoxTue.Checked or
          CheckBoxWed.Checked or CheckBoxThu.Checked or
          CheckBoxFri.Checked or CheckBoxSat.Checked or CheckBoxSun.Checked) then begin
    SetActiveAction(Action1);
    ShowInfo(itError, 'Nie okre�lono �adnego pracuj�cego dnia, ustaw przynajmniej jeden', '');
    Result := False;
  end else if CIntEditBackupAge.Visible and (CIntEditBackupAge.Value = 0) then begin
    Result := False;
    SetActiveAction(Action1);
    ShowInfo(itError, 'Ilo�� dni nie mo�e by� r�wna zero', '');
    CIntEditBackupAge.SetFocus;
  end else if EditBackupName.Enabled and (EditBackupName.Text = '') then begin
    Result := False;
    SetActiveAction(Action1);
    ShowInfo(itError, 'Nazwa kopii nie mo�e by� pusta', '');
    EditBackupName.SetFocus;
  end;
  if Result and (FRestartInfo <> '') then begin
    ShowInfo(itInfo, FRestartInfo, '');
  end;
end;

procedure TCPreferencesForm.ComboBoxBackupActionChange(Sender: TObject);
begin
  CStaticBackupCat.Enabled := (ComboBoxBackupAction.ItemIndex <> 3);
  EditBackupName.Enabled := CStaticBackupCat.Enabled;
  CheckBoxCanOverwrite.Enabled := CStaticBackupCat.Enabled;
  ActionAdd.Enabled := EditBackupName.Enabled;
  CIntEditBackupAge.Visible := (ComboBoxBackupAction.ItemIndex = 2);
  LabelAge.Visible := CIntEditBackupAge.Visible;
  ComboBoxWhen.Visible := (ComboBoxBackupAction.ItemIndex <> 3);
end;

procedure TCPreferencesForm.ActionAddExecute(Sender: TObject);
var xData: TObjectList;
begin
  xData := TObjectList.Create(False);
  xData.Add(GBaseTemlatesList);
  EditAddTemplate(xData, Self, EditBackupName, False);
  xData.Free;
end;

procedure TCPreferencesForm.CStaticBackupCatGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
var xDir: String;
begin
  xDir := ADataGid;
  AAccepted := SelectDirectory('Wybierz katalog kopii', '', xDir);
  if AAccepted then begin
    AText := MinimizeName(xDir, CStaticBackupCat.Canvas, CStaticBackupCat.Width);
    ADataGid := xDir;
  end;
end;

procedure TCPreferencesForm.ListCDataListReloadTree(Sender: TCDataList; ARootElement: TCListDataElement);
var xCount: Integer;
    xElement: TCListDataElement;
begin
  for xCount := 0 to GPlugins.Count - 1 do begin
    xElement := TCListDataElement.Create(True, Sender, TCDataListElementObject(GPlugins.Items[xCount]), False);
    ARootElement.Add(xElement);
  end;
end;

procedure TCPreferencesForm.ListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
var xConfigurable: Boolean;
    xHasAbout: Boolean;
begin
  xConfigurable := False;
  xHasAbout := False;
  if Node <> Nil then begin
    xConfigurable := TCPlugin(List.GetTreeElement(Node).Data).isConfigurable;
    xHasAbout := TCPlugin(List.GetTreeElement(Node).Data).hasAbout;
  end;
  Action9.Enabled := xConfigurable;
  Action10.Enabled := xHasAbout;
end;

procedure TCPreferencesForm.Action9Execute(Sender: TObject);
var xConfiguration: String;
    xPlugin: TCPlugin;
    xPluginPref: TPluginPref;
begin
  xPlugin := TCPlugin(List.SelectedElement.Data);
  xPluginPref := TPluginPref(FPluginPrefs.ByPrefname[xPlugin.fileName]);
  if xPluginPref = Nil then begin
    xConfiguration := '';
  end else begin
    xConfiguration := xPluginPref.configuration;
  end;
  if xPlugin.Configure then begin
    if xPluginPref = Nil then begin
      xPluginPref := TPluginPref.CreatePluginPref(xPlugin.fileName, xPlugin.pluginConfiguration);
      FPluginPrefs.Add(xPluginPref, True);
    end;
    xPluginPref.configuration := xPlugin.pluginConfiguration;
  end;
end;

procedure TCPreferencesForm.ListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  Node.CheckType := ctCheckBox;
end;

procedure TCPreferencesForm.ListChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  if FRestartInfo = '' then begin
    FRestartInfo := 'Zmiany aktywno�ci wtyczek zostan� wprowadzone dopiero po ponownym uruchomieniu CManager-a';
  end;
end;

procedure TCPreferencesForm.Action10Execute(Sender: TObject);
begin
  TCPlugin(List.SelectedElement.Data).About;
end;

procedure TCPreferencesForm.Panel4Click(Sender: TObject);
begin
  ColorDialog.Color := Panel4.Color;
  if ColorDialog.Execute then begin
    Panel4.Color := ColorDialog.Color;
  end;
end;

procedure TCPreferencesForm.Panel5Click(Sender: TObject);
begin
  ColorDialog.Color := Panel5.Color;
  if ColorDialog.Execute then begin
    Panel5.Color := ColorDialog.Color;
  end;
end;

procedure TCPreferencesForm.Action11Execute(Sender: TObject);
var xPrefs: TCListPreferencesForm;
begin
  xPrefs := TCListPreferencesForm.Create(Nil);
  if xPrefs.ShowListPreferences(TViewPref(FViewPrefs.ByPrefname[TCExtractionsFrame.GetPrefname])) then begin
    SendMessageToFrames(TCExtractionsFrame, WM_MUSTREPAINT, 0, 0);
  end;
  xPrefs.Free;
end;

procedure TCPreferencesForm.CStaticAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCAccountsFrame, ADataGid, AText);
end;

procedure TCPreferencesForm.CStaticCategoryGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCProductsFrame, ADataGid, AText);
end;

procedure TCPreferencesForm.CStaticCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCCashpointsFrame, ADataGid, AText);
end;

procedure TCPreferencesForm.CStaticProfileGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCProfileFrame, ADataGid, AText);
end;

procedure TCPreferencesForm.ShortcutListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
begin
  CellText := TAction(ActionManager1.Actions[Node.Index]).Caption;
end;

procedure TCPreferencesForm.ShortcutListHotChange(Sender: TBaseVirtualTree; OldNode, NewNode: PVirtualNode);
begin
  if NewNode <> Nil then begin
    if NewNode.Index <> 0 then begin
      Sender.Cursor := crHandPoint;
    end;
  end else begin
    Sender.Cursor := crDefault;
  end;
end;

procedure TCPreferencesForm.ShortcutListGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
begin
  ImageIndex := TAction(ActionManager1.Actions[Node.Index]).ImageIndex;
end;

procedure TCPreferencesForm.ShortcutListClick(Sender: TObject);
var xAction: TAction;
begin
  if (ShortcutList.FocusedNode <> Nil) then begin
    xAction := TAction(ActionManager1.Actions[ShortcutList.FocusedNode.Index]);
    xAction.Execute;
  end;
end;

procedure TCPreferencesForm.Ustawienialisty1Click(Sender: TObject);
var xPrefs: TCListPreferencesForm;
begin
  xPrefs := TCListPreferencesForm.Create(Nil);
  if xPrefs.ShowListPreferences(ShortcutList.ViewPref) then begin
    ShortcutList.ReinitNode(ShortcutList.RootNode, True);
    ShortcutList.Repaint;
  end;
  xPrefs.Free;
end;

procedure TCPreferencesForm.CStaticDefaultCurrencyGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCCurrencydefFrame, ADataGid, AText);
end;

end.