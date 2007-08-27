unit CInfoFormUnit;

interface

uses
  Windows, SysUtils, Classes, Forms, CConfigFormUnit, Buttons, StdCtrls, Controls,
  ExtCtrls;

type
  TIconType = (itWarning, itError, itInfo, itQuestion);

  TCInfoForm = class(TCConfigForm)
    Image: TImage;
    LabelInfo: TLabel;
    CheckBoxAlways: TCheckBox;
  end;

function ShowInfo(AIconType: TIconType; AText: String; AAdditional: String; AAlways: Pointer = Nil): Boolean;
procedure NotImplemented(AFunctionName: String);

implementation

uses CTools;

{$R *.dfm}

function ShowInfo(AIconType: TIconType; AText: String; AAdditional: String; AAlways: Pointer = Nil): Boolean;
var xForm: TCInfoForm;
    xCaption: String;
    xIconRes: PChar;
    xWidth: Integer;
    xHeight: Integer;
    xText: String;
    xAdditional: String;
begin
  xForm := TCInfoForm.Create(Nil);
  if AAlways <> Nil then begin
    Boolean(AAlways^) := False;
  end;
  case AIconType of
    itWarning: begin
      xCaption := 'Uwaga';
      xIconRes := IDI_EXCLAMATION;
    end;
    itError: begin
      xCaption := 'B³¹d';
      xIconRes := IDI_HAND;
    end;
    itInfo: begin
      xCaption := 'Informacja';
      xIconRes := IDI_ASTERISK;
    end;
    itQuestion: begin
      xCaption := 'Pytanie';
      xIconRes := IDI_QUESTION;
    end;
  end;
  if AIconType in [itWarning, itError, itInfo] then begin
    xForm.BitBtnOk.Visible := False;
    xForm.BitBtnCancel.Caption := 'OK';
    xForm.BitBtnCancel.Default := True;
  end else begin
    xForm.BitBtnOk.Caption := '&Tak';
    xForm.BitBtnCancel.Caption := '&Nie';
  end;
  xForm.Caption := xCaption;
  xForm.Image.Picture.Icon.Handle := LoadIcon(0, xIconRes);
  xText := StringReplace(AText, sLineBreak, ' ', [rfReplaceAll, rfIgnoreCase]);
  xText := StringReplace(xText, '\n', sLineBreak, [rfReplaceAll, rfIgnoreCase]);
  xText := WrapTextToLength(xText, 130);
  if AAdditional <> '' then begin
    xAdditional := StringReplace(AAdditional, sLineBreak, ' ', [rfReplaceAll, rfIgnoreCase]);
    xAdditional := StringReplace(xAdditional, '\n', sLineBreak, [rfReplaceAll, rfIgnoreCase]);
    xText := xText + sLineBreak + WrapTextToLength('(Szczegó³y: ' + xAdditional + ')', 130);
  end;
  xForm.LabelInfo.Caption := xText;
  xWidth := xForm.LabelInfo.Width + xForm.LabelInfo.Left + xForm.Image.Left;
  if xWidth < 270 then xWidth := 270;
  xForm.Width := xWidth;
  if xForm.LabelInfo.Height > xForm.Image.Height then begin
    xHeight := xForm.LabelInfo.Height;
  end else begin
    xHeight := xForm.Image.Height;
  end;
  xHeight := xHeight + 2 * xForm.Image.Top + 24;
  if xHeight <= xForm.Image.Height + 2 * xForm.Image.Top then xHeight := xForm.Image.Height + 2 * xForm.Image.Top;
  xForm.Height := xHeight + xForm.PanelButtons.Height;
  xForm.CheckBoxAlways.Visible := AAlways <> Nil;
  Result := xForm.ShowConfig(coAdd);
  if Result and (AAlways <> Nil) then begin
    Boolean(AAlways^) := xForm.CheckBoxAlways.Checked;
  end;
  xForm.Free;
  Application.ProcessMessages;
end;

procedure NotImplemented(AFunctionName: String);
begin
  ShowInfo(itInfo, AFunctionName + ' nie jest jeszcze zaimplementowane', '');
end;

end.
