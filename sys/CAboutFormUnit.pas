unit CAboutFormUnit;

interface

{$WARN SYMBOL_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, ShellApi, ComCtrls,
  CComponents, ClipBrd, CRichtext, RichEdit;

type
  TCAboutForm = class(TCConfigForm)
    Image: TImage;
    Label2: TLabel;
    RichEditContrib: TRichEdit;
    CButtonMail: TCButton;
    CButton1: TCButton;
    CButton2: TCButton;
    procedure FormCreate(Sender: TObject);
    procedure CButtonMailClick(Sender: TObject);
    procedure CButton1Click(Sender: TObject);
    procedure CButton2Click(Sender: TObject);
  protected
    procedure FillForm; override;
    procedure WndProc(var Message: TMessage); override;
  end;

procedure ShowAbout;

implementation

uses CBaseFormUnit, CDatabase, CDatatools, CTools,
     CInfoFormUnit;

{$R *.dfm}

var GAboutDialog: TCAboutForm;

procedure ShowAbout;
begin
  GAboutDialog := TCAboutForm.Create(Nil);
  GAboutDialog.ShowConfig(coNone);
  GAboutDialog.Free;
end;

procedure TCAboutForm.FillForm;
var xText: TStringStream;
    xRes: TResourceStream;
begin
  inherited FillForm;
  xRes := TResourceStream.Create(HInstance, 'CONTRIB', RT_RCDATA);
  xText := TStringStream.Create('');
  xRes.SaveToStream(xText);
  AssignRichText(xText.DataString, RichEditContrib);
  xRes.Free;
  xText.Free;
end;

procedure TCAboutForm.FormCreate(Sender: TObject);
var xMask: Cardinal;
begin
  Label2.Caption := 'CManager wersja ' + FileVersion(ParamStr(0)) + ' Beta';
  xMask := SendMessage(RichEditContrib.Handle, EM_GETEVENTMASK, 0, 0);
  SendMessage(RichEditContrib.Handle, EM_SETEVENTMASK, 0, xMask or ENM_LINK);
  SendMessage(RichEditContrib.Handle, EM_AUTOURLDETECT, Integer(True), 0);
end;

procedure TCAboutForm.CButtonMailClick(Sender: TObject);
begin
  ShellExecute(0, nil, 'mailto:levin_a@users.sourceforge.net?subject=CManager', nil, nil, SW_SHOWNORMAL);
end;

procedure TCAboutForm.CButton1Click(Sender: TObject);
begin
  ShellExecute(0, nil, 'http://cmanager.sourceforge.net', nil, nil, SW_SHOWNORMAL);
end;

procedure TCAboutForm.CButton2Click(Sender: TObject);
begin
  Clipboard.Open;
  Clipboard.Clear;
  Clipboard.AsText := '4963605';
  Clipboard.Close;
  ShowInfo(itInfo, 'Numer gadu-gadu zosta³ skopiowany do schowka', '');
end;

procedure TCAboutForm.WndProc(var Message: TMessage);
var xP: TENLink;
    xUrl: string;
begin
  if (Message.Msg = WM_NOTIFY) then begin
    if (PNMHDR(Message.LParam).code = EN_LINK) then begin
      xP := TENLink(Pointer(TWMNotify(Message).NMHdr)^);
      if (xP.msg = WM_LBUTTONDOWN) then begin
        SendMessage(RichEditContrib.Handle, EM_EXSETSEL, 0, LongInt(@(xP.chrg)));
        xUrl := RichEditContrib.SelText;
        ShellExecute(Handle, 'open', PChar(xUrl), Nil, Nil, SW_SHOWNORMAL);
      end
    end
  end;
  inherited;
end;

end.
