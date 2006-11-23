unit CCashpointsFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, VirtualTrees, Buttons, CDatabase, ImgList,
  CComponents, ActnList, ExtCtrls, Menus, VTHeaderPopup, PngImageList;

type
  TCCashpointsFrame = class(TCBaseFrame)
    ActionList: TActionList;
    ActionAddCashpoint: TAction;
    ActionEditCahpoint: TAction;
    ActionDelCashpoint: TAction;
    CashpointList: TVirtualStringTree;
    VTHeaderPopupMenu: TVTHeaderPopupMenu;
    PanelFrameButtons: TPanel;
    CButtonAddCashpoint: TCButton;
    CButtonEditCashpoint: TCButton;
    CButtonDelCashpoint: TCButton;
    procedure ActionAddCashpointExecute(Sender: TObject);
    procedure ActionEditCahpointExecute(Sender: TObject);
    procedure ActionDelCashpointExecute(Sender: TObject);
    procedure CashpointListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure CashpointListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure CashpointListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure CashpointListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure CashpointListHeaderClick(Sender: TVTHeader; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure CashpointListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure CashpointListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
    procedure CashpointListBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
    procedure CashpointListDblClick(Sender: TObject);
  private
    FCashpointObjects: TDataObjectList;
    procedure ReloadCashpoints;
    procedure MessageCashpointAdded(AId: TDataGid);
    procedure MessageCashpointEdited(AId: TDataGid);
    procedure MessageCashpointDeleted(AId: TDataGid);
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

uses CDataObjects, CCashpointFormUnit, CConfigFormUnit, CFrameFormUnit, CMainFormUnit,
     CInfoFormUnit, GraphUtil;

{$R *.dfm}

destructor TCCashpointsFrame.Destroy;
begin
  FCashpointObjects.Free;
  inherited Destroy;
end;

class function TCCashpointsFrame.GetTitle: String;
begin
  Result := 'Kontrahenci';
end;

procedure TCCashpointsFrame.InitializeFrame(AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList);
begin
  inherited InitializeFrame(AAdditionalData, AOutputData, AMultipleCheck);
  ReloadCashpoints;
end;

procedure TCCashpointsFrame.ReloadCashpoints;
begin
  FCashpointObjects := TDataObject.GetList(TCashPoint, CashPointProxy, 'select * from cashPoint');
  CashpointList.BeginUpdate;
  CashpointList.Clear;
  CashpointList.RootNodeCount := FCashpointObjects.Count;
  CashpointListFocusChanged(CashpointList, CashpointList.FocusedNode, 0);
  CashpointList.EndUpdate;
end;

procedure TCCashpointsFrame.ActionAddCashpointExecute(Sender: TObject);
var xForm: TCCashpointForm;
    xDataGid: TDataGid;
begin
  xForm := TCCashpointForm.Create(Nil);
  xDataGid := xForm.ShowDataobject(coAdd, CashPointProxy, Nil, True);
  if xDataGid <> CEmptyDataGid then begin
    SendMessageToFrames(TCCashpointsFrame, WM_DATAOBJECTADDED, Integer(@xDataGid), 0);
  end;
  xForm.Free;
end;

procedure TCCashpointsFrame.CashpointListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  TDataObject(CashpointList.GetNodeData(Node)^) := FCashpointObjects.Items[Node.Index];
  if MultipleChecks <> Nil then begin
    Node.CheckType := ctCheckBox;
    Node.CheckState := csCheckedNormal;
  end;
end;

procedure TCCashpointsFrame.CashpointListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TDataObject);
end;

procedure TCCashpointsFrame.CashpointListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var xData: TCashPoint;
begin
  xData := TCashPoint(CashpointList.GetNodeData(Node)^);
  CellText := xData.name;
end;

procedure TCCashpointsFrame.ActionEditCahpointExecute(Sender: TObject);
var xForm: TCCashpointForm;
    xDataGid: TDataGid;
begin
  xForm := TCCashpointForm.Create(Nil);
  xDataGid := xForm.ShowDataobject(coEdit, CashPointProxy, TCashPoint(CashpointList.GetNodeData(CashpointList.FocusedNode)^), True);
  if xDataGid <> CEmptyDataGid then begin
    SendMessageToFrames(TCCashpointsFrame, WM_DATAOBJECTEDITED, Integer(@xDataGid), 0);
  end;
  xForm.Free;
end;

