inherited CDepositInvestmentForm: TCDepositInvestmentForm
  Left = 403
  Top = 89
  Caption = 'Lokata'
  ClientHeight = 728
  ClientWidth = 537
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 537
    Height = 687
    object GroupBox1: TGroupBox
      Left = 16
      Top = 16
      Width = 505
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
        Left = 234
        Top = 28
        Width = 30
        Height = 13
        Alignment = taRightJustify
        Caption = 'Status'
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
      object ComboBoxStatus: TComboBox
        Left = 272
        Top = 24
        Width = 209
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
        Width = 353
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
        Items.Strings = (
          'W'#322'asny'
          'W/g szablonu')
      end
    end
    object GroupBox3: TGroupBox
      Left = 16
      Top = 136
      Width = 505
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
        Left = 30
        Top = 64
        Width = 90
        Height = 13
        Alignment = taRightJustify
        Caption = 'Prowadz'#261'cy lokat'#281
      end
      object Label10: TLabel
        Left = 86
        Top = 99
        Width = 34
        Height = 13
        Alignment = taRightJustify
        Caption = 'Waluta'
      end
      object Label18: TLabel
        Left = 249
        Top = 100
        Width = 103
        Height = 13
        Alignment = taRightJustify
        Caption = 'Kwota kapita'#322'u lokaty'
      end
      object Label4: TLabel
        Left = 274
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
      object CStaticAccount: TCStatic
        Left = 128
        Top = 24
        Width = 353
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
        Left = 128
        Top = 60
        Width = 353
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
        Top = 96
        Width = 105
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
        Left = 360
        Top = 96
        Width = 121
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
        Left = 360
        Top = 132
        Width = 121
        Height = 21
        BorderStyle = bsNone
        TabOrder = 4
        Decimals = 4
        ThousandSep = True
        CurrencyStr = '%'
        BevelKind = bkTile
        WithCalculator = True
      end
      object CIntEditPeriodCount: TCIntEdit
        Left = 128
        Top = 168
        Width = 105
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 4
        TabOrder = 5
        Text = '0'
      end
      object ComboBoxPeriodType: TComboBox
        Left = 248
        Top = 168
        Width = 233
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 2
        TabOrder = 6
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
        Width = 353
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 7
        Text = 'zmie'#324' status lokaty na nieaktywna'
        Items.Strings = (
          'zmie'#324' status lokaty na nieaktywna'
          'za'#322#243#380' ponownie na ten sam czas trwania lokaty')
      end
      object ComboBoxDueMode: TComboBox
        Left = 128
        Top = 240
        Width = 353
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 8
        Text = 'jednorazowo, po zako'#324'czeniu czasu trwania lokaty'
        Items.Strings = (
          'jednorazowo, po zako'#324'czeniu czasu trwania lokaty'
          'co wskazany okres czasu')
      end
      object CIntEditDueCount: TCIntEdit
        Left = 128
        Top = 276
        Width = 105
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 4
        TabOrder = 9
        Text = '0'
      end
      object ComboBoxDueType: TComboBox
        Left = 248
        Top = 276
        Width = 233
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 2
        TabOrder = 10
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
        Width = 353
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 11
        Text = 'dopisz odsetki do kwoty kapita'#322'u'
        Items.Strings = (
          'dopisz odsetki do kwoty kapita'#322'u'
          'pozostaw odsetki gotowe do wyp'#322'aty')
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 687
    Width = 537
    inherited BitBtnOk: TBitBtn
      Left = 360
    end
    inherited BitBtnCancel: TBitBtn
      Left = 448
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
