unit CExtractionItemFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFrameUnit, ActnList, VTHeaderPopup, Menus, ImgList,
  PngImageList, CComponents, VirtualTrees, StdCtrls, ExtCtrls, CDatabase,
  CDataobjectFormUnit, CImageListsUnit;

type
  TCExtractionItemFrameData = class(TCDataobjectFrameData)
  private
    FidAccountExtraction: TDataGid;
  published
    property idAccountExtraction: TDataGid read FidAccountExtraction write FidAccountExtraction;
  end;

  TCExtractionItemFrame = class(TCDataobjectFrame)
  protected
    function GetSelectedType: Integer; override;
    function IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean; override;
  public
    procedure ReloadDataobjects; override;
    class function GetTitle: String; override;
    function GetDataobjectClass(AOption: Integer): TDataObjectClass; override;
    function GetDataobjectProxy(AOption: Integer): TDataProxy; override;
    class function GetPrefname: String; override;
    procedure InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean); override;
  end;

implementation

uses CDataObjects, CPluginConsts, CTools, CBaseFrameUnit;

{$R *.dfm}

function TCExtractionItemFrame.GetDataobjectClass(AOption: Integer): TDataObjectClass;
begin
  Result := TExtractionItem;
end;

function TCExtractionItemFrame.GetDataobjectProxy(AOption: Integer): TDataProxy;
begin
  Result := ExtractionItemProxy;
end;

class function TCExtractionItemFrame.GetPrefname: String;
begin
  Result := 'ExtractionItem';
end;

function TCExtractionItemFrame.GetSelectedType: Integer;
begin
  if List.FocusedNode <> Nil then begin
    Result := CSELECTEDITEM_EXTRACTIONITEM;
  end else begin
    Result := CSELECTEDITEM_INCORRECT;
  end;
end;

class function TCExtractionItemFrame.GetTitle: String;
begin
  Result := 'Operacje wyci¹gu';
end;

procedure TCExtractionItemFrame.InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean);
begin
  inherited InitializeFrame(AOwner, AAdditionalData, AOutputData, AMultipleCheck, False);
end;

function TCExtractionItemFrame.IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean;
begin
  Result := (APluginSelectedItemTypes and CSELECTEDITEM_EXTRACTIONITEM) = CSELECTEDITEM_EXTRACTIONITEM;
end;

procedure TCExtractionItemFrame.ReloadDataobjects;
var xCondition: String;
begin
  inherited ReloadDataobjects;
  if (AdditionalData <> Nil) then begin
    if xCondition = '' then begin
      xCondition := ' where idAccountExtraction = ' + DataGidToDatabase(TCExtractionItemFrameData(AdditionalData).idAccountExtraction);
    end;
  end;
  Dataobjects := TDataObject.GetList(TExtractionItem, ExtractionItemProxy, 'select * from extractionItem' + xCondition);
end;

end.
