program CQuery;

{$APPTYPE CONSOLE}

{$R 'cqueryicons.res' 'cqueryicons.rc'}

uses
  Windows,
  AdoDb,
  AdoInt,
  ActiveX,
  SysUtils,
  Variants,
  Classes,
  MemCheck in 'MemCheck.pas',
  CTools in 'Shared\CTools.pas',
  CAdotools in 'Shared\CAdotools.pas',
  CXmlTlb in 'Shared\CXmlTlb.pas',  
  CXml in 'Shared\CXml.pas';

{$R *.res}

const
  CConnectionString = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s;Persist Security Info=False';
  CConnectionStringWithPass = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s;Persist Security Info=False;Jet OLEDB:Database Password=%s';


function ConnectToDatabase(ADatafile: String; APassword: String; ADatabase: TADOConnection; var AError: String): Boolean;
begin
  AError := '';
  Result := False;
  if APassword = '' then begin
    ADatabase.ConnectionString := Format(CConnectionString, [ADatafile]);
  end else begin
    ADatabase.ConnectionString := Format(CConnectionStringWithPass, [ADatafile, APassword]);
  end;
  ADatabase.Mode := cmShareDenyNone;
  ADatabase.LoginPrompt := False;
  ADatabase.CursorLocation := clUseClient;
  try
    ADatabase.Open;
    Result := True;
  except
    on E: Exception do begin
      AError := E.Message;
    end;
  end;
end;

function ExecuteSql(ADb: TADOConnection; ASql: String; var AError: String; ADelimeter: String; AToXml, ANoHeader: Boolean): Boolean;
var xSqls: TStringList;
    xCount: Integer;
    xQuery: _Recordset;
    xValue: String;
begin
  Result := True;
  xSqls := TStringList.Create;
  try
    xSqls.Text := StringReplace(StringReplace(ASql, sLineBreak, '', [rfReplaceAll, rfIgnoreCase]), ';', sLineBreak, [rfReplaceAll, rfIgnoreCase]);
    xCount := 0;
    while Result and (xCount <= xSqls.Count - 1) do begin
      try
        xQuery := ADb.Execute(xSqls.Strings[xCount], cmdText);
        if xQuery.State = adStateOpen then begin
          if AToXml then begin
            xValue := GetRowsAsXml(xQuery);
          end else begin
            xValue := GetRowsAsString(xQuery, ADelimeter, ANoHeader);
          end;
          Writeln(xValue);
        end;
      except
        on E: Exception do begin
          AError := E.Message;
          Result := False;
        end;
      end;
      Inc(xCount);
    end;
  finally
    xSqls.Free;
  end;
end;

var xAction: Integer;
    xExitCode: Integer;
    xText: String;
    xFile: String;
    xSql: String;
    xPassword: String;
    xDatabase: TADOConnection;
    xScript: TStringList;
    xDelimeter: String;
    xCode: Integer;
    xToXml: Boolean;
    xNoHeader: Boolean;
begin
  {$IFDEF DEBUG}
  MemChk;
  {$ENDIF}
  xExitCode := $FF;
  CoInitialize(Nil);
  if IsValidXmlparserInstalled(True, False) then begin
    xDelimeter := '';
    if GetSwitch('-h') then begin
      xText := 'CQuery [-s [komenda]] [-x] [-d [separator p�l]] [-w] [-f [plik]] -u [nazwa pliku danych] [-p [has�o do pliku]]' + sLineBreak +
               '  -s wykonaj komend� sql [komenda]' + sLineBreak +
               '  -f wykonaj skrypt sql [plik]' + sLineBreak +
               '  -d rodziela pola zadanym separatorem, akceptuje kody hex np. 0x0a' + sLineBreak +
               '  -x wynik w postaci xml-a' + sLineBreak +
               '  -p wskazuje has�o dost�pu do pliku danych' + sLineBreak +
               '  -w pomija dodawanie nag��wka z nazwami kolumn' + sLineBreak + 
               '  -h wy�wietla ten ekran';
    end else begin
      xAction := 0;
      if GetSwitch('-s') then begin
        xAction := xAction or $01;
        xSql := GetParamValue('-s');
      end;
      if GetSwitch('-f') then begin
        xAction := xAction or $02;
        xSql := GetParamValue('-f');
      end;
      xDelimeter := GetParamValue('-d');
      if xDelimeter <> '' then begin
        if AnsiLowerCase(Copy(xDelimeter, 1, 2)) = '0x' then begin
          xCode := StrToInt64Def('$' + Copy(xDelimeter, 3, MaxInt), -1);
          if xCode >= 0 then begin
            xDelimeter := Chr(xCode);
          end;
        end;
      end;
      xToXml := GetSwitch('-x');
      xNoHeader := GetSwitch('-w');
      if (xAction <= 0) or (xAction >= 3) then begin
        xText := 'Niepoprawne parametry wywo�ania. Spr�buj "CQuery -h"';
      end else begin
        xFile := GetParamValue('-u');
        if xFile = '' then begin
          xText := 'Nie podano nazwy pliku danych';
        end else if (xAction = $02) and (not FileExists(xSql)) then begin
          xText := 'Nie mo�na odnale�� pliku ' + xSql;
        end else begin
          xText := '';
          if xAction = $02 then begin
            xScript := TStringList.Create;
            try
              try
                xScript.LoadFromFile(xSql);
                xSql := xScript.Text;
              except
                on E: Exception do begin
                  xText := E.Message;
                end;
              end;
            finally
              xScript.Free;
            end;
          end;
          if xText = '' then begin
            xPassword := GetParamValue('-p');
            xDatabase := TADOConnection.Create(Nil);
            try
              if ConnectToDatabase(xFile, xPassword, xDatabase, xText) then begin
                if ExecuteSql(xDatabase, xSql, xText, xDelimeter, xToXml, xNoHeader) then begin
                  xExitCode := $00;
                end;
                xDatabase.Close;
              end;
            finally
              xDatabase.Free;
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
