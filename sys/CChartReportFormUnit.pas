unit CChartReportFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CReportFormUnit, StdCtrls, Buttons, ExtCtrls, TeeProcs,
  TeEngine, Chart;

type
  TCChartReportForm = class(TCReportForm)
    CChart: TChart;
    PrintDialog: TPrintDialog;
  protected
    procedure DoPrint; override;
    procedure DoPreview; override;
  public

  end;

implementation

{$R *.dfm}

procedure TCChartReportForm.DoPreview;
begin
end;

procedure TCChartReportForm.DoPrint;
begin
  if PrintDialog.Execute then begin
    CChart.Print;
  end;
end;

end.
 