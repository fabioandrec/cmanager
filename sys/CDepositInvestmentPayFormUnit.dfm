inherited CDepositInvestmentPayForm: TCDepositInvestmentPayForm
  Left = 273
  Top = 62
  Caption = 'CDepositInvestmentPayForm'
  ClientHeight = 636
  ClientWidth = 626
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 626
    Height = 595
    object GroupBox1: TGroupBox
      Left = 16
      Top = 16
      Width = 593
      Height = 137
      Caption = ' Dane podstawowe '
      TabOrder = 0
      object Label3: TLabel
        Left = 57
        Top = 64
        Width = 63
        Height = 13
        Alignment = taRightJustify
        Caption = 'Data operacji'
      end
      object Label2: TLabel
        Left = 87
        Top = 28
        Width = 33
        Height = 13
        Alignment = taRightJustify
        Caption = 'Lokata'
      end
      object Label12: TLabel
        Left = 255
        Top = 64
        Width = 73
        Height = 13
        Alignment = taRightJustify
        Caption = 'Rodzaj operacji'
      end
      object Label7: TLabel
        Left = 263
        Top = 100
        Width = 65
        Height = 13
        Alignment = taRightJustify
        Caption = 'Waluta lokaty'
      end
      object CDateTime: TCDateTime
        Left = 128
        Top = 60
        Width = 89
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz dat'#281' >'
        Color = clWindow
        ParentColor = False
        TabOrder = 1
        TabStop = True
        Transparent = False
        HotTrack = True
        Withtime = False
      end
      object ComboBoxType: TComboBox
        Left = 336
        Top = 60
        Width = 233
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 2
        Text = 'Dop'#322'ata do lokaty'
        OnChange = ComboBoxTypeChange
        Items.Strings = (
          'Dop'#322'ata do lokaty'
          'Likwidacja lokaty'
          'Wyp'#322'ata odsetek')
      end
      object CStaticDeposit: TCStatic
        Left = 128
        Top = 24
        Width = 441
        Height = 21
        Cursor = crHandPoint
        Hint = '<wybierz lokat'#281' z listy>'
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz lokat'#281' z listy>'
        Color = clWindow
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz lokat'#281' z listy>'
        OnGetDataId = CStaticDepositGetDataId
        OnChanged = CStaticDepositChanged
        HotTrack = True
      end
      object CStaticDepositCurrency: TCStatic
        Left = 336
        Top = 96
        Width = 233
        Height = 21
        Hint = '<brak lokaty>'
        AutoSize = False
        BevelKind = bkTile
        Caption = '<brak lokaty>'
        Color = clWindow
        Enabled = False
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        TabStop = True
        Transparent = False
        TextOnEmpty = '<brak lokaty>'
        HotTrack = False
      end
    end
    object GroupBox2: TGroupBox
      Left = 16
      Top = 444
      Width = 593
      Height = 145
      Caption = ' Opis '
      TabOrder = 1
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
        Items.Strings = (
          'W'#322'asny'
          'W/g szablonu')
      end
    end
    object GroupBox3: TGroupBox
      Left = 16
      Top = 172
      Width = 593
      Height = 253
      Caption = ' Szczeg'#243#322'y operacji '
      Color = clBtnFace
      ParentColor = False
      TabOrder = 2
      object Label14: TLabel
        Left = 52
        Top = 142
        Width = 68
        Height = 13
        Alignment = taRightJustify
        Caption = 'Konto operacji'
      end
      object Label17: TLabel
        Left = 336
        Top = 143
        Width = 64
        Height = 13
        Alignment = taRightJustify
        Caption = 'Waluta konta'
      end
      object Label22: TLabel
        Left = 70
        Top = 179
        Width = 50
        Height = 13
        Alignment = taRightJustify
        Caption = 'Przelicznik'
      end
      object Label21: TLabel
        Left = 320
        Top = 179
        Width = 80
        Height = 13
        Alignment = taRightJustify
        Caption = 'W walucie konta'
      end
      object Label13: TLabel
        Left = 75
        Top = 215
        Width = 45
        Height = 13
        Alignment = taRightJustify
        Caption = 'Kategoria'
      end
      object Label15: TLabel
        Left = 55
        Top = 32
        Width = 65
        Height = 13
        Alignment = taRightJustify
        Caption = 'Kapita'#322' lokaty'
      end
      object Label1: TLabel
        Left = 332
        Top = 32
        Width = 68
        Height = 13
        Alignment = taRightJustify
        Caption = 'Wolne odsetki'
      end
      object Label4: TLabel
        Left = 330
        Top = 69
        Width = 70
        Height = 13
        Alignment = taRightJustify
        Caption = 'Kwota operacji'
      end
      object Label5: TLabel
        Left = 40
        Top = 106
        Width = 80
        Height = 13
        Alignment = taRightJustify
        Caption = 'Kapita'#322' lokaty po'
      end
      object Label6: TLabel
        Left = 317
        Top = 106
        Width = 83
        Height = 13
        Alignment = taRightJustify
        Caption = 'Wolne odsetki po'
      end
      object CStaticAccount: TCStatic
        Left = 128
        Top = 138
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
        TabOrder = 5
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz konto z listy>'
        OnGetDataId = CStaticAccountGetDataId
        OnChanged = CStaticAccountChanged
        HotTrack = True
      end
      object CStaticAccountCurrency: TCStatic
        Left = 408
        Top = 139
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
        TabOrder = 6
        TabStop = True
        Transparent = False
        TextOnEmpty = '<brak konta>'
        HotTrack = False
      end
      object CStaticCurrencyRate: TCStatic
        Left = 128
        Top = 175
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
        TabOrder = 7
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz przelicznik kursu z listy>'
        OnGetDataId = CStaticCurrencyRateGetDataId
        OnChanged = CStaticCurrencyRateChanged
        HotTrack = True
      end
      object CCurrEditAccount: TCCurrEdit
        Left = 408
        Top = 175
        Width = 161
        Height = 21
        BorderStyle = bsNone
        Enabled = False
        TabOrder = 8
        Decimals = 2
        ThousandSep = True
        CurrencyStr = 'z'#322
        BevelKind = bkTile
        WithCalculator = True
      end
      object CStaticCategory: TCStatic
        Left = 128
        Top = 211
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
        TabOrder = 9
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz kategori'#281' z listy>'
        OnGetDataId = CStaticCategoryGetDataId
        OnChanged = CStaticCategoryChanged
        HotTrack = True
      end
      object CCurrEditBeforeCap: TCCurrEdit
        Left = 128
        Top = 28
        Width = 169
        Height = 21
        BorderStyle = bsNone
        Enabled = False
        TabOrder = 0
        Decimals = 2
        ThousandSep = True
        CurrencyStr = 'z'#322
        BevelKind = bkTile
        WithCalculator = True
      end
      object CCurrEditBeforeInt: TCCurrEdit
        Left = 408
        Top = 28
        Width = 161
        Height = 21
        BorderStyle = bsNone
        Enabled = False
        TabOrder = 1
        Decimals = 2
        ThousandSep = True
        CurrencyStr = 'z'#322
        BevelKind = bkTile
        WithCalculator = True
      end
      object CCurrEditCash: TCCurrEdit
        Left = 408
        Top = 65
        Width = 161
        Height = 21
        BorderStyle = bsNone
        TabOrder = 2
        OnChange = CCurrEditCashChange
        Decimals = 2
        ThousandSep = True
        CurrencyStr = 'z'#322
        BevelKind = bkTile
        WithCalculator = True
      end
      object CCurrEditAfterCap: TCCurrEdit
        Left = 128
        Top = 102
        Width = 169
        Height = 21
        BorderStyle = bsNone
        Enabled = False
        TabOrder = 3
        Decimals = 2
        ThousandSep = True
        CurrencyStr = 'z'#322
        BevelKind = bkTile
        WithCalculator = True
      end
      object CCurrEditAfterInt: TCCurrEdit
        Left = 408
        Top = 102
        Width = 161
        Height = 21
        BorderStyle = bsNone
        Enabled = False
        TabOrder = 4
        Decimals = 2
        ThousandSep = True
        CurrencyStr = 'z'#322
        BevelKind = bkTile
        WithCalculator = True
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 595
    Width = 626
    inherited BitBtnOk: TBitBtn
      Left = 449
    end
    inherited BitBtnCancel: TBitBtn
      Left = 537
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
