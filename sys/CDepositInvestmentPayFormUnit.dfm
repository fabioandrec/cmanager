inherited CDepositInvestmentPayForm: TCDepositInvestmentPayForm
  Left = 211
  Top = 209
  Caption = 'CDepositInvestmentPayForm'
  ClientWidth = 626
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 626
    object GroupBox1: TGroupBox
      Left = 16
      Top = 16
      Width = 593
      Height = 101
      Caption = ' Dane podstawowe '
      TabOrder = 0
      object Label3: TLabel
        Left = 57
        Top = 28
        Width = 63
        Height = 13
        Alignment = taRightJustify
        Caption = 'Data operacji'
      end
      object Label2: TLabel
        Left = 56
        Top = 64
        Width = 64
        Height = 13
        Alignment = taRightJustify
        Caption = 'Nazwa lokaty'
      end
      object Label12: TLabel
        Left = 255
        Top = 28
        Width = 73
        Height = 13
        Alignment = taRightJustify
        Caption = 'Rodzaj operacji'
      end
      object CDateTime: TCDateTime
        Left = 128
        Top = 24
        Width = 89
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz dat'#281' >'
        Color = clWindow
        ParentColor = False
        TabOrder = 0
        TabStop = True
        Transparent = False
        HotTrack = True
        Withtime = False
      end
      object EditName: TEdit
        Left = 128
        Top = 60
        Width = 441
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        Enabled = False
        MaxLength = 40
        TabOrder = 2
      end
      object ComboBoxType: TComboBox
        Left = 336
        Top = 24
        Width = 233
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 1
        Text = 'Dop'#322'ata do lokaty'
        Items.Strings = (
          'Dop'#322'ata do lokaty'
          'Likwidacja lokaty'
          'Wyp'#322'ata odsetek'
          'Wyp'#322'ata kapita'#322'u')
      end
    end
  end
  inherited PanelButtons: TPanel
    Width = 626
    inherited BitBtnOk: TBitBtn
      Left = 449
    end
    inherited BitBtnCancel: TBitBtn
      Left = 537
    end
  end
end
