inherited CInvestmentMovementForm: TCInvestmentMovementForm
  Left = 338
  Top = 58
  Caption = 'CInvestmentMovementForm'
  ClientHeight = 549
  ClientWidth = 538
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 538
    Height = 508
    object GroupBox1: TGroupBox
      Left = 16
      Top = 16
      Width = 505
      Height = 65
      Caption = ' Dane podstawowe '
      TabOrder = 0
      object Label5: TLabel
        Left = 247
        Top = 28
        Width = 33
        Height = 13
        Alignment = taRightJustify
        Caption = 'Rodzaj'
      end
      object Label3: TLabel
        Left = 19
        Top = 28
        Width = 53
        Height = 13
        Alignment = taRightJustify
        Caption = 'Data i czas'
      end
      object ComboBoxType: TComboBox
        Left = 288
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
        Items.Strings = (
          'Zakup'
          'Sprzeda'#380)
      end
      object CDateTime: TCDateTime
        Left = 80
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
      Top = 328
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
      Top = 96
      Width = 505
      Height = 217
      Caption = ' Szczeg'#243#322'y operacji '
      TabOrder = 1
      object Label4: TLabel
        Left = 36
        Top = 33
        Width = 76
        Height = 13
        Alignment = taRightJustify
        Caption = 'Konto inwestycji'
      end
      object Label1: TLabel
        Left = 279
        Top = 33
        Width = 49
        Height = 13
        Alignment = taRightJustify
        Caption = 'Instrument'
      end
      object Label15: TLabel
        Left = 306
        Top = 69
        Width = 22
        Height = 13
        Alignment = taRightJustify
        Caption = 'Ilo'#347#263
      end
      object Label2: TLabel
        Left = 38
        Top = 69
        Width = 74
        Height = 13
        Alignment = taRightJustify
        Caption = 'W/g notowania'
      end
      object Label6: TLabel
        Left = 258
        Top = 105
        Width = 71
        Height = 13
        Alignment = taRightJustify
        Caption = 'Warto'#347#263' jednej'
      end
      object Label9: TLabel
        Left = 234
        Top = 141
        Width = 94
        Height = 13
        Alignment = taRightJustify
        Caption = 'Warto'#347#263' wszystkich'
      end
      object Label8: TLabel
        Left = 19
        Top = 177
        Width = 93
        Height = 13
        Alignment = taRightJustify
        Caption = 'Kategoria inwestycji'
      end
      object CStaticAccount: TCStatic
        Left = 120
        Top = 29
        Width = 145
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
      object CStaticInstrument: TCStatic
        Left = 336
        Top = 29
        Width = 145
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz z listy>'
        Color = clWindow
        ParentColor = False
        TabOrder = 1
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz z listy>'
        HotTrack = True
      end
      object CCurrEditOnceQuantity: TCCurrEdit
        Tag = 1
        Left = 336
        Top = 65
        Width = 145
        Height = 21
        BorderStyle = bsNone
        TabOrder = 2
        Decimals = 2
        ThousandSep = True
        CurrencyStr = 'z'#322
        BevelKind = bkTile
        WithCalculator = True
      end
      object CStatic1: TCStatic
        Left = 120
        Top = 65
        Width = 145
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz z listy>'
        Color = clWindow
        ParentColor = False
        TabOrder = 3
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz z listy>'
        HotTrack = True
      end
      object CCurrEditValue: TCCurrEdit
        Tag = 1
        Left = 336
        Top = 101
        Width = 145
        Height = 21
        BorderStyle = bsNone
        TabOrder = 4
        Decimals = 4
        ThousandSep = True
        CurrencyStr = 'z'#322
        BevelKind = bkTile
        WithCalculator = True
      end
      object CCurrEditInoutOnceMovement: TCCurrEdit
        Left = 336
        Top = 137
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
      object CStaticInoutOnceCategory: TCStatic
        Left = 120
        Top = 173
        Width = 361
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz kategori'#281' z listy>'
        Color = clWindow
        ParentColor = False
        TabOrder = 6
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz kategori'#281' z listy>'
        HotTrack = True
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 508
    Width = 538
    inherited BitBtnOk: TBitBtn
      Left = 361
    end
    inherited BitBtnCancel: TBitBtn
      Left = 449
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
