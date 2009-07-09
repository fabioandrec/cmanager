inherited CChoosePeriodYearFilterForm: TCChoosePeriodYearFilterForm
  Caption = 'CChoosePeriodYearFilterForm'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TCPanel
    inherited GroupBox1: TGroupBox
      inherited CDateTime1: TCDateTime
        Caption = '<wybierz rok>'
        DateTimeFormat = 'yyyy'
        TextOnEmpty = '<wybierz rok>'
      end
      inherited CDateTime2: TCDateTime
        Caption = '<wybierz rok>'
        DateTimeFormat = 'yyyy'
        TextOnEmpty = '<wybierz rok>'
      end
    end
  end
end
