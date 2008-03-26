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
    class function GetDataobjectClass(AOption: Integer): TDataObjectClass; override;
    class function GetDataobjectProxy(AOption: Integer): TDataProxy; override;
    function GetDataobjectForm(AOption: Integer): TCDataobjectFormClass; override;
    procedure UpdateButtons(AIsSelectedSomething: Boolean); override;
  end;

implementation

uses CDataObjects, CProfileFormUnit, CPluginConsts, CBaseFrameUnit,
  CDatatools, CTools, CFrameFormUnit;

{$R *.dfm}

class function TCProfileFrame.GetDataobjectClass(AOption: Integer): TDataObjectClass;
begin
  Result := TProfile;
end;

function TCProfileFrame.GetDataobjectForm(AOption: Integer): TCDataobjectFormClass;
begin
  Result := TCProfileForm;
end;

class function TCProfileFrame.GetDataobjectProxy(AOption: Integer): TDataProxy;
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
var xMark: TProfile;
begin
  inherited ReloadDataobjects;
  Dataobjects := TProfile.GetList(TProfile, ProfileProxy, 'select * from profile');
  if FrameOwner.InheritsFrom(TCFrameForm) then begin
    if TCFrameForm(FrameOwner).IsChoice then begin
      xMark := TProfile.Create(True);
      xMark.id := CEmptyDataGid;
      xMark.name := '<wyczyœæ aktywny profil>';
      Dataobjects.Add(xMark);
    end;
  end;
end;

procedure TCProfileFrame.UpdateButtons(AIsSelectedSomething: Boolean);
begin
  inherited UpdateButtons(AIsSelectedSomething);
  ActionEdit.Enabled := ActionEdit.Enabled and (TDataObject(List.SelectedElement.Data).id <> CEmptyDataGid);
  ActionDelete.Enabled := ActionDelete.Enabled and (TDataObject(List.SelectedElement.Data).id <> CEmptyDataGid);
end;

end.
