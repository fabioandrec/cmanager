inherited CAccountsFrame: TCAccountsFrame
  Width = 607
  Height = 360
  inherited Bevel: TBevel
    Top = 317
    Width = 607
  end
  inherited FilterPanel: TCPanel
    Width = 607
  end
  inherited List: TCDataList
    Width = 607
    Height = 296
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
        WideText = 'Rodzaj'
      end
      item
        Alignment = taRightJustify
        Position = 2
        Width = 143
        WideText = 'Dost'#281'pne '#347'rodki'
      end
      item
        Position = 3
        Width = 164
        WideText = 'Waluta'
      end>
    WideDefaultText = ''
  end
  inherited ButtonPanel: TCPanel
    Top = 320
    Width = 607
  end
  inherited ActionListButtons: TActionList
    Images = CImageLists.AccountFrameImageList24x24
    inherited ActionAdd: TAction
      Caption = 'Dodaj konto'
    end
    inherited ActionEdit: TAction
      Caption = 'Edytuj konto'
    end
    inherited ActionDelete: TAction
      Caption = 'Usu'#324' konto'
    end
  end
end
