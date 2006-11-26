inherited CInfoForm: TCInfoForm
  Left = 22
  Top = 22
  Caption = 'InfoForm'
  ClientHeight = 471
  ClientWidth = 774
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 774
    Height = 430
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
    Top = 430
    Width = 774
    inherited BitBtnOk: TBitBtn
      Left = 597
    end
    inherited BitBtnCancel: TBitBtn
      Left = 685
    end
  end
end
