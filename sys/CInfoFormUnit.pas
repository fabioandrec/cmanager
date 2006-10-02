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
  end;

function ShowInfo(AIconType: TIconType; AText: String; AAdditional: String): Boolean;

implementation

{$R *.dfm}

function ShowInfo(AIconType: TIconType; AText: String; AAdditional: String): Boolean;
var xForm: TCInfoForm;
    xCaption: String;
    xIconRes: PChar;
    xWidth: Integer;
    xHeight: Integer;
    xText: String;
begin
  xForm := TCInfoForm.Create(Nil);
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
  xText := AText;
  if AAdditional <> '' then begin
    xText := xText + #10 + '(Szczegó³y: ' + AAdditional + ')';
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
  Result := xForm.ShowConfig(coAdd);
  xForm.Free;
end;

end.
