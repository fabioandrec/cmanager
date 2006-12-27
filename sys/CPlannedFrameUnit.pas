unit CPlannedFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, ImgList, StdCtrls, ExtCtrls, VirtualTrees,
  ActnList, CComponents, CDatabase, Menus, VTHeaderPopup, GraphUtil, AdoDb,
  Contnrs, PngImageList, CImageListsUnit, CDataObjects;

type
  TCPlannedFrame = class(TCBaseFrame)
    PanelFrameButtons: TPanel;
    PlannedList: TVirtualStringTree;
    ActionList: TActionList;
    ActionMovement: TAction;
    ActionEditMovement: TAction;
    ActionDelMovement: TAction;
    VTHeaderPopupMenu: TVTHeaderPopupMenu;
    CButtonDel: TCButton;
    CButtonEdit: TCButton;
    CButtonOut: TCButton;
    procedure PlannedListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure PlannedListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure PlannedListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure PlannedListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure PlannedListHeaderClick(Sender: TVTHeader; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PlannedListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure PlannedListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
    procedure PlannedListBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
    procedure ActionMovementExecute(Sender: TObject);
    procedure ActionEditMovementExecute(Sender: TObject);
    procedure ActionDelMovementExecute(Sender: TObject);
    procedure PlannedListDblClick(Sender: TObject);
    procedure PlannedListPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
  private
    FPlannedObjects: TDataObjectList;
    procedure MessageMovementAdded(AId: TDataGid);
    procedure MessageMovementEdited(AId: TDataGid);
    procedure MessageMovementDeleted(AId: TDataGid);
    procedure FindFontAndBackground(AMovement: TPlannedMovement; AFont: TFont; var ABackground: TColor);
  protected
    procedure WndProc(var Message: TMessage); override;
  public
    function GetList: TVirtualStringTree; override;
    procedure ReloadPlanned;
    constructor Create(AOwner: TComponent); override;
    procedure InitializeFrame(AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList); override;
    destructor Destroy; override;
    class function GetTitle: String; override;
  end;

implementation

uses CFrameFormUnit, CInfoFormUnit, CConfigFormUnit, CDataobjectFormUnit,
  CAccountsFrameUnit, DateUtils, CListFrameUnit, DB, CMovementFormUnit,
  CPlannedFormUnit, CDoneFrameUnit, CConsts, CPreferences;

{$R *.dfm}

constructor TCPlannedFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPlannedObjects := Nil;
end;

procedure TCPlannedFrame.PlannedListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
begin
  CButtonEdit.Enabled := Node <> Nil;
  CButtonDel.Enabled := Node <> Nil;
  if Owner.InheritsFrom(TCFrameForm) then begin
    TCFrameForm(Owner).BitBtnOk.Enabled := (Node <> Nil) or (MultipleChecks <> Nil);
  end;
end;

procedure TCPlannedFrame.ReloadPlanned;
begin
  FPlannedObjects := TDataObject.GetList(TPlannedMovement, PlannedMovementProxy, 'select * from plannedMovement');
  PlannedList.BeginUpdate;
  PlannedList.Clear;
  PlannedList.RootNodeCount := FPlannedObjects.Count;
  PlannedListFocusChanged(PlannedList, PlannedList.FocusedNode, 0);
  PlannedList.EndUpdate;
end;

procedure TCPlannedFrame.InitializeFrame(AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList);
begin
  inherited InitializeFrame(AAdditionalData, AOutputData, AMultipleCheck);
  ReloadPlanned;
end;

destructor TCPlannedFrame.Destroy;
begin
  FPlannedObjects.Free;
  inherited Destroy;
end;

procedure TCPlannedFrame.PlannedListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  TDataObject(PlannedList.GetNodeData(Node)^) := FPlannedObjects.Items[Node.Index];
  if MultipleChecks <> Nil then begin
    Node.CheckType := ctCheckBox;
    Node.CheckState := csCheckedNormal;
  end;
end;

procedure TCPlannedFrame.PlannedListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TDataObject);
end;

