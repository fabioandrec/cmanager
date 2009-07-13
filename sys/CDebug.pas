unit CDebug;

interface

var GDebugMode: Boolean = False;
var GDebugLog: String = '';

procedure DebugStartTickCount(AId: String);
procedure DebugEndTickCounting(AId: String; AText: String = '');
procedure DebugSaveToLog(AText: String);

implementation

uses CTools, Windows, SysUtils, DateUtils, Classes;

threadvar LTickList: TStringList;

procedure DebugStartTickCount(AId: String);
begin
  LTickList.Values[AId] := IntToStr(MilliSecondOfTheDay(Now));
end;

procedure DebugEndTickCounting(AId: String; AText: String = '');
var xValue: String;
begin
  if GDebugMode and (GDebugLog <> '') then begin
    xValue := LTickList.Values[AId];
    if xValue <> '' then begin
      SaveToLog(AId + ' ' + AText + ' (' + IntToStr(MilliSecondOfTheDay(Now) - StrToInt64Def(xValue, 0)) + ' msec)', GDebugLog);
    end else begin
      SaveToLog(AId + ' ' + AText, GDebugLog);
    end;
  end;
end;

procedure DebugSaveToLog(AText: String);
begin
  if GDebugMode and (GDebugLog <> '') then begin
    SaveToLog(AText, GDebugLog);
  end;
end;

initialization
  LTickList := TStringList.Create;
finalization
  LTickList.Free;
end.
