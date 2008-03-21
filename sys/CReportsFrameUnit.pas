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
    FisPrivate: Boolean;
    FreportClass: TCReportClass;
    FreportParams: TCReportParams;
    Fname: String;
    Fdesc: String;
    Fimage: Integer;
    Fid: TDataGid;
  public
    constructor CreatePrivate(AName: String; AReportClass: TCReportClass; AReportParams: TCReportParams; ADesc: String; AImage: Integer; AId: TDataGid);
    constructor CreateReport(AName: String; AReportClass: TCReportClass; AReportParams: TCReportParams; ADesc: String; AImage: Integer);
    constructor CreateGroup(AName: String; ADesc: String; AImage: Integer);
    function GetColumnImage(AColumnIndex: Integer): Integer; override;
    function GetElementHint(AColumnIndex: Integer): String; override;
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String; override;
    function GetElementId: String; override;
    function GetElementType: String; override;
    function GetElementText: String; override;
    procedure GetElementReload; override;
    function GetElementCompare(AColumnIndex: Integer; ACompareWith: TCDataListElementObject; AViewTextSelector: String): Integer; override;
    destructor Destroy; override;
  published
    property isReport: Boolean read FisReport;
    property reportClass: TCReportClass read FreportClass;
    property reportParams: TCReportParams read FreportParams;
    property isPrivate: Boolean read FisPrivate;
    property id: TDataGid read Fid;
  end;

  TCReportsFrame = class(TCBaseFrame)
    ActionList: TActionList;
    ActionExecute: TAction;
    VTHeaderPopupMenu: TVTHeaderPopupMenu;
    PanelFrameButtons: TPanel;
    CButtonExecute: TCButton;
    List: TCDataList;
    Bevel: TBevel;
    ActionAdd: TAction;
    ActionEdit: TAction;
    ActionDel: TAction;
    CButton1: TCButton;
    CButton2: TCButton;
    CButton3: TCButton;
    PopupMenuIcons: TPopupMenu;
    MenuItemBigIcons: TMenuItem;
    MenuItemSmallIcons: TMenuItem;
    procedure ListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure ListDblClick(Sender: TObject);
    procedure ActionExecuteExecute(Sender: TObject);
    procedure ListCDataListReloadTree(Sender: TCDataList; ARootElement: TCListDataElement);
    procedure ActionAddExecute(Sender: TObject);
    procedure ActionEditExecute(Sender: TObject);
    procedure ActionDelExecute(Sender: TObject);
    procedure ListGetRowPreferencesName(AHelper: TObject; var APrefname: String);
    procedure MenuItemBigIconsClick(Sender: TObject);
    procedure MenuItemSmallIconsClick(Sender: TObject);
  private
  private
    FSmallIconsButtonsImageList: TPngImageList;
    FBigIconsButtonsImageList: TPngImageList;
    FPrivateList: TDataObjectList;
    FPrivateElement: TCListDataElement;
    procedure ReloadPrivate(ARootElement: TCListDataElement);
  protected
    procedure WndProc(var Message: TMessage); override;
    procedure MessageMovementAdded(AId: TDataGid; AOptions: Integer); virtual;
    procedure MessageMovementEdited(AId: TDataGid; AOptions: Integer); virtual;
    procedure MessageMovementDeleted(AId: TDataGid; AOptions: Integer); virtual;
  public
    function GetList: TCList; override;
    class function GetTitle: String; override;
    procedure InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean); override;
    procedure FinalizeFrame; override;
    class function GetPrefname: String; override;
    procedure UpdateIcons;
  end;

implementation

uses CDataObjects, CFrameFormUnit, CProductFormUnit, CConfigFormUnit, CInfoFormUnit, CConsts,
  CPlugins, CPluginConsts, CTools, CReportDefFormUnit, CPreferences,
  StrUtils;

{$R *.dfm}

const CNoImage = -1;
      CHtmlReportImage = 0;
      CChartReportImage = 1;
      CBarReportImage = 2;
      CLineReportImage = 3;
      CPluginReportImage = 4;

procedure TCReportsFrame.ListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
begin
  if Node <> Nil then begin
    CButtonExecute.Enabled := TReportListElement(List.GetTreeElement(Node).Data).isReport;
    CButton2.Enabled := TReportListElement(List.GetTreeElement(Node).Data).isPrivate;
    CButton3.Enabled := TReportListElement(List.GetTreeElement(Node).Data).isPrivate;
  end else begin
    CButtonExecute.Enabled := False;
    CButton2.Enabled := False;
    CButton3.Enabled := False;
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

