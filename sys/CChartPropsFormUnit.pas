unit CChartPropsFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, Chart,
  CBaseFormUnit, ComCtrls, TeEngine;

type
  TMarksStyle = (msHidden, msValues, msLabels);

  TCChartPropsForm = class(TCBaseForm)
    GroupBox1: TGroupBox;
    ComboBox: TComboBox;
    TrackBarRotate: TTrackBar;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    TrackBarElevation: TTrackBar;
    Label4: TLabel;
    Label5: TLabel;
    TrackBarPerspective: TTrackBar;
    Label6: TLabel;
    Label7: TLabel;
    TrackBarTilt: TTrackBar;
    Label8: TLabel;
    Label9: TLabel;
    TrackBarDepth: TTrackBar;
    Label10: TLabel;
    GroupBox2: TGroupBox;
    ComboBoxLegendPos: TComboBox;
    Label11: TLabel;
    TrackBarZoom: TTrackBar;
    Label12: TLabel;
    GroupBoxMarks: TGroupBox;
    ComboBoxMarks: TComboBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ComboBoxLegendPosChange(Sender: TObject);
    procedure TrackBarRotateChange(Sender: TObject);
    procedure TrackBarElevationChange(Sender: TObject);
    procedure TrackBarPerspectiveChange(Sender: TObject);
    procedure ComboBoxChange(Sender: TObject);
    procedure TrackBarTiltChange(Sender: TObject);
    procedure TrackBarDepthChange(Sender: TObject);
    procedure TrackBarZoomChange(Sender: TObject);
    procedure ComboBoxMarksChange(Sender: TObject);
  private
    Fchart: TChart;
    FisPie: Boolean;
    function GetmarksStyle: TMarksStyle;
    procedure SetmarksStyle(const Value: TMarksStyle);
  protected
    procedure CheckIsPie;
    procedure UpdateTrackbars;
    procedure UpdateLabelPos(ALabel: TLabel; ATrackbar: TTrackBar);
  public
    property chart: TChart read Fchart write Fchart;
    property marksStyle: TMarksStyle read GetmarksStyle write SetmarksStyle;
  end;

function ShowChartProps(AChart: TChart): TForm;

implementation

{$R *.dfm}

uses Series, TeCanvas;

const CLegendPosition: array[0..4] of String = ('z lewej', 'z prawej', 'z g�ry', 'z do�u', 'ukryta');

function ShowChartProps(AChart: TChart): TForm;
begin
  Result := TCChartPropsForm.Create(Application);
  with TCChartPropsForm(Result) do begin
    chart := AChart;
    CheckIsPie;
    if chart.View3D then begin
      if chart.View3DOptions.Orthogonal then begin
        ComboBox.ItemIndex := 1;
      end else begin
        ComboBox.ItemIndex := 2;
      end;
    end else begin
      ComboBox.ItemIndex := 0;
    end;
    ComboBoxMarks.ItemIndex := Ord(marksStyle);
    TrackBarRotate.Position := chart.View3DOptions.Rotation;
    TrackBarElevation.Position := chart.View3DOptions.Elevation;
    TrackBarPerspective.Position := chart.View3DOptions.Perspective;
    TrackBarTilt.Position := chart.View3DOptions.Tilt;
    TrackBarDepth.Position := chart.Chart3DPercent;
    TrackBarZoom.Position := chart.View3DOptions.Zoom;
    UpdateLabelPos(Label2, TrackBarRotate);
    UpdateLabelPos(Label4, TrackBarElevation);
    UpdateLabelPos(Label6, TrackBarPerspective);
    UpdateLabelPos(Label8, TrackBarTilt);
    UpdateLabelPos(Label10, TrackBarDepth);
    UpdateLabelPos(Label12, TrackBarZoom);
    UpdateTrackbars;    
    if chart.Legend.Visible then begin
      ComboBoxLegendPos.ItemIndex := Ord(chart.Legend.Alignment);
    end else begin
      ComboBoxLegendPos.ItemIndex := 4;
    end;
  end;
end;

procedure TCChartPropsForm.CheckIsPie;
var xCount: Integer;
    xTemp: TPieSeries;
begin
  FisPie := False;
  xCount := 0;
  xTemp := TPieSeries.Create(Nil);
  while (xCount <= Fchart.SeriesCount - 1) and (not FisPie) do begin
    FisPie := Fchart.Series[xCount].SameClass(xTemp);
    Inc(xCount);
  end;
  xTemp.Free;
end;

procedure TCChartPropsForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caHide;
end;

procedure TCChartPropsForm.FormCreate(Sender: TObject);
var xCount: Integer;
begin
  with ComboBoxLegendPos do begin
    Clear;
    for xCount := Low(CLegendPosition) to High(CLegendPosition) do begin
      Items.Add(CLegendPosition[xCount])
    end;
  end;
end;

