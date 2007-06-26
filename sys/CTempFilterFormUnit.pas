unit CTempFilterFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, CListFrameUnit;

type
  TCTempFilterForm = class(TCConfigForm)
  end;

procedure ShowTempFilter;

implementation

uses CDatabase, AdoDb;

{$R *.dfm}

procedure ShowTempFilter;
var xForm: TCTempFilterForm;
begin
  xForm := TCTempFilterForm.Create(Nil);
  xForm.ShowConfig(coAdd);
  xForm.Free;
end;

end.
