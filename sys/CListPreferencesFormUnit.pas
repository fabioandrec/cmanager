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
    procedure Action3Execute(Sender: TObject);
    procedure Action4Execute(Sender: TObject);
    procedure ComboBoxTypeChange(Sender: TObject);
    procedure TrackBarChange(Sender: TObject);
  private
    FPrefContainer: TPrefList;
    procedure UpdatePanelRowPosition;
  public
    function ShowListPreferences(AFrameName: String; APrefContainer: TPrefList): Boolean;
  end;

implementation

uses Contnrs;

{$R *.dfm}

procedure TCListPreferencesForm.Action3Execute(Sender: TObject);
var xObj: TFontPref;
begin
  xObj := TFontPref(ComboBoxType.Items.Objects[ComboBoxType.ItemIndex]);
  FontDialog.Font := PanelRow.Font;
  if FontDialog.Execute then begin
    PanelRow.Font := FontDialog.Font;
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
    xViewPref: TViewPref;
    xFontPref: TFontPref;
begin
  FPrefContainer := APrefContainer;
  xViewPref := TViewPref.Create(AFrameName);
  xViewPref.Clone(FPrefContainer.ByPrefname[AFramename]);
  for xCount := 0 to xViewPref.Fontprefs.Count - 1 do begin
    xFontPref := TFontPref(xViewPref.Fontprefs.Items[xCount]);
    ComboBoxType.AddItem(xFontPref.Desc, xFontPref);
  end;
  ComboBoxType.ItemIndex := 0;
  ComboBoxTypeChange(Nil);
  Result := ShowConfig(coEdit);
  if Result then begin
    FPrefContainer.ByPrefname[AFramename].Clone(xViewPref);
  end;
  xViewPref.Free;
end;

procedure TCListPreferencesForm.ComboBoxTypeChange(Sender: TObject);
var xObj: TFontPref;
begin
  if ComboBoxType.ItemIndex <> -1 then begin
    xObj := TFontPref(ComboBoxType.Items.Objects[ComboBoxType.ItemIndex]);
    PanelRow.Font.Assign(xObj.Font);
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
  PanelRow.Top := (PanelExample.Height - PanelRow.Height) div 2;
end;

end.
