unit CInvestmentMovementFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFrameUnit, ActnList, VTHeaderPopup, Menus, ImgList,
  PngImageList, CComponents, VirtualTrees, StdCtrls, ExtCtrls, CDatabase,
  CDataObjectFormUnit;

type
  TCInvestmentMovementFrame = class(TCDataobjectFrame)
  protected
    function IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean; override;
    function GetSelectedType: Integer; override;
  public
    class function GetTitle: String; override;
    function IsValidFilteredObject(AObject: TDataObject): Boolean; override;
    procedure ReloadDataobjects; override;
    function GetStaticFilter: TStringList; override;
    class function GetDataobjectClass(AOption: Integer): TDataObjectClass; override;
    class function GetDataobjectProxy(AOption: Integer): TDataProxy; override;
    function GetDataobjectForm(AOption: Integer): TCDataobjectFormClass; override;
    function GetHistoryText: String; override;
    procedure ShowHistory(AGid: ShortString); override;
  end;

implementation

uses CDataObjects, CInvestmentMovementFormUnit, CPluginConsts;

{$R *.dfm}

{ TCInvestmentMovementFrame }

class function TCInvestmentMovementFrame.GetDataobjectClass(AOption: Integer): TDataObjectClass;
begin
  Result := TInvestmentMovement;
end;

function TCInvestmentMovementFrame.GetDataobjectForm(AOption: Integer): TCDataobjectFormClass;
begin
  Result := TCInvestmentMovementForm;
end;

class function TCInvestmentMovementFrame.GetDataobjectProxy(AOption: Integer): TDataProxy;
begin
  Result := InvestmentMovementProxy;
end;

function TCInvestmentMovementFrame.GetHistoryText: String;
begin
end;

function TCInvestmentMovementFrame.GetSelectedType: Integer;
begin
  if List.FocusedNode <> Nil then begin
    Result := CSELECTEDITEM_INVESTMENTMOVEMENT;
  end else begin
    Result := CSELECTEDITEM_INCORRECT;
  end;
end;

function TCInvestmentMovementFrame.GetStaticFilter: TStringList;
begin
  Result := Nil;
end;

class function TCInvestmentMovementFrame.GetTitle: String;
begin
  Result := 'Inwestycje';
end;

function TCInvestmentMovementFrame.IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean;
begin
  Result := (APluginSelectedItemTypes and CSELECTEDITEM_INVESTMENTMOVEMENT) = CSELECTEDITEM_INVESTMENTMOVEMENT;
end;

function TCInvestmentMovementFrame.IsValidFilteredObject(AObject: TDataObject): Boolean;
begin
  Result := (inherited IsValidFilteredObject(AObject));
end;

procedure TCInvestmentMovementFrame.ReloadDataobjects;
begin
end;

procedure TCInvestmentMovementFrame.ShowHistory(AGid: ShortString);
begin
end;

end.
 