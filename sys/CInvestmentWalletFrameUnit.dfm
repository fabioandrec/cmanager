inherited CInvestmentWalletFrame: TCInvestmentWalletFrame
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
  inherited ImageList: TPngImageList
    Left = 64
    Top = 64
  end
  inherited ActionListButtons: TActionList
    inherited ActionAdd: TAction
      Caption = 'Dodaj portfel'
    end
    inherited ActionEdit: TAction
      Caption = 'Edytuj portfel'
    end
    inherited ActionDelete: TAction
      Caption = 'Usu'#324' portfel'
    end
  end
end
