inherited CExtractionsFrame: TCExtractionsFrame
  inherited List: TCDataList
    Header.MainColumn = 0
    Images = CImageLists.ExtstatusImageList16x16
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
        Width = 10
        WideText = 'Status'
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
      Width = 116
    end
  end
  inherited ImageList: TPngImageList
    Left = 144
    Top = 96
  end
  inherited ListPopupMenu: TPopupMenu
    Left = 280
    Top = 112
  end
  inherited ActionListButtons: TActionList
    Images = CImageLists.ExtractionImageList24x24
    inherited ActionAdd: TAction
      Caption = 'Dodaj wyci'#261'g'
    end
    inherited ActionEdit: TAction
      Caption = 'Edytuj wyci'#261'g'
    end
    inherited ActionDelete: TAction
      Caption = 'Usu'#324' wyci'#261'g'
    end
  end
end
