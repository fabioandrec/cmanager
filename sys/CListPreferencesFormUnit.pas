unit CListPreferencesFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, CComponents,
  ActnList, XPStyleActnCtrls, ActnMan, ImgList, PngImageList, CPreferences,
  ComCtrls;

type
  TCListPreferencesForm = class(TCConfigForm)
    FontImageList: TPngImageList;
    ActionManager: TActionManager;
    Action3: TAction;
    Action4: TAction;
    GroupBox2: TGroupBox;
    CButton5: TCButton;
    CButton6: TCButton;
    PanelExample: TPanel;
    ComboBoxType: TComboBox;
    FontDialog: TFontDialog;
    ColorDialog: TColorDialog;
    TrackBar: TTrackBar;
    Label1: TLabel;
    PanelRow: TPanel;
    Action1: TAction;
    Action2: TAction;
    CButton1: TCButton;
    CButton2: TCButton;
    PanelActive: TPanel;
    CButton3: TCButton;
    Action5: TAction;
    procedure Action3Execute(Sender: TObject);
    procedure Action4Execute(Sender: TObject);
    procedure ComboBoxTypeChange(Sender: TObject);
    procedure TrackBarChange(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
  private
    FPrefContainer: TPrefList;
    FViewPref: TViewPref;
    procedure UpdatePanelRowPosition;
  public
    function ShowListPreferences(AFrameName: String; APrefContainer: TPrefList): Boolean;
  end;

implementation

uses Contnrs;

{$R *.dfm}

procedure TCListPreferencesForm.Action3Execute(Sender: TObject);
var xObj: TFontPref;
    xPrevColor: TColor;
begin
  xObj := TFontPref(ComboBoxType.Items.Objects[ComboBoxType.ItemIndex]);
  FontDialog.Font := PanelRow.Font;
  xPrevColor := PanelActive.Font.Color;;
  if FontDialog.Execute then begin
    PanelRow.Font := FontDialog.Font;
    PanelActive.Font := FontDialog.Font;
    PanelActive.Font.Color := xPrevColor;
    xObj.Font.Assign(FontDialog.Font);
  end;
end;

procedure TCListPreferencesForm.Action4Execute(Sender: TObject);
var xObj: TFontPref;
begin
  xObj := TFontPref(ComboBoxType.Items.Objects[ComboBoxType.ItemIndex]);
  ColorDialog.Color := PanelRow.Color;
  if ColorDialog.Execute then begin
    PanelRow.Color := ColorDialog.Color;
    xObj.Background := ColorDialog.Color;
  end;
end;

function TCListPreferencesForm.ShowListPreferences(AFrameName: String; APrefContainer: TPrefList): Boolean;
var xCount: Integer;
    xFontPref: TFontPref;
begin
  FPrefContainer := APrefContainer;
  FViewPref := TViewPref.Create(AFrameName);
  FViewPref.Clone(FPrefContainer.ByPrefname[AFramename]);
  for xCount := 0 to FViewPref.Fontprefs.Count - 1 do begin
    xFontPref := TFontPref(FViewPref.Fontprefs.Items[xCount]);
    ComboBoxType.AddItem(xFontPref.Desc, xFontPref);
  end;
  ComboBoxType.ItemIndex := 0;
  ComboBoxTypeChange(Nil);
  PanelActive.Font.Color := FViewPref.FocusedFontColor;
  PanelActive.Color := FViewPref.FocusedBackgroundColor;
  Result := ShowConfig(coEdit);
  if Result then begin
    FPrefContainer.ByPrefname[AFramename].Clone(FViewPref);
  end;
  FViewPref.Free;
end;

procedure TCListPreferencesForm.ComboBoxTypeChange(Sender: TObject);
var xObj: TFontPref;
    xPrevColor: TColor;
begin
  if ComboBoxType.ItemIndex <> -1 then begin
    xObj := TFontPref(ComboBoxType.Items.Objects[ComboBoxType.ItemIndex]);
    xPrevColor := PanelActive.Font.Color;
    PanelRow.Font.Assign(xObj.Font);
    PanelActive.Font.Assign(xObj.Font);
    PanelActive.Font.Color := xPrevColor;
    PanelRow.Color := xObj.Background;
    TrackBar.Position := xObj.RowHeight;
    UpdatePanelRowPosition;
  end;
end;

procedure TCListPreferencesForm.TrackBarChange(Sender: TObject);
var xObj: TFontPref;
begin
  xObj := TFontPref(ComboBoxType.Items.Objects[ComboBoxType.ItemIndex]);
  xObj.RowHeight := TrackBar.Position;
  UpdatePanelRowPosition;
end;

procedure TCListPreferencesForm.UpdatePanelRowPosition;
begin
  PanelRow.Height := TrackBar.Position;
  PanelActive.Height := TrackBar.Position;
  PanelRow.Top := (PanelExample.Height - (PanelRow.Height + PanelActive.Height)) div 2;
  PanelActive.Top := PanelRow.Top + PanelRow.Height + 1;
end;

procedure TCListPreferencesForm.Action1Execute(Sender: TObject);
begin
  ColorDialog.Color := PanelActive.Color;
  if ColorDialog.Execute then begin
    PanelActive.Color := ColorDialog.Color;
    FViewPref.FocusedBackgroundColor := ColorDialog.Color;
  end;
end;

procedure TCListPreferencesForm.Action2Execute(Sender: TObject);
begin
  ColorDialog.Color := PanelActive.Font.Color;
  if ColorDialog.Execute then begin
    PanelActive.Font.Color := ColorDialog.Color;
    FViewPref.FocusedFontColor := ColorDialog.Color;
  end;
end;

end.
