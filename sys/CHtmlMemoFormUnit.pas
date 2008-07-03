unit CHtmlMemoFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, OleCtrls, SHDocVw,
  CComponents, MsHtml;

type
  THtmlAnswer = class(TObject)
  public
    procedure UpdateAnswer(AWebBrowser: IWebBrowser2); virtual; abstract;
  end;

  TCHtmlMemoForm = class(TCConfigForm)
    Panel1: TPanel;
    Panel2: TPanel;
    CBrowser: TCBrowser;
    procedure CBrowserDocumentComplete(Sender: TObject; const pDisp: IDispatch; var URL: OleVariant);
  private
    FHtmlAnswer: THtmlAnswer;
  public
    function ShowConfig(AOperation: TConfigOperation; ACanResize: Boolean = False; ANoneButtonCaption: String = ''): Boolean; override;
  end;

procedure ShowHtmlReport(AFormTitle: String; AReport: String; AWidth, AHeight: Integer; AButtonCaption: String; AHtmlAnswer: THtmlAnswer);

implementation

uses CPreferences, CTemplates;

{$R *.dfm}

procedure ShowHtmlReport(AFormTitle: String; AReport: String; AWidth, AHeight: Integer; AButtonCaption: String; AHtmlAnswer: THtmlAnswer);
var xForm: TCHtmlMemoForm;
    xReport: String;
begin
  xForm := TCHtmlMemoForm.Create(Application);
  xForm.Caption := AFormTitle;
  xForm.Width := AWidth;
  xForm.Height := AHeight;
  xForm.FHtmlAnswer := AHtmlAnswer;
  xReport := GBaseTemlatesList.ExpandTemplates(AReport, GBasePreferences);
  xForm.CBrowser.LoadFromString(xReport);
  xForm.ShowConfig(coNone, False, '&OK');
  xForm.Free;
end;

procedure TCHtmlMemoForm.CBrowserDocumentComplete(Sender: TObject; const pDisp: IDispatch; var URL: OleVariant);
begin
  CBrowser.OleObject.document.body.style.overflowY := 'hidden';
  CBrowser.OleObject.document.body.style.overflowX := 'hidden';
end;

function TCHtmlMemoForm.ShowConfig(AOperation: TConfigOperation; ACanResize: Boolean; ANoneButtonCaption: String): Boolean;
begin
  Result := inherited ShowConfig(AOperation, ACanResize, ANoneButtonCaption);
  if FHtmlAnswer <> Nil then begin
    FHtmlAnswer.UpdateAnswer(CBrowser.DefaultInterface);
  end;
end;

end.
