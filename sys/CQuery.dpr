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
  CTools in '.\Shared\CTools.pas';

{$R *.res}

const
  CConnectionString = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s;Persist Security Info=False';

function ConnectToDatabase(ADatafile: String; ADatabase: TADOConnection; var AError: String): Boolean;
begin
  AError := '';
  Result := False;
  ADatabase.ConnectionString := Format(CConnectionString, [ADatafile]);
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

function ExecuteSql(ADb: TADOConnection; ASql: String; var AError: String): Boolean;
var xSqls: TStringList;
    xCount: Integer;
    xQuery: _Recordset;
    xCf: Integer;
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
          for xCf := 0 to xQuery.Fields.Count - 1 do begin
            Write(xQuery.Fields.Item[xCf].Name);
            if xCf <> xQuery.Fields.Count - 1 then begin
              Write(#9);
            end;
          end;
          Writeln;
          while not xQuery.Eof do begin
            for xCf := 0 to xQuery.Fields.Count - 1 do begin
              try
                xValue := xQuery.Fields.Item[xCf].Value;
              except
                xValue := '<b³¹d>';
              end;
              Write(xValue);
              if xCf <> xQuery.Fields.Count - 1 then begin
                Write(#9);
              end;
            end;
            Writeln;
            xQuery.MoveNext;
          end;
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
    xDatabase: TADOConnection;
    xScript: TStringList;
begin
  {$IFDEF DEBUG}
  MemChk;
  {$ENDIF}
  xExitCode := $FF;
  CoInitialize(Nil);
  if GetSwitch('-h') then begin
    xText := 'CQuery [-s komenda] [-f plik] -u [nazwa pliku danych]' + sLineBreak +
             '  -s wykonaj komendê sql [komenda]' + sLineBreak +
             '  -f wykonaj skrypt sql [plik]' + sLineBreak +
             '  -h wyœwietla ten ekran';
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
    if (xAction <= 0) or (xAction >= 3) then begin
      xText := 'Niepoprawne parametry wywo³ania. Spróbuj "CQuery -h"';
    end else begin
      xFile := GetParamValue('-u');
      if xFile = '' then begin
        xText := 'Nie podano nazwy pliku danych';
      end else if (xAction = $02) and (not FileExists(xSql)) then begin
        xText := 'Nie mo¿na odnaleŸæ pliku ' + xSql;
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
          xDatabase := TADOConnection.Create(Nil);
          try
            if ConnectToDatabase(xFile, xDatabase, xText) then begin
              if ExecuteSql(xDatabase, xSql, xText) then begin
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
  CoUninitialize;
  Halt(xExitCode);
end.
