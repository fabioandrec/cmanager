unit CTools;

{$WARN SYMBOL_PLATFORM OFF}

interface

{$WARN SYMBOL_PLATFORM OFF}

uses Windows, Types;

function FileVersion(AName: string): String;
function FileNumbers(AName: String; var AMS, ALS: DWORD): Boolean;
function FileSize(AName: String): Int64;
function GetParamValue(AParam: String): String;
function GetSwitch(ASwitch: String): Boolean;
function StringToStringArray(AString: String; ADelimeter: Char): TStringDynArray;
function LPad(AString: String; AChar: Char; ALength: Integer): String;

implementation

uses SysUtils, Classes;

function FileVersion(AName: string): String;
var xProductVersionMS: DWORD;
    xProductVersionLS: DWORD;
begin
  FileNumbers(AName, xProductVersionMS, xProductVersionLS);
  Result := IntToStr(HiWord(xProductVersionMS)) + '.' + IntToStr(LoWord(xProductVersionMS)) + '.' + IntToStr(HiWord(xProductVersionLS)) + '.' + IntToStr(LoWord(xProductVersionLS));
end;

function FileNumbers(AName: String; var AMS, ALS: DWORD): Boolean;
var xVersionBuffer: Pointer;
    xVersionSize, xDummy: DWord;
    xSize: Integer;
    xVSFixedFileInfo: PVSFixedFileInfo;
begin
  Result := False;
  AMS := 0;
  ALS := 0;
  xVersionSize := GetFileVersionInfoSize(PChar(AName), xDummy);
  if xVersionSize <> 0 then begin
    xSize := xVersionSize;
    GetMem(xVersionBuffer, xSize);
    try
      if GetFileVersionInfo(PChar(AName), xDummy, xVersionSize, xVersionBuffer) and VerQueryValue(xVersionBuffer, '', Pointer(xVSFixedFileInfo), xVersionSize) then begin
        AMS := xVSFixedFileInfo^.dwProductVersionMS;
        ALS := xVSFixedFileInfo^.dwProductVersionLS;
        Result := True;
      end;
    finally
      FreeMem(xVersionBuffer, xSize);
    end;
  end;
end;

function FileSize(AName: String): Int64;
var xS: TSearchRec;
begin
  Result := 0;
  if FindFirst(AName, faAnyFile, xS) = 0 then begin
    Result := Int64(xS.FindData.nFileSizeHigh) shl Int64(32) + Int64(xS.FindData.nFileSizeLow);
  end;
  SysUtils.FindClose(xS);
end;

function GetParamValue(AParam: String): String;
var xCount: Integer;
begin
  Result := '';
  xCount := 1;
  while (xCount <= ParamCount) and (Result = '') do begin
    if AnsiUpperCase(ParamStr(xCount)) = AnsiUpperCase(AParam) then begin
      if (xCount + 1) <= ParamCount then begin
        Result := ParamStr(xCount + 1);
        xCount := xCount + 2;
      end;
    end;
    Inc(xCount);
  end;
end;

function GetSwitch(ASwitch: String): Boolean;
var xCount: Integer;
begin
  Result := False;
  xCount := 1;
  while (xCount <= ParamCount) and (not Result) do begin
    Result := AnsiUpperCase(ParamStr(xCount)) = AnsiUpperCase(ASwitch);
    Inc(xCount);
  end;
end;

function StringToStringArray(AString: String; ADelimeter: Char): TStringDynArray;
var xStr: TStringList;
    xCount: Integer;
begin
  xStr := TStringList.Create;
  xStr.Text := StringReplace(AString, ADelimeter, sLineBreak, [rfReplaceAll, rfIgnoreCase]);
  SetLength(Result, xStr.Count);
  for xCount := 0 to xStr.Count - 1 do begin
    Result[xCount] := xStr.Strings[xCount];
  end;
  xStr.Free;
end;

function LPad(AString: String; AChar: Char; ALength: Integer): String;
begin
  Result := AString;
  while Length(Result) < ALength do begin
    Result := AChar + Result;
  end;
end;

end.
