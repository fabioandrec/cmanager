inherited CLimitsFrame: TCLimitsFrame
  inherited List: TCDataList
    Header.MainColumn = 0
    Images = CImageLists.DoneImageList16x16
    Columns = <
      item
        Position = 0
        Width = 200
        WideText = 'Nazwa'
      end
      item
        Position = 1
        Width = 143
        WideText = 'Aktywno'#347#263
      end
      item
        Position = 2
        Width = 100
        WideText = 'Rodzaj'
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
  inherited ActionListButtons: TActionList
    Images = CImageLists.LimitsImageList24x24
    inherited ActionAdd: TAction
      Caption = 'Dodaj limit'
    end
    inherited ActionEdit: TAction
      Caption = 'Edytuj limit'
    end
    inherited ActionDelete: TAction
      Caption = 'Usu'#324' limit'
    end
  end
end