constructor TReportListElement.CreatePrivate(AName: String; AReportClass: TCReportClass; AReportParams: TCReportParams; ADesc: String; AImage: Integer; AId: TDataGid);
begin
  CreateReport(AName, AReportClass, AReportParams, ADesc, AImage);
  FisPrivate := True;
  Fid := AId;
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
  FisPrivate := False;
  Fid := CEmptyDataGid;
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

function TReportListElement.GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String;
begin
  Result := Fname;
end;

function TReportListElement.GetElementCompare(AColumnIndex: Integer; ACompareWith: TCDataListElementObject; AViewTextSelector: String): Integer;
begin
  Result := AnsiCompareStr(GetColumnText(AColumnIndex, False, AViewTextSelector), ACompareWith.GetColumnText(AColumnIndex, False, AViewTextSelector));
end;

function TReportListElement.GetElementHint(AColumnIndex: Integer): String;
begin
  Result := Fdesc;
end;

function TReportListElement.GetElementId: String;
begin
  Result := Fid;
end;

procedure TCReportsFrame.ListCDataListReloadTree(Sender: TCDataList; ARootElement: TCListDataElement);
var xBase: TCListDataElement;
    xStats: TCListDataElement;
    xOthers: TCListDataElement;
    xBs, xTm: TCListDataElement;
    xCount: Integer;
    xPlugin: TCPlugin;
