inherited CExtractionItemForm: TCExtractionItemForm
  Top = 158
  Caption = 'Operacja'
  ClientHeight = 385
  ClientWidth = 460
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 460
    Height = 344
    object GroupBox2: TGroupBox
      Left = 16
      Top = 167
      Width = 425
      Height = 169
      Caption = ' Opis '
      TabOrder = 1
      object CButton1: TCButton
        Left = 158
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
        Left = 276
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
        Width = 377
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
    object GroupBox1: TGroupBox
      Left = 16
      Top = 16
      Width = 425
      Height = 137
      Caption = ' Dane podstawowe '
      TabOrder = 0
      object Label3: TLabel
        Left = 33
        Top = 28
        Width = 63
        Height = 13
        Alignment = taRightJustify
        Caption = 'Data operacji'
      end
      object Label5: TLabel
        Left = 23
        Top = 62
        Width = 73
        Height = 13
        Alignment = taRightJustify
        Caption = 'Rodzaj operacji'
      end
      object Label20: TLabel
        Left = 62
        Top = 96
        Width = 34
        Height = 13
        Alignment = taRightJustify
        Caption = 'Waluta'
      end
      object Label1: TLabel
        Left = 266
        Top = 97
        Width = 30
        Height = 13
        Alignment = taRightJustify
        Caption = 'Kwota'
      end
      object Label2: TLabel
        Left = 211
        Top = 28
        Width = 85
        Height = 13
        Alignment = taRightJustify
        Caption = 'Data ksi'#281'gowania'
      end
      object ComboBoxType: TComboBox
        Left = 104
        Top = 58
        Width = 297
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 2
        Text = 'Obci'#261#380'enie'
        OnChange = ComboBoxTypeChange
        Items.Strings = (
          'Obci'#261#380'enie'
          'Uznanie')
      end
      object CDateTime: TCDateTime
        Left = 104
        Top = 24
        Width = 97
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
        Withtime = False
      end
      object CStaticMovementCurrency: TCStatic
        Left = 104
        Top = 93
        Width = 97
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz walut'#281'>'
        Color = clWindow
        ParentColor = False
        TabOrder = 3
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz walut'#281'>'
        OnGetDataId = CStaticMovementCurrencyGetDataId
        OnChanged = CStaticMovementCurrencyChanged
        HotTrack = True
      end
      object CCurrEditMovement: TCCurrEdit
        Left = 304
        Top = 93
        Width = 97
        Height = 21
        BorderStyle = bsNone
        TabOrder = 4
        Decimals = 2
        ThousandSep = True
        CurrencyStr = 'z'#322
        BevelKind = bkTile
        WithCalculator = True
      end
      object CDateTimeAcc: TCDateTime
        Left = 304
        Top = 24
        Width = 97
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz dat'#281'>'
        Color = clWindow
        ParentColor = False
        TabOrder = 1
        TabStop = True
        Transparent = False
        OnChanged = CDateTimeAccChanged
        HotTrack = True
        Withtime = False
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 344
    Width = 460
    inherited BitBtnOk: TBitBtn
      Left = 283
    end
    inherited BitBtnCancel: TBitBtn
      Left = 371
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