procedure TCPlannedFrame.PlannedListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var xData: TPlannedMovement;
begin
  xData := TPlannedMovement(PlannedList.GetNodeData(Node)^);
  if Column = 0 then begin
    CellText := IntToStr(Node.Index + 1);
  end else if Column = 1 then begin
    CellText := xData.description;
  end else if Column = 2 then begin
    if (xData.movementType = CInMovement) then begin
      CellText := 'Przych�d';
    end else if (xData.movementType = COutMovement) then begin
      CellText := 'Rozch�d';
    end;
  end else begin
    CellText := CurrencyToString(xData.cash);
  end;
end;

procedure TCPlannedFrame.PlannedListHeaderClick(Sender: TVTHeader; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
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

procedure TCPlannedFrame.PlannedListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var xData1: TPlannedMovement;
    xData2: TPlannedMovement;
begin
  xData1 := TPlannedMovement(PlannedList.GetNodeData(Node1)^);
  xData2 := TPlannedMovement(PlannedList.GetNodeData(Node2)^);
  if Column = 0 then begin
    if Node1.Index > Node2.Index then begin
      Result := 1;
    end else if Node1.Index < Node2.Index then begin
      Result := -1;
    end else begin
      Result := 0;
    end;
  end else if Column = 1 then begin
    Result := AnsiCompareText(xData1.description, xData2.description);
  end else if Column = 2 then begin
    Result := AnsiCompareText(xData1.movementType, xData2.movementType);
  end else if Column = 3 then begin
    if xData1.cash > xData2.cash then begin
      Result := 1;
    end else if xData1.cash < xData2.cash then begin
      Result := -1;
    end else begin
      Result := 0;
    end;
  end;
end;

procedure TCPlannedFrame.PlannedListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
var xData: TPlannedMovement;
begin
  xData := TPlannedMovement(PlannedList.GetNodeData(Node)^);
  HintText := xData.description;
  LineBreakStyle := hlbForceMultiLine;
end;

procedure TCPlannedFrame.PlannedListBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
var xBase: TPlannedMovement;
    xColor: TColor;
begin
  xBase := TPlannedMovement(PlannedList.GetNodeData(Node)^);
  with TargetCanvas do begin
    if not Odd(Node.Index) then begin
      ItemColor := clWindow;
    end else begin
      ItemColor := GetHighLightColor(clWindow, -10);
    end;
    FindFontAndBackground(xBase, Nil, xColor);
    if xColor <> clWindow then begin
      ItemColor := xColor;
    end;
    EraseAction := eaColor;
  end;
end;

procedure TCPlannedFrame.MessageMovementAdded(AId: TDataGid);
var xDataobject: TPlannedMovement;
    xNode: PVirtualNode;
begin
  xDataobject := TPlannedMovement(TPlannedMovement.LoadObject(PlannedMovementProxy, AId, True));
  if IsValidFilteredObject(xDataobject) then begin
    FPlannedObjects.Add(xDataobject);
    xNode := PlannedList.AddChild(Nil, xDataobject);
    PlannedList.Sort(xNode, PlannedList.Header.SortColumn, PlannedList.Header.SortDirection);
    PlannedList.FocusedNode := xNode;
    PlannedList.Selected[xNode] := True;
  end else begin
    xDataobject.Free;
  end;
  SendMessageToFrames(TCDoneFrame, WM_DATAREFRESH, 0, 0);
end;

procedure TCPlannedFrame.MessageMovementDeleted(AId: TDataGid);
var xNode: PVirtualNode;
begin
  xNode := FindDataobjectNode(AId, PlannedList);
  if xNode <> Nil then begin
    PlannedList.DeleteNode(xNode);
    FPlannedObjects.Remove(TPlannedMovement(PlannedList.GetNodeData(xNode)^));
  end;
  SendMessageToFrames(TCDoneFrame, WM_DATAREFRESH, 0, 0);
end;

procedure TCPlannedFrame.MessageMovementEdited(AId: TDataGid);
var xDataobject: TPlannedMovement;
    xNode: PVirtualNode;
begin
  xNode := FindDataobjectNode(AId, PlannedList);
  if xNode <> Nil then begin
    xDataobject := TPlannedMovement(PlannedList.GetNodeData(xNode)^);
    xDataobject.ReloadObject;
    if IsValidFilteredObject(xDataobject) then begin
      PlannedList.InvalidateNode(xNode);
      PlannedList.Sort(xNode, PlannedList.Header.SortColumn, PlannedList.Header.SortDirection);
    end else begin
      PlannedList.DeleteNode(xNode);
      FPlannedObjects.Remove(TPlannedMovement(PlannedList.GetNodeData(xNode)^));
    end;
  end;
  SendMessageToFrames(TCDoneFrame, WM_DATAREFRESH, 0, 0);
end;

function TCPlannedFrame.GetList: TVirtualStringTree;
begin
  Result := PlannedList;
end;

procedure TCPlannedFrame.WndProc(var Message: TMessage);
var xDataGid: TDataGid;
begin
  inherited WndProc(Message);
  with Message do begin
    if Msg = WM_DATAOBJECTADDED then begin
      xDataGid := PDataGid(WParam)^;
      MessageMovementAdded(xDataGid);
    end else if Msg = WM_DATAOBJECTEDITED then begin
      xDataGid := PDataGid(WParam)^;
      MessageMovementEdited(xDataGid);
    end else if Msg = WM_DATAOBJECTDELETED then begin
      xDataGid := PDataGid(WParam)^;
      MessageMovementDeleted(xDataGid);
    end;
  end;
end;

class function TCPlannedFrame.GetTitle: String;
begin
  Result := 'Planowane operacje';
end;

procedure TCPlannedFrame.ActionMovementExecute(Sender: TObject);
var xForm: TCPlannedForm;
    xDataGid: TDataGid;
begin
  xForm := TCPlannedForm.Create(Nil);
  xDataGid := xForm.ShowDataobject(coAdd, PlannedMovementProxy, Nil, True);
  if xDataGid <> CEmptyDataGid then begin
    SendMessageToFrames(TCPlannedFrame, WM_DATAOBJECTADDED, Integer(@xDataGid), 0);
  end;
  xForm.Free;
end;

procedure TCPlannedFrame.ActionEditMovementExecute(Sender: TObject);
var xForm: TCPlannedForm;
    xBase: TPlannedMovement;
    xDataGid: TDataGid;
begin
  xBase := TPlannedMovement(PlannedList.GetNodeData(PlannedList.FocusedNode)^);
  xForm := TCPlannedForm.Create(Nil);
  xDataGid := xForm.ShowDataobject(coEdit, PlannedMovementProxy, xBase, True);
  if xDataGid <> CEmptyDataGid then begin
    SendMessageToFrames(TCPlannedFrame, WM_DATAOBJECTEDITED, Integer(@xDataGid), 0);
  end;
  xForm.Free;
end;

procedure TCPlannedFrame.ActionDelMovementExecute(Sender: TObject);
var xBase: TPlannedMovement;
    xObject: TDataObject;
begin
  xBase := TPlannedMovement(PlannedList.GetNodeData(PlannedList.FocusedNode)^);
  if TPlannedMovement.CanBeDeleted(xBase.id) then begin
    if ShowInfo(itQuestion, 'Czy chcesz usun�� wybrany plan ?', '') then begin
      xObject := TPlannedMovement(TPlannedMovement.LoadObject(PlannedMovementProxy, xBase.id, False));
      xObject.DeleteObject;
      GDataProvider.CommitTransaction;
      SendMessageToFrames(TCPlannedFrame, WM_DATAOBJECTDELETED, Integer(@xObject.id), 0);
    end;
  end;
end;

procedure TCPlannedFrame.PlannedListDblClick(Sender: TObject);
begin
  ActionEditMovement.Execute;
end;

procedure TCPlannedFrame.FindFontAndBackground(AMovement: TPlannedMovement; AFont: TFont; var ABackground: TColor);
var xKey: String;
    xPref: TFontPreference;
begin
  xKey := AMovement.movementType;
  xPref := GFontpreferences.FindFontPreference('plannedMovement', xKey);
  if xPref <> Nil then begin
    ABackground := xPref.Background;
    if AFont <> Nil then begin
      AFont.Assign(xPref.Font);
    end;
  end;
end;

procedure TCPlannedFrame.PlannedListPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
var xBase: TPlannedMovement;
    xColor: TColor;
begin
  xBase := TPlannedMovement(PlannedList.GetNodeData(Node)^);
  FindFontAndBackground(xBase, TargetCanvas.Font, xColor);
end;

end.
