unit CListPreferencesFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, CComponents,
  ActnList, XPStyleActnCtrls, ActnMan, ImgList, PngImageList, CPreferences;

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
    procedure Action3Execute(Sender: TObject);
    procedure Action4Execute(Sender: TObject);
    procedure ComboBoxTypeChange(Sender: TObject);
  private
    FPrefContainer: TPrefList;
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
  FontDialog.Font := PanelExample.Font;
  if FontDialog.Execute then begin
    PanelExample.Font := FontDialog.Font;
    xObj.Font.Assign(FontDialog.Font);
  end;
end;

procedure TCListPreferencesForm.Action4Execute(Sender: TObject);
var xObj: TFontPref;
begin
  xObj := TFontPref(ComboBoxType.Items.Objects[ComboBoxType.ItemIndex]);
  ColorDialog.Color := PanelExample.Color;
  if ColorDialog.Execute then begin
    PanelExample.Color := ColorDialog.Color;
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
    PanelExample.Font.Assign(xObj.Font);
    PanelExample.Color := xObj.Background;
  end;
end;

end.
 