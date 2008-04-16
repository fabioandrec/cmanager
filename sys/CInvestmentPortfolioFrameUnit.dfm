inherited CInvestmentPortfolioFrame: TCInvestmentPortfolioFrame
  inherited List: TCDataList
    Header.MainColumn = 0
    Columns = <
      item
        Position = 0
        Width = 150
        WideText = 'Konto'
      end
      item
        Position = 1
        Width = 150
        WideText = 'Instrument'
      end
      item
        Alignment = taRightJustify
        Position = 2
        Width = 75
        WideText = 'Ilo'#347#263
      end
      item
        Alignment = taRightJustify
        Position = 3
        Width = 150
        WideText = 'Aktualna warto'#347#263
      end
      item
        Position = 4
        Width = 10
        WideText = 'Waluta'
      end>
    WideDefaultText = ''
  end
  inherited ButtonPanel: TPanel
    inherited CButtonAdd: TCButton
      Width = 124
    end
    inherited CButtonEdit: TCButton
      Width = 196
    end
    object CButtonAll: TCButton
      Left = 301
      Top = 4
      Width = 133
      Height = 30
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Action = ActionAllInvestmentMovements
      Anchors = [akTop, akRight]
    end
  end
  inherited ActionListButtons: TActionList
    Images = CImageLists.InvestmentImageList24x24
    inherited ActionAdd: TAction
      Caption = 'Dodaj operacj'#281
      ImageIndex = 1
    end
    inherited ActionEdit: TAction
      Caption = 'Poka'#380' histori'#281' portfela'
      ImageIndex = 0
    end
    object ActionAllInvestmentMovements: TAction
      Caption = 'Wszystkie operacje'
      ImageIndex = 3
      OnExecute = ActionAllInvestmentMovementsExecute
    end
  end
end
