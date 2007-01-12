inherited CChooseFutureFilterForm: TCChooseFutureFilterForm
  Left = 361
  Top = 196
  ClientHeight = 421
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Height = 380
    inherited GroupBox1: TGroupBox
      Caption = ' Zakres dat dla podstawy prognozy  '
    end
    inherited GroupBox2: TGroupBox
      Top = 288
    end
    object GroupBox3: TGroupBox
      Left = 16
      Top = 152
      Width = 337
      Height = 121
      Caption = ' Okres prognozowany   '
      TabOrder = 2
      object Label3: TLabel
        Left = 31
        Top = 36
        Width = 33
        Height = 13
        Alignment = taRightJustify
        Caption = 'Rodzaj'
      end
      object Label4: TLabel
        Left = 29
        Top = 76
        Width = 35
        Height = 13
        Alignment = taRightJustify
        Caption = 'od daty'
      end
      object Label6: TLabel
        Left = 177
        Top = 76
        Width = 35
        Height = 13
        Alignment = taRightJustify
        Caption = 'do daty'
      end
      object ComboBoxFuture: TComboBox
        Left = 72
        Top = 32
        Width = 233
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 1
        TabOrder = 0
        Text = 'przysz'#322'y tydzie'#324
        OnChange = ComboBoxFutureChange
        Items.Strings = (
          'dowolny'
          'przysz'#322'y tydzie'#324
          'przysz'#322'y miesi'#261'c'
          'przysz'#322'y kwarta'#322
          'przysz'#322'e p'#243#322'rocze'
          'przysz'#322'y rok'
          'nast'#281'pne 7 dni'
          'nast'#281'pne 14 dni'
          'nast'#281'pne 30 dni')
      end
      object CDateTime3: TCDateTime
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
      end
      object CDateTime4: TCDateTime
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
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 380
  end
end
