inherited CDescpatternForm: TCDescpatternForm
  Left = 363
  Top = 371
  Caption = 'Szablon opisu'
  ClientHeight = 298
  ClientWidth = 540
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 540
    Height = 257
    object GroupBox1: TGroupBox
      Left = 16
      Top = 16
      Width = 505
      Height = 73
      Caption = ' Dla nast'#281'puj'#261'cych czynno'#347'ci '
      TabOrder = 0
      object Label5: TLabel
        Left = 18
        Top = 32
        Width = 46
        Height = 13
        Alignment = taRightJustify
        Caption = 'Czynno'#347#263
      end
      object Label7: TLabel
        Left = 278
        Top = 32
        Width = 18
        Height = 13
        Alignment = taRightJustify
        Caption = 'Typ'
      end
      object ComboBoxOperation: TComboBox
        Left = 72
        Top = 28
        Width = 193
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 0
        Text = 'Operacje wykonane'
        OnChange = ComboBoxOperationChange
        Items.Strings = (
          'Operacje wykonane'
          'Listy operacji wykonanych'
          'Operacje zaplanowane')
      end
      object ComboBoxType: TComboBox
        Left = 304
        Top = 28
        Width = 177
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 1
        Text = 'Aktywne'
        OnChange = ComboBoxTypeChange
        Items.Strings = (
          'Aktywne'
          'Wy'#322#261'czone')
      end
    end
    object GroupBox2: TGroupBox
      Left = 16
      Top = 106
      Width = 505
      Height = 137
      Caption = ' Definicja '
      TabOrder = 1
      object RichEditDesc: TRichEdit
        Left = 24
        Top = 28
        Width = 457
        Height = 89
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 0
        OnChange = RichEditDescChange
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 257
    Width = 540
    inherited BitBtnOk: TBitBtn
      Left = 363
    end
    inherited BitBtnCancel: TBitBtn
      Left = 451
    end
  end
end
