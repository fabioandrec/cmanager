unit CFilterFrameUnit;

interface

uses CDataobjectFrameUnit, Classes, ActnList, VTHeaderPopup, Menus,
     ImgList, Controls, PngImageList, CComponents, VirtualTrees, StdCtrls,
     ExtCtrls, CDatabase, CDataobjectFormUnit, CImageListsUnit, Dialogs;

type
  TCFilterFrame = class(TCDataobjectFrame)
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

uses CDataObjects, CFilterFormUnit, CPluginConsts, CBaseFrameUnit;

{$R *.dfm}

function TCFilterFrame.GetDataobjectClass(AOption: Integer): TDataObjectClass;
begin
  Result := TMovementFilter;
end;

function TCFilterFrame.GetDataobjectForm(AOption: Integer): TCDataobjectFormClass;
begin
  Result := TCFilterForm;
end;

function TCFilterFrame.GetDataobjectProxy(AOption: Integer): TDataProxy;
begin
  Result := MovementFilterProxy;
end;

function TCFilterFrame.GetSelectedType: Integer;
begin
  if List.FocusedNode <> Nil then begin
    Result := CSELECTEDITEM_FILTER;
  end else begin
    Result := CSELECTEDITEM_INCORRECT;
  end;
end;

class function TCFilterFrame.GetTitle: String;
begin
  Result := 'Filtry';
end;

function TCFilterFrame.IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean;
begin
  Result := (APluginSelectedItemTypes and CSELECTEDITEM_FILTER) = CSELECTEDITEM_FILTER;
end;

procedure TCFilterFrame.ReloadDataobjects;
begin
  inherited ReloadDataobjects;
  Dataobjects := TMovementFilter.GetList(TMovementFilter, MovementFilterProxy, 'select * from movementFilter where isTemp = 0')
end;

end.
