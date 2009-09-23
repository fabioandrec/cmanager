unit CChartReportFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CReportFormUnit, StdCtrls, Buttons, ExtCtrls, TeeProcs,
  TeEngine, Chart, Series, ActnList, CComponents, Contnrs, VirtualTrees,
  CImageListsUnit, Menus, StrUtils, Math, Types;

type
  TCChart = class(TChart)
  private
    Fsymbol: String;
    Ftitle: String;
    Fimage: Integer;
    FregSeries: TObjectList;
    FavgSeries: TObjectList;
    FmedSeries: TObjectList;
    FresSeries: TObjectList;
    FsupSeries: TObjectList;
    FweightSeries: TObjectList;
    FgeoSeries: TObjectList;
    function GetIsPie: Boolean;
    function GetIsBar: Boolean;
    function GetIsLin: Boolean;
    function GetIsavgVisible: Boolean;
    function GetIsregVisible: Boolean;
    function GetIsgeoVisible: Boolean;
    function GetIsmedVisible: Boolean;
    function GetIsresVisible: Boolean;
    function GetIssupVisible: Boolean;
    function GetIsweightVisible: Boolean;
    procedure SetIsavgVisible(const Value: Boolean);
    procedure SetIsregVisible(const Value: Boolean);
    procedure SetIsgeotVisible(const Value: Boolean);
    procedure SetIsmedVisible(const Value: Boolean);
    procedure SetIsresVisible(const Value: Boolean);
    procedure SetIssupVisible(const Value: Boolean);
    procedure SetIsweightVisible(const Value: Boolean);
  protected
    function GetSeriesOfClassCount(ASerie: TChartSeries): Integer;
  public
    constructor CreateNew(AOwner: TComponent; ASymbol: String);
    property symbol: String read Fsymbol write Fsymbol;
    property thumbTitle: String read Ftitle write Ftitle;
    property isPie: Boolean read GetIsPie;
    property isBar: Boolean read GetIsBar;
    property isLin: Boolean read GetIsLin;
    property isAvgVisible: Boolean read GetIsavgVisible write SetIsavgVisible;
    property isRegVisible: Boolean read GetIsregVisible write SetIsregVisible;
    property isMedVisible: Boolean read GetIsmedVisible write SetIsmedVisible;
    property isResVisible: Boolean read GetIsresVisible write SetIsresVisible;
    property isSupVisible: Boolean read GetIssupVisible write SetIssupVisible;
    property isWeightVisible: Boolean read GetIsweightVisible write SetIsweightVisible;
    property isGeoVisible: Boolean read GetIsgeoVisible write SetIsgeotVisible;
    property image: Integer read Fimage write Fimage;
    destructor Destroy; override;
  end;

  TChartList = class(TObjectList)
  private
    function GetItems(AIndex: Integer): TCChart;
    procedure SetItems(AIndex: Integer; const Value: TCChart);
    function GetBySymbol(ASymbol: String): TCChart;
  public
    property Items[AIndex: Integer]: TCChart read GetItems write SetItems;
    property BySymbol[ASymbol: String]: TCChart read GetBySymbol;
  end;

  TCChartReportForm = class(TCReportForm)
    PrintDialog: TPrintDialog;
    CButton4: TCButton;
    ActionGraph: TAction;
    PanelThumbs: TCPanel;
    Splitter: TSplitter;
    PanelParent: TCPanel;
    PanelShortcutsTitle: TCPanel;
    PopupMenu1: TPopupMenu;
    MenuItemList: TMenuItem;
    N4: TMenuItem;
    MenuItemBig: TMenuItem;
    MenuItemSmall: TMenuItem;
    PanelChart: TCPanel;
    PanelNoData: TCPanel;
    Panel1: TCPanel;
    ThumbsList: TCList;
    procedure ActionGraphExecute(Sender: TObject);
    procedure ThumbsListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure ThumbsListGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
    procedure ThumbsListHotChange(Sender: TBaseVirtualTree; OldNode, NewNode: PVirtualNode);
    procedure ThumbsListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure ThumbsListGetRowPreferencesName(AHelper: TObject; var APrefname: String);
    procedure MenuItemListClick(Sender: TObject);
    procedure MenuItemBigClick(Sender: TObject);
    procedure MenuItemSmallClick(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
  private
    Fcharts: TChartList;
    FActiveChartIndex: Integer;
    Fprops: TForm;
    function CreateNewChart(ASymbol: String): TCChart;
    procedure SetActiveChartIndex(const Value: Integer);
    function GetActiveChart: TCChart;
  protected
    procedure DoPrint; override;
    procedure DoSave; override;
  public
    constructor CreateForm(AReport: TObject); override;
    procedure UpdateThumbnails;
    destructor Destroy; override;
    function GetChart(ASymbol: String; ACanCreate: Boolean = True): TCChart;
    property ActiveChartIndex: Integer read FActiveChartIndex write SetActiveChartIndex;
    property ActiveChart: TCChart read GetActiveChart;
    property charts: TChartList read Fcharts;
  end;

implementation

uses CChartPropsFormUnit, CReports, CConfigFormUnit, CPreferences,
  CConsts, CListPreferencesFormUnit, CMath;

{$R *.dfm}

function SeriesToDoubleArray(ASerie: TChartSeries): TDoubleDynArray;
var xLength, xCount: Integer;
begin
  xLength := ASerie.Count;
  SetLength(Result, 0);
  for xCount := 0 to xLength - 1 do begin
    if not ASerie.IsNull(xCount) then begin
      SetLength(Result, Length(Result) + 1);
      Result[High(Result)] := ASerie.YValue[xCount];
    end;
  end;
end;

procedure SeriesToXYArrays(ASerie: TChartSeries; var AX, AY: TDoubleDynArray);
var xLength, xCount: Integer;
begin
  xLength := ASerie.Count;
  SetLength(AX, 0);
  SetLength(AY, 0);
  for xCount := 0 to xLength - 1 do begin
    if not ASerie.IsNull(xCount) then begin
      SetLength(AX, Length(AX) + 1);
      SetLength(AY, Length(AY) + 1);
      AX[High(AX)] := ASerie.XValue[xCount];
      AY[High(AY)] := ASerie.YValue[xCount];
    end;
  end;
end;

procedure PrepareAvgSerie(ASourceSerie: TChartSeries; ADestserie: TLineSeries);
var xCount: Integer;
    xSum: Double;
begin
  if ASourceSerie.Count > 0 then begin
    xSum := AvgDoubleArray(SeriesToDoubleArray(ASourceSerie));
    for xCount := 0 to ASourceSerie.Count - 1 do begin
      ADestserie.AddXY(ASourceSerie.XValue[xCount], xSum);
    end;
    ADestserie.Title := ASourceSerie.Title + ' (Œrednie)';
    ADestserie.Marks.Assign(ASourceSerie.Marks);
  end;
end;

procedure PrepareRegSerie(ASourceSerie: TChartSeries; ADestserie: TLineSeries);
var xXVals: TDoubleDynArray;
    xYVals: TDoubleDynArray;
    xA, xB: Double;
    xCount: Integer;
begin
  if ASourceSerie.Count > 0 then begin
    SeriesToXYArrays(ASourceSerie, xXVals, xYVals);
    RegLin(xXVals, xYVals, xA, xB);
    for xCount := Low(xXVals) to High(xXVals) do begin
      ADestserie.AddXY(xXVals[xCount], xA * xXVals[xCount] + xB);
    end;
    ADestserie.Title := ASourceSerie.Title + ' (Linia trendu)';
    ADestserie.Marks.Assign(ASourceSerie.Marks);
  end;
end;

procedure PrepareMedSerie(ASourceSerie: TChartSeries; ADestserie: TLineSeries);
var xSeriesArray: TDoubleDynArray;
    xValue: Double;
    xCount: Integer;
begin
  if ASourceSerie.Count > 0 then begin
    xSeriesArray := SeriesToDoubleArray(ASourceSerie);
    xValue := MedDoubleArray(xSeriesArray);
    for xCount := 0 to ASourceSerie.Count - 1 do begin
      ADestserie.AddXY(ASourceSerie.XValue[xCount], xValue);
    end;
    ADestserie.Title := ASourceSerie.Title + ' (Mediana)';
    ADestserie.Marks.Assign(ASourceSerie.Marks);
  end;
end;

procedure PrepareGeoSerie(ASourceSerie: TChartSeries; ADestserie: TLineSeries);
var xSeriesArray: TDoubleDynArray;
    xValue: Double;
    xCount: Integer;
begin
  if ASourceSerie.Count > 0 then begin
    xSeriesArray := SeriesToDoubleArray(ASourceSerie);
    xValue := GeoDoubleArray(xSeriesArray);
    for xCount := 0 to ASourceSerie.Count - 1 do begin
      ADestserie.AddXY(ASourceSerie.XValue[xCount], xValue);
    end;
    ADestserie.Title := ASourceSerie.Title + ' (Œrednie geometryczne)';
    ADestserie.Marks.Assign(ASourceSerie.Marks);
  end;
end;

procedure PrepareWeightSerie(ASourceSerie: TChartSeries; ADestserie: TLineSeries);
var xSeriesArray: TDoubleDynArray;
    xValue: Double;
    xCount: Integer;
begin
  if ASourceSerie.Count > 0 then begin
    xSeriesArray := SeriesToDoubleArray(ASourceSerie);
    xValue := WeightDoubleArray(xSeriesArray);
    for xCount := 0 to ASourceSerie.Count - 1 do begin
      ADestserie.AddXY(ASourceSerie.XValue[xCount], xValue);
    end;
    ADestserie.Title := ASourceSerie.Title + ' (Œrednie wa¿one)';
    ADestserie.Marks.Assign(ASourceSerie.Marks);
  end;
end;

procedure PrepareResSerie(ASourceSerie: TChartSeries; ADestserie: TLineSeries);
var xXVals: TDoubleDynArray;
    xYVals: TDoubleDynArray;
    xA, xB: Double;
    xCount: Integer;
begin
  if ASourceSerie.Count > 0 then begin
    SeriesToXYArrays(ASourceSerie, xXVals, xYVals);
    ResLin(xXVals, xYVals, xA, xB);
    for xCount := Low(xXVals) to High(xXVals) do begin
      ADestserie.AddXY(xXVals[xCount], xA * xXVals[xCount] + xB);
    end;
    ADestserie.Title := ASourceSerie.Title + ' (Linia oporu)';
    ADestserie.Marks.Assign(ASourceSerie.Marks);
  end;
end;

procedure PrepareSupSerie(ASourceSerie: TChartSeries; ADestserie: TLineSeries);
var xXVals: TDoubleDynArray;
    xYVals: TDoubleDynArray;
    xA, xB: Double;
    xCount: Integer;
begin
  if ASourceSerie.Count > 0 then begin
    SeriesToXYArrays(ASourceSerie, xXVals, xYVals);
    SupLin(xXVals, xYVals, xA, xB);
    for xCount := Low(xXVals) to High(xXVals) do begin
      ADestserie.AddXY(xXVals[xCount], xA * xXVals[xCount] + xB);
    end;
    ADestserie.Title := ASourceSerie.Title + ' (Linia wsparcia)';
    ADestserie.Marks.Assign(ASourceSerie.Marks);
  end;
end;

procedure TCChartReportForm.DoPrint;
begin
  if ActiveChartIndex <> -1 then begin
    if PrintDialog.Execute then begin
      ActiveChart.Print;
    end;
  end;
end;

procedure TCChartReportForm.DoSave;
begin
  inherited DoSave;
  if FActiveChartIndex <> -1 then begin
    if SaveDialog.Execute then begin
      ActiveChart.SaveToBitmapFile(SaveDialog.FileName);
    end;
  end;
end;

procedure TCChartReportForm.ActionGraphExecute(Sender: TObject);
var xChart: TCChart;
begin
  xChart := ActiveChart;
  if xChart <> Nil then begin
    if Fprops = Nil then begin
      Fprops := TCChartPropsForm.Create(Nil);;
      TCChartPropsForm(Fprops).SetChart(xChart, TCChartReport(Report).GetPrefname + xChart.symbol);
    end;
    Fprops.Show;
    Fprops.BringToFront;
  end;
end;

destructor TCChartReportForm.Destroy;
begin
  if Assigned(Fprops) then begin
    FreeAndNil(Fprops);
  end;
  Fcharts.Free;
  inherited Destroy;
end;

constructor TCChart.CreateNew(AOwner: TComponent; ASymbol: String);
begin
  inherited Create(AOwner);
  FregSeries := TObjectList.Create(True);
  FavgSeries := TObjectList.Create(True);
  FmedSeries := TObjectList.Create(True);
  FresSeries := TObjectList.Create(True);
  FsupSeries := TObjectList.Create(True);
  FweightSeries := TObjectList.Create(True);
  FgeoSeries := TObjectList.Create(True);
  Fsymbol := ASymbol;
  Ftitle := '';
  Fimage := -1;
end;

function TChartList.GetBySymbol(ASymbol: String): TCChart;
var xCount: Integer;
    xPrefname: String;
begin
  xCount := 0;
  xPrefname := AnsiLowerCase(ASymbol);
  Result := Nil;
  while (xCount <= Count - 1) and (Result = Nil) do begin
    if AnsiLowerCase(Items[xCount].symbol) = ASymbol then begin
      Result := Items[xCount];
    end;
    Inc(xCount);
  end;
end;

function TChartList.GetItems(AIndex: Integer): TCChart;
begin
  Result := TCChart(inherited Items[AIndex]);
end;

procedure TChartList.SetItems(AIndex: Integer; const Value: TCChart);
begin
  inherited Items[AIndex] := Value;
end;

function TCChartReportForm.CreateNewChart(ASymbol: String): TCChart;
begin
  Result := TCChart.CreateNew(Nil, ASymbol);
  with Result do begin
    DoubleBuffered := True;
    AnimatedZoom := True;
    BackWall.Brush.Color := clWhite;
    BackWall.Brush.Style := bsClear;
    BackWall.Color := clSilver;
    BottomWall.Brush.Color := clWhite;
    BottomWall.Brush.Style := bsClear;
    BottomWall.Dark3D := False;
    Foot.Alignment := taRightJustify;
    Foot.Brush.Color := clWhite;
    Foot.Color := clWhite;
    Foot.Font.Charset := DEFAULT_CHARSET;
    Foot.Font.Color := clNavy;
    Foot.Font.Height := -10;
    Foot.Font.Name := 'Verdana';
    Foot.Font.Style := [];
    Foot.Frame.Color := clWhite;
    Foot.Text.Clear;
    Foot.Text.Add('Report footer');
    LeftWall.Brush.Color := clWhite;
    LeftWall.Brush.Style := bsClear;
    MarginBottom := 1;
    MarginLeft := 3;
    MarginRight := 3;
    MarginTop := 1;
    Title.Alignment := taLeftJustify;
    Title.Color := clWhite;
    Title.Font.Charset := DEFAULT_CHARSET;
    Title.Font.Color := clNavy;
    Title.Font.Height := -14;
    Title.Font.Name := 'Verdana';
    Title.Font.Style := [fsBold];
    Title.Frame.Color := 8453888;
    BackColor := clSilver;
    BottomAxis.DateTimeFormat := 'yyyy-MM-dd';
    BottomAxis.Grid.SmallDots := True;
    BottomAxis.LabelsAngle := 90;
    BottomAxis.LabelsFont.Charset := DEFAULT_CHARSET;
    BottomAxis.LabelsFont.Color := clBlack;
    BottomAxis.LabelsFont.Height := -11;
    BottomAxis.LabelsFont.Name := 'Verdana';
    BottomAxis.LabelsFont.Style := [];
    BottomAxis.LabelsSeparation := 0;
    BottomAxis.MinorTickCount := 0;
    BottomAxis.Title.Font.Charset := DEFAULT_CHARSET;
    BottomAxis.Title.Font.Color := clBlack;
    BottomAxis.Title.Font.Height := -11;
    BottomAxis.Title.Font.Name := 'Verdana';
    BottomAxis.Title.Font.Style := [];
    DepthAxis.LabelsFont.Charset := EASTEUROPE_CHARSET;
    DepthAxis.LabelsFont.Color := clBlack;
    DepthAxis.LabelsFont.Height := -11;
    DepthAxis.LabelsFont.Name := 'Verdana';
    DepthAxis.LabelsFont.Style := [];
    DepthAxis.Title.Font.Charset := EASTEUROPE_CHARSET;
    DepthAxis.Title.Font.Color := clBlack;
    DepthAxis.Title.Font.Height := -11;
    DepthAxis.Title.Font.Name := 'Verdana';
    DepthAxis.Title.Font.Style := [];
    LeftAxis.Grid.SmallDots := True;
    LeftAxis.LabelsFont.Charset := EASTEUROPE_CHARSET;
    LeftAxis.LabelsFont.Color := clBlack;
    LeftAxis.LabelsFont.Height := -11;
    LeftAxis.LabelsFont.Name := 'Verdana';
    LeftAxis.LabelsFont.Style := [];
    LeftAxis.Title.Angle := 0;
    LeftAxis.Title.Font.Charset := EASTEUROPE_CHARSET;
    LeftAxis.Title.Font.Color := clBlack;
    LeftAxis.Title.Font.Height := -11;
    LeftAxis.Title.Font.Name := 'Verdana';
    LeftAxis.Title.Font.Style := [];
    Legend.Alignment := laBottom;
    Legend.Font.Charset := DEFAULT_CHARSET;
    Legend.Font.Color := clBlack;
    Legend.Font.Height := -11;
    Legend.Font.Name := 'Verdana';
    Legend.Font.Style := [];
    RightAxis.LabelsFont.Charset := EASTEUROPE_CHARSET;
    RightAxis.LabelsFont.Color := clBlack;
    RightAxis.LabelsFont.Height := -11;
    RightAxis.LabelsFont.Name := 'Verdana';
    RightAxis.LabelsFont.Style := [];
    RightAxis.Title.Font.Charset := ANSI_CHARSET;
    RightAxis.Title.Font.Color := clBlack;
    RightAxis.Title.Font.Height := -11;
    RightAxis.Title.Font.Name := 'Verdana';
    RightAxis.Title.Font.Style := [];
    TopAxis.LabelsFont.Charset := EASTEUROPE_CHARSET;
    TopAxis.LabelsFont.Color := clBlack;
    TopAxis.LabelsFont.Height := -11;
    TopAxis.LabelsFont.Name := 'Verdana';
    TopAxis.LabelsFont.Style := [];
    TopAxis.Title.Font.Charset := EASTEUROPE_CHARSET;
    TopAxis.Title.Font.Color := clBlack;
    TopAxis.Title.Font.Height := -11;
    TopAxis.Title.Font.Name := 'Verdana';
    TopAxis.Title.Font.Style := [];
    View3D := False;
    View3DOptions.Elevation := 341;
    View3DOptions.Perspective := 0;
    View3DOptions.Rotation := 338;
    View3DOptions.Zoom := 80;
    View3DOptions.ZoomText := False;
    Align := alClient;
    BevelOuter := bvNone;
    Color := clWhite;
    Visible := False;
    Parent := PanelChart;
    Foot.Text.Text := TCBaseReport(Report).GetReportFooter;
    Title.Text.Text := TCBaseReport(Report).GetReportTitle;
    LeftAxis.Axis.Width := 1;
    RightAxis.Axis.Width := 1;
    TopAxis.Axis.Width := 1;
    BottomAxis.Axis.Width := 1;
  end;
  Fcharts.Add(Result);
end;

function TCChartReportForm.GetChart(ASymbol: String; ACanCreate: Boolean): TCChart;
begin
  Result := Fcharts.BySymbol[ASymbol];
  if (Result = Nil) and ACanCreate then begin
    Result := CreateNewChart(ASymbol);
  end;
end;

procedure TCChartReportForm.SetActiveChartIndex(const Value: Integer);
var xNode: PVirtualNode;
begin
  if FActiveChartIndex <> Value then begin
    if FActiveChartIndex <> -1 then begin
      Fcharts.Items[FActiveChartIndex].Visible := False;
    end;
    FActiveChartIndex := Value;
    if FActiveChartIndex <> -1 then begin
      Fcharts.Items[FActiveChartIndex].Visible := True;
      xNode := FindNodeWithIndex(FActiveChartIndex, ThumbsList);
      if xNode <> Nil then begin
        ThumbsList.FocusedNode := xNode;
        ThumbsList.Selected[xNode] := True;
      end;
      TCChartReport(Report).SetChartProps;
      if Fprops <> Nil then begin
        TCChartPropsForm(Fprops).SetChart(ActiveChart, TCChartReport(Report).GetPrefname + ActiveChart.symbol);
      end;
    end else begin
      ThumbsList.FocusedNode := Nil;
      TCChartPropsForm(Fprops).SetChart(Nil, '');
    end;
  end;
end;

function TCChartReportForm.GetActiveChart: TCChart;
begin
  Result := Nil;
  if FActiveChartIndex <> -1 then begin
    Result := Fcharts.Items[FActiveChartIndex];
  end;
end;

constructor TCChartReportForm.CreateForm(AReport: TObject);
begin
  inherited CreateForm(AReport);
  Fcharts := TChartList.Create(True);
  Fprops := Nil;
  ThumbsList.ViewPref := TViewPref(GViewsPreferences.ByPrefname[CFontPreferencesChartList]);
  if GBasePreferences.chartListSmall then begin
    MenuItemSmall.Click;
  end;
  FActiveChartIndex := -1;
end;

procedure TCChartReportForm.UpdateThumbnails;
begin
  PanelThumbs.Visible := Fcharts.Count > 1;
  Splitter.Visible := PanelThumbs.Visible;
  if PanelThumbs.Visible then begin
    ThumbsList.RootNodeCount := Fcharts.Count;
  end;
end;

procedure TCChartReportForm.ThumbsListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
begin
  CellText := Fcharts.Items[Node.Index].thumbTitle;
  if CellText = '' then begin
    CellText := 'Podstawowy';
  end;
end;

destructor TCChart.Destroy;
begin
  FregSeries.Free;
  FavgSeries.Free;
  FmedSeries.Free;
  FresSeries.Free;
  FsupSeries.Free;
  FweightSeries.Free;
  FgeoSeries.Free;
  inherited Destroy;
end;

function TCChart.GetIsavgVisible: Boolean;
begin
  Result := FavgSeries.Count > 0;
end;

function TCChart.GetIsBar: Boolean;
var xCount: Integer;
    xTemp: TBarSeries;
begin
  xCount := 0;
  xTemp := TBarSeries.Create(Nil);
  Result := False;
  while (xCount <= SeriesCount - 1) and (not Result) do begin
    Result := Series[xCount].SameClass(xTemp);
    Inc(xCount);
  end;
  xTemp.Free;
end;

function TCChart.GetIsgeoVisible: Boolean;
begin
  Result := FgeoSeries.Count > 0;
end;

function TCChart.GetIsLin: Boolean;
var xCount: Integer;
    xTemp: TLineSeries;
begin
  xCount := 0;
  xTemp := TLineSeries.Create(Nil);
  Result := False;
  while (xCount <= SeriesCount - 1) and (not Result) do begin
    Result := Series[xCount].SameClass(xTemp);
    Inc(xCount);
  end;
  xTemp.Free;
end;

function TCChart.GetIsmedVisible: Boolean;
begin
  Result := FmedSeries.Count > 0;
end;

function TCChart.GetIsPie: Boolean;
var xCount: Integer;
    xTemp: TPieSeries;
begin
  xCount := 0;
  xTemp := TPieSeries.Create(Nil);
  Result := False;
  while (xCount <= SeriesCount - 1) and (not Result) do begin
    Result := Series[xCount].SameClass(xTemp);
    Inc(xCount);
  end;
  xTemp.Free;
end;

procedure TCChartReportForm.ThumbsListGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
var xImage: Integer;
begin
  xImage := Fcharts.Items[Node.Index].image;
  if xImage = -1 then begin
    if Fcharts.Items[Node.Index].isPie then begin
      xImage := 1;
    end else if Fcharts.Items[Node.Index].isBar then begin
      xImage := 0;
    end else if Fcharts.Items[Node.Index].isLin then begin
      xImage := 2;
    end;
  end;
  ImageIndex := xImage;
end;

procedure TCChartReportForm.ThumbsListHotChange(Sender: TBaseVirtualTree; OldNode, NewNode: PVirtualNode);
begin
  if NewNode <> Nil then begin
    ThumbsList.Cursor := crHandPoint;
  end else begin
    ThumbsList.Cursor := crDefault;
  end;
end;

procedure TCChartReportForm.ThumbsListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
var xIndex: Integer;
begin
  if (Node <> Nil) then begin
    xIndex := Node.Index;
    if (xIndex >= 0) and (xIndex <= Fcharts.Count - 1) then begin
      ActiveChartIndex := xIndex;
    end;
  end else begin
    ActiveChartIndex := -1;
  end;
end;

function TCChart.GetIsregVisible: Boolean;
begin
  Result := FregSeries.Count > 0;
end;

function TCChart.GetIsresVisible: Boolean;
begin
  Result := FresSeries.Count > 0;
end;

function TCChart.GetIssupVisible: Boolean;
begin
  Result := FsupSeries.Count > 0;
end;

function TCChart.GetIsweightVisible: Boolean;
begin
  Result := FweightSeries.Count > 0;
end;

function TCChart.GetSeriesOfClassCount(ASerie: TChartSeries): Integer;
var xCount: Integer;
begin
  xCount := 0;
  Result := 0;
  while (xCount <= SeriesCount - 1) do begin
    if Series[xCount].SameClass(ASerie) then begin
      Inc(Result);
    end;
    Inc(xCount);
  end;
end;

procedure TCChart.SetIsavgVisible(const Value: Boolean);
var xCount: Integer;
    xCalcSerie: TLineSeries;
    xCurSerie: TChartSeries;
begin
  if Value <> isAvgVisible then begin
    if Value then begin
      for xCount := 0 to SeriesCount - 1 do begin
        xCurSerie := Series[xCount];
        if (FregSeries.IndexOf(xCurSerie) = -1) and (FavgSeries.IndexOf(xCurSerie) = -1) and
           (FmedSeries.IndexOf(xCurSerie) = -1) and (FresSeries.IndexOf(xCurSerie) = -1) and
           (FsupSeries.IndexOf(xCurSerie) = -1) and (FweightSeries.IndexOf(xCurSerie) = -1) and
           (FgeoSeries.IndexOf(xCurSerie) = -1) then begin
          xCalcSerie := TLineSeries.Create(Self);
          FavgSeries.Add(xCalcSerie);
          PrepareAvgSerie(xCurSerie, xCalcSerie);
          xCalcSerie.XValues.DateTime := BottomAxis.ExactDateTime;
          AddSeries(xCalcSerie);
        end;
      end;
    end else begin
      while (FavgSeries.Count <> 0) do begin
        SeriesList.Remove(FavgSeries.Items[0]);
        FavgSeries.Delete(0);
      end;
    end;
  end;
end;

procedure TCChart.SetIsgeotVisible(const Value: Boolean);
var xCount: Integer;
    xCalcSerie: TLineSeries;
    xCurSerie: TChartSeries;
begin
  if Value <> isGeoVisible then begin
    if Value then begin
      for xCount := 0 to SeriesCount - 1 do begin
        xCurSerie := Series[xCount];
        if (FregSeries.IndexOf(xCurSerie) = -1) and (FavgSeries.IndexOf(xCurSerie) = -1) and
           (FmedSeries.IndexOf(xCurSerie) = -1) and (FresSeries.IndexOf(xCurSerie) = -1) and
           (FsupSeries.IndexOf(xCurSerie) = -1) and (FweightSeries.IndexOf(xCurSerie) = -1) and
           (FgeoSeries.IndexOf(xCurSerie) = -1) then begin
          xCalcSerie := TLineSeries.Create(Self);
          FgeoSeries.Add(xCalcSerie);
          PrepareGeoSerie(xCurSerie, xCalcSerie);
          xCalcSerie.XValues.DateTime := BottomAxis.ExactDateTime;
          AddSeries(xCalcSerie);
        end;
      end;
    end else begin
      while (FgeoSeries.Count <> 0) do begin
        SeriesList.Remove(FgeoSeries.Items[0]);
        FgeoSeries.Delete(0);
      end;
    end;
  end;
end;

procedure TCChart.SetIsmedVisible(const Value: Boolean);
var xCount: Integer;
    xCalcSerie: TLineSeries;
    xCurSerie: TChartSeries;
begin
  if Value <> ismedVisible then begin
    if Value then begin
      for xCount := 0 to SeriesCount - 1 do begin
        xCurSerie := Series[xCount];
        if (FregSeries.IndexOf(xCurSerie) = -1) and (FavgSeries.IndexOf(xCurSerie) = -1) and
           (FmedSeries.IndexOf(xCurSerie) = -1) and (FresSeries.IndexOf(xCurSerie) = -1) and
           (FsupSeries.IndexOf(xCurSerie) = -1) and (FweightSeries.IndexOf(xCurSerie) = -1) and
           (FgeoSeries.IndexOf(xCurSerie) = -1) then begin
          xCalcSerie := TLineSeries.Create(Self);
          FmedSeries.Add(xCalcSerie);
          PrepareMedSerie(xCurSerie, xCalcSerie);
          xCalcSerie.XValues.DateTime := BottomAxis.ExactDateTime;
          AddSeries(xCalcSerie);
        end;
      end;
    end else begin
      while (FmedSeries.Count <> 0) do begin
        SeriesList.Remove(FmedSeries.Items[0]);
        FmedSeries.Delete(0);
      end;
    end;
  end;
end;

procedure TCChart.SetIsregVisible(const Value: Boolean);
var xCount: Integer;
    xCalcSerie: TLineSeries;
    xCurSerie: TChartSeries;
begin
  if Value <> isRegVisible then begin
    if Value then begin
      for xCount := 0 to SeriesCount - 1 do begin
        xCurSerie := Series[xCount];
        if (FregSeries.IndexOf(xCurSerie) = -1) and (FavgSeries.IndexOf(xCurSerie) = -1) and
           (FmedSeries.IndexOf(xCurSerie) = -1) and (FresSeries.IndexOf(xCurSerie) = -1) and
           (FsupSeries.IndexOf(xCurSerie) = -1) and (FweightSeries.IndexOf(xCurSerie) = -1) and
           (FgeoSeries.IndexOf(xCurSerie) = -1) then begin
          xCalcSerie := TLineSeries.Create(Self);
          FregSeries.Add(xCalcSerie);
          PrepareRegSerie(xCurSerie, xCalcSerie);
          xCalcSerie.XValues.DateTime := BottomAxis.ExactDateTime;
          AddSeries(xCalcSerie);
        end;
      end;
    end else begin
      while (FregSeries.Count <> 0) do begin
        SeriesList.Remove(FregSeries.Items[0]);
        FregSeries.Delete(0);
      end;
    end;
  end;
end;

procedure TCChartReportForm.ThumbsListGetRowPreferencesName(AHelper: TObject; var APrefname: String);
begin
  APrefname := IfThen(MenuItemBig.Checked, 'B', 'S');
end;

procedure TCChartReportForm.MenuItemListClick(Sender: TObject);
var xPrefs: TCListPreferencesForm;
begin
  xPrefs := TCListPreferencesForm.Create(Nil);
  if xPrefs.ShowListPreferences(ThumbsList.ViewPref) then begin
    ThumbsList.ReinitNode(ThumbsList.RootNode, True);
    ThumbsList.Repaint;
  end;
  xPrefs.Free;
end;

procedure TCChartReportForm.MenuItemBigClick(Sender: TObject);
begin
  with ThumbsList do begin
    Images := CImageLists.ChartImageList32x32;
    MenuItemBig.Checked := True;
    ReinitNode(RootNode, True);
    Repaint;
    GBasePreferences.chartListSmall := False;
  end;
end;

procedure TCChartReportForm.MenuItemSmallClick(Sender: TObject);
begin
  with ThumbsList do begin
    Images := CImageLists.ChartImageList16x16;
    MenuItemSmall.Checked := True;
    ReinitNode(RootNode, True);
    Repaint;
    GBasePreferences.chartListSmall := True;
  end;
end;

procedure TCChartReportForm.FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var xChart: TCChart;
    xPos: TPoint;
begin
  if ActiveChartIndex >= 0 then begin
    xChart := TCChart(Fcharts.Items[ActiveChartIndex]);
    GetCursorPos(xPos);
    if IsWindow(xChart.Handle) and (WindowFromPoint(xPos) = xChart.Handle) then begin
      try
        if xChart.isPie then begin
          if WheelDelta > 0 then begin
            xChart.View3DOptions.Zoom := xChart.View3DOptions.Zoom - 4;
          end else if WheelDelta < 0 then begin
            xChart.View3DOptions.Zoom := xChart.View3DOptions.Zoom + 4;
          end;
        end else begin
          if WheelDelta > 0 then begin
            xChart.ZoomPercent(96);
          end else if WheelDelta < 0 then begin
            xChart.ZoomPercent(104);
          end;
        end;
      except
      end;
    end;
  end;
  inherited;
end;

procedure TCChart.SetIsresVisible(const Value: Boolean);
var xCount: Integer;
    xCalcSerie: TLineSeries;
    xCurSerie: TChartSeries;
begin
  if Value <> isResVisible then begin
    if Value then begin
      for xCount := 0 to SeriesCount - 1 do begin
        xCurSerie := Series[xCount];
        if (FregSeries.IndexOf(xCurSerie) = -1) and (FavgSeries.IndexOf(xCurSerie) = -1) and
           (FmedSeries.IndexOf(xCurSerie) = -1) and (FresSeries.IndexOf(xCurSerie) = -1) and
           (FsupSeries.IndexOf(xCurSerie) = -1) and (FweightSeries.IndexOf(xCurSerie) = -1) and
           (FgeoSeries.IndexOf(xCurSerie) = -1) then begin
          xCalcSerie := TLineSeries.Create(Self);
          FresSeries.Add(xCalcSerie);
          PrepareResSerie(xCurSerie, xCalcSerie);
          xCalcSerie.XValues.DateTime := BottomAxis.ExactDateTime;
          AddSeries(xCalcSerie);
        end;
      end;
    end else begin
      while (FresSeries.Count <> 0) do begin
        SeriesList.Remove(FresSeries.Items[0]);
        FresSeries.Delete(0);
      end;
    end;
  end;
end;

procedure TCChart.SetIssupVisible(const Value: Boolean);
var xCount: Integer;
    xCalcSerie: TLineSeries;
    xCurSerie: TChartSeries;
begin
  if Value <> isSupVisible then begin
    if Value then begin
      for xCount := 0 to SeriesCount - 1 do begin
        xCurSerie := Series[xCount];
        if (FregSeries.IndexOf(xCurSerie) = -1) and (FavgSeries.IndexOf(xCurSerie) = -1) and
           (FmedSeries.IndexOf(xCurSerie) = -1) and (FresSeries.IndexOf(xCurSerie) = -1) and
           (FsupSeries.IndexOf(xCurSerie) = -1) and (FweightSeries.IndexOf(xCurSerie) = -1) and
           (FgeoSeries.IndexOf(xCurSerie) = -1) then begin
          xCalcSerie := TLineSeries.Create(Self);
          FsupSeries.Add(xCalcSerie);
          PrepareSupSerie(xCurSerie, xCalcSerie);
          xCalcSerie.XValues.DateTime := BottomAxis.ExactDateTime;
          AddSeries(xCalcSerie);
        end;
      end;
    end else begin
      while (FsupSeries.Count <> 0) do begin
        SeriesList.Remove(FsupSeries.Items[0]);
        FsupSeries.Delete(0);
      end;
    end;
  end;
end;

procedure TCChart.SetIsweightVisible(const Value: Boolean);
var xCount: Integer;
    xCalcSerie: TLineSeries;
    xCurSerie: TChartSeries;
begin
  if Value <> isWeightVisible then begin
    if Value then begin
      for xCount := 0 to SeriesCount - 1 do begin
        xCurSerie := Series[xCount];
        if (FregSeries.IndexOf(xCurSerie) = -1) and (FavgSeries.IndexOf(xCurSerie) = -1) and
           (FmedSeries.IndexOf(xCurSerie) = -1) and (FresSeries.IndexOf(xCurSerie) = -1) and
           (FsupSeries.IndexOf(xCurSerie) = -1) and (FweightSeries.IndexOf(xCurSerie) = -1) and
           (FgeoSeries.IndexOf(xCurSerie) = -1) then begin
          xCalcSerie := TLineSeries.Create(Self);
          FweightSeries.Add(xCalcSerie);
          PrepareWeightSerie(xCurSerie, xCalcSerie);
          xCalcSerie.XValues.DateTime := BottomAxis.ExactDateTime;
          AddSeries(xCalcSerie);
        end;
      end;
    end else begin
      while (FweightSeries.Count <> 0) do begin
        SeriesList.Remove(FweightSeries.Items[0]);
        FweightSeries.Delete(0);
      end;
    end;
  end;
end;

end.
