program CTransform;

{$APPTYPE CONSOLE}

{$R 'ctransformicons.res' 'ctransformicons.rc'}

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
    xOutput: TStringList;
    xXmlFilename, xXslFilename, xOutputFilename: String;
    xXmlDoc, xXslDoc: ICXMLDOMDocument;
    xAutorun, xOverride, xCanSave: Boolean;
begin
  {$IFDEF DEBUG}
  MemChk;
  {$ENDIF}
  xExitCode := $FF;
  CoInitialize(Nil);
  if GetSwitch('-h') then begin
    xText := 'CTransform -x [nazwa pliku xml] -t [nazwa pliku arkusza styli] [-f [nazwa pliku wyjœciowego]] [-a] [-o]' + sLineBreak +
             '  -x okreœla plik wejœciowy, który ma zostaæ przetworzony' + sLineBreak +
             '  -t okreœla plik arkusza styli, wzglêdem którego nast¹pi przetworzenie' + sLineBreak +
             '  -f okreœla nazwê pliku, do którego zostanie zapisany wynik transformacji, parametr opcjonalny,' + sLineBreak +
             '     je¿eli nie zostanie podany wynik zostanie zapisany na standardowe wyjœcie' + sLineBreak +
             '  -a po poprawnym przetworzeniu uruchom plik wynikowy w domyœlnej przegl¹darce, parametr dostêpny' + sLineBreak +
             '     przy jednoczesnym u¿yciu opcji -f' + sLineBreak +
             '  -o zezwalaj na nadpisywanie plików wyjœciowych' + sLineBreak +
             '  -h wyœwietla ten ekran';
  end else begin
    xXmlFilename := GetParamValue('-x');
    xXslFilename := GetParamValue('-t');
    xOutputFilename := GetParamValue('-f');
    xAutorun := GetSwitch('-a');
    xOverride := GetSwitch('-o');
    if xXmlFilename = '' then begin
      xText := 'Brak nazwy pliku xml. Spróbuj CTransform -h';
    end else if xXslFilename = '' then begin
      xText := 'Brak nazwy pliku arkusza styli. Spróbuj CTransform -h';
    end else begin
      if not FileExists(xXmlFilename) then begin
        xText := 'Nie odnaleziono pliku ' + xXmlFilename;
      end else if not FileExists(xXslFilename) then begin
        xText := 'Nie odnaleziono pliku ' + xXslFilename;
      end else if (xOutputFilename = '') and xAutorun then begin
        xText := 'Niedozwolona opcja -a. Spróbuj CTranform -h';
      end else if (xOutputFilename <> '') and FileExists(xOutputFilename) and (not xOverride) then begin
        xText := 'Plik o nazwie ' + xOutputFilename + ' ju¿ istnieje';
      end else begin
        try
          xXmlDoc := CoDOMDocument.Create;
          xXmlDoc.load(xXmlFilename);
          if xXmlDoc.parseError.errorCode = 0 then begin
            try
              xXslDoc := CoDOMDocument.Create;
              xXslDoc.load(xXslFilename);
              if xXslDoc.parseError.errorCode = 0 then begin
                xOutput := TStringList.Create;
                try
                  try
                    xOutput.Text := xXmlDoc.transformNode(xXslDoc);
                    if xOutputFilename = '' then begin
                      Writeln(xOutput.Text);
                      xExitCode := $00;
                    end else begin
                      xCanSave := True;
                      if FileExists(xOutputFilename) then begin
                        if not SysUtils.DeleteFile(xOutputFilename) then begin
                          Writeln(SysErrorMessage(GetLastError));
                          xCanSave := False;
                        end;
                      end;
                      if xCanSave then begin
                        try
                          xOutput.SaveToFile(xOutputFilename);
                          xExitCode := $00;
                          ShellExecute(0, 'open', PChar(xOutputFilename), nil, nil, SW_SHOWNORMAL);
                        except
                          on E: Exception do begin
                            xText := E.Message;
                          end;
                        end;
                      end;
                    end;
                  except
                    on E: Exception do begin
                      xText := E.Message;
                    end;
                  end;
                finally
                  xOutput.Free;
                end;
              end else begin
                xText := 'Plik ' + xXslFilename + ' nie jest poprawnym dokumentem xml, ' + GetParseErrorDescription(xXslDoc.parseError, False);
              end;
            except
              on E: Exception do begin
                xText := E.Message;
              end;
            end;
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
  if xExitCode <> $00 then begin
    Writeln(xText);
  end;
  CoUninitialize;
  Halt(xExitCode);
end.
