unit CTools;

{$WARN SYMBOL_PLATFORM OFF}

interface

{$WARN SYMBOL_PLATFORM OFF}

uses Windows, Types, Contnrs, Classes, StdCtrls;

const
  CEmptyDataGid = '';

type
  TPolishEncodings = (splASCII, splISO, splLatinII, splMazovia, splWindows);

  TSum = class(TObject)
  private
    Fvalue: Currency;
    Fname: String;
    Fcurrency: String;
  public
    property value: Currency read Fvalue write Fvalue;
    property name: String read Fname write Fname;
    property currency: String read Fcurrency write Fcurrency;
  end;

  TSumList = class(TObjectList)
  private
    function GetItems(AIndex: Integer): TSum;
    procedure SetItems(AIndex: Integer; const Value: TSum);
    function GetByNameCurrency(AName, ACurrency: String): TSum;
  public
    constructor CreateWithSum(AName: String; AValue: Currency; ACurrency: String);
    procedure AddSum(AName: String; AValue: Currency; ACurrency: String);
    function GetSum(AName: String; ACurrency: String): Currency; overload;
    function GetSum(ANames: TStringList; ACurrency: String): Currency; overload;
    function GetSum(ACurrency: String): Currency; overload;
    property Items[AIndex: Integer]: TSum read GetItems write SetItems;
    property ByNameCurrency[AName, ACurrency: String]: TSum read GetByNameCurrency;
  end;

  TConsoleRedirect = class(TObject)
  private
    FStartupInfo: TStartupInfo;
    FProcessInfo: TProcessInformation;
    FStdSecurityAttributes: TSecurityAttributes;
    FErrSecurityAttributes: TSecurityAttributes;
    FIsRunning: Boolean;
    FCmdLine: String;
    FParameters: String;
    FReadStdPipe: THandle;
    FWriteStdPipe: THandle;
    FReadErrPipe: THandle;
    FWriteErrPipe: THandle;
    procedure ReadRedirectedOutput(APipe: THandle; AOutput: TStrings);
  public
    constructor Create(ACmdLine, AParameters: String);
    function Execute(AStdOutput: TStrings; AErrOutput: TStrings; var AExitCode: Cardinal): Cardinal;
  published
    property StartupInfo: TStartupInfo read FStartupInfo;
    property ProcessInfo: TProcessInformation read FProcessInfo;
    property IsRunning: Boolean read FIsRunning;
    property CmdLine: String read FCmdLine;
    property Parameters: String read FParameters;
  end;

  TVariantDynArray = array of Variant;

function FileVersion(AName: string): String;
function FileNumbers(AName: String; var AMS, ALS: DWORD): Boolean;
function FileSize(AName: String): Int64;
function GetParamValue(AParam: String): String;
function GetSwitch(ASwitch: String): Boolean;
function StringToStringArray(AString: String; ADelimeter: String): TStringDynArray;
function StringToVariantArray(AString: String; ADelimeter: String): TVariantDynArray;
function LPad(AString: String; AChar: Char; ALength: Integer): String;
function RPad(AString: String; AChar: Char; ALength: Integer): String;
function RunApplication(ACmdline, AParams: String; var AOutputInfo: String): Boolean;
procedure SaveToLog(AText: String; ALogFilename: String);
function StrToCurrencyDecimalDot(AStr: String): Currency; overload;
function StrToCurrencyDecimalDot(AStr: String; var AOut: Currency): Boolean; overload;
function StrToDatetime(ADateTime: String; ADateFormat, ATimeFormat, ADateSeparator, ATimeSeparator: String; var AOutput: TDateTime): Boolean;
procedure FillCombo(ACombo: TComboBox; const AList: array of String; AItemIndex: Integer = 0);
function PolishConversion(AStdIn, AStdOut: TPolishEncodings; ALine: string): string;
function GetDescText(ADescription: String; ALineNo: Integer = 0; AWithInfo: Boolean = True): String;
function ReplaceLinebreaks(AText: String; AWith: String = '<br>'): String;
function CreateNewGuid: String;
function IsEvenToStr(AInt: Integer): String; overload;
function IsEven(AInt: Integer): Boolean; overload;
function DataGidToDatabase(ADataGid: String): String;
function DatetimeToDatabase(ADatetime: TDateTime; AWithTime: Boolean): String;
function CurrencyToDatabase(ACurrency: Currency): String;
function TrimStr(AStr: String; AUnwanted: String): String;
function WrapTextToLength(AText: String; ALength: Integer): String;
function GetMonthNumber(AMonthName: String): Integer;
function Date2StrDate(ADateTime: TDateTime; AWithTime: Boolean = False): String;
function DateTimeUptoMinutes(ADateTime: TDateTime): TDateTime;
function GetStringFromResources(AResName: String; AResType: PChar): String;
procedure GetFileFromResource(AResName: String; AResType: PChar; AFilename: String);
function XsdToDateTime(ADateTimeStr: String): TDateTime;
function DateTimeToXsd(ADateTime: TDateTime; AYearFirst: Boolean = True; AWithTime: Boolean = True): String;
function IntToStrWithSign(AInteger: Integer): String;
function GetStartQuarterOfTheYear(ADateTime: TDateTime): TDateTime;
function GetEndQuarterOfTheYear(ADateTime: TDateTime): TDateTime;
function GetQuarterOfTheYear(ADateTime: TDateTime): Integer;
function GetStartHalfOfTheYear(ADateTime: TDateTime): TDateTime;
function GetEndHalfOfTheYear(ADateTime: TDateTime): TDateTime;
function GetHalfOfTheYear(ADateTime: TDateTime): Integer;
function GetFormattedDate(ADate: TDateTime; AFormat: String): String;
function GetFormattedTime(ADate: TDateTime; AFormat: String): String;
function GetSystemPathname(AFilename: String): String;

implementation

uses SysUtils, StrUtils, DateUtils;

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

function StringToStringArray(AString: String; ADelimeter: String): TStringDynArray;
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

function StringToVariantArray(AString: String; ADelimeter: String): TVariantDynArray;
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

function RPad(AString: String; AChar: Char; ALength: Integer): String;
begin
  Result := AString;
  while Length(Result) < ALength do begin
    Result := Result + AChar;
  end;
end;

procedure TSumList.AddSum(AName: String; AValue: Currency; ACurrency: String);
var xSum: TSum;
begin
  xSum := ByNameCurrency[AName, ACurrency];
  if xSum = Nil then begin
    xSum := TSum.Create;
    xSum.name := AName;
    xSum.value := AValue;
    xSum.currency := ACurrency;
    Add(xSum);
  end else begin
    xSum.value := xSum.value + AValue;
  end;
end;

constructor TSumList.CreateWithSum(AName: String; AValue: Currency; ACurrency: String);
begin
  inherited Create(True);
  AddSum(AName, AValue, ACurrency);
end;

function TSumList.GetByNameCurrency(AName, ACurrency: String): TSum;
var xCount: Integer;
begin
  Result := Nil;
  xCount := 0;
  while (Result = Nil) and (xCount <= Count - 1) do begin
    if (Items[xCount].name = AName) and (Items[xCount].currency = ACurrency) then begin
      Result := Items[xCount];
    end;
    Inc(xCount);
  end;
end;

function TSumList.GetItems(AIndex: Integer): TSum;
begin
  Result := TSum(inherited Items[AIndex]);
end;

function TSumList.GetSum(AName: String; ACurrency: String): Currency;
var xSum: TSum;
begin
  xSum := ByNameCurrency[AName, ACurrency];
  if xSum = Nil then begin
    Result := 0;
  end else begin
    Result := xSum.value;
  end;
end;

function TSumList.GetSum(ANames: TStringList; ACurrency: String): Currency;
var xCount: Integer;
begin
  Result := 0;
  for xCount := 0 to ANames.Count - 1 do begin
    Result := Result + GetSum(ANames.Strings[xCount], ACurrency);
  end;
end;

function TSumList.GetSum(ACurrency: String): Currency;
var xCount: Integer;
begin
  Result := 0;
  for xCount := 0 to Count - 1 do begin
    if Items[xCount].currency = ACurrency then begin
      Result := Result + Items[xCount].value;
    end;
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

procedure DisableProcessWindowsGhosting; 
type TDisableProcessWindowsGhostingProc = procedure; stdcall;
const CUser32 = 'User32.dll';
var xModH: HMODULE;
    xDisableProcessWindowsGhosting: TDisableProcessWindowsGhostingProc;
begin
  xModH := GetModuleHandle(CUser32);
  if xModH <> 0 then begin
    @xDisableProcessWindowsGhosting := nil;
    @xDisableProcessWindowsGhosting := GetProcAddress(xModH, 'DisableProcessWindowsGhosting');
    If Assigned(xDisableProcessWindowsGhosting) then begin
      xDisableProcessWindowsGhosting;
    end;
  end;
end;

constructor TConsoleRedirect.Create(ACmdLine, AParameters: String);
begin
  inherited Create;
  FCmdLine := ACmdLine;
  FParameters := AParameters;
  FIsRunning := False;
end;

function TConsoleRedirect.Execute(AStdOutput: TStrings; AErrOutput: TStrings; var AExitCode: Cardinal): Cardinal;
var xCommand: String;
    xRes: Cardinal;
