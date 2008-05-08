unit CDepositInvestmentPayFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, CComponents;

type
  TCDepositInvestmentPayForm = class(TCDataobjectForm)
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label2: TLabel;
    Label12: TLabel;
    CDateTime: TCDateTime;
    EditName: TEdit;
    ComboBoxType: TComboBox;
  private
  protected
    procedure InitializeForm; override;
  public
  end;

implementation

{$R *.dfm}

{ TCDepositInvestmentPayForm }

procedure TCDepositInvestmentPayForm.InitializeForm;
begin
  inherited InitializeForm;
  Caption := 'Lokata - Wyp³ata';
end;

end.
 