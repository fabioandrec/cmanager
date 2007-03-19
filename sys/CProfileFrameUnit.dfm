inherited CProfileFrame: TCProfileFrame
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
    Images = CImageLists.ProfileImageList24x24
    inherited ActionAdd: TAction
      Caption = 'Dodaj profil'
    end
    inherited ActionEdit: TAction
      Caption = 'Edytuj profil'
    end
    inherited ActionDelete: TAction
      Caption = 'Usu'#324' profil'
    end
  end
end
