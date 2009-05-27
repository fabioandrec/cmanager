inherited CDepositInvestmentForm: TCDepositInvestmentForm
  Left = 295
  Top = 117
  Caption = 'Lokata'
  ClientHeight = 728
  ClientWidth = 627
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TCPanel
    Width = 627
    Height = 687
    object GroupBox1: TGroupBox
      Left = 16
      Top = 16
      Width = 593
      Height = 101
      Caption = ' Dane podstawowe '
      TabOrder = 0
      object Label3: TLabel
        Left = 43
        Top = 28
        Width = 77
        Height = 13
        Alignment = taRightJustify
        Caption = 'Data utworzenia'
      end
      object Label2: TLabel
        Left = 56
        Top = 64
        Width = 64
        Height = 13
        Alignment = taRightJustify
        Caption = 'Nazwa lokaty'
      end
      object Label12: TLabel
        Left = 253
        Top = 28
        Width = 75
        Height = 13
        Alignment = taRightJustify
        Caption = 'Tryb utworzenia'
      end
      object LabelState: TLabel
        Left = 275
        Top = 28
        Width = 53
        Height = 13
        Alignment = taRightJustify
        Caption = 'Stan lokaty'
      end
      object CDateTime: TCDateTime
        Left = 128
        Top = 24
        Width = 89
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz dat'#281' >'
        Color = clWindow
        ParentColor = False
        TabOrder = 0
        TabStop = True
        Transparent = False
        OnChanged = CDateTimeChanged
        HotTrack = True
        Withtime = False
      end
      object EditName: TEdit
        Left = 128
        Top = 60
        Width = 441
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 40
        TabOrder = 2
        OnChange = EditNameChange
      end
      object ComboBoxType: TComboBox
        Left = 336
        Top = 24
        Width = 233
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 1
        Text = 'Za'#322'o'#380'enie lokaty'
        OnChange = ComboBoxTypeChange
        Items.Strings = (
          'Za'#322'o'#380'enie lokaty'
          'Rejestracja lokaty')
      end
      object ComboBoxDepositState: TComboBox
        Left = 336
        Top = 24
        Width = 233
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        Enabled = False
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 3
        Text = 'Aktywna'
        OnChange = ComboBoxTypeChange
        Items.Strings = (
          'Aktywna'
          'Nieaktywna'
          'Zlikwidowana')
      end
    end
    object GroupBox2: TGroupBox
      Left = 16
      Top = 536
      Width = 593
      Height = 145
      Caption = ' Opis '
      TabOrder = 2
      object CButton1: TCButton
        Left = 326
        Top = 102
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
        Left = 444
        Top = 102
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
        Width = 545
        Height = 61
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 0
      end
      object ComboBoxTemplate: TComboBox
        Left = 24
        Top = 104
        Width = 97
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 1
        TabOrder = 1
        Text = 'W/g szablonu'
        OnChange = ComboBoxTemplateChange
        Items.Strings = (
          'W'#322'asny'
          'W/g szablonu')
      end
    end
    object GroupBox3: TGroupBox
      Left = 16
      Top = 132
      Width = 593
      Height = 389
      Caption = ' Szczeg'#243#322'y lokaty '
      Color = clBtnFace
      ParentColor = False
      TabOrder = 1
      object Label1: TLabel
        Left = 30
        Top = 28
        Width = 90
        Height = 13
        Alignment = taRightJustify
        Caption = 'Prowadz'#261'cy lokat'#281
      end
      object Label10: TLabel
        Left = 86
        Top = 63
        Width = 34
        Height = 13
        Alignment = taRightJustify
        Caption = 'Waluta'
      end
      object Label4: TLabel
        Left = 42
        Top = 100
        Width = 78
        Height = 13
        Alignment = taRightJustify
        Caption = 'Oprocentowanie'
      end
      object Label6: TLabel
        Left = 29
        Top = 136
        Width = 91
        Height = 13
        Alignment = taRightJustify
        Caption = 'Czas trwania lokaty'
      end
      object Label7: TLabel
        Left = 324
        Top = 136
        Width = 76
        Height = 13
        Alignment = taRightJustify
        Caption = 'Po zako'#324'czeniu'
      end
      object Label8: TLabel
        Left = 46
        Top = 172
        Width = 74
        Height = 13
        Alignment = taRightJustify
        Caption = 'Naliczaj odsetki'
      end
      object Label9: TLabel
        Left = 107
        Top = 208
        Width = 13
        Height = 13
        Alignment = taRightJustify
        Caption = 'Co'
      end
      object Label11: TLabel
        Left = 337
        Top = 208
        Width = 63
        Height = 13
        Alignment = taRightJustify
        Caption = 'Po naliczeniu'
      end
      object Label15: TLabel
        Left = 335
        Top = 64
        Width = 65
        Height = 13
        Alignment = taRightJustify
        Caption = 'Kapita'#322' lokaty'
      end
      object Label5: TLabel
        Left = 44
        Top = 244
        Width = 76
        Height = 13
        Alignment = taRightJustify
        Caption = 'Prognoza lokaty'
      end
      object Label14: TLabel
        Left = 52
        Top = 280
        Width = 68
        Height = 13
        Alignment = taRightJustify
        Caption = 'Konto operacji'
      end
      object Label17: TLabel
        Left = 336
        Top = 281
        Width = 64
        Height = 13
        Alignment = taRightJustify
        Caption = 'Waluta konta'
      end
      object Label22: TLabel
        Left = 70
        Top = 317
        Width = 50
        Height = 13
        Alignment = taRightJustify
        Caption = 'Przelicznik'
      end
      object Label21: TLabel
        Left = 320
        Top = 317
        Width = 80
        Height = 13
        Alignment = taRightJustify
        Caption = 'W walucie konta'
      end
      object Label13: TLabel
        Left = 75
        Top = 353
        Width = 45
        Height = 13
        Alignment = taRightJustify
        Caption = 'Kategoria'
      end
      object Label16: TLabel
        Left = 332
        Top = 100
        Width = 68
        Height = 13
        Alignment = taRightJustify
        Caption = 'Wolne odsetki'
      end
      object CStaticCashpoint: TCStatic
        Left = 128
        Top = 24
        Width = 441
        Height = 21
        Cursor = crHandPoint
        Hint = '<wybierz kontrahenta z listy>'
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz kontrahenta z listy>'
        Color = clWindow
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz kontrahenta z listy>'
        OnGetDataId = CStaticCashpointGetDataId
        OnChanged = CStaticCashpointChanged
        HotTrack = True
      end
      object CStaticCurrency: TCStatic
        Left = 128
        Top = 60
        Width = 161
        Height = 21
        Cursor = crHandPoint
        Hint = '<wybierz walut'#281'>'
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz walut'#281'>'
        Color = clWindow
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz walut'#281'>'
        OnGetDataId = CStaticCurrencyGetDataId
        OnChanged = CStaticCurrencyChanged
        HotTrack = True
      end
      object CCurrEditRate: TCCurrEdit
        Left = 128
        Top = 96
        Width = 161
        Height = 21
        BorderStyle = bsNone
        TabOrder = 3
        OnChange = CCurrEditRateChange
        Decimals = 4
        ThousandSep = True
        CurrencyStr = '%'
        BevelKind = bkTile
        WithCalculator = True
      end
      object CIntEditPeriodCount: TCIntEdit
        Left = 128
        Top = 132
        Width = 57
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 4
        TabOrder = 5
        Text = '1'
        OnChange = CIntEditPeriodCountChange
      end
      object ComboBoxPeriodType: TComboBox
        Left = 200
        Top = 132
        Width = 105
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 2
        TabOrder = 6
        Text = 'miesi'#281'cy'
        OnChange = ComboBoxPeriodTypeChange
        Items.Strings = (
          'dni'
          'tygodni'
          'miesi'#281'cy'
          'lat')
      end
      object ComboBoxPeriodAction: TComboBox
        Left = 408
        Top = 132
        Width = 161
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 7
        Text = 'zmie'#324' status na nieaktywna'
        Items.Strings = (
          'zmie'#324' status na nieaktywna'
          'automatycznie odn'#243'w lokat'#281)
      end
      object ComboBoxDueMode: TComboBox
        Left = 128
        Top = 168
        Width = 441
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 8
        Text = 'jednorazowo, po zako'#324'czeniu czasu trwania lokaty'
        OnChange = ComboBoxDueModeChange
        Items.Strings = (
          'jednorazowo, po zako'#324'czeniu czasu trwania lokaty'
          'wielokrotnie, co wskazany okres czasu')
      end
      object CIntEditDueCount: TCIntEdit
        Left = 128
        Top = 204
        Width = 57
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 4
        TabOrder = 9
        Text = '1'
        OnChange = CIntEditDueCountChange
      end
      object ComboBoxDueType: TComboBox
        Left = 200
        Top = 204
        Width = 97
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 2
        TabOrder = 10
        Text = 'miesi'#281'cy'
        OnChange = ComboBoxDueTypeChange
        Items.Strings = (
          'dni'
          'tygodni'
          'miesi'#281'cy'
          'lat')
      end
      object ComboBoxDueAction: TComboBox
        Left = 408
        Top = 204
        Width = 161
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 11
        Text = 'dopisz odsetki do kapita'#322'u'
        Items.Strings = (
          'dopisz odsetki do kapita'#322'u'
          'pozostaw do wyp'#322'aty')
      end
      object CCurrEditActualCash: TCCurrEdit
        Left = 408
        Top = 60
        Width = 161
        Height = 21
        BorderStyle = bsNone
        TabOrder = 2
        OnChange = CCurrEditActualCashChange
        Decimals = 2
        ThousandSep = True
        CurrencyStr = 'z'#322
        BevelKind = bkTile
        WithCalculator = True
      end
      object CStaticFuture: TCStatic
        Left = 128
        Top = 240
        Width = 441
        Height = 21
        Cursor = crHandPoint
        Hint = '<kliknij tu aby obejrze'#263' informacje o lokacie>'
        AutoSize = False
        BevelKind = bkTile
        Caption = '<kliknij tu aby obejrze'#263' informacje o lokacie>'
        Color = clWindow
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 12
        TabStop = True
        Transparent = False
        TextOnEmpty = '<kliknij tu aby obejrze'#263' informacje o lokacie>'
        OnGetDataId = CStaticFutureGetDataId
        HotTrack = True
      end
      object CStaticAccount: TCStatic
        Left = 128
        Top = 276
        Width = 169
        Height = 21
        Cursor = crHandPoint
        Hint = '<wybierz konto z listy>'
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz konto z listy>'
        Color = clWindow
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 13
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz konto z listy>'
        OnGetDataId = CStaticAccountGetDataId
        OnChanged = CStaticAccountChanged
        HotTrack = True
      end
      object CStaticAccountCurrency: TCStatic
        Left = 408
        Top = 277
        Width = 161
        Height = 21
        Hint = '<brak konta>'
        AutoSize = False
        BevelKind = bkTile
        Caption = '<brak konta>'
        Color = clWindow
        Enabled = False
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 14
        TabStop = True
        Transparent = False
        TextOnEmpty = '<brak konta>'
        HotTrack = False
      end
      object CStaticCurrencyRate: TCStatic
        Left = 128
        Top = 313
        Width = 169
        Height = 21
        Cursor = crHandPoint
        Hint = '<wybierz przelicznik kursu z listy>'
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz przelicznik kursu z listy>'
        Color = clWindow
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 15
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz przelicznik kursu z listy>'
        OnGetDataId = CStaticCurrencyRateGetDataId
        OnChanged = CStaticCurrencyRateChanged
        HotTrack = True
      end
      object CCurrEditAccount: TCCurrEdit
        Left = 408
        Top = 313
        Width = 161
        Height = 21
        BorderStyle = bsNone
        Enabled = False
        TabOrder = 16
        Decimals = 2
        ThousandSep = True
        CurrencyStr = 'z'#322
        BevelKind = bkTile
        WithCalculator = True
      end
      object CStaticCategory: TCStatic
        Left = 128
        Top = 349
        Width = 441
        Height = 21
        Cursor = crHandPoint
        Hint = '<wybierz kategori'#281' z listy>'
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz kategori'#281' z listy>'
        Color = clWindow
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 17
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz kategori'#281' z listy>'
        OnGetDataId = CStaticCategoryGetDataId
        OnChanged = CStaticCategoryChanged
        HotTrack = True
      end
      object CCurrEditNoncapitalized: TCCurrEdit
        Left = 408
        Top = 96
        Width = 161
        Height = 21
        BorderStyle = bsNone
        TabOrder = 4
        OnChange = CCurrEditActualCashChange
        Decimals = 2
        ThousandSep = True
        CurrencyStr = 'z'#322
        BevelKind = bkTile
        WithCalculator = True
      end
    end
  end
  inherited PanelButtons: TCPanel
    Top = 687
    Width = 627
    inherited BitBtnOk: TBitBtn
      Left = 450
    end
    inherited BitBtnCancel: TBitBtn
      Left = 538
    end
  end
  object ActionManager: TActionManager
    Images = CImageLists.TemplateImageList16x16
    Left = 48
    Top = 256
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