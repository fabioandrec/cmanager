unit CPreferencesFormUnit;

interface

{$WARN UNIT_PLATFORM OFF}

uses  CConfigFormUnit, StdCtrls, Dialogs, ImgList, Controls,
  PngImageList, Classes, ActnList, XPStyleActnCtrls, ActnMan, CComponents,
  ComCtrls, Buttons, ExtCtrls, Windows, Messages, SysUtils, Variants, Graphics,
  Forms, VirtualTrees, CPreferences;

const
  CPreferencesFirstTab = 0;

type
  TCPreferencesForm = class(TCConfigForm)
    PanelMain: TPanel;
    PanelShortcuts: TPanel;
    PanelShortcutsTitle: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    PageControl: TPageControl;
    CButton1: TCButton;
    ActionManager1: TActionManager;
    Action1: TAction;
    CategoryImageList: TPngImageList;
    Action2: TAction;
    CButton2: TCButton;
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
    CButton3: TCButton;
    Action3: TAction;
    TabSheetAutostart: TTabSheet;
    GroupBox3: TGroupBox;
    CheckBoxAutostartOperations: TCheckBox;
    ComboBoxDays: TComboBox;
    Label4: TLabel;
    CIntEditDays: TCIntEdit;
    CheckBoxAutoIn: TCheckBox;
    CheckBoxAutoOut: TCheckBox;
    CheckBoxAutoAlways: TCheckBox;
    Label1: TLabel;
    CheckBoxAutoOldIn: TCheckBox;
    CheckBoxAutoOldOut: TCheckBox;
    procedure CStaticFileNameGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure RadioButtonLastClick(Sender: TObject);
    procedure RadioButtonThisClick(Sender: TObject);
    procedure RadioButtonNeverClick(Sender: TObject);
    procedure ComboBoxDaysChange(Sender: TObject);
    procedure CheckBoxAutostartOperationsClick(Sender: TObject);
  private
    FActiveAction: TAction;
    FViewPrefs: TPrefList;
    FBasePrefs: TBasePref;
    procedure SetActiveAction(const Value: TAction);
    procedure ActionExecute(Sender: TObject);
    procedure UpdateFilenameState;
  protected
    procedure FillForm; override;
    procedure ReadValues; override;
  public
    function ShowPreferences(ATab: Integer = CPreferencesFirstTab): Boolean;
    property ActiveAction: TAction read FActiveAction write SetActiveAction;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

uses CListPreferencesFormUnit, StrUtils, FileCtrl, CConsts;

{$R *.dfm}

function TCPreferencesForm.ShowPreferences(ATab: Integer): Boolean;
begin
  Action1.OnExecute := ActionExecute;
  Action2.OnExecute := ActionExecute;
  Action3.OnExecute := ActionExecute;
  ActiveAction := TAction(ActionManager1.Actions[ATab]);
  FViewPrefs.Clone(GViewsPreferences);
  FBasePrefs.Clone(GBasePreferences);
  Result := ShowConfig(coEdit);
  if Result then begin
    GViewsPreferences.Clone(FViewPrefs);
    GBasePreferences.Clone(FBasePrefs);
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
end;

destructor TCPreferencesForm.Destroy;
begin
  FViewPrefs.Free;
  FBasePrefs.Free;
  inherited Destroy;
end;

procedure TCPreferencesForm.FillForm;
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
    CheckBoxStatusVisible.Checked := showStatusBar;
    CheckBoxAutostartOperations.Checked := startupInfo;
    ComboBoxDays.ItemIndex := startupInfoType;
    CIntEditDays.Text := IntToStr(startupInfoDays);
    CheckBoxAutoIn.Checked := startupInfoIn;
    CheckBoxAutoOut.Checked := startupInfoOut;
    CheckBoxAutoAlways.Checked := startupInfoAlways;
    CheckBoxAutoOldIn.Checked := startupInfoOldIn;
    CheckBoxAutoOldOut.Checked := startupInfoOldOut;
  end;
  ComboBoxDays.Enabled := CheckBoxAutostartOperations.Checked;
  CheckBoxAutostartOperationsClick(Nil);
  UpdateFilenameState;
end;

procedure TCPreferencesForm.ReadValues;
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
    showStatusBar := CheckBoxStatusVisible.Checked;
    startupInfo := CheckBoxAutostartOperations.Checked;
    startupInfoType := ComboBoxDays.ItemIndex;
    startupInfoDays := CIntEditDays.Value;
    startupInfoIn := CheckBoxAutoIn.Checked;
    startupInfoOut := CheckBoxAutoOut.Checked;
    startupInfoAlways := CheckBoxAutoAlways.Checked;
    startupInfoOldIn := CheckBoxAutoOldIn.Checked;
    startupInfoOldOut := CheckBoxAutoOldOut.Checked;
  end;
end;

procedure TCPreferencesForm.ComboBoxDaysChange(Sender: TObject);
begin
  CIntEditDays.Enabled := (ComboBoxDays.ItemIndex = ComboBoxDays.Items.Count - 1) and (CheckBoxAutostartOperations.Checked);
  Label4.Enabled := CIntEditDays.Enabled;
  Label1.Enabled := CIntEditDays.Enabled;
end;

procedure TCPreferencesForm.CheckBoxAutostartOperationsClick(Sender: TObject);
begin
  ComboBoxDays.Enabled := CheckBoxAutostartOperations.Checked;
  CheckBoxAutoIn.Enabled := ComboBoxDays.Enabled;
  CheckBoxAutoOut.Enabled := ComboBoxDays.Enabled;
  CheckBoxAutoOldIn.Enabled := ComboBoxDays.Enabled;
  CheckBoxAutoOldOut.Enabled := ComboBoxDays.Enabled;
  CheckBoxAutoAlways.Enabled := ComboBoxDays.Enabled;
  ComboBoxDaysChange(Nil);
end;

end.
