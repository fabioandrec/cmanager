inherited CInvestmentPortfolioFrame: TCInvestmentPortfolioFrame
  Width = 654
  inherited Bevel: TBevel
    Width = 654
  end
  inherited FilterPanel: TPanel
    Width = 654
  end
  inherited List: TCDataList
    Width = 654
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
        Width = 129
        WideText = 'Waluta'
      end>
    WideDefaultText = ''
  end
  inherited ButtonPanel: TPanel
    Width = 654
    inherited CButtonAdd: TCButton
      Width = 124
    end
    inherited CButtonEdit: TCButton
      Left = 269
      Width = 116
    end
    inherited CButtonDelete: TCButton
      Left = 381
      Width = 156
      Caption = 'Usu'#324' inwestycj'#281
    end
    inherited CButtonHistory: TCButton
      Left = 549
    end
    object CButtonDetails: TCButton
      Left = 125
      Top = 4
      Width = 148
      Height = 30
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Action = ActionDetails
    end
  end
  inherited ListPopupMenu: TPopupMenu
    inherited Usu1: TMenuItem
      Caption = 'Usu'#324' inwestycj'#281
    end
  end
  inherited ActionListButtons: TActionList
    Images = CImageLists.InvestmentImageList24x24
    inherited ActionAdd: TAction
      Caption = 'Dodaj operacj'#281
      ImageIndex = 1
    end
    inherited ActionEdit: TAction
      Caption = 'Poka'#380' histori'#281
      ImageIndex = 0
    end
    object ActionDetails: TAction
      Caption = 'Szczeg'#243#322'y inwestycji'
      ImageIndex = 3
      OnExecute = ActionDetailsExecute
    end
  end
  inherited ActionListHistory: TActionList
    Top = 152
  end
end
