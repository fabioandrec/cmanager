inherited CPlannedForm: TCPlannedForm
  Left = 323
  Top = 84
  Caption = 'Planowana operacja'
  ClientHeight = 541
  ClientWidth = 536
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
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
      object Label4: TLabel
        Left = 36
        Top = 29
        Width = 68
        Height = 13
        Alignment = taRightJustify
        Caption = 'Konto operacji'
      end
      object Label2: TLabel
        Left = 59
        Top = 65
        Width = 45
        Height = 13
        Alignment = taRightJustify
        Caption = 'Kategoria'
      end
      object Label6: TLabel
        Left = 52
        Top = 101
        Width = 52
        Height = 13
        Alignment = taRightJustify
        Caption = 'Kontrahent'
      end
      object Label9: TLabel
        Left = 250
        Top = 139
        Width = 70
        Height = 13
        Alignment = taRightJustify
        Caption = 'Kwota operacji'
      end
      object Label17: TLabel
        Left = 30
        Top = 138
        Width = 74
        Height = 13
        Alignment = taRightJustify
        Caption = 'Waluta operacji'
      end
      object CStaticAccount: TCStatic
        Left = 112
        Top = 25
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
        OnGetDataId = CStaticAccountGetDataId
        OnChanged = CStaticAccountChanged
        HotTrack = True
      end
      object CStaticCategory: TCStatic
        Left = 112
        Top = 61
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
        OnGetDataId = CStaticCategoryGetDataId
        OnChanged = CStaticAccountChanged
        HotTrack = True
      end
      object CStaticCashpoint: TCStatic
        Left = 112
        Top = 97
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
        OnGetDataId = CStaticCashpointGetDataId
        OnChanged = CStaticAccountChanged
        HotTrack = True
      end
      object CCurrEdit: TCCurrEdit
        Left = 328
        Top = 135
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
      object CStaticCurrency: TCStatic
        Left = 112
        Top = 135
        Width = 129
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
        OnGetDataId = CStaticCurrencyGetDataId
        OnChanged = CStaticCurrencyChanged
        HotTrack = True
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
          'Przych'#243'd')
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
        AutoSize = False
        BevelKind = bkTile
        Caption = '<ustaw harmonogram wykonywania operacji>'
        Color = clWindow
        ParentColor = False
        TabOrder = 2
        TabStop = True
        Transparent = False
        TextOnEmpty = '<ustaw harmonogram wykonywania operacji>'
        OnGetDataId = CStaticScheduleGetDataId
        HotTrack = True
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 500
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
