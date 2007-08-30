unit CUnitDefFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFrameUnit, ActnList, VTHeaderPopup, Menus, ImgList,
  PngImageList, CComponents, VirtualTrees, StdCtrls, ExtCtrls, CDatabase,
  CDataObjectFormUnit, CImageListsUnit;

type
  TCUnitDefFrame = class(TCDataobjectFrame)
  protected
    function IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean; override;
    function GetSelectedType: Integer; override;
  public
    class function GetTitle: String; override;
    procedure ReloadDataobjects; override;
    class function GetDataobjectClass(AOption: Integer): TDataObjectClass; override;
    class function GetDataobjectProxy(AOption: Integer): TDataProxy; override;
    function GetDataobjectForm(AOption: Integer): TCDataobjectFormClass; override;
  end;

implementation

uses CDataObjects, CPluginConsts, CUnitdefFormUnit, CBaseFrameUnit;

{$R *.dfm}

class function TCUnitDefFrame.GetDataobjectClass(AOption: Integer): TDataObjectClass;
begin
  Result := TUnitDef;
end;

function TCUnitDefFrame.GetDataobjectForm(AOption: Integer): TCDataobjectFormClass;
begin
  Result := TCUnitdefForm;
end;

class function TCUnitDefFrame.GetDataobjectProxy(AOption: Integer): TDataProxy;
begin
  Result := UnitDefProxy;
end;

function TCUnitDefFrame.GetSelectedType: Integer;
begin
  if List.FocusedNode <> Nil then begin
    Result := CSELECTEDITEM_UNITDEF;
  end else begin
    Result := CSELECTEDITEM_INCORRECT;
  end;
end;

class function TCUnitDefFrame.GetTitle: String;
begin
  Result := 'Jednostki miary';
end;

function TCUnitDefFrame.IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean;
begin
  Result := (APluginSelectedItemTypes and CSELECTEDITEM_UNITDEF) = CSELECTEDITEM_UNITDEF;
end;

procedure TCUnitDefFrame.ReloadDataobjects;
begin
  inherited ReloadDataobjects;
  Dataobjects := TUnitDef.GetList(TUnitDef, UnitDefProxy, 'select * from unitDef');
end;

end.
