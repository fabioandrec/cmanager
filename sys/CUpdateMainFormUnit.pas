unit CUpdateMainFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CComponents, StdCtrls, ExtCtrls, WinInet, ShellApi, ComCtrls, ActiveX,
  MsXml;

type
  TCUpdateMainForm = class(TForm)
    Image: TImage;
    Label1: TLabel;
    Label2: TLabel;
    RichEdit: TRichEdit;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  protected
    procedure WndProc(var Message: TMessage); override;
  end;

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
    FTextToReport: String;
    function GetErrorDesc(AErrorCode: Cardinal): String;
    function GetHostname: String;
    function GetPathname: String;
    function RemoveProto(AUrl: String): String;
    function GetResponse(var AResponse: String): Cardinal;
    procedure AddToReportInternal;
  protected
    procedure AddToReport(AText: String);
    procedure Execute; override;
  public
    constructor Create(AUrl, AProxy, AProxyUser, AProxyPass: String; AConnectionType: THttpConnectType);
    procedure CancelRequest;
    property Hostname: String read GetHostname;
    property Pathname: String read GetPathname;
    property Url: String read FUrl;
    property Proxy: String read FProxy;
    property ProxyUser: String read FProxyUser;
    property ProxyPass: String read FProxyPass;
    property HttpRequestType: THttpConnectType read FHttpConnectType;
    property Response: String read FResponse;
    property RequestResult: Cardinal read FRequestResult;
    property IsRunning: Boolean read FIsRunning;
  end;

const
  CUpdateLink = 'http://cmanager.sourceforge.net/update.xml';
  //CUpdateLink = 'file://d:\cvs\sourceforge\cmanager\docs\homepage\update.xml';
  
var
  CUpdateMainForm: TCUpdateMainForm;
  CIsQuiet: Boolean;
  CUpdateThread: THttpRequest;
  CFoundNewVersion: Boolean;

procedure UpdateSystem;

implementation

{$R *.dfm}

uses CommCtrl, CRichtext, CTools, MemCheck, CXml, RichEdit;

constructor THttpRequest.Create(AUrl, AProxy, AProxyUser, AProxyPass: String; AConnectionType: THttpConnectType);
begin
  inherited Create(True);
  FUrl := AUrl;
  FProxy := AProxy;
  FProxyPass := AProxyPass;
  FProxyUser := FProxyUser;
  FHttpConnectType := AConnectionType;
  FResponse := '';
  FRequestResult := 0;
  FreeOnTerminate := False;
  FIsRunning := False;
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
    AddToReport('Sprawdzanie aktualizacji...');
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
      hctPreconfig: FInternetHandle := InternetOpen('CUpdate', INTERNET_OPEN_TYPE_PRECONFIG, Nil, Nil, 0);
      hctProxy: FInternetHandle := InternetOpen('CUpdate', INTERNET_OPEN_TYPE_PROXY, PChar(FProxy), '', 0);
      else FInternetHandle := InternetOpen('CUpdate', INTERNET_OPEN_TYPE_DIRECT, Nil, Nil, 0);
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
            AddToReport('Sprawdzanie aktualizacji...');
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

procedure TCUpdateMainForm.FormCreate(Sender: TObject);
var xMask: Integer;
begin
  Image.Picture.Icon.Handle := LoadIcon(HInstance, 'LARGEICON');
  xMask := SendMessage(RichEdit.Handle, EM_GETEVENTMASK, 0, 0);
  SendMessage(RichEdit.Handle, EM_SETEVENTMASK, 0, xMask or ENM_LINK);
  SendMessage(RichEdit.Handle, EM_AUTOURLDETECT, Integer(True), 0);
end;

procedure UpdateSystem;
var xFinished: Boolean;
begin
  CIsQuiet := GetSwitch('/quiet');
  CFoundNewVersion := False;
  Application.CreateForm(TCUpdateMainForm, CUpdateMainForm);
  if not CIsQuiet then begin
    CUpdateMainForm.Show;
    CUpdateMainForm.Update;
  end;
  CUpdateThread := THttpRequest.Create(CUpdateLink, '', '', '', hctPreconfig);
  CUpdateThread.Resume;
  repeat
    xFinished := WaitForSingleObject(CUpdateThread.Handle, 10) <> WAIT_TIMEOUT;
    if not xFinished then begin
      Application.ProcessMessages;
    end;
  until xFinished;
  if (not CIsQuiet) or CFoundNewVersion then begin
    CUpdateMainForm.Button1.Caption := '&Zamknij';
    if CUpdateThread.RequestResult = 0 then begin
      if CFoundNewVersion then begin
        CUpdateMainForm.Label2.Caption := ' - Zakoñczono sprawdzanie aktualizacji';
      end else begin
        CUpdateMainForm.Label2.Caption := ' - Zakoñczono sprawdzanie aktualizacji';
      end;
    end else begin
      CUpdateMainForm.Label2.Caption := ' - Sprawdzenie aktualizacji nie powiod³o siê';
    end;
    Application.BringToFront;
    Application.Run;
  end;
  CUpdateThread.Free;
end;

function CompareVersions(ALatest, ACurrent: String): Boolean;
var xLatest, xCurrent: TStringList;
    xCount: Integer;
