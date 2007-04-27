unit CHttpRequest;

interface

uses Classes, WinInet, SysUtils, Windows, ComCtrls;

type
  THttpConnectType = (hctDirect, hctPreconfig, hctProxy);

  THttpRequest = class(TThread)
  private
    FUrl: String;
    FProxy: String;
    FProxyUser: String;
    FProxyPass: String;
    FInternetHandle: HINTERNET;
    FConnectHandle: HINTERNET;
    FRequestHandle: HINTERNET;
    FHttpConnectType: THttpConnectType;
    FResponse: String;
    FRequestResult: Cardinal;
    FIsRunning: Boolean;
    FIsCancelled: Boolean;
    FTextToReport: String;
    FRichEdit: TRichEdit;
    FAgentName: String;
    FFinished: Boolean;
    function GetErrorDesc(AErrorCode: Cardinal): String;
    function GetHostname: String;
    function GetPathname: String;
    function RemoveProto(AUrl: String): String;
    procedure AddToReportInternal;
  protected
    function GetResponse(var AResponse: String): Cardinal;
    procedure AddToReport(AText: String);
    procedure Execute; override;
    procedure AfterGetResponse; virtual; abstract;
  public
    constructor Create(AUrl, AProxy, AProxyUser, AProxyPass: String; AConnectionType: THttpConnectType; AReportRichedit: TRichEdit; AAgentName: String);
    procedure CancelRequest;
    property Hostname: String read GetHostname;
    property Pathname: String read GetPathname;
    property Url: String read FUrl write FUrl;
    property Proxy: String read FProxy;
    property ProxyUser: String read FProxyUser;
    property ProxyPass: String read FProxyPass;
    property HttpRequestType: THttpConnectType read FHttpConnectType;
    property Response: String read FResponse write FResponse;
    property RequestResult: Cardinal read FRequestResult write FRequestResult;
    property IsRunning: Boolean read FIsRunning write FIsRunning;
    property IsCancelled: Boolean read FIsCancelled;
    property Finished: Boolean read FFinished write FFinished;
  end;

implementation

uses CRichtext;

constructor THttpRequest.Create(AUrl, AProxy, AProxyUser, AProxyPass: String; AConnectionType: THttpConnectType; AReportRichedit: TRichEdit; AAgentName: String);
begin
  inherited Create(True);
  FIsCancelled := False;
  FUrl := AUrl;
  FProxy := AProxy;
  FProxyPass := AProxyPass;
  FProxyUser := FProxyUser;
  FHttpConnectType := AConnectionType;
  FResponse := '';
  FRequestResult := 0;
  FreeOnTerminate := False;
  FIsRunning := False;
  FRichEdit := AReportRichedit;
  FAgentName := AAgentName;
  FFinished := False;
end;

function THttpRequest.GetHostname: String;
var xDel: Integer;
begin
  Result := RemoveProto(FUrl);
  xDel := Pos('/', Result);
  if xDel > 0 then begin
    Result := Copy(Result, 1, xDel - 1);
  end;
end;

function THttpRequest.GetPathname: String;
var xDel: Integer;
begin
  Result := RemoveProto(FUrl);
  xDel := Pos('/', Result);
  if xDel > 0 then begin
    Result := Copy(Result, xDel + 1, Length(Result) - xDel);
  end;
end;

function THttpRequest.RemoveProto(AUrl: String): String;
begin
  Result := AUrl;
  if Copy(AnsiUpperCase(Result), 1, 7) = 'HTTP://' then begin
    Result := Copy(Result, 8, Length(Result) - 7);
  end;
end;

function THttpRequest.GetResponse(var AResponse: String): Cardinal;
var xBytesCount: Cardinal;
    xContentBuffer: PChar;
    xContentString: String;
    xFilename: String;
    xFile: THandle;
    xRead: Cardinal;
