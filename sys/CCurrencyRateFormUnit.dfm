inherited CCurrencyRateForm: TCCurrencyRateForm
  Left = 243
  Top = 135
  Caption = 'Kurs waluty'
  ClientHeight = 386
  ClientWidth = 522
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 522
    Height = 345
    object GroupBox4: TGroupBox
      Left = 16
      Top = 16
      Width = 489
      Height = 65
      Caption = ' Dane podstawowe '
      TabOrder = 0
      object Label15: TLabel
        Left = 139
        Top = 28
        Width = 37
        Height = 13
        Alignment = taRightJustify
        Caption = 'dla dnia'
      end
      object Label2: TLabel
        Left = 290
        Top = 29
        Width = 19
        Height = 13
        Alignment = taRightJustify
        Caption = 'w/g'
      end
      object Label3: TLabel
        Left = 20
        Top = 28
        Width = 21
        Height = 13
        Caption = 'Kurs'
      end
      object CDateTime: TCDateTime
        Left = 184
        Top = 24
        Width = 89
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz dat'#281'>'
        Color = clWindow
        ParentColor = False
        TabOrder = 1
        TabStop = True
        Transparent = False
        OnChanged = CDateTimeChanged
        HotTrack = True
      end
      object CStaticCashpoint: TCStatic
        Left = 317
        Top = 25
        Width = 148
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz kontrahenta z listy>'
        Color = clWindow
        ParentColor = False
        TabOrder = 2
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz kontrahenta z listy>'
        OnGetDataId = CStaticCashpointGetDataId
        OnChanged = CStaticCashpointChanged
        HotTrack = True
      end
      object ComboBoxType: TComboBox
        Left = 48
        Top = 24
        Width = 81
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 0
        Text = #347'redni'
        OnChange = ComboBoxTypeChange
        Items.Strings = (
          #347'redni'
          'kupna'
          'sprzeda'#380'y')
      end
    end
    object GroupBox1: TGroupBox
      Left = 16
      Top = 92
      Width = 489
      Height = 65
      Caption = ' Przelicznik '
      TabOrder = 1
      object Label1: TLabel
        Left = 230
        Top = 28
        Width = 39
        Height = 13
        Alignment = taRightJustify
        Caption = 'kosztuje'
      end
      object CIntQuantity: TCIntEdit
        Left = 24
        Top = 24
        Width = 65
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 0
        Text = '1'
        OnChange = CIntQuantityChange
      end
      object CStaticBaseCurrencydef: TCStatic
        Left = 101
        Top = 24
        Width = 116
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz walut'#281'>'
        Color = clWindow
        ParentColor = False
        TabOrder = 1
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz walut'#281'>'
        OnGetDataId = CStaticBaseCurrencydefGetDataId
        OnChanged = CStaticBaseCurrencydefChanged
        HotTrack = True
      end
      object CStaticTargetCurrencydef: TCStatic
        Left = 353
        Top = 24
        Width = 112
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
        OnGetDataId = CStaticTargetCurrencydefGetDataId
        OnChanged = CStaticTargetCurrencydefChanged
        HotTrack = True
      end
      object CCurrRate: TCCurrEdit
        Left = 277
        Top = 24
        Width = 64
        Height = 21
        BorderStyle = bsNone
        TabOrder = 2
        OnChange = CCurrRateChange
        Decimals = 4
        ThousandSep = True
        CurrencyStr = 'z'#322
        BevelKind = bkTile
      end
    end
    object GroupBox2: TGroupBox
      Left = 16
      Top = 169
      Width = 489
      Height = 169
      Caption = ' Opis '
      TabOrder = 2
      object CButton1: TCButton
        Left = 222
        Top = 126
        Width = 115
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
        Left = 340
        Top = 126
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
        Width = 441
        Height = 89
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 0
      end
      object ComboBoxTemplate: TComboBox
        Left = 24
        Top = 128
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
  end
  inherited PanelButtons: TPanel
    Top = 345
    Width = 522
    inherited BitBtnOk: TBitBtn
      Left = 345
    end
    inherited BitBtnCancel: TBitBtn
      Left = 433
    end
  end
  object ActionManager: TActionManager
    Images = CImageLists.TemplateImageList16x16
    Left = 144
    Top = 293
    StyleName = 'XP Style'
    object ActionAdd: TAction
      Caption = 'Wstaw mnemonik'
      ImageIndex = 0
      OnExecute = ActionAddExecute
    end
    object ActionTemplate: TAction
      Caption = 'Konfiguruj szablony'
      ImageIndex = 1
      OnExecute = ActionTemplateExecute
    end
  end
end