begin
  Result := False;
  xLatest := TStringList.Create;
  xLatest.Text := StringReplace(ALatest, '.', sLineBreak, [rfReplaceAll, rfIgnoreCase]);
  xCurrent := TStringList.Create;
  xCurrent.Text := StringReplace(ACurrent, '.', sLineBreak, [rfReplaceAll, rfIgnoreCase]);
  xCount := 0;
  while (xCount <= xLatest.Count - 1) and (xCount <= xCurrent.Count - 1) and (not Result) do begin
    Result := StrToIntDef(xLatest.Strings[xCount], -1) > StrToIntDef(xCurrent.Strings[xCount], -1);
    Inc(xCount);
  end;
  xLatest.Free;
  xCurrent.Free;
end;

procedure THttpRequest.Execute;
var xDocument: IXMLDOMDocument;
    xStream: TStringStream;
    xHelper: TStreamAdapter;
    xCurrentVersion: String;
    xLatestVersion: String;
    xNode: IXMLDOMNode;
    xItem: IXMLDOMNode;
    xValid: Boolean;
    xDesc: String;
begin
  FIsRunning := True;
  FRequestResult := GetResponse(FResponse);
  if FRequestResult = ERROR_SUCCESS then begin
    CoInitialize(Nil);
    xDocument := CoDOMDocument.Create;
    xDocument.validateOnParse := True;
    xDocument.resolveExternals := True;
    xStream := TStringStream.Create(FResponse);
    xHelper := TStreamAdapter.Create(xStream);
    xDocument.load(xHelper as IStream);
    xStream.Free;
    xValid := False;
    if xDocument.parseError.errorCode = 0 then begin
      xCurrentVersion := FileVersion(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'cmanager.exe');
      xNode := xDocument.selectSingleNode('update');
      if xNode <> Nil then begin
        xLatestVersion := GetXmlAttribute('version', xNode, '');
        if xLatestVersion <> '' then begin
          xValid := True;
          if CompareVersions(xLatestVersion, xCurrentVersion) then begin
            CFoundNewVersion := True;
            AddToReport('Znaleziono now¹ wersjê CManager-a ' + CRtfSB + GetXmlAttribute('name', xNode, '') + CRtfEB);
            AddToReport('Wydanie z dnia ' + GetXmlAttribute('date', xNode, ''));
            xDesc := StringReplace(GetXmlAttribute('desc', xNode, ''), '/n', sLineBreak, [rfReplaceAll, rfIgnoreCase]);
            if xDesc <> '' then begin
              AddToReport('');
              AddToReport(xDesc);
            end;
            AddToReport('');
            AddToReport('Pobierz aktualizacjê z ' + GetXmlAttribute('direct', xNode, ''));
            AddToReport('Otwórz stronê domow¹ ' + GetXmlAttribute('homepage', xNode, ''));
            AddToReport('');
            xItem := xNode.firstChild;
            if xItem <> Nil then begin
              AddToReport('Zmiany w tej wersji:');
            end;
            while (xItem <> Nil) do begin
              AddToReport('   [' + GetXmlAttribute('type', xItem, '') + '] ' + GetXmlAttribute('info', xItem, ''));
              xItem := xItem.nextSibling;
            end;
          end else begin
            AddToReport('Nie znaleziono nowych aktualizacji CManager-a');
          end;
        end;
      end;
    end;
    if not xValid then begin
      AddToReport('Odczytany plik nie zawiera danych o uaktualnieniach.');
      AddToReport('Sprawdz czy masz dostêp do ' + CUpdateLink);
    end;
    xDocument := Nil;
    CoUninitialize;
  end;
  FIsRunning := False;
end;

procedure THttpRequest.CancelRequest;
begin
  if FRequestHandle <> Nil then begin
    InternetCloseHandle(FRequestHandle);
  end;
end;

procedure TCUpdateMainForm.Button1Click(Sender: TObject);
begin
  if CUpdateThread.IsRunning then begin
    CUpdateThread.CancelRequest;
    CUpdateThread.Terminate;
    WaitForSingleObject(CUpdateThread.Handle, INFINITE);
    Label2.Caption := 'Przerwano sprawdzanie aktualizacji';
    Button1.Caption := '&Zamknij';
  end else begin
    Close;
  end;
end;

procedure THttpRequest.AddToReport(AText: String);
begin
  FTextToReport := AText;
  Synchronize(AddToReportInternal);
end;

procedure THttpRequest.AddToReportInternal;
begin
  AddRichText(FTextToReport, CUpdateMainForm.RichEdit);
end;

procedure TCUpdateMainForm.WndProc(var Message: TMessage);
var xP: TENLink;
    xUrl: string;
begin
  if (Message.Msg = WM_NOTIFY) then begin
    if (PNMHDR(Message.LParam).code = EN_LINK) then begin
      xP := TENLink(Pointer(TWMNotify(Message).NMHdr)^);
      if (xP.msg = WM_LBUTTONDOWN) then begin
        SendMessage(RichEdit.Handle, EM_EXSETSEL, 0, LongInt(@(xP.chrg)));
        xUrl := RichEdit.SelText;
        ShellExecute(Handle, 'open', PChar(xUrl), Nil, Nil, SW_SHOWNORMAL);
      end
    end
  end;
  inherited;
end;

end.