begin
  xBase := TCListDataElement.Create(False, List, TReportListElement.CreateGroup('Podstawowe', '', CNoImage), True);
  ARootElement.Add(xBase);
  xBase.Add(TCListDataElement.Create(False, List, TReportListElement.CreateReport('Stan kont' , TAccountBalanceOnDayReport, Nil, 'Pokazuje stan wszystkich kont na wybrany dzieñ', CHtmlReportImage), True));
  xBase.Add(TCListDataElement.Create(False, List, TReportListElement.CreateReport('Operacje wykonane' , TDoneOperationsListReport, Nil, 'Pokazuje operacje wykonane w wybranym okresie', CHtmlReportImage), True));
  xBase.Add(TCListDataElement.Create(False, List, TReportListElement.CreateReport('Operacje zaplanowane' , TPlannedOperationsListReport, Nil, 'Pokazuje operacje zaplanowane na wybrany okres', CHtmlReportImage), True));
  xBase.Add(TCListDataElement.Create(False, List, TReportListElement.CreateReport('Przep³yw gotówki' , TCashFlowListReport, Nil, 'Pokazuje przep³yw gotówki miêdzy kontami/kontrahentami w wybranym okresie', CHtmlReportImage), True));
  xBase.Add(TCListDataElement.Create(False, List, TReportListElement.CreateReport('Historia konta' , TAccountHistoryReport, Nil, 'Pokazuje historiê wybranego konta w wybranym okresie', CHtmlReportImage), True));
  xBase.Add(TCListDataElement.Create(False, List, TReportListElement.CreateReport('Historia kontrahenta' , TCPHistoryReport, TCReportParams.CreateAco(CGroupByCashpoint), 'Pokazuje historiê wybranego kontrahenta w wybranym okresie', CHtmlReportImage), True));
  xBase.Add(TCListDataElement.Create(False, List, TReportListElement.CreateReport('Historia kategorii' , TCPHistoryReport, TCReportParams.CreateAco(CGroupByProduct), 'Pokazuje historiê wybranego kategorii w wybranym okresie', CHtmlReportImage), True));
  xBase.Add(TCListDataElement.Create(False, List, TReportListElement.CreateReport('Wykres stanu kont' , TAccountBalanceChartReport, Nil, 'Pokazuje wykres stanu kont w wybranym okresie', CLineReportImage), True));
  xBase.Add(TCListDataElement.Create(False, List, TReportListElement.CreateReport('Sumy przychodów i rozchodów' , TCashSumReportChart, TCSelectedMovementTypeParams.Create(CInMovement + COutMovement), 'Pokazuje sumy przychodów\rozchodów w wybranym okresie', CBarReportImage), True));
  xBs := TCListDataElement.Create(False, List, TReportListElement.CreateGroup('Rozchody', '', CNoImage), True);
  ARootElement.Add(xBs);
  xBs.Add(TCListDataElement.Create(False, List, TReportListElement.CreateReport('Lista operacji rozchodowych' , TOperationsListReport, TCSelectedMovementTypeParams.Create(COutMovement), 'Pokazuje operacje rozchodowe w wybranym okresie', CHtmlReportImage), True));
  xTm := TCListDataElement.Create(False, List, TReportListElement.CreateGroup('w/g kategorii', '', CNoImage), True);
  xBs.Add(xTm);
  xTm.Add(TCListDataElement.Create(False, List, TReportListElement.CreateReport('Wykres rozchodów' , TOperationsByCategoryChart, TCSelectedMovementTypeParams.Create(COutMovement), 'Pokazuje operacje rozchodowe w rozbiciu na kategorie', CChartReportImage), True));
  xTm.Add(TCListDataElement.Create(False, List, TReportListElement.CreateReport('Lista rozchodów' , TOperationsByCategoryList, TCSelectedMovementTypeParams.Create(COutMovement), 'Pokazuje operacje rozchodowe w rozbiciu na kategorie', CHtmlReportImage), True));
  xTm.Add(TCListDataElement.Create(False, List, TReportListElement.CreateReport('Drzewo rozchodów' , TOperationsTreeCategoryList, TCSelectedMovementTypeParams.Create(COutMovement), 'Pokazuje sumy operacji rozchodowych w drzewie kategorii', CHtmlReportImage), True));
  xTm := TCListDataElement.Create(False, List, TReportListElement.CreateGroup('w/g kontrahentów', '', CNoImage), True);
  xBs.Add(xTm);
  xTm.Add(TCListDataElement.Create(False, List, TReportListElement.CreateReport('Wykres rozchodów' , TOperationsByCashpointChart, TCSelectedMovementTypeParams.Create(COutMovement), 'Pokazuje operacje rozchodowe w rozbiciu na kontrahentów', CChartReportImage), True));
  xTm.Add(TCListDataElement.Create(False, List, TReportListElement.CreateReport('Lista rozchodów' , TOperationsByCashpointList, TCSelectedMovementTypeParams.Create(COutMovement), 'Pokazuje operacje rozchodowe w rozbiciu na kontrahentów', CHtmlReportImage), True));
  xTm := TCListDataElement.Create(False, List, TReportListElement.CreateGroup('Sumy', '', CNoImage), True);
  xBs.Add(xTm);
  xTm.Add(TCListDataElement.Create(False, List, TReportListElement.CreateReport('Wykres sum rozchodów' , TSumBySomethingChart, TCSelectedMovementTypeParams.Create(COutMovement), 'Pokazuje sumy rozchodów w wybranym okresie', CBarReportImage), True));
  xTm.Add(TCListDataElement.Create(False, List, TReportListElement.CreateReport('Lista sum rozchodów' , TSumBySomethingList, TCSelectedMovementTypeParams.Create(COutMovement), 'Pokazuje sumy rozchodów w wybranym okresie', CHtmlReportImage), True));
  xTm.Add(TCListDataElement.Create(False, List, TReportListElement.CreateReport('Sumy kwotowe rozchodów dla kont' , TCashSumReportList, TCSelectedMovementTypeParams.CreateAcpType(CGroupByAccount, COutMovement), 'Pokazuje sumy rozchodów w wybranym okresie', CHtmlReportImage), True));
  xTm.Add(TCListDataElement.Create(False, List, TReportListElement.CreateReport('Sumy iloœciowe rozchodów' , TQuantitySumReportList, TCSelectedMovementTypeParams.CreateAcpType(CGroupByProduct, COutMovement), 'Pokazuje sumy iloœciowe rozchodów w wybranym okresie', CHtmlReportImage), True));
  xBs := TCListDataElement.Create(False, List, TReportListElement.CreateGroup('Przychody', '', CNoImage), True);
  ARootElement.Add(xBs);
  xBs.Add(TCListDataElement.Create(False, List, TReportListElement.CreateReport('Lista operacji przychodowych' , TOperationsListReport, TCSelectedMovementTypeParams.Create(CInMovement), 'Pokazuje operacje przychodowe w wybranym okresie', CHtmlReportImage), True));
  xTm := TCListDataElement.Create(False, List, TReportListElement.CreateGroup('w/g kategorii', '', CNoImage), True);
  xBs.Add(xTm);
  xTm.Add(TCListDataElement.Create(False, List, TReportListElement.CreateReport('Wykres przychodów' , TOperationsByCategoryChart, TCSelectedMovementTypeParams.Create(CInMovement), 'Pokazuje operacje przychodowe w rozbiciu na kategorie', CChartReportImage), True));
  xTm.Add(TCListDataElement.Create(False, List, TReportListElement.CreateReport('Lista przychodów' , TOperationsByCategoryList, TCSelectedMovementTypeParams.Create(CInMovement), 'Pokazuje operacje przychodowe w rozbiciu na kategorie', CHtmlReportImage), True));
  xTm.Add(TCListDataElement.Create(False, List, TReportListElement.CreateReport('Drzewo rozchodów' , TOperationsTreeCategoryList, TCSelectedMovementTypeParams.Create(COutMovement), 'Pokazuje sumy operacji rozchodowych w drzewie kategorii', CHtmlReportImage), True));
  xTm := TCListDataElement.Create(False, List, TReportListElement.CreateGroup('w/g kontrahentów', '', CNoImage), True);
  xBs.Add(xTm);
  xTm.Add(TCListDataElement.Create(False, List, TReportListElement.CreateReport('Wykres przychodów' , TOperationsByCashpointChart, TCSelectedMovementTypeParams.Create(CInMovement), 'Pokazuje operacje przychodowe w rozbiciu na kontrahentów', CChartReportImage), True));
  xTm.Add(TCListDataElement.Create(False, List, TReportListElement.CreateReport('Lista przychodów' , TOperationsByCashpointList, TCSelectedMovementTypeParams.Create(CInMovement), 'Pokazuje operacje przychodowe w rozbiciu na kontrahentów', CHtmlReportImage), True));
  xTm := TCListDataElement.Create(False, List, TReportListElement.CreateGroup('Sumy', '', CNoImage), True);
  xBs.Add(xTm);
  xTm.Add(TCListDataElement.Create(False, List, TReportListElement.CreateReport('Wykres sum przychodów' , TSumBySomethingChart, TCSelectedMovementTypeParams.Create(CInMovement), 'Pokazuje sumy przychodów w wybranym okresie', CBarReportImage), True));
  xTm.Add(TCListDataElement.Create(False, List, TReportListElement.CreateReport('Lista sum przychodów' , TSumBySomethingList, TCSelectedMovementTypeParams.Create(CInMovement), 'Pokazuje sumy przychodów w wybranym okresie', CHtmlReportImage), True));
  xTm.Add(TCListDataElement.Create(False, List, TReportListElement.CreateReport('Sumy kwotowe przychodów dla kont' , TCashSumReportList, TCSelectedMovementTypeParams.CreateAcpType(CGroupByAccount, CInMovement), 'Pokazuje sumy przychodów w wybranym okresie', CHtmlReportImage), True));
  xTm.Add(TCListDataElement.Create(False, List, TReportListElement.CreateReport('Sumy iloœciowe przychodów' , TQuantitySumReportList, TCSelectedMovementTypeParams.CreateAcpType(CGroupByProduct, CInMovement), 'Pokazuje sumy iloœciowe przychodów w wybranym okresie', CHtmlReportImage), True));
  xStats := TCListDataElement.Create(False, List, TReportListElement.CreateGroup('Statystyki', '', CNoImage), True);
  ARootElement.Add(xStats);
  xStats.Add(TCListDataElement.Create(False, List, TReportListElement.CreateReport('Œrednie' , TAveragesReport, Nil, 'Pokazuje œrednie rozchody/przychody w wybranym okresie', CHtmlReportImage), True));
  xStats.Add(TCListDataElement.Create(False, List, TReportListElement.CreateReport('Prognozy' , TFuturesReport, Nil,  'Pokazuje prognozy rozchodów i przychodów dla wybranego okresu', CHtmlReportImage), True));
  xStats.Add(TCListDataElement.Create(False, List, TReportListElement.CreateReport('Podsumowanie' , TPeriodSumsReport, Nil, 'Pokazuje podsumowanie statystyczne wybranego okresu', CHtmlReportImage), True));
  xOthers := TCListDataElement.Create(False, List, TReportListElement.CreateGroup('Ró¿ne', '', CNoImage), True);
  ARootElement.Add(xOthers);
  xOthers.Add(TCListDataElement.Create(False, List, TReportListElement.CreateReport('Historia wybranej waluty' , TCurrencyRatesHistoryReport, Nil, 'Pokazuje historiê waluty w/g wybranego kontrahenta w zadanym okresis', CLineReportImage), True));
  xOthers.Add(TCListDataElement.Create(False, List, TReportListElement.CreateReport('Lista kursów wybranej waluty' , TCurrencyRatesListReport, Nil, 'Pokazuje historiê waluty w/g wybranego kontrahenta w zadanym okresis', CHtmlReportImage), True));
  xOthers.Add(TCListDataElement.Create(False, List, TReportListElement.CreateReport('Lista notowañ wybranego instrumentu inwestycyjnego' , TInstrumentValueListReport, Nil, 'Pokazuje historiê instrumentu w zadanym okresis', CHtmlReportImage), True));
  xOthers.Add(TCListDataElement.Create(False, List, TReportListElement.CreateReport('Wykres notowañ wybranego instrumentu inwestycyjnego' , TInstrumentValueChartReport, Nil, 'Pokazuje historiê instrumentu w zadanym okresis', CLineReportImage), True));
  for xCount := 0 to GPlugins.Count - 1 do begin
    xPlugin := TCPlugin(GPlugins.Items[xCount]);
    if xPlugin.isTypeof[CPLUGINTYPE_HTMLREPORT] then begin
      xOthers.Add(TCListDataElement.Create(False, List, TReportListElement.CreateReport(xPlugin.pluginMenu, TPluginHtmlReport, TCPluginReportParams.Create(xPlugin), xPlugin.pluginDescription, CPluginReportImage), True));
    end else if xPlugin.isTypeof[CPLUGINTYPE_CHARTREPORT] then begin
      xOthers.Add(TCListDataElement.Create(False, List, TReportListElement.CreateReport(xPlugin.pluginMenu, TPluginChartReport, TCPluginReportParams.Create(xPlugin), xPlugin.pluginDescription, CPluginReportImage), True));
    end;
  end;
  ReloadPrivate(ARootElement);
