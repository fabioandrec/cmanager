inherited CParamDefForm: TCParamDefForm
  Caption = 'Parametr'
  ClientHeight = 151
  ClientWidth = 522
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 522
    Height = 110
    object GroupBox1: TGroupBox
      Left = 16
      Top = 16
      Width = 489
      Height = 81
      Caption = ' Dane podstawowe '
      TabOrder = 0
      object Label5: TLabel
        Left = 19
        Top = 36
        Width = 29
        Height = 13
        Alignment = taRightJustify
        Caption = 'Grupa'
      end
      object Label1: TLabel
        Left = 239
        Top = 36
        Width = 33
        Height = 13
        Alignment = taRightJustify
        Caption = 'Nazwa'
      end
      object ComboBoxGroup: TComboBox
        Left = 56
        Top = 32
        Width = 169
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        ItemHeight = 13
        TabOrder = 0
      end
      object EditName: TEdit
        Left = 280
        Top = 32
        Width = 177
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 40
        TabOrder = 1
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 110
    Width = 522
    inherited BitBtnOk: TBitBtn
      Left = 345
    end
    inherited BitBtnCancel: TBitBtn
      Left = 433
    end
  end
end
