inherited CMovementForm: TCMovementForm
  Left = 360
  Top = 92
  Caption = 'Operacja'
  ClientHeight = 607
  ClientWidth = 536
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TCPanel
    Width = 536
    Height = 566
    object GroupBox1: TGroupBox
      Left = 16
      Top = 16
      Width = 505
      Height = 65
      Caption = ' Dane podstawowe '
      TabOrder = 0
      object Label3: TLabel
        Left = 17
        Top = 28
        Width = 23
        Height = 13
        Alignment = taRightJustify
        Caption = 'Data'
      end
      object Label5: TLabel
        Left = 151
        Top = 28
        Width = 33
        Height = 13
        Alignment = taRightJustify
        Caption = 'Rodzaj'
      end
      object ComboBoxType: TComboBox
        Left = 192
        Top = 24
        Width = 289
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 1
        Text = 'Rozch'#243'd jednorazowy'
        OnChange = ComboBoxTypeChange
        Items.Strings = (
          'Rozch'#243'd jednorazowy'
          'Przych'#243'd jednorazowy'
          'Transfer '#347'rodk'#243'w'
          'Planowany rozch'#243'd'
          'Planowany przych'#243'd'
          'Planowany transfer '#347'rodk'#243'w')
      end
      object CDateTime: TCDateTime
        Left = 48
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
    end
    object GroupBox2: TGroupBox
      Left = 16
      Top = 392
      Width = 505
      Height = 169
      Caption = ' Opis '
      TabOrder = 2
      object CButton1: TCButton
        Left = 238
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
        Left = 356
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
        Width = 457
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
        OnChange = ComboBoxTemplateChange
        Items.Strings = (
          'W'#322'asny'
          'W/g szablonu')
      end
    end
    object GroupBox3: TGroupBox
      Left = 16
      Top = 96
      Width = 505
      Height = 281
      Caption = ' Szczeg'#243#322'y operacji '
      TabOrder = 1
      object PageControl: TPageControl
        Left = 2
        Top = 15
        Width = 501
        Height = 264
        ActivePage = TabSheetInOutCyclic
        Align = alClient
        Style = tsFlatButtons
        TabOrder = 0
        TabStop = False
        object TabSheetInOutCyclic: TTabSheet
          Caption = 'TabSheetInOutCyclic'
          TabVisible = False
          object Label16: TLabel
            Left = 354
            Top = 81
            Width = 22
            Height = 13
            Alignment = taRightJustify
            Caption = 'Ilo'#347#263
          end
          object Label11: TLabel
            Left = 61
            Top = 9
            Width = 43
            Height = 13
            Alignment = taRightJustify
            Caption = 'Operacja'
          end
          object Label14: TLabel
            Left = 36
            Top = 45
            Width = 68
            Height = 13
            Alignment = taRightJustify
            Caption = 'Konto operacji'
          end
          object Label12: TLabel
            Left = 59
            Top = 81
            Width = 45
            Height = 13
            Alignment = taRightJustify
            Caption = 'Kategoria'
          end
          object Label13: TLabel
            Left = 52
            Top = 117
            Width = 52
            Height = 13
            Alignment = taRightJustify
            Caption = 'Kontrahent'
          end
          object Label10: TLabel
            Left = 30
            Top = 152
            Width = 74
            Height = 13
            Alignment = taRightJustify
            Caption = 'Waluta operacji'
          end
          object Label18: TLabel
            Left = 306
            Top = 153
            Width = 70
            Height = 13
            Alignment = taRightJustify
            Caption = 'Kwota operacji'
          end
          object Label23: TLabel
            Left = 54
            Top = 189
            Width = 50
            Height = 13
            Alignment = taRightJustify
            Caption = 'Przelicznik'
          end
          object Label24: TLabel
            Left = 40
            Top = 224
            Width = 64
            Height = 13
            Alignment = taRightJustify
            Caption = 'Waluta konta'
          end
          object Label25: TLabel
            Left = 296
            Top = 225
            Width = 80
            Height = 13
            Alignment = taRightJustify
            Caption = 'W walucie konta'
          end
          object CButtonStateCyclic: TCButton
            Left = 366
            Top = 39
            Width = 107
            Height = 25
            Cursor = crHandPoint
            PicPosition = ppLeft
            PicOffset = 10
            TxtOffset = 15
            Framed = False
            Action = ActionStateOnceTransSource
            Color = clBtnFace
          end
          object CCurrEditCyclicQuantity: TCCurrEdit
            Tag = 1
            Left = 384
            Top = 77
            Width = 89
            Height = 21
            BorderStyle = bsNone
            TabOrder = 3
            OnChange = CCurrEditInoutOnceMovementChange
            Decimals = 2
            ThousandSep = True
            CurrencyStr = 'z'#322
            BevelKind = bkTile
            WithCalculator = True
          end
          object CStaticInoutCyclic: TCStatic
            Left = 112
            Top = 5
            Width = 361
            Height = 21
            Cursor = crHandPoint
            Hint = '<wybierz operacj'#281' z listy zaplanowanych operacji>'
            AutoSize = False
            BevelKind = bkTile
            Caption = '<wybierz operacj'#281' z listy zaplanowanych operacji>'
            Color = clWindow
            ParentColor = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            TabStop = True
            Transparent = False
            TextOnEmpty = '<wybierz operacj'#281' z listy zaplanowanych operacji>'
            OnGetDataId = CStaticInoutCyclicGetDataId
            OnChanged = CStaticInoutCyclicChanged
            HotTrack = True
          end
          object CStaticInoutCyclicAccount: TCStatic
            Left = 112
            Top = 41
            Width = 257
            Height = 21
            Cursor = crHandPoint
            Hint = '<wybierz konto>'
            AutoSize = False
            BevelKind = bkTile
            Caption = '<wybierz konto>'
            Color = clWindow
            ParentColor = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            TabStop = True
            Transparent = False
            TextOnEmpty = '<wybierz konto>'
            OnGetDataId = CStaticInoutCyclicAccountGetDataId
            OnChanged = CStaticInoutCyclicAccountChanged
            HotTrack = True
          end
          object CStaticInoutCyclicCategory: TCStatic
            Left = 112
            Top = 77
            Width = 169
            Height = 21
            Cursor = crHandPoint
            Hint = '<wybierz kategori'#281'>'
            AutoSize = False
            BevelKind = bkTile
            Caption = '<wybierz kategori'#281'>'
            Color = clWindow
            ParentColor = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            TabStop = True
            Transparent = False
            TextOnEmpty = '<wybierz kategori'#281'>'
            OnGetDataId = CStaticInoutCyclicCategoryGetDataId
            OnChanged = CStaticInoutCyclicCategoryChanged
            HotTrack = True
          end
          object CStaticInoutCyclicCashpoint: TCStatic
            Left = 112
            Top = 113
            Width = 169
            Height = 21
            Cursor = crHandPoint
            Hint = '<wybierz kontrahenta>'
            AutoSize = False
            BevelKind = bkTile
            Caption = '<wybierz kontrahenta>'
            Color = clWindow
            ParentColor = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 4
            TabStop = True
            Transparent = False
            TextOnEmpty = '<wybierz kontrahenta>'
            OnGetDataId = CStaticInoutCyclicCashpointGetDataId
            OnChanged = CStaticInoutCyclicCashpointChanged
            HotTrack = True
          end
          object CStaticInOutCyclicMovementCurrency: TCStatic
            Left = 112
            Top = 149
            Width = 169
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
            TabOrder = 5
            TabStop = True
            Transparent = False
            TextOnEmpty = '<wybierz walut'#281'>'
            OnGetDataId = CStaticInOutOnceCurrencyAccountGetDataId
            OnChanged = CStaticInOutCyclicMovementCurrencyChanged
            HotTrack = True
          end
          object CCurrEditInoutCyclicMovement: TCCurrEdit
            Left = 384
            Top = 149
            Width = 89
            Height = 21
            BorderStyle = bsNone
            TabOrder = 6
            OnChange = CCurrEditInoutCyclicMovementChange
            Decimals = 2
            ThousandSep = True
            CurrencyStr = 'z'#322
            BevelKind = bkTile
            WithCalculator = True
          end
          object CStaticInOutCyclicRate: TCStatic
            Left = 112
            Top = 185
            Width = 169
            Height = 21
            Cursor = crHandPoint
            Hint = '<wybierz przelicznik>'
            AutoSize = False
            BevelKind = bkTile
            Caption = '<wybierz przelicznik>'
            Color = clWindow
            ParentColor = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 7
            TabStop = True
            Transparent = False
            TextOnEmpty = '<wybierz przelicznik>'
            OnGetDataId = CStaticInOutCyclicRateGetDataId
            OnChanged = CStaticInOutCyclicRateChanged
            HotTrack = True
          end
          object CStaticInOutCyclicCurrencyAccount: TCStatic
            Left = 112
            Top = 221
            Width = 169
            Height = 21
            Cursor = crHandPoint
            Hint = '<brak konta>'
            AutoSize = False
            BevelKind = bkTile
            Caption = '<brak konta>'
            Color = clWindow
            Enabled = False
            ParentColor = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 8
            TabStop = True
            Transparent = False
            TextOnEmpty = '<brak konta>'
            OnGetDataId = CStaticInOutOnceCurrencyAccountGetDataId
            HotTrack = False
          end
          object CCurrEditInOutCyclicAccount: TCCurrEdit
            Left = 384
            Top = 221
            Width = 89
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
        object TabSheetTrans: TTabSheet
          Caption = 'TabSheetTrans'
          ImageIndex = 2
          TabVisible = False
          object Label6: TLabel
            Left = 29
            Top = 9
            Width = 75
            Height = 13
            Alignment = taRightJustify
            Caption = 'Konto '#378'r'#243'd'#322'owe'
          end
          object Label7: TLabel
            Left = 27
            Top = 45
            Width = 77
            Height = 13
            Alignment = taRightJustify
            Caption = 'Konto docelowe'
          end
          object Label8: TLabel
            Left = 30
            Top = 116
            Width = 74
            Height = 13
            Alignment = taRightJustify
            Caption = 'Waluta operacji'
          end
          object Label19: TLabel
            Left = 306
            Top = 117
            Width = 70
            Height = 13
            Alignment = taRightJustify
            Caption = 'Kwota operacji'
          end
          object Label26: TLabel
            Left = 54
            Top = 153
            Width = 50
            Height = 13
            Alignment = taRightJustify
            Caption = 'Przelicznik'
          end
          object Label27: TLabel
            Left = 21
            Top = 188
            Width = 83
            Height = 13
            Alignment = taRightJustify
            Caption = 'Waluta docelowa'
          end
          object Label28: TLabel
            Left = 296
            Top = 189
            Width = 80
            Height = 13
            Alignment = taRightJustify
            Caption = 'W walucie konta'
          end
          object CButtonStateOnceTransSource: TCButton
            Left = 366
            Top = 3
            Width = 107
            Height = 25
            Cursor = crHandPoint
            PicPosition = ppLeft
            PicOffset = 10
            TxtOffset = 15
            Framed = False
            Action = ActionStateOnceTransSource
            Color = clBtnFace
          end
          object CButtonStateOnceTransDest: TCButton
            Left = 366
            Top = 39
            Width = 107
            Height = 25
            Cursor = crHandPoint
            PicPosition = ppLeft
            PicOffset = 10
            TxtOffset = 15
            Framed = False
            Action = ActionStateOnceTransDest
            Color = clBtnFace
          end
          object CStaticOnceTransSourceAccount: TCStatic
            Left = 112
            Top = 5
            Width = 257
            Height = 21
            Cursor = crHandPoint
            Hint = '<wybierz konto '#378'r'#243'd'#322'owe z listy>'
            AutoSize = False
            BevelKind = bkTile
            Caption = '<wybierz konto '#378'r'#243'd'#322'owe z listy>'
            Color = clWindow
            ParentColor = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            TabStop = True
            Transparent = False
            TextOnEmpty = '<wybierz konto '#378'r'#243'd'#322'owe z listy>'
            OnGetDataId = CStaticOnceTransSourceAccountGetDataId
            OnChanged = CStaticOnceTransSourceAccountChanged
            HotTrack = True
          end
          object CStaticOnceTransDestAccount: TCStatic
            Left = 112
            Top = 41
            Width = 257
            Height = 21
            Cursor = crHandPoint
            Hint = '<wybierz konto docelowe z listy>'
            AutoSize = False
            BevelKind = bkTile
            Caption = '<wybierz konto docelowe z listy>'
            Color = clWindow
            ParentColor = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            TabStop = True
            Transparent = False
            TextOnEmpty = '<wybierz konto docelowe z listy>'
            OnGetDataId = CStaticOnceTransDestAccountGetDataId
            OnChanged = CStaticOnceTransDestAccountChanged
            HotTrack = True
          end
          object CStaticOnceTransCurrencySource: TCStatic
            Left = 112
            Top = 113
            Width = 169
            Height = 21
            Cursor = crHandPoint
            Hint = '<brak konta>'
            AutoSize = False
            BevelKind = bkTile
            Caption = '<brak konta>'
            Color = clWindow
            Enabled = False
            ParentColor = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            TabStop = True
            Transparent = False
            TextOnEmpty = '<brak konta>'
            OnGetDataId = CStaticInOutOnceCurrencyAccountGetDataId
            HotTrack = False
          end
          object CCurrEditOnceTransMovement: TCCurrEdit
            Left = 384
            Top = 113
            Width = 89
            Height = 21
            BorderStyle = bsNone
            TabOrder = 3
            OnChange = CCurrEditOnceTransMovementChange
            Decimals = 2
            ThousandSep = True
            CurrencyStr = 'z'#322
            BevelKind = bkTile
            WithCalculator = True
          end
          object CStaticOnceTransRate: TCStatic
            Left = 112
            Top = 149
            Width = 361
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
            TabOrder = 4
            TabStop = True
            Transparent = False
            TextOnEmpty = '<wybierz przelicznik kursu z listy>'
            OnGetDataId = CStaticOnceTransRateGetDataId
            OnChanged = CStaticOnceTransRateChanged
            HotTrack = True
          end
          object CStaticOnceTransCurrencyDest: TCStatic
            Left = 112
            Top = 185
            Width = 169
            Height = 21
            Cursor = crHandPoint
            Hint = '<brak konta>'
            AutoSize = False
            BevelKind = bkTile
            Caption = '<brak konta>'
            Color = clWindow
            Enabled = False
            ParentColor = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 5
            TabStop = True
            Transparent = False
            TextOnEmpty = '<brak konta>'
            OnGetDataId = CStaticInOutOnceCurrencyAccountGetDataId
            HotTrack = False
          end
          object CCurrEditOnceTransAccount: TCCurrEdit
            Left = 384
            Top = 185
            Width = 89
            Height = 21
            BorderStyle = bsNone
            Enabled = False
            TabOrder = 6
            Decimals = 2
            ThousandSep = True
            CurrencyStr = 'z'#322
            BevelKind = bkTile
            WithCalculator = True
          end
        end
        object TabSheetInOutOnce: TTabSheet
          Caption = 'TabSheetInOutOnce'
          ImageIndex = 4
          TabVisible = False
          object Label15: TLabel
            Left = 354
            Top = 45
            Width = 22
            Height = 13
            Alignment = taRightJustify
            Caption = 'Ilo'#347#263
          end
          object Label4: TLabel
            Left = 36
            Top = 9
            Width = 68
            Height = 13
            Alignment = taRightJustify
            Caption = 'Konto operacji'
          end
          object Label1: TLabel
            Left = 59
            Top = 45
            Width = 45
            Height = 13
            Alignment = taRightJustify
            Caption = 'Kategoria'
          end
          object Label2: TLabel
            Left = 52
            Top = 81
            Width = 52
            Height = 13
            Alignment = taRightJustify
            Caption = 'Kontrahent'
          end
          object Label9: TLabel
            Left = 306
            Top = 117
            Width = 70
            Height = 13
            Alignment = taRightJustify
            Caption = 'Kwota operacji'
          end
          object Label17: TLabel
            Left = 40
            Top = 188
            Width = 64
            Height = 13
            Alignment = taRightJustify
            Caption = 'Waluta konta'
          end
          object Label20: TLabel
            Left = 30
            Top = 116
            Width = 74
            Height = 13
            Alignment = taRightJustify
            Caption = 'Waluta operacji'
          end
          object Label21: TLabel
            Left = 296
            Top = 189
            Width = 80
            Height = 13
            Alignment = taRightJustify
            Caption = 'W walucie konta'
          end
          object Label22: TLabel
            Left = 54
            Top = 153
            Width = 50
            Height = 13
            Alignment = taRightJustify
            Caption = 'Przelicznik'
          end
          object CButtonStateOnce: TCButton
            Left = 366
            Top = 3
            Width = 107
            Height = 25
            Cursor = crHandPoint
            PicPosition = ppLeft
            PicOffset = 10
            TxtOffset = 15
            Framed = False
            Action = ActionStateOnceTransSource
            Color = clBtnFace
          end
          object CCurrEditOnceQuantity: TCCurrEdit
            Tag = 1
            Left = 384
            Top = 41
            Width = 89
            Height = 21
            BorderStyle = bsNone
            TabOrder = 2
            OnChange = CCurrEditInoutOnceMovementChange
            Decimals = 2
            ThousandSep = True
            CurrencyStr = 'z'#322
            BevelKind = bkTile
            WithCalculator = True
          end
          object CStaticInoutOnceAccount: TCStatic
            Left = 112
            Top = 5
            Width = 257
            Height = 21
            Cursor = crHandPoint
            Hint = '<wybierz konto '#378'r'#243'd'#322'owe z listy>'
            AutoSize = False
            BevelKind = bkTile
            Caption = '<wybierz konto '#378'r'#243'd'#322'owe z listy>'
            Color = clWindow
            ParentColor = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            TabStop = True
            Transparent = False
            TextOnEmpty = '<wybierz konto '#378'r'#243'd'#322'owe z listy>'
            OnGetDataId = CStaticInoutOnceAccountGetDataId
            OnChanged = CStaticInoutOnceAccountChanged
            HotTrack = True
          end
          object CStaticInoutOnceCategory: TCStatic
            Left = 112
            Top = 41
            Width = 169
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
            TabOrder = 1
            TabStop = True
            Transparent = False
            TextOnEmpty = '<wybierz kategori'#281' z listy>'
            OnGetDataId = CStaticInoutOnceCategoryGetDataId
            OnChanged = CStaticInoutOnceCategoryChanged
            HotTrack = True
          end
          object CStaticInoutOnceCashpoint: TCStatic
            Left = 112
            Top = 77
            Width = 361
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
            TabOrder = 3
            TabStop = True
            Transparent = False
            TextOnEmpty = '<wybierz kontrahenta z listy>'
            OnGetDataId = CStaticInoutOnceCashpointGetDataId
            OnChanged = CStaticInoutOnceCashpointChanged
            HotTrack = True
          end
          object CCurrEditInoutOnceMovement: TCCurrEdit
            Left = 384
            Top = 113
            Width = 89
            Height = 21
            BorderStyle = bsNone
            TabOrder = 5
            OnChange = CCurrEditInoutOnceMovementChange
            Decimals = 2
            ThousandSep = True
            CurrencyStr = 'z'#322
            BevelKind = bkTile
            WithCalculator = True
          end
          object CStaticInOutOnceCurrencyAccount: TCStatic
            Left = 112
            Top = 185
            Width = 169
            Height = 21
            Cursor = crHandPoint
            Hint = '<brak konta>'
            AutoSize = False
            BevelKind = bkTile
            Caption = '<brak konta>'
            Color = clWindow
            Enabled = False
            ParentColor = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 7
            TabStop = True
            Transparent = False
            TextOnEmpty = '<brak konta>'
            OnGetDataId = CStaticInOutOnceCurrencyAccountGetDataId
            HotTrack = False
          end
          object CStaticInOutOnceMovementCurrency: TCStatic
            Left = 112
            Top = 113
            Width = 169
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
            TabOrder = 4
            TabStop = True
            Transparent = False
            TextOnEmpty = '<wybierz walut'#281'>'
            OnGetDataId = CStaticInOutOnceCurrencyAccountGetDataId
            OnChanged = CStaticInOutOnceMovementCurrencyChanged
            HotTrack = True
          end
          object CCurrEditInOutOnceAccount: TCCurrEdit
            Left = 384
            Top = 185
            Width = 89
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
          object CStaticInOutOnceRate: TCStatic
            Left = 112
            Top = 149
            Width = 361
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
            TabOrder = 6
            TabStop = True
            Transparent = False
            TextOnEmpty = '<wybierz przelicznik kursu z listy>'
            OnGetDataId = CStaticInOutOnceRateGetDataId
            OnChanged = CStaticInOutOnceRateChanged
            HotTrack = True
          end
        end
        object TabSheetTransCyclic: TTabSheet
          Caption = 'TabSheetTransCyclic'
          ImageIndex = 3
          TabVisible = False
          object Label29: TLabel
            Left = 61
            Top = 9
            Width = 43
            Height = 13
            Alignment = taRightJustify
            Caption = 'Operacja'
          end
          object Label30: TLabel
            Left = 29
            Top = 45
            Width = 75
            Height = 13
            Alignment = taRightJustify
            Caption = 'Konto '#378'r'#243'd'#322'owe'
          end
          object Label31: TLabel
            Left = 27
            Top = 81
            Width = 77
            Height = 13
            Alignment = taRightJustify
            Caption = 'Konto docelowe'
          end
          object CButtonStateCyclicTransDest: TCButton
            Left = 366
            Top = 75
            Width = 107
            Height = 25
            Cursor = crHandPoint
            PicPosition = ppLeft
            PicOffset = 10
            TxtOffset = 15
            Framed = False
            Action = ActionStateCyclicTransDest
            Color = clBtnFace
          end
          object CButtonStateCyclicTransSource: TCButton
            Left = 366
            Top = 39
            Width = 107
            Height = 25
            Cursor = crHandPoint
            PicPosition = ppLeft
            PicOffset = 10
            TxtOffset = 15
            Framed = False
            Action = ActionStateCyclicTransSource
            Color = clBtnFace
          end
          object Label32: TLabel
            Left = 30
            Top = 116
            Width = 74
            Height = 13
            Alignment = taRightJustify
            Caption = 'Waluta operacji'
          end
          object Label33: TLabel
            Left = 306
            Top = 117
            Width = 70
            Height = 13
            Alignment = taRightJustify
            Caption = 'Kwota operacji'
          end
          object Label34: TLabel
            Left = 54
            Top = 153
            Width = 50
            Height = 13
            Alignment = taRightJustify
            Caption = 'Przelicznik'
          end
          object Label35: TLabel
            Left = 21
            Top = 188
            Width = 83
            Height = 13
            Alignment = taRightJustify
            Caption = 'Waluta docelowa'
          end
          object Label36: TLabel
            Left = 296
            Top = 189
            Width = 80
            Height = 13
            Alignment = taRightJustify
            Caption = 'W walucie konta'
          end
          object CStaticCyclicTrans: TCStatic
            Left = 112
            Top = 5
            Width = 361
            Height = 21
            Cursor = crHandPoint
            Hint = '<wybierz operacj'#281' z listy zaplanowanych operacji>'
            AutoSize = False
            BevelKind = bkTile
            Caption = '<wybierz operacj'#281' z listy zaplanowanych operacji>'
            Color = clWindow
            ParentColor = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            TabStop = True
            Transparent = False
            TextOnEmpty = '<wybierz operacj'#281' z listy zaplanowanych operacji>'
            OnGetDataId = CStaticCyclicTransGetDataId
            OnChanged = CStaticCyclicTransChanged
            HotTrack = True
          end
          object CStaticCyclicTransSourceAccount: TCStatic
            Left = 112
            Top = 41
            Width = 257
            Height = 21
            Cursor = crHandPoint
            Hint = '<wybierz konto '#378'r'#243'd'#322'owe z listy>'
            AutoSize = False
            BevelKind = bkTile
            Caption = '<wybierz konto '#378'r'#243'd'#322'owe z listy>'
            Color = clWindow
            ParentColor = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            TabStop = True
            Transparent = False
            TextOnEmpty = '<wybierz konto '#378'r'#243'd'#322'owe z listy>'
            OnGetDataId = CStaticCyclicTransSourceAccountGetDataId
            OnChanged = CStaticCyclicTransSourceAccountChanged
            HotTrack = True
          end
          object CStaticCyclicTransDestAccount: TCStatic
            Left = 112
            Top = 77
            Width = 257
            Height = 21
            Cursor = crHandPoint
            Hint = '<wybierz konto docelowe z listy>'
            AutoSize = False
            BevelKind = bkTile
            Caption = '<wybierz konto docelowe z listy>'
            Color = clWindow
            ParentColor = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            TabStop = True
            Transparent = False
            TextOnEmpty = '<wybierz konto docelowe z listy>'
            OnGetDataId = CStaticCyclicTransDestAccountGetDataId
            OnChanged = CStaticCyclicTransDestAccountChanged
            HotTrack = True
          end
          object CStaticCyclicTransCurrencySource: TCStatic
            Left = 112
            Top = 113
            Width = 169
            Height = 21
            Cursor = crHandPoint
            Hint = '<brak konta>'
            AutoSize = False
            BevelKind = bkTile
            Caption = '<brak konta>'
            Color = clWindow
            Enabled = False
            ParentColor = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 3
            TabStop = True
            Transparent = False
            TextOnEmpty = '<brak konta>'
            OnGetDataId = CStaticCyclicTransCurrencySourceGetDataId
            HotTrack = False
          end
          object CCurrEditCyclicTransMovement: TCCurrEdit
            Left = 384
            Top = 113
            Width = 89
            Height = 21
            BorderStyle = bsNone
            TabOrder = 4
            OnChange = CCurrEditCyclicTransMovementChange
            Decimals = 2
            ThousandSep = True
            CurrencyStr = 'z'#322
            BevelKind = bkTile
            WithCalculator = True
          end
          object CStaticCyclicTransCurrencyDest: TCStatic
            Left = 112
            Top = 185
            Width = 169
            Height = 21
            Cursor = crHandPoint
            Hint = '<brak konta>'
            AutoSize = False
            BevelKind = bkTile
            Caption = '<brak konta>'
            Color = clWindow
            Enabled = False
            ParentColor = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 5
            TabStop = True
            Transparent = False
            TextOnEmpty = '<brak konta>'
            OnGetDataId = CStaticCyclicTransCurrencyDestGetDataId
            HotTrack = False
          end
          object CCurrEditCyclicTransAccount: TCCurrEdit
            Left = 384
            Top = 185
            Width = 89
            Height = 21
            BorderStyle = bsNone
            Enabled = False
            TabOrder = 6
            Decimals = 2
            ThousandSep = True
            CurrencyStr = 'z'#322
            BevelKind = bkTile
            WithCalculator = True
          end
          object CStaticCyclicTransRate: TCStatic
            Left = 112
            Top = 149
            Width = 361
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
            OnGetDataId = CStaticCyclicTransRateGetDataId
            OnChanged = CStaticCyclicTransRateChanged
            HotTrack = True
          end
        end
      end
    end
  end
  inherited PanelButtons: TCPanel
    Top = 566
    Width = 536
    DesignSize = (
      536
      41)
    inherited BitBtnOk: TBitBtn
      Left = 359
    end
    inherited BitBtnCancel: TBitBtn
      Left = 447
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
      OnExecute = ActionAddExecute
    end
    object ActionTemplate: TAction
      Caption = 'Konfiguruj szablony'
      ImageIndex = 1
      OnExecute = ActionTemplateExecute
    end
  end
  object ActionManagerStates: TActionManager
    Images = CImageLists.MovstatusImageList16x16
    Left = 32
    Top = 122
    StyleName = 'XP Style'
    object ActionStateOnce: TAction
      Caption = 'Do uzgodnienia'
      ImageIndex = 1
      OnExecute = ActionStateOnceExecute
    end
    object ActionStateOnceTransSource: TAction
      Caption = 'Do uzgodnienia'
      ImageIndex = 1
      OnExecute = ActionStateOnceTransSourceExecute
    end
    object ActionStateOnceTransDest: TAction
      Caption = 'Do uzgodnienia'
      ImageIndex = 1
      OnExecute = ActionStateOnceTransDestExecute
    end
    object ActionStateCyclic: TAction
      Caption = 'Do uzgodnienia'
      ImageIndex = 1
      OnExecute = ActionStateCyclicExecute
    end
    object ActionStateCyclicTransSource: TAction
      Caption = 'Do uzgodnienia'
      ImageIndex = 1
      OnExecute = ActionStateCyclicTransSourceExecute
    end
    object ActionStateCyclicTransDest: TAction
      Caption = 'Do uzgodnienia'
      ImageIndex = 1
      OnExecute = ActionStateCyclicTransDestExecute
    end
  end
end