unit CHelp;

interface

uses HH, SysUtils;

procedure HelpCloseAll;
procedure HelpShowDefault;

var GHelpFilename: String;

implementation

procedure HelpCloseAll;
begin
  if Assigned(HtmlHelp) then begin
    HtmlHelp(0, '', HH_CLOSE_ALL, 0);
  end;
end;

procedure HelpShowDefault;
begin
  if Assigned(HtmlHelp) then begin
    HtmlHelp(0, PChar(GHelpFilename), HH_DISPLAY_TOC, 0);
  end;
end;

initialization
  GHelpFilename := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + '\help\cmanager.chm';
end.
