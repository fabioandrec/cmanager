unit CDescTemplatesFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, Menus, ImgList, PngImageList, VirtualTrees, GraphUtil,
  Contnrs;

type
  TDescAdditionalData = class(TObject)
  private
    FTemplates: TObjectList;
  public
    constructor Create(ATemplates: TObjectList);
  end;

  TCDescTemplatesFrame = class(TCBaseFrame)
    TempList: TVirtualStringTree;
    procedure TempListBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
    procedure TempListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure TempListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure TempListInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
    procedure TempListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure TempListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
    procedure TempListDblClick(Sender: TObject);
    procedure TempListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
  protected
    function GetSelectedId: ShortString; override;
    function GetSelectedText: String; override;
  public
    procedure InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList); override;
    function GetList: TVirtualStringTree; override;
    class function GetTitle: String; override;
  end;

implementation

uses CTemplates, CBaseFormUnit, CFrameFormUnit;

{$R *.dfm}

procedure TCDescTemplatesFrame.TempListBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
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

procedure TCDescTemplatesFrame.TempListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TObject);
end;

procedure TCDescTemplatesFrame.TempListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  if ParentNode = Nil then begin
    InitialStates := InitialStates + [ivsHasChildren, ivsExpanded];
    TObject(TempList.GetNodeData(Node)^) := TDescAdditionalData(AdditionalData).FTemplates.Items[Node.Index];
  end else begin
    TDescTemplate(TempList.GetNodeData(Node)^) := TDescTemplateList(TempList.GetNodeData(ParentNode)^).Items[Node.Index];
  end;
end;

procedure TCDescTemplatesFrame.TempListInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
begin
  ChildCount := TDescTemplateList(TempList.GetNodeData(Node)^).Count;
end;

procedure TCDescTemplatesFrame.InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList);
begin
  inherited InitializeFrame(AOwner, AAdditionalData, AOutputData, AMultipleCheck);
  TempList.RootNodeCount := TDescAdditionalData(AdditionalData).FTemplates.Count;
  TempListFocusChanged(TempList, TempList.FocusedNode, 0);
end;

procedure TCDescTemplatesFrame.TempListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var xObj: TDescTemplate;
    xBase: TCBaseForm;
begin
  CellText := '';
  if TempList.NodeParent[Node] = Nil then begin
    if Column = 0 then begin
      CellText := TDescTemplateList(TempList.GetNodeData(Node)^).name;
    end;
  end else begin
    xObj := TDescTemplate(TempList.GetNodeData(Node)^);
    if Column = 0 then begin
      CellText := xObj.symbol;
    end else if Column = 1 then begin
      CellText := xObj.description;
    end else if Column = 2 then begin
      xBase := GetBaseForm;
      if xBase <> Nil then begin
        CellText := xObj.GetValue(xBase);
      end;
    end;
  end;
end;

function TCDescTemplatesFrame.GetList: TVirtualStringTree;
begin
  Result := TempList;
end;

class function TCDescTemplatesFrame.GetTitle: String;
begin
  Result := 'Lista mnemoników';
end;

procedure TCDescTemplatesFrame.TempListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
begin
  if TempList.NodeParent[Node] = Nil then begin
    HintText := TDescTemplateList(TempList.GetNodeData(Node)^).name;
  end else begin
    HintText := TDescTemplate(TempList.GetNodeData(Node)^).description;
  end;
  LineBreakStyle := hlbForceMultiLine;
end;

procedure TCDescTemplatesFrame.TempListDblClick(Sender: TObject);
begin
  if (TempList.FocusedNode <> Nil) and (TempList.NodeParent[TempList.FocusedNode] <> Nil) then begin
    if Owner.InheritsFrom(TCFrameForm) then begin
      TCFrameForm(Owner).BitBtnOkClick(Nil);
    end;
  end;
end;

procedure TCDescTemplatesFrame.TempListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
begin
  if Owner.InheritsFrom(TCFrameForm) then begin
    TCFrameForm(Owner).BitBtnOk.Enabled := (Node <> Nil) and (TempList.NodeParent[Node] <> Nil);
  end;
end;

function TCDescTemplatesFrame.GetSelectedId: ShortString;
begin
  Result := TDescTemplate(TempList.GetNodeData(TempList.FocusedNode)^).symbol;
end;

function TCDescTemplatesFrame.GetSelectedText: String;
begin
  Result := TDescTemplate(TempList.GetNodeData(TempList.FocusedNode)^).description;
end;

constructor TDescAdditionalData.Create(ATemplates: TObjectList);
begin
  inherited Create;
  FTemplates := ATemplates;
end;

end.
