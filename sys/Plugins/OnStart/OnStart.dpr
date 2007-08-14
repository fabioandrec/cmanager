library OnStart;

{$R *.res}

uses
  Windows,
  Dialogs,
  Forms,
  Variants,
  SysUtils,
  Classes,
  AdoInt,
  CPluginTypes in '..\CPluginTypes.pas',
  CPluginConsts in '..\CPluginConsts.pas',
  CTools in '..\..\Shared\CTools.pas',
  StartupFormUnit in 'StartupFormUnit.pas' {StartupForm};

var CManInterface: ICManagerInterface;

function Plugin_Initialize(ACManagerInterface: ICManagerInterface): Boolean; stdcall; export;
begin
  CManInterface := ACManagerInterface;
  with CManInterface do begin
    Application.Handle := GetAppHandle;
    SetType(CPLUGINTYPE_ONSTARTUP);
    SetCaption('Poka¿ okno');
    SetDescription('Pokazuje okno na starcie');
    GShutdownEvent := CManInterface.GetShutdownEvent;
  end;
  Result := True;
end;

function Plugin_Execute: OleVariant; stdcall; export;
begin
  VarClear(Result);
  if GStartupForm = Nil then begin
    GStartupForm := TStartupForm.Create(Nil);
  end;
  GStartupForm.Show;
end;

procedure Plugin_Finalize; stdcall; export;
begin
  if GStartupForm <> Nil then begin
    FreeAndNil(GStartupForm);
  end;
end;

exports
  Plugin_Initialize,
  Plugin_Execute,
  Plugin_Finalize;
end.
