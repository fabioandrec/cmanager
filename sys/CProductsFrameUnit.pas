unit CProductsFrameUnit;

interface

uses CDataobjectFrameUnit, Classes, ActnList, VTHeaderPopup, Menus,
     ImgList, Controls, PngImageList, CComponents, VirtualTrees, StdCtrls,
     ExtCtrls, CDatabase, CDataobjectFormUnit, CImageListsUnit, Dialogs;

type
  TCProductsFrame = class(TCDataobjectFrame)
    CButtonAddSubcategory: TCButton;
    ActionAddSubcategory: TAction;
    procedure ActionAddSubcategoryExecute(Sender: TObject);
  protected
    function IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean; override;
    function GetSelectedType: Integer; override;
  public
    procedure UpdateButtons(AIsSelectedSomething: Boolean); override;
    class function GetTitle: String; override;
    function GetStaticFilter: TStringList; override;
    function IsValidFilteredObject(AObject: TDataObject): Boolean; override;
    procedure ReloadDataobjects; override;
    procedure RecreateTreeHelper; override;
    class function GetDataobjectClass(AOption: Integer): TDataObjectClass; override;
    class function GetDataobjectProxy(AOption: Integer): TDataProxy; override;
    function GetDataobjectForm(AOption: Integer): TCDataobjectFormClass; override;
    function GetDataobjectParent(ADataobject: TDataObject): TCListDataElement; override;
    function GetHistoryText: String; override;
    procedure ShowHistory(AGid: ShortString); override;
  end;

implementation

uses CDataObjects, CProductFormUnit, CConsts, CConfigFormUnit, CReports,
  CPluginConsts, CTools, CBaseFrameUnit;

{$R *.dfm}

class function TCProductsFrame.GetDataobjectClass(AOption: Integer): TDataObjectClass;
begin
  Result := TProduct;
end;

function TCProductsFrame.GetDataobjectForm(AOption: Integer): TCDataobjectFormClass;
begin
  Result := TCProductForm;
end;

class function TCProductsFrame.GetDataobjectProxy(AOption: Integer): TDataProxy;
begin
  Result := ProductProxy;
end;

function TCProductsFrame.GetStaticFilter: TStringList;
begin
  Result := TStringList.Create;
  with Result do begin
    Add(CFilterAllElements + '=<wszystkie elementy>');
    Add(COutProduct + '=<kategorie rozchodów>');
    Add(CInProduct + '=<kategorie przychodów>');
  end;
end;

class function TCProductsFrame.GetTitle: String;
begin
  Result := 'Kategorie';
end;

function TCProductsFrame.IsValidFilteredObject(AObject: TDataObject): Boolean;
begin
  Result := inherited IsValidFilteredObject(AObject) or (TProduct(AObject).productType = CStaticFilter.DataId); 
end;

procedure TCProductsFrame.RecreateTreeHelper;
var xCount: Integer;
    xDataobject: TProduct;
    xElement, xParent: TCListDataElement;
begin
  for xCount := 0 to Dataobjects.Count - 1 do begin
    xDataobject := TProduct(Dataobjects.Items[xCount]);
    xElement := TCListDataElement.Create(MultipleChecks <> Nil, List, xDataobject);
    if xDataobject.idParentProduct = CEmptyDataGid then begin
      xParent := List.RootElement;
    end else begin
      xParent := List.RootElement.FindDataElement(xDataobject.idParentProduct, xDataobject.ClassName, True);
    end;
    xParent.Add(xElement);
  end;
end;

procedure TCProductsFrame.ReloadDataobjects;
var xCondition: String;
begin
  inherited ReloadDataobjects;
  if CStaticFilter.DataId = CFilterAllElements then begin
    xCondition := '';
  end else if CStaticFilter.DataId = CInProduct then begin
    xCondition := ' where productType = ''' + CInProduct + '''';
  end else if CStaticFilter.DataId = COutProduct then begin
    xCondition := ' where productType = ''' + COutProduct + '''';
  end;
  Dataobjects := TDataObject.GetList(TProduct, ProductProxy, 'select * from product ' + xCondition + ' order by created, idParentProduct');
end;

procedure TCProductsFrame.ActionAddSubcategoryExecute(Sender: TObject);
var xForm: TCProductForm;
begin
  xForm := TCProductForm.Create(Nil);
  xForm.ShowDataobject(coAdd, ProductProxy, Nil, True, TCProductAdditionalData.Create(List.SelectedId, ''));
  xForm.Free;
end;

procedure TCProductsFrame.UpdateButtons(AIsSelectedSomething: Boolean);
begin
  inherited UpdateButtons(AIsSelectedSomething);
  ActionAddSubcategory.Enabled := AIsSelectedSomething;
end;

function TCProductsFrame.GetDataobjectParent(ADataobject: TDataObject): TCListDataElement;
begin
  Result := inherited GetDataobjectParent(ADataobject);
  if TProduct(ADataobject).idParentProduct <> CEmptyDataGid then begin
    Result := List.RootElement.FindDataElement(TProduct(ADataobject).idParentProduct, ADataobject.ClassName);
  end;
end;

function TCProductsFrame.GetHistoryText: String;
begin
  Result := 'Historia kategorii'
end;

procedure TCProductsFrame.ShowHistory(AGid: ShortString);
var xReport: TCPHistoryReport;
    xParams: TCReportParams;
begin
  xParams := TCWithGidParams.Create(AGid);
  xParams.acp := CGroupByProduct;
  xReport := TCPHistoryReport.CreateReport(xParams);
  xReport.ShowReport;
  xReport.Free;
  xParams.Free;
end;

function TCProductsFrame.GetSelectedType: Integer;
begin
  Result := CSELECTEDITEM_PRODUCT;
end;

function TCProductsFrame.IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean;
begin
  Result := (APluginSelectedItemTypes and CSELECTEDITEM_PRODUCT) = CSELECTEDITEM_PRODUCT;
end;

end.
