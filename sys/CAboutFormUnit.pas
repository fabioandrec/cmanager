unit CAboutFormUnit;

interface

{$WARN SYMBOL_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, ShellApi, ComCtrls,
  CComponents;

type
  TCAboutForm = class(TCConfigForm)
    Image: TImage;
    Label1: TLabel;
    Label2: TLabel;
    RichEditContrib: TRichEdit;
    CButtonMail: TCButton;
    CButton1: TCButton;
    procedure FormCreate(Sender: TObject);
    procedure CButtonMailClick(Sender: TObject);
    procedure CButton1Click(Sender: TObject);
  protected
    procedure FillForm; override;
  end;

implementation

uses CBaseFormUnit, CDatabase, CDatatools;

{$R *.dfm}

procedure TCAboutForm.FillForm;
var xText: TStringStream;
    xRes: TResourceStream;
begin
  inherited FillForm;
  Image.Picture.Icon.Handle := LoadIcon(HInstance, 'LARGEICON');
  xRes := TResourceStream.Create(HInstance, 'CONTRIB', RT_RCDATA);
  xText := TStringStream.Create('');
  xRes.SaveToStream(xText);
  AssignRichText(xText.DataString, RichEditContrib);
  xRes.Free;
  xText.Free;
end;

procedure TCAboutForm.FormCreate(Sender: TObject);
begin
  Label2.Caption := 'wersja ' + FileVersion(ParamStr(0)) + ' Beta';
end;

procedure TCAboutForm.CButtonMailClick(Sender: TObject);
begin
  ShellExecute(0, nil, 'mailto:mabaturo@wp.pl?subject=CManager', nil, nil, SW_SHOWNORMAL);
end;

procedure TCAboutForm.CButton1Click(Sender: TObject);
begin
  ShellExecute(0, nil, 'http://cmanager.sourceforge.net', nil, nil, SW_SHOWNORMAL);
end;

end.
