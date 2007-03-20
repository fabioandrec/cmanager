unit CLimitsFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, Menus, ImgList, PngImageList, CComponents,
  ExtCtrls, VirtualTrees, ActnList, VTHeaderPopup, CDataobjectFrameUnit, CDatabase,
  CDataObjectFormUnit, StdCtrls, CImageListsUnit;

type
  TCLimitsFrame = class(TCDataobjectFrame)
  public
    procedure ReloadDataobjects; override;
    function GetDataobjectClass(AOption: Integer): TDataObjectClass; override;
    function GetDataobjectProxy(AOption: Integer): TDataProxy; override;
    function GetDataobjectForm(AOption: Integer): TCDataobjectFormClass; override;
    function GetStaticFilter: TStringList; override;
    function IsValidFilteredObject(AObject: TDataObject): Boolean; override;
  end;

implementation

uses CDataObjects, CDatatools, CCashpointFormUnit, CLimitFormUnit, CConsts;

{$R *.dfm}

function TCLimitsFrame.GetDataobjectClass(AOption: Integer): TDataObjectClass;
begin
  Result := TMovementLimit;
end;

function TCLimitsFrame.GetDataobjectForm(AOption: Integer): TCDataobjectFormClass;
begin
  Result := TCLimitForm;
end;

function TCLimitsFrame.GetDataobjectProxy(AOption: Integer): TDataProxy;
begin
  Result := MovementLimitProxy;
end;

function TCLimitsFrame.GetStaticFilter: TStringList;
begin
  Result := TStringList.Create;
  with Result do begin
    Add(CFilterAllElements + '=<wszystkie elementy>');
    Add(CLimitActive + '=<aktywne>');
    Add(CLimitDisabled + '=<wy³¹czone>');
  end;
end;

function TCLimitsFrame.IsValidFilteredObject(AObject: TDataObject): Boolean;
begin
  Result := inherited IsValidFilteredObject(AObject) or (IntToStr(Integer(TMovementLimit(AObject).isActive)) = CStaticFilter.DataId); 
end;

procedure TCLimitsFrame.ReloadDataobjects;
var xCondition: String;
begin
  inherited ReloadDataobjects;
  if CStaticFilter.DataId = CFilterAllElements then begin
    xCondition := '';
  end else if CStaticFilter.DataId = CLimitActive then begin
    xCondition := ' where isActive = 1'
  end else if CStaticFilter.DataId = CLimitDisabled then begin
    xCondition := ' where isActive = 0'
  end;
  Dataobjects := TMovementLimit.GetList(TMovementLimit, MovementLimitProxy, 'select * from movementLimit' + xCondition);
end;


end.
