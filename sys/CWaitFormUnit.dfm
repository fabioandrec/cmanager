object CWaitForm: TCWaitForm
  Left = 268
  Top = 229
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'CWaitForm'
  ClientHeight = 70
  ClientWidth = 356
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object LabelText: TLabel
    Left = 16
    Top = 16
    Width = 47
    Height = 13
    Caption = 'LabelText'
  end
  object ProgressBar: TProgressBar
    Left = 16
    Top = 40
    Width = 329
    Height = 13
    Smooth = True
    TabOrder = 0
  end
  object StaticText: TStaticText
    Left = 16
    Top = 40
    Width = 329
    Height = 13
    AutoSize = False
    BorderStyle = sbsSunken
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ShowAccelChar = False
    TabOrder = 1
  end
end
