object CCalculatorForm: TCCalculatorForm
  Left = 507
  Top = 109
  Anchors = [akLeft, akTop, akRight, akBottom]
  BorderStyle = bsNone
  Caption = 'CCalendarForm'
  ClientHeight = 125
  ClientWidth = 194
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  DesignSize = (
    194
    125)
  PixelsPerInch = 96
  TextHeight = 13
  object RichEdit: TRichEdit
    Left = 13
    Top = 12
    Width = 172
    Height = 69
    TabStop = False
    Anchors = [akLeft, akTop, akBottom]
    BevelKind = bkTile
    BorderStyle = bsNone
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object CValue: TCCurrEdit
    Left = 12
    Top = 91
    Width = 173
    Height = 21
    Anchors = [akLeft, akTop, akRight, akBottom]
    BorderStyle = bsNone
    TabOrder = 1
    Decimals = 2
    ThousandSep = True
    CurrencyStr = 'z'#322
    BevelKind = bkTile
    WithCalculator = False
  end
end
