inherited CCurrencydefFrame: TCCurrencydefFrame
  Width = 529
  inherited Bevel: TBevel
    Width = 529
  end
  inherited FilterPanel: TPanel
    Width = 529
  end
  inherited List: TCDataList
    Width = 529
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
        Width = 229
        WideText = 'Iso'
      end>
    WideDefaultText = ''
  end
  inherited ButtonPanel: TPanel
    Width = 529
  end
end
