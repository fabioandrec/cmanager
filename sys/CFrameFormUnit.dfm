inherited CFrameForm: TCFrameForm
  Left = 144
  Top = 47
  Caption = 'CFrameForm'
  ClientHeight = 621
  ClientWidth = 877
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 877
    Height = 580
    DesignSize = (
      877
      580)
    object PanelFrame: TPanel
      Left = 2
      Top = 2
      Width = 873
      Height = 571
      Anchors = [akLeft, akTop, akRight, akBottom]
      BevelOuter = bvLowered
      TabOrder = 0
      object Bevel1: TBevel
        Left = 1
        Top = 568
        Width = 871
        Height = 2
        Align = alBottom
        Shape = bsBottomLine
        Style = bsRaised
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 580
    Width = 877
    DesignSize = (
      877
      41)
    inherited BitBtnOk: TBitBtn
      Left = 700
    end
    inherited BitBtnCancel: TBitBtn
      Left = 788
    end
  end
end
