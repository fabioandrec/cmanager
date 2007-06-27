unit CFilterDetailFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, Menus, ImgList, PngImageList, VirtualTrees,
  ExtCtrls, CImageListsUnit, CDatabase, CDataObjects, CConsts;

type
  TFilterDetailData = class(TObject)
  private
    FAccountIds: TStringList;
    FProductIds: TStringList;
    FCashpointIds: TStringList;
  public
    constructor Create;
    property AccountIds: TStringList read FAccountIds write FAccountIds;
    property ProductIds: TStringList read FProductIds write FProductIds;
    property CashpointIds: TStringList read FCashpointIds write FCashpointIds;
    destructor Destroy; override;
  end;

  TCFilterDetailFrame = class(TCBaseFrame)
    PanelThumbs: TPanel;
    ThumbsList: TVirtualStringTree;
    Splitter: TSplitter;
    PanelFrames: TPanel;
    procedure ThumbsListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure ThumbsListGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
    procedure ThumbsListChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
  private
    FActiveFrameIndex: Integer;
    FFrames: array[0..2] of TCBaseFrame;
    FChecks: array[0..2] of TStringList;
    procedure SetActiveFrameIndex(const Value: Integer);
  public
    procedure InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean); override;
    destructor Destroy; override;
    class function GetTitle: String; override;
    procedure UpdateOutputData; override;
  published
    property ActiveFrameIndex: Integer read FActiveFrameIndex write SetActiveFrameIndex;
  end;

function CreateTemporaryMovementFilter: TDataGid;

implementation

uses CFrameFormUnit, CAccountsFrameUnit, CProductsFrameUnit, CCashpointsFrameUnit;

{$R *.dfm}

function CreateTemporaryMovementFilter: TDataGid;
var xId, xText: String;
    xData: TFilterDetailData;
    xOutput: TFilterDetailData;
    xFilter: TMovementFilter;
begin
  Result := CEmptyDataGid;
  xData := TFilterDetailData.Create;
  xOutput := TFilterDetailData.Create;
  if TCFrameForm.ShowFrame(TCFilterDetailFrame, xId, xText, xData, Nil, xOutput, Nil, True) then begin
    GDataProvider.BeginTransaction;
    xFilter := TMovementFilter.CreateObject(MovementFilterProxy, False);
    xFilter.name := '*' + FormatDateTime('yyyymmddhhnnss', Now);
    xFilter.description := 'filtr tymczasowy';
    xFilter.isTemp := True;
    xFilter.accounts.Assign(xOutput.AccountIds);
    xFilter.products.Assign(xOutput.ProductIds);
    xFilter.cashpoints.Assign(xOutput.CashpointIds);
    Result := xFilter.id;
    GDataProvider.CommitTransaction;
  end;
  xOutput.Free;
end;

procedure TCFilterDetailFrame.InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean);
var xCount: Integer;
begin
  inherited InitializeFrame(AOwner, AAdditionalData, AOutputData, AMultipleCheck, AWithButtons);
  for xCount := 0 to 2 do begin
    FFrames[xCount] := Nil;
    FChecks[xCount] := TStringList.Create;
  end;
  if AdditionalData <> Nil then begin
    with TFilterDetailData(AdditionalData) do begin
      FChecks[0].Assign(FAccountIds);
      FChecks[1].Assign(FProductIds);
      FChecks[2].Assign(FCashpointIds);
    end;
  end;
  FActiveFrameIndex := -1;
  ThumbsList.RootNodeCount := 3;
  ThumbsList.FocusedNode := ThumbsList.GetFirst;
  ThumbsList.Selected[ThumbsList.FocusedNode] := True;
  ActiveFrameIndex := 0;
end;

procedure TCFilterDetailFrame.ThumbsListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
begin
  if Node.Index = 0 then begin
    CellText := 'Konta';
  end else if Node.Index = 1 then begin
    CellText := 'Kategorie';
  end else begin
    CellText := 'Kontrahenci';
  end;
end;

procedure TCFilterDetailFrame.ThumbsListGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
begin
  if Node.Index = 0 then begin
    ImageIndex := 4;
  end else if Node.Index = 1 then begin
    ImageIndex := 5;
  end else begin
    ImageIndex := 6;
  end;
end;

procedure TCFilterDetailFrame.SetActiveFrameIndex(const Value: Integer);
begin
  if FActiveFrameIndex <> Value then begin
    if FActiveFrameIndex <> -1 then begin
      FFrames[FActiveFrameIndex].HideFrame;
    end;
    FActiveFrameIndex := Value;
    if FFrames[FActiveFrameIndex] = Nil then begin
      if FActiveFrameIndex = 0 then begin
        FFrames[FActiveFrameIndex] := TCAccountsFrame.Create(Self);
      end else if FActiveFrameIndex = 1 then begin
        FFrames[FActiveFrameIndex] := TCProductsFrame.Create(Self);
      end else begin
        FFrames[FActiveFrameIndex] := TCCashpointsFrame.Create(Self);
      end;
      FFrames[FActiveFrameIndex].Visible := False;
      FFrames[FActiveFrameIndex].DisableAlign;
      FFrames[FActiveFrameIndex].InitializeFrame(Self, Nil, Nil, FChecks[FActiveFrameIndex], False);
      if FFrames[FActiveFrameIndex].GetList <> Nil then begin
        FFrames[FActiveFrameIndex].GetList.TabStop := True;
      end;
      FFrames[FActiveFrameIndex].PrepareCheckStates;
      FFrames[FActiveFrameIndex].Parent := PanelFrames;
      FFrames[FActiveFrameIndex].EnableAlign;
      FFrames[FActiveFrameIndex].Show;
    end;
    FFrames[FActiveFrameIndex].ShowFrame;
  end;
end;

destructor TCFilterDetailFrame.Destroy;
var xCount: Integer;
begin
  for xCount := 0 to 2 do begin
    if FFrames[xCount] <> Nil then begin
      FFrames[xCount].Free;
    end;
    FChecks[xCount].Free;
  end;
  inherited Destroy;
end;

procedure TCFilterDetailFrame.ThumbsListChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  if Node <> Nil then begin
    ActiveFrameIndex := Node.Index;
  end;
end;

class function TCFilterDetailFrame.GetTitle: String;
begin
  Result := 'Ustawienia filtru';
end;

procedure TCFilterDetailFrame.UpdateOutputData;
var xCount: Integer;
begin
  with TFilterDetailData(OutputData) do begin
    for xCount := 0 to 2 do begin
      if FFrames[xCount] <> Nil then begin
        FFrames[xCount].UpdateOutputData;
      end;
    end;
    FAccountIds.Assign(FChecks[0]);
    FProductIds.Assign(FChecks[1]);
    FCashpointIds.Assign(FChecks[2]);
  end;
end;

constructor TFilterDetailData.Create;
begin
  inherited Create;
  FAccountIds := TStringList.Create;
  FCashpointIds := TStringList.Create;
  FProductIds := TStringList.Create;
end;

destructor TFilterDetailData.Destroy;
begin
  FAccountIds.Free;
  FCashpointIds.Free;
  FProductIds.Free;
  inherited Destroy;
end;

end.