end;

procedure TReportListElement.GetElementReload;
var xDef: TReportDef;
begin
  xDef := TReportDef(TReportDef.LoadObject(ReportDefProxy, id, False));
  Fname := xDef.name;
  Fdesc := xDef.description;
end;

function TReportListElement.GetElementText: String;
begin
end;

function TReportListElement.GetElementType: String;
begin
  Result := ClassName;
end;

procedure TCReportsFrame.InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean);
begin
  inherited InitializeFrame(AOwner, AAdditionalData, AOutputData, AMultipleCheck, AWithButtons);
  FBigIconsButtonsImageList := TPngImageList(ActionList.Images);
  if List.ViewPref <> Nil then begin
    MenuItemSmallIcons.Checked := List.ViewPref.ButtonSmall;
    UpdateIcons;
  end;
  List.RootElement.FreeDataOnClear := True;
  List.ReloadTree;
  ListFocusChanged(List, List.FocusedNode, 0);  
end;

procedure TCReportsFrame.ReloadPrivate(ARootElement: TCListDataElement);
var xCount: Integer;
    xDef: TReportDef;
begin
  GDataProvider.BeginTransaction;
  FPrivateList := TReportDef.GetAllObjects(ReportDefProxy);
  FPrivateElement := TCListDataElement.Create(False, List, TReportListElement.CreateGroup('W³asne', '', CNoImage), True);
  ARootElement.Add(FPrivateElement);
  for xCount := 0 to FPrivateList.Count - 1 do begin
    xDef := TReportDef(FPrivateList.Items[xCount]);
    FPrivateElement.AppendDataElement(TCListDataElement.Create(False, List, TReportListElement.CreatePrivate(xDef.name, TPrivateReport, TCWithGidParams.Create(xDef.id), xDef.description, CHtmlReportImage, xDef.id), True));
  end;
  GDataProvider.RollbackTransaction;
