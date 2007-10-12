program CValidate;

{$APPTYPE CONSOLE}

{$R 'cvalidateicons.res' 'cvalidateicons.rc'}

uses
  MemCheck in 'MemCheck.pas',
  SysUtils,
  ShellApi,
  Windows,
  Classes,
  ActiveX,
  CXmlTlb in 'Shared\CXmlTlb.pas',
  CXml in 'Shared\CXml.pas',
  CTools in 'Shared\CTools.pas';

{$R *.res}

var xExitCode: Integer;
    xText: String;
    xXmlFilename, xXsdFilename: String;
    xXmlDoc, xXsdDoc: ICXMLDOMDocument;
    xValid: Boolean;
begin
  {$IFDEF DEBUG}
  MemChk;
  {$ENDIF}
  xExitCode := $FF;
  CoInitialize(Nil);
  if IsValidXmlparserInstalled(True) then begin
    if GetSwitch('-h') then begin
      xText := 'CValidate [-x nazwa schematu xsd] -f [nazwa pliku xml]' + sLineBreak +
               '  -f plik xml, który ma zostaæ sprawdzony' + sLineBreak +
               '  -x walidacja wzglêdem wskazanego schematu xsd' + sLineBreak +
               '  -h wyœwietla ten ekran';
    end else begin
      xXmlFilename := GetParamValue('-f');
      xXsdFilename := GetParamValue('-x');
      if xXmlFilename = '' then begin
        xText := 'Brak nazwy pliku xml. Spróbuj CValidate -h';
      end else begin
        if not FileExists(xXmlFilename) then begin
          xText := 'Nie odnaleziono pliku ' + xXmlFilename;
        end else if (xXsdFilename <> '') and (not FileExists(xXsdFilename)) then begin
          xText := 'Nie odnaleziono pliku ' + xXsdFilename;
        end else begin
          xValid := False;
          if xXsdFilename <> '' then begin
            xXsdDoc := GetDocumentFromFile(xXsdFilename, Nil);
            if xXsdDoc <> Nil then begin
              if xXsdDoc.parseError.errorCode = 0 then begin
                xValid := True;
              end else begin
                xText := 'Plik ' + xXsdFilename + ' nie jest poprawnym dokumentem xml, ' +  GetParseErrorDescription(xXsdDoc.parseError, False);
              end;
            end else begin
              xText := 'Nie mo¿na odczytac pliku ' + xXsdFilename + ', ' +  SysErrorMessage(GetLastError);
            end;
          end else begin
            xValid := True;
          end;
          if xValid then begin
            xXmlDoc := GetDocumentFromFile(xXmlFilename, xXsdDoc);
            if xXmlDoc <> Nil then begin
              if xXmlDoc.parseError.errorCode = 0 then begin
                xExitCode := $00;
                Writeln('Plik ' + xXmlFilename + ' jest poprawnym plikiem xml');
              end else begin
                xText := 'Plik ' + xXmlFilename + ' nie jest poprawnym dokumentem xml, ' +  GetParseErrorDescription(xXmlDoc.parseError, False);
              end;
            end else begin
              xText := 'Nie mo¿na odczytac pliku ' + xXmlFilename + ', ' +  SysErrorMessage(GetLastError);
            end;
          end;
        end;
      end;
    end;
    if xExitCode <> $00 then begin
      Writeln(xText);
    end;
  end;
  CoUninitialize;
  Halt(xExitCode);
end.
