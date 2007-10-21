inherited CInstrumentValueForm: TCInstrumentValueForm
  Caption = 'Notowanie'
  ClientHeight = 356
  ClientWidth = 535
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 535
    Height = 315
    object GroupBox1: TGroupBox
      Left = 16
      Top = 16
      Width = 505
      Height = 105
      Caption = ' Dane podstawowe '
      TabOrder = 0
      object Label3: TLabel
        Left = 19
        Top = 32
        Width = 53
        Height = 13
        Alignment = taRightJustify
        Caption = 'Data i czas'
      end
      object Label1: TLabel
        Left = 239
        Top = 33
        Width = 49
        Height = 13
        Alignment = taRightJustify
        Caption = 'Instrument'
      end
      object Label15: TLabel
        Left = 249
        Top = 69
        Width = 40
        Height = 13
        Alignment = taRightJustify
        Caption = 'Warto'#347#263
      end
      object CDateTime: TCDateTime
        Left = 80
        Top = 28
        Width = 145
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz dat'#281'  i czas>'
        Color = clWindow
        ParentColor = False
        TabOrder = 0
        TabStop = True
        Transparent = False
        OnChanged = CDateTimeChanged
        HotTrack = True
        Withtime = True
      end
      object CStaticInstrument: TCStatic
        Left = 296
        Top = 29
        Width = 185
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
        OnGetDataId = CStaticInstrumentGetDataId
        OnChanged = CStaticInstrumentChanged
        HotTrack = True
      end
      object CCurrEditValue: TCCurrEdit
        Tag = 1
        Left = 296
        Top = 65
        Width = 185
        Height = 21
        BorderStyle = bsNone
        TabOrder = 2
        Decimals = 4
        ThousandSep = True
        CurrencyStr = 'z'#322
        BevelKind = bkTile
        WithCalculator = True
      end
    end
    object GroupBox2: TGroupBox
      Left = 16
      Top = 139
      Width = 505
      Height = 169
      Caption = ' Opis '
      TabOrder = 1
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
  end
  inherited PanelButtons: TPanel
    Top = 315
    Width = 535
    inherited BitBtnOk: TBitBtn
      Left = 358
    end
    inherited BitBtnCancel: TBitBtn
      Left = 446
    end
  end
  object ActionManager: TActionManager
    Images = CImageLists.TemplateImageList16x16
    Left = 40
    Top = 74
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
