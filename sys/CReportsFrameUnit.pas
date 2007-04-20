unit CReportsFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, ImgList, ExtCtrls, VirtualTrees, Menus,
  VTHeaderPopup, ActnList, CComponents, CDatabase, Contnrs, GraphUtil,
  StdCtrls, CReports, PngImageList, CImageListsUnit;

type
  TReportListElement = class(TCDataListElementObject)
  private
    FisReport: Boolean;
    FreportClass: TCReportClass;
    FreportParams: TCReportParams;
    Fname: String;
    Fdesc: String;
    Fimage: Integer;
  public
    constructor CreateReport(AName: String; AReportClass: TCReportClass; AReportParams: TCReportParams; ADesc: String; AImage: Integer);
    constructor CreateGroup(AName: String; ADesc: String; AImage: Integer);
    function GetColumnImage(AColumnIndex: Integer): Integer; override;
    function GetElementHint(AColumnIndex: Integer): String; override;
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean): String; override;
    function GetElementId: String; override;
    function GetElementType: String; override;
    function GetElementText: String; override;
    procedure GetElementReload; override;
    function GetElementCompare(AColumnIndex: Integer; ACompareWith: TCDataListElementObject): Integer; override;
    destructor Destroy; override;
  published
    property isReport: Boolean read FisReport;
    property reportClass: TCReportClass read FreportClass;
    property reportParams: TCReportParams read FreportParams;
  end;

  TCReportsFrame = class(TCBaseFrame)
    ActionList: TActionList;
    ActionExecute: TAction;
    VTHeaderPopupMenu: TVTHeaderPopupMenu;
    PanelFrameButtons: TPanel;
    CButtonExecute: TCButton;
    List: TCDataList;
    Bevel: TBevel;
    procedure ListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure ListDblClick(Sender: TObject);
    procedure ActionExecuteExecute(Sender: TObject);
    procedure ListCDataListReloadTree(Sender: TCDataList; ARootElement: TCListDataElement);
  public
    function GetList: TCList; override;
    class function GetTitle: String; override;
    procedure InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList); override;
  end;

implementation

uses CDataObjects, CFrameFormUnit, CProductFormUnit, CConfigFormUnit, CInfoFormUnit, CConsts;

{$R *.dfm}

const CNoImage = -1;
      CHtmlReportImage = 0;
      CChartReportImage = 1;
      CLineReportImage = 2;

procedure TCReportsFrame.ListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
begin
  if Node <> Nil then begin
    CButtonExecute.Enabled := TReportListElement(List.GetTreeElement(Node).Data).isReport;
  end else begin
    CButtonExecute.Enabled := False;
  end;
end;

class function TCReportsFrame.GetTitle: String;
begin
  Result := 'Raporty';
end;

procedure TCReportsFrame.ListDblClick(Sender: TObject);
begin
  if List.FocusedNode <> Nil then begin
    if CButtonExecute.Enabled then begin
      ActionExecute.Execute;
    end;
  end;
end;

function TCReportsFrame.GetList: TCList;
begin
  Result := List;
end;

procedure TCReportsFrame.ActionExecuteExecute(Sender: TObject);
var xData: TReportListElement;
    xReport: TCBaseReport;
begin
  xData := TReportListElement(List.SelectedElement.Data);
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

constructor TReportListElement.CreateGroup(AName: String; ADesc: String; AImage: Integer);
begin
  inherited Create;
  Fname := AName;
  Fdesc := ADesc;
  FisReport := False;
  Fimage := AImage;
  FreportParams := Nil;
  FreportClass := Nil;
end;

constructor TReportListElement.CreateReport(AName: String; AReportClass: TCReportClass; AReportParams: TCReportParams; ADesc: String; AImage: Integer);
begin
  inherited Create;
  Fname := AName;
  Fdesc := ADesc;
  FisReport := True;
  Fimage := AImage;
  FreportParams := AReportParams;
  FreportClass := AReportClass;
end;

destructor TReportListElement.Destroy;
begin
  if FreportParams <> Nil then begin
    FreportParams.Free;
  end;
  inherited Destroy;
end;

function TReportListElement.GetColumnImage(AColumnIndex: Integer): Integer;
begin
  Result := Fimage;
end;

