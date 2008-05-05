inherited CDepositInvestmentFrame: TCDepositInvestmentFrame
  Width = 631
  Height = 274
  inherited Bevel: TBevel
    Top = 231
    Width = 631
  end
  inherited FilterPanel: TCPanel
    Width = 631
  end
  inherited List: TCDataList
    Width = 631
    Height = 210
    Header.MainColumn = 0
    Images = CImageLists.DepositStateImageList16x16
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
        Width = 31
        WideText = 'Data zapadalno'#347'ci odsetek'
      end>
    WideDefaultText = ''
  end
  inherited ButtonPanel: TPanel
    Top = 234
    Width = 631
    inherited CButtonDelete: TCButton
      Left = 357
    end
    inherited CButtonHistory: TCButton
      Left = 453
    end
    object CButtonDetails: TCButton
      Left = 245
      Top = 4
      Width = 116
      Height = 30
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Action = ActionDetails
    end
  end
  inherited ActionListButtons: TActionList
    Images = CImageLists.DepositImageList24x24
    inherited ActionAdd: TAction
      Caption = 'Za'#322#243#380' lokat'#281
    end
    inherited ActionEdit: TAction
      Caption = 'Edytuj lokat'#281
    end
    inherited ActionDelete: TAction
      Caption = 'Usu'#324' lokat'#281
    end
    object ActionDetails: TAction
      Caption = 'Poka'#380' histori'#281
      ImageIndex = 3
      OnExecute = ActionDetailsExecute
    end
  end
end
