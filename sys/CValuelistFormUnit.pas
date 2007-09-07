unit CValuelistFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, Grids, ValEdit;

type
  TCValuelistForm = class(TCConfigForm)
    ValueListEditor: TValueListEditor;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ShowValuelist(var AList: TStringList): Boolean;

implementation

{$R *.dfm}

function ShowValuelist(var AList: TStringList): Boolean;
var xForm: TCValuelistForm;
begin
  xForm := TCValuelistForm.Create(Application);
  xForm.ValueListEditor.Strings.Text := AList.Text;
  Result := xForm.ShowConfig(coEdit);
  if Result then begin
    AList.Assign(xForm.ValueListEditor.Strings);
  end;
  xForm.Free;
end;

end.
