inherited CChooseDateForm: TCChooseDateForm
  Left = 362
  Top = 400
  Caption = 'Parametry raportu'
  ClientHeight = 190
  ClientWidth = 511
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 511
    Height = 149
    object GroupBox1: TGroupBox
      Left = 16
      Top = 16
      Width = 471
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
        Left = 249
        Top = 76
        Width = 35
        Height = 13
        Alignment = taRightJustify
        Caption = 'do daty'
      end
      object ComboBoxPredefined: TComboBox
        Left = 72
        Top = 32
        Width = 369
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
        Width = 150
        Height = 21
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz dat'#281'>'
        Color = clWindow
        ParentColor = False
        TabOrder = 1
        HotTrack = True
      end
      object CDateTime2: TCDateTime
        Left = 291
        Top = 72
        Width = 150
        Height = 21
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz dat'#281'>'
        Color = clWindow
        ParentColor = False
        TabOrder = 2
        HotTrack = True
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 149
    Width = 511
    inherited BitBtnOk: TBitBtn
      Left = 334
    end
    inherited BitBtnCancel: TBitBtn
      Left = 422
    end
  end
end
