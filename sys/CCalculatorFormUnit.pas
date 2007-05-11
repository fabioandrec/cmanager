unit CCalculatorFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, ExtCtrls, CComponents, ActnList, StdCtrls;

type
  TCCalculatorForm = class(TForm)
    RichEdit: TRichEdit;
    CValue: TCCurrEdit;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    FPrecision: SmallInt;
    FValue: Double;
    FOperation: Char;
    procedure FinishOperation;
    procedure StartOperation(AKey: Char);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WndProc(var Message: TMessage); override;
  end;

function ShowCalculator(AParent: TWinControl; APrecision: Integer; var AResult: Double): Boolean;

implementation

uses DateUtils, Types, CRichtext;

{$R *.dfm}

function ShowCalculator(AParent: TWinControl; APrecision: Integer; var AResult: Double): Boolean;
begin
  Result := False;
  with TCCalculatorForm.Create(Nil) do begin
    FPrecision := APrecision;
    FValue := 0;
    FOperation := ' ';
    CValue.CurrencyStr := '';
    CValue.Decimals := FPrecision;
    Top := AParent.ClientOrigin.Y + AParent.Height + 2;
    Left := AParent.ClientOrigin.X + 4;
    if Left + Width > Screen.Width then begin
      Left := Screen.Width - Width - 5;
    end;
    Show;
    repeat
      Application.HandleMessage;
    until (ModalResult = mrOk) or (ModalResult = mrCancel);
    if ModalResult = mrOk then begin
      Result := True;
    end;
    Free;
  end;
end;

procedure TCCalculatorForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then begin
    ModalResult := mrCancel;
  end else if Key = VK_RETURN then begin
    ModalResult := mrOk;
  end;
end;

procedure TCCalculatorForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do begin
    Style := WS_POPUP or WS_DLGFRAME;
    if CheckWin32Version(5, 1) then begin
      WindowClass.Style := WindowClass.style or CS_DROPSHADOW;
    end;
  end;
end;

procedure TCCalculatorForm.WndProc(var Message: TMessage);
begin
  inherited WndProc(Message);
  if Message.Msg = WM_ACTIVATE then begin
    if Message.WParamLo = WA_INACTIVE then begin
      ModalResult := mrCancel;
    end;
  end;
end;

procedure TCCalculatorForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key in ['+', '-', '*', '/']) then begin
    FinishOperation;
    StartOperation(Key);
    Key := #0;
  end else begin
    FinishOperation;
    Key := #0;
  end;
end;

procedure TCCalculatorForm.FinishOperation;
begin
  if FOperation = '+' then begin
    FValue := FValue + CValue.Value;
  end else if FOperation = '-' then begin
    FValue := FValue - CValue.Value;
  end else if FOperation = '*' then begin
    FValue := FValue * CValue.Value;
  end else if FOperation = '/' then begin
    FValue := FValue / CValue.Value;
  end;
  if FOperation <> ' ' then begin
    AddRichText(FloatToStr(CValue.Value), RichEdit);
    AddRichText('=', RichEdit);
    AddRichText(CRtfSB + FloatToStr(FValue) + CRtfEB, RichEdit);
    FOperation := ' ';
  end else begin
    AddRichText(FloatToStr(CValue.Value), RichEdit);
  end;
end;

procedure TCCalculatorForm.StartOperation(AKey: Char);
begin
  FOperation := AKey;
  AddRichText(AKey, RichEdit);
  CValue.Value := 0;
end;

end.
