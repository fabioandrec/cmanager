unit CFilterFrameUnit;

interface

uses CDataobjectFrameUnit, Classes, ActnList, VTHeaderPopup, Menus,
     ImgList, Controls, PngImageList, CComponents, VirtualTrees, StdCtrls,
     ExtCtrls, CDatabase, CDataobjectFormUnit, CImageListsUnit;

type
  TCFilterFrame = class(TCDataobjectFrame)
    class function GetTitle: String; override;
    procedure ReloadDataobjects; override;
    function GetDataobjectClass(AOption: Integer): TDataObjectClass; override;
    function GetDataobjectProxy(AOption: Integer): TDataProxy; override;
    function GetDataobjectForm(AOption: Integer): TCDataobjectFormClass; override;
  end;

implementation

uses CDataObjects, CFilterFormUnit;

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

class function TCFilterFrame.GetTitle: String;
begin
  Result := 'Filtry';
end;

procedure TCFilterFrame.ReloadDataobjects;
begin
  inherited ReloadDataobjects;
  Dataobjects := TMovementFilter.GetList(TMovementFilter, MovementFilterProxy, 'select * from movementFilter')
end;

end.
