unit CReports;

interface

uses Classes, CReportFormUnit, Graphics, Controls, Chart, Series, Contnrs;

type
  TCReportClass = class of TCReport;

  TCReport = class(TObject)
  private
    FreportText: TStringList;
    Fform: TCReportForm;
    Fcharts: TObjectList;
    function GetreportText: String;
  protected
    procedure CleanReportData; virtual;
    function PrepareReportData: Boolean; virtual; abstract;
    function GetreportName: String; virtual;
  public
    procedure ShowReport;
    constructor Create;
    destructor Destroy; override;
    function GetChart: TChart;
  published
    property reportText: String read GetreportText;
    property reportName: String read GetreportName;
  end;

  TTestReport = class(TCReport)
  end;

implementation

uses Forms;

procedure TCReport.CleanReportData;
begin
end;

constructor TCReport.Create;
begin
  inherited Create;
  FreportText := TStringList.Create;
  Fcharts := TObjectList.Create(False);
end;

destructor TCReport.Destroy;
begin
  CleanReportData;
  Fcharts.Free;
  FreportText.Free;
  inherited Destroy;
end;

function TCReport.GetChart: TChart;
begin
  Result := TChart.Create(Fform);
  Result.Visible := False;
  Result.BorderStyle := bsNone;
  Result.BevelInner := bvNone;
  Result.BevelOuter := bvNone;
  Result.Color := clWindow;
  Result.Parent := Fform;
  Fcharts.Add(Result)
end;

function TCReport.GetreportName: String;
begin
  Result := '<bez nazwy>';
end;

function TCReport.GetreportText: String;
begin
  Result := FreportText.Text;
end;

procedure TCReport.ShowReport;
begin
  Fform := TCReportForm.Create(Nil);
  if PrepareReportData then begin
    Fform.Caption := reportName;
    Fform.CBrowser.LoadFromString(reportText);
    Fform.ShowModal;
  end;
  Fform.Free;
end;

end.
