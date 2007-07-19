inherited CExtractionItemFrame: TCExtractionItemFrame
  inherited List: TCDataList
    Header.MainColumn = 0
    Images = CImageLists.MovementIcons16x16
    Columns = <
      item
        Alignment = taRightJustify
        Position = 0
        Width = 40
        WideText = 'Lp'
      end
      item
        Position = 1
        Width = 100
        WideText = 'Data operacji'
      end
      item
        Position = 2
        Width = 200
        WideText = 'Opis'
      end
      item
        Alignment = taRightJustify
        Position = 3
        Width = 100
        WideText = 'Kwota'
      end
      item
        Position = 4
        WideText = 'Waluta'
      end
      item
        Position = 5
        Width = 10
        WideText = 'Rodzaj'
      end>
    WideDefaultText = ''
  end
  inherited ImageList: TPngImageList
    Left = 40
    Top = 64
  end
  inherited ListPopupMenu: TPopupMenu
    Left = 96
    Top = 72
  end
end
