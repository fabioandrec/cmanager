unit NBPCurrencyRatesProgressFormUnit;

interface

{$WARN SYMBOL_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, jpeg, CHttpRequest, MsXml;

type
  TNBPCurrencyRatesThread = class(THttpRequest)
  private
    procedure SetFinished;
  protected
    procedure AfterGetResponse; override;
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
    function RetriveCurrencyRates(AFromLink: String; var AOutput: String): Boolean;
  end;

var NBPCurrencyRatesProgressForm: TNBPCurrencyRatesProgressForm;

implementation

uses CRichtext, StrUtils, CXml;

{$R *.dfm}

const
  CSTARTTAG = '<a href="';
  CENDTAG = '"';

function TNBPCurrencyRatesProgressForm.RetriveCurrencyRates(AFromLink: String; var AOutput: String): Boolean;
begin
  AssignRichText('Rozpoczêcie wyszukiwania lokalizacji tabeli kursów walut...', RichEdit);
  FRequestThread := TNBPCurrencyRatesThread.Create(AFromLink, '', '', '', hctPreconfig, RichEdit, 'MSIE');
  ShowModal;
  Result := FRequestThread.RequestResult = 0;
  if Result then begin
    AOutput := FRequestThread.Response;
  end;
  FRequestThread.Free;
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
    xXml: IXMLDOMDocument;
begin
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
      xXml := GetDocumentFromString(xResponse);
      if xXml.parseError.errorCode = 0 then begin
        Response := xResponse;
      end else begin
        RequestResult := ERROR_FILE_NOT_FOUND;
        AddToReport('Otrzymane dane nie s¹ poprawn¹ tabel¹ kursów walut');
      end;
    end;
  end else begin
    RequestResult := ERROR_FILE_NOT_FOUND;
    AddToReport('Otrzymane dane nie zawieraj¹ lokalizacji tabeli kursów walut');
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
