unit CChartPropsFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, Chart;

type
  TCChartPropsForm = class(TCConfigForm)
    CheckBox3d: TCheckBox;
    CheckBoxLeg: TCheckBox;
  private
    Fchart: TChart;
    FisPie: Boolean;
  protected
    procedure CheckIsPie;
    procedure FillForm; override;
    procedure ReadValues; override;
  public
    property chart: TChart read Fchart write Fchart;
  end;

function ShowChartProps(AChart: TChart): Boolean;

implementation

{$R *.dfm}

uses Series;

function ShowChartProps(AChart: TChart): Boolean;
var xForm: TCChartPropsForm;
begin
  xForm := TCChartPropsForm.Create(Nil);
  xForm.chart := AChart;
  xForm.CheckIsPie;
  Result := xForm.ShowConfig(coEdit);
  xForm.Free;
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

procedure TCChartPropsForm.FillForm;
begin
  CheckBox3d.Checked := Fchart.View3D;
  CheckBoxLeg.Checked := Fchart.Legend.Visible;
end;

procedure TCChartPropsForm.ReadValues;
begin
  Fchart.View3D := CheckBox3d.Checked;
  Fchart.View3DWalls := Fchart.View3D and (not FisPie);
  Fchart.View3DOptions.Orthogonal := Fchart.View3DWalls;
  Fchart.Legend.Visible := CheckBoxLeg.Checked;
end;

end.
