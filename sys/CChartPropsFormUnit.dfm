inherited CChartPropsForm: TCChartPropsForm
  Left = 262
  Top = 168
  Caption = 'Wygl'#261'd wykresu'
  ClientHeight = 245
  ClientWidth = 379
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 379
    Height = 204
    object CheckBox3d: TCheckBox
      Left = 16
      Top = 16
      Width = 81
      Height = 17
      Caption = 'Tr'#243'jwymiar'
      TabOrder = 0
    end
    object CheckBoxLeg: TCheckBox
      Left = 16
      Top = 40
      Width = 81
      Height = 17
      Caption = 'Legenda'
      TabOrder = 1
    end
  end
  inherited PanelButtons: TPanel
    Top = 204
    Width = 379
    inherited BitBtnOk: TBitBtn
      Left = 202
    end
    inherited BitBtnCancel: TBitBtn
      Left = 290
    end
  end
end
