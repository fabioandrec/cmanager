inherited CChoosePeriodAccountListGroupForm: TCChoosePeriodAccountListGroupForm
  Left = 487
  Top = 378
  ClientHeight = 377
  ClientWidth = 369
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 369
    Height = 336
    object GroupBox3: TGroupBox
      Left = 16
      Top = 248
      Width = 337
      Height = 81
      Caption = ' Grupowanie '
      TabOrder = 2
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
    Top = 336
    Width = 369
    inherited BitBtnOk: TBitBtn
      Left = 192
    end
    inherited BitBtnCancel: TBitBtn
      Left = 280
    end
  end
end
