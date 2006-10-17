inherited CReportForm: TCReportForm
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
  end
end
