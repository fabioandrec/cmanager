inherited CInvestmentPortfolioFrame: TCInvestmentPortfolioFrame
  inherited List: TCDataList
    Header.MainColumn = 0
    Columns = <
      item
        Position = 0
        Width = 150
        WideText = 'Konto'
      end
      item
        Position = 1
        Width = 150
        WideText = 'Instrument'
      end
      item
        Alignment = taRightJustify
        Position = 2
        Width = 75
        WideText = 'Ilo'#347#263
      end
      item
        Alignment = taRightJustify
        Position = 3
        Width = 150
        WideText = 'Aktualna warto'#347#263
      end
      item
        Position = 4
        Width = 10
        WideText = 'Waluta'
      end>
    WideDefaultText = ''
  end
end
