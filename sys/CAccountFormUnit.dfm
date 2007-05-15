inherited CAccountForm: TCAccountForm
  Left = 405
  Top = 223
  Caption = 'Konto'
  ClientHeight = 479
  ClientWidth = 370
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 370
    Height = 438
    object GroupBoxAccountType: TGroupBox
      Left = 16
      Top = 16
      Width = 337
      Height = 73
      Caption = ' Rodzaj konta '
      TabOrder = 0
      object ComboBoxType: TComboBox
        Left = 24
        Top = 31
        Width = 289
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
    end
    object GroupBox2: TGroupBox
      Left = 16
      Top = 104
      Width = 337
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
        Left = 45
        Top = 172
        Width = 91
        Height = 13
        Alignment = taRightJustify
        Caption = #346'rodki pocz'#261'tkowe'
      end
      object EditName: TEdit
        Left = 56
        Top = 28
        Width = 257
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 40
        TabOrder = 0
      end
      object RichEditDesc: TRichEdit
        Left = 56
        Top = 64
        Width = 257
        Height = 89
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 1
      end
      object CCurrEditCash: TCCurrEdit
        Left = 144
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
    object GroupBoxBank: TGroupBox
      Left = 16
      Top = 328
      Width = 337
      Height = 105
      Caption = ' Dane dodatkowe '
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
        Width = 205
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 40
        TabOrder = 0
      end
      object CStaticBank: TCStatic
        Left = 108
        Top = 64
        Width = 205
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz prowadz'#261'cego z listy>'
        Color = clWindow
        ParentColor = False
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
    Top = 438
    Width = 370
    inherited BitBtnOk: TBitBtn
      Left = 193
    end
    inherited BitBtnCancel: TBitBtn
      Left = 281
    end
  end
end
