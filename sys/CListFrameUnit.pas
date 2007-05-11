unit CListFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, ImgList, VirtualTrees, CDatabase, GraphUtil,
  PngImageList, Menus, CComponents;

type
  TCListFrame = class(TCBaseFrame)
    List: TCList;
    procedure ListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure ListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure ListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure ListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure ListDblClick(Sender: TObject);
    procedure ListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
  private
    FGids: TStringList;
    FNames: TStringList;
  protected
    function GetSelectedId: TDataGid; override;
    function GetSelectedText: String; override;
  public
    function GetList: TCList; override;
    procedure ReloadList(AItems: TStringList);
    procedure InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList); override;
    destructor Destroy; override;
    class function GetTitle: String; override;
    function FindNode(ADataId: ShortString; AList: TCList): PVirtualNode; override;
  end;

implementation

uses CFrameFormUnit;

{$R *.dfm}

destructor TCListFrame.Destroy;
begin
  FGids.Free;
  FNames.Free;
  inherited Destroy;
end;

function TCListFrame.GetList: TCList;
begin
  Result := List;
end;

function TCListFrame.GetSelectedId: TDataGid;
var xInt: Integer;
begin
  Result := '';
  if List.FocusedNode <> Nil then begin
    xInt := Integer(List.GetNodeData(List.FocusedNode)^);
    Result := FGids.Strings[xInt];
  end;
end;

function TCListFrame.GetSelectedText: String;
var xInt: Integer;
begin
  Result := '';
  if List.FocusedNode <> Nil then begin
    xInt := Integer(List.GetNodeData(List.FocusedNode)^);
    Result := FNames.Strings[xInt];
  end;
end;

class function TCListFrame.GetTitle: String;
begin
  Result := 'Wybierz z listy';
end;

procedure TCListFrame.InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList);
begin
  inherited InitializeFrame(AOwner, AAdditionalData, AOutputData, AMultipleCheck);
  FGids := TStringList.Create;
  FNames := TStringList.Create;
  ReloadList(TStringList(AAdditionalData));
end;

procedure TCListFrame.ListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  Integer(List.GetNodeData(Node)^) := Node.Index;
end;

procedure TCListFrame.ListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(Integer);
end;

procedure TCListFrame.ListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var xData: Integer;
begin
  xData := Integer(List.GetNodeData(Node)^);
  CellText := FNames.Strings[xData];
end;

procedure TCListFrame.ListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var xData1: Integer;
    xData2: Integer;
begin
  if List.Header.SortColumn <> -1 then begin
    xData1 := Integer(List.GetNodeData(Node1)^);
    xData2 := Integer(List.GetNodeData(Node2)^);
    Result := AnsiCompareText(FNames.Strings[xData1], FNames.Strings[xData2]);
  end;
end;

procedure TCListFrame.ListDblClick(Sender: TObject);
begin
  if List.FocusedNode <> Nil then begin
    if Owner.InheritsFrom(TCFrameForm) then begin
      TCFrameForm(Owner).BitBtnOkClick(Nil);
    end;
  end;
end;

procedure TCListFrame.ReloadList(AItems: TStringList);
var xCount: Integer;
begin
  for xCount := 0 to AItems.Count - 1 do begin
    FGids.Add(AItems.Names[xCount]);
    FNames.Add(AItems.Values[AItems.Names[xCount]]);
  end;
  List.BeginUpdate;
  List.RootNodeCount := FGids.Count;
  List.EndUpdate;
  ListFocusChanged(List, List.FocusedNode, 0);
end;

procedure TCListFrame.ListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
begin
  if Owner.InheritsFrom(TCFrameForm) then begin
    TCFrameForm(Owner).BitBtnOk.Enabled := Node <> Nil;
  end;
end;

function TCListFrame.FindNode(ADataId: ShortString; AList: TCList): PVirtualNode;
var xIndex: Integer;
    xCount: Integer;
    xNode: PVirtualNode;
begin
  Result := Nil;
  xIndex := FGids.IndexOf(ADataId);
  if xIndex <> -1 then begin
    xCount := 0;
    xNode := AList.GetFirst;
    while (xNode <> Nil) and (Result = Nil) do begin
      if xCount = xIndex then begin
        Result := xNode;
      end;
      xNode := xNode.NextSibling;
    end;
  end;
end;

end.
