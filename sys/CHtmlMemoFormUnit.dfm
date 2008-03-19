inherited CHtmlMemoForm: TCHtmlMemoForm
  Left = 295
  Top = 137
  Caption = 'CHtmlMemoForm'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    DesignSize = (
      591
      384)
    object Panel1: TPanel
      Left = 4
      Top = 4
      Width = 583
      Height = 376
      Anchors = [akLeft, akTop, akRight, akBottom]
      BevelOuter = bvLowered
      TabOrder = 0
      object Panel2: TPanel
        Left = 1
        Top = 1
        Width = 581
        Height = 374
        Align = alClient
        Caption = 'Panel2'
        TabOrder = 0
        object CBrowser: TCBrowser
          Left = 1
          Top = 1
          Width = 579
          Height = 372
          Align = alClient
          TabOrder = 0
          OnDocumentComplete = CBrowserDocumentComplete
          AutoVSize = True
          ControlData = {
            4C0000000C3C0000C41D00000000000000000000000000000000000000000000
            000000004C000000000000000000000001000000E0D057007335CF11AE690800
            2B2E126202000000000000004C0000000114020000000000C000000000000046
            8000000000000000000000000000000000000000000000000000000000000000
            00000000000000000100000000000000000000000000000000000000}
        end
      end
    end
  end
end
