unit NBPACurrencyRatesProgressFormUnit;

interface

{$WARN SYMBOL_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, jpeg, CHttpRequest, CXml;

type
  TNBPACurrencyRatesThread = class(THttpRequest)
  private
    FResponseXml: ICXMLDOMDocument;
    FRootElement: ICXMLDOMNode;
    procedure SetFinished;
  protected
    procedure AfterGetResponse; override;
  public
    property ResponseXml: ICXMLDOMDocument read FResponseXml write FResponseXml;
    property RootElement: ICXMLDOMNode read FRootElement write FRootElement;
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
    FRequestThread: TNBPACurrencyRatesThread;
  public
    function RetriveCurrencyRates: OleVariant;
  end;

var NBPACurrencyRatesProgressForm: TNBPACurrencyRatesProgressForm;

implementation

uses CRichtext, StrUtils, NBPACurrencyRatesConfigFormUnit,
  CPluginConsts;

{$R *.dfm}

const
  CSTARTTAG = '<a href="';
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
    FRequestThread := TNBPACurrencyRatesThread.Create(xLink, '', '', '', hctPreconfig, RichEdit, 'MSIE');
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
          SetXmlAttribute('type', xOut, CCURRENCYRATE_AVG);
        end;
      end;
      Result := GetStringFromDocument(xXml);
    end;
    FRequestThread.Free;
  end;
  DecimalSeparator := xOldDecimal;
end;

procedure TNBPACurrencyRatesProgressForm.FormActivate(Sender: TObject);
begin
  if not FRequestThread.Finished then begin
    FRequestThread.Resume;
  end;
end;

procedure TNBPACurrencyRatesThread.AfterGetResponse;
var xLocalization: String;
    xResponse: String;
    xHtml: String;
    xStag, xEtag: Integer;
    xPath: String;
begin
  FResponseXml := Nil;
  FRootElement := Nil;
  if AnsiUpperCase(Copy(Url, 1, 7)) = 'FILE://' then begin
    FResponseXml := GetDocumentFromString(Response, Nil);
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
        FResponseXml := GetDocumentFromString(xResponse, Nil);
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

procedure TNBPACurrencyRatesProgressForm.Button1Click(Sender: TObject);
begin
  if FRequestThread.IsRunning then begin
    FRequestThread.CancelRequest;
    FRequestThread.Terminate;
    WaitForSingleObject(FRequestThread.Handle, INFINITE);
  end;
  Close;
end;

procedure TNBPACurrencyRatesThread.SetFinished;
begin
  if IsRunning then begin
    if RequestResult <> 0 then begin
      NBPACurrencyRatesProgressForm.Button1.Caption := '&Zamknij';
    end else begin
      NBPACurrencyRatesProgressForm.Close;
    end;
  end;
end;

end.
