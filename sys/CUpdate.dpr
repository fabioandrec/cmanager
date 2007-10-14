program CUpdate;

{$R 'cupdateicons.res' 'cupdateicons.rc'}

uses
  Forms,
  Windows,
  CUpdateMainFormUnit in 'CUpdateMainFormUnit.pas' {CUpdateMainForm},
  CComponents in 'CComponents.pas',
  {$IFDEF DEBUG}
  MemCheck in 'MemCheck.pas',
  {$ENDIF}
  CRichtext in '.\Shared\CRichtext.pas',
  CXmlTlb in 'Shared\CXmlTlb.pas',  
  CXml in '.\Shared\CXml.pas',
  CTools in '.\Shared\CTools.pas',
  CHttpRequest in '.\Shared\CHttpRequest.pas';

{$R *.res}

begin
  {$IFDEF DEBUG}
  MemChk;
  {$ENDIF}
  Application.Initialize;
  if IsValidXmlparserInstalled(True, True) then begin
    Application.Icon.Handle := LoadIcon(HInstance, 'BASEICON');
    UpdateSystem;
  end;
end.
