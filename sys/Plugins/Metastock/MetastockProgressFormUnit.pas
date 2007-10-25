unit MetastockProgressFormUnit;

interface

{$WARN SYMBOL_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, jpeg, CHttpRequest, CXml, WinInet,
  CPluginTypes, Types, Math;

type
  TMetastockBaseThread = class(TBaseHttpRequest)
  private
    FIsValidResponse: Boolean;
    FValidCount, FInvalidCount: Integer;
    FSourceList: ICXMLDOMNodeList;
    FOutputXml: ICXMLDOMDocument;
  protected
    function MainThreadProcedure: Cardinal; override;
    procedure ThreadFinished; override;
  public
    constructor Create(ALogWindow: HWND; AUrl, AProxy, AProxyUser, AProxyPass: String; AConnectionType: THttpConnectType; AAgentName: String); override;
  published
    property SourceList: ICXMLDOMNodeList read FSourceList write FSourceList;
    property OutputXml: ICXMLDOMDocument read FOutputXml write FOutputXml;
  end;

  TMetastockProgressForm = class(TForm)
    Label2: TLabel;
    RichEdit: TRichEdit;
    Button1: TButton;
    Image: TImage;
    OpenDialogXml: TOpenDialog;
    Button2: TButton;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    FMetastockBaseThread: TMetastockBaseThread;
    FConfigXml: ICXMLDOMDocument;
  protected
    procedure WndProc(var Message: TMessage); override;
  public
    function RetriveStockExchanges: OleVariant;
  end;

var MetastockProgressForm: TMetastockProgressForm;

const WM_SHOWIMPORTBUTTON = WM_USER + 1;

implementation

uses CRichtext, StrUtils, CPluginConsts, CBasics, MetastockConfigFormUnit,
  CTools;

{$R *.dfm}

function TMetastockProgressForm.RetriveStockExchanges: OleVariant;
var xError: String;
begin
  VarClear(Result);
  FConfigXml := TMetastockConfigForm.GetConfigurationAsXml(GCManagerInterface.GetConfiguration, xError);
  if (FConfigXml = Nil) or (xError <> '') then begin
    GCManagerInterface.ShowDialogBox(xError, CDIALOGBOX_ERROR);
  end else begin
    Button2.Visible := False;
    FMetastockBaseThread := TMetastockBaseThread.Create(Handle, '', '', '', '', hctPreconfig, 'MSIE');
    FMetastockBaseThread.SourceList := FConfigXml.documentElement.selectNodes('source');
    ShowModal;
    if FMetastockBaseThread.OutputXml <> Nil then begin
      Result := GetStringFromDocument(FMetastockBaseThread.OutputXml);
    end;
    FMetastockBaseThread.Free;
  end;
end;

procedure TMetastockProgressForm.WndProc(var Message: TMessage);
begin
  inherited WndProc(Message);
  if Message.Msg = WMC_RICHEDITADDTEXT then begin
    PerformAddThreadRichText(RichEdit, Message.WParam);
  end else if Message.Msg = WM_SHOWIMPORTBUTTON then begin
    Button2.Visible := True;
  end;
end;

function TMetastockBaseThread.MainThreadProcedure: Cardinal;
var xResponse: String;
    xCount: Integer;
    xNode, xStockNode, xExNode: ICXMLDOMNode;
    xRes: Cardinal;
    xRoot: ICXMLDOMNode;
    xResStr: TStringList;
    xLineNum: Integer;
    xResValid: Boolean;
    xArray: TStringDynArray;
    xFieldSeparator: String;
    xDecimalSeparator: String;
    xDateSeparator: String;
    xTimeSeparator: String;
    xIdentColumn: Integer;
    xRegDateColumn, xRegTimeColumn: Integer;
    xValueColumn: Integer;
    xDateFormat: String;
    xTimeFormat: String;
    xDateTimeStr: String;
    xValueStr: String;
    xIdentifierStr: String;
    xOldDecimalSep: Char;
    xValueOf: Currency;
    xRegDatetime: TDateTime;
begin
  xOldDecimalSep := DecimalSeparator;
  DecimalSeparator := '.';
  xCount := 0;
  FValidCount := 0;
  FInvalidCount := 0;
  Result := ERROR_SUCCESS;
  while (xCount <= FSourceList.length - 1) and (not IsCancelled) do begin
    xNode := FSourceList.item[xCount];
    AddToReport('Pobieranie ' + GetXmlAttribute('name', xNode, ''));
    Url := GetXmlAttribute('link', xNode, '');
    if Url <> '' then begin
      xRes := GetResponse('', xResponse);
      if xRes = ERROR_SUCCESS then begin
        SetXmlAttribute('response', xNode, xResponse);
        SetXmlAttribute('isValid', xNode, True);
      end else begin
        SetXmlAttribute('error', xNode, xRes);
        SetXmlAttribute('isValid', xNode, False);
      end;
      FIsValidResponse := FIsValidResponse and (xRes = ERROR_SUCCESS);
    end;
    Inc(xCount);
  end;
  if not IsCancelled then begin
    FOutputXml := GetXmlDocument;
    xRoot := FOutputXml.createElement('exchanges');
    FOutputXml.appendChild(xRoot);
    xCount := 0;
    while (xCount <= FSourceList.length - 1) and (not IsCancelled) do begin
      xNode := FSourceList.item[xCount];
      xFieldSeparator := GetXmlAttribute('fieldSeparator', xNode, ',');
      xDecimalSeparator := GetXmlAttribute('decimalSeparator', xNode, '.');
      xDateSeparator := GetXmlAttribute('dateSeparator', xNode, '');
      xTimeSeparator := GetXmlAttribute('timeSeparator', xNode, '');
      xDateFormat := GetXmlAttribute('dateFormat', xNode, 'RMD');
      xTimeFormat := GetXmlAttribute('timeFormat', xNode, 'HN');
      xIdentColumn := GetXmlAttribute('identColumn', xNode, 1);
      xRegDateColumn := GetXmlAttribute('regDateColumn', xNode, 2);
      xRegTimeColumn := GetXmlAttribute('regTimeColumn', xNode, 3);
      xValueColumn := GetXmlAttribute('valueColumn', xNode, 4);
      if GetXmlAttribute('isValid', xNode, False) then begin
        xResStr := TStringList.Create;
        xResStr.Text := GetXmlAttribute('response', xNode, '');
        xResValid := True;
        xLineNum := 0;
        xStockNode := FOutputXml.createElement('stockExchange');
        while (xLineNum <= xResStr.Count - 1) and xResValid and (not IsCancelled) do begin
          if Trim(xResStr.Strings[xLineNum]) <> '' then begin
            xArray := StringToStringArray(xResStr.Strings[xLineNum], xFieldSeparator);
            if Length(xArray) >= Max(Max(xIdentColumn, Max(xRegDateColumn, xRegTimeColumn)), xValueColumn) then begin
              xIdentifierStr := Trim(xArray[xIdentColumn - 1]);
              xValueStr := Trim(xArray[xValueColumn - 1]);
              if xRegDateColumn = xRegTimeColumn then begin
                xDateTimeStr := Trim(xArray[xRegTimeColumn]);
              end else begin
                xDateTimeStr := Trim(xArray[xRegDateColumn] + ' ' + xArray[xRegTimeColumn]);
              end;
              if xIdentifierStr <> '' then begin
                if StrToCurrencyDecimalDot(StringReplace(xValueStr, xDecimalSeparator, '.', [rfReplaceAll, rfIgnoreCase]), xValueOf) then begin
                  if StrToDatetime(xDateTimeStr, xDateFormat, xTimeFormat, xDateSeparator, xTimeSeparator, xRegDatetime) then begin
                    xExNode := FOutputXml.createElement('exchange');
                    xStockNode.appendChild(xExNode);
                    SetXmlAttribute('identifier', xExNode, xIdentifierStr);
                    SetXmlAttribute('regDateTime', xExNode, DateTimeToXsd(xRegDatetime));
                    SetXmlAttribute('value', xExNode, Trim(Format('%-10.4f', [xValueOf])));
                  end else begin
                    xResValid := False;
                    AddToReport('Z ' + GetXmlAttribute('name', xNode, '') + ' otrzymano niepoprawn¹ wartoœæ daty lub czasu notowania');
                  end;
                end else begin
                  xResValid := False;
                  AddToReport('Z ' + GetXmlAttribute('name', xNode, '') + ' otrzymano niepoprawn¹ wartoœæ intstrumentu');
                end;
              end else begin
                xResValid := False;
                AddToReport('Z ' + GetXmlAttribute('name', xNode, '') + ' otrzymano pusty identyfikator');
              end;
            end else begin
              xResValid := False;
              AddToReport('Dane odebrane z ' + GetXmlAttribute('name', xNode, '') + ' nie s¹ zgodne z definicj¹ pliku importu');
            end;
          end;
          Inc(xLineNum);
        end;
        if xResValid then begin
          SetXmlAttribute('cashpointName', xStockNode, GetXmlAttribute('cashpointName', xNode, ''));
          SetXmlAttribute('searchType', xStockNode, GetXmlAttribute('searchType', xNode, ''));
          xRoot.appendChild(xStockNode);
          Inc(FValidCount);
        end else begin
          Inc(FInvalidCount);
          xStockNode := Nil;
        end;
        xResStr.Free
      end else begin
        Inc(FInvalidCount);
      end;
      Inc(xCount);
    end;
  end;
  if IsCancelled then begin
    FOutputXml := Nil;
  end;
  DecimalSeparator := xOldDecimalSep;
end;

procedure TMetastockProgressForm.FormActivate(Sender: TObject);
begin
  if FMetastockBaseThread.Status = tsSuspended then begin
    FMetastockBaseThread.InitThread;
  end;
end;

procedure TMetastockProgressForm.Button1Click(Sender: TObject);
begin
  if FMetastockBaseThread.Status = tsRunning then begin
    FMetastockBaseThread.CancelThread;
  end else begin
    if (not FMetastockBaseThread.FIsValidResponse) or (FMetastockBaseThread.FInvalidCount <> 0) then begin
      FMetastockBaseThread.OutputXml := Nil;
    end;
    Close;
  end;
end;

procedure TMetastockBaseThread.ThreadFinished;
begin
  if ExitCode = ERROR_SUCCESS then begin
    if FIsValidResponse and (FInvalidCount = 0) then begin
      PostMessage(MetastockProgressForm.Handle, WM_CLOSE, 0, 0);
    end else begin
      PostMessage(MetastockProgressForm.Handle, WM_SHOWIMPORTBUTTON, 0, 0);
      MetastockProgressForm.Button1.Caption := '&Anuluj';
    end;
  end else if ExitCode = ERROR_CANCELLED then begin
    PostMessage(MetastockProgressForm.Handle, WM_CLOSE, 0, 0);
  end else begin
    MetastockProgressForm.Button1.Caption := '&Zamknij';
  end;
end;

constructor TMetastockBaseThread.Create(ALogWindow: HWND; AUrl, AProxy, AProxyUser, AProxyPass: String; AConnectionType: THttpConnectType; AAgentName: String);
begin
  inherited Create(ALogWindow, AUrl, AProxy, AProxyUser, AProxyPass, AConnectionType, AAgentName);
  FIsValidResponse := True;
  FOutputXml := Nil;
end;

procedure TMetastockProgressForm.Button2Click(Sender: TObject);
begin
  Close;
end;

end.
