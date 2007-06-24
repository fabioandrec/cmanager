unit CCalculatorFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Buttons, ExtCtrls, CComponents, ActnList, StdCtrls;

type
  TCCalculatorForm = class(TForm)
    RichEdit: TCRichEdit;
    CValue: TCCurrEdit;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    FPrecision: SmallInt;
    FValue: Double;
    FOperation: Char;
    FWasDigit: Boolean;
    FWasOperation: Boolean;
    FWasError: Boolean;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WndProc(var Message: TMessage); override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

function ShowCalculator(AParent: TWinControl; APrecision: Integer; var AResult: Double): Boolean;

implementation

uses DateUtils, Types, CRichtext;

{$R *.dfm}

function ShowCalculator(AParent: TWinControl; APrecision: Integer; var AResult: Double): Boolean;
var xForm: TCCalculatorForm;
begin
  Result := False;
  xForm := TCCalculatorForm.Create(Nil);
  with xForm do begin
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
      AResult := FValue;
    end;
  end;
  xForm.Free;
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
var xPrevValue, xOperand: Double;
begin
  if Key in ['-', '+', '*', '/', '%'] then begin
    FWasOperation := True;
    if (not FWasDigit) then begin
      FOperation := Key;
    end else begin
      if (FOperation = ' ') then begin
        FOperation := Key;
        FWasOperation := True;
        FValue := CValue.Value;
      end else begin
        xPrevValue := FValue;
        xOperand := CValue.Value;
        try
          if FOperation = '+' then begin
            FValue := xPrevValue + xOperand;
          end else if FOperation = '-' then begin
            FValue := xPrevValue - xOperand;
          end else if FOperation = '*' then begin
            FValue := xPrevValue * xOperand;
          end else if FOperation = '/' then begin
            FValue := xPrevValue / xOperand;
          end else if FOperation = '%' then begin
            FValue := xPrevValue * xOperand / 100;
          end;
        except
          FWasError := True;
        end;
        if not FWasError then begin
          try
            AddRichText(CRtFRA + CValue.FormatIt(xPrevValue, False) + ' ' + FOperation + ' ' + CValue.FormatIt(xOperand, False), RichEdit);
            AddRichText(CRtFRA + '=', RichEdit);
            AddRichText(CRtFRA + CRtfSB + CValue.FormatIt(FValue, False) + CRtfEB, RichEdit);
            FOperation := Key;
          except
          end;
        end;
      end;
    end;
  end else if Key in ['='] then begin
    FWasOperation := True;
    if FOperation <> ' ' then begin
      xPrevValue := FValue;
      xOperand := CValue.Value;
      try
        if FOperation = '+' then begin
          FValue := xPrevValue + xOperand;
        end else if FOperation = '-' then begin
          FValue := xPrevValue - xOperand;
        end else if FOperation = '*' then begin
          FValue := xPrevValue * xOperand;
        end else if FOperation = '/' then begin
          FValue := xPrevValue / xOperand;
        end else if FOperation = '%' then begin
          FValue := xPrevValue * xOperand / 100;
        end;
      except
        FWasError := True;
      end;
      if not FWasError then begin
        try
          AddRichText(CRtFRA + CValue.FormatIt(xPrevValue, False) + ' ' + FOperation + ' ' + CValue.FormatIt(xOperand, False), RichEdit);
          AddRichText(CRtFRA + '=', RichEdit);
          AddRichText(CRtFRA + CRtfSB + CValue.FormatIt(FValue, False) + CRtfEB, RichEdit);
          FOperation := ' ';
        except
        end;
      end;
    end;
  end else if Key in ['0'..'9'] then begin
    FWasDigit := True;
    if FWasOperation then begin
      FWasOperation := False;
      CValue.Value := 0;
    end;
  end;
  RichEdit.SelStart := MaxInt;
  SendMessage(RichEdit.Handle, EM_SCROLLCARET, 0, 0);
  FWasError := False;
  inherited;
end;

constructor TCCalculatorForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FWasDigit := False;
  FWasOperation := False;
  FWasError := False;
end;

end.