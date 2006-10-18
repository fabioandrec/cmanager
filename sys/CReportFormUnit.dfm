inherited CReportForm: TCReportForm
  Left = 126
  Top = 15
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
    object CBrowser: TCBrowser
      Left = 1
      Top = 1
      Width = 789
      Height = 568
      Align = alClient
      TabOrder = 0
      AutoVSize = False
      ControlData = {
        4C000000C1510000E93A00000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E12620A000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
  end
  inherited PanelButtons: TPanel
    Top = 570
    Width = 791
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
