unit CFilterFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, VirtualTrees, Buttons, CDatabase, ImgList,
  CComponents, ActnList, ExtCtrls, Menus, VTHeaderPopup, PngImageList;

type
  TCFilterFrame = class(TCBaseFrame)
    ActionList: TActionList;
    ActionAddFilter: TAction;
    ActionEditFilter: TAction;
    ActionDelFilter: TAction;
    FilterList: TVirtualStringTree;
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
    procedure FilterListHeaderClick(Sender: TVTHeader; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FilterListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure FilterListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
    procedure FilterListBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
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
    function GetList: TVirtualStringTree; override;
  public
    procedure InitializeFrame(AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList); override;
    destructor Destroy; override;
    class function GetTitle: String; override;
  end;

implementation

uses CDataObjects, CFilterFormUnit, CConfigFormUnit, CFrameFormUnit, CMainFormUnit,
     CInfoFormUnit, GraphUtil;

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

procedure TCFilterFrame.InitializeFrame(AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList);
begin
  inherited InitializeFrame(AAdditionalData, AOutputData, AMultipleCheck);
  ReloadFilters;
end;

procedure TCFilterFrame.ReloadFilters;
begin
  FFilterObjects := TDataObject.GetList(TMovementFilter, MovementFilterProxy, 'select * from movementFilter');
  FilterList.BeginUpdate;
  FilterList.Clear;
  FilterList.RootNodeCount := FFilterObjects.Count;
  FilterListFocusChanged(FilterList, FilterList.FocusedNode, 0);
  FilterList.EndUpdate;
end;

procedure TCFilterFrame.ActionAddFilterExecute(Sender: TObject);
var xForm: TCFilterForm;
    xDataGid: TDataGid;
begin
  xForm := TCFilterForm.Create(Nil);
  xDataGid := xForm.ShowDataobject(coAdd, MovementFilterProxy, Nil, True);
  if xDataGid <> CEmptyDataGid then begin
    SendMessageToFrames(TCFilterFrame, WM_DATAOBJECTADDED, Integer(@xDataGid), 0);
  end;
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
    xDataGid: TDataGid;
begin
  xForm := TCFilterForm.Create(Nil);
  xDataGid := xForm.ShowDataobject(coEdit, MovementFilterProxy, TMovementFilter(FilterList.GetNodeData(FilterList.FocusedNode)^), True);
  if xDataGid <> CEmptyDataGid then begin
    SendMessageToFrames(TCFilterFrame, WM_DATAOBJECTEDITED, Integer(@xDataGid), 0);
  end;
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

procedure TCFilterFrame.FilterListHeaderClick(Sender: TVTHeader; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
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
begin
  xData := TDataObject(FilterList.GetNodeData(FilterList.FocusedNode)^);
  if TMovementFilter.CanBeDeleted(xData.id) then begin
    if ShowInfo(itQuestion, 'Czy chcesz usun¹æ filtr o nazwie "' + TMovementFilter(xData).name + '" ?', '') then begin
      xData.DeleteObject;
      GDataProvider.CommitTransaction;
      SendMessageToFrames(TCFilterFrame, WM_DATAOBJECTDELETED, Integer(@xData.id), 0);
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
    FilterList.DeleteNode(xNode);
    FFilterObjects.Remove(TMovementFilter(FilterList.GetNodeData(xNode)^));
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

procedure TCFilterFrame.FilterListBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
begin
  with TargetCanvas do begin
    if not Odd(Node.Index) then begin
      ItemColor := clWindow;
    end else begin
      ItemColor := GetHighLightColor(clWindow, -10);
    end;
    EraseAction := eaColor;
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

function TCFilterFrame.GetList: TVirtualStringTree;
begin
  Result := FilterList;
end;

end.
