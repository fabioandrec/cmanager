unit CMemoFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, ComCtrls, Printers, ActiveX,
  ActnList, CComponents;

type
  TCMemoForm = class(TCConfigForm)
    RichEdit: TRichEdit;
    PrinterSetupDialog: TPrinterSetupDialog;
    ActionList: TActionList;
    Action1: TAction;
    CButton1: TCButton;
    procedure Action1Execute(Sender: TObject);
  end;

procedure ShowReport(AFormTitle: String; AReport: String; AWidth, AHeight: Integer; AFontname: String = ''; AFontsize: Integer = -1);

implementation

uses CBaseFormUnit, CRichtext;

{$R *.dfm}

procedure ShowReport(AFormTitle: String; AReport: String; AWidth, AHeight: Integer; AFontname: String = ''; AFontsize: Integer = -1);
var xForm: TCMemoForm;
begin
  xForm := TCMemoForm.Create(Application);
  xForm.Caption := AFormTitle;
  xForm.Width := AWidth;
  xForm.Height := AHeight;
  if AFontname <> '' then begin
    xForm.RichEdit.Font.Name := AFontname;
  end;
  if AFontsize <> -1 then begin
    xForm.RichEdit.Font.Size := AFontsize;
  end;
  AssignRichText(AReport, xForm.RichEdit);
  xForm.ShowConfig(coNone);
  xForm.Free;
end;

procedure TCMemoForm.Action1Execute(Sender: TObject);
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
