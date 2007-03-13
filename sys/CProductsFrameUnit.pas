unit CProductsFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, ImgList, ExtCtrls, VirtualTrees, Menus,
  VTHeaderPopup, ActnList, CComponents, CDatabase, Contnrs, GraphUtil,
  StdCtrls, PngImageList, CImageListsUnit;

type
  TProductsFrameAdditionalData = class(TObject)
  private
    FproductType: String;
  public
    constructor Create(AType: String);
  published
    property productType: String read FproductType;
  end;

  TCProductsFrame = class(TCBaseFrame)
    ProductList: TVirtualStringTree;
    ActionList: TActionList;
    ActionAddSubCategory: TAction;
    ActionEditCategory: TAction;
    ActionDelCategory: TAction;
    VTHeaderPopupMenu: TVTHeaderPopupMenu;
    ActionAddRootCategory: TAction;
    PanelFrameButtons: TPanel;
    CButtonAddCategory: TCButton;
    CButtonAddSubcategory: TCButton;
    CButtonEditCategory: TCButton;
    CButtonDelCategory: TCButton;
    procedure ProductListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure ProductListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure ProductListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure ProductListInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
    procedure ProductListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure ProductListHeaderClick(Sender: TVTHeader; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ProductListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
    procedure ProductListBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
    procedure ProductListDblClick(Sender: TObject);
    procedure ProductListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure ActionAddRootCategoryExecute(Sender: TObject);
    procedure ActionEditCategoryExecute(Sender: TObject);
    procedure ActionDelCategoryExecute(Sender: TObject);
    procedure ActionAddSubCategoryExecute(Sender: TObject);
  private
    FProductObjects: TDataObjectList;
    FTreeHelper: TTreeObjectList;
    procedure ReloadProducts;
    procedure RecreateTreeHelper;
    procedure MessageCashpointAdded(AId: TDataGid);
    procedure MessageCashpointEdited(AId: TDataGid);
    procedure MessageCashpointDeleted(AId: TDataGid);
  protected
    procedure WndProc(var Message: TMessage); override;
    function GetSelectedId: TDataGid; override;
    function GetSelectedText: String; override;
  public
    function GetList: TVirtualStringTree; override;
    procedure InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList); override;
    destructor Destroy; override;
    class function GetTitle: String; override;
    function FindNode(ADataId: ShortString; AList: TVirtualStringTree): PVirtualNode; override;
    function FindNodeId(ANode: PVirtualNode): ShortString; override;
  end;

implementation

uses CDataObjects, CFrameFormUnit, CProductFormUnit, CConfigFormUnit,
  CInfoFormUnit, CConsts;

{$R *.dfm}

