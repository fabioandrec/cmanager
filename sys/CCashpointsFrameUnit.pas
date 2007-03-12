unit CCashpointsFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, VirtualTrees, Buttons, CDatabase, ImgList,
  CComponents, ActnList, ExtCtrls, Menus, VTHeaderPopup, PngImageList,
  CImageListsUnit, StdCtrls, CDataObjects;

type
  TCashpointFrameAdditionalData = class
  private
    FcashpointType: TBaseEnumeration;
  public
    constructor Create(ACashpointType: TBaseEnumeration);
  published
    property cashpointType: TBaseEnumeration read FcashpointType;
  end;

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
    Panel: TPanel;
    Label2: TLabel;
    CStaticFilter: TCStatic;
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
    procedure CStaticFilterGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticFilterChanged(Sender: TObject);
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
  public
    function GetList: TVirtualStringTree; override;
    procedure InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList); override;
    destructor Destroy; override;
    class function GetTitle: String; override;
    function IsValidFilteredObject(AObject: TDataObject): Boolean; override;
  end;

implementation

uses CCashpointFormUnit, CConfigFormUnit, CFrameFormUnit, CMainFormUnit,
     CInfoFormUnit, GraphUtil, CConsts, CListFrameUnit;

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

procedure TCCashpointsFrame.InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList);
begin
  inherited InitializeFrame(AOwner, AAdditionalData, AOutputData, AMultipleCheck);
  if AAdditionalData <> Nil then begin
    if TCashpointFrameAdditionalData(AAdditionalData).cashpointType = CCashpointTypeAll then begin
      CStaticFilter.DataId := '1';
      CStaticFilter.Caption := '<dostêpne wszêdzie>';
    end else if TCashpointFrameAdditionalData(AAdditionalData).cashpointType = CCashpointTypeIn then begin
      CStaticFilter.DataId := '3';
      CStaticFilter.Caption := '<tylko przychody>';
    end else if TCashpointFrameAdditionalData(AAdditionalData).cashpointType = CCashpointTypeOut then begin
      CStaticFilter.DataId := '2';
      CStaticFilter.Caption := '<tylko rozchody>';
    end;
  end;
  ReloadCashpoints;
end;

procedure TCCashpointsFrame.ReloadCashpoints;
var xCondition: String;
begin
  if CStaticFilter.DataId = '0' then begin
    xCondition := '';
  end else if CStaticFilter.DataId = '1' then begin
    xCondition := ' where cashpointType = ''' + CCashpointTypeAll + '''';
  end else if CStaticFilter.DataId = '2' then begin
    xCondition := ' where cashpointType <> ''' + CCashpointTypeOut + '''';
  end else if CStaticFilter.DataId = '3' then begin
    xCondition := ' where cashpointType <> ''' + CCashpointTypeIn + '''';
  end;
  FCashpointObjects := TDataObject.GetList(TCashPoint, CashPointProxy, 'select * from cashPoint' + xCondition);
  CashpointList.BeginUpdate;
  CashpointList.Clear;
  CashpointList.RootNodeCount := FCashpointObjects.Count;
  CashpointListFocusChanged(CashpointList, CashpointList.FocusedNode, 0);
  CashpointList.EndUpdate;
end;

procedure TCCashpointsFrame.ActionAddCashpointExecute(Sender: TObject);
var xForm: TCCashpointForm;
begin
  xForm := TCCashpointForm.Create(Nil);
  xForm.ShowDataobject(coAdd, CashPointProxy, Nil, True);
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
begin
  xForm := TCCashpointForm.Create(Nil);
  xForm.ShowDataobject(coEdit, CashPointProxy, TCashPoint(CashpointList.GetNodeData(CashpointList.FocusedNode)^), True);
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
    xBase: TDataObject;
begin
  xBase := TDataObject(CashpointList.GetNodeData(CashpointList.FocusedNode)^);
  if TCashPoint.CanBeDeleted(xBase.id) then begin
    if ShowInfo(itQuestion, 'Czy chcesz usun¹æ kontrahenta o nazwie "' + TCashPoint(xBase).name + '" ?', '') then begin
      xData := TCashPoint.LoadObject(CashPointProxy, xBase.id, False);
      xData.DeleteObject;
      GDataProvider.CommitTransaction;
      SendMessageToFrames(TCCashpointsFrame, WM_DATAOBJECTDELETED, Integer(@xBase.id), 0);
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
    CashpointList.BeginUpdate;
    FCashpointObjects.Remove(TCashPoint(CashpointList.GetNodeData(xNode)^));
    CashpointList.DeleteNode(xNode);
    CashpointList.EndUpdate;
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
    end else begin
      ActionEditCahpoint.Execute;
    end;
  end;
end;

function TCCashpointsFrame.GetList: TVirtualStringTree;
begin
  Result := CashpointList;
end;

procedure TCCashpointsFrame.CStaticFilterGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
var xList: TStringList;
    xGid, xText: String;
    xRect: TRect;
begin
  xList := TStringList.Create;
  xList.Add('0=<dowolny>');
  xList.Add('1=<dostêpne wszêdzie>');
  xList.Add('2=<tylko rozchody>');
  xList.Add('3=<tylko przychody>');
  xGid := CEmptyDataGid;
  xText := '';
  xRect := Rect(10, 10, 200, 300);
  AAccepted := TCFrameForm.ShowFrame(TCListFrame, xGid, xText, xList, @xRect);
  if AAccepted then begin
    ADataGid := xGid;
    AText := xText;
  end;
end;

procedure TCCashpointsFrame.CStaticFilterChanged(Sender: TObject);
begin
  ReloadCashpoints;
end;

function TCCashpointsFrame.IsValidFilteredObject(AObject: TDataObject): Boolean;
var xFt: String;
begin
  xFt := '';
  if CStaticFilter.DataId = '1' then begin
    xFt := CCashpointTypeAll;
  end else if CStaticFilter.DataId = '2' then begin
    xFt := CCashpointTypeIn;
  end else if CStaticFilter.DataId = '3' then begin
    xFt := CCashpointTypeOut;
  end;
  Result := (xFt = '') or (TCashPoint(AObject).cashpointType = xFt); 
end;

constructor TCashpointFrameAdditionalData.Create(ACashpointType: TBaseEnumeration);
begin
  inherited Create;
  FcashpointType := ACashpointType;
end;

end.
