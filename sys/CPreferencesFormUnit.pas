unit CPreferencesFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, VirtualTrees,
  ComCtrls, ActnList, XPStyleActnCtrls, ActnMan, CComponents, ImgList,
  PngImageList;

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
  private
    FActiveAction: TAction;
    procedure SetActiveAction(const Value: TAction);
    procedure ActionExecute(Sender: TObject);
  public
    function ShowPreferences(ATab: Integer = CPreferencesFirstTab): Boolean;
    property ActiveAction: TAction read FActiveAction write SetActiveAction;
  end;

implementation

uses CListPreferencesFormUnit;

{$R *.dfm}

function TCPreferencesForm.ShowPreferences(ATab: Integer): Boolean;
begin
  Action1.OnExecute := ActionExecute;
  Action2.OnExecute := ActionExecute;
  ActiveAction := TAction(ActionManager1.Actions[ATab]);
  Result := ShowConfig(coEdit);
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

end.
