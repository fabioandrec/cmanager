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
    xXsdSchema: ICXMLDOMSchemaCollection;
    xValid: Boolean;
begin
  {$IFDEF DEBUG}
  MemChk;
  {$ENDIF}
  xExitCode := $FF;
  CoInitialize(Nil);
  if GetSwitch('-h') then begin
    xText := 'CValidate [-x nazwa schematu xsd] -f [nazwa pliku xml]' + sLineBreak +
             '  -f plik xml, który ma zostaæ sprawdzony' + sLineBreak +
             '  -x walidacja wzglêdem wskazanego schematu xsd' + sLineBreak +
             '  -h wyœwietla ten ekran';
  end else begin
    xXmlFilename := GetParamValue('-f');
    xXsdFilename := GetParamValue('-x');
    xXsdSchema := Nil;
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
          try
            xXsdDoc := GetNewDocument;
            xXsdDoc.load(xXsdFilename);
            if xXsdDoc.parseError.errorCode = 0 then begin
              xXsdSchema := GetNewSchema;
              xXsdSchema.add('', xXsdDoc);
              xValid := True;
            end else begin
              xText := 'Plik ' + xXsdFilename + ' nie jest poprawnym dokumentem xml, ' +  GetParseErrorDescription(xXsdDoc.parseError, False);
            end;
          except
            on E: Exception do begin
              xText := E.Message;
            end;
          end;
        end else begin
          xValid := True;
        end;
        if xValid then begin
          try
            xXmlDoc := GetNewDocument;
            xXmlDoc.resolveExternals := True;
            xXmlDoc.validateOnParse := True;
            xXmlDoc.async := False;
            if xXsdSchema <> Nil then begin
              xXmlDoc.schemas := xXsdSchema;
            end;
            xXmlDoc.load(xXmlFilename);
            if xXmlDoc.parseError.errorCode = 0 then begin
              xExitCode := $00;
              Writeln('Plik ' + xXmlFilename + ' jest poprawnym plikiem xml');
            end else begin
              xText := 'Plik ' + xXmlFilename + ' nie jest poprawnym dokumentem xml, ' +  GetParseErrorDescription(xXmlDoc.parseError, False);
            end;
          except
            on E: Exception do begin
              xText := E.Message;
            end;
          end;
        end;
      end;
    end;
  end;
  if xExitCode <> $00 then begin
    Writeln(xText);
  end;
  CoUninitialize;
  Halt(xExitCode);
end.