end;

procedure TCReportsFrame.FinalizeFrame;
begin
  if FSmallIconsButtonsImageList <> Nil then begin
    FSmallIconsButtonsImageList.Free;
  end;
  FPrivateList.Free;
  inherited FinalizeFrame;
end;

procedure TCReportsFrame.ActionAddExecute(Sender: TObject);
var xForm: TCReportDefForm;
begin
  xForm := TCReportDefForm.Create(Nil);
  xForm.ShowDataobject(coAdd, ReportDefProxy, Nil, True);
  xForm.Free;
end;

procedure TCReportsFrame.ActionEditExecute(Sender: TObject);
var xForm: TCReportDefForm;
begin
  if List.FocusedNode <> Nil then begin
    xForm := TCReportDefForm.Create(Nil);
    xForm.ShowDataobject(coEdit, ReportDefProxy, FPrivateList.ObjectById[TReportListElement(List.SelectedElement.Data).id], True);
    xForm.Free;
  end;
end;

procedure TCReportsFrame.ActionDelExecute(Sender: TObject);
var xId: TDataGid;
begin
  if List.FocusedNode <> Nil then begin
    if ShowInfo(itQuestion, 'Czy chcesz usun¹æ wybran¹ definicjê raportu ?', '') then begin
      xId := TReportListElement(List.SelectedElement.Data).id;
      FPrivateList.ObjectById[xId].DeleteObject;
      GDataProvider.CommitTransaction;
      SendMessageToFrames(TCReportsFrame, WM_DATAOBJECTDELETED, Integer(@xId), 0);
    end;
  end;
