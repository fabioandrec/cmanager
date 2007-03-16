unit CLimitsFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, Menus, ImgList, PngImageList, CComponents,
  ExtCtrls, VirtualTrees, ActnList, VTHeaderPopup;

type
  TCLimitsFrame = class(TCBaseFrame)
    ProfileList: TVirtualStringTree;
    PanelFrameButtons: TPanel;
    CButtonAddProfile: TCButton;
    CButtonEditProfile: TCButton;
    CButtonDelProfile: TCButton;
    VTHeaderPopupMenu: TVTHeaderPopupMenu;
    ActionList: TActionList;
    ActionAddLimit: TAction;
    ActionEditLimit: TAction;
    ActionDelLimit: TAction;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
