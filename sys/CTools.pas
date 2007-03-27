unit CTools;

{$WARN SYMBOL_PLATFORM OFF}

interface

{$WARN SYMBOL_PLATFORM OFF}

uses Windows, Types, Contnrs, Classes;

type
  TSum = class(TObject)
  private
    Fvalue: Currency;
    Fname: String;
  public
    property value: Currency read Fvalue write Fvalue;
    property name: String read Fname write Fname;
  end;

  TSumList = class(TObjectList)
  private
    function GetItems(AIndex: Integer): TSum;
    procedure SetItems(AIndex: Integer; const Value: TSum);
    function GetByName(AName: String): TSum;
  public
    constructor CreateWithSum(AName: String; AValue: Currency);
    procedure AddSum(AName: String; AValue: Currency);
    function GetSum(AName: String): Currency; overload;
    function GetSum(ANames: TStringList): Currency; overload;
    function GetSum: Currency; overload;
    property Items[AIndex: Integer]: TSum read GetItems write SetItems;
    property ByName[AName: String]: TSum read GetByName;
  end;


function FileVersion(AName: string): String;
function FileNumbers(AName: String; var AMS, ALS: DWORD): Boolean;
function FileSize(AName: String): Int64;
function GetParamValue(AParam: String): String;
function GetSwitch(ASwitch: String): Boolean;
function StringToStringArray(AString: String; ADelimeter: Char): TStringDynArray;
function LPad(AString: String; AChar: Char; ALength: Integer): String;

implementation

uses SysUtils;

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

procedure TSumList.AddSum(AName: String; AValue: Currency);
var xSum: TSum;
begin
  xSum := ByName[AName];
  if xSum = Nil then begin
    xSum := TSum.Create;
    xSum.name := AName;
    xSum.value := AValue;
    Add(xSum);
  end else begin
    xSum.value := xSum.value + AValue;
  end;
end;

constructor TSumList.CreateWithSum(AName: String; AValue: Currency);
begin
  inherited Create(True);
  AddSum(AName, AValue);
end;

function TSumList.GetByName(AName: String): TSum;
var xCount: Integer;
begin
  Result := Nil;
  xCount := 0;
  while (Result = Nil) and (xCount <= Count - 1) do begin
    if Items[xCount].name = AName then begin
      Result := Items[xCount];
    end;
    Inc(xCount);
  end;
end;

function TSumList.GetItems(AIndex: Integer): TSum;
begin
  Result := TSum(inherited Items[AIndex]);
end;

function TSumList.GetSum(AName: String): Currency;
var xSum: TSum;
begin
  xSum := ByName[AName];
  if xSum = Nil then begin
    Result := 0;
  end else begin
    Result := xSum.value;
  end;
end;

function TSumList.GetSum(ANames: TStringList): Currency;
var xCount: Integer;
begin
  Result := 0;
  for xCount := 0 to ANames.Count - 1 do begin
    Result := Result + GetSum(ANames.Strings[xCount]);
  end;
end;

function TSumList.GetSum: Currency;
var xCount: Integer;
begin
  Result := 0;
  for xCount := 0 to Count - 1 do begin
    Result := Result + Items[xCount].value;
  end;
end;

procedure TSumList.SetItems(AIndex: Integer; const Value: TSum);
begin
  inherited Items[AIndex] := Value;
end;

function RunApp(AAppName: String; AParams: String; AWorkpath: String): Boolean;
var xStartup: TStartupInfo;
    xProcess: TProcessInformation;
    xExit: Cardinal;
begin
  Result := False;
  FillChar(xStartup, SizeOf(TStartupInfo), #0);
  xStartup.cb := SizeOf(STARTUPINFO);
  if CreateProcess(Nil, PChar(AAppName + ' ' + AParams), Nil, Nil, False, 0, Nil, PChar(ExtractFilePath(AWorkpath)), xStartup, xProcess) then begin
    WaitForSingleObject(xProcess.hProcess, INFINITE);
    GetExitCodeProcess(xProcess.hProcess, xExit);
    Result := (xExit = 0);
  end;
end;

end.
