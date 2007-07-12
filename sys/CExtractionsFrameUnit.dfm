inherited CExtractionsFrame: TCExtractionsFrame
  inherited List: TCDataList
    Header.MainColumn = 0
    Columns = <
      item
        Position = 0
        Width = 100
        WideText = 'Data wyci'#261'gu'
      end
      item
        Position = 1
        Width = 250
        WideText = 'Opis'
      end
      item
        Position = 2
        Width = 100
        WideText = 'Za okres od'
      end
      item
        Position = 3
        Width = 100
        WideText = 'Za okres do'
      end
      item
        Position = 4
        Width = 100
        WideText = 'Status'
      end>
    WideDefaultText = ''
  end
  inherited ImageList: TPngImageList
    Left = 144
    Top = 96
  end
  inherited ListPopupMenu: TPopupMenu
    Left = 280
    Top = 112
  end
end
