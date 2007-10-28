unit CChartPropsFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, Chart,
  CBaseFormUnit, ComCtrls, TeEngine, CPreferences, CChartReportFormUnit;

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
    GroupBox3: TGroupBox;
    CheckBoxReg: TCheckBox;
    CheckBoxAvg: TCheckBox;
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
    procedure CheckBoxRegClick(Sender: TObject);
    procedure CheckBoxAvgClick(Sender: TObject);
  private
    Fchart: TCChart;
    Fprefs: TChartPref;
    FprefName: String;
    function GetmarksStyle: TMarksStyle;
    procedure SetmarksStyle(const Value: TMarksStyle);
    procedure UpdatePrefs;
  protected
    procedure UpdateTrackbars;
    procedure UpdateLabelPos(ALabel: TLabel; ATrackbar: TTrackBar);
  public
    constructor Create(AOwner: TComponent); override;
    procedure SetChart(AChart: TCChart; APrefName: String);
    property chart: TCChart read Fchart write Fchart;
    property marksStyle: TMarksStyle read GetmarksStyle write SetmarksStyle;
  end;

implementation

{$R *.dfm}

uses Series, TeCanvas, CTools;

const CLegendPosition: array[0..4] of String = ('z lewej', 'z prawej', 'z góry', 'z do³u', 'ukryta');

procedure TCChartPropsForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caHide;
end;

procedure TCChartPropsForm.FormCreate(Sender: TObject);
begin
  FillCombo(ComboBoxLegendPos, CLegendPosition);
end;

procedure TCChartPropsForm.ComboBoxLegendPosChange(Sender: TObject);
begin
  chart.Legend.Visible := ComboBoxLegendPos.ItemIndex <> 4;
  if chart.Legend.Visible then begin
    chart.Legend.Alignment := TLegendAlignment(ComboBoxLegendPos.ItemIndex);
  end;
  UpdatePrefs;
end;

procedure TCChartPropsForm.TrackBarRotateChange(Sender: TObject);
begin
  UpdateLabelPos(Label2, TrackBarRotate);
  Fchart.View3DOptions.Rotation := TrackBarRotate.Position;
  UpdatePrefs;
end;

procedure TCChartPropsForm.TrackBarElevationChange(Sender: TObject);
begin
  UpdateLabelPos(Label4, TrackBarElevation);
  Fchart.View3DOptions.Elevation := TrackBarElevation.Position;
  UpdatePrefs;
end;

procedure TCChartPropsForm.TrackBarPerspectiveChange(Sender: TObject);
begin
  UpdateLabelPos(Label6, TrackBarPerspective);
  Fchart.View3DOptions.Perspective := TrackBarPerspective.Position;
  UpdatePrefs;
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
  UpdatePrefs;
end;

procedure TCChartPropsForm.UpdateTrackbars;
begin
  if Fchart <> Nil then begin
    ComboBoxMarks.Enabled := True;
    ComboBoxLegendPos.Enabled := True;
    ComboBox.Enabled := True;
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
  end else begin
    Label1.Enabled := False;
    TrackBarRotate.Enabled := False;
    Label2.Enabled := False;
    Label4.Enabled := False;
    TrackBarElevation.Enabled := False;
    Label3.Enabled := False;
    Label5.Enabled := False;
    TrackBarPerspective.Enabled := False;
    Label6.Enabled := False;
    Label8.Enabled := False;
    TrackBarTilt.Enabled := False;
    Label7.Enabled := False;
    Label9.Enabled := False;
    TrackBarDepth.Enabled := False;
    Label10.Enabled := False;
    Label11.Enabled := False;
    TrackBarZoom.Enabled := False;
    Label12.Enabled := False;
    ComboBoxMarks.Enabled := False;
    ComboBoxLegendPos.Enabled := False;
    ComboBox.Enabled := False;
  end;
end;

procedure TCChartPropsForm.TrackBarTiltChange(Sender: TObject);
begin
  UpdateLabelPos(Label8, TrackBarTilt);
  Fchart.View3DOptions.Tilt := TrackBarTilt.Position;
  UpdatePrefs;
end;

procedure TCChartPropsForm.TrackBarDepthChange(Sender: TObject);
begin
  UpdateLabelPos(Label10, TrackBarDepth);
  Fchart.Chart3DPercent := TrackBarDepth.Position;
  UpdatePrefs;
end;

procedure TCChartPropsForm.TrackBarZoomChange(Sender: TObject);
begin
  UpdateLabelPos(Label12, TrackBarZoom);
  Fchart.View3DOptions.Zoom := TrackBarZoom.Position;
  UpdatePrefs;
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
  UpdatePrefs;
end;

procedure TCChartPropsForm.ComboBoxMarksChange(Sender: TObject);
begin
  marksStyle := TMarksStyle(ComboBoxMarks.ItemIndex);
  UpdatePrefs;
end;

constructor TCChartPropsForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Fprefs := Nil;
end;

procedure TCChartPropsForm.UpdatePrefs;
begin
  Fprefs := TChartPref(GChartPreferences.ByPrefname[FprefName]);
  if Fprefs = Nil then begin
    Fprefs := TChartPref.Create(FprefName);
    GChartPreferences.Add(Fprefs);
  end;
  with Fprefs do begin
    view := ComboBox.ItemIndex;
    legend := ComboBoxLegendPos.ItemIndex;
    values := ComboBoxMarks.ItemIndex;
    depth := TrackBarDepth.Position;
    zoom := TrackBarZoom.Position;
    rotate := TrackBarRotate.Position;
    elevation := TrackBarElevation.Position;
    perspective := TrackBarPerspective.Position;
    tilt := TrackBarTilt.Position;
    isAvg := CheckBoxAvg.Checked;
    isReg := CheckBoxReg.Checked;
  end;
end;

procedure TCChartPropsForm.SetChart(AChart: TCChart; APrefName: String);
begin
  FprefName := APrefName;
  if AChart <> Nil then begin
    Fchart := AChart;
    FprefName := APrefName;
    if chart.View3D then begin
      if chart.View3DOptions.Orthogonal then begin
        ComboBox.ItemIndex := 1;
      end else begin
        ComboBox.ItemIndex := 2;
      end;
    end else begin
      ComboBox.ItemIndex := 0;
    end;
    CheckBoxReg.Enabled := not AChart.isPie;
    CheckBoxAvg.Enabled := not AChart.isPie;
    ComboBoxMarks.ItemIndex := Ord(marksStyle);
    TrackBarRotate.Position := chart.View3DOptions.Rotation;
    TrackBarElevation.Position := chart.View3DOptions.Elevation;
    TrackBarPerspective.Position := chart.View3DOptions.Perspective;
    TrackBarTilt.Position := chart.View3DOptions.Tilt;
    TrackBarDepth.Position := chart.Chart3DPercent;
    TrackBarZoom.Position := chart.View3DOptions.Zoom;
    CheckBoxReg.Checked := chart.isRegVisible;
    CheckBoxAvg.Checked := chart.isAvgVisible;
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
    UpdatePrefs;
  end else begin
    UpdateTrackbars;
  end;
end;

procedure TCChartPropsForm.CheckBoxRegClick(Sender: TObject);
begin
  Fchart.isRegVisible := CheckBoxReg.Checked;
  UpdatePrefs;
end;

procedure TCChartPropsForm.CheckBoxAvgClick(Sender: TObject);
begin
  Fchart.isAvgVisible := CheckBoxAvg.Checked;
  UpdatePrefs;
end;

end.
