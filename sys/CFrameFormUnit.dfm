inherited CFrameForm: TCFrameForm
  Left = 295
  Top = 184
  Caption = 'CFrameForm'
  ClientHeight = 621
  ClientWidth = 877
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TCPanel
    Width = 877
    Height = 580
    DesignSize = (
      877
      580)
    object PanelBase: TCPanel
      Left = 2
      Top = 2
      Width = 873
      Height = 576
      Anchors = [akLeft, akTop, akRight, akBottom]
      BevelOuter = bvNone
      TabOrder = 0
      object PanelTopInfo: TCPanel
        Left = 0
        Top = 0
        Width = 873
        Height = 41
        Align = alTop
        Alignment = taLeftJustify
        BevelOuter = bvNone
        TabOrder = 0
        object LabelTopPanelInfo: TLabel
          Left = 16
          Top = 12
          Width = 9
          Height = 13
          Caption = '...'
        end
      end
      object PanelBottomInfo: TCPanel
        Left = 0
        Top = 535
        Width = 873
        Height = 41
        Align = alBottom
        Alignment = taLeftJustify
        BevelOuter = bvNone
        TabOrder = 1
        object LabelBottomPanelInfo: TLabel
          Left = 856
          Top = 12
          Width = 9
          Height = 13
          Alignment = taRightJustify
          Caption = '...'
        end
      end
      object PanelFrame: TCPanel
        Left = 0
        Top = 41
        Width = 873
        Height = 494
        Align = alClient
        BevelOuter = bvLowered
        TabOrder = 2
        object BevelBottom: TBevel
          Left = 1
          Top = 492
          Width = 871
          Height = 1
          Align = alBottom
          Shape = bsTopLine
        end
        object Bevel1: TBevel
          Left = 871
          Top = 1
          Width = 1
          Height = 491
          Align = alRight
          Shape = bsRightLine
          Style = bsRaised
        end
      end
    end
  end
  inherited PanelButtons: TCPanel
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