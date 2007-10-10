unit NBPBSCurrencyRatesProgressFormUnit;

interface

{$WARN SYMBOL_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, jpeg, CHttpRequest, CXmlTlb;

type
  TNBPBSCurrencyRatesThread = class(THttpRequest)
  private
    FResponseXml: IXMLDOMDocument2;
    FRootElement: IXMLDOMNode;
    procedure SetFinished;
  protected
    procedure AfterGetResponse; override;
  public
    property ResponseXml: IXMLDOMDocument2 read FResponseXml write FResponseXml;
    property RootElement: IXMLDOMNode read FRootElement write FRootElement;
  end;

  TNBPBSCurrencyRatesProgressForm = class(TForm)
    Label2: TLabel;
    RichEdit: TRichEdit;
    Button1: TButton;
    Image: TImage;
    OpenDialogXml: TOpenDialog;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    FRequestThread: TNBPBSCurrencyRatesThread;
  public
    function RetriveCurrencyRates: OleVariant;
  end;

var NBPBSCurrencyRatesProgressForm: TNBPBSCurrencyRatesProgressForm;

implementation

uses CRichtext, StrUtils, CXml, NBPBSCurrencyRatesConfigFormUnit,
  CPluginConsts;

{$R *.dfm}

const
  CSTARTTAG = '<a href="';
  CENDTAG = '"';

function TNBPBSCurrencyRatesProgressForm.RetriveCurrencyRates: OleVariant;
var xOutRoot: IXMLDOMNode;
    xPositions: IXMLDOMNodeList;
    xPosition, xOut: IXMLDOMNode;
    xCount: Integer;
    xCurrencyName, xCurrencyIso: String;
    xCurrencyQuantity: Integer;
    xCurrencyRate: Currency;
    xOldDecimal: Char;
    xLink: String;
    xXml: IXMLDOMDocument2;
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
    xLink := 'http://www.nbp.org.pl/Kursy/KursyC.html';
  end;
  if xProceed then begin
    FRequestThread := TNBPBSCurrencyRatesThread.Create(xLink, '', '', '', hctPreconfig, RichEdit, 'MSIE');
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
        if (xCurrencyName <> '') and (xCurrencyIso <> '') and (xCurrencyQuantity <> -1) then begin
          xCurrencyRate := StrToFloatDef(StringReplace(GetXmlNodeValue('kurs_kupna', xPosition, ''), ',', '.', [rfIgnoreCase, rfReplaceAll]), -1);
          if (xCurrencyRate <> -1) then begin
            xOut := xXml.createElement('currencyRate');
            xOutRoot.appendChild(xOut);
            SetXmlAttribute('sourceName', xOut, xCurrencyName);
            SetXmlAttribute('sourceIso', xOut, xCurrencyIso);
            SetXmlAttribute('targetName', xOut, 'Polski z³oty');
            SetXmlAttribute('targetIso', xOut, 'PLN');
            SetXmlAttribute('quantity', xOut, xCurrencyQuantity);
            SetXmlAttribute('rate', xOut, Trim(Format('%-10.4f', [xCurrencyRate])));
            SetXmlAttribute('type', xOut, CCURRENCYRATE_BUY);
          end;
          xCurrencyRate := StrToFloatDef(StringReplace(GetXmlNodeValue('kurs_sprzedazy', xPosition, ''), ',', '.', [rfIgnoreCase, rfReplaceAll]), -1);
          if (xCurrencyRate <> -1) then begin
            xOut := xXml.createElement('currencyRate');
            xOutRoot.appendChild(xOut);
            SetXmlAttribute('sourceName', xOut, xCurrencyName);
            SetXmlAttribute('sourceIso', xOut, xCurrencyIso);
            SetXmlAttribute('targetName', xOut, 'Polski z³oty');
            SetXmlAttribute('targetIso', xOut, 'PLN');
            SetXmlAttribute('quantity', xOut, xCurrencyQuantity);
            SetXmlAttribute('rate', xOut, Trim(Format('%-10.4f', [xCurrencyRate])));
            SetXmlAttribute('type', xOut, CCURRENCYRATE_SELL);
          end;
        end;
      end;
      Result := GetStringFromDocument(xXml);
    end;
    FRequestThread.Free;
  end;
  DecimalSeparator := xOldDecimal;
end;

procedure TNBPBSCurrencyRatesProgressForm.FormActivate(Sender: TObject);
begin
  if not FRequestThread.Finished then begin
    FRequestThread.Resume;
  end;
end;

procedure TNBPBSCurrencyRatesThread.AfterGetResponse;
var xLocalization: String;
    xResponse: String;
    xHtml: String;
    xStag, xEtag: Integer;
    xPath: String;
begin
  FResponseXml := Nil;
  FRootElement := Nil;
  if AnsiUpperCase(Copy(Url, 1, 7)) = 'FILE://' then begin
    FResponseXml := GetDocumentFromString(Response);
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
  end else begin
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
  end;
  Synchronize(SetFinished);
end;

procedure TNBPBSCurrencyRatesProgressForm.Button1Click(Sender: TObject);
begin
  if FRequestThread.IsRunning then begin
    FRequestThread.CancelRequest;
    FRequestThread.Terminate;
    WaitForSingleObject(FRequestThread.Handle, INFINITE);
  end;
  Close;
end;

procedure TNBPBSCurrencyRatesThread.SetFinished;
begin
  if IsRunning then begin
    if RequestResult <> 0 then begin
      NBPBSCurrencyRatesProgressForm.Button1.Caption := '&Zamknij';
    end else begin
      NBPBSCurrencyRatesProgressForm.Close;
    end;
  end;
end;

end.
