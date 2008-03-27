unit CQuickpatternFrameUnit;

interface

uses CDataobjectFrameUnit, Classes, ActnList, VTHeaderPopup, Menus,
     ImgList, Controls, PngImageList, CComponents, VirtualTrees, StdCtrls,
     ExtCtrls, CDatabase, CDataobjectFormUnit, CImageListsUnit, Dialogs;

type
  TCQuickpatternFrame = class(TCDataobjectFrame)
  protected
    function GetSelectedType: Integer; override;
    function IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean; override;
  public
    class function GetTitle: String; override;
    procedure ReloadDataobjects; override;
    class function GetDataobjectClass(AOption: Integer): TDataObjectClass; override;
    class function GetDataobjectProxy(AOption: Integer): TDataProxy; override;
    function GetDataobjectForm(AOption: Integer): TCDataobjectFormClass; override;
  end;

implementation

uses CDataObjects, CQuickpatternFormUnit, CPluginConsts, CBaseFrameUnit,
  CDatatools, CTools, CFrameFormUnit;

{$R *.dfm}

class function TCQuickpatternFrame.GetDataobjectClass(AOption: Integer): TDataObjectClass;
begin
  Result := TQuickPattern;
end;

function TCQuickpatternFrame.GetDataobjectForm(AOption: Integer): TCDataobjectFormClass;
begin
  Result := TCQuickpatternForm;
end;

class function TCQuickpatternFrame.GetDataobjectProxy(AOption: Integer): TDataProxy;
begin
  Result := QuickPatternProxy;
end;

function TCQuickpatternFrame.GetSelectedType: Integer;
begin
  if List.FocusedNode <> Nil then begin
    Result := CSELECTEDITEM_QUICKPATTERN;
  end else begin
    Result := CSELECTEDITEM_INCORRECT;
  end;
end;

class function TCQuickpatternFrame.GetTitle: String;
begin
  Result := 'Szybkie operacje';
end;

function TCQuickpatternFrame.IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean;
begin
  Result := (APluginSelectedItemTypes and CSELECTEDITEM_QUICKPATTERN) = CSELECTEDITEM_QUICKPATTERN;
end;

procedure TCQuickpatternFrame.ReloadDataobjects;
begin
  inherited ReloadDataobjects;
  Dataobjects := TProfile.GetList(TProfile, ProfileProxy, 'select * from quickPattern');
end;

end.