procedure TCCashpointsFrame.CashpointListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
begin
  CButtonEditCashpoint.Enabled := Node <> Nil;
  CButtonDelCashpoint.Enabled := Node <> Nil;
  if Owner.InheritsFrom(TCFrameForm) then begin
    TCFrameForm(Owner).BitBtnOk.Enabled := (Node <> Nil) or (MultipleChecks <> Nil);
  end;
end;

procedure TCCashpointsFrame.CashpointListHeaderClick(Sender: TVTHeader; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
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

procedure TCCashpointsFrame.CashpointListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var xData1: TCashPoint;
    xData2: TCashPoint;
begin
  xData1 := TCashPoint(CashpointList.GetNodeData(Node1)^);
  xData2 := TCashPoint(CashpointList.GetNodeData(Node2)^);
  Result := AnsiCompareText(xData1.name, xData2.name);
end;

procedure TCCashpointsFrame.ActionDelCashpointExecute(Sender: TObject);
var xData: TDataObject;
begin
  xData := TDataObject(CashpointList.GetNodeData(CashpointList.FocusedNode)^);
  if TCashPoint.CanBeDeleted(xData.id) then begin
    if ShowInfo(itQuestion, 'Czy chcesz usun¹æ kontrahenta o nazwie "' + TCashPoint(xData).name + '" ?', '') then begin
      xData.DeleteObject;
      GDataProvider.CommitTransaction;
      SendMessageToFrames(TCCashpointsFrame, WM_DATAOBJECTDELETED, Integer(@xData.id), 0);
    end;
  end;
end;

procedure TCCashpointsFrame.CashpointListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
var xData: TCashPoint;
begin
  xData := TCashPoint(CashpointList.GetNodeData(Node)^);
  HintText := xData.description;
  LineBreakStyle := hlbForceMultiLine;
end;

procedure TCCashpointsFrame.MessageCashpointAdded(AId: TDataGid);
var xDataobject: TCashPoint;
    xNode: PVirtualNode;
begin
  xDataobject := TCashPoint(TCashPoint.LoadObject(CashPointProxy, AId, True));
  FCashpointObjects.Add(xDataobject);
  xNode := CashpointList.AddChild(Nil, xDataobject);
  CashpointList.Sort(xNode, CashpointList.Header.SortColumn, CashpointList.Header.SortDirection);
  CashpointList.FocusedNode := xNode;
  CashpointList.Selected[xNode] := True;
end;

procedure TCCashpointsFrame.MessageCashpointEdited(AId: TDataGid);
var xDataobject: TCashPoint;
    xNode: PVirtualNode;
begin
  xNode := FindDataobjectNode(AId, CashpointList);
  if xNode <> Nil then begin
    xDataobject := TCashPoint(CashpointList.GetNodeData(xNode)^);
    xDataobject.ReloadObject;
    CashpointList.InvalidateNode(xNode);
    CashpointList.Sort(xNode, CashpointList.Header.SortColumn, CashpointList.Header.SortDirection);
  end;
end;

procedure TCCashpointsFrame.MessageCashpointDeleted(AId: TDataGid);
var xNode: PVirtualNode;
begin
  xNode := FindDataobjectNode(AId, CashpointList);
  if xNode <> Nil then begin
    CashpointList.DeleteNode(xNode);
    FCashpointObjects.Remove(TCashPoint(CashpointList.GetNodeData(xNode)^));
  end;
end;

procedure TCCashpointsFrame.WndProc(var Message: TMessage);
var xDataGid: TDataGid;
begin
  inherited WndProc(Message);
  with Message do begin
    if Msg = WM_DATAOBJECTADDED then begin
      xDataGid := PDataGid(WParam)^;
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

procedure TCCashpointsFrame.CashpointListBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
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

function TCCashpointsFrame.GetSelectedId: TDataGid;
begin
  Result := '';
  if CashpointList.FocusedNode <> Nil then begin
    Result := TCashPoint(CashpointList.GetNodeData(CashpointList.FocusedNode)^).id;
  end;
end;

function TCCashpointsFrame.GetSelectedText: String;
begin
  Result := '';
  if CashpointList.FocusedNode <> Nil then begin
    Result := TCashPoint(CashpointList.GetNodeData(CashpointList.FocusedNode)^).name;
  end;
end;

procedure TCCashpointsFrame.CashpointListDblClick(Sender: TObject);
begin
  if CashpointList.FocusedNode <> Nil then begin
    if Owner.InheritsFrom(TCFrameForm) then begin
      TCFrameForm(Owner).BitBtnOkClick(Nil);
    end;
  end;
end;

function TCCashpointsFrame.GetList: TVirtualStringTree;
begin
  Result := CashpointList;
end;

end.
