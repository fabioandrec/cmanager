unit CReportsFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, ImgList, ExtCtrls, VirtualTrees, Menus,
  VTHeaderPopup, ActnList, CComponents, CDatabase, Contnrs, GraphUtil,
  StdCtrls, CReports, PngImageList, CImageListsUnit;

type
  THelperElement = class(TObjectList)
  private
    FisReport: Boolean;
    FreportClass: TCReportClass;
    FreportParams: TCReportParams;
    Fname: String;
    Fdesc: String;
    Fimage: Integer;
  public
    constructor Create(AIsReport: Boolean; AName: String; AClass: TCReportClass; AParams: TCReportParams; ADesc: String; AImage: Integer);
    destructor Destroy; override;
  published
    property isReport: Boolean read FisReport;
    property reportClass: TCReportClass read FreportClass;
    property reportParams: TCReportParams read FreportParams;
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
    procedure ReportListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
    procedure ReportListBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
    procedure ReportListDblClick(Sender: TObject);
    procedure ActionExecuteExecute(Sender: TObject);
    procedure ReportListGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
  private
    FTreeHelper: THelperElement;
    procedure RecreateTreeHelper;
    procedure ReloadReports;
  public
    function GetList: TVirtualStringTree; override;
    procedure InitializeFrame(AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList); override;
    destructor Destroy; override;
    class function GetTitle: String; override;
  end;

implementation

uses CDataObjects, CFrameFormUnit, CProductFormUnit, CConfigFormUnit,
     CInfoFormUnit, CConsts;

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
var xBase: THelperElement;
    xStats: THelperElement;
    xBs, xTm: THelperElement;
begin
  xBase := THelperElement.Create(False, 'Podstawowe', Nil, Nil, '', CNoImage);
  FTreeHelper.Add(xBase);
  xBase.Add(THelperElement.Create(True, 'Stan kont' , TAccountBalanceOnDayReport, Nil, 'Pokazuje stan wszystkich kont na wybrany dzieñ', CNoImage));
  xBase.Add(THelperElement.Create(True, 'Operacje wykonane' , TDoneOperationsListReport, Nil, 'Pokazuje operacje wykonane w wybranym okresie', CNoImage));
  xBase.Add(THelperElement.Create(True, 'Operacje zaplanowane' , TPlannedOperationsListReport, Nil, 'Pokazuje operacje zaplanowane na wybrany okres', CNoImage));
  xBase.Add(THelperElement.Create(True, 'Przep³yw gotówki' , TCashFlowListReport, Nil, 'Pokazuje przep³yw gotówki miêdzy kontami/kontrahentami w wybranym okresie', CNoImage));
  xBase.Add(THelperElement.Create(True, 'Historia konta' , TAccountHistoryReport, Nil, 'Pokazuje historiê wybranego konta w wybranym okresie', CNoImage));
  xBase.Add(THelperElement.Create(True, 'Wykres stanu kont' , TAccountBalanceChartReport, Nil, 'Pokazuje wykres stanu kont w wybranym okresie', CNoImage));

  xBs := THelperElement.Create(False, 'Rozchody', Nil, Nil, '', CNoImage);
  FTreeHelper.Add(xBs);
  xBs.Add(THelperElement.Create(True, 'Lista operacji rozchodowych' , TOperationsListReport, TCSelectedMovementTypeParams.Create(COutMovement), 'Pokazuje operacje rozchodowe w wybranym okresie', CNoImage));
  xTm := THelperElement.Create(False, 'w/g kategorii', Nil, Nil, '', CNoImage);
  xBs.Add(xTm);
  xTm.Add(THelperElement.Create(True, 'Wykres rozchodów' , TOperationsByCategoryChart, TCSelectedMovementTypeParams.Create(COutMovement), 'Pokazuje operacje rozchodowe w rozbiciu na kategorie', CNoImage));
  xTm.Add(THelperElement.Create(True, 'Lista rozchodów' , TOperationsByCategoryList, TCSelectedMovementTypeParams.Create(COutMovement), 'Pokazuje operacje rozchodowe w rozbiciu na kategorie', CNoImage));
  xTm := THelperElement.Create(False, 'w/g kontrahentów', Nil, Nil, '', CNoImage);
  xBs.Add(xTm);
  xTm.Add(THelperElement.Create(True, 'Wykres rozchodów' , TOperationsByCashpointChart, TCSelectedMovementTypeParams.Create(COutMovement), 'Pokazuje operacje rozchodowe w rozbiciu na kontrahentów', CNoImage));
  xTm.Add(THelperElement.Create(True, 'Lista rozchodów' , TOperationsByCashpointList, TCSelectedMovementTypeParams.Create(COutMovement), 'Pokazuje operacje rozchodowe w rozbiciu na kontrahentów', CNoImage));
  xTm := THelperElement.Create(False, 'Sumy', Nil, Nil, '', CNoImage);
  xBs.Add(xTm);
  xTm.Add(THelperElement.Create(True, 'Wykres sum rozchodów' , TSumReportChart, TCSelectedMovementTypeParams.Create(COutMovement), 'Pokazuje sumy rozchodów w wybranym okresie', CNoImage));
  xTm.Add(THelperElement.Create(True, 'Lista sum rozchodów' , TSumReportList, TCSelectedMovementTypeParams.Create(COutMovement), 'Pokazuje sumy rozchodów w wybranym okresie', CNoImage));

  xBs := THelperElement.Create(False, 'Przychody', Nil, Nil, '', CNoImage);
  FTreeHelper.Add(xBs);
  xBs.Add(THelperElement.Create(True, 'Lista operacji przychodowych' , TOperationsListReport, TCSelectedMovementTypeParams.Create(CInMovement), 'Pokazuje operacje przychodowe w wybranym okresie', CNoImage));
  xTm := THelperElement.Create(False, 'w/g kategorii', Nil, Nil, '', CNoImage);
  xBs.Add(xTm);
  xTm.Add(THelperElement.Create(True, 'Wykres przychodów' , TOperationsByCategoryChart, TCSelectedMovementTypeParams.Create(CInMovement), 'Pokazuje operacje przychodowe w rozbiciu na kategorie', CNoImage));
  xTm.Add(THelperElement.Create(True, 'Lista przychodów' , TOperationsByCategoryList, TCSelectedMovementTypeParams.Create(CInMovement), 'Pokazuje operacje przychodowe w rozbiciu na kategorie', CNoImage));
  xTm := THelperElement.Create(False, 'w/g kontrahentów', Nil, Nil, '', CNoImage);
  xBs.Add(xTm);
  xTm.Add(THelperElement.Create(True, 'Wykres przychodów' , TOperationsByCashpointChart, TCSelectedMovementTypeParams.Create(CInMovement), 'Pokazuje operacje przychodowe w rozbiciu na kontrahentów', CNoImage));
  xTm.Add(THelperElement.Create(True, 'Lista przychodów' , TOperationsByCashpointList, TCSelectedMovementTypeParams.Create(CInMovement), 'Pokazuje operacje przychodoe w rozbiciu na kontrahentów', CNoImage));
  xTm := THelperElement.Create(False, 'Sumy', Nil, Nil, '', CNoImage);
  xBs.Add(xTm);
  xTm.Add(THelperElement.Create(True, 'Wykres sum przychodów' , TSumReportChart, TCSelectedMovementTypeParams.Create(CInMovement), 'Pokazuje sumy przychodów w wybranym okresie', CNoImage));
  xTm.Add(THelperElement.Create(True, 'Lista sum przychodów' , TSumReportList, TCSelectedMovementTypeParams.Create(CInMovement), 'Pokazuje sumy przychodów w wybranym okresie', CNoImage));

  xStats := THelperElement.Create(False, 'Statystyki', Nil, Nil, '', CNoImage);
  FTreeHelper.Add(xStats);
  xStats.Add(THelperElement.Create(True, 'Œrednie' , TAveragesReport, Nil, 'Pokazuje œrednie rozchody/przychody w wybranym okresie', CNoImage));
  xStats.Add(THelperElement.Create(True, 'Prognozy' , Nil,Nil,  'Pokazuje prognozy rozchodów i przychodów dla wybranego okresu', CNoImage));
  xStats.Add(THelperElement.Create(True, 'Podsumowanie' , TPeriodSumsReport, Nil, 'Pokazuje podsumowanie statystyczne wybranego okresu', CNoImage));
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

