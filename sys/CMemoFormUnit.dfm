inherited CMemoForm: TCMemoForm
  Left = 343
  Top = 221
  BorderStyle = bsSizeable
  Caption = 'ReportForm'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    DesignSize = (
      593
      398)
    object RichEdit: TRichEdit
      Left = 4
      Top = 5
      Width = 585
      Height = 390
      TabStop = False
      Anchors = [akLeft, akTop, akRight, akBottom]
      BevelKind = bkTile
      BorderStyle = bsNone
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 0
      WordWrap = False
    end
  end
  inherited PanelButtons: TPanel
    object SpeedButton1: TSpeedButton [0]
      Left = 16
      Top = 8
      Width = 25
      Height = 25
      Flat = True
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000120B0000120B00000000000000000000FF00FFFF00FF
        FF00FFFF00FFCD8376DAA7A0FF00FFFF00FFE1C6B6D6AF99D2AB97FF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFD28575F1C9BFE29F95C2776CD6
        A794F0DDD1FEFEFEF6E9E7D3AE9BC89F88FF00FFFF00FFFF00FFFF00FFDFAA9D
        D88B79FDECE4FEF3EDFEDBD1DBAB9AECD7CBFEFEFEFEFEFEFDF8FBFBF3F6EDDD
        DCD3AEA0C08F76FF00FFDFA18EE8A490FEE9E1FBE1DBF1C6C2F1C3BDE7BBB2DD
        AFA2DDB9ACE7D0C5F9F1EEFBF3F6F5E9EBF5E9EDDCBEB3C3947BD88266FEE4DD
        F7D0C9F1C2BCF7D7D1F3D5CFF3CAC4E9B9B6E0AEA6D39F92C89685D3AE9EE6D0
        CACA9585C4907EFF00FFDC8A6DF8CCC5F3C0B8FDD7D0FEF2F0FEF7F6FDEDE8F9
        E1DCF1CEC9E8BBB8E2B0A9C88D83B77A66C6957AC98C87FF00FFDC8569FCC9C3
        FED0C5FEE2C8FEDEAEFEE2C5FEF6F1FEFBFBFEF8F5FDEDE8EED0CCF0C8C5E1B9
        B599A769C88681FF00FFE29B82F3B09AFDECD0FEF1B7FECB76FDB364FBB272FC
        CEA7FEF3E8FEFEFEFEFEFEFDF6F3F3E6E2D1AF9BCB8B85FF00FFFF00FFEECDC0
        DEB796FEFBD5FEE7A9FEC473F9A24FF1873AED843FF5AC7BF9DCC6FEFEFEFEFE
        FEDA938DFF00FFFF00FFFF00FFFF00FFE3C8B9FEFCFEFBF0E3FBE3BDFECC86FB
        AE57F38735E25E15E05914EC874DEBB8A2C77D74FF00FFFF00FFFF00FFDFBEAD
        F9F2EEFEFCFDF8F0F3F3E7EBF0DED7F7D6B2FBBB6EE97A2DDA5513CD5524CC7F
        6EFF00FFFF00FFFF00FFFF00FFE4C6B5FEFEFEFDF9F9F9F0F0F3E7E7EEE0E2ED
        DDE2C29278D9A085DFA391FF00FFFF00FFFF00FFFF00FFFF00FFE4C5B4FBF5F1
        FEFEFEFDF8F8F9F0F0F3E7E7F1E2E4DBBDB3CCAA97FF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFE0BBA7F6ECE7FDFBFBFEFEFEFCF5F7F3E8E8F2E6E8C1
        9279FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFE8D1C5
        E0C1B2DEBCADEBD5CEF9F1F5E2CBC2D1AE9BFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFDABDAEC69C82BB876BFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
      OnClick = SpeedButton1Click
    end
  end
  object PrinterSetupDialog: TPrinterSetupDialog
    Left = 216
    Top = 408
  end
end