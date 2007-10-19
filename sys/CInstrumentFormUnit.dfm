inherited CInstrumentForm: TCInstrumentForm
  Caption = 'Instrument inwestycyjny'
  ClientHeight = 458
  ClientWidth = 380
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 380
    Height = 417
    object GroupBoxAccountType: TGroupBox
      Left = 16
      Top = 16
      Width = 345
      Height = 265
      Caption = ' Dane podstawowe  '
      TabOrder = 0
      object Label6: TLabel
        Left = 15
        Top = 36
        Width = 33
        Height = 13
        Alignment = taRightJustify
        Caption = 'Rodzaj'
      end
      object CButton1: TCButton
        Left = 175
        Top = 70
        Width = 154
        Height = 25
        Cursor = crHandPoint
        PicPosition = ppLeft
        PicOffset = 10
        TxtOffset = 15
        Framed = False
        Color = clBtnFace
      end
      object Label1: TLabel
        Left = 15
        Top = 116
        Width = 33
        Height = 13
        Alignment = taRightJustify
        Caption = 'Nazwa'
      end
      object Label2: TLabel
        Left = 27
        Top = 152
        Width = 21
        Height = 13
        Alignment = taRightJustify
        Caption = 'Opis'
      end
      object Label3: TLabel
        Left = 14
        Top = 76
        Width = 34
        Height = 13
        Alignment = taRightJustify
        Caption = 'Symbol'
      end
      object ComboBoxType: TComboBox
        Left = 56
        Top = 32
        Width = 265
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 0
        Text = 'Indeks gie'#322'dowy'
        OnChange = ComboBoxTypeChange
        Items.Strings = (
          'Indeks gie'#322'dowy'
          'Akcje'
          'Obligacje'
          'Fundusz inwestycyjny'
          'Nieokre'#347'lony')
      end
      object EditName: TEdit
        Left = 56
        Top = 112
        Width = 265
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 40
        TabOrder = 2
      end
      object RichEditDesc: TCRichedit
        Left = 56
        Top = 152
        Width = 265
        Height = 89
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 3
      end
      object EditSymbol: TEdit
        Left = 56
        Top = 72
        Width = 265
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 40
        TabOrder = 1
      end
    end
    object GroupBoxBank: TGroupBox
      Left = 16
      Top = 296
      Width = 345
      Height = 113
      Caption = ' Dane dodatkowe '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      object Label4: TLabel
        Left = 16
        Top = 31
        Width = 80
        Height = 13
        Alignment = taRightJustify
        Caption = 'Miejsce notowa'#324
      end
      object Label5: TLabel
        Left = 18
        Top = 72
        Width = 78
        Height = 13
        Alignment = taRightJustify
        Caption = 'Waluta notowa'#324
      end
      object CStaticBank: TCStatic
        Left = 104
        Top = 28
        Width = 217
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz prowadz'#261'cego z listy>'
        Color = clWindow
        ParentColor = False
        TabOrder = 0
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz prowadz'#261'cego z listy>'
        OnGetDataId = CStaticBankGetDataId
        HotTrack = True
      end
      object CStaticCurrency: TCStatic
        Left = 104
        Top = 68
        Width = 217
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz walut'#281' z listy>'
        Color = clWindow
        ParentColor = False
        TabOrder = 1
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz walut'#281' z listy>'
        OnGetDataId = CStaticCurrencyGetDataId
        HotTrack = True
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 417
    Width = 380
    inherited BitBtnOk: TBitBtn
      Left = 203
    end
    inherited BitBtnCancel: TBitBtn
      Left = 291
    end
  end
end
