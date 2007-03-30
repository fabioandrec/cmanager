unit CChartReportFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CReportFormUnit, StdCtrls, Buttons, ExtCtrls, TeeProcs,
  TeEngine, Chart, Series, ActnList, CComponents;

type
  TCChartReportForm = class(TCReportForm)
    PrintDialog: TPrintDialog;
    CChart: TChart;
  protected
    procedure DoPrint; override;
    procedure DoSave; override;
  public
  end;

implementation

{$R *.dfm}

procedure TCChartReportForm.DoPrint;
begin
  if PrintDialog.Execute then begin
    CChart.Print;
  end;
end;

procedure TCChartReportForm.DoSave;
begin
  SaveDialog.Filter := 'pliki BMP|*.bmp';
  SaveDialog.DefaultExt := '.bmp';
  if SaveDialog.Execute then begin
    CChart.SaveToBitmapFile(SaveDialog.FileName);
  end;
end;

end.
