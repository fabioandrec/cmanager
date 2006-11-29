unit CCompactDatafileFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CProgressFormUnit, ComCtrls, StdCtrls, Buttons, ExtCtrls;

type
  TCCompactDatafileForm = class(TCProgressForm)
  protected
    function DoWork: Boolean; override;
    function GetProgressType: TWaitType; override;
  end;

implementation

{$R *.dfm}

function TCCompactDatafileForm.DoWork: Boolean;
begin
  Sleep(5000);
  Result := True;
end;

function TCCompactDatafileForm.GetProgressType: TWaitType;
begin
  Result := wtAnimate;
end;

end.
