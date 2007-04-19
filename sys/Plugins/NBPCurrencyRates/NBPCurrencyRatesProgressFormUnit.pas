unit NBPCurrencyRatesProgressFormUnit;

interface

{$WARN SYMBOL_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, jpeg, CHttpRequest, MsXml;

type
  TNBPCurrencyRatesThread = class(THttpRequest)
  private
    FResponseXml: IXMLDOMDocument;
    FRootElement: IXMLDOMNode;
    procedure SetFinished;
  protected
    procedure AfterGetResponse; override;
  public
    property ResponseXml: IXMLDOMDocument read FResponseXml write FResponseXml;
    property RootElement: IXMLDOMNode read FRootElement write FRootElement;
  end;

  TNBPCurrencyRatesProgressForm = class(TForm)
    Label2: TLabel;
    RichEdit: TRichEdit;
    Button1: TButton;
    Image: TImage;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    FRequestThread: TNBPCurrencyRatesThread;
  public
    function RetriveCurrencyRates: String;
  end;

var NBPCurrencyRatesProgressForm: TNBPCurrencyRatesProgressForm;

implementation

uses CRichtext, StrUtils, CXml, NBPCurrencyRatesConfigFormUnit;

{$R *.dfm}

const
  CSTARTTAG = '<a href="';
  CENDTAG = '"';

function TNBPCurrencyRatesProgressForm.RetriveCurrencyRates: String;
var xOutRoot: IXMLDOMNode;
    xPositions: IXMLDOMNodeList;
    xPosition, xOut: IXMLDOMNode;
    xCount: Integer;
    xCurrencyName, xCurrencyIso: String;
    xCurrencyQuantity: Integer;
    xCurrencyRate: Currency;
    xOldDecimal: Char;
    xLink: String;
    xXml: IXMLDOMDocument;
begin
  Result := '';
  xOldDecimal := DecimalSeparator;
  DecimalSeparator := '.';
  AssignRichText('Rozpoczêcie wyszukiwania lokalizacji tabeli kursów walut...', RichEdit);
  xLink := GCManagerInterface.GetConfiguration;
  if xLink = '' then begin
    xLink := 'http://www.nbp.org.pl/Kursy/KursyA.html';
  end;
  FRequestThread := TNBPCurrencyRatesThread.Create(xLink, '', '', '', hctPreconfig, RichEdit, 'MSIE');
  ShowModal;
  if FRequestThread.RequestResult = 0 then begin
    xXml := GetXmlDocument;
    xOutRoot := xXml.createElement('currencyRates');
    xXml.appendChild(xOutRoot);
    SetXmlAttribute('cashpointName', xOutRoot, 'Narodowy Bank Polski');
    SetXmlAttribute('bindingDate', xOutRoot, StringReplace(GetXmlNodeValue('data_publikacji', FRequestThread.RootElement, ''), '-', '', [rfReplaceAll, rfIgnoreCase]));
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
      end;
    end;
    Result := GetStringFromDocument(xXml);
  end;
  FRequestThread.Free;
  DecimalSeparator := xOldDecimal;
end;

procedure TNBPCurrencyRatesProgressForm.FormActivate(Sender: TObject);
begin
  if not FRequestThread.Finished then begin
    FRequestThread.Resume;
  end;
end;

procedure TNBPCurrencyRatesThread.AfterGetResponse;
var xLocalization: String;
    xResponse: String;
    xHtml: String;
    xStag, xEtag: Integer;
    xPath: String;
begin
  FResponseXml := Nil;
  FRootElement := Nil;
  xHtml := Response;
  xLocalization := '';
  xStag := LastDelimiter('/', Url);
  xPath := Copy(Url, 1, xStag);
  xStag := Pos(CSTARTTAG, xHtml);
  if xStag > 0 then begin
    xStag := xStag + Length(CSTARTTAG);
    xEtag := PosEx(CENDTAG, xHtml, xStag);
    if xEtag > xStag then begin
      xLocalization := xPath + Copy(xHtml, xStag, xEtag - xStag);
    end;
  end;
  if xLocalization <> '' then begin
    AddToReport('Rozpoczêcie pobierania tabeli kursów walut...');
    Url := xLocalization;
    RequestResult := GetResponse(xResponse);
    if RequestResult = 0 then begin
      FResponseXml := GetDocumentFromString(xResponse);
      if FResponseXml.parseError.errorCode = 0 then begin
        FRootElement := FResponseXml.selectSingleNode('tabela_kursow');
        if FRootElement = Nil then begin
          FResponseXml := Nil;
          AddToReport('Otrzymane dane nie s¹ poprawn¹ tabel¹ kursów walut');
          RequestResult := ERROR_BAD_FORMAT;
        end;
      end else begin
        FResponseXml := Nil;
        AddToReport('Otrzymane dane nie s¹ poprawn¹ tabel¹ kursów walut');
        RequestResult := ERROR_BAD_FORMAT;
      end;
    end;
  end else begin
    AddToReport('Otrzymane dane nie zawieraj¹ lokalizacji tabeli kursów walut');
    RequestResult := ERROR_BAD_FORMAT;
  end;
  Synchronize(SetFinished);
end;

procedure TNBPCurrencyRatesProgressForm.Button1Click(Sender: TObject);
begin
  if FRequestThread.IsRunning then begin
    FRequestThread.CancelRequest;
    FRequestThread.Terminate;
    WaitForSingleObject(FRequestThread.Handle, INFINITE);
  end;
  Close;
end;

procedure TNBPCurrencyRatesThread.SetFinished;
begin
  if IsRunning then begin
    if RequestResult <> 0 then begin
      NBPCurrencyRatesProgressForm.Button1.Caption := '&Zamknij';
    end else begin
      NBPCurrencyRatesProgressForm.Close;
    end;
  end;
end;

end.
