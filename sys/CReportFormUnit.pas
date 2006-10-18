unit CReportFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, OleCtrls, SHDocVw,
  CComponents;

type
  TCReportForm = class(TCConfigForm)
    CBrowser: TCBrowser;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TCReportForm.BitBtn2Click(Sender: TObject);
begin
  CBrowser.ExecWB(OLECMDID_PRINTPREVIEW, 0);
end;

procedure TCReportForm.BitBtn1Click(Sender: TObject);
begin
  CBrowser.ExecWB(OLECMDID_PRINT, 0);
end;

end.
