inherited CMemoForm: TCMemoForm
  Left = 272
  Top = 128
  BorderStyle = bsSizeable
  Caption = 'ReportForm'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    DesignSize = (
      591
      396)
    object RichEdit: TCRichEdit
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
    object CButton1: TCButton [0]
      Left = 8
      Top = 8
      Width = 73
      Height = 25
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Action = Action1
      Color = clBtnFace
    end
  end
  object PrinterSetupDialog: TPrinterSetupDialog
    Left = 216
    Top = 408
  end
  object ActionList: TActionList
    Images = CImageLists.ActionImageList
    Left = 376
    Top = 402
    object Action1: TAction
      Caption = 'Drukuj'
      ImageIndex = 0
      OnExecute = Action1Execute
    end
  end
end