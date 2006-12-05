unit CPreferencesFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls;

const
  CPreferencesFirstTab = 0;

type
  TCPreferencesForm = class(TCConfigForm)
  private
    { Private declarations }
  public
    function ShowPreferences(ATab: Integer = CPreferencesFirstTab): Boolean;
  end;

implementation

{$R *.dfm}

{ TCPreferencesForm }

function TCPreferencesForm.ShowPreferences(ATab: Integer): Boolean;
begin
  Result := ShowConfig(coEdit);
end;

end.
