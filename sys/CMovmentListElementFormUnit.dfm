inherited CMovmentListElementForm: TCMovmentListElementForm
  Caption = 'Operacja'
  ClientHeight = 346
  ClientWidth = 539
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 539
    Height = 305
    object GroupBox2: TGroupBox
      Left = 16
      Top = 133
      Width = 505
      Height = 164
      Caption = ' Opis '
      TabOrder = 1
      object CButton1: TCButton
        Left = 14
        Top = 124
        Width = 217
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
        Left = 320
        Top = 124
        Width = 161
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
    end
    object GroupBox3: TGroupBox
      Left = 16
      Top = 16
      Width = 505
      Height = 105
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
      object Label9: TLabel
        Left = 226
        Top = 67
        Width = 30
        Height = 13
        Alignment = taRightJustify
        Caption = 'Kwota'
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
      object CCurrEdit: TCCurrEdit
        Left = 264
        Top = 63
        Width = 209
        Height = 21
        BorderStyle = bsNone
        TabOrder = 1
        Decimals = 2
        ThousandSep = True
        CurrencyStr = 'z'#322
        BevelKind = bkTile
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 305
    Width = 539
    inherited BitBtnOk: TBitBtn
      Left = 362
    end
    inherited BitBtnCancel: TBitBtn
      Left = 450
    end
  end
  object ActionManager: TActionManager
    Images = CImageLists.TemplateImageList16x16
    Left = 56
    Top = 82
    StyleName = 'XP Style'
    object ActionAdd: TAction
      Caption = 'Dodaj mnemonik w wybranym miejscu'
      ImageIndex = 0
      OnExecute = ActionAddExecute
    end
    object ActionTemplate: TAction
      Caption = 'Konfiguruj szablony opis'#243'w'
      ImageIndex = 1
      OnExecute = ActionTemplateExecute
    end
  end
end
