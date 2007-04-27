program CArchive;

{$APPTYPE CONSOLE}

{$R 'carchiveicons.res' 'carchiveicons.rc'}

uses
  Windows,
  ActiveX,
  SysUtils,
  MemCheck in 'MemCheck.pas',
  CTools in '.\Shared\CTools.pas',
  CBackups in 'CBackups.pas',
  CAdox in 'CAdox.pas';

{$R *.res}

var xAction: Integer;
    xExitCode: Integer;
    xOverride: Boolean;
    xText: String;
    xFile, xBackup: String;
begin
  {$IFDEF DEBUG}
  MemChk;
  {$ENDIF}
  xExitCode := $FF;
  CoInitialize(Nil);
  if GetSwitch('-h') then begin
    xText := 'CArchive -[a|x|c|n|h] [-o] -b [nazwa kopii pliku danych] -u [nazwa pliku danych]' + sLineBreak +
             '  -a wykonaj kopiê pliku danych [nazwa pliku danych] i zapisz jako [nazwa kopii pliku danych]' + sLineBreak +
             '  -x odtwórz kopiê pliku danych [nazwa kopii pliku danych] do pliku o nazwie [nazwa pliku danych]' + sLineBreak +
             '  -c kompaktuj plik danych [nazwa pliku danych]' + sLineBreak +
             '  -n utwórz czysty plik danych [nazwa pliku danych]' + sLineBreak +
             '  -o zezwala na nadpisywanie plików' + sLineBreak +
             '  -h wyœwietla ten ekran';
  end else begin
    xAction := 0;
    if GetSwitch('-a') then begin
      xAction := xAction or $01;
    end;
    if GetSwitch('-x') then begin
      xAction := xAction or $02;
    end;
    if GetSwitch('-c') then begin
      xAction := xAction or $04;
    end;
    if GetSwitch('-n') then begin
      xAction := xAction or $08;
    end;
    if (xAction <= 0) or (xAction >= 9) then begin
      xText := 'Niepoprawne parametry wywo³ania. Spróbuj "CArchive -h"';
    end else begin
      xOverride := GetSwitch('-o');
      xFile := GetParamValue('-u');
      xBackup := GetParamValue('-b');
      if xFile = '' then begin
        xText := 'Nie podano nazwy pliku danych';
      end else if (xBackup = '') and (xAction <= $02) then begin
        xText := 'Nie podano nazwy kopii pliku danych';
      end else begin
        if xAction = $01 then begin
          if CmbBackup(xFile, xBackup, xOverride, xText, Nil) then begin
            xExitCode := $00;
          end;
        end else if xAction = $02 then begin
          if CmbRestore(xFile, xBackup, xOverride, xText) then begin
            xExitCode := $00;
          end;
        end else if xAction = $04 then begin
          if CompactDatabase(xFile, xText) then begin
            xExitCode := $00;
          end;
        end else if xAction = $08 then begin
          if xOverride then begin
            if FileExists(xFile) then begin
              DeleteFile(xFile);
            end;
          end;
          if CreateDatabase(xFile, xText) then begin
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
