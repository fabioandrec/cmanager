inherited CDepositInvestmentForm: TCDepositInvestmentForm
  Left = 275
  Top = 71
  Caption = 'Lokata'
  ClientHeight = 728
  ClientWidth = 627
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
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
        Left = 17
        Top = 28
        Width = 103
        Height = 13
        Alignment = taRightJustify
        Caption = 'Data za'#322'o'#380'enia lokaty'
      end
      object Label5: TLabel
        Left = 242
        Top = 28
        Width = 22
        Height = 13
        Alignment = taRightJustify
        Caption = 'Stan'
      end
      object Label2: TLabel
        Left = 56
        Top = 64
        Width = 64
        Height = 13
        Alignment = taRightJustify
        Caption = 'Nazwa lokaty'
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
        HotTrack = True
        Withtime = False
      end
      object ComboBoxState: TComboBox
        Left = 272
        Top = 24
        Width = 297
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 1
        Text = 'Aktywna'
        Items.Strings = (
          'Aktywna'
          'Zamkni'#281'ta'
          'Nieaktywna')
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
      end
    end
    object GroupBox2: TGroupBox
      Left = 16
      Top = 512
      Width = 593
      Height = 169
      Caption = ' Opis '
      TabOrder = 2
      object CButton1: TCButton
        Left = 326
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
        Left = 444
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
        Width = 545
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
      Top = 136
      Width = 593
      Height = 361
      Caption = ' Szczeg'#243#322'y lokaty '
      TabOrder = 1
      object Label14: TLabel
        Left = 20
        Top = 28
        Width = 100
        Height = 13
        Alignment = taRightJustify
        Caption = 'Konto stowarzyszone'
      end
      object Label1: TLabel
        Left = 310
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
      object Label18: TLabel
        Left = 26
        Top = 100
        Width = 94
        Height = 13
        Alignment = taRightJustify
        Caption = 'Kapita'#322' pocz'#261'tkowy'
      end
      object Label4: TLabel
        Left = 42
        Top = 136
        Width = 78
        Height = 13
        Alignment = taRightJustify
        Caption = 'Oprocentowanie'
      end
      object Label6: TLabel
        Left = 29
        Top = 172
        Width = 91
        Height = 13
        Alignment = taRightJustify
        Caption = 'Czas trwania lokaty'
      end
      object Label7: TLabel
        Left = 44
        Top = 208
        Width = 76
        Height = 13
        Alignment = taRightJustify
        Caption = 'Po zako'#324'czeniu'
      end
      object Label8: TLabel
        Left = 46
        Top = 244
        Width = 74
        Height = 13
        Alignment = taRightJustify
        Caption = 'Naliczaj odsetki'
      end
      object Label9: TLabel
        Left = 107
        Top = 280
        Width = 13
        Height = 13
        Alignment = taRightJustify
        Caption = 'Co'
      end
      object Label11: TLabel
        Left = 57
        Top = 316
        Width = 63
        Height = 13
        Alignment = taRightJustify
        Caption = 'Po naliczeniu'
      end
      object Label12: TLabel
        Left = 344
        Top = 172
        Width = 56
        Height = 13
        Alignment = taRightJustify
        Caption = 'Data ko'#324'ca'
      end
      object Label13: TLabel
        Left = 315
        Top = 280
        Width = 85
        Height = 13
        Alignment = taRightJustify
        Caption = 'Kolejne naliczanie'
      end
      object Label15: TLabel
        Left = 323
        Top = 100
        Width = 77
        Height = 13
        Alignment = taRightJustify
        Caption = 'Aktualny kapita'#322
      end
      object Label16: TLabel
        Left = 332
        Top = 136
        Width = 68
        Height = 13
        Alignment = taRightJustify
        Caption = 'Wolne odsetki'
      end
      object CStaticAccount: TCStatic
        Left = 128
        Top = 24
        Width = 161
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz konto z listy>'
        Color = clWindow
        ParentColor = False
        TabOrder = 0
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz konto z listy>'
        HotTrack = True
      end
      object CStaticCashpoint: TCStatic
        Left = 408
        Top = 24
        Width = 161
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
      object CStaticCurrency: TCStatic
        Left = 128
        Top = 60
        Width = 161
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz walut'#281'>'
        Color = clWindow
        ParentColor = False
        TabOrder = 2
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz walut'#281'>'
        HotTrack = True
      end
      object CCurrEditCapital: TCCurrEdit
        Left = 128
        Top = 96
        Width = 161
        Height = 21
        BorderStyle = bsNone
        TabOrder = 3
        Decimals = 2
        ThousandSep = True
        CurrencyStr = 'z'#322
        BevelKind = bkTile
        WithCalculator = True
      end
      object CCurrEditRate: TCCurrEdit
        Left = 128
        Top = 132
        Width = 161
        Height = 21
        BorderStyle = bsNone
        TabOrder = 5
        Decimals = 4
        ThousandSep = True
        CurrencyStr = '%'
        BevelKind = bkTile
        WithCalculator = True
      end
      object CIntEditPeriodCount: TCIntEdit
        Left = 128
        Top = 168
        Width = 57
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 4
        TabOrder = 7
        Text = '1'
      end
      object ComboBoxPeriodType: TComboBox
        Left = 200
        Top = 168
        Width = 105
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 2
        TabOrder = 8
        Text = 'miesi'#281'cy'
        Items.Strings = (
          'dni'
          'tygodni'
          'miesi'#281'cy'
          'lat')
      end
      object ComboBoxPeriodAction: TComboBox
        Left = 128
        Top = 204
        Width = 177
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 10
        Text = 'zmie'#324' status na nieaktywna'
        Items.Strings = (
          'zmie'#324' status na nieaktywna'
          'automatycznie odn'#243'w lokat'#281)
      end
      object ComboBoxDueMode: TComboBox
        Left = 128
        Top = 240
        Width = 441
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 11
        Text = 'jednorazowo, po zako'#324'czeniu czasu trwania lokaty'
        Items.Strings = (
          'jednorazowo, po zako'#324'czeniu czasu trwania lokaty'
          'wielokrotnie, co wskazany okres czasu')
      end
      object CIntEditDueCount: TCIntEdit
        Left = 128
        Top = 276
        Width = 57
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 4
        TabOrder = 12
        Text = '1'
      end
      object ComboBoxDueType: TComboBox
        Left = 200
        Top = 276
        Width = 97
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 2
        TabOrder = 13
        Text = 'miesi'#281'cy'
        Items.Strings = (
          'dni'
          'tygodni'
          'miesi'#281'cy'
          'lat')
      end
      object ComboBoxDueAction: TComboBox
        Left = 128
        Top = 312
        Width = 169
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 15
        Text = 'dopisz odsetki do kapita'#322'u'
        Items.Strings = (
          'dopisz odsetki do kapita'#322'u'
          'pozostaw gotowe do wyp'#322'aty')
      end
      object CDateTimeDepositEndDate: TCDateTime
        Left = 408
        Top = 168
        Width = 161
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz dat'#281' >'
        Color = clWindow
        ParentColor = False
        TabOrder = 9
        TabStop = True
        Transparent = False
        HotTrack = True
        Withtime = False
      end
      object CDateTimeNextDue: TCDateTime
        Left = 408
        Top = 276
        Width = 161
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz dat'#281' >'
        Color = clWindow
        ParentColor = False
        TabOrder = 14
        TabStop = True
        Transparent = False
        HotTrack = True
        Withtime = False
      end
      object CCurrEditActualCash: TCCurrEdit
        Left = 408
        Top = 96
        Width = 161
        Height = 21
        BorderStyle = bsNone
        TabOrder = 4
        Decimals = 2
        ThousandSep = True
        CurrencyStr = 'z'#322
        BevelKind = bkTile
        WithCalculator = True
      end
      object CCurrEditActualInterest: TCCurrEdit
        Left = 408
        Top = 132
        Width = 161
        Height = 21
        BorderStyle = bsNone
        TabOrder = 6
        Decimals = 2
        ThousandSep = True
        CurrencyStr = 'z'#322
        BevelKind = bkTile
        WithCalculator = True
      end
    end
  end
  inherited PanelButtons: TPanel
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
    end
    object ActionTemplate: TAction
      Caption = 'Konfiguruj szablony'
      ImageIndex = 1
    end
  end
end
