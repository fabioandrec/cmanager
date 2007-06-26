inherited CFrameForm: TCFrameForm
  Left = 220
  Top = 174
  Caption = 'CFrameForm'
  ClientHeight = 621
  ClientWidth = 877
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 877
    Height = 580
    object PanelFrame: TPanel
      Left = 2
      Top = 2
      Width = 873
      Height = 571
      Anchors = [akLeft, akTop, akRight, akBottom]
      BevelOuter = bvLowered
      TabOrder = 0
    end
  end
  inherited PanelButtons: TPanel
    Top = 580
    Width = 877
    inherited BitBtnOk: TBitBtn
      Left = 700
    end
    inherited BitBtnCancel: TBitBtn
      Left = 788
    end
  end
end