end;

procedure TCReportsFrame.MessageMovementAdded(AId: TDataGid; AOptions: Integer);
var xDataobject: TReportDef;
    xElement: TCListDataElement;
begin
  xDataobject := TReportDef(TReportDef.LoadObject(ReportDefProxy, AId, True));
  FPrivateList.Add(xDataobject);
  xElement := TCListDataElement.Create(False, List, TReportListElement.CreatePrivate(xDataobject.name, TPrivateReport, TCWithGidParams.Create(xDataobject.id), xDataobject.description, CHtmlReportImage, xDataobject.id), True);
  List.FocusedNode := FPrivateElement.AppendDataElement(xElement);
end;

procedure TCReportsFrame.MessageMovementDeleted(AId: TDataGid; AOptions: Integer);
begin
  FPrivateElement.DeleteDataElement(AId, TReportListElement.ClassName);
end;

procedure TCReportsFrame.MessageMovementEdited(AId: TDataGid; AOptions: Integer);
var xElement: TCListDataElement;
begin
  xElement := FPrivateElement.FindDataElement(AId, TReportListElement.ClassName);
  if xElement <> Nil then begin
    FPrivateElement.RefreshDataElement(AId, TReportListElement.ClassName);
  end;
end;

procedure TCReportsFrame.WndProc(var Message: TMessage);
var xDataGid: TDataGid;
begin
  inherited WndProc(Message);
  with Message do begin
    if Msg = WM_DATAOBJECTADDED then begin
      xDataGid := PDataGid(WParam)^;
      MessageMovementAdded(xDataGid, LParam);
    end else if Msg = WM_DATAOBJECTEDITED then begin
      xDataGid := PDataGid(WParam)^;
      MessageMovementEdited(xDataGid, LParam);
    end else if Msg = WM_DATAOBJECTDELETED then begin
      xDataGid := PDataGid(WParam)^;
      MessageMovementDeleted(xDataGid, LParam);
    end;
  end;
end;

class function TCReportsFrame.GetPrefname: String;
begin
  Result := 'reportsFrame';
end;

procedure TCReportsFrame.ListGetRowPreferencesName(AHelper: TObject; var APrefname: String);
begin
  APrefname := IfThen(TReportListElement(TCListDataElement(AHelper).Data).isReport, 'R', 'G');
end;

procedure TCReportsFrame.MenuItemBigIconsClick(Sender: TObject);
begin
  if not MenuItemBigIcons.Checked then begin
    MenuItemBigIcons.Checked := True;
    if List.ViewPref <> Nil then begin
      List.ViewPref.ButtonSmall := False;
    end;
    UpdateIcons;
  end;
end;

procedure TCReportsFrame.MenuItemSmallIconsClick(Sender: TObject);
begin
  if not MenuItemSmallIcons.Checked then begin
    MenuItemSmallIcons.Checked := True;
    if List.ViewPref <> Nil then begin
      List.ViewPref.ButtonSmall := True;
    end;
    UpdateIcons;
  end;
end;

procedure TCReportsFrame.UpdateIcons;
var xDummy: TPngImageList;
begin
  xDummy := Nil;
  UpdatePanelIcons(PanelFrameButtons,
                   MenuItemBigIcons, MenuItemSmallIcons,
                   FBigIconsButtonsImageList, Nil,
                   ActionList, Nil,
                   FSmallIconsButtonsImageList,
                   xDummy);
end;

end.
