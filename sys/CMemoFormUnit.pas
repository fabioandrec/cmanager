unit CMemoFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, ComCtrls, Printers, ActiveX;

type
  TCMemoForm = class(TCConfigForm)
    RichEdit: TRichEdit;
    SpeedButton1: TSpeedButton;
    PrinterSetupDialog: TPrinterSetupDialog;
    procedure SpeedButton1Click(Sender: TObject);
  end;

procedure ShowReport(AFormTitle: String; AReport: String; AWidth, AHeight: Integer);

implementation

uses CBaseFormUnit, CRichtext;

{$R *.dfm}

procedure ShowReport(AFormTitle: String; AReport: String; AWidth, AHeight: Integer);
var xForm: TCMemoForm;
begin
  xForm := TCMemoForm.Create(Application);
  xForm.Caption := AFormTitle;
  xForm.Width := AWidth;
  xForm.Height := AHeight;
  AssignRichText(AReport, xForm.RichEdit);
  xForm.ShowConfig(coNone);
  xForm.Free;
end;

procedure TCMemoForm.SpeedButton1Click(Sender: TObject);
begin
  if Printer.Printers.Count > 0 then begin
    if PrinterSetupDialog.Execute then begin
      RichEdit.Print('');
    end;
  end else begin
    MessageBox(Application.Handle, 'W systemie nie zainstalowano ¿adnej drukarki', 'Uwaga', MB_OK + MB_ICONEXCLAMATION);
  end;
end;

end.
