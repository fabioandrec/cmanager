inherited CInfoForm: TCInfoForm
  Left = 273
  Top = 242
  Caption = 'InfoForm'
  ClientHeight = 471
  ClientWidth = 774
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TCPanel
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
  inherited PanelButtons: TCPanel
    Top = 430
    Width = 774
    inherited BitBtnOk: TBitBtn
      Left = 597
    end
    inherited BitBtnCancel: TBitBtn
      Left = 685
    end
    object CheckBoxAlways: TCheckBox
      Left = 8
      Top = 13
      Width = 153
      Height = 17
      Caption = 'Zastosuj ten wyb'#243'r zawsze'
      TabOrder = 2
    end
  end
end