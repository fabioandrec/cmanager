unit CReportFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, OleCtrls, SHDocVw,
  CComponents;

type
  TCReportForm = class(TCConfigForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
  protected
    procedure DoPrint; virtual;
    procedure DoPreview; virtual;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TCReportForm.BitBtn2Click(Sender: TObject);
begin
  DoPreview;
end;

procedure TCReportForm.BitBtn1Click(Sender: TObject);
begin
  DoPrint;
end;

procedure TCReportForm.DoPreview;
begin
end;

procedure TCReportForm.DoPrint;
begin
end;

end.
