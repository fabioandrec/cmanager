unit CFilterFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, VirtualTrees, Buttons, CDatabase, ImgList,
  CComponents, ActnList, ExtCtrls, Menus, VTHeaderPopup, PngImageList,
  CImageListsUnit;

type
  TCFilterFrame = class(TCBaseFrame)
    ActionList: TActionList;
    ActionAddFilter: TAction;
    ActionEditFilter: TAction;
    ActionDelFilter: TAction;
    FilterList: TCList;
    VTHeaderPopupMenu: TVTHeaderPopupMenu;
    PanelFrameButtons: TPanel;
    CButtonAddFilter: TCButton;
    CButtonEditFilter: TCButton;
    CButtonDelFilter: TCButton;
    procedure ActionAddFilterExecute(Sender: TObject);
    procedure ActionEditFilterExecute(Sender: TObject);
    procedure ActionDelFilterExecute(Sender: TObject);
    procedure FilterListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure FilterListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure FilterListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure FilterListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure FilterListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure FilterListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
    procedure FilterListDblClick(Sender: TObject);
  private
    FFilterObjects: TDataObjectList;
    procedure ReloadFilters;
    procedure MessageFilterAdded(AId: TDataGid);
    procedure MessageFilterEdited(AId: TDataGid);
    procedure MessageFilterDeleted(AId: TDataGid);
  protected
    procedure WndProc(var Message: TMessage); override;
    function GetSelectedId: TDataGid; override;
    function GetSelectedText: String; override;
  public
    function GetList: TCList; override;
    procedure InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList); override;
    destructor Destroy; override;
    class function GetTitle: String; override;
  end;

implementation

uses CDataObjects, CFilterFormUnit, CConfigFormUnit, CFrameFormUnit, CMainFormUnit,
     CInfoFormUnit, GraphUtil, CConsts;

{$R *.dfm}

destructor TCFilterFrame.Destroy;
begin
  FFilterObjects.Free;
  inherited Destroy;
end;

class function TCFilterFrame.GetTitle: String;
begin
  Result := 'Filtry';
end;

procedure TCFilterFrame.InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList);
begin
  inherited InitializeFrame(AOwner, AAdditionalData, AOutputData, AMultipleCheck);
  ReloadFilters;
end;

procedure TCFilterFrame.ReloadFilters;
begin
  FilterList.BeginUpdate;
  FilterList.Clear;
  if FFilterObjects <> Nil then begin
    FreeAndNil(FFilterObjects);
  end;
  FFilterObjects := TDataObject.GetList(TMovementFilter, MovementFilterProxy, 'select * from movementFilter');
  FilterList.RootNodeCount := FFilterObjects.Count;
  FilterList.EndUpdate;
  FilterListFocusChanged(FilterList, FilterList.FocusedNode, 0);
end;

procedure TCFilterFrame.ActionAddFilterExecute(Sender: TObject);
var xForm: TCFilterForm;
begin
  xForm := TCFilterForm.Create(Nil);
  xForm.ShowDataobject(coAdd, MovementFilterProxy, Nil, True);
  xForm.Free;
end;

procedure TCFilterFrame.FilterListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  TDataObject(FilterList.GetNodeData(Node)^) := FFilterObjects.Items[Node.Index];
  if MultipleChecks <> Nil then begin
    Node.CheckType := ctCheckBox;
    Node.CheckState := csCheckedNormal;
  end;
end;

procedure TCFilterFrame.FilterListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TDataObject);
end;

procedure TCFilterFrame.FilterListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var xData: TMovementFilter;
begin
  xData := TMovementFilter(FilterList.GetNodeData(Node)^);
  CellText := xData.name;
end;

procedure TCFilterFrame.ActionEditFilterExecute(Sender: TObject);
var xForm: TCFilterForm;
begin
  xForm := TCFilterForm.Create(Nil);
  xForm.ShowDataobject(coEdit, MovementFilterProxy, TMovementFilter(FilterList.GetNodeData(FilterList.FocusedNode)^), True);
  xForm.Free;
end;

procedure TCFilterFrame.FilterListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
begin
  CButtonEditFilter.Enabled := Node <> Nil;
  CButtonDelFilter.Enabled := Node <> Nil;
  if Owner.InheritsFrom(TCFrameForm) then begin
    TCFrameForm(Owner).BitBtnOk.Enabled := (Node <> Nil) or (MultipleChecks <> Nil);
  end;
end;

procedure TCFilterFrame.FilterListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var xData1: TMovementFilter;
    xData2: TMovementFilter;
