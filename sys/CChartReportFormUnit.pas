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
    CButton4: TCButton;
    ActionGraph: TAction;
    procedure ActionGraphExecute(Sender: TObject);
  private
    FProps: TForm;
  protected
    procedure DoPrint; override;
    procedure DoSave; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

uses CChartPropsFormUnit, CReports;

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

procedure TCChartReportForm.ActionGraphExecute(Sender: TObject);
begin
  if FProps = Nil then begin
    FProps := ShowChartProps(CChart);
  end else begin
    FProps.Show;
    FProps.BringToFront;
  end;
end;

constructor TCChartReportForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FProps := Nil;
end;

destructor TCChartReportForm.Destroy;
begin
  if Assigned(FProps) then begin
    FreeAndNil(FProps);
  end;
  inherited Destroy;
end;

end.