function TReportListElement.GetColumnText(AColumnIndex: Integer; AStatic: Boolean): String;
begin
  Result := Fname;
end;

function TReportListElement.GetElementCompare(AColumnIndex: Integer; ACompareWith: TCDataListElementObject): Integer;
begin
  Result := AnsiCompareStr(GetColumnText(AColumnIndex, False), ACompareWith.GetColumnText(AColumnIndex, False));
end;

function TReportListElement.GetElementHint(AColumnIndex: Integer): String;
begin
  Result := Fdesc;
end;

function TReportListElement.GetElementId: String;
begin
  Result := Fname;
end;

procedure TCReportsFrame.ListCDataListReloadTree(Sender: TCDataList; ARootElement: TCListDataElement);
var xBase: TCListDataElement;
    xStats: TCListDataElement;
    xOthers: TCListDataElement;
    xBs, xTm: TCListDataElement;
begin
  xBase := TCListDataElement.Create(List, TReportListElement.CreateGroup('Podstawowe', '', CNoImage), True);
  ARootElement.Add(xBase);
  xBase.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Stan kont' , TAccountBalanceOnDayReport, Nil, 'Pokazuje stan wszystkich kont na wybrany dzieñ', CHtmlReportImage), True));
  xBase.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Operacje wykonane' , TDoneOperationsListReport, Nil, 'Pokazuje operacje wykonane w wybranym okresie', CHtmlReportImage), True));
  xBase.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Operacje zaplanowane' , TPlannedOperationsListReport, Nil, 'Pokazuje operacje zaplanowane na wybrany okres', CHtmlReportImage), True));
  xBase.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Przep³yw gotówki' , TCashFlowListReport, Nil, 'Pokazuje przep³yw gotówki miêdzy kontami/kontrahentami w wybranym okresie', CHtmlReportImage), True));
  xBase.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Historia konta' , TAccountHistoryReport, Nil, 'Pokazuje historiê wybranego konta w wybranym okresie', CHtmlReportImage), True));
  xBase.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Wykres stanu kont' , TAccountBalanceChartReport, Nil, 'Pokazuje wykres stanu kont w wybranym okresie', CLineReportImage), True));
  xBase.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Sumy przychodów i rozchodów' , TSumReportChart, TCSelectedMovementTypeParams.Create(CInMovement + COutMovement), 'Pokazuje sumy przychodów\rozchodów w wybranym okresie', CLineReportImage), True));
  xBs := TCListDataElement.Create(List, TReportListElement.CreateGroup('Rozchody', '', CNoImage), True);
  ARootElement.Add(xBs);
  xBs.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Lista operacji rozchodowych' , TOperationsListReport, TCSelectedMovementTypeParams.Create(COutMovement), 'Pokazuje operacje rozchodowe w wybranym okresie', CHtmlReportImage), True));
  xTm := TCListDataElement.Create(List, TReportListElement.CreateGroup('w/g kategorii', '', CNoImage), True);
  xBs.Add(xTm);
  xTm.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Wykres rozchodów' , TOperationsByCategoryChart, TCSelectedMovementTypeParams.Create(COutMovement), 'Pokazuje operacje rozchodowe w rozbiciu na kategorie', CChartReportImage), True));
  xTm.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Lista rozchodów' , TOperationsByCategoryList, TCSelectedMovementTypeParams.Create(COutMovement), 'Pokazuje operacje rozchodowe w rozbiciu na kategorie', CHtmlReportImage), True));
  xTm := TCListDataElement.Create(List, TReportListElement.CreateGroup('w/g kontrahentów', '', CNoImage), True);
  xBs.Add(xTm);
  xTm.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Wykres rozchodów' , TOperationsByCashpointChart, TCSelectedMovementTypeParams.Create(COutMovement), 'Pokazuje operacje rozchodowe w rozbiciu na kontrahentów', CChartReportImage), True));
  xTm.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Lista rozchodów' , TOperationsByCashpointList, TCSelectedMovementTypeParams.Create(COutMovement), 'Pokazuje operacje rozchodowe w rozbiciu na kontrahentów', CHtmlReportImage), True));
  xTm := TCListDataElement.Create(List, TReportListElement.CreateGroup('Sumy', '', CNoImage), True);
  xBs.Add(xTm);
  xTm.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Wykres sum rozchodów' , TSumReportChart, TCSelectedMovementTypeParams.Create(COutMovement), 'Pokazuje sumy rozchodów w wybranym okresie', CLineReportImage), True));
  xTm.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Lista sum rozchodów' , TSumReportList, TCSelectedMovementTypeParams.Create(COutMovement), 'Pokazuje sumy rozchodów w wybranym okresie', CHtmlReportImage), True));
  xBs := TCListDataElement.Create(List, TReportListElement.CreateGroup('Przychody', '', CNoImage), True);
  ARootElement.Add(xBs);
  xBs.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Lista operacji przychodowych' , TOperationsListReport, TCSelectedMovementTypeParams.Create(CInMovement), 'Pokazuje operacje przychodowe w wybranym okresie', CHtmlReportImage), True));
  xTm := TCListDataElement.Create(List, TReportListElement.CreateGroup('w/g kategorii', '', CNoImage), True);
  xBs.Add(xTm);
  xTm.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Wykres przychodów' , TOperationsByCategoryChart, TCSelectedMovementTypeParams.Create(CInMovement), 'Pokazuje operacje przychodowe w rozbiciu na kategorie', CChartReportImage), True));
  xTm.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Lista przychodów' , TOperationsByCategoryList, TCSelectedMovementTypeParams.Create(CInMovement), 'Pokazuje operacje przychodowe w rozbiciu na kategorie', CHtmlReportImage), True));
  xTm := TCListDataElement.Create(List, TReportListElement.CreateGroup('w/g kontrahentów', '', CNoImage), True);
  xBs.Add(xTm);
  xTm.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Wykres przychodów' , TOperationsByCashpointChart, TCSelectedMovementTypeParams.Create(CInMovement), 'Pokazuje operacje przychodowe w rozbiciu na kontrahentów', CChartReportImage), True));
  xTm.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Lista przychodów' , TOperationsByCashpointList, TCSelectedMovementTypeParams.Create(CInMovement), 'Pokazuje operacje przychodowe w rozbiciu na kontrahentów', CHtmlReportImage), True));
  xTm := TCListDataElement.Create(List, TReportListElement.CreateGroup('Sumy', '', CNoImage), True);
  xBs.Add(xTm);
  xTm.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Wykres sum przychodów' , TSumReportChart, TCSelectedMovementTypeParams.Create(CInMovement), 'Pokazuje sumy przychodów w wybranym okresie', CLineReportImage), True));
  xTm.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Lista sum przychodów' , TSumReportList, TCSelectedMovementTypeParams.Create(CInMovement), 'Pokazuje sumy przychodów w wybranym okresie', CHtmlReportImage), True));
  xStats := TCListDataElement.Create(List, TReportListElement.CreateGroup('Statystyki', '', CNoImage), True);
  ARootElement.Add(xStats);
  xStats.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Œrednie' , TAveragesReport, Nil, 'Pokazuje œrednie rozchody/przychody w wybranym okresie', CHtmlReportImage), True));
  xStats.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Prognozy' , TFuturesReport, Nil,  'Pokazuje prognozy rozchodów i przychodów dla wybranego okresu', CHtmlReportImage), True));
  xStats.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Podsumowanie' , TPeriodSumsReport, Nil, 'Pokazuje podsumowanie statystyczne wybranego okresu', CHtmlReportImage), True));
  xOthers := TCListDataElement.Create(List, TReportListElement.CreateGroup('Ró¿ne', '', CNoImage), True);
  ARootElement.Add(xOthers);
  xOthers.Add(TCListDataElement.Create(List, TReportListElement.CreateReport('Historia wybranej waluty' , TCurrencyRatesHistoryReport, Nil, 'Pokazuje historiê waluty w/g wybranego kontrahenta w zadanym okresis', CChartReportImage), True));
end;

procedure TReportListElement.GetElementReload;
begin
end;

function TReportListElement.GetElementText: String;
begin
end;

function TReportListElement.GetElementType: String;
begin
  Result := ClassName;
end;

procedure TCReportsFrame.InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList);
begin
  inherited InitializeFrame(AOwner, AAdditionalData, AOutputData, AMultipleCheck);
  List.RootElement.FreeDataOnClear := True;
  List.ReloadTree;
end;

end.
