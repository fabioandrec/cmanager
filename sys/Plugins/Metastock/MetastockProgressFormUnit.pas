unit MetastockProgressFormUnit;

interface

{$WARN SYMBOL_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, jpeg, CHttpRequest, CXml, WinInet,
  CPluginTypes;

type
  TMetastockBaseThread = class(TBaseHttpRequest)
  private
    FIsValidResponse: Boolean;
    FValidCount, FInvalidCount: Integer;
    FSourceList: ICXMLDOMNodeList;
  protected
    function MainThreadProcedure: Cardinal; override;
    procedure ThreadFinished; override;
  public
    constructor Create(ALogWindow: HWND; AUrl, AProxy, AProxyUser, AProxyPass: String; AConnectionType: THttpConnectType; AAgentName: String); override;
  published
    property SourceList: ICXMLDOMNodeList read FSourceList write FSourceList;
  end;

  TMetastockProgressForm = class(TForm)
    Label2: TLabel;
    RichEdit: TRichEdit;
    Button1: TButton;
    Image: TImage;
    OpenDialogXml: TOpenDialog;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    FMetastockBaseThread: TMetastockBaseThread;
    FConfigXml: ICXMLDOMDocument;
  protected
    procedure WndProc(var Message: TMessage); override;
  public
    function RetriveStockExchanges: OleVariant;
  end;

var MetastockProgressForm: TMetastockProgressForm;

implementation

uses CRichtext, StrUtils, CPluginConsts, CBasics, MetastockConfigFormUnit;

{$R *.dfm}

function TMetastockProgressForm.RetriveStockExchanges: OleVariant;
var xError: String;
begin
  VarClear(Result);
  FConfigXml := TMetastockConfigForm.GetConfigurationAsXml(GCManagerInterface.GetConfiguration, xError);
  if (FConfigXml = Nil) or (xError <> '') then begin
    GCManagerInterface.ShowDialogBox(xError, CDIALOGBOX_ERROR);
  end else begin
    FMetastockBaseThread := TMetastockBaseThread.Create(Handle, '', '', '', '', hctPreconfig, 'MSIE');
    FMetastockBaseThread.SourceList := FConfigXml.documentElement.selectNodes('source');
    ShowModal;
    if FMetastockBaseThread.ExitCode = ERROR_SUCCESS then begin
    end;
    FMetastockBaseThread.Free;
  end;
end;

procedure TMetastockProgressForm.WndProc(var Message: TMessage);
begin
  inherited WndProc(Message);
  if Message.Msg = WMC_RICHEDITADDTEXT then begin
    PerformAddThreadRichText(RichEdit, Message.WParam);
  end;
end;

function TMetastockBaseThread.MainThreadProcedure: Cardinal;
var xResponse: String;
    xCount: Integer;
    xNode: ICXMLDOMNode;
    xRes: Cardinal;
begin
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
        Inc(FValidCount);
      end else begin
        SetXmlAttribute('error', xNode, xRes);
        Inc(FInvalidCount);
      end;
      FIsValidResponse := FIsValidResponse and (xRes = ERROR_SUCCESS);
    end;
    Inc(xCount);
  end;
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
    Close;
  end;
end;

procedure TMetastockBaseThread.ThreadFinished;
begin
  if ExitCode = ERROR_SUCCESS then begin
    if FIsValidResponse then begin
      PostMessage(MetastockProgressForm.Handle, WM_CLOSE, 0, 0);
    end else begin
      MetastockProgressForm.Button1.Caption := '&Zamknij';
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
end;

end.
