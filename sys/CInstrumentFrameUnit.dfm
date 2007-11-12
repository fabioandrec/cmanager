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
  inherited ButtonPanel: TPanel
    inherited CButtonAdd: TCButton
      Width = 124
    end
    inherited CButtonEdit: TCButton
      Width = 140
    end
    inherited CButtonDelete: TCButton
      Width = 164
    end
  end
  inherited ImageList: TPngImageList
    Left = 24
    Top = 80
  end
  inherited ListPopupMenu: TPopupMenu
    Left = 144
    Top = 128
  end
  inherited ActionListButtons: TActionList
    Images = CImageLists.InstrumentImageList24x24
    inherited ActionAdd: TAction
      Caption = 'Dodaj instrument'
    end
    inherited ActionEdit: TAction
      Caption = 'Edytuj instrument'
    end
    inherited ActionDelete: TAction
      Caption = 'Usu'#324' instrument'
    end
  end
end
