unit NBPACurrencyRatesConfigFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, CPluginTypes;

type
  TNBPACurrencyRatesConfigForm = class(TForm)
    PanelConfig: TPanel;
    PanelButtons: TPanel;
    BitBtnOk: TBitBtn;
    BitBtnCancel: TBitBtn;
    GroupBox1: TGroupBox;
    EditName: TEdit;
    GroupBox2: TGroupBox;
    ComboBoxSource: TComboBox;
    procedure BitBtnOkClick(Sender: TObject);
    procedure BitBtnCancelClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ComboBoxSourceChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var GCManagerInterface: ICManagerInterface;

implementation

{$R *.dfm}

procedure TNBPACurrencyRatesConfigForm.BitBtnOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TNBPACurrencyRatesConfigForm.BitBtnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TNBPACurrencyRatesConfigForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then begin
    Close;
  end;
end;

procedure TNBPACurrencyRatesConfigForm.ComboBoxSourceChange(Sender: TObject);
begin
  EditName.Enabled := ComboBoxSource.ItemIndex = 0;
end;

end.
 