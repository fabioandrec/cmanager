unit CTools;

{$WARN SYMBOL_PLATFORM OFF}

interface

{$WARN SYMBOL_PLATFORM OFF}

uses Windows, Types, Contnrs, Classes, StdCtrls;

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

function FileVersion(AName: string): String;
function FileNumbers(AName: String; var AMS, ALS: DWORD): Boolean;
function FileSize(AName: String): Int64;
function GetParamValue(AParam: String): String;
function GetSwitch(ASwitch: String): Boolean;
function StringToStringArray(AString: String; ADelimeter: Char): TStringDynArray;
function LPad(AString: String; AChar: Char; ALength: Integer): String;
function RunApplication(ACmdline, AParams: String; var AOutputInfo: String): Boolean;
procedure SaveToLog(AText: String; ALogFilename: String);
function DmyToDate(AString: String; ADefault: TDateTime): TDateTime;
function StrToCurrencyDecimalDot(AStr: String): Currency;
procedure FillCombo(ACombo: TComboBox; const AList: array of String; AItemIndex: Integer = 0);

function IsEvenToStr(AInt: Integer): String; overload;
function IsEven(AInt: Integer): Boolean; overload;

implementation

uses SysUtils, StrUtils;

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
    xText := FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now) + #9 + AText;
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
begin
  xY := StrToIntDef(Copy(AString, 1, 4), 0);
  xM := StrToIntDef(Copy(AString, 5, 2), 0);
  xD := StrToIntDef(Copy(AString, 7, 2), 0);
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


end.