procedure TCProductsFrame.ReloadProducts;
var xWhere: String;
begin
  ProductList.BeginUpdate;
  ProductList.Clear;
  if FProductObjects <> Nil then begin
    FreeAndNil(FProductObjects);
  end;
  if Assigned(AdditionalData) then begin
    xWhere := 'where productType = ''' + TProductsFrameAdditionalData(AdditionalData).productType + '''';
  end else begin
    xWhere := '';
  end;
  FProductObjects := TDataObject.GetList(TProduct, ProductProxy, 'select * from product ' + xWhere + ' order by created, idParentProduct');
  RecreateTreeHelper;
  ProductList.RootNodeCount := FTreeHelper.Count;
  ProductList.EndUpdate;
  ProductListFocusChanged(ProductList, ProductList.FocusedNode, 0);
end;

procedure TCProductsFrame.ProductListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
begin
  CButtonEditCategory.Enabled := Node <> Nil;
  CButtonDelCategory.Enabled := Node <> Nil;
  CButtonAddSubcategory.Enabled := Node <> Nil;
  if Owner.InheritsFrom(TCFrameForm) then begin
    TCFrameForm(Owner).BitBtnOk.Enabled := (Node <> Nil) or (MultipleChecks <> Nil);
  end;
end;

procedure TCProductsFrame.RecreateTreeHelper;
var xCount: Integer;
    xDataobject: TProduct;
    xTreeObject: TTreeObject;
    xParentTreeObject: TTreeObject;
begin
  for xCount := 0 to FProductObjects.Count - 1 do begin
    xDataobject := TProduct(FProductObjects.Items[xCount]);
    xTreeObject := TTreeObject.Create;
    xTreeObject.Dataobject := xDataobject;
    if xDataobject.idParentProduct = CEmptyDataGid then begin
      xParentTreeObject := Nil;
    end else begin
      xParentTreeObject := FTreeHelper.FindDataId(xDataobject.idParentProduct, FTreeHelper);
    end;
    if xParentTreeObject <> Nil then begin
      xParentTreeObject.Childobjects.Add(xTreeObject);
    end else begin
      FTreeHelper.Add(xTreeObject);
    end;
  end;
end;

destructor TCProductsFrame.Destroy;
begin
  FTreeHelper.Free;
  FProductObjects.Free;
  inherited Destroy;
end;

class function TCProductsFrame.GetTitle: String;
begin
  Result := 'Kategorie';
end;

procedure TCProductsFrame.InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList);
begin
  inherited InitializeFrame(AOwner, AAdditionalData, AOutputData, AMultipleCheck);
  FTreeHelper := TTreeObjectList.Create(True);
  ReloadProducts;
end;

procedure TCProductsFrame.ProductListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var xTreeList: TTreeObjectList;
    xTreeObject: TTreeObject;
begin
  if ParentNode = Nil then begin
    xTreeList := FTreeHelper;
  end else begin
    xTreeList := TTreeObject(ProductList.GetNodeData(ParentNode)^).Childobjects;
  end;
  xTreeObject := xTreeList.Items[Node.Index];
  TTreeObject(ProductList.GetNodeData(Node)^) := xTreeObject;
  if xTreeObject.Childobjects.Count > 0 then begin
    InitialStates := InitialStates + [ivsHasChildren, ivsExpanded];
  end;
  if MultipleChecks <> Nil then begin
    Node.CheckType := ctCheckBox;
    Node.CheckState := csCheckedNormal;
  end;
end;

procedure TCProductsFrame.ProductListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TTreeObject);
end;

procedure TCProductsFrame.ProductListInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
var xData: TTreeObject;
begin
  xData := TTreeObject(ProductList.GetNodeData(Node)^);
  ChildCount := xData.Childobjects.Count;
end;

procedure TCProductsFrame.ProductListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var xData: TTreeObject;
begin
  xData := TTreeObject(ProductList.GetNodeData(Node)^);
  CellText := TProduct(xData.Dataobject).name;
end;

procedure TCProductsFrame.ProductListHeaderClick(Sender: TVTHeader; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then begin
    with Sender do begin
      if SortColumn <> Column then begin
        SortColumn := Column;
        SortDirection := sdAscending;
      end else begin
        case SortDirection of
          sdAscending: SortDirection := sdDescending;
          sdDescending: SortDirection := sdAscending;
        end;
      end;
    end;
  end;
end;

procedure TCProductsFrame.ProductListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
var xData: TTreeObject;
begin
  xData := TTreeObject(ProductList.GetNodeData(Node)^);
  HintText := TProduct(xData.Dataobject).description;
  LineBreakStyle := hlbForceMultiLine;
end;

procedure TCProductsFrame.ProductListBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
begin
  with TargetCanvas do begin
    if not Odd(Sender.AbsoluteIndex(Node)) then begin
      ItemColor := clWindow;
    end else begin
      ItemColor := GetHighLightColor(clWindow, -10);
    end;
    EraseAction := eaColor;
  end;
end;

procedure TCProductsFrame.ProductListDblClick(Sender: TObject);
begin
  if ProductList.FocusedNode <> Nil then begin
    if Owner.InheritsFrom(TCFrameForm) then begin
      TCFrameForm(Owner).BitBtnOkClick(Nil);
    end else begin
      ActionEditCategory.Execute;
    end;
  end;
end;

procedure TCProductsFrame.ProductListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var xData1: TTreeObject;
    xData2: TTreeObject;
begin
  xData1 := TTreeObject(ProductList.GetNodeData(Node1)^);
  xData2 := TTreeObject(ProductList.GetNodeData(Node2)^);
  Result := AnsiCompareText(TProduct(xData1.Dataobject).name, TProduct(xData2.Dataobject).name);
end;

function TCProductsFrame.GetList: TVirtualStringTree;
begin
  Result := ProductList;
end;

function TCProductsFrame.GetSelectedId: TDataGid;
begin
  Result := '';
  if ProductList.FocusedNode <> Nil then begin
    Result := TProduct(TTreeObject(ProductList.GetNodeData(ProductList.FocusedNode)^).Dataobject).id;
  end;
end;

function TCProductsFrame.GetSelectedText: String;
begin
  Result := '';
  if ProductList.FocusedNode <> Nil then begin
    Result := TProduct(TTreeObject(ProductList.GetNodeData(ProductList.FocusedNode)^).Dataobject).name;
  end;
end;

procedure TCProductsFrame.ActionAddRootCategoryExecute(Sender: TObject);
var xForm: TCProductForm;
    xAdditional: TCProductAdditionalData;
begin
  xForm := TCProductForm.Create(Nil);
  if Assigned(AdditionalData) then begin
    xAdditional := TCProductAdditionalData.Create('', TProductsFrameAdditionalData(AdditionalData).productType);
  end else begin
    xAdditional := Nil;
  end;
  xForm.ShowDataobject(coAdd, ProductProxy, Nil, True, xAdditional);
  xForm.Free;
end;

procedure TCProductsFrame.WndProc(var Message: TMessage);
var xDataGid: TDataGid;
    xParentGid: TDataGid;
begin
  inherited WndProc(Message);
  with Message do begin
    if Msg = WM_DATAOBJECTADDED then begin
      xDataGid := PDataGid(WParam)^;
      if LParam <> 0 then begin
        xParentGid := PDataGid(LParam)^;
      end else begin
        xParentGid := '';
      end;
      MessageCashpointAdded(xDataGid);
    end else if Msg = WM_DATAOBJECTEDITED then begin
      xDataGid := PDataGid(WParam)^;
      MessageCashpointEdited(xDataGid);
    end else if Msg = WM_DATAOBJECTDELETED then begin
      xDataGid := PDataGid(WParam)^;
      MessageCashpointDeleted(xDataGid);
    end;
  end;
end;

procedure TCProductsFrame.MessageCashpointAdded(AId: TDataGid);
var xDataobject: TProduct;
    xNode: PVirtualNode;
    xParent: PVirtualNode;
    xTreeobject: TTreeObject;
    xParentTree: TTreeObject;
begin
  xDataobject := TProduct(TProduct.LoadObject(ProductProxy, AId, True));
  FProductObjects.Add(xDataobject);
  xTreeobject := TTreeObject.Create;
  xTreeobject.Dataobject := xDataobject;
  if xDataobject.idParentProduct <> CEmptyDataGid then begin
    xParent := FindTreeobjectNode(xDataobject.idParentProduct, ProductList);
    xParentTree := FTreeHelper.FindDataId(xDataobject.idParentProduct, FTreeHelper);
    xParentTree.Childobjects.Add(xTreeobject);
  end else begin
    FTreeHelper.Add(xTreeobject);
    xParent := Nil;
  end;
  xNode := ProductList.AddChild(xParent, xDataobject);
  ProductList.Sort(xNode, ProductList.Header.SortColumn, ProductList.Header.SortDirection);
  ProductList.FocusedNode := xNode;
  ProductList.Selected[xNode] := True;
end;

procedure TCProductsFrame.MessageCashpointDeleted(AId: TDataGid);
var xNode: PVirtualNode;
    xTree, xParentTree: TTreeObject;
begin
  xNode := FindTreeobjectNode(AId, ProductList);
  if xNode <> Nil then begin
    ProductList.BeginUpdate;
    xTree := FTreeHelper.FindDataId(AId, FTreeHelper);
    if TProduct(xTree.Dataobject).idParentProduct <> CEmptyDataGid then begin
      xParentTree := FTreeHelper.FindDataId(TProduct(xTree.Dataobject).idParentProduct, FTreeHelper);
      xParentTree.Childobjects.Remove(xTree);
    end else begin
      FTreeHelper.Remove(xTree);
    end;
    FProductObjects.Remove(TProduct(ProductList.GetNodeData(xNode)^));
    ProductList.DeleteNode(xNode);
    ProductList.EndUpdate;
  end;
end;

procedure TCProductsFrame.MessageCashpointEdited(AId: TDataGid);
var xDataobject: TProduct;
    xNode: PVirtualNode;
begin
  xNode := FindTreeobjectNode(AId, ProductList);
  if xNode <> Nil then begin
    xDataobject := TProduct(TTreeObject(ProductList.GetNodeData(xNode)^).Dataobject);
    xDataobject.ReloadObject;
    ProductList.InvalidateNode(xNode);
    ProductList.Sort(xNode, ProductList.Header.SortColumn, ProductList.Header.SortDirection);
  end;
end;

procedure TCProductsFrame.ActionEditCategoryExecute(Sender: TObject);
var xForm: TCProductForm;
    xParentGid: TDataGid;
begin
  xForm := TCProductForm.Create(Nil);
  xParentGid := TProduct(TTreeObject(ProductList.GetNodeData(ProductList.FocusedNode)^).Dataobject).idParentProduct;
  xForm.ShowDataobject(coEdit, ProductProxy, TTreeObject(ProductList.GetNodeData(ProductList.FocusedNode)^).Dataobject, True, TCProductAdditionalData.Create(xParentGid, ''));
  xForm.Free;
end;

procedure TCProductsFrame.ActionDelCategoryExecute(Sender: TObject);
var xData: TDataObject;
    xBase: TDataObject;
begin
  xBase := TTreeObject(ProductList.GetNodeData(ProductList.FocusedNode)^).Dataobject;
  if TProduct.CanBeDeleted(xBase.id) then begin
    if ShowInfo(itQuestion, 'Czy chcesz usun¹æ kategoriê o nazwie "' + TProduct(xBase).name + '" ?', '') then begin
      xData := TProduct.LoadObject(ProductProxy, xBase.id, False);
      xData.DeleteObject;
      GDataProvider.CommitTransaction;
      SendMessageToFrames(TCProductsFrame, WM_DATAOBJECTDELETED, Integer(@xBase.id), 0);
    end;
  end;
end;

procedure TCProductsFrame.ActionAddSubCategoryExecute(Sender: TObject);
var xForm: TCProductForm;
    xParentGid: TDataGid;
begin
  xForm := TCProductForm.Create(Nil);
  xParentGid := TProduct(TTreeObject(ProductList.GetNodeData(ProductList.FocusedNode)^).Dataobject).id;
  xForm.ShowDataobject(coAdd, ProductProxy, Nil, True, TCProductAdditionalData.Create(xParentGid, ''));
  xForm.Free;
end;

constructor TProductsFrameAdditionalData.Create(AType: String);
begin
  inherited Create;
  FproductType := AType;
end;

function TCProductsFrame.FindNode(ADataId: ShortString; AList: TVirtualStringTree): PVirtualNode;
begin
  Result := FindTreeobjectNode(ADataId, AList);
end;

function TCProductsFrame.FindNodeId(ANode: PVirtualNode): ShortString;
var xData: TTreeObject;
begin
  xData := TTreeObject(ProductList.GetNodeData(ANode)^);
  Result := TProduct(xData.Dataobject).id;
end;

end.