procedure TCChartPropsForm.ComboBoxLegendPosChange(Sender: TObject);
begin
  chart.Legend.Visible := ComboBoxLegendPos.ItemIndex <> 4;
  if chart.Legend.Visible then begin
    chart.Legend.Alignment := TLegendAlignment(ComboBoxLegendPos.ItemIndex);
  end;
end;

procedure TCChartPropsForm.TrackBarRotateChange(Sender: TObject);
begin
  UpdateLabelPos(Label2, TrackBarRotate);
  Fchart.View3DOptions.Rotation := TrackBarRotate.Position;
end;

procedure TCChartPropsForm.TrackBarElevationChange(Sender: TObject);
begin
  UpdateLabelPos(Label4, TrackBarElevation);
  Fchart.View3DOptions.Elevation := TrackBarElevation.Position;
end;

procedure TCChartPropsForm.TrackBarPerspectiveChange(Sender: TObject);
begin
  UpdateLabelPos(Label6, TrackBarPerspective);
  Fchart.View3DOptions.Perspective := TrackBarPerspective.Position;
end;

procedure TCChartPropsForm.UpdateLabelPos(ALabel: TLabel; ATrackbar: TTrackBar);
begin
  ALabel.Caption := IntToStr(ATrackbar.Position);
end;

procedure TCChartPropsForm.ComboBoxChange(Sender: TObject);
begin
  Fchart.View3D := (ComboBox.ItemIndex <> 0);
  Fchart.View3DOptions.Orthogonal := (ComboBox.ItemIndex = 1);
  UpdateTrackbars;
end;

procedure TCChartPropsForm.UpdateTrackbars;
begin
  Label1.Enabled := ComboBox.ItemIndex = 2;
  TrackBarRotate.Enabled := ComboBox.ItemIndex = 2;
  Label2.Enabled := ComboBox.ItemIndex = 2;
  Label4.Enabled := ComboBox.ItemIndex = 2;
  TrackBarElevation.Enabled := ComboBox.ItemIndex = 2;
  Label3.Enabled := ComboBox.ItemIndex = 2;
  Label5.Enabled := ComboBox.ItemIndex = 2;
  TrackBarPerspective.Enabled := ComboBox.ItemIndex = 2;
  Label6.Enabled := ComboBox.ItemIndex = 2;
  Label8.Enabled := ComboBox.ItemIndex = 2;
  TrackBarTilt.Enabled := ComboBox.ItemIndex = 2;
  Label7.Enabled := ComboBox.ItemIndex = 2;
  Label9.Enabled := ComboBox.ItemIndex <> 0;
  TrackBarDepth.Enabled := ComboBox.ItemIndex <> 0;
  Label10.Enabled := ComboBox.ItemIndex <> 0;
  Label11.Enabled := ComboBox.ItemIndex <> 0;
  TrackBarZoom.Enabled := ComboBox.ItemIndex <> 0;
  Label12.Enabled := ComboBox.ItemIndex <> 0;
end;

procedure TCChartPropsForm.TrackBarTiltChange(Sender: TObject);
begin
  UpdateLabelPos(Label8, TrackBarTilt);
  Fchart.View3DOptions.Tilt := TrackBarTilt.Position;
end;

procedure TCChartPropsForm.TrackBarDepthChange(Sender: TObject);
begin
  UpdateLabelPos(Label10, TrackBarDepth);
  Fchart.Chart3DPercent := TrackBarDepth.Position;
end;

procedure TCChartPropsForm.TrackBarZoomChange(Sender: TObject);
begin
  UpdateLabelPos(Label12, TrackBarZoom);
  Fchart.View3DOptions.Zoom := TrackBarZoom.Position;
end;

function TCChartPropsForm.GetmarksStyle: TMarksStyle;
var xCount: Integer;
begin
  Result := msHidden;
  xCount := 0;
  while (xCount <= Fchart.SeriesCount - 1) and (Result = msHidden) do begin
    if Fchart.Series[xCount].Marks.Visible then begin
      if Fchart.Series[xCount].Marks.Style = smsValue then begin
        Result := msValues;
      end else begin
        Result := msLabels;
      end;
    end;
    Inc(xCount);
  end;
end;

procedure TCChartPropsForm.SetmarksStyle(const Value: TMarksStyle);
var xCount: Integer;
begin
  for xCount := 0 to Fchart.SeriesCount - 1 do begin
    Fchart.Series[xCount].Marks.Visible := Value <> msHidden;
    if Value = msValues then begin
      Fchart.Series[xCount].Marks.Style := smsValue;
    end else begin
      Fchart.Series[xCount].Marks.Style := smsLabel;
    end;
  end;
end;

procedure TCChartPropsForm.ComboBoxMarksChange(Sender: TObject);
begin
  marksStyle := TMarksStyle(ComboBoxMarks.ItemIndex);
end;

end.
