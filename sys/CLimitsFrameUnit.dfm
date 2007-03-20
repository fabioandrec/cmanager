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