begin
  Result := 0;
  AResponse := '';
  AddToReport('Inicjowanie po³¹czenia...');
  if AnsiUpperCase(Copy(FUrl, 1, 7)) = 'FILE://' then begin
    xFilename := Copy(FUrl, 8, MaxInt);
    AddToReport('Sprawdzanie ¿¹dania...');
    xFile := CreateFile(PChar(xFilename), GENERIC_READ, 0, Nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
    if xFile <> INVALID_HANDLE_VALUE then begin
      xBytesCount := GetFileSize(xFile, Nil);
      SetLength(AResponse, xBytesCount);
      if not ReadFile(xFile, AResponse[1], xBytesCount, xRead, Nil) then begin
        AddToReport('B³¹d, ' + GetErrorDesc(Result));
        Result := GetLastError;
      end;
      CloseHandle(xFile);
    end else begin
      Result := GetLastError;
      AddToReport('B³¹d, ' + GetErrorDesc(Result));
    end;
  end else begin
    case FHttpConnectType of
      hctPreconfig: FInternetHandle := InternetOpen(PChar(FAgentName), INTERNET_OPEN_TYPE_PRECONFIG, Nil, Nil, 0);
      hctProxy: FInternetHandle := InternetOpen(PChar(FAgentName), INTERNET_OPEN_TYPE_PROXY, PChar(FProxy), '', 0);
      else FInternetHandle := InternetOpen(PChar(FAgentName), INTERNET_OPEN_TYPE_DIRECT, Nil, Nil, 0);
    end;
    if FInternetHandle <> Nil then begin
      if (FHttpConnectType = hctProxy) and (FProxyUser <> '') then begin
        InternetSetOption(FInternetHandle, INTERNET_OPTION_PROXY_USERNAME, PChar(ProxyUser), Length(ProxyUser) + 1);
      end;
      if (FHttpConnectType = hctProxy) and (FProxyPass <> '') then begin
        InternetSetOption(FInternetHandle, INTERNET_OPTION_PROXY_PASSWORD, PChar(ProxyPass), Length(ProxyPass) + 1);
      end;
      FConnectHandle := InternetConnect(FInternetHandle, PChar(Hostname), INTERNET_DEFAULT_HTTP_PORT, Nil, Nil, INTERNET_SERVICE_HTTP, 0, 0);
      if FConnectHandle <> Nil then begin
        FRequestHandle := HttpOpenRequest(FConnectHandle, Nil, PChar(Pathname), Nil, Nil, Nil, INTERNET_FLAG_RELOAD, 0);
        if FRequestHandle <> Nil then begin
          if HttpSendRequest(FRequestHandle, Nil, 0, Nil, 0) then begin
            AddToReport('Sprawdzanie ¿¹dania...');
            GetMem(xContentBuffer, $FFFF);
            repeat
              xBytesCount := 0;
              if InternetReadFile(FRequestHandle, xContentBuffer, $FFFF, xBytesCount) then begin
                if xBytesCount > 0 then begin
                  SetLength(xContentString, xBytesCount);
                  CopyMemory(@xContentString[1], xContentBuffer, xBytesCount);
                  AResponse := AResponse + xContentString;
                end;
              end else begin
                Result := GetLastError;
                AddToReport('B³¹d, ' + GetErrorDesc(Result));
              end;
            until (xBytesCount = 0) or (Result <> ERROR_SUCCESS);
            FreeMem(xContentBuffer);
          end else begin
            Result := GetLastError;
            AddToReport('B³¹d, ' + GetErrorDesc(Result));
          end;
          InternetCloseHandle(FRequestHandle);
        end else begin
          Result := GetLastError;
          AddToReport('B³¹d, ' + GetErrorDesc(Result));
        end;
        InternetCloseHandle(FConnectHandle);
      end else begin
        Result := GetLastError;
        AddToReport('B³¹d, ' + GetErrorDesc(Result));
      end;
      InternetCloseHandle(FInternetHandle);
    end else begin
      Result := GetLastError;
      AddToReport('B³¹d, ' + GetErrorDesc(Result));
    end;
  end;
  if Result <> ERROR_SUCCESS then begin
    AResponse := IntToStr(Result) + ' ' + GetErrorDesc(Result);
  end;
end;

function GetModuleErrorDesc(AErrorCode: Cardinal; AModuleName: String): String;
var xErrorStr: PChar;
    xInet: THandle;
begin
  xInet := LoadLibrary(PChar(AModuleName));
  Result := '';
  if xInet >= 32 then begin
    FormatMessage(FORMAT_MESSAGE_ALLOCATE_BUFFER or FORMAT_MESSAGE_IGNORE_INSERTS or FORMAT_MESSAGE_FROM_SYSTEM or FORMAT_MESSAGE_FROM_HMODULE, Pointer(xInet), AErrorCode, Lang_neutral, @xErrorStr, 1, nil);
    Result := xErrorStr;
    LocalFree(HLocal(xErrorStr));
    FreeLibrary(xInet);
  end;
end;

function THttpRequest.GetErrorDesc(AErrorCode: Cardinal): String;
begin
  Result := SysErrorMessage(AErrorCode);
  if (Result = '') and (AErrorCode >= INTERNET_ERROR_BASE) then begin
    Result := GetModuleErrorDesc(AErrorCode, 'wininet.dll');
  end;
end;

procedure THttpRequest.AddToReportInternal;
begin
  AddRichText(FTextToReport, FRichEdit);
end;

procedure THttpRequest.AddToReport(AText: String);
begin
  FTextToReport := AText;
  Synchronize(AddToReportInternal);
end;

procedure THttpRequest.CancelRequest;
begin
  FIsCancelled := True;
  if FRequestHandle <> Nil then begin
    InternetCloseHandle(FRequestHandle);
  end;
end;

procedure THttpRequest.Execute;
begin
  FIsRunning := True;
  FRequestResult := GetResponse(FResponse);
  AfterGetResponse;
  FIsRunning := False;
  FFinished := True;
end;

end.
