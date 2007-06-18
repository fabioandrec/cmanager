inherited CChartReportForm: TCChartReportForm
  Left = 221
  Top = 202
  Caption = 'CChartReportForm'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelButtons: TPanel
    inherited CButton3: TCButton
      Left = 76
    end
    object CButton4: TCButton [3]
      Left = 148
      Top = 8
      Width = 77
      Height = 25
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Action = ActionGraph
      Color = clBtnFace
    end
  end
  inherited ActionList: TActionList
    inherited Action2: TAction
      Visible = False
    end
    object ActionGraph: TAction
      Caption = 'Wygl'#261'd'
      ImageIndex = 3
      OnExecute = ActionGraphExecute
    end
  end
  object PrintDialog: TPrintDialog
    Left = 129
    Top = 65
  end
end
