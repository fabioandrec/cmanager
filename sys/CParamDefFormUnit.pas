unit CParamDefFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, CReports;

type
  TCParamDefForm = class(TCConfigForm)
    GroupBox1: TGroupBox;
    Label5: TLabel;
    ComboBoxGroup: TComboBox;
    Label1: TLabel;
    EditName: TEdit;
  private
    FParamDef: TReportDialgoParamDef;
  protected
    function CanAccept: Boolean; override;
    procedure FillForm; override;
    procedure ReadValues; override;
  published
    property paramDef: TReportDialgoParamDef read FParamDef write FParamDef;
  end;

implementation

uses CInfoFormUnit;

{$R *.dfm}

function TCParamDefForm.CanAccept: Boolean;
begin
  Result := inherited CanAccept;
  if Trim(EditName.Text) = '' then begin
    Result := False;
    ShowInfo(itError, 'Nazwa parametru nie mo¿e byæ pusta', '');
    EditName.SetFocus;
  end;
end;

procedure TCParamDefForm.FillForm;
var xCount: Integer;
begin
  inherited FillForm;
  for xCount := 0 to FParamDef.parentParamsDefs.groups.Count - 1 do begin
    ComboBoxGroup.Items.Add(FParamDef.parentParamsDefs.groups.Strings[xCount]);
  end;
  if Operation = coEdit then begin
    EditName.Text := FParamDef.name;
    ComboBoxGroup.Text := FParamDef.group;
  end;
end;

procedure TCParamDefForm.ReadValues;
begin
  inherited ReadValues;
  with FParamDef do begin
    name := EditName.Text;
    group := ComboBoxGroup.Text;
  end;
end;

end.
