inherited CLimitForm: TCLimitForm
  Left = 217
  Top = 128
  Caption = 'Limit'
  ClientHeight = 436
  ClientWidth = 533
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 533
    Height = 395
    object GroupBox2: TGroupBox
      Left = 16
      Top = 16
      Width = 497
      Height = 177
      Caption = ' Dane podstawowe '
      TabOrder = 0
      object Label1: TLabel
        Left = 175
        Top = 32
        Width = 33
        Height = 13
        Alignment = taRightJustify
        Caption = 'Nazwa'
      end
      object Label2: TLabel
        Left = 27
        Top = 69
        Width = 21
        Height = 13
        Alignment = taRightJustify
        Caption = 'Opis'
      end
      object Label7: TLabel
        Left = 18
        Top = 32
        Width = 30
        Height = 13
        Alignment = taRightJustify
        Caption = 'Status'
      end
      object EditName: TEdit
        Left = 216
        Top = 28
        Width = 257
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 40
        TabOrder = 1
      end
      object RichEditDesc: TRichEdit
        Left = 56
        Top = 65
        Width = 417
        Height = 89
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 2
      end
      object ComboBoxStatus: TComboBox
        Left = 56
        Top = 28
        Width = 97
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 0
        Text = 'Aktywny'
        Items.Strings = (
          'Aktywny'
          'Wy'#322#261'czony')
      end
    end
    object GroupBox1: TGroupBox
      Left = 16
      Top = 208
      Width = 497
      Height = 181
      Caption = ' Definicja limitu '
      TabOrder = 1
      object Label3: TLabel
        Left = 23
        Top = 68
        Width = 89
        Height = 13
        Alignment = taRightJustify
        Caption = 'z operacji w/g filtru'
      end
      object Label6: TLabel
        Left = 52
        Top = 104
        Width = 60
        Height = 13
        Alignment = taRightJustify
        Caption = 'wykonanych'
      end
      object Label4: TLabel
        Left = 305
        Top = 104
        Width = 39
        Height = 13
        Alignment = taRightJustify
        Caption = 'Ilo'#347#263' dni'
      end
      object Label5: TLabel
        Left = 395
        Top = 104
        Width = 78
        Height = 13
        Caption = '(w'#322#261'cznie z dzi'#347')'
      end
      object Label8: TLabel
        Left = 96
        Top = 140
        Width = 16
        Height = 13
        Alignment = taRightJustify
        Caption = 'jest'
      end
      object Label10: TLabel
        Left = 303
        Top = 140
        Width = 43
        Height = 13
        Alignment = taRightJustify
        Caption = 'od kwoty'
      end
      object Label9: TLabel
        Left = 17
        Top = 33
        Width = 94
        Height = 13
        Alignment = taRightJustify
        Caption = 'Przekroczono, je'#380'eli'
      end
      object CStaticFilter: TCStatic
        Left = 120
        Top = 65
        Width = 353
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wszystkie operacje>'
        Color = clWindow
        ParentColor = False
        TabOrder = 1
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wszystkie operacje>'
        OnGetDataId = CStaticFilterGetDataId
        HotTrack = True
      end
      object ComboBoxDays: TComboBox
        Left = 120
        Top = 100
        Width = 161
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 2
        Text = 'Dzi'#347
        OnChange = ComboBoxDaysChange
        Items.Strings = (
          'Dzi'#347
          'W tym tygodniu'
          'W tym miesi'#261'cu'
          'W tym kwartale'
          'W tym p'#243#322'roczu'
          'W tym roku'
          'W ostatnich dniach')
      end
      object CIntEditDays: TCIntEdit
        Left = 352
        Top = 100
        Width = 33
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 3
        Text = '1'
      end
      object ComboBoxCondition: TComboBox
        Left = 120
        Top = 136
        Width = 161
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 4
        Text = 'wieksza'
        OnChange = ComboBoxDaysChange
        Items.Strings = (
          'wieksza'
          'wi'#281'ksza lub r'#243'wna'
          'mniejsza'
          'mniejsza lub r'#243'wna'
          'r'#243'wna')
      end
      object CCurrEditBound: TCCurrEdit
        Left = 352
        Top = 136
        Width = 121
        Height = 21
        BorderStyle = bsNone
        TabOrder = 5
        Decimals = 2
        ThousandSep = True
        CurrencyStr = 'z'#322
        BevelKind = bkTile
      end
      object ComboBoxSum: TComboBox
        Left = 119
        Top = 29
        Width = 354
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 0
        Text = 'Suma rozchod'#243'w'
        OnChange = ComboBoxDaysChange
        Items.Strings = (
          'Suma rozchod'#243'w'
          'Suma przychod'#243'w'
          'Saldo')
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 395
    Width = 533
    inherited BitBtnOk: TBitBtn
      Left = 356
    end
    inherited BitBtnCancel: TBitBtn
      Left = 444
    end
  end
end
