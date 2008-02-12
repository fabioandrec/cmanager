program CArchive;

{$APPTYPE CONSOLE}

{$R 'carchiveicons.res' 'carchiveicons.rc'}

uses
  Windows,
  ActiveX,
  SysUtils,
  {$IFDEF DEBUG}
  MemCheck in 'MemCheck.pas',
  {$ENDIF}
  CTools in '.\Shared\CTools.pas',
  CBackups in 'CBackups.pas',
  CAdox in 'CAdox.pas';

{$R *.res}

var xAction: Integer;
    xExitCode: Integer;
    xOverride: Boolean;
    xText: String;
    xFile, xBackup, xPassword, xNewPassword: String;
begin
  {$IFDEF DEBUG}
  MemChk;
  {$ENDIF}
  xExitCode := $FF;
  CoInitialize(Nil);
  if GetSwitch('-h') then begin
    xText := 'CArchive -[a|x|c|n|h|s] [-o] -b [nazwa kopii pliku danych] -u [nazwa pliku danych]' + sLineBreak +
             '  -a wykonaj kopiê pliku danych [nazwa pliku danych] i zapisz jako [nazwa kopii pliku danych]' + sLineBreak +
             '  -x odtwórz kopiê pliku danych [nazwa kopii pliku danych] do pliku o nazwie [nazwa pliku danych]' + sLineBreak +
             '  -c kompaktuj plik danych [nazwa pliku danych]' + sLineBreak +
             '  -n utwórz czysty plik danych [nazwa pliku danych]' + sLineBreak +
             '  -s ustawia/zmienia has³o dostêpu do pliku danych' + sLineBreak +
             '  -o zezwala na nadpisywanie plików' + sLineBreak +
             '  -p wskazuje has³o dostêpu do pliku danych (dla opcji -s okreœla poprzednie has³o)' + sLineBreak +
             '  -z okreœla nowe has³o dostêpu do pliku danych (tylko z opcj¹ -s)' + sLineBreak +
             '  -h wyœwietla ten ekran';
  end else begin
    xAction := 0;
    if GetSwitch('-a') then begin
      xAction := xAction or 1;
    end;
    if GetSwitch('-x') then begin
      xAction := xAction or 2;
    end;
    if GetSwitch('-c') then begin
      xAction := xAction or 4;
    end;
    if GetSwitch('-n') then begin
      xAction := xAction or 8;
    end;
    if GetSwitch('-s') then begin
      xAction := xAction or 16;
    end;
    if not (xAction in [1, 2, 4, 8, 16]) then begin
      xText := 'Niepoprawne parametry wywo³ania. Spróbuj "CArchive -h"';
    end else begin
      xOverride := GetSwitch('-o');
      xFile := GetParamValue('-u');
      xBackup := GetParamValue('-b');
      xPassword := GetParamValue('-p');
      xNewPassword := GetParamValue('-z');
      if xFile = '' then begin
        xText := 'Nie podano nazwy pliku danych';
      end else if (xBackup = '') and (xAction <= $02) then begin
        xText := 'Nie podano nazwy kopii pliku danych';
      end else begin
        if xAction = 1 then begin
          if CmbBackup(xFile, xBackup, xOverride, xText, Nil) then begin
            xExitCode := $00;
          end;
        end else if xAction = 2 then begin
          if CmbRestore(xFile, xBackup, xOverride, xText) then begin
            xExitCode := $00;
          end;
        end else if xAction = 4 then begin
          if CompactDatabase(xFile, xPassword, xText) then begin
            xExitCode := $00;
          end;
        end else if xAction = 8 then begin
          if xOverride then begin
            if FileExists(xFile) then begin
              DeleteFile(xFile);
            end;
          end;
          if CreateDatabase(xFile, xPassword, xText) then begin
            xExitCode := $00;
          end;
        end else if xAction = 16 then begin
          if ChangeDatabasePassword(xFile, xPassword, xNewPassword, xText) then begin
            xExitCode := $00;
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
