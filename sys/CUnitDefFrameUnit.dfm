inherited CUnitDefFrame: TCUnitDefFrame
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
  inherited ButtonPanel: TCPanel
    inherited CButtonAdd: TCButton
      Width = 124
    end
    inherited CButtonEdit: TCButton
      Width = 124
      Caption = 'Edytuj jednostk'#281
    end
    inherited CButtonDelete: TCButton
      Left = 248
      Width = 145
      Caption = 'Usu'#324' jednostk'#281
    end
  end
  inherited ActionListButtons: TActionList
    Images = CImageLists.UnitedefsImageList24x24
    inherited ActionAdd: TAction
      Caption = 'Dodaj jednostk'#281
    end
  end
end