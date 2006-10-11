unit CBaseFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, Contnrs, CDatabase, VirtualTrees;

const
  WM_DATAOBJECTADDED = WM_USER + 1;
  WM_DATAOBJECTEDITED = WM_USER + 2;
  WM_DATAOBJECTDELETED = WM_USER + 3;
  WM_DATAREFRESH = WM_USER + 4;

type
  TCBaseFrameClass = class of TCBaseFrame;

  TCBaseFrame = class(TFrame)
    ImageList: TImageList;
  private
    FAdditionalData: TObject;
  protected
    function GetSelectedId: TDataGid; virtual;
    function GetSelectedText: String; virtual;
    function GetList: TVirtualStringTree; virtual;
  public
    procedure InitializeFrame(AAdditionalData: TObject); virtual;
    class function GetTitle: String; virtual;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function IsValidFilteredObject(AObject: TDataObject): Boolean; virtual;
  published
    property SelectedId: TDataGid read GetSelectedId;
    property SelectedText: String read GetSelectedText;
    property List: TVirtualStringTree read GetList;
    property AdditionalData: TObject read FAdditionalData;
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

procedure TCBaseFrame.InitializeFrame(AAdditionalData: TObject);
begin
  FAdditionalData := AAdditionalData;
end;

function TCBaseFrame.IsValidFilteredObject(AObject: TDataObject): Boolean;
begin
  Result := True;
end;

initialization
  GFrames := TObjectList.Create(False);
finalization
  GFrames.Free;
end.
