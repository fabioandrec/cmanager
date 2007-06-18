unit CChartReportFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CReportFormUnit, StdCtrls, Buttons, ExtCtrls, TeeProcs,
  TeEngine, Chart, Series, ActnList, CComponents, Contnrs, VirtualTrees;

type
  TCChart = class(TChart)
  private
    Fsymbol: String;
    Fprops: TForm;
  public
    constructor CreateNew(AOwner: TComponent; ASymbol: String);
    destructor Destroy; override;
    property symbol: String read Fsymbol write Fsymbol;
    property props: TForm read Fprops write Fprops;
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
    procedure ActionGraphExecute(Sender: TObject);
  private
    Fcharts: TChartList;
    FActiveChartIndex: Integer;
    function CreateNewChart(ASymbol: String): TCChart;
    procedure SetActiveChartIndex(const Value: Integer);
    function GetActiveChart: TCChart;
  protected
    procedure DoPrint; override;
    procedure DoSave; override;
  public
    destructor Destroy; override;
    function GetChart(ASymbol: String; ACanCreate: Boolean = True): TCChart;
    property ActiveChartIndex: Integer read FActiveChartIndex write SetActiveChartIndex;
    property ActiveChart: TCChart read GetActiveChart;
    constructor CreateForm(AReport: TObject); override;
  end;

implementation

uses CChartPropsFormUnit, CReports, CConfigFormUnit;

{$R *.dfm}

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
  SaveDialog.Filter := 'pliki BMP|*.bmp';
  SaveDialog.DefaultExt := '.bmp';
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
    if xChart.props = Nil then begin
      xChart.props := ShowChartProps(Fcharts.Items[FActiveChartIndex], TCChartReport(Report).GetPrefname + xChart.symbol);
    end;
    xChart.props.Show;
    xChart.props.BringToFront;
  end;
end;

destructor TCChartReportForm.Destroy;
begin
  Fcharts.Free;
  inherited Destroy;
end;

constructor TCChart.CreateNew(AOwner: TComponent; ASymbol: String);
begin
  inherited Create(AOwner);
  Fsymbol := ASymbol;
  Fprops := Nil;
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

destructor TCChart.Destroy;
begin
  if Assigned(Fprops) then begin
    FreeAndNil(Fprops);
  end;
  inherited Destroy;
end;

function TCChartReportForm.CreateNewChart(ASymbol: String): TCChart;
begin
  Result := TCChart.CreateNew(Nil, ASymbol);
  with Result do begin
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
    Foot.Font.Height := -11;
    Foot.Font.Name := 'Verdana';
    Foot.Font.Style := [];
    Foot.Frame.Color := clWhite;
    Foot.Text.Clear;
    Foot.Text.Add('Report footer');
    LeftWall.Brush.Color := clWhite;
    LeftWall.Brush.Style := bsClear;
    MarginBottom := 1;
    MarginLeft := 1;
    MarginRight := 1;
    MarginTop := 1;
    Title.Alignment := taLeftJustify;
    Title.Color := clWhite;
    Title.Font.Charset := DEFAULT_CHARSET;
    Title.Font.Color := clNavy;
    Title.Font.Height := -14;
    Title.Font.Name := 'Verdana';
    Title.Font.Style := [fsBold];
    Title.Frame.Color := 8453888;
    Title.Text.Clear;
    Title.Text.Add('Report title');
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
    Parent := PanelConfig;
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
begin
  if FActiveChartIndex <> Value then begin
    if FActiveChartIndex <> -1 then begin
      Fcharts.Items[FActiveChartIndex].Visible := False;
    end;
    FActiveChartIndex := Value;
    if FActiveChartIndex <> -1 then begin
      Fcharts.Items[FActiveChartIndex].Visible := True;
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
  FActiveChartIndex := -1;
end;

end.
