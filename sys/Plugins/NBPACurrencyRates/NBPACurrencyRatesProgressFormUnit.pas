unit NBPACurrencyRatesProgressFormUnit;

interface

{$WARN SYMBOL_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, jpeg, CHttpRequest, CXml, WinInet,
  MsHtml, ActiveX;

type
  TNBPACurrencyRatesBaseThread = class(TBaseHttpRequest)
  private
    FResponseXml: ICXMLDOMDocument;
    FRootElement: ICXMLDOMNode;
    FIsValidResponse: Boolean;
  protected
    function AfterGetResponse(ARequestIdentifier: String): Cardinal; override;
    procedure ThreadFinished; override;
  public
    property ResponseXml: ICXMLDOMDocument read FResponseXml write FResponseXml;
    property RootElement: ICXMLDOMNode read FRootElement write FRootElement;
    property IsValidResponse: Boolean read FIsValidResponse;
    constructor Create(ALogWindow: HWND; AUrl: String; AProxy: String; AProxyUser: String; AProxyPass: String; AConnectionType: THttpConnectType; AAgentName: String); override;
  end;

  TNBPACurrencyRatesProgressForm = class(TForm)
    Label2: TLabel;
    RichEdit: TRichEdit;
    Button1: TButton;
    Image: TImage;
    OpenDialogXml: TOpenDialog;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    FRequestThread: TNBPACurrencyRatesBaseThread;
  protected
    procedure WndProc(var Message: TMessage); override;
  public
    function RetriveCurrencyRates: OleVariant;
  end;

var NBPACurrencyRatesProgressForm: TNBPACurrencyRatesProgressForm;

implementation

uses CRichtext, StrUtils, NBPACurrencyRatesConfigFormUnit,
  CPluginConsts, CBasics;

{$R *.dfm}

const
  CHREFTAG = '<a href="';
  CSTARTTAG = '/kursy/xml/';
  CENDTAG = '"';

function TNBPACurrencyRatesProgressForm.RetriveCurrencyRates: OleVariant;
var xOutRoot: ICXMLDOMNode;
    xPositions: ICXMLDOMNodeList;
    xPosition, xOut: ICXMLDOMNode;
    xCount: Integer;
    xCurrencyName, xCurrencyIso: String;
    xCurrencyQuantity: Integer;
    xCurrencyRate: Currency;
    xOldDecimal: Char;
    xLink: String;
    xXml: ICXMLDOMDocument;
    xConfiguration: String;
    xProceed: Boolean;
begin
  VarClear(Result);
  xOldDecimal := DecimalSeparator;
  DecimalSeparator := '.';
  AssignRichText('Rozpoczêcie wyszukiwania lokalizacji tabeli kursów walut...', RichEdit);
  xConfiguration := GCManagerInterface.GetConfiguration;
  xProceed := False;
  if AnsiUpperCase(Copy(xConfiguration, 1, 2)) = 'F;' then begin
    if OpenDialogXml.Execute then begin
      xLink := 'file://' + OpenDialogXml.FileName;
      xProceed := True;
    end;
  end else begin
    xLink := Copy(xConfiguration, 3, Length(xConfiguration) - 2);
    xProceed := True;
  end;
  if xLink = '' then begin
    xLink := 'http://www.nbp.org.pl/Kursy/KursyA.html';
  end;
  if xProceed then begin
    FRequestThread := TNBPACurrencyRatesBaseThread.Create(Handle, xLink, '', '', '', hctPreconfig,  'MSIE');
    ShowModal;
    if FRequestThread.ExitCode = ERROR_SUCCESS then begin
      if FRequestThread.IsValidResponse then begin
        xXml := GetXmlDocument;
        xOutRoot := xXml.createElement('currencyRates');
        xXml.appendChild(xOutRoot);
        SetXmlAttribute('cashpointName', xOutRoot, 'Narodowy Bank Polski');
        SetXmlAttribute('bindingDate', xOutRoot, GetXmlNodeValue('data_publikacji', FRequestThread.RootElement, ''));
        xPositions := FRequestThread.RootElement.selectNodes('pozycja');
        for xCount := 0 to xPositions.length - 1 do begin
          xPosition := xPositions.item[xCount];
          xCurrencyName := GetXmlNodeValue('nazwa_waluty', xPosition, '');
          xCurrencyIso := GetXmlNodeValue('kod_waluty', xPosition, '');
          xCurrencyQuantity := StrToIntDef(GetXmlNodeValue('przelicznik', xPosition, ''), -1);
          xCurrencyRate := StrToFloatDef(StringReplace(GetXmlNodeValue('kurs_sredni', xPosition, ''), ',', '.', [rfIgnoreCase, rfReplaceAll]), -1);
          if (xCurrencyName <> '') and (xCurrencyIso <> '') and (xCurrencyQuantity <> -1) and (xCurrencyRate <> -1) then begin
            xOut := xXml.createElement('currencyRate');
            xOutRoot.appendChild(xOut);
            SetXmlAttribute('sourceName', xOut, xCurrencyName);
            SetXmlAttribute('sourceIso', xOut, xCurrencyIso);
            SetXmlAttribute('targetName', xOut, 'Polski z³oty');
            SetXmlAttribute('targetIso', xOut, 'PLN');
            SetXmlAttribute('quantity', xOut, xCurrencyQuantity);
            SetXmlAttribute('rate', xOut, Trim(Format('%-10.4f', [xCurrencyRate])));
            SetXmlAttribute('type', xOut, CCURRENCYRATE_AVG);
          end;
        end;
        Result := GetStringFromDocument(xXml);
      end;
    end;
    FRequestThread.Free;
  end;
  DecimalSeparator := xOldDecimal;
end;

procedure TNBPACurrencyRatesProgressForm.FormActivate(Sender: TObject);
begin
  if FRequestThread.Status = tsSuspended then begin
    FRequestThread.InitThread;
  end;
end;

procedure TNBPACurrencyRatesProgressForm.Button1Click(Sender: TObject);
begin
  if FRequestThread.Status = tsRunning then begin
    FRequestThread.CancelThread;
  end else begin
    Close;
  end;
end;

function TNBPACurrencyRatesBaseThread.AfterGetResponse(ARequestIdentifier: String): Cardinal;
var xLocalization: String;
    xResponse: String;
    xDoc: IHTMLDocument2;
    xLink: IHTMLElement;
    xVar: Variant;
begin
  Result := inherited AfterGetResponse(ARequestIdentifier);
  if ARequestIdentifier = '' then begin
    FResponseXml := Nil;
    FRootElement := Nil;
    if AnsiUpperCase(Copy(Url, 1, 7)) = 'FILE://' then begin
      FResponseXml := GetDocumentFromString(ResponseBuffer, Nil);
      if FResponseXml.parseError.errorCode = 0 then begin
        FRootElement := FResponseXml.selectSingleNode('tabela_kursow');
        if FRootElement = Nil then begin
          FResponseXml := Nil;
          AddToReport('Otrzymane dane nie s¹ poprawn¹ tabel¹ kursów walut');
        end;
      end else begin
        FResponseXml := Nil;
        AddToReport('Otrzymane dane nie s¹ poprawn¹ tabel¹ kursów walut');
      end;
    end else begin
      xDoc := CoHTMLDocument.Create as IHTMLDocument2;
      xDoc.designMode := 'on';
      while xDoc.readyState <> 'complete' do begin
        Sleep(1);
      end;
      xVar := VarArrayCreate([0, 0], VarVariant);
      xVar[0] := ResponseBuffer;
      xDoc.Write(PSafeArray(System.TVarData(xVar).VArray));
      xDoc.designMode := 'off';
      while xDoc.readyState <> 'complete' do begin
        Sleep(1);
      end;
      if xDoc.links.length >= 4 then begin
        xLink := xDoc.links.item(3, '') as IHTMLElement;
        xLocalization := (xLink as IHTMLAnchorElement).pathname;
      end;
      if xLocalization <> '' then begin
        AddToReport('Rozpoczêcie pobierania tabeli kursów walut...');
        Url := Hostname + '/' + xLocalization;
        InternetCloseHandle(FRequestHandle);
        InternetCloseHandle(FConnectHandle);
        InternetCloseHandle(FInternetHandle);
        Result := GetResponse('xml', xResponse);
        if Result = 0 then begin
          FResponseXml := GetDocumentFromString(xResponse, Nil);
          if FResponseXml.parseError.errorCode = 0 then begin
            FRootElement := FResponseXml.selectSingleNode('tabela_kursow');
            if FRootElement = Nil then begin
              FResponseXml := Nil;
              AddToReport('Otrzymane dane nie s¹ poprawn¹ tabel¹ kursów walut');
            end else begin
              FIsValidResponse := True;
            end;
          end else begin
            FResponseXml := Nil;
            AddToReport('Otrzymane dane nie s¹ poprawn¹ tabel¹ kursów walut');
          end;
        end;
      end else begin
        AddToReport('Otrzymane dane nie zawieraj¹ lokalizacji tabeli kursów walut');
      end;
    end;
  end;
end;

constructor TNBPACurrencyRatesBaseThread.Create(ALogWindow: HWND; AUrl, AProxy, AProxyUser, AProxyPass: String; AConnectionType: THttpConnectType; AAgentName: String);
begin
  inherited Create(ALogWindow, AUrl, AProxy, AProxyUser, AProxyPass, AConnectionType, AAgentName);
  FIsValidResponse := False;
end;

procedure TNBPACurrencyRatesBaseThread.ThreadFinished;
begin
  if ExitCode = ERROR_SUCCESS then begin
    if FIsValidResponse then begin
      PostMessage(NBPACurrencyRatesProgressForm.Handle, WM_CLOSE, 0, 0);
    end else begin
      NBPACurrencyRatesProgressForm.Button1.Caption := '&Zamknij';
      NBPACurrencyRatesProgressForm.Label2.Caption := 'B³¹d pobierania kursów walut';
    end;
  end else if ExitCode = ERROR_CANCELLED then begin
    PostMessage(NBPACurrencyRatesProgressForm.Handle, WM_CLOSE, 0, 0);
  end else begin
    NBPACurrencyRatesProgressForm.Button1.Caption := '&Zamknij';
    NBPACurrencyRatesProgressForm.Label2.Caption := 'Przerwano pobierania kursów walut';
  end;
end;

procedure TNBPACurrencyRatesProgressForm.WndProc(var Message: TMessage);
begin
  inherited WndProc(Message);
  if Message.Msg = WMC_RICHEDITADDTEXT then begin
    PerformAddThreadRichText(RichEdit, Message.WParam);
  end;
end;

end.
