unit CProfileFrameUnit;

interface

uses CDataobjectFrameUnit, Classes, ActnList, VTHeaderPopup, Menus,
     ImgList, Controls, PngImageList, CComponents, VirtualTrees, StdCtrls,
     ExtCtrls, CDatabase, CDataobjectFormUnit, CImageListsUnit;

type
  TCProfileFrame = class(TCDataobjectFrame)
  public
    class function GetTitle: String; override;
    procedure ReloadDataobjects; override;
    function GetDataobjectClass(AOption: Integer): TDataObjectClass; override;
    function GetDataobjectProxy(AOption: Integer): TDataProxy; override;
    function GetDataobjectForm(AOption: Integer): TCDataobjectFormClass; override;
  end;

implementation

uses CDataObjects, CProfileFormUnit;

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

class function TCProfileFrame.GetTitle: String;
begin
  Result := 'Profile';
end;

procedure TCProfileFrame.ReloadDataobjects;
begin
  inherited ReloadDataobjects;
  Dataobjects := TProfile.GetList(TProfile, ProfileProxy, 'select * from profile')
end;

end.
