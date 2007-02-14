program CUpdate;

{$R 'icons.res' 'icons.rc'}

uses
  Forms,
  CUpdateMainFormUnit in 'CUpdateMainFormUnit.pas' {CUpdateMainForm},
  CComponents in 'CComponents.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TCUpdateMainForm, CUpdateMainForm);
  Application.Run;
end.
