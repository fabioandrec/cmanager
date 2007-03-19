inherited CFilterFrame: TCFilterFrame
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
  inherited ActionListButtons: TActionList
    Images = CImageLists.FilterImageList24x24
    inherited ActionAdd: TAction
      Caption = 'Dodaj filtr'
    end
    inherited ActionEdit: TAction
      Caption = 'Edytuj filtr'
    end
    inherited ActionDelete: TAction
      Caption = 'Usu'#324' filtr'
    end
  end
end
