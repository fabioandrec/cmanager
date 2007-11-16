inherited CChoosePeriodForm: TCChoosePeriodForm
  Left = 328
  Top = 258
  Caption = 'Parametry raportu'
  ClientHeight = 282
  ClientWidth = 368
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 368
    Height = 241
    object GroupBox1: TGroupBox
      Left = 16
      Top = 16
      Width = 337
      Height = 121
      Caption = ' Zakres dat '
      TabOrder = 0
      object Label5: TLabel
        Left = 31
        Top = 36
        Width = 33
        Height = 13
        Alignment = taRightJustify
        Caption = 'Rodzaj'
      end
      object Label1: TLabel
        Left = 29
        Top = 76
        Width = 35
        Height = 13
        Alignment = taRightJustify
        Caption = 'od daty'
      end
      object Label2: TLabel
        Left = 177
        Top = 76
        Width = 35
        Height = 13
        Alignment = taRightJustify
        Caption = 'do daty'
      end
      object ComboBoxPredefined: TComboBox
        Left = 72
        Top = 32
        Width = 233
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 3
        TabOrder = 0
        Text = 'w tym miesi'#261'cu'
        OnChange = ComboBoxPredefinedChange
        Items.Strings = (
          'dowolny'
          'tylko dzi'#347
          'w tym tygodni'
          'w tym miesi'#261'cu'
          'w tym kwartale'
          'w tym p'#243#322'roczu'
          'w tym roku'
          'ostatnie 7 dni'
          'ostatnie 14 dni'
          'ostatnie 30 dni')
      end
      object CDateTime1: TCDateTime
        Left = 72
        Top = 72
        Width = 89
        Height = 21
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz dat'#281'>'
        Color = clWindow
        ParentColor = False
        TabOrder = 1
        TabStop = True
        Transparent = False
        HotTrack = True
        Withtime = False
      end
      object CDateTime2: TCDateTime
        Left = 219
        Top = 72
        Width = 86
        Height = 21
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz dat'#281'>'
        Color = clWindow
        ParentColor = False
        TabOrder = 2
        TabStop = True
        Transparent = False
        HotTrack = True
        Withtime = False
      end
    end
    object GroupBoxView: TGroupBox
      Left = 16
      Top = 152
      Width = 337
      Height = 81
      Caption = ' Wy'#347'wietlanie  '
      TabOrder = 1
      object LabelView: TLabel
        Left = 24
        Top = 37
        Width = 40
        Height = 13
        Alignment = taRightJustify
        Caption = 'Kwoty w'
      end
      object CStaticCurrencyView: TCStatic
        Left = 72
        Top = 33
        Width = 233
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<waluta operacji>'
        Color = clWindow
        ParentColor = False
        TabOrder = 0
        TabStop = True
        Transparent = False
        DataId = 'M'
        TextOnEmpty = '<brak aktywnego filtru>'
        OnGetDataId = CStaticCurrencyViewGetDataId
        HotTrack = True
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 241
    Width = 368
    DesignSize = (
      368
      41)
    inherited BitBtnOk: TBitBtn
      Left = 191
    end
    inherited BitBtnCancel: TBitBtn
      Left = 279
    end
  end
end
