unit CChooseDateFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, CComponents;

type
  TCChooseDateForm = class(TCConfigForm)
    GroupBox1: TGroupBox;
    CDateTime1: TCDateTime;
  end;

function ChooseDateByForm(var ADate: TDateTime): Boolean;

implementation

uses CDatabase, DateUtils;

{$R *.dfm}

function ChooseDateByForm(var ADate: TDateTime): Boolean;
var xForm: TCChooseDateForm;
begin
  xForm := TCChooseDateForm.Create(Nil);
  xForm.CDateTime1.Value := GWorkDate;
  Result := xForm.ShowConfig(coEdit);
  if Result then begin
    ADate := xForm.CDateTime1.Value;
  end;
  xForm.Free;
end;

end.
