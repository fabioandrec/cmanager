object StartupForm: TStartupForm
  Left = 316
  Top = 648
  BorderIcons = []
  BorderStyle = bsNone
  ClientHeight = 31
  ClientWidth = 220
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 131
    Height = 13
    Caption = 'CManager jest uruchomiony'
  end
  object Label2: TLabel
    Left = 144
    Top = 8
    Width = 32
    Height = 13
    Caption = 'Label2'
  end
  object Timer: TTimer
    OnTimer = TimerTimer
    Left = 192
    Top = 40
  end
end
