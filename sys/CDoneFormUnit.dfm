inherited CDoneForm: TCDoneForm
  Caption = 'Zaplanowana operacja'
  ClientHeight = 502
  ClientWidth = 405
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 405
    Height = 461
    object GroupBox1: TGroupBox
      Left = 16
      Top = 192
      Width = 369
      Height = 65
      Caption = ' Status zaplanowanej operacji '
      TabOrder = 0
      object ComboBoxStatus: TComboBox
        Left = 24
        Top = 24
        Width = 321
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
        OnSelect = ComboBoxStatusSelect
        Items.Strings = (
          'Gotowa do realizacji'
          'Uznana za zrealizowan'#261
          'Odrzucona jako niezasadna')
      end
    end
    object GroupBox2: TGroupBox
      Left = 16
      Top = 275
      Width = 369
      Height = 174
      Caption = ' Opis '
      TabOrder = 1
      object Label3: TLabel
        Left = 23
        Top = 136
        Width = 66
        Height = 13
        Alignment = taRightJustify
        Caption = 'Data realizacji'
      end
      object Label10: TLabel
        Left = 218
        Top = 136
        Width = 30
        Height = 13
        Alignment = taRightJustify
        Caption = 'Kwota'
      end
      object RichEditDesc: TRichEdit
        Left = 24
        Top = 28
        Width = 321
        Height = 89
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 0
      end
      object CDateTime: TCDateTime
        Left = 96
        Top = 132
        Width = 89
        Height = 21
        Cursor = crHandPoint
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
      object CCurrCash: TCCurrEdit
        Left = 256
        Top = 132
        Width = 89
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
    object GroupBox3: TGroupBox
      Left = 16
      Top = 16
      Width = 369
      Height = 161
      Caption = ' Informacje '
      TabOrder = 2
      object Label1: TLabel
        Left = 128
        Top = 124
        Width = 120
        Height = 13
        Alignment = taRightJustify
        Caption = 'Planowana data realizacji'
      end
      object CDateTimePlanned: TCDateTime
        Left = 256
        Top = 120
        Width = 89
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz dat'#281'>'
        Color = clWindow
        Enabled = False
        ParentColor = False
        TabOrder = 0
        TabStop = True
        Transparent = False
        HotTrack = True
      end
      object RichEditOperation: TRichEdit
        Left = 24
        Top = 32
        Width = 321
        Height = 73
        BevelKind = bkTile
        BorderStyle = bsNone
        Enabled = False
        TabOrder = 1
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 461
    Width = 405
    inherited BitBtnOk: TBitBtn
      Left = 228
    end
    inherited BitBtnCancel: TBitBtn
      Left = 316
    end
  end
end
