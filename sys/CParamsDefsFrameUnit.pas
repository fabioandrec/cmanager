unit CParamsDefsFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, Menus, ImgList, PngImageList, ExtCtrls,
  VirtualTrees, CComponents, VTHeaderPopup, ActnList, CImageListsUnit;

type
  TCParamsDefsFrame = class(TCBaseFrame)
    ActionListButtons: TActionList;
    ActionAdd: TAction;
    ActionEdit: TAction;
    ActionDelete: TAction;
    VTHeaderPopupMenu: TVTHeaderPopupMenu;
    List: TCDataList;
    ButtonPanel: TPanel;
    CButtonAdd: TCButton;
    CButtonEdit: TCButton;
    CButtonDelete: TCButton;
    CButtonHistory: TCButton;
    Bevel: TBevel;
    ActionPreview: TAction;
  private
    { Private declarations }
  public
    function GetList: TCList; override;
    procedure InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean); override;
  end;

implementation

{$R *.dfm}

function TCParamsDefsFrame.GetList: TCList;
begin
  Result := List;
end;

procedure TCParamsDefsFrame.InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean);
begin
  inherited InitializeFrame(AOwner, AAdditionalData, AOutputData, AMultipleCheck, AWithButtons);
  CButtonHistory.Width := CButtonHistory.Canvas.TextWidth(ActionPreview.Caption) + CButtonHistory.PicOffset + ActionListButtons.Images.Width + 10;
  CButtonHistory.Left := ButtonPanel.Width - CButtonHistory.Width - 15;
  CButtonHistory.Anchors := [akTop, akRight];
end;

end.
 