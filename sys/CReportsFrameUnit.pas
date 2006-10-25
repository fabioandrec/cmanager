unit CReportsFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, ImgList, ExtCtrls, VirtualTrees, Menus,
  VTHeaderPopup, ActnList, CComponents, CDatabase, Contnrs, GraphUtil,
  StdCtrls, CReports, PngImageList;

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
    procedure ReportListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
    procedure ReportListBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
    procedure ReportListDblClick(Sender: TObject);
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
var xBase: THelperElement;
    xIncomes: THelperElement;
    xExpenses: THelperElement;
    xOthers: THelperElement;
begin
  xBase := THelperElement.Create(False, 'Podstawowe', '1', '', CNoImage);
  FTreeHelper.Add(xBase);
  xBase.Add(THelperElement.Create(True, 'Stan kont' , '1_01', 'Pokazuje stan wszystkich kont na wybrany dzieñ', CNoImage));
  xBase.Add(THelperElement.Create(True, 'Operacje wykonane' , '1_02', 'Pokazuje operacje wykonane w wybranym okresie', CNoImage));
  xBase.Add(THelperElement.Create(True, 'Operacje zaplanowane' , '1_03', 'Pokazuje operacje zaplanowane na wybrany okres', CNoImage));
  xBase.Add(THelperElement.Create(True, 'Przep³yw gotówki' , '1_04', 'Pokazuje przep³yw gotówki miêdzy kontami/kontrahentami w wybranym okresie', CNoImage));
  xBase.Add(THelperElement.Create(True, 'Historia konta' , '1_05', 'Pokazuje historiê wybranego konta w wybranym okresie', CNoImage));
  xBase.Add(THelperElement.Create(True, 'Wykres stanu kont' , '1_06', 'Pokazuje wykres stanu kont w wybranym okresie', CNoImage));

  xIncomes := THelperElement.Create(False, 'Rozchody', '2', '', CNoImage);
  FTreeHelper.Add(xIncomes);
  xIncomes.Add(THelperElement.Create(True, 'Lista operacji rozchodowych' , '2_01', 'Pokazuje operacje rozchodowe w wybranym okresie', CNoImage));
  xIncomes.Add(THelperElement.Create(True, 'Rozchody wed³ug kategorii' , '2_02', 'Pokazuje operacje rozchodowe w rozbiciu na kategorie', CNoImage));
  xIncomes.Add(THelperElement.Create(True, 'Rozchody wed³ug kontrahentów' , '2_03', 'Pokazuje operacje rozchodowe w rozbiciu na kontrahentów', CNoImage));
  xIncomes.Add(THelperElement.Create(True, 'Œrednie rozchody' , '2_04', 'Pokazuje œrednie rozchody w wybranym okresie', CNoImage));

  xExpenses := THelperElement.Create(False, 'Przychody', '3', '', CNoImage);
  FTreeHelper.Add(xExpenses);
  xExpenses.Add(THelperElement.Create(True, 'Lista operacji przychodowych' , '3_01', 'Pokazuje operacje przychodowe w wybranym okresie', CNoImage));
  xExpenses.Add(THelperElement.Create(True, 'Przychody wed³ug kategorii' , '3_02', 'Pokazuje operacje przychodowe w rozbiciu na kategorie', CNoImage));
  xExpenses.Add(THelperElement.Create(True, 'Przychody wed³ug kontrahentów' , '3_03', 'Pokazuje operacje przychodowe w rozbiciu na kontrahentów', CNoImage));
  xExpenses.Add(THelperElement.Create(True, 'Œrednie przychody' , '3_04', 'Pokazuje œrednie przychody w wybranym okresie', CNoImage));

  xOthers := THelperElement.Create(False, 'Inne', '4', '', CNoImage);
  xOthers.Add(THelperElement.Create(True, 'Bilans' , '4_01', 'Pokazuje bilans wybranego okresu', CNoImage));
  xOthers.Add(THelperElement.Create(True, 'Trendy rozchodów i przychodów' , '4_02', 'Pokazuje trendy rozchodów i przychodów dla wybranego okresu', CNoImage));

  FTreeHelper.Add(xOthers);
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
  if AGid = '1_01' then begin
    Result := TAccountBalanceOnDayReport;
  end else if AGid = '1_02' then begin
    Result := TDoneOperationsListReport;
  end else if AGid = '1_03' then begin
    Result := TPlannedOperationsListReport;
  end else if AGid = '1_04' then begin
    Result := TCashFlowListReport;
  end else begin
    Result := Nil;
  end;
end;

end.
