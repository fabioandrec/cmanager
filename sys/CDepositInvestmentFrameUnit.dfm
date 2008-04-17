inherited CDepositInvestmentFrame: TCDepositInvestmentFrame
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
        WideText = 'Stan'
      end
      item
        Alignment = taRightJustify
        Position = 2
        Width = 100
        WideText = 'Kapita'#322
      end
      item
        Position = 3
        WideText = 'Waluta'
      end
      item
        Position = 4
        Width = 150
        WideText = 'Data ko'#324'ca lokaty'
      end
      item
        Position = 5
        Width = 10
        WideText = 'Nast'#281'pne naliczanie odsetek'
      end>
    WideDefaultText = ''
  end
  inherited ActionListButtons: TActionList
    Images = CImageLists.DepositImageList24x24
    inherited ActionAdd: TAction
      Caption = 'Za'#322#243#380' lokat'#281
    end
  end
end
