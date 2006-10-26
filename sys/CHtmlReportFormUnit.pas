unit CHtmlReportFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CReportFormUnit, OleCtrls, SHDocVw, CComponents, StdCtrls,
  Buttons, ExtCtrls;

type
  TCHtmlReportForm = class(TCReportForm)
    CBrowser: TCBrowser;
  protected
    procedure DoPreview; override;
    procedure DoPrint; override;
  end;

implementation

{$R *.dfm}

procedure TCHtmlReportForm.DoPreview;
begin
  CBrowser.ExecWB(OLECMDID_PRINTPREVIEW, 0);
end;

procedure TCHtmlReportForm.DoPrint;
begin
  CBrowser.ExecWB(OLECMDID_PRINT, 0);
end;

end.
 