inherited CMovementForm: TCMovementForm
  Left = 330
  Top = 299
  Caption = 'Operacja'
  ClientHeight = 504
  ClientWidth = 536
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 536
    Height = 463
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
      object GroupBox4: TGroupBox
        Left = 0
        Top = 0
        Width = 505
        Height = 65
        Caption = ' Dane podstawowe '
        TabOrder = 1
        object Label15: TLabel
          Left = 17
          Top = 28
          Width = 23
          Height = 13
          Alignment = taRightJustify
          Caption = 'Data'
        end
        object Label16: TLabel
          Left = 151
          Top = 28
          Width = 33
          Height = 13
          Alignment = taRightJustify
          Caption = 'Rodzaj'
        end
        object CDateTime: TCDateTime
          Left = 48
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
          OnChanged = CDateTimeChanged
          HotTrack = True
        end
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
        TabOrder = 0
        Text = 'Rozch'#243'd jednorazowy'
        OnChange = ComboBoxTypeChange
        Items.Strings = (
          'Rozch'#243'd jednorazowy'
          'Przych'#243'd jednorazowy'
          'Transfer '#347'rodk'#243'w'
          'Planowany rozch'#243'd'
          'Planowany przych'#243'd')
      end
    end
    object GroupBox2: TGroupBox
      Left = 16
      Top = 288
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
      object RichEditDesc: TRichEdit
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
      Height = 177
      Caption = ' Szczeg'#243#322'y operacji '
      TabOrder = 1
      object PageControl: TPageControl
        Left = 2
        Top = 15
        Width = 501
        Height = 160
        ActivePage = TabSheetTrans
        Align = alClient
        Style = tsFlatButtons
        TabOrder = 0
        TabStop = False
        object TabSheetInOutCyclic: TTabSheet
          Caption = 'TabSheetInOutCyclic'
          TabVisible = False
          object Label10: TLabel
            Left = 290
            Top = 119
            Width = 30
            Height = 13
            Alignment = taRightJustify
            Caption = 'Kwota'
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
            Left = 268
            Top = 81
            Width = 52
            Height = 13
            Alignment = taRightJustify
            Caption = 'Kontrahent'
          end
          object Label18: TLabel
            Left = 70
            Top = 118
            Width = 34
            Height = 13
            Alignment = taRightJustify
            Caption = 'Waluta'
          end
          object CCurrEditInoutCyclic: TCCurrEdit
            Left = 328
            Top = 115
            Width = 145
            Height = 21
            BorderStyle = bsNone
            TabOrder = 5
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
            AutoSize = False
            BevelKind = bkTile
            Caption = '<wybierz operacj'#281' z listy zaplanowanych operacji>'
            Color = clWindow
            ParentColor = False
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
            Width = 361
            Height = 21
            Cursor = crHandPoint
            AutoSize = False
            BevelKind = bkTile
            Caption = '<wybierz konto z listy>'
            Color = clWindow
            ParentColor = False
            TabOrder = 1
            TabStop = True
            Transparent = False
            TextOnEmpty = '<wybierz konto z listy>'
            OnGetDataId = CStaticInoutCyclicAccountGetDataId
            OnChanged = CStaticInoutOnceAccountChanged
            HotTrack = True
          end
          object CStaticInoutCyclicCategory: TCStatic
            Left = 112
            Top = 77
            Width = 145
            Height = 21
            Cursor = crHandPoint
            AutoSize = False
            BevelKind = bkTile
            Caption = '<wybierz kategori'#281' z listy>'
            Color = clWindow
            ParentColor = False
            TabOrder = 2
            TabStop = True
            Transparent = False
            TextOnEmpty = '<wybierz kategori'#281' z listy>'
            OnGetDataId = CStaticInoutCyclicCategoryGetDataId
            OnChanged = CStaticInoutOnceAccountChanged
            HotTrack = True
          end
          object CStaticInoutCyclicCashpoint: TCStatic
            Left = 328
            Top = 77
            Width = 145
            Height = 21
            Cursor = crHandPoint
            AutoSize = False
            BevelKind = bkTile
            Caption = '<wybierz kontrahenta z listy>'
            Color = clWindow
            ParentColor = False
            TabOrder = 3
            TabStop = True
            Transparent = False
            TextOnEmpty = '<wybierz kontrahenta z listy>'
            OnGetDataId = CStaticInoutCyclicCashpointGetDataId
            OnChanged = CStaticInoutOnceAccountChanged
            HotTrack = True
          end
          object CStaticCurrencyCyclic: TCStatic
            Left = 112
            Top = 115
            Width = 145
            Height = 21
            Cursor = crHandPoint
            AutoSize = False
            BevelKind = bkTile
            Caption = '<wybierz walut'#281' z listy>'
            Color = clWindow
            ParentColor = False
            TabOrder = 4
            TabStop = True
            Transparent = False
            TextOnEmpty = '<wybierz walut'#281' z listy>'
            OnGetDataId = CStaticCurrencyCyclicGetDataId
            OnChanged = CStaticCurrencyCyclicChanged
            HotTrack = True
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
            Left = 290
            Top = 119
            Width = 30
            Height = 13
            Alignment = taRightJustify
            Caption = 'Kwota'
          end
          object Label19: TLabel
            Left = 70
            Top = 118
            Width = 34
            Height = 13
            Alignment = taRightJustify
            Caption = 'Waluta'
          end
          object CStaticTransSourceAccount: TCStatic
            Left = 112
            Top = 5
            Width = 361
            Height = 21
            Cursor = crHandPoint
            AutoSize = False
            BevelKind = bkTile
            Caption = '<wybierz konto '#378'r'#243'd'#322'owe z listy>'
            Color = clWindow
            ParentColor = False
            TabOrder = 0
            TabStop = True
            Transparent = False
            TextOnEmpty = '<wybierz konto '#378'r'#243'd'#322'owe z listy>'
            OnGetDataId = CStaticTransSourceAccountGetDataId
            OnChanged = CStaticInoutOnceAccountChanged
            HotTrack = True
          end
          object CStaticTransDestAccount: TCStatic
            Left = 112
            Top = 41
            Width = 361
            Height = 21
            Cursor = crHandPoint
            AutoSize = False
            BevelKind = bkTile
            Caption = '<wybierz konto docelowe z listy>'
            Color = clWindow
            ParentColor = False
            TabOrder = 1
            TabStop = True
            Transparent = False
            TextOnEmpty = '<wybierz konto docelowe z listy>'
            OnGetDataId = CStaticTransDestAccountGetDataId
            OnChanged = CStaticInoutOnceAccountChanged
            HotTrack = True
          end
          object CCurrEditTrans: TCCurrEdit
            Left = 328
            Top = 115
            Width = 145
            Height = 21
            BorderStyle = bsNone
            TabOrder = 3
            Decimals = 2
            ThousandSep = True
            CurrencyStr = 'z'#322
            BevelKind = bkTile
            WithCalculator = True
          end
          object CStaticCurrencyTrans: TCStatic
            Left = 112
            Top = 115
            Width = 145
            Height = 21
            Cursor = crHandPoint
            AutoSize = False
            BevelKind = bkTile
            Caption = '<wybierz walut'#281' z listy>'
            Color = clWindow
            ParentColor = False
            TabOrder = 2
            TabStop = True
            Transparent = False
            TextOnEmpty = '<wybierz walut'#281' z listy>'
            OnGetDataId = CStaticCurrencyTransGetDataId
            OnChanged = CStaticCurrencyTransChanged
            HotTrack = True
          end
        end
        object TabSheetInOutOnce: TTabSheet
          Caption = 'TabSheetInOutOnce'
          ImageIndex = 4
          TabVisible = False
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
            Left = 290
            Top = 119
            Width = 30
            Height = 13
            Alignment = taRightJustify
            Caption = 'Kwota'
          end
          object Label17: TLabel
            Left = 70
            Top = 118
            Width = 34
            Height = 13
            Alignment = taRightJustify
            Caption = 'Waluta'
          end
          object CStaticInoutOnceAccount: TCStatic
            Left = 112
            Top = 5
            Width = 361
            Height = 21
            Cursor = crHandPoint
            AutoSize = False
            BevelKind = bkTile
            Caption = '<wybierz konto '#378'r'#243'd'#322'owe z listy>'
            Color = clWindow
            ParentColor = False
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
            Width = 361
            Height = 21
            Cursor = crHandPoint
            AutoSize = False
            BevelKind = bkTile
            Caption = '<wybierz kategori'#281' z listy>'
            Color = clWindow
            ParentColor = False
            TabOrder = 1
            TabStop = True
            Transparent = False
            TextOnEmpty = '<wybierz kategori'#281' z listy>'
            OnGetDataId = CStaticInoutOnceCategoryGetDataId
            OnChanged = CStaticInoutOnceAccountChanged
            HotTrack = True
          end
          object CStaticInoutOnceCashpoint: TCStatic
            Left = 112
            Top = 77
            Width = 361
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
            OnGetDataId = CStaticInoutOnceCashpointGetDataId
            OnChanged = CStaticInoutOnceAccountChanged
            HotTrack = True
          end
          object CCurrEditInoutOnce: TCCurrEdit
            Left = 328
            Top = 115
            Width = 145
            Height = 21
            BorderStyle = bsNone
            TabOrder = 4
            Decimals = 2
            ThousandSep = True
            CurrencyStr = 'z'#322
            BevelKind = bkTile
            WithCalculator = True
          end
          object CStaticCurrencyOnce: TCStatic
            Left = 112
            Top = 115
            Width = 145
            Height = 21
            Cursor = crHandPoint
            AutoSize = False
            BevelKind = bkTile
            Caption = '<wybierz walut'#281' z listy>'
            Color = clWindow
            ParentColor = False
            TabOrder = 3
            TabStop = True
            Transparent = False
            TextOnEmpty = '<wybierz walut'#281' z listy>'
            OnGetDataId = CStaticCurrencyOnceGetDataId
            OnChanged = CStaticCurrencyOnceChanged
            HotTrack = True
          end
        end
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 463
    Width = 536
    inherited BitBtnOk: TBitBtn
      Left = 359
    end
    inherited BitBtnCancel: TBitBtn
      Left = 447
    end
  end
  object ActionManager: TActionManager
    Images = CImageLists.TemplateImageList16x16
    Left = 40
    Top = 178
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
