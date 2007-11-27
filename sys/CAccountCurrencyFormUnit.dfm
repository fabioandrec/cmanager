inherited CAccountCurrencyForm: TCAccountCurrencyForm
  Left = 290
  Top = 174
  Caption = 'Regu'#322'y przelicze'#324' walut'
  ClientHeight = 283
  ClientWidth = 477
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 477
    Height = 242
    object GroupBox1: TGroupBox
      Left = 16
      Top = 16
      Width = 441
      Height = 73
      Caption = ' Dla nast'#281'puj'#261'cej czynno'#347'ci '
      TabOrder = 0
      object Label7: TLabel
        Left = 30
        Top = 32
        Width = 18
        Height = 13
        Alignment = taRightJustify
        Caption = 'Typ'
      end
      object ComboBoxType: TComboBox
        Left = 56
        Top = 28
        Width = 361
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 0
        Text = 'Aktywne'
        OnChange = ComboBoxTypeChange
        Items.Strings = (
          'Aktywne'
          'Wy'#322#261'czone')
      end
    end
    object GroupBox2: TGroupBox
      Left = 16
      Top = 108
      Width = 441
      Height = 109
      Caption = ' Przeliczaj waluty za pomoc'#261' '
      TabOrder = 1
      object Label1: TLabel
        Left = 27
        Top = 32
        Width = 21
        Height = 13
        Alignment = taRightJustify
        Caption = 'Kurs'
      end
      object Label4: TLabel
        Left = 175
        Top = 32
        Width = 19
        Height = 13
        Alignment = taRightJustify
        Caption = 'w/g'
      end
      object Label2: TLabel
        Left = 28
        Top = 72
        Width = 20
        Height = 13
        Alignment = taRightJustify
        Caption = 'U'#380'yj'
      end
      object ComboBoxRate: TComboBox
        Left = 56
        Top = 28
        Width = 105
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 0
        Text = #346'redni'
        OnChange = ComboBoxRateChange
        Items.Strings = (
          #346'redni'
          'Kupna'
          'Sprzeda'#380'y')
      end
      object CStaticBank: TCStatic
        Left = 204
        Top = 28
        Width = 213
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
        OnChanged = CStaticBankChanged
        HotTrack = True
      end
      object ComboBoxUseOld: TComboBox
        Left = 56
        Top = 68
        Width = 361
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 2
        Text = 'Kurs obowi'#261'zuj'#261'cy dla dnia operacji'
        OnChange = ComboBoxUseOldChange
        Items.Strings = (
          'Kurs obowi'#261'zuj'#261'cy dla dnia operacji'
          'Kurs z dowolnego wcze'#347'niejszego dnia')
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 242
    Width = 477
    inherited BitBtnOk: TBitBtn
      Left = 300
    end
    inherited BitBtnCancel: TBitBtn
      Left = 388
    end
  end
end
