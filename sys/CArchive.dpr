program CArchive;

{$R 'carchiveicons.res' 'carchiveicons.rc'}

uses
  Forms,
  Windows,
  SysUtils,
  CTools in 'CTools.pas',
  CBackups in 'CBackups.pas',
  MemCheck in 'MemCheck.pas';

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
  Application.Initialize;
  Application.Icon.Handle := LoadIcon(HInstance, 'BASEICON');
  xExitCode := $FF;
  if GetSwitch('-h') then begin
    xExitCode := $00;
    xText := 'CArchive -[a|x|h] [-o] -b [nazwa kopii pliku danych] -u [nazwa pliku danych]' + sLineBreak +
             '  -a wykonaj kopiê pliku danych [nazwa pliku danych] i zapisz jako [nazwa kopii pliku danych]' + sLineBreak +
             '  -x odtwórz kopiê pliku danych [nazwa kopii pliku danych] do pliku o nazwie [nazwa pliku danych]' + sLineBreak +
             '  -o zezwala na nadpisywanie plików' + sLineBreak +
             '  -h wyœwietla ten ekran';
    MessageBox(0, PChar(xText), 'Informacja', MB_OK + MB_ICONINFORMATION);
  end else begin
    xAction := 0;
    if GetSwitch('-a') then begin
      xAction := xAction or $01;
    end;
    if GetSwitch('-x') then begin
      xAction := xAction or $02;
    end;
    if (xAction <= 0) or (xAction >= 3) then begin
      MessageBox(0, 'Niepoprawne parametry wywo³ania. Spróbuj "CArchive -h"', 'B³¹d', MB_OK + MB_ICONERROR);
    end else begin
      xOverride := GetSwitch('-o');
      xFile := GetParamValue('-u');
      xBackup := GetParamValue('-b');
      if xFile = '' then begin
        xText := 'Nie podano nazwy pliku danych';
      end else if xBackup = '' then begin
        xText := 'Nie podano nazwy kopii pliku danych';
      end else begin
        if xAction = $01 then begin
          if CmbBackup(xFile, xBackup, xOverride, xText) then begin
            xExitCode := $00;
          end;
        end else begin
          if CmbRestore(xBackup, xFile, xOverride, xText) then begin
            xExitCode := $00;
          end;
        end;
      end;
      if xExitCode <> $00 then begin
        if xAction = $01 then begin
          xText := 'Podczas wykonywania kopii pliku danych wyst¹pi³ b³¹d.' + sLineBreak + 'Szczegó³y: ' + xText;
        end else begin
          xText := 'Podczas odtwarzania pliku danych z kopii wyst¹pi³ b³¹d.' + sLineBreak + 'Szczegó³y: ' + xText;
        end;
        MessageBox(0, PChar(xText), 'B³¹d', MB_OK + MB_ICONERROR);
      end;
    end;
  end;
  Halt(xExitCode);
end.
