inherited CInfoForm: TCInfoForm
  Left = 359
  Top = 355
  Caption = 'InfoForm'
  ClientHeight = 190
  ClientWidth = 501
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 501
    Height = 149
    object Image: TImage
      Left = 16
      Top = 16
      Width = 32
      Height = 32
    end
    object LabelInfo: TLabel
      Left = 60
      Top = 16
      Width = 44
      Height = 13
      Caption = 'LabelInfo'
    end
  end
  inherited PanelButtons: TPanel
    Top = 149
    Width = 501
    inherited BitBtnOk: TBitBtn
      Left = 324
    end
    inherited BitBtnCancel: TBitBtn
      Left = 412
    end
  end
end
