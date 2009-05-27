unit CHtmlReportFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CReportFormUnit, OleCtrls, SHDocVw, CComponents, StdCtrls,
  Buttons, ExtCtrls, ActnList;

type
  TCHtmlReportForm = class(TCReportForm)
    Panel1: TCPanel;
    CBrowser: TCBrowser;
  protected
    procedure DoPreview; override;
    procedure DoPrint; override;
    procedure DoSave; override;
  end;

implementation

uses CReports, CConfigFormUnit;

{$R *.dfm}

procedure TCHtmlReportForm.DoPreview;
begin
  CBrowser.ExecWB(OLECMDID_PRINTPREVIEW, 0);
end;

procedure TCHtmlReportForm.DoPrint;
begin
  CBrowser.ExecWB(OLECMDID_PRINT, 0);
end;

procedure TCHtmlReportForm.DoSave;
begin
  inherited DoSave;
  if SaveDialog.Execute then begin
    TCHtmlReport(Report).SaveToFile(SaveDialog.FileName);
  end;
end;

end.