inherited CAccountForm: TCAccountForm
  Left = 413
  Top = 169
  Caption = 'Konto'
  ClientHeight = 518
  ClientWidth = 379
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 379
    Height = 477
    object GroupBox2: TGroupBox
      Left = 16
      Top = 144
      Width = 345
      Height = 209
      Caption = ' Dane konta '
      TabOrder = 1
      object Label1: TLabel
        Left = 15
        Top = 32
        Width = 33
        Height = 13
        Alignment = taRightJustify
        Caption = 'Nazwa'
      end
      object Label2: TLabel
        Left = 27
        Top = 68
        Width = 21
        Height = 13
        Alignment = taRightJustify
        Caption = 'Opis'
      end
      object LabelCash: TLabel
        Left = 53
        Top = 172
        Width = 91
        Height = 13
        Alignment = taRightJustify
        Caption = #346'rodki pocz'#261'tkowe'
      end
      object EditName: TEdit
        Left = 56
        Top = 28
        Width = 265
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 40
        TabOrder = 0
      end
      object RichEditDesc: TCRichedit
        Left = 56
        Top = 64
        Width = 265
        Height = 89
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 1
      end
      object CCurrEditCash: TCCurrEdit
        Left = 152
        Top = 168
        Width = 169
        Height = 21
        BorderStyle = bsNone
        TabOrder = 2
        Decimals = 2
        ThousandSep = True
        CurrencyStr = 'z'#322
        BevelKind = bkTile
        WithCalculator = True
      end
    end
    object GroupBoxAccountType: TGroupBox
      Left = 16
      Top = 16
      Width = 345
      Height = 113
      Caption = ' Dane podstawowe  '
      TabOrder = 0
      object Label5: TLabel
        Left = 14
        Top = 76
        Width = 34
        Height = 13
        Alignment = taRightJustify
        Caption = 'Waluta'
      end
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
        Action = Action1
        Color = clBtnFace
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
        TabOrder = 0
        OnChange = ComboBoxTypeChange
        Items.Strings = (
          'Got'#243'wkowe'
          'Rachunek bankowy'
          'Rachunek inwestycyjny')
      end
      object CStaticCurrency: TCStatic
        Left = 56
        Top = 72
        Width = 114
        Height = 21
        Cursor = crHandPoint
        Hint = '<wybierz walut'#281' z listy>'
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz walut'#281' z listy>'
        Color = clWindow
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz walut'#281' z listy>'
        OnGetDataId = CStaticCurrencyGetDataId
        OnChanged = CStaticCurrencyChanged
        HotTrack = True
      end
    end
    object GroupBoxBank: TGroupBox
      Left = 16
      Top = 368
      Width = 345
      Height = 105
      Caption = ' Dane dodatkowe '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      object Label3: TLabel
        Left = 20
        Top = 32
        Width = 79
        Height = 13
        Alignment = taRightJustify
        Caption = 'Numer rachunku'
      end
      object Label4: TLabel
        Left = 40
        Top = 67
        Width = 58
        Height = 13
        Alignment = taRightJustify
        Caption = 'Prowadz'#261'cy'
      end
      object EditNumber: TEdit
        Left = 108
        Top = 28
        Width = 213
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 40
        TabOrder = 0
      end
      object CStaticBank: TCStatic
        Left = 108
        Top = 64
        Width = 213
        Height = 21
        Cursor = crHandPoint
        Hint = '<wybierz prowadz'#261'cego z listy>'
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz prowadz'#261'cego z listy>'
        Color = clWindow
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz prowadz'#261'cego z listy>'
        OnGetDataId = CStaticBankGetDataId
        HotTrack = True
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 477
    Width = 379
    inherited BitBtnOk: TBitBtn
      Left = 202
    end
    inherited BitBtnCancel: TBitBtn
      Left = 290
    end
  end
  object ActionManager: TActionManager
    Images = CImageLists.TemplateImageList16x16
    Left = 40
    Top = 268
    StyleName = 'XP Style'
    object Action1: TAction
      Caption = 'Regu'#322'y przelicze'#324' walut'
      ImageIndex = 2
      OnExecute = Action1Execute
    end
  end
end
