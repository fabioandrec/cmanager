unit CDepositInvestmentFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFrameUnit, ActnList, VTHeaderPopup, Menus, ImgList,
  PngImageList, CComponents, VirtualTrees, StdCtrls, ExtCtrls, CImageListsUnit, CDatabase, CDataObjects,
  CDataobjectFormUnit;

type
  TCDepositInvestmentFrame = class(TCDataobjectFrame)
  protected
    function IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean; override;
    function GetSelectedType: Integer; override;
  public
    class function GetTitle: String; override;
    function GetStaticFilter: TStringList; override;
    class function GetDataobjectClass(AOption: Integer): TDataObjectClass; override;
    class function GetDataobjectProxy(AOption: Integer): TDataProxy; override;
    function GetDataobjectForm(AOption: Integer): TCDataobjectFormClass; override;
    function IsValidFilteredObject(AObject: TDataObject): Boolean; override;
    procedure ReloadDataobjects; override;
  end;

implementation

uses CPluginConsts, CConsts, CDepositInvestmentFormUnit;

{$R *.dfm}

class function TCDepositInvestmentFrame.GetDataobjectClass(AOption: Integer): TDataObjectClass;
begin
  Result := TDepositInvestment;
end;

function TCDepositInvestmentFrame.GetDataobjectForm(AOption: Integer): TCDataobjectFormClass;
begin
  Result := TCDepositInvestmentForm;
end;

class function TCDepositInvestmentFrame.GetDataobjectProxy(AOption: Integer): TDataProxy;
begin
  Result := DepositInvestmentProxy;
end;

function TCDepositInvestmentFrame.GetSelectedType: Integer;
begin
  if List.FocusedNode <> Nil then begin
    Result := CSELECTEDITEM_DEPOSITINVESTMENT;
  end else begin
    Result := CSELECTEDITEM_INCORRECT;
  end;
end;

function TCDepositInvestmentFrame.GetStaticFilter: TStringList;
begin
  Result := TStringList.Create;
  with Result do begin
    Add(CFilterAllElements + '=<wszystkie elementy>');
    Add(CDepositInvestmentActive + '=<aktywne>');
    Add(CDepositInvestmentClosed + '=<zamkniêta>');
    Add(CDepositInvestmentInactive + '=<nieaktywne>');
  end;
end;

class function TCDepositInvestmentFrame.GetTitle: String;
begin
  Result := 'Lokaty';
end;

function TCDepositInvestmentFrame.IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean;
begin
  Result := (APluginSelectedItemTypes and CSELECTEDITEM_DEPOSITINVESTMENT) = CSELECTEDITEM_DEPOSITINVESTMENT;
end;

function TCDepositInvestmentFrame.IsValidFilteredObject(AObject: TDataObject): Boolean;
begin
  Result := (inherited IsValidFilteredObject(AObject)) or
            (TDepositInvestment(AObject).depositState = CStaticFilter.DataId);
end;

procedure TCDepositInvestmentFrame.ReloadDataobjects;
var xCondition: String;
begin
  inherited ReloadDataobjects;
  if CStaticFilter.DataId = CFilterAllElements then begin
    xCondition := '';
  end else begin
    xCondition := ' where depositState = ''' + CStaticFilter.DataId + '''';
  end;
  Dataobjects := TDepositInvestment.GetList(TDepositInvestment, DepositInvestmentProxy, 'select * from depositInvestment' + xCondition);
end;

end.
 