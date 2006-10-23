unit CReportsFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, ImgList, ExtCtrls, VirtualTrees, Menus,
  VTHeaderPopup, ActnList, CComponents, CDatabase, Contnrs, GraphUtil,
  StdCtrls, CReports;

type
  THelperElement = class(TObjectList)
  private
    FisReport: Boolean;
    Fid: TDataGid;
    Fname: String;
    Fdesc: String;
    Fimage: Integer;
  public
    constructor Create(AIsReport: Boolean; AName: String; AId: TDataGid; ADesc: String; AImage: Integer);
  published
    property isReport: Boolean read FisReport;
    property id: TDataGid read Fid;
    property name: String read Fname;
    property desc: String read Fdesc;
    property image: Integer read Fimage;
  end;

  TCReportsFrame = class(TCBaseFrame)
    ReportList: TVirtualStringTree;
    ActionList: TActionList;
    ActionExecute: TAction;
    VTHeaderPopupMenu: TVTHeaderPopupMenu;
    PanelFrameButtons: TPanel;
    CButtonExecute: TCButton;
    procedure ReportListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure ReportListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure ReportListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure ReportListInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
    procedure ReportListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure ReportListHeaderClick(Sender: TVTHeader; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ReportListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
    procedure ReportListBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
    procedure ReportListDblClick(Sender: TObject);
    procedure ReportListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure ActionExecuteExecute(Sender: TObject);
  private
    FTreeHelper: THelperElement;
    procedure RecreateTreeHelper;
    procedure ReloadReports;
  protected
    function GetSelectedId: TDataGid; override;
    function GetSelectedText: String; override;
    function GetList: TVirtualStringTree; override;
    function GetClassOfReport(AGid: TDataGid): TCReportClass;
  public
    procedure InitializeFrame(AAdditionalData: TObject; AOutputData: Pointer); override;
    destructor Destroy; override;
    class function GetTitle: String; override;
  end;

implementation

uses CDataObjects, CFrameFormUnit, CProductFormUnit, CConfigFormUnit,
     CInfoFormUnit;

{$R *.dfm}

const CNoImage = -1;

procedure TCReportsFrame.ReloadReports;
begin
  ReportList.BeginUpdate;
  ReportList.Clear;
  RecreateTreeHelper;
  ReportList.RootNodeCount := FTreeHelper.Count;
  ReportListFocusChanged(ReportList, ReportList.FocusedNode, 0);
  ReportList.EndUpdate;
end;

procedure TCReportsFrame.ReportListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
var xData: THelperElement;
begin
  if Node <> Nil then begin
    xData := THelperElement(ReportList.GetNodeData(Node)^);
    CButtonExecute.Enabled := xData.isReport;
    if Owner.InheritsFrom(TCFrameForm) then begin
      TCFrameForm(Owner).BitBtnOk.Enabled := xData.isReport;
    end;
  end else begin
    CButtonExecute.Enabled := False;
    if Owner.InheritsFrom(TCFrameForm) then begin
      TCFrameForm(Owner).BitBtnOk.Enabled := False;
    end;
  end;
end;

procedure TCReportsFrame.RecreateTreeHelper;
var xRoot: THelperElement;
begin
  FTreeHelper.Add(THelperElement.Create(True, 'Stan kont na dziœ' , '1', 'Pokazuje aktualny stan wszystkich kont', CNoImage));
end;

destructor TCReportsFrame.Destroy;
begin
  FTreeHelper.Free;
  inherited Destroy;
end;

class function TCReportsFrame.GetTitle: String;
begin
  Result := 'Raporty';
end;

procedure TCReportsFrame.InitializeFrame(AAdditionalData: TObject; AOutputData: Pointer);
begin
  inherited InitializeFrame(AAdditionalData, AOutputData);
  FTreeHelper := THelperElement.Create(False, '', '', '', CNoImage);
  ReloadReports;
end;

procedure TCReportsFrame.ReportListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var xTreeList: THelperElement;
    xTreeObject: THelperElement;
begin
  if ParentNode = Nil then begin
    xTreeList := FTreeHelper;
  end else begin
    xTreeList := THelperElement(ReportList.GetNodeData(ParentNode)^);
  end;
  xTreeObject := THelperElement(xTreeList.Items[Node.Index]);
  THelperElement(ReportList.GetNodeData(Node)^) := xTreeObject;
  if xTreeObject.Count > 0 then begin
    InitialStates := InitialStates + [ivsHasChildren, ivsExpanded];
  end;
end;

procedure TCReportsFrame.ReportListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(THelperElement);
end;

procedure TCReportsFrame.ReportListInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
var xData: THelperElement;
begin
  xData := THelperElement(ReportList.GetNodeData(Node)^);
  ChildCount := xData.Count;
end;

procedure TCReportsFrame.ReportListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var xData: THelperElement;
begin
  xData := THelperElement(ReportList.GetNodeData(Node)^);
  CellText := xData.name;
end;

procedure TCReportsFrame.ReportListHeaderClick(Sender: TVTHeader; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
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

procedure TCReportsFrame.ReportListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
var xData: THelperElement;
begin
  xData := THelperElement(ReportList.GetNodeData(Node)^);
  HintText := xData.desc;
  LineBreakStyle := hlbForceMultiLine;
end;

procedure TCReportsFrame.ReportListBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
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

procedure TCReportsFrame.ReportListDblClick(Sender: TObject);
begin
  if ReportList.FocusedNode <> Nil then begin
    if Owner.InheritsFrom(TCFrameForm) then begin
      TCFrameForm(Owner).BitBtnOkClick(Nil);
    end else begin
      if CButtonExecute.Enabled then begin
        ActionExecute.Execute;
      end;
    end;
  end;
end;

procedure TCReportsFrame.ReportListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var xData1: THelperElement;
    xData2: THelperElement;
begin
  xData1 := THelperElement(ReportList.GetNodeData(Node1)^);
  xData2 := THelperElement(ReportList.GetNodeData(Node2)^);
  Result := AnsiCompareText(xData1.name, xData2.name);
end;

function TCReportsFrame.GetList: TVirtualStringTree;
begin
  Result := ReportList;
end;

function TCReportsFrame.GetSelectedId: TDataGid;
begin
  Result := '';
  if ReportList.FocusedNode <> Nil then begin
    Result := THelperElement(ReportList.GetNodeData(ReportList.FocusedNode)^).id;
  end;
end;

function TCReportsFrame.GetSelectedText: String;
begin
  Result := '';
  if ReportList.FocusedNode <> Nil then begin
    Result := THelperElement(ReportList.GetNodeData(ReportList.FocusedNode)^).name;
  end;
end;

constructor THelperElement.Create(AIsReport: Boolean; AName: String; AId: TDataGid; ADesc: String; AImage: Integer);
begin
  inherited Create(True);
  FisReport := AIsReport;
  Fid := AId;
  Fname := AName;
  Fdesc := ADesc;
  Fimage := AImage;
end;

procedure TCReportsFrame.ActionExecuteExecute(Sender: TObject);
var xClass: TCReportClass;
    xReport: TCReport;
    xGid: TDataGid;
begin
  xGid := GetSelectedId;
  if xGid <> CEmptyDataGid then begin
    xClass := GetClassOfReport(xGid);
    if xClass <> Nil then begin
      xReport := xClass.Create;
      xReport.ShowReport;
      xReport.Free;
    end else begin
      ShowInfo(itError, 'Wybrany raport nie jest jeszcze dostêpny', '')
    end;
  end;
end;

function TCReportsFrame.GetClassOfReport(AGid: TDataGid): TCReportClass;
begin
  if AGid = '1' then begin
    Result := TTodayCashInAccount;
  end else begin
    Result := Nil;
  end;
end;

end.
