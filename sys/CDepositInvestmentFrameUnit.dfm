inherited CDepositInvestmentFrame: TCDepositInvestmentFrame
  inherited List: TCDataList
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
        Width = 10
        WideText = 'Data zapadalno'#347'ci odsetek'
      end>
    WideDefaultText = ''
  end
  inherited ButtonPanel: TPanel
    inherited CButtonEdit: TCButton
      Left = 245
    end
    inherited CButtonDelete: TCButton
      Left = 469
    end
    inherited CButtonHistory: TCButton
      Left = 565
    end
    object CButtonDetails: TCButton
      Left = 357
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
    object CButton1: TCButton
      Left = 117
      Top = 4
      Width = 124
      Height = 30
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Action = ActionPay
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
    object ActionPay: TAction
      Caption = 'Operacja lokaty'
      ImageIndex = 4
      OnExecute = ActionPayExecute
    end
  end
end
