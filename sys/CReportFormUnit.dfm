inherited CReportForm: TCReportForm
  Left = 268
  Top = 264
  Width = 799
  Height = 638
  BorderIcons = [biSystemMenu, biMaximize]
  BorderStyle = bsSizeable
  Caption = 'CReportForm'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 791
    Height = 570
    BevelOuter = bvLowered
  end
  inherited PanelButtons: TPanel
    Top = 570
    Width = 791
    DesignSize = (
      791
      41)
    inherited BitBtnOk: TBitBtn
      Left = 614
    end
    inherited BitBtnCancel: TBitBtn
      Left = 702
    end
    object BitBtn1: TBitBtn
      Left = 14
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Drukuj'
      TabOrder = 2
      OnClick = BitBtn1Click
    end
    object BitBtn2: TBitBtn
      Left = 102
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Podgl'#261'd'
      TabOrder = 3
      OnClick = BitBtn2Click
    end
  end
end
