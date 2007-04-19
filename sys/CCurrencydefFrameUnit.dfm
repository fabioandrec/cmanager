inherited CCurrencydefFrame: TCCurrencydefFrame
  inherited List: TCDataList
    Header.MainColumn = 0
    Columns = <
      item
        Position = 0
        Width = 200
        WideText = 'Nazwa'
      end
      item
        Position = 1
        Width = 100
        WideText = 'Symbol'
      end
      item
        Position = 2
        Width = 143
        WideText = 'Iso'
      end>
    WideDefaultText = ''
  end
  inherited ButtonPanel: TPanel
    inherited CButtonAdd: TCButton
      Width = 108
    end
    inherited CButtonEdit: TCButton
      Width = 108
    end
    inherited CButtonDelete: TCButton
      Width = 108
    end
  end
  inherited ActionListButtons: TActionList
    Images = CImageLists.CurrencyDefImageList24x24
    inherited ActionAdd: TAction
      Caption = 'Dodaj walut'#281
    end
    inherited ActionEdit: TAction
      Caption = 'Edytuj walut'#281
    end
    inherited ActionDelete: TAction
      Caption = 'Usu'#324' walut'#281
    end
  end
end