begin
  FIsRunning := False;
  Result := ERROR_SUCCESS;
  xCommand := '"' + FCmdLine + '" ' + FParameters;
  FillChar(FStartupInfo, SizeOf(FStartupInfo), #0);
  FillChar(FStdSecurityAttributes, SizeOf(FStdSecurityAttributes), #0);
  FillChar(FErrSecurityAttributes, SizeOf(FErrSecurityAttributes), #0);
  FillChar(FProcessInfo, SizeOf(FProcessInfo), #0);
  with FStdSecurityAttributes do begin
    nLength := Sizeof(FStdSecurityAttributes);
    bInheritHandle := True
  end;
  with FErrSecurityAttributes do begin
    nLength := Sizeof(FErrSecurityAttributes);
    bInheritHandle := True
  end;
  if CreatePipe(FReadStdPipe, FWriteStdPipe, @FStdSecurityAttributes, 0) then begin
    if CreatePipe(FReadErrPipe, FWriteErrPipe, @FErrSecurityAttributes, 0) then begin
      try
        SetHandleInformation(FReadStdPipe, HANDLE_FLAG_INHERIT, 0);
        SetHandleInformation(FReadErrPipe, HANDLE_FLAG_INHERIT, 0);
        with FStartupInfo do begin
          cb := SizeOf(StartupInfo);
          dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
          wShowWindow := SW_HIDE;
          hStdOutput := FWriteStdPipe;
          hStdError := FWriteErrPipe;
        end;
        if CreateProcess(nil, PChar(xCommand), nil, nil, True, CREATE_NEW_CONSOLE, nil, nil, FStartupInfo, FProcessInfo) then begin
          CloseHandle(FWriteStdPipe);
          FWriteStdPipe := INVALID_HANDLE_VALUE;
          CloseHandle(FWriteErrPipe);
          FWriteErrPipe := INVALID_HANDLE_VALUE;
          try
            FIsRunning := True;
            repeat
              ReadRedirectedOutput(FReadStdPipe, AStdOutput);
              ReadRedirectedOutput(FReadErrPipe, AErrOutput);
              xRes := WaitForSingleObject(ProcessInfo.hProcess, 0);
              if xRes = WAIT_OBJECT_0 then begin
                FIsRunning := False;
              end else if xRes = WAIT_FAILED then begin
                FIsRunning := False;
                Result := GetLastError;
              end;
            until not FIsRunning;
          finally
            CloseHandle(FProcessInfo.hThread);
            CloseHandle(FProcessInfo.hProcess);
          end;
        end else begin
          Result := GetLastError;
        end;
      finally
        CloseHandle(FReadStdPipe);
        CloseHandle(FReadErrPipe);
        if FWriteStdPipe <> INVALID_HANDLE_VALUE then begin
          CloseHandle(FWriteStdPipe);
        end;
        if FWriteErrPipe <> INVALID_HANDLE_VALUE then begin
          CloseHandle(FWriteErrPipe);
        end;
      end;
    end else begin
      Result := GetLastError;
    end;
  end else begin
    Result := GetLastError;
  end;
end;

procedure TConsoleRedirect.ReadRedirectedOutput(APipe: THandle; AOutput: TStrings);
var xBuffer: Array[0..1024] of Char;
    xRead: Cardinal;
    xFinished: Boolean;
begin
  xFinished := False;
  repeat
    if ReadFile(APipe, xBuffer, 1024, xRead, Nil) then begin
      if xRead > 0 then begin
        xBuffer[xRead + 1] := #0;
        AOutput.Text := AOutput.Text + StrPas(xBuffer);
      end else begin
        xFinished := True;
      end;
    end else begin
      xFinished := True;
    end;
  until xFinished;
end;

function RunApplication(ACmdline, AParams: String; var AOutputInfo: String): Boolean;
var xRedir: TConsoleRedirect;
    xOut, xErr: TStringList;
    xExitCode: Cardinal;
    xResult: Cardinal;
begin
  xOut := TStringList.Create;
  xErr := TStringList.Create;
  xRedir := TConsoleRedirect.Create(ACmdline, AParams);
  xResult := xRedir.Execute(xOut, xErr, xExitCode);
  if xResult <> ERROR_SUCCESS then begin
    AOutputInfo := SysErrorMessage(xResult);
    Result := False;
  end else begin
    AOutputInfo := xOut.Text;
    Result := xExitCode = 0;
  end;
  xRedir.Free;
  xErr.Free;
  xOut.Free;
end;

procedure SaveToLog(AText: String; ALogFilename: String);
var xStream: TFileStream;
    xText: String;
begin
  if (ALogFilename <> '') then begin
    xText := FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now) + #9 + StringReplace(AText, sLineBreak, '', [rfReplaceAll, rfIgnoreCase]);
    if PosEx(sLineBreak, xText, Length(xText) - Length(sLineBreak)) = 0 then begin
      xText := xText + sLineBreak;
    end;
    if FileExists(ALogFilename) then begin
      xStream := TFileStream.Create(ALogFilename, fmOpenReadWrite or fmShareDenyWrite);
    end else begin
      xStream := TFileStream.Create(ALogFilename, fmCreate or fmShareDenyWrite);
    end;
    xStream.Seek(0, soFromEnd);
    xStream.WriteBuffer(xText[1], Length(xText));
    xStream.Free;
  end;
end;

function DmyToDate(AString: String; ADefault: TDateTime): TDateTime;
var xY, xM, xD: Word;
    xStr: String;
begin
  xStr := StringReplace(AString, '-', '', [rfReplaceAll, rfIgnoreCase]);
  xStr := StringReplace(xStr, ':', '', [rfReplaceAll, rfIgnoreCase]);
  xStr := StringReplace(xStr, ' ', '', [rfReplaceAll, rfIgnoreCase]);
  xStr := StringReplace(xStr, 'T', '', [rfReplaceAll, rfIgnoreCase]);
  xD := StrToIntDef(Copy(xStr, 1, 2), 0);
  xM := StrToIntDef(Copy(xStr, 3, 2), 0);
  xY := StrToIntDef(Copy(xStr, 5, 4), 0);
  if not TryEncodeDate(xY, xM, xD, Result) then begin
    Result := ADefault;
  end;
end;

function StrToCurrencyDecimalDot(AStr: String): Currency;
var xStr: String;
begin
  xStr := StringReplace(AStr, '.', DecimalSeparator, [rfReplaceAll, rfIgnoreCase]);
  xStr := StringReplace(xStr, ',', DecimalSeparator, [rfReplaceAll, rfIgnoreCase]);
  Result := StrToFloatDef(xStr, 0);
end;

function StrToCurrencyDecimalDot(AStr: String; var AOut: Currency): Boolean; overload;
var xStr: String;
begin
  xStr := StringReplace(AStr, '.', DecimalSeparator, [rfReplaceAll, rfIgnoreCase]);
  xStr := StringReplace(xStr, ',', DecimalSeparator, [rfReplaceAll, rfIgnoreCase]);
  try
    AOut := StrToFloat(xStr);
    Result := True;
  except
    Result := False;
  end;
end;

procedure FillCombo(ACombo: TComboBox; const AList: array of String; AItemIndex: Integer = 0);
var xCount: Integer;
begin
  ACombo.Items.BeginUpdate;
  ACombo.Clear;
  for xCount := Low(AList) to High(AList) do begin
    if AList[xCount] <> '' then begin
      ACombo.Items.Add(AList[xCount]);
    end;
  end;
  if ACombo.Items.Count >= AItemIndex then begin
   ACombo.ItemIndex := AItemIndex;
  end;
  ACombo.Items.EndUpdate;
end;

function IsEvenToStr(AInt: Integer): String;
begin
  Result := IfThen(IsEven(AInt), 'even', '');
end;

function IsEven(AInt: Integer): Boolean;
begin
  Result := not Odd(AInt);
end;

function GetMonthNumber(AMonthName: String): Integer;
var xName: String;
    xCount: Integer;
begin
  xName := AnsiUpperCase(AMonthName);
  xCount := Low(LongMonthNames);
  Result := 0;
  while (xCount <= High(LongMonthNames)) and (Result = 0) do begin
    if AnsiUpperCase(LongMonthNames[xCount]) = AMonthName then begin
      Result := xCount;
    end;
    Inc(xCount);
  end;
end;

function PolishConversion(AStdIn, AStdOut: TPolishEncodings; ALine: string): string;
const xPolishCount = 18;
      xTabCode: array[TPolishEncodings, 1..xPolishCount] of Char =
      ((#65, #67, #69, #76, #78, #79, #83, #90, #90, #97, #99, #101, #108, #110, #111, #115, #122, #122),
        (#161, #198, #202, #163, #209, #211, #166, #172, #175, #177, #230, #234, #179, #241, #243, #182, #188, #191),
        (#164, #143, #168, #157, #227, #224, #151, #141, #189, #165, #134, #169, #136, #228, #162, #152, #171, #190),
        (#143, #149, #144, #156, #165, #163, #152, #160, #161, #134, #141, #145, #146, #164, #162, #158, #166, #167),
        (#165, #198, #202, #163, #209, #211, #140, #143, #175, #185, #230, #234, #179, #241, #243, #156, #159, #191));
      xTabSets: array[TPolishEncodings] of set of Char =
      ([#97, #99, #101, #108, #110, #111, #115, #120, #122, #65, #67, #69, #76, #78, #79, #83, #88, #90],
        [#161, #198, #202, #163, #209, #211, #166, #172, #175, #177, #230, #234, #179, #241, #243, #182, #188, #191],
        [#164, #143, #168, #157, #227, #224, #151, #141, #189, #165, #134, #169, #136, #228, #162, #152, #171, #190],
        [#143, #149, #144, #156, #165, #163, #152, #160, #161, #134, #141, #145, #146, #164, #162, #158, #166, #167],
        [#165, #198, #202, #163, #209, #211, #140, #143, #175, #185, #230, #234, #179, #241, #243, #156, #159, #191]);
var xCountI, xCountJ: integer;
    xChanged: boolean;
begin
  Result := ALine;
  if (AStdIn <> AStdOut) and (AStdIn <> splASCII) then begin
    for xCountI := 1 to length(Result) do begin
      if Result[xCountI] in xTabSets[AStdIn] then begin
        xChanged := false;
        xCountJ := 1;
        repeat
          if Result[xCountI] = xTabCode[AStdIn, xCountJ] then begin
            Result[xCountI] := xTabCode[AStdOut, xCountJ];
            xChanged := True;
          end;
          inc(xCountJ);
        until (xCountJ > xPolishCount) or xChanged;
      end;
    end;
  end;
end;

function GetDescText(ADescription: String; ALineNo: Integer = 0; AWithInfo: Boolean = True): String;
var xStr: TStringList;
begin
  if ALineNo <> -1 then begin
    xStr := TStringList.Create;
    xStr.Text := ADescription;
    if ALineNo <= xStr.Count - 1 then begin
      Result := xStr.Strings[ALineNo];
      if AWithInfo and (xStr.Count > 1) then begin
        Result := Result + ' (...)';
      end;
    end else begin
      Result := ADescription;
    end;
    xStr.Free;
  end else begin
    Result := ADescription;
  end;
end;

function ReplaceLinebreaks(AText: String; AWith: String = '<br>'): String;
begin
  Result := StringReplace(AText, sLineBreak, AWith, [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, Chr(10), AWith, [rfReplaceAll, rfIgnoreCase]);
end;

function CreateNewGuid: String;
var xGuid: TGUID;
begin
  CreateGUID(xGuid);
  Result := GUIDToString(xGuid);
end;

function DataGidToDatabase(ADataGid: String): String;
begin
  Result := IfThen(ADataGid = CEmptyDataGid, 'Null', '''' + ADataGid + '''');
end;

function CurrencyToDatabase(ACurrency: Currency): String;
var xFormat: TFormatSettings;
begin
  GetLocaleFormatSettings(LOCALE_USER_DEFAULT, xFormat);
  xFormat.DecimalSeparator := '.';
  Result := CurrToStr(ACurrency, xFormat);
end;

function DatetimeToDatabase(ADatetime: TDateTime; AWithTime: Boolean): String;
begin
  if ADatetime = 0 then begin
    Result := 'Null';
  end else begin
    if not AWithTime then begin
      Result := '#' + FormatDateTime('yyyy-mm-dd', ADatetime) + '#';
    end else begin
      Result := '#' + FormatDateTime('yyyy-mm-dd hh:nn:ss', ADatetime) + '#';
    end;
  end;
end;

function TrimStr(AStr: String; AUnwanted: String): String;
var xLenUnwanted: Integer;
begin
  Result := AStr;
  xLenUnwanted := Length(AUnwanted);
  while Copy(Result, 1, xLenUnwanted) = AUnwanted do begin
    Delete(Result, 1, xLenUnwanted);
  end;
  while Copy(Result, Length(Result) - xLenUnwanted + 1, xLenUnwanted) = AUnwanted do begin
    Delete(Result, Length(Result) - xLenUnwanted + 1, xLenUnwanted);
  end;
end;

function WrapTextToLength(AText: String; ALength: Integer): String;
var xStr: TStringList;
    xCount: Integer;
    xCurr: String;
    xPos: Integer;
begin
  xStr := TStringList.Create;
  xStr.Text := AText;
  for xCount := 0 to xStr.Count - 1 do begin
    xCurr := WrapText(xStr.Strings[xCount], ALength);
    xPos := Pos(sLineBreak, xCurr);
    if xPos > 0 then begin
      xStr.Strings[xCount] := Copy(xCurr, 1, xPos - 1);
      Delete(xCurr, 1, xPos + Length(sLineBreak) - 1);
      if Length(xCurr) > 0 then begin
        if xCount + 1 <= xStr.Count - 1 then begin
          xStr.Strings[xCount + 1] := xCurr + ' ' + xStr.Strings[xCount + 1];
        end else begin
          xStr.Add(xCurr);
        end;
      end;
    end;
  end;
  Result := '';
  for xCount := 0 to xStr.Count - 1 do begin
    Result := Result + xStr.Strings[xCount] + IfThen(xCount < xStr.Count - 1, sLineBreak, '');
  end;
  xStr.Free;
end;

function Date2StrDate(ADateTime: TDateTime; AWithTime: Boolean = False): String;
begin
  if AWithTime then begin
    DateTimeToString(Result, ShortDateFormat + ' hh:nn', ADateTime);
  end else begin
    Result := DateToStr(ADateTime);
  end;
end;

function DateTimeUptoMinutes(ADateTime: TDateTime): TDateTime;
var xY, xM, xD, xH, xN, xS, xMs: Word;
begin
  DecodeDateTime(ADateTime, xY, xM, xD, xH, xN, xS, xMs);
  Result := EncodeDateTime(xY, xM, xD, xH, xN, 0, 0);
end;

function GetStringFromResources(AResName: String; AResType: PChar): String;
var xResStr: TResourceStream;
    xStrStr: TStringStream;
begin
  xStrStr := TStringStream.Create('');
  try
    xResStr := TResourceStream.Create(HInstance, AResName, AResType);
    xStrStr.CopyFrom(xResStr, xResStr.Size);
    Result := xStrStr.DataString;
    xResStr.Free;
  finally
    xStrStr.Free;
  end;
end;

function GetTimeZoneBias : Longint;
var xTzinfo: TTimeZoneInformation;
begin
  Result:= 0;
  case GetTimeZoneInformation(xTzinfo) of
    TIME_ZONE_ID_STANDARD: begin
      Result := xTzinfo.Bias;
    end;
    TIME_ZONE_ID_DAYLIGHT: begin
      Result := xTzinfo.Bias;
    end;
  end;
end;

function GetTimeZoneAdjustment : String;
var xBias: Longint;
begin
  xBias := GetTimeZoneBias;
  if (xBias = 0) then begin
    Result := 'GMT'
  end else if (xBias < 0) then begin
    Result := '+' + LPad(IntToStr(Abs(xBias) div 60), '0', 2) + ':'
                             + LPad(IntToStr(Abs(xBias) mod 60), '0', 2)
  end else if (xBias > 0) then begin
    Result := '-' + LPad(IntToStr(xBias div 60), '0', 2) + ':'
                             + LPad(IntToStr(xBias mod 60), '0', 2);
  end;
end;

function DateTimeToXsd(ADateTime: TDateTime; AYearFirst: Boolean = True; AWithTime: Boolean = True): String;
begin
  Result := FormatDateTime(IfThen(AYearFirst, 'yyyy-mm-dd', 'dd-mm-yyyy'), ADateTime) +
            IfThen(AWithTime, 'T', '') + IfThen(AWithTime, FormatDateTime('hh:nn:ss.zzz', ADateTime)) +
            IfThen(AWithTime, GetTimeZoneAdjustment, '');
end;

procedure AddTimeBias(var ADateTime: TDateTime; ABias: Longint);
var xH, xM: Word;
    xT : TDateTime;
begin
  if (ABias <> 0) then begin
    xH := (Abs(ABias) div 60);
    xM := (Abs(ABias) mod 60);
    xT := EncodeTime(xH, xM, 0, 0);
    if (ABias > 0) then begin
      ADateTime := ADateTime + xT;
    end else begin
      ADateTime := ADateTime - xT;
    end;
  end;
end;

function XsdToDateTime(ADateTimeStr: String): TDateTime;
var xYear, xMonth, xDay, xHour, xMin, xSec, xMilli, xBHour, xBMinute : Word;
    xTime, xDate : TDateTime;
    xBias: Longint;
    xLen: Integer;
begin
  xLen := Length(ADateTimeStr);
  //Maybe its yyyy-mm-dd
  xYear := StrToIntDef(Copy(ADateTimeStr, 1, 4), 0);
  xMonth := StrToIntDef(Copy(ADateTimeStr, 6, 2), 0);
  xDay := StrToIntDef(Copy(ADateTimeStr, 9, 2), 0);
  if (xYear = 0) or (xMonth = 0) or (xDay = 0) then begin
    //No, check dd-mm-yyyy
    xDay := StrToIntDef(Copy(ADateTimeStr, 1, 2), 0);
    xMonth := StrToIntDef(Copy(ADateTimeStr, 4, 2), 0);
    xYear := StrToIntDef(Copy(ADateTimeStr, 7, 4), 0);
  end;
  if (xYear <> 0) and (xMonth <> 0) and (xDay <> 0) then begin
    if xLen = 10 then begin
      //"yyyy-mm-dd"
      Result := EncodeDate(xYear, xMonth, xDay);
    end else if xLen = 19 then begin
      //"yyyy-mm-ddThh:nn:ss"
      xHour := StrToIntDef(Copy(ADateTimeStr, 12, 2), 0);
      xMin := StrToIntDef(Copy(ADateTimeStr, 15, 2), 0);
      xSec := StrToIntDef(Copy(ADateTimeStr, 18, 2), 0);
      Result := EncodeDateTime(xYear, xMonth, xDay, xHour, xMin, xSec, 0);
    end else if xLen = 22 then begin
      //"yyyy-mm-ddThh:nn:ssZ"
      xHour := StrToIntDef(Copy(ADateTimeStr, 12, 2), 0);
      xMin := StrToIntDef(Copy(ADateTimeStr, 15, 2), 0);
      xSec := StrToIntDef(Copy(ADateTimeStr, 18, 2), 0);
      xMilli := 0;
      if TryEncodeTime(xHour, xMin, xSec, xMilli, xTime) then begin
        if TryEncodeDate(xYear, xMonth, xDay, xDate) then begin
          xDate := xDate + xTime;
          Result := xDate;
        end else begin
          Result := 0;
        end;
      end else begin
        Result := 0;
      end;
    end else if xLen = 25 then begin
      //"yyyy-mm-ddThh:nn:ss+hh:nn"
      xHour := StrToIntDef(Copy(ADateTimeStr, 12, 2), 0);
      xMin := StrToIntDef(Copy(ADateTimeStr, 15, 2), 0);
      xSec := StrToIntDef(Copy(ADateTimeStr, 18, 2), 0);
      xMilli := 0;
      if TryEncodeTime(xHour, xMin, xSec, xMilli, xTime) then begin
        if TryEncodeDate(xYear, xMonth, xDay, xDate) then begin
          xDate := xDate + xTime;
          xBHour := StrToIntDef(Copy(ADateTimeStr, 21, 2), 0);
          xBMinute := StrToIntDef(Copy(ADateTimeStr, 24, 2), 0);
          xBias := (xBHour * 60) + xBMinute;
          if (ADateTimeStr[20] = '-') then xBias := 0 - xBias;
          AddTimeBias(xDate, 0 - xBias);
          xBias := GetTimeZoneBias;
          AddTimeBias(xDate, 0 - xBias);
          Result := xDate;
        end else begin
          Result := 0;
        end;
      end else begin
        Result := 0;
      end;
    end else if (xLen = 26) or (xLen = 29) then begin
      //"yyyy-mm-ddThh:nn:ss.zzzZ"
      //"yyyy-mm-ddThh:nn:ss.zzz+hh:nn"
      if (xLen = 29) or (xLen = 26) then begin
        xHour := StrToIntDef(Copy(ADateTimeStr, 12, 2), 0);
        xMin := StrToIntDef(Copy(ADateTimeStr, 15, 2), 0);
        xSec := StrToIntDef(Copy(ADateTimeStr, 18, 2), 0);
        xMilli := StrToIntDef(Copy(ADateTimeStr, 21, 3), 0);
      end else begin
        xHour := 0;
        xMin := 0;
        xSec := 0;
        xMilli := 0;
      end;
      if TryEncodeTime(xHour, xMin, xSec, xMilli, xTime) then begin
        if TryEncodeDate(xYear, xMonth, xDay, xDate) then begin
          xDate := xDate + xTime;
          if (Length(ADateTimeStr) = 29) then begin
            xBHour := StrToIntDef(Copy(ADateTimeStr, 25, 2), 0);
            xBMinute := StrToIntDef(Copy(ADateTimeStr, 28, 2), 0);
            xBias := (xBHour * 60) + xBMinute;
            if (ADateTimeStr[24] = '-') then xBias := 0 - xBias;
          end else begin
            xBias := 0;
          end;
          AddTimeBias(xDate, 0 - xBias);
          xBias := GetTimeZoneBias;
          AddTimeBias(xDate, 0 - xBias);
          Result := xDate;
        end else begin
          Result := 0;
        end;
      end else begin
        Result := 0;
      end;
    end else begin
      Result := 0;
    end;
  end else begin
    Result := 0;
  end;
end;

function StrToDatetime(ADateTime: String; ADateFormat, ATimeFormat, ADateSeparator, ATimeSeparator: String; var AOutput: TDateTime): Boolean;
var xStr: String;
    xYs, xMs, xDs, xHs, xNs, xSs: Integer;
    xYi, xMi, xDi, xHi, xNi, xSi: Integer;
begin
  Result := False;
  AOutput := 0;
  xStr := StringReplace(Trim(ADateTime), '-', '', [rfReplaceAll, rfIgnoreCase]);
  xStr := StringReplace(xStr, ' ', '', [rfReplaceAll, rfIgnoreCase]);
  xStr := StringReplace(xStr, ':', '', [rfReplaceAll, rfIgnoreCase]);
  xStr := StringReplace(xStr, 'T', '', [rfReplaceAll, rfIgnoreCase]);
  xStr := StringReplace(xStr, ADateSeparator, '', [rfReplaceAll, rfIgnoreCase]);
  xStr := StringReplace(xStr, ATimeSeparator, '', [rfReplaceAll, rfIgnoreCase]);
  if ADateFormat = 'MDR' then begin
    xMs := 1;
    xDs := 3;
    xYs := 5;
  end else if ADateFormat = 'DMR' then begin
    xDs := 1;
    xMs := 3;
    xYs := 5;
  end else if ADateFormat = 'RMD' then begin
    xYs := 1;
    xMs := 5;
    xDs := 7;
  end else if ADateFormat = 'MRD' then begin
    xMs := 1;
    xYs := 3;
    xDs := 7;
  end else if ADateFormat = 'DRM' then begin
    xDs := 1;
    xYs := 3;
    xMs := 7;
  end else if ADateFormat = 'RDM' then begin
    xYs := 1;
    xDs := 5;
    xMs := 7;
  end else begin
    xYs := -1;
    xDs := -1;
    xMs := -1;
  end;
  if (xYs <> -1) and (xMs <> -1) and (xDs <> -1) then begin
    xYi := StrToIntDef(Copy(xStr, xYs, 4), 0);
    xMi := StrToIntDef(Copy(xStr, xMs, 2), 0);
    xDi := StrToIntDef(Copy(xStr, xDs, 2), 0);
    try
      Result := TryEncodeDate(xYi, xMi, xDi, AOutput);
    except
      Result := False;
    end;
    if Result and (ATimeFormat <> '--') then begin
      Delete(xStr, 1, 8);
      if ATimeFormat = 'HN' then begin
        xHs := 1;
        xNs := 3;
        xSs := -1;
      end else if ATimeFormat = 'NH' then begin
        xNs := 1;
        xHs := 3;
        xSs := -1;
      end else if ATimeFormat = 'HNS' then begin
        xHs := 1;
        xNs := 3;
        xSs := 5;
      end else if ATimeFormat = 'NHS' then begin
        xNs := 1;
        xHs := 3;
        xSs := 5;
      end else if ATimeFormat = 'SHN' then begin
        xSs := 1;
        xHs := 3;
        xNs := 5;
      end else if ATimeFormat = 'HSN' then begin
        xHs := 1;
        xSs := 3;
        xNs := 5;
      end else if ATimeFormat = 'NSH' then begin
        xNs := 1;
        xSs := 3;
        xHs := 5;
      end else if ATimeFormat = 'SNH' then begin
        xSs := 1;
        xNs := 3;
        xHs := 5;
      end else begin
        xSs := -1;
        xHs := -1;
        xNs := -1;
      end;
      if (xHs <> -1) and (xNs <> -1) then begin
        xHi := StrToIntDef(Copy(xStr, xHs, 2), -1);
        xNi := StrToIntDef(Copy(xStr, xNs, 2), -1);
        if xSs > 0 then begin
          xSi := StrToIntDef(Copy(xStr, xSs, 2), -1);
        end else begin
          xSi := 0;
        end;
        if (xHi >= 0) and (xNi >= 0) and (xSi >= 0) then begin
          try
            Result := TryEncodeDateTime(xYi, xMi, xDi, xHi, xNi, xSi, 0, AOutput);
          except
            Result := False;
          end;
        end else begin
          Result := False;
        end;
      end else begin
        Result := False;
      end;
    end;
  end;
end;

function IntToStrWithSign(AInteger: Integer): String;
begin
  Result := IntToStr(AInteger);
  if AInteger >= 0 then begin
    Result := '+' + Result;
  end;
end;

procedure GetFileFromResource(AResName: String; AResType: PChar; AFilename: String);
var xRes: TResourceStream;
begin
  xRes := TResourceStream.Create(HInstance, AResName, AResType);
  xRes.SaveToFile(AFilename);
  xRes.Free;
end;

function GetStartQuarterOfTheYear(ADateTime: TDateTime): TDateTime;
var xQuarter: Integer;
begin
  xQuarter := GetQuarterOfTheYear(ADateTime);
  Result := EncodeDate(YearOf(ADateTime), (xQuarter - 1) * 3 + 1, 1);
end;

function GetEndQuarterOfTheYear(ADateTime: TDateTime): TDateTime;
var xQuarter: Integer;
begin
  xQuarter := GetQuarterOfTheYear(ADateTime);
  Result := EncodeDate(YearOf(ADateTime), xQuarter * 3, DayOf(EndOfAMonth(YearOf(ADateTime), xQuarter * 3)));
end;

function GetQuarterOfTheYear(ADateTime: TDateTime): Integer;
var xMonth: Integer;
begin
  xMonth := MonthOf(ADateTime);
  Result := ((xMonth - 1) div 3) + 1;
end;

function GetStartHalfOfTheYear(ADateTime: TDateTime): TDateTime;
var xHalf: Integer;
begin
  xHalf := GetHalfOfTheYear(ADateTime);
  Result := EncodeDate(YearOf(ADateTime), (xHalf - 1) * 6 + 1, 1);
end;

function GetEndHalfOfTheYear(ADateTime: TDateTime): TDateTime;
var xHalf: Integer;
begin
  xHalf := GetHalfOfTheYear(ADateTime);
  Result := EncodeDate(YearOf(ADateTime), xHalf * 6, DayOf(EndOfAMonth(YearOf(ADateTime), xHalf * 6)));
end;

function GetHalfOfTheYear(ADateTime: TDateTime): Integer;
var xMonth: Integer;
begin
  xMonth := MonthOf(ADateTime);
  Result := ((xMonth - 1) div 6) + 1;
end;

function GetFormattedDate(ADate: TDateTime; AFormat: String): String;
var xTime: TSystemTime;
    xRes: PChar;
begin
  GetMem(xRes, $FF);
  DateTimeToSystemTime(ADate, xTime);
  if GetDateFormat(GetThreadLocale, 0, @xTime, PChar(AFormat), xRes, $FF) <> 0 then begin
    Result := String(xRes);
  end;
  FreeMem(xRes);
end;

function GetFormattedTime(ADate: TDateTime; AFormat: String): String;
var xTime: TSystemTime;
    xRes: PChar;
begin
  GetMem(xRes, $FF);
  DateTimeToSystemTime(ADate, xTime);
  if GetTimeFormat(GetThreadLocale, 0, @xTime, PChar(AFormat), xRes, $FF) <> 0 then begin
    Result := String(xRes);
  end;
  FreeMem(xRes);
end;

function GetSystemPathname(AFilename: String): String;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + ExtractFileName(AFilename);
end;

end.
