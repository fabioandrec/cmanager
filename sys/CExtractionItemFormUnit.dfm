inherited CExtractionItemForm: TCExtractionItemForm
  Left = 400
  Top = 269
  Caption = 'Operacja'
  ClientHeight = 353
  ClientWidth = 512
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 512
    Height = 312
    object GroupBox2: TGroupBox
      Left = 16
      Top = 135
      Width = 481
      Height = 169
      Caption = ' Opis '
      TabOrder = 1
      object CButton1: TCButton
        Left = 206
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
        Left = 324
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
        Width = 425
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
      Width = 481
      Height = 105
      Caption = ' Dane podstawowe '
      TabOrder = 0
      object Label3: TLabel
        Left = 33
        Top = 28
        Width = 23
        Height = 13
        Alignment = taRightJustify
        Caption = 'Data'
      end
      object Label5: TLabel
        Left = 175
        Top = 28
        Width = 33
        Height = 13
        Alignment = taRightJustify
        Caption = 'Rodzaj'
      end
      object Label20: TLabel
        Left = 22
        Top = 64
        Width = 34
        Height = 13
        Alignment = taRightJustify
        Caption = 'Waluta'
      end
      object Label1: TLabel
        Left = 178
        Top = 65
        Width = 30
        Height = 13
        Alignment = taRightJustify
        Caption = 'Kwota'
      end
      object ComboBoxType: TComboBox
        Left = 216
        Top = 24
        Width = 233
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 1
        Text = 'Obci'#261#380'enie'
        OnChange = ComboBoxTypeChange
        Items.Strings = (
          'Obci'#261#380'enie'
          'Uznanie')
      end
      object CDateTime: TCDateTime
        Left = 64
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
      end
      object CStaticMovementCurrency: TCStatic
        Left = 64
        Top = 61
        Width = 97
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
        OnGetDataId = CStaticMovementCurrencyGetDataId
        OnChanged = CStaticMovementCurrencyChanged
        HotTrack = True
      end
      object CCurrEditMovement: TCCurrEdit
        Left = 216
        Top = 61
        Width = 233
        Height = 21
        BorderStyle = bsNone
        TabOrder = 3
        Decimals = 2
        ThousandSep = True
        CurrencyStr = 'z'#322
        BevelKind = bkTile
        WithCalculator = True
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 312
    Width = 512
    inherited BitBtnOk: TBitBtn
      Left = 335
    end
    inherited BitBtnCancel: TBitBtn
      Left = 423
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
