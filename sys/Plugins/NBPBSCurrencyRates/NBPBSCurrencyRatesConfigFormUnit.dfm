object NBPBSCurrencyRatesConfigForm: TNBPBSCurrencyRatesConfigForm
  Left = 349
  Top = 251
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Konfiguracja'
  ClientHeight = 226
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
    Height = 185
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object GroupBox1: TGroupBox
      Left = 16
      Top = 104
      Width = 329
      Height = 73
      Caption = ' Adres strony z kursami walut NBP '
      TabOrder = 1
      object EditName: TEdit
        Left = 24
        Top = 28
        Width = 281
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 0
        Text = 'http://www.nbp.org.pl/Kursy/KursyC.html'
      end
    end
    object GroupBox2: TGroupBox
      Left = 16
      Top = 16
      Width = 329
      Height = 73
      Caption = ' '#377'r'#243'd'#322'o tabel '
      TabOrder = 0
      object ComboBoxSource: TComboBox
        Left = 24
        Top = 32
        Width = 281
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 0
        Text = 'Strona z kursami NBP'
        OnChange = ComboBoxSourceChange
        Items.Strings = (
          'Strona z kursami NBP'
          'Wskazany plik lokalny')
      end
    end
  end
  object PanelButtons: TPanel
    Left = 0
    Top = 185
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
