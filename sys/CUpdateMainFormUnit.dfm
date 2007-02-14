object CUpdateMainForm: TCUpdateMainForm
  Left = 528
  Top = 411
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Aktualizacja'
  ClientHeight = 165
  ClientWidth = 316
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
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 316
    Height = 165
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object Image: TImage
      Left = 16
      Top = 16
      Width = 32
      Height = 32
      AutoSize = True
    end
    object Label1: TLabel
      Left = 48
      Top = 26
      Width = 50
      Height = 13
      Caption = 'Manager'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 100
      Top = 26
      Width = 204
      Height = 13
      Caption = '- trwa sprawdzanie dost'#281'pnych aktualizacji.'
    end
  end
end