begin
  xData1 := TMovementFilter(FilterList.GetNodeData(Node1)^);
  xData2 := TMovementFilter(FilterList.GetNodeData(Node2)^);
  Result := AnsiCompareText(xData1.name, xData2.name);
end;

procedure TCFilterFrame.ActionDelFilterExecute(Sender: TObject);
var xData: TDataObject;
    xBase: TDataObject;
begin
  xBase := TDataObject(FilterList.GetNodeData(FilterList.FocusedNode)^);
  if TMovementFilter.CanBeDeleted(xBase.id) then begin
    if ShowInfo(itQuestion, 'Czy chcesz usun¹æ filtr o nazwie "' + TMovementFilter(xBase).name + '" ?', '') then begin
      xData := TMovementFilter.LoadObject(MovementFilterProxy, xBase.id, False);
      xData.DeleteObject;
      GDataProvider.CommitTransaction;
      SendMessageToFrames(TCFilterFrame, WM_DATAOBJECTDELETED, Integer(@xBase.id), 0);
    end;
  end;
end;

procedure TCFilterFrame.FilterListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
var xData: TMovementFilter;
begin
  xData := TMovementFilter(FilterList.GetNodeData(Node)^);
  HintText := xData.description;
  LineBreakStyle := hlbForceMultiLine;
end;

procedure TCFilterFrame.MessageFilterAdded(AId: TDataGid);
var xDataobject: TMovementFilter;
    xNode: PVirtualNode;
begin
  xDataobject := TMovementFilter(TMovementFilter.LoadObject(MovementFilterProxy, AId, True));
  FFilterObjects.Add(xDataobject);
  xNode := FilterList.AddChild(Nil, xDataobject);
  FilterList.Sort(xNode, FilterList.Header.SortColumn, FilterList.Header.SortDirection);
  FilterList.FocusedNode := xNode;
  FilterList.Selected[xNode] := True;
end;

procedure TCFilterFrame.MessageFilterEdited(AId: TDataGid);
var xDataobject: TMovementFilter;
    xNode: PVirtualNode;
begin
  xNode := FindDataobjectNode(AId, FilterList);
  if xNode <> Nil then begin
    xDataobject := TMovementFilter(FilterList.GetNodeData(xNode)^);
    xDataobject.ReloadObject;
    FilterList.InvalidateNode(xNode);
    FilterList.Sort(xNode, FilterList.Header.SortColumn, FilterList.Header.SortDirection);
  end;
end;

procedure TCFilterFrame.MessageFilterDeleted(AId: TDataGid);
var xNode: PVirtualNode;
begin
  xNode := FindDataobjectNode(AId, FilterList);
  if xNode <> Nil then begin
    FilterList.BeginUpdate;
    FFilterObjects.Remove(TMovementFilter(FilterList.GetNodeData(xNode)^));
    FilterList.DeleteNode(xNode);
    FilterList.EndUpdate;
  end;
end;

procedure TCFilterFrame.WndProc(var Message: TMessage);
var xDataGid: TDataGid;
begin
  inherited WndProc(Message);
  with Message do begin
    if Msg = WM_DATAOBJECTADDED then begin
      xDataGid := PDataGid(WParam)^;
      MessageFilterAdded(xDataGid);
    end else if Msg = WM_DATAOBJECTEDITED then begin
      xDataGid := PDataGid(WParam)^;
      MessageFilterEdited(xDataGid);
    end else if Msg = WM_DATAOBJECTDELETED then begin
      xDataGid := PDataGid(WParam)^;
      MessageFilterDeleted(xDataGid);
    end;
  end;
end;

function TCFilterFrame.GetSelectedId: TDataGid;
begin
  Result := '';
  if FilterList.FocusedNode <> Nil then begin
    Result := TMovementFilter(FilterList.GetNodeData(FilterList.FocusedNode)^).id;
  end;
end;

function TCFilterFrame.GetSelectedText: String;
begin
  Result := '';
  if FilterList.FocusedNode <> Nil then begin
    Result := TMovementFilter(FilterList.GetNodeData(FilterList.FocusedNode)^).name;
  end;
end;

procedure TCFilterFrame.FilterListDblClick(Sender: TObject);
begin
  if FilterList.FocusedNode <> Nil then begin
    if Owner.InheritsFrom(TCFrameForm) then begin
      TCFrameForm(Owner).BitBtnOkClick(Nil);
    end else begin
      ActionEditFilter.Execute;
    end;
  end;
end;

function TCFilterFrame.GetList: TCList;
begin
  Result := FilterList;
end;

end.
