object NBPCurrencyRatesConfigForm: TNBPCurrencyRatesConfigForm
  Left = 346
  Top = 416
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Konfiguracja'
  ClientHeight = 140
  ClientWidth = 359
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object PanelConfig: TPanel
    Left = 0
    Top = 0
    Width = 359
    Height = 99
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object GroupBox1: TGroupBox
      Left = 16
      Top = 16
      Width = 329
      Height = 73
      Caption = ' Adres strony z kursami walut NBP '
      TabOrder = 0
      object EditName: TEdit
        Left = 24
        Top = 28
        Width = 281
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 0
        Text = 'http://www.nbp.org.pl/Kursy/KursyA.html'
      end
    end
  end
  object PanelButtons: TPanel
    Left = 0
    Top = 99
    Width = 359
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      359
      41)
    object BitBtnOk: TBitBtn
      Left = 182
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Default = True
      TabOrder = 0
      OnClick = BitBtnOkClick
    end
    object BitBtnCancel: TBitBtn
      Left = 270
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Anuluj'
      TabOrder = 1
      OnClick = BitBtnCancelClick
    end
  end
end
