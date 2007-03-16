object CUpdateMainForm: TCUpdateMainForm
  Left = 422
  Top = 341
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Aktualizacja'
  ClientHeight = 274
  ClientWidth = 413
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
    Width = 201
    Height = 13
    Caption = '- trwa sprawdzanie dost'#281'pnych aktualizacji'
  end
  object RichEdit: TRichEdit
    Left = 16
    Top = 64
    Width = 385
    Height = 161
    BevelInner = bvNone
    BevelKind = bkTile
    BorderStyle = bsNone
    Color = clBtnFace
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
  end
  object Button1: TButton
    Left = 328
    Top = 240
    Width = 75
    Height = 25
    Caption = '&Przerwij'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 16
    Top = 240
    Width = 75
    Height = 25
    Caption = 'P&obierz'
    TabOrder = 1
    Visible = False
    OnClick = Button2Click
  end
end
