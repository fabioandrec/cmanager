unit CUpdateMainFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CComponents, StdCtrls, ExtCtrls, WinInet, ShellApi, ComCtrls, ActiveX,
  CHttpRequest;

type
  TCUpdateMainForm = class(TForm)
    Image: TImage;
    Label1: TLabel;
    Label2: TLabel;
    RichEdit: TRichEdit;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  protected
    procedure WndProc(var Message: TMessage); override;
  end;

  TUpdateHttpRequest = class(THttpRequest)
  protected
    procedure AfterGetResponse; override;
  end;

var
  CUpdateMainForm: TCUpdateMainForm;
  CUpdateLink: String;
  CIsQuiet: Boolean;
  CUpdateThread: TUpdateHttpRequest;
  CFoundNewVersion: Boolean;
  CDownloadLink: String = '';

procedure UpdateSystem;

implementation

{$R *.dfm}

uses CommCtrl, CRichtext, CTools, MemCheck, CXml, RichEdit;

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
  CUpdateLink := GetParamValue('/site');
  if CUpdateLink = '' then begin
    CUpdateLink := 'http://cmanager.sourceforge.net/update.xml';  
  end;
  CUpdateThread := TUpdateHttpRequest.Create(CUpdateLink, '', '', '', hctPreconfig, CUpdateMainForm.RichEdit, 'CUpdate');
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
    CUpdateMainForm.Button2.Visible := CFoundNewVersion;
    Application.BringToFront;
    Application.Run;
  end;
  CUpdateThread.Free;
end;

function CompareVersions(ALatest, ACurrent: String): Boolean;
var xLatest, xCurrent: TStringList;
    xCount: Integer;
begin
  xLatest := TStringList.Create;
  xLatest.Text := StringReplace(ALatest, '.', sLineBreak, [rfReplaceAll, rfIgnoreCase]);
  for xCount := 0 to xLatest.Count - 1 do begin
    xLatest.Strings[xCount] := LPad(xLatest.Strings[xCount], '0', 3);
  end;
  xCurrent := TStringList.Create;
  xCurrent.Text := StringReplace(ACurrent, '.', sLineBreak, [rfReplaceAll, rfIgnoreCase]);
  for xCount := 0 to xCurrent.Count - 1 do begin
    xCurrent.Strings[xCount] := LPad(xCurrent.Strings[xCount], '0', 3);
  end;
  Result := StringReplace(xLatest.Text, sLineBreak, '', [rfReplaceAll, rfIgnoreCase]) > StringReplace(xCurrent.Text, sLineBreak, '', [rfReplaceAll, rfIgnoreCase]);
  xLatest.Free;
  xCurrent.Free;
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

procedure TCUpdateMainForm.Button2Click(Sender: TObject);
begin
  if CDownloadLink <> '' then begin
    ShellExecute(0, nil, PChar(CDownloadLink), nil, nil, SW_SHOWNORMAL);
  end;
end;

procedure TUpdateHttpRequest.AfterGetResponse;
var xDocument: ICXMLDOMDocument;
    xCurrentVersion: String;
    xLatestVersion: String;
    xNode: ICXMLDOMNode;
    xItem: ICXMLDOMNode;
    xValid: Boolean;
    xDesc: String;
begin
  if RequestResult = ERROR_SUCCESS then begin
    CoInitialize(Nil);
    xDocument := GetDocumentFromString(Response);
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
            xDesc := StringReplace(GetXmlAttribute('desc', xNode, ''), '\n', sLineBreak, [rfReplaceAll, rfIgnoreCase]);
            if xDesc <> '' then begin
              AddToReport('');
              AddToReport(xDesc);
            end;
            AddToReport('');
            CDownloadLink := GetXmlAttribute('direct', xNode, '');
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
end;

end.
