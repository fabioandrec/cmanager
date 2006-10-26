inherited CChartReportForm: TCChartReportForm
  Caption = 'CChartReportForm'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    object CChart: TChart
      Left = 1
      Top = 1
      Width = 789
      Height = 568
      BackWall.Brush.Color = clWhite
      BackWall.Brush.Style = bsClear
      Title.Text.Strings = (
        'TChart')
      Align = alClient
      BevelOuter = bvNone
      Color = clWhite
      TabOrder = 0
    end
  end
  inherited PanelButtons: TPanel
    inherited BitBtn2: TBitBtn
      Visible = False
    end
  end
  object PrintDialog: TPrintDialog
    Left = 129
    Top = 65
  end
end
