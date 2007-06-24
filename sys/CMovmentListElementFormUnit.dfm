inherited CMovmentListElementForm: TCMovmentListElementForm
  Caption = 'Operacja'
  ClientHeight = 420
  ClientWidth = 538
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 538
    Height = 379
    object GroupBox2: TGroupBox
      Left = 16
      Top = 209
      Width = 505
      Height = 164
      Caption = ' Opis '
      TabOrder = 1
      object CButton1: TCButton
        Left = 238
        Top = 125
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
      object RichEditDesc: TCRichEdit
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
      Top = 16
      Width = 505
      Height = 177
      Caption = ' Szczeg'#243#322'y operacji '
      TabOrder = 0
      object Label2: TLabel
        Left = 59
        Top = 29
        Width = 45
        Height = 13
        Alignment = taRightJustify
        Caption = 'Kategoria'
      end
      object Label20: TLabel
        Left = 30
        Top = 64
        Width = 74
        Height = 13
        Alignment = taRightJustify
        Caption = 'Waluta operacji'
      end
      object Label1: TLabel
        Left = 274
        Top = 65
        Width = 70
        Height = 13
        Alignment = taRightJustify
        Caption = 'Kwota operacji'
      end
      object Label22: TLabel
        Left = 54
        Top = 101
        Width = 50
        Height = 13
        Alignment = taRightJustify
        Caption = 'Przelicznik'
      end
      object Label17: TLabel
        Left = 40
        Top = 136
        Width = 64
        Height = 13
        Alignment = taRightJustify
        Caption = 'Waluta konta'
      end
      object Label21: TLabel
        Left = 234
        Top = 137
        Width = 110
        Height = 13
        Alignment = taRightJustify
        Caption = 'Kwota w walucie konta'
      end
      object CStaticCategory: TCStatic
        Left = 112
        Top = 25
        Width = 361
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz kategori'#281' z listy>'
        Color = clWindow
        ParentColor = False
        TabOrder = 0
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz kategori'#281' z listy>'
        OnGetDataId = CStaticCategoryGetDataId
        OnChanged = CStaticCategoryChanged
        HotTrack = True
      end
      object CStaticMovementCurrency: TCStatic
        Left = 112
        Top = 61
        Width = 97
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz walut'#281'>'
        Color = clWindow
        ParentColor = False
        TabOrder = 1
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz walut'#281'>'
        OnGetDataId = CStaticMovementCurrencyGetDataId
        OnChanged = CStaticMovementCurrencyChanged
        HotTrack = True
      end
      object CCurrEditMovement: TCCurrEdit
        Left = 352
        Top = 61
        Width = 121
        Height = 21
        BorderStyle = bsNone
        TabOrder = 2
        OnChange = CCurrEditMovementChange
        Decimals = 2
        ThousandSep = True
        CurrencyStr = 'z'#322
        BevelKind = bkTile
        WithCalculator = True
      end
      object CStaticRate: TCStatic
        Left = 112
        Top = 97
        Width = 361
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz przelicznik kursu z listy>'
        Color = clWindow
        ParentColor = False
        TabOrder = 3
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz przelicznik kursu z listy>'
        OnGetDataId = CStaticRateGetDataId
        OnChanged = CStaticRateChanged
        HotTrack = True
      end
      object CStaticAccountCurrency: TCStatic
        Left = 112
        Top = 133
        Width = 97
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<brak konta>'
        Color = clWindow
        Enabled = False
        ParentColor = False
        TabOrder = 4
        TabStop = True
        Transparent = False
        TextOnEmpty = '<brak konta>'
        HotTrack = False
      end
      object CCurrEditAccount: TCCurrEdit
        Left = 352
        Top = 133
        Width = 121
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
    end
  end
  inherited PanelButtons: TPanel
    Top = 379
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
    Left = 56
    Top = 82
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