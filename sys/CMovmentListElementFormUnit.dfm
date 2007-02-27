inherited CMovmentListElementForm: TCMovmentListElementForm
  Caption = 'Operacja'
  ClientHeight = 325
  ClientWidth = 539
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 539
    Height = 284
    object GroupBox2: TGroupBox
      Left = 16
      Top = 133
      Width = 505
      Height = 137
      Caption = ' Opis '
      TabOrder = 1
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
    Top = 284
    Width = 539
    inherited BitBtnOk: TBitBtn
      Left = 362
    end
    inherited BitBtnCancel: TBitBtn
      Left = 450
    end
  end
end
