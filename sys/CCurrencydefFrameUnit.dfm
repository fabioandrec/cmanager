inherited CCurrencydefFrame: TCCurrencydefFrame
  inherited List: TCDataList
    Header.MainColumn = 0
    Columns = <
      item
        Position = 0
        Width = 200
        WideText = 'Nazwa'
      end
      item
        Position = 1
        Width = 100
        WideText = 'Symbol'
      end
      item
        Position = 2
        Width = 143
        WideText = 'Iso'
      end>
    WideDefaultText = ''
  end
  inherited ActionListButtons: TActionList
    Images = CImageLists.CurrencyDefImageList24x24
  end
end
