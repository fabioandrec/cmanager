unit CProfileFrameUnit;

interface

uses CDataobjectFrameUnit, Classes, ActnList, VTHeaderPopup, Menus,
     ImgList, Controls, PngImageList, CComponents, VirtualTrees, StdCtrls,
     ExtCtrls, CDatabase, CDataobjectFormUnit, CImageListsUnit, Dialogs;

type
  TCProfileFrame = class(TCDataobjectFrame)
  protected
    function GetSelectedType: Integer; override;
    function IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean; override;
  public
    class function GetTitle: String; override;
    procedure ReloadDataobjects; override;
    function GetDataobjectClass(AOption: Integer): TDataObjectClass; override;
    function GetDataobjectProxy(AOption: Integer): TDataProxy; override;
    function GetDataobjectForm(AOption: Integer): TCDataobjectFormClass; override;
  end;

implementation

uses CDataObjects, CProfileFormUnit, CPluginConsts, CBaseFrameUnit;

{$R *.dfm}

function TCProfileFrame.GetDataobjectClass(AOption: Integer): TDataObjectClass;
begin
  Result := TProfile;
end;

function TCProfileFrame.GetDataobjectForm(AOption: Integer): TCDataobjectFormClass;
begin
  Result := TCProfileForm;
end;

function TCProfileFrame.GetDataobjectProxy(AOption: Integer): TDataProxy;
begin
  Result := ProfileProxy;
end;

function TCProfileFrame.GetSelectedType: Integer;
begin
  if List.FocusedNode <> Nil then begin
    Result := CSELECTEDITEM_PROFILE;
  end else begin
    Result := CSELECTEDITEM_INCORRECT;
  end;
end;

class function TCProfileFrame.GetTitle: String;
begin
  Result := 'Profile';
end;

function TCProfileFrame.IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean;
begin
  Result := (APluginSelectedItemTypes and CSELECTEDITEM_PROFILE) = CSELECTEDITEM_PROFILE;
end;

procedure TCProfileFrame.ReloadDataobjects;
begin
  inherited ReloadDataobjects;
  Dataobjects := TProfile.GetList(TProfile, ProfileProxy, 'select * from profile')
end;

end.
