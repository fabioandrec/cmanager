program CUpdate;

{$R 'cupdateicons.res' 'cupdateicons.rc'}

uses
  Forms,
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
  UpdateSystem;
end.
