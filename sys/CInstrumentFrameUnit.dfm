inherited CInstrumentFrame: TCInstrumentFrame
  inherited List: TCDataList
    Header.MainColumn = 0
    Columns = <
      item
        Position = 0
        Width = 140
        WideText = 'Symbol'
      end
      item
        Position = 1
        Width = 300
        WideText = 'Nazwa'
      end
      item
        Position = 2
        Width = 10
        WideText = 'Typ'
      end>
    WideDefaultText = ''
  end
  inherited ImageList: TPngImageList
    Left = 24
    Top = 80
  end
  inherited ListPopupMenu: TPopupMenu
    Left = 144
    Top = 128
  end
end
