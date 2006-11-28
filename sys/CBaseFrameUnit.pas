unit CBaseFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, Contnrs, CDatabase, VirtualTrees, PngImageList;

const
  WM_DATAOBJECTADDED = WM_USER + 1;
  WM_DATAOBJECTEDITED = WM_USER + 2;
  WM_DATAOBJECTDELETED = WM_USER + 3;
  WM_DATAREFRESH = WM_USER + 4;
  WM_FORMMAXIMIZE = WM_USER + 5;
  WM_FORMMINIMIZE = WM_USER + 6;

type
  TCBaseFrameClass = class of TCBaseFrame;

  TCBaseFrame = class(TFrame)
    ImageList: TPngImageList;
  private
    FAdditionalData: TObject;
    FOutputData: Pointer;
    FMultipleChecks: TStringList;
  protected
    function GetSelectedId: TDataGid; virtual;
    function GetSelectedText: String; virtual;
    function GetList: TVirtualStringTree; virtual;
  public
    procedure UpdateOutputData; virtual;
    function FindNode(ADataId: TDataGid; AList: TVirtualStringTree): PVirtualNode; virtual;
    procedure InitializeFrame(AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList); virtual;
    procedure PrepareCheckStates; virtual;
    class function GetTitle: String; virtual;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function IsValidFilteredObject(AObject: TDataObject): Boolean; virtual;
    function FindNodeId(ANode: PVirtualNode): TDataGid; virtual;
    property OutputData: Pointer read FOutputData;
  published
    property SelectedId: TDataGid read GetSelectedId;
    property SelectedText: String read GetSelectedText;
    property List: TVirtualStringTree read GetList;
    property AdditionalData: TObject read FAdditionalData;
    property MultipleChecks: TStringList read FMultipleChecks;
  end;

var GFrames: TObjectList;

procedure SendMessageToFrames(AFrameClass: TCBaseFrameClass; AMsg: Cardinal; AWParam: Cardinal; ALParam: Cardinal);
function FindDataobjectNode(AGid: TDataGid; AList: TVirtualStringTree): PVirtualNode;
function FindTreeobjectNode(AGid: TDataGid; AList: TVirtualStringTree): PVirtualNode;

implementation

{$R *.dfm}

procedure SendMessageToFrames(AFrameClass: TCBaseFrameClass; AMsg: Cardinal; AWParam: Cardinal; ALParam: Cardinal);
var xCount: Integer;
begin
  for xCount := 0 to GFrames.Count - 1 do begin
    if GFrames.Items[xCount].InheritsFrom(AFrameClass) then begin
       TCBaseFrame(GFrames.Items[xCount]).Perform(AMsg, AWParam, ALParam);
    end;
  end;
end;

function FindDataobjectNode(AGid: TDataGid; AList: TVirtualStringTree): PVirtualNode;
var xCurNode: PVirtualNode;
    xDataobject: TDataObject;
begin
  Result := Nil;
  xCurNode := AList.GetFirst;
  while (Result = Nil) and (xCurNode <> Nil) do begin
    xDataobject := TDataObject(AList.GetNodeData(xCurNode)^);
    if xDataobject.id = AGid then begin
      Result := xCurNode;
    end else begin
      xCurNode := AList.GetNext(xCurNode);
    end;
  end;
end;

function FindTreeobjectNode(AGid: TDataGid; AList: TVirtualStringTree): PVirtualNode;
var xCurNode: PVirtualNode;
    xTreeobject: TTreeObject;
begin
  Result := Nil;
  xCurNode := AList.GetFirst;
  while (Result = Nil) and (xCurNode <> Nil) do begin
    xTreeobject := TTreeObject(AList.GetNodeData(xCurNode)^);
    if xTreeobject.Dataobject.id = AGid then begin
      Result := xCurNode;
    end else begin
      xCurNode := AList.GetNext(xCurNode);
    end;
  end;
end;

constructor TCBaseFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  GFrames.Add(Self);
end;

destructor TCBaseFrame.Destroy;
begin
  GFrames.Remove(Self);
  inherited Destroy;
end;

function TCBaseFrame.FindNode(ADataId: TDataGid; AList: TVirtualStringTree): PVirtualNode;
begin
  Result := FindDataobjectNode(ADataId, AList);
end;

function TCBaseFrame.FindNodeId(ANode: PVirtualNode): TDataGid;
begin
  Result := TDataObject(GetList.GetNodeData(ANode)^).id;
end;

function TCBaseFrame.GetList: TVirtualStringTree;
begin
  Result := Nil;
end;

function TCBaseFrame.GetSelectedId: TDataGid;
begin
  Result := '';
end;

function TCBaseFrame.GetSelectedText: String;
begin
  Result := '';
end;

class function TCBaseFrame.GetTitle: String;
begin
  Result := '';
end;

procedure TCBaseFrame.InitializeFrame(AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList);
begin
  FAdditionalData := AAdditionalData;
  FMultipleChecks := AMultipleCheck;
  FOutputData := AOutputData;
  if (AMultipleCheck <> Nil) and (GetList <> Nil) then begin
    GetList.TreeOptions.MiscOptions := GetList.TreeOptions.MiscOptions + [toCheckSupport];
    GetList.CheckImageKind := ckDarkTick;
  end;
end;

function TCBaseFrame.IsValidFilteredObject(AObject: TDataObject): Boolean;
begin
  Result := True;
end;

procedure TCBaseFrame.PrepareCheckStates;
var xNode: PVirtualNode;
    xList: TVirtualStringTree;
    xAll: Boolean;
    xId: TDataGid;
    xChecked: Boolean;
begin
  xList := GetList;
  if (xList <> Nil) and (FMultipleChecks <> Nil) then begin
    xAll := FMultipleChecks.Count = 0;
    xNode := xList.GetFirst;
    while (xNode <> Nil) do begin
      xNode.CheckType := ctCheckBox;
      xChecked := xAll;
      if not xChecked then begin
        xId := FindNodeId(xNode);
        xChecked := FMultipleChecks.IndexOf(xId) <> -1;
      end;
      if xChecked then begin
        xNode.CheckState := csCheckedNormal;
      end else begin
        xNode.CheckState := csUncheckedNormal;
      end;
      xNode := xList.GetNext(xNode);
    end;
  end;
end;

procedure TCBaseFrame.UpdateOutputData;
var xNode: PVirtualNode;
    xList: TVirtualStringTree;
    xAll: Boolean;
begin
  xList := GetList;
  if (FMultipleChecks <> Nil) and (xList <> Nil) then begin
    FMultipleChecks.Clear;
    xNode := xList.GetFirst;
    xAll := True;
    while (xNode <> Nil) do begin
      if xNode.CheckState = csCheckedNormal then begin
        FMultipleChecks.Add(FindNodeId(xNode));
      end else begin
        xAll := False;
      end;
      xNode := xList.GetNext(xNode);
    end;
    if xAll then begin
      FMultipleChecks.Clear;
    end;
  end;
end;

initialization
  GFrames := TObjectList.Create(False);
finalization
  GFrames.Free;
end.
