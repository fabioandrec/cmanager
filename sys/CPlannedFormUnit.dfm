inherited CPlannedForm: TCPlannedForm
  Left = 323
  Top = 84
  Caption = 'Planowana operacja'
  ClientHeight = 541
  ClientWidth = 536
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TCPanel
    Width = 536
    Height = 500
    object GroupBox2: TGroupBox
      Left = 16
      Top = 328
      Width = 505
      Height = 165
      Caption = ' Opis '
      TabOrder = 2
      object CButton1: TCButton
        Left = 238
        Top = 125
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
        Top = 125
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
        Top = 127
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
      Top = 136
      Width = 505
      Height = 177
      Caption = ' Szczeg'#243#322'y operacji '
      TabOrder = 1
      object PageControl: TPageControl
        Left = 2
        Top = 15
        Width = 501
        Height = 160
        ActivePage = TabSheetTransfer
        Align = alClient
        Style = tsFlatButtons
        TabOrder = 0
        object TabSheetInOut: TTabSheet
          Caption = 'TabSheetInOut'
          TabVisible = False
          object Label4: TLabel
            Left = 28
            Top = 9
            Width = 68
            Height = 13
            Alignment = taRightJustify
            Caption = 'Konto operacji'
          end
          object Label2: TLabel
            Left = 51
            Top = 45
            Width = 45
            Height = 13
            Alignment = taRightJustify
            Caption = 'Kategoria'
          end
          object Label15: TLabel
            Left = 346
            Top = 45
            Width = 22
            Height = 13
            Alignment = taRightJustify
            Caption = 'Ilo'#347#263
          end
          object Label6: TLabel
            Left = 44
            Top = 81
            Width = 52
            Height = 13
            Alignment = taRightJustify
            Caption = 'Kontrahent'
          end
          object Label17: TLabel
            Left = 22
            Top = 117
            Width = 74
            Height = 13
            Alignment = taRightJustify
            Caption = 'Waluta operacji'
          end
          object Label9: TLabel
            Left = 298
            Top = 117
            Width = 70
            Height = 13
            Alignment = taRightJustify
            Caption = 'Kwota operacji'
          end
          object CCurrEditQuantity: TCCurrEdit
            Tag = 1
            Left = 376
            Top = 41
            Width = 89
            Height = 21
            BorderStyle = bsNone
            TabOrder = 2
            Decimals = 2
            ThousandSep = True
            CurrencyStr = 'z'#322
            BevelKind = bkTile
            WithCalculator = True
          end
          object CStaticAccount: TCStatic
            Left = 104
            Top = 5
            Width = 361
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
            OnGetDataId = CStaticAccountGetDataId
            OnChanged = CStaticAccountChanged
            HotTrack = True
          end
          object CStaticCategory: TCStatic
            Left = 104
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
            OnGetDataId = CStaticCategoryGetDataId
            OnChanged = CStaticCategoryChanged
            HotTrack = True
          end
          object CStaticCashpoint: TCStatic
            Left = 104
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
            OnGetDataId = CStaticCashpointGetDataId
            OnChanged = CStaticAccountChanged
            HotTrack = True
          end
          object CStaticCurrency: TCStatic
            Left = 104
            Top = 113
            Width = 169
            Height = 21
            Cursor = crHandPoint
            Hint = '<wybierz walut'#281' z listy>'
            AutoSize = False
            BevelKind = bkTile
            Caption = '<wybierz walut'#281' z listy>'
            Color = clWindow
            ParentColor = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 4
            TabStop = True
            Transparent = False
            TextOnEmpty = '<wybierz walut'#281' z listy>'
            OnGetDataId = CStaticCurrencyGetDataId
            OnChanged = CStaticCurrencyChanged
            HotTrack = True
          end
          object CCurrEdit: TCCurrEdit
            Left = 376
            Top = 113
            Width = 89
            Height = 21
            BorderStyle = bsNone
            TabOrder = 5
            Decimals = 2
            ThousandSep = True
            CurrencyStr = 'z'#322
            BevelKind = bkTile
            WithCalculator = True
          end
        end
        object TabSheetTransfer: TTabSheet
          Caption = 'TabSheetTransfer'
          ImageIndex = 1
          TabVisible = False
          object Label3: TLabel
            Left = 28
            Top = 9
            Width = 68
            Height = 13
            Alignment = taRightJustify
            Caption = 'Konto operacji'
          end
          object Label8: TLabel
            Left = 22
            Top = 45
            Width = 74
            Height = 13
            Alignment = taRightJustify
            Caption = 'Waluta operacji'
          end
          object Label10: TLabel
            Left = 298
            Top = 45
            Width = 70
            Height = 13
            Alignment = taRightJustify
            Caption = 'Kwota operacji'
          end
          object Label11: TLabel
            Left = 19
            Top = 81
            Width = 77
            Height = 13
            Alignment = taRightJustify
            Caption = 'Konto docelowe'
          end
          object CStaticAccoutTransferSource: TCStatic
            Left = 104
            Top = 5
            Width = 361
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
            OnGetDataId = CStaticAccoutTransferSourceGetDataId
            OnChanged = CStaticAccoutTransferSourceChanged
            HotTrack = True
          end
          object CStaticSourceCurrencyDefTransfer: TCStatic
            Left = 104
            Top = 41
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
            TabOrder = 1
            TabStop = True
            Transparent = False
            TextOnEmpty = '<brak konta>'
            HotTrack = False
          end
          object CCurrEditTransfer: TCCurrEdit
            Left = 376
            Top = 41
            Width = 89
            Height = 21
            BorderStyle = bsNone
            TabOrder = 2
            Decimals = 2
            ThousandSep = True
            CurrencyStr = 'z'#322
            BevelKind = bkTile
            WithCalculator = True
          end
          object CStaticAccoutTransferDest: TCStatic
            Left = 104
            Top = 77
            Width = 361
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
            TabOrder = 3
            TabStop = True
            Transparent = False
            TextOnEmpty = '<wybierz konto docelowe z listy>'
            OnGetDataId = CStaticAccoutTransferDestGetDataId
            OnChanged = CStaticAccoutTransferDestChanged
            HotTrack = True
          end
        end
      end
    end
    object GroupBox1: TGroupBox
      Left = 16
      Top = 16
      Width = 505
      Height = 105
      Caption = ' Dane podstawowe '
      TabOrder = 0
      object Label5: TLabel
        Left = 31
        Top = 32
        Width = 73
        Height = 13
        Alignment = taRightJustify
        Caption = 'Rodzaj operacji'
      end
      object Label7: TLabel
        Left = 290
        Top = 32
        Width = 30
        Height = 13
        Alignment = taRightJustify
        Caption = 'Status'
      end
      object Label1: TLabel
        Left = 38
        Top = 69
        Width = 66
        Height = 13
        Alignment = taRightJustify
        Caption = 'Harmonogram'
      end
      object ComboBoxType: TComboBox
        Left = 112
        Top = 28
        Width = 161
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 0
        Text = 'Rozch'#243'd'
        OnChange = ComboBoxTypeChange
        Items.Strings = (
          'Rozch'#243'd'
          'Przych'#243'd'
          'Transfer')
      end
      object ComboBoxStatus: TComboBox
        Left = 328
        Top = 28
        Width = 137
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 1
        Text = 'Aktywne'
        OnChange = ComboBoxTypeChange
        Items.Strings = (
          'Aktywne'
          'Wy'#322#261'czone')
      end
      object CStaticSchedule: TCStatic
        Left = 112
        Top = 65
        Width = 353
        Height = 21
        Cursor = crHandPoint
        Hint = '<ustaw harmonogram wykonywania operacji>'
        AutoSize = False
        BevelKind = bkTile
        Caption = '<ustaw harmonogram wykonywania operacji>'
        Color = clWindow
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        TabStop = True
        Transparent = False
        TextOnEmpty = '<ustaw harmonogram wykonywania operacji>'
        OnGetDataId = CStaticScheduleGetDataId
        HotTrack = True
      end
    end
  end
  inherited PanelButtons: TCPanel
    Top = 500
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
    Left = 24
    Top = 202
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