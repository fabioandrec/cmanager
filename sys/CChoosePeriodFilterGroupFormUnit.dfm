inherited CChoosePeriodFilterGroupForm: TCChoosePeriodFilterGroupForm
  Caption = 'CChoosePeriodFilterGroupForm'
  ClientHeight = 475
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Height = 434
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
      object ComboBoxSums: TComboBox
        Left = 72
        Top = 32
        Width = 233
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
    end
  end
  inherited PanelButtons: TPanel
    Top = 434
  end
end
