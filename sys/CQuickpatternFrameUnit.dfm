inherited CQuickpatternFrame: TCQuickpatternFrame
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
  inherited ButtonPanel: TPanel
    inherited CButtonAdd: TCButton
      Width = 116
    end
    inherited CButtonEdit: TCButton
      Width = 116
    end
    inherited CButtonDelete: TCButton
      Width = 124
    end
  end
  inherited ActionListButtons: TActionList
    Images = CImageLists.QuickpatternImageList24x24
    inherited ActionAdd: TAction
      Caption = 'Dodaj szablon'
    end
    inherited ActionEdit: TAction
      Caption = 'Edytuj szablon'
    end
    inherited ActionDelete: TAction
      Caption = 'Usu'#324' szablon'
    end
  end
end
