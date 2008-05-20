unit CListPreferencesFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, CComponents,
  ActnList, XPStyleActnCtrls, ActnMan, ImgList, PngImageList, CPreferences,
  ComCtrls, VirtualTrees;

type
  TCListPreferencesForm = class(TCConfigForm)
    FontImageList: TPngImageList;
    ActionManager: TActionManager;
    ActionFont: TAction;
    ActionBackgroundOdd: TAction;
    GroupBox2: TGroupBox;
    CButton5: TCButton;
    CButton6: TCButton;
    PanelExample: TPanel;
    ComboBoxType: TComboBox;
    FontDialog: TFontDialog;
    ColorDialog: TColorDialog;
    TrackBar: TTrackBar;
    Label1: TLabel;
    ActionBackgroundActive: TAction;
    ActionFontActive: TAction;
    CButton1: TCButton;
    CButton2: TCButton;
    CButton3: TCButton;
    ActionBackgroundEven: TAction;
    ExampleList: TCDataList;
    CButton4: TCButton;
    ActionDefault: TAction;
    procedure ExampleListCDataListReloadTree(Sender: TCDataList; ARootElement: TCListDataElement);
    procedure ActionFontExecute(Sender: TObject);
    procedure ActionBackgroundOddExecute(Sender: TObject);
    procedure ActionBackgroundEvenExecute(Sender: TObject);
    procedure ActionBackgroundActiveExecute(Sender: TObject);
    procedure ActionFontActiveExecute(Sender: TObject);
    procedure TrackBarChange(Sender: TObject);
    procedure ComboBoxTypeChange(Sender: TObject);
    procedure ExampleListGetRowPreferencesName(AHelper: TObject; var APrefname: String);
    procedure ActionDefaultExecute(Sender: TObject);
  private
    FViewPref: TViewPref;
    procedure RefreshList;
  public
    function ShowListPreferences(AViewPref: TViewPref): Boolean;
  end;

implementation

uses Contnrs;

{$R *.dfm}

function TCListPreferencesForm.ShowListPreferences(AViewPref: TViewPref): Boolean;
var xCount: Integer;
    xFontPref: TFontPref;
begin
  FViewPref := TViewPref.Create(AViewPref.Prefname);
  FViewPref.Clone(AViewPref);
  for xCount := 0 to FViewPref.Fontprefs.Count - 1 do begin
    xFontPref := TFontPref(FViewPref.Fontprefs.Items[xCount]);
    ComboBoxType.AddItem(xFontPref.Desc, xFontPref);
  end;
  ComboBoxType.ItemIndex := 0;
  ExampleList.ViewPref := FViewPref;
  ExampleList.ReloadTree;
  ComboBoxTypeChange(Nil);
  SetSystemCustomColors(ColorDialog);
  Result := ShowConfig(coEdit);
  if Result then begin
    AViewPref.Clone(FViewPref);
  end;
  FViewPref.Free;
end;

procedure TCListPreferencesForm.ExampleListCDataListReloadTree(Sender: TCDataList; ARootElement: TCListDataElement);
begin
  ARootElement.Add(TCListDataElement.Create(False, ExampleList, TCDataListSimpleString.Create('Element 0 - parzysty'), True, False));
  ARootElement.Add(TCListDataElement.Create(False, ExampleList, TCDataListSimpleString.Create('Element 1 - nieparzysty'), True, False));
  ARootElement.Add(TCListDataElement.Create(False, ExampleList, TCDataListSimpleString.Create('Element 2 - parzysty'), True, False));
  ARootElement.Add(TCListDataElement.Create(False, ExampleList, TCDataListSimpleString.Create('Element 3 - nieparzysty'), True, False));
end;

procedure TCListPreferencesForm.ActionFontExecute(Sender: TObject);
var xFontPref: TFontPref;
begin
  xFontPref := TFontPref(ComboBoxType.Items.Objects[ComboBoxType.ItemIndex]);
  FontDialog.Font.Assign(xFontPref.Font);
  if FontDialog.Execute then begin
    xFontPref.Font.Assign(FontDialog.Font);
    RefreshList;
  end;
end;

procedure TCListPreferencesForm.RefreshList;
begin
  ExampleList.ReinitNode(ExampleList.RootNode, True);
  ExampleList.Repaint;
end;

procedure TCListPreferencesForm.ActionBackgroundOddExecute(Sender: TObject);
var xFontPref: TFontPref;
begin
  xFontPref := TFontPref(ComboBoxType.Items.Objects[ComboBoxType.ItemIndex]);
  ColorDialog.Color := xFontPref.Background;
  if ColorDialog.Execute then begin
    xFontPref.Background := ColorDialog.Color;
    RefreshList;
  end;
end;

procedure TCListPreferencesForm.ActionBackgroundEvenExecute(Sender: TObject);
var xFontPref: TFontPref;
begin
  xFontPref := TFontPref(ComboBoxType.Items.Objects[ComboBoxType.ItemIndex]);
  ColorDialog.Color := xFontPref.BackgroundEven;
  if ColorDialog.Execute then begin
    xFontPref.BackgroundEven := ColorDialog.Color;
    RefreshList;
  end;
end;

procedure TCListPreferencesForm.ActionBackgroundActiveExecute(Sender: TObject);
begin
  ColorDialog.Color := FViewPref.FocusedBackgroundColor;
  if ColorDialog.Execute then begin
    FViewPref.FocusedBackgroundColor := ColorDialog.Color;
    RefreshList;
  end;
end;

procedure TCListPreferencesForm.ActionFontActiveExecute(Sender: TObject);
begin
  ColorDialog.Color := FViewPref.FocusedFontColor;
  if ColorDialog.Execute then begin
    FViewPref.FocusedFontColor := ColorDialog.Color;
    RefreshList;
  end;
end;

procedure TCListPreferencesForm.TrackBarChange(Sender: TObject);
begin
  TFontPref(ComboBoxType.Items.Objects[ComboBoxType.ItemIndex]).RowHeight := TrackBar.Position;
  RefreshList;
end;

procedure TCListPreferencesForm.ComboBoxTypeChange(Sender: TObject);
begin
  if ComboBoxType.ItemIndex <> -1 then begin
    TrackBar.Position := TFontPref(ComboBoxType.Items.Objects[ComboBoxType.ItemIndex]).RowHeight;
    RefreshList; 
  end;
end;

procedure TCListPreferencesForm.ExampleListGetRowPreferencesName(AHelper: TObject; var APrefname: String);
begin
  APrefname := TFontPref(ComboBoxType.Items.Objects[ComboBoxType.ItemIndex]).Prefname;
end;

procedure TCListPreferencesForm.ActionDefaultExecute(Sender: TObject);
var xDefault: TPrefList;
    xPref: TViewPref;
    xCount: Integer;
begin
  xDefault := GetDefaultViewPreferences;
  xPref := TViewPref(xDefault.ByPrefname[FViewPref.Prefname]);
  if xPref <> Nil then begin
    ExampleList.BeginUpdate;
    ComboBoxType.Items.BeginUpdate;
    for xCount := 0 to ComboBoxType.Items.Count - 1 do begin
      ComboBoxType.Items.Objects[xCount] := Nil;
    end;
    FViewPref.Clone(xPref);
    for xCount := 0 to ComboBoxType.Items.Count - 1 do begin
      ComboBoxType.Items.Objects[xCount] := TFontPref(FViewPref.Fontprefs.Items[xCount]);
    end;
    ExampleList.ViewPref := FViewPref;
    ComboBoxType.Items.EndUpdate;
    ExampleList.EndUpdate;
    RefreshList;
  end;
  xDefault.Free;
end;

end.