procedure TCReportsFrame.InitializeFrame(AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList);
begin
  inherited InitializeFrame(AAdditionalData, AOutputData, AMultipleCheck);
  FTreeHelper := THelperElement.Create(False, '', Nil, Nil, '', CNoImage);
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
    InitialStates := InitialStates + [ivsHasChildren];
  end;
  if MultipleChecks <> Nil then begin
    Node.CheckType := ctCheckBox;
    Node.CheckState := csCheckedNormal;
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

function TCReportsFrame.GetList: TVirtualStringTree;
begin
  Result := ReportList;
end;

constructor THelperElement.Create(AIsReport: Boolean; AName: String; AClass: TCReportClass; AParams: TCReportParams; ADesc: String; AImage: Integer);
begin
  inherited Create(True);
  FisReport := AIsReport;
  FreportClass := AClass;
  Fname := AName;
  Fdesc := ADesc;
  Fimage := AImage;
  FreportParams := AParams;
end;

procedure TCReportsFrame.ActionExecuteExecute(Sender: TObject);
var xData: THelperElement;
    xReport: TCBaseReport;
begin
  xData := THelperElement(ReportList.GetNodeData(ReportList.FocusedNode)^);
  if xData.reportClass <> Nil then begin
    xReport := xData.reportClass.CreateReport(xData.reportParams);
    if xReport <> Nil then begin
      xReport.ShowReport;
      xReport.Free;
    end;
  end else begin
    ShowInfo(itError, 'Wybrany raport nie jest jeszcze dostêpny', '')
  end;
end;

destructor THelperElement.Destroy;
begin
  if FreportParams <> Nil then begin
    FreportParams.Free;
  end;
  inherited Destroy;
end;

procedure TCReportsFrame.ReportListGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
var xData: THelperElement;
begin
  xData := THelperElement(ReportList.GetNodeData(Node)^);
  ImageIndex := xData.image;
end;

end.
