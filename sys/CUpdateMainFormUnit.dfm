object CUpdateMainForm: TCUpdateMainForm
  Left = 412
  Top = 275
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Sprawdzanie aktualizacji'
  ClientHeight = 339
  ClientWidth = 372
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
end
