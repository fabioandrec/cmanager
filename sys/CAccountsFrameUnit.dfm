inherited CAccountsFrame: TCAccountsFrame
  Width = 787
  inherited FilterPanel: TCPanel
    Width = 787
    object Label1: TLabel [1]
      Left = 195
      Top = 4
      Width = 33
      Height = 13
      Alignment = taRightJustify
      Caption = 'Status:'
    end
    object CStaticStatusFilter: TCStatic
      Left = 233
      Top = 4
      Width = 136
      Height = 13
      Cursor = crHandPoint
      Hint = '<Aktywne>'
      AutoSize = False
      BevelInner = bvNone
      BevelKind = bkTile
      BevelOuter = bvNone
      Caption = '<Aktywne>'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      TabStop = True
      Transparent = False
      DataId = 'A'
      TextOnEmpty = '<dowolny>'
      OnGetDataId = CStaticStatusFilterGetDataId
      OnChanged = CStaticStatusFilterChanged
      HotTrack = True
    end
  end
  inherited List: TCDataList
    Width = 787
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
        Width = 100
        WideText = 'Waluta'
      end
      item
        Position = 4
        Width = 244
        WideText = 'Status'
      end>
    WideDefaultText = ''
  end
  inherited ButtonPanel: TCPanel
    Width = 787
  end
  inherited BevelPanel: TCPanel
    Width = 787
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
