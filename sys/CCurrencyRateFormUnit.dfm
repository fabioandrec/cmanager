inherited CCurrencyRateForm: TCCurrencyRateForm
  Caption = 'Kurs waluty'
  ClientHeight = 470
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Height = 429
    object GroupBox4: TGroupBox
      Left = 16
      Top = 16
      Width = 473
      Height = 65
      Caption = ' Dane podstawowe '
      TabOrder = 0
      object Label15: TLabel
        Left = 19
        Top = 28
        Width = 61
        Height = 13
        Alignment = taRightJustify
        Caption = 'Kurs dla dnia'
      end
      object Label2: TLabel
        Left = 186
        Top = 29
        Width = 19
        Height = 13
        Alignment = taRightJustify
        Caption = 'w/g'
      end
      object CDateTime1: TCDateTime
        Left = 88
        Top = 24
        Width = 89
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz dat'#281'>'
        Color = clWindow
        ParentColor = False
        TabOrder = 0
        TabStop = True
        Transparent = False
        HotTrack = True
      end
      object CStaticInoutOnceCashpoint: TCStatic
        Left = 213
        Top = 25
        Width = 233
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz kontrahenta z listy>'
        Color = clWindow
        ParentColor = False
        TabOrder = 1
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz kontrahenta z listy>'
        HotTrack = True
      end
    end
    object GroupBox2: TGroupBox
      Left = 16
      Top = 260
      Width = 505
      Height = 136
      Caption = ' Opis '
      TabOrder = 1
      object CButton1: TCButton
        Left = 238
        Top = 97
        Width = 123
        Height = 25
        Cursor = crHandPoint
        PicPosition = ppLeft
        PicOffset = 10
        TxtOffset = 15
        Framed = False
        Action = ActionAdd
        Color = clBtnFace
      end
      object CButton2: TCButton
        Left = 356
        Top = 97
        Width = 129
        Height = 25
        Cursor = crHandPoint
        PicPosition = ppLeft
        PicOffset = 10
        TxtOffset = 15
        Framed = False
        Action = ActionTemplate
        Color = clBtnFace
      end
      object RichEditDesc: TRichEdit
        Left = 24
        Top = 28
        Width = 457
        Height = 61
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 0
      end
      object ComboBoxTemplate: TComboBox
        Left = 24
        Top = 99
        Width = 97
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 1
        TabOrder = 1
        Text = 'W/g szablonu'
        Items.Strings = (
          'W'#322'asny'
          'W/g szablonu')
      end
    end
    object CIntEditTimes: TCIntEdit
      Left = 144
      Top = 181
      Width = 89
      Height = 21
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 2
      Text = '1'
    end
    object CStaticInoutOnceAccount: TCStatic
      Left = 245
      Top = 181
      Width = 89
      Height = 21
      Cursor = crHandPoint
      AutoSize = False
      BevelKind = bkTile
      Caption = '<wybierz walut'#281'>'
      Color = clWindow
      ParentColor = False
      TabOrder = 3
      TabStop = True
      Transparent = False
      TextOnEmpty = '<wybierz walut'#281'>'
      HotTrack = True
    end
    object CStatic1: TCStatic
      Left = 269
      Top = 216
      Width = 89
      Height = 21
      Cursor = crHandPoint
      AutoSize = False
      BevelKind = bkTile
      Caption = '<wybierz walut'#281'>'
      Color = clWindow
      ParentColor = False
      TabOrder = 4
      TabStop = True
      Transparent = False
      TextOnEmpty = '<wybierz walut'#281'>'
      HotTrack = True
    end
  end
  inherited PanelButtons: TPanel
    Top = 429
  end
  object ActionManager: TActionManager
    Images = CImageLists.TemplateImageList16x16
    Left = 56
    Top = 226
    StyleName = 'XP Style'
    object ActionAdd: TAction
      Caption = 'Wstaw mnemonik'
      ImageIndex = 0
    end
    object ActionTemplate: TAction
      Caption = 'Konfiguruj szablony'
      ImageIndex = 1
    end
  end
end
