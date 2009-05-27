inherited CChoosePeriodFilterGroupForm: TCChoosePeriodFilterGroupForm
  Left = 282
  Top = 12
  Caption = 'CChoosePeriodFilterGroupForm'
  ClientHeight = 471
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TCPanel
    Height = 430
    inherited GroupBoxView: TGroupBox
      Top = 344
    end
    object GroupBox3: TGroupBox
      Left = 16
      Top = 248
      Width = 337
      Height = 81
      Caption = ' Grupowanie '
      TabOrder = 3
      object Label3: TLabel
        Left = 38
        Top = 36
        Width = 26
        Height = 13
        Alignment = taRightJustify
        Caption = 'Sumy'
      end
      object Label4: TLabel
        Left = 169
        Top = 36
        Width = 39
        Height = 13
        Alignment = taRightJustify
        Caption = 'Wed'#322'ug'
      end
      object ComboBoxSums: TComboBox
        Left = 72
        Top = 32
        Width = 89
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 0
        Text = 'dzienne'
        OnChange = ComboBoxPredefinedChange
        Items.Strings = (
          'dzienne'
          'tygodniowe '
          'miesi'#281'czne')
      end
      object ComboBoxAcp: TComboBox
        Left = 216
        Top = 32
        Width = 89
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 1
        Text = '<brak>'
        OnChange = ComboBoxPredefinedChange
        Items.Strings = (
          '<brak>'
          'Kont'
          'Kontrahent'#243'w'
          'Kategorii')
      end
    end
  end
  inherited PanelButtons: TCPanel
    Top = 430
  end
end