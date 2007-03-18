inherited CLimitsFrame: TCLimitsFrame
  inherited FilterPanel: TPanel
    inherited CStaticFilter: TCStatic
      OnChanged = nil
    end
  end
  inherited List: TCDataList
    Header.MainColumn = 0
    Columns = <
      item
        Position = 0
        Width = 443
        WideText = 'Nazwa'
      end>
    WideDefaultText = ''
  end
  inherited ImageList: TPngImageList
    Left = 24
    Top = 64
  end
  inherited ListPopupMenu: TPopupMenu
    Left = 80
    Top = 80
  end
end
