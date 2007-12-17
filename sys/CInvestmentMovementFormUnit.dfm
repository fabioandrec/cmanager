inherited CInvestmentMovementForm: TCInvestmentMovementForm
  Left = 324
  Top = 58
  Caption = 'CInvestmentMovementForm'
  ClientHeight = 660
  ClientWidth = 554
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 554
    Height = 619
    object GroupBox1: TGroupBox
      Left = 16
      Top = 16
      Width = 521
      Height = 65
      Caption = ' Dane podstawowe '
      TabOrder = 0
      object Label5: TLabel
        Left = 263
        Top = 28
        Width = 33
        Height = 13
        Alignment = taRightJustify
        Caption = 'Rodzaj'
      end
      object Label3: TLabel
        Left = 35
        Top = 28
        Width = 53
        Height = 13
        Alignment = taRightJustify
        Caption = 'Data i czas'
      end
      object ComboBoxType: TComboBox
        Left = 304
        Top = 24
        Width = 193
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 0
        Text = 'Zakup'
        OnChange = ComboBoxTypeChange
        Items.Strings = (
          'Zakup'
          'Sprzeda'#380)
      end
      object CDateTime: TCDateTime
        Left = 96
        Top = 24
        Width = 145
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz dat'#281'  i czas>'
        Color = clWindow
        ParentColor = False
        TabOrder = 1
        TabStop = True
        Transparent = False
        HotTrack = True
        Withtime = True
      end
    end
    object GroupBox2: TGroupBox
      Left = 16
      Top = 440
      Width = 521
      Height = 169
      Caption = ' Opis '
      TabOrder = 2
      object CButton1: TCButton
        Left = 254
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
        Left = 372
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
      object RichEditDesc: TCRichedit
        Left = 24
        Top = 28
        Width = 473
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
    object GroupBox3: TGroupBox
      Left = 16
      Top = 96
      Width = 521
      Height = 329
      Caption = ' Szczeg'#243#322'y operacji '
      TabOrder = 1
      object Label4: TLabel
        Left = 36
        Top = 177
        Width = 76
        Height = 13
        Alignment = taRightJustify
        Caption = 'Konto inwestycji'
      end
      object Label1: TLabel
        Left = 39
        Top = 33
        Width = 49
        Height = 13
        Alignment = taRightJustify
        Caption = 'Instrument'
      end
      object Label15: TLabel
        Left = 322
        Top = 69
        Width = 22
        Height = 13
        Alignment = taRightJustify
        Caption = 'Ilo'#347#263
      end
      object Label2: TLabel
        Left = 14
        Top = 69
        Width = 74
        Height = 13
        Alignment = taRightJustify
        Caption = 'W/g notowania'
      end
      object Label6: TLabel
        Left = 274
        Top = 105
        Width = 71
        Height = 13
        Alignment = taRightJustify
        Caption = 'Warto'#347#263' jednej'
      end
      object Label9: TLabel
        Left = 250
        Top = 141
        Width = 94
        Height = 13
        Alignment = taRightJustify
        Caption = 'Warto'#347#263' wszystkich'
      end
      object Label8: TLabel
        Left = 19
        Top = 289
        Width = 93
        Height = 13
        Alignment = taRightJustify
        Caption = 'Kategoria inwestycji'
      end
      object Label20: TLabel
        Left = 266
        Top = 32
        Width = 78
        Height = 13
        Alignment = taRightJustify
        Caption = 'Waluta notowa'#324
      end
      object Label22: TLabel
        Left = 62
        Top = 213
        Width = 50
        Height = 13
        Alignment = taRightJustify
        Caption = 'Przelicznik'
      end
      object Label17: TLabel
        Left = 48
        Top = 248
        Width = 64
        Height = 13
        Alignment = taRightJustify
        Caption = 'Waluta konta'
      end
      object Label21: TLabel
        Left = 264
        Top = 249
        Width = 80
        Height = 13
        Alignment = taRightJustify
        Caption = 'W walucie konta'
      end
      object CStaticAccount: TCStatic
        Left = 120
        Top = 173
        Width = 377
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz konto z listy>'
        Color = clWindow
        ParentColor = False
        TabOrder = 6
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz konto z listy>'
        OnGetDataId = CStaticAccountGetDataId
        OnChanged = CStaticAccountChanged
        HotTrack = True
      end
      object CStaticInstrument: TCStatic
        Left = 96
        Top = 29
        Width = 145
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz z listy>'
        Color = clWindow
        ParentColor = False
        TabOrder = 0
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz z listy>'
        OnGetDataId = CStaticInstrumentGetDataId
        OnChanged = CStaticInstrumentChanged
        HotTrack = True
      end
      object CCurrEditQuantity: TCCurrEdit
        Tag = 1
        Left = 352
        Top = 65
        Width = 145
        Height = 21
        BorderStyle = bsNone
        TabOrder = 3
        OnChange = CCurrEditQuantityChange
        Decimals = 2
        ThousandSep = True
        BevelKind = bkTile
        WithCalculator = True
      end
      object CStaticInstrumentValue: TCStatic
        Left = 96
        Top = 65
        Width = 145
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz z listy>'
        Color = clWindow
        ParentColor = False
        TabOrder = 2
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz z listy>'
        OnGetDataId = CStaticInstrumentValueGetDataId
        OnChanged = CStaticInstrumentValueChanged
        HotTrack = True
      end
      object CCurrEditValue: TCCurrEdit
        Tag = 1
        Left = 352
        Top = 101
        Width = 145
        Height = 21
        BorderStyle = bsNone
        TabOrder = 4
        OnChange = CCurrEditValueChange
        Decimals = 4
        ThousandSep = True
        CurrencyStr = 'z'#322
        BevelKind = bkTile
        WithCalculator = True
      end
      object CCurrMovement: TCCurrEdit
        Left = 352
        Top = 137
        Width = 145
        Height = 21
        BorderStyle = bsNone
        Enabled = False
        TabOrder = 5
        Decimals = 2
        ThousandSep = True
        CurrencyStr = 'z'#322
        BevelKind = bkTile
        WithCalculator = True
      end
      object CStaticCategory: TCStatic
        Left = 120
        Top = 285
        Width = 377
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz kategori'#281' z listy>'
        Color = clWindow
        ParentColor = False
        TabOrder = 10
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz kategori'#281' z listy>'
        OnGetDataId = CStaticCategoryGetDataId
        HotTrack = True
      end
      object CStaticInstrumentCurrency: TCStatic
        Left = 352
        Top = 29
        Width = 145
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<brak instrumentu>'
        Color = clWindow
        Enabled = False
        ParentColor = False
        TabOrder = 1
        TabStop = True
        Transparent = False
        TextOnEmpty = '<brak instrumentu>'
        HotTrack = True
      end
      object CStaticCurrencyRate: TCStatic
        Left = 120
        Top = 209
        Width = 377
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz przelicznik kursu z listy>'
        Color = clWindow
        ParentColor = False
        TabOrder = 7
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz przelicznik kursu z listy>'
        OnGetDataId = CStaticCurrencyRateGetDataId
        OnChanged = CStaticCurrencyRateChanged
        HotTrack = True
      end
      object CStaticAccountCurrency: TCStatic
        Left = 120
        Top = 245
        Width = 121
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<brak konta>'
        Color = clWindow
        Enabled = False
        ParentColor = False
        TabOrder = 8
        TabStop = True
        Transparent = False
        TextOnEmpty = '<brak konta>'
        HotTrack = False
      end
      object CCurrEditAccount: TCCurrEdit
        Left = 352
        Top = 245
        Width = 145
        Height = 21
        BorderStyle = bsNone
        Enabled = False
        TabOrder = 9
        Decimals = 2
        ThousandSep = True
        CurrencyStr = 'z'#322
        BevelKind = bkTile
        WithCalculator = True
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 619
    Width = 554
    inherited BitBtnOk: TBitBtn
      Left = 377
    end
    inherited BitBtnCancel: TBitBtn
      Left = 465
    end
  end
  object ActionManager: TActionManager
    Images = CImageLists.TemplateImageList16x16
    Left = 32
    Top = 184
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
