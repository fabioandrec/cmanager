library RunCalc;

{$R *.res}

uses
  Windows,
  ShellApi,
  CPluginTypes in '..\CPluginTypes.pas',
  CPluginConsts in '..\CPluginConsts.pas';

function Plugin_Execute: OleVariant; stdcall; export;
begin
  ShellExecute(0, 'open', 'calc.exe', Nil, Nil, SW_NORMAL);
  VarClear(Result);
end;

function Plugin_Initialize(ACManagerInterface: ICManagerInterface): Boolean; stdcall; export;
begin
  with ACManagerInterface do begin
    SetType(CPLUGINTYPE_JUSTEXECUTE);
    SetCaption('Uruchom kalkulator');
    SetDescription('Uruchamianie kalkulatora');
  end;
  Result := True;
end;

exports
  Plugin_Initialize,
  Plugin_Execute;
end.
