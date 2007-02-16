program CUpdate;

{$R 'cupdateicons.res' 'cupdateicons.rc'}

uses
  Forms,
  Windows,
  CUpdateMainFormUnit in 'CUpdateMainFormUnit.pas' {CUpdateMainForm},
  CComponents in 'CComponents.pas',
  MemCheck in 'MemCheck.pas',
  CRichtext in 'CRichtext.pas',
  CXml in 'CXml.pas',
  CTools in 'CTools.pas';

{$R *.res}

begin
  MemChk;
  Application.Initialize;
  Application.Icon.Handle := LoadIcon(HInstance, 'BASEICON');
  UpdateSystem;
end.
