inherited CDepositMovementFrame: TCDepositMovementFrame
  inherited FilterPanel: TCPanel
    object Label1: TLabel [1]
      Left = 194
      Top = 4
      Width = 85
      Height = 13
      Caption = 'Okres wykonania:'
    end
    object Label3: TLabel [2]
      Left = 481
      Top = 4
      Width = 15
      Height = 13
      Caption = '(od'
    end
    object Label4: TLabel [3]
      Left = 554
      Top = 4
      Width = 12
      Height = 13
      Caption = 'do'
    end
    object Label5: TLabel [4]
      Left = 622
      Top = 4
      Width = 3
      Height = 13
      Caption = ')'
    end
    object CStaticPeriod: TCStatic
      Left = 283
      Top = 4
      Width = 90
      Height = 15
      Cursor = crHandPoint
      AutoSize = False
      BevelInner = bvNone
      BevelKind = bkTile
      BevelOuter = bvNone
      Caption = '<tylko dzi'#347'>'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 1
      TabStop = True
      Transparent = False
      DataId = '1'
      TextOnEmpty = '<tylko dzi'#347'>'
      OnGetDataId = CStaticPeriodGetDataId
      OnChanged = CStaticPeriodChanged
      HotTrack = True
    end
    object CDateTimePerStart: TCDateTime
      Left = 498
      Top = 4
      Width = 89
      Height = 14
      AutoSize = False
      BevelInner = bvNone
      BevelKind = bkTile
      BevelOuter = bvNone
      Caption = '<wybierz dat'#281'  i czas>'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 2
      TabStop = True
      Transparent = False
      OnChanged = CDateTimePerStartChanged
      HotTrack = True
      Withtime = True
    end
    object CDateTimePerEnd: TCDateTime
      Left = 656
      Top = 4
      Width = 85
      Height = 14
      AutoSize = False
      BevelInner = bvNone
      BevelKind = bkTile
      BevelOuter = bvNone
      Caption = '<wybierz dat'#281'  i czas>'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 3
      TabStop = True
      Transparent = False
      OnChanged = CDateTimePerEndChanged
      HotTrack = True
      Withtime = True
    end
  end
  inherited List: TCDataList
    Header.AutoSizeIndex = 2
    Header.MainColumn = 0
    Images = CImageLists.MovementIcons16x16
    Columns = <
      item
        Alignment = taRightJustify
        Position = 0
        WideText = 'Lp'
      end
      item
        Position = 1
        Width = 100
        WideText = 'Data'
      end
      item
        Position = 2
        Width = 193
        WideText = 'Opis'
        WideHint = 'Opis'
      end
      item
        Alignment = taRightJustify
        Position = 3
        Width = 100
        WideText = 'Kwota'
      end
      item
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark]
        Position = 4
        Width = 10
        WideText = 'Rodzaj'
      end>
    WideDefaultText = ''
  end
  inherited ButtonPanel: TCPanel
    inherited CButtonAdd: TCButton
      Width = 124
    end
    inherited CButtonEdit: TCButton
      Width = 124
    end
    inherited CButtonDelete: TCButton
      Width = 132
    end
  end
  inherited ImageList: TPngImageList
    Left = 168
    Top = 8
  end
  inherited ActionListButtons: TActionList
    Images = CImageLists.DepositMovementImageList24x24
    inherited ActionAdd: TAction
      Caption = 'Dodaj operacj'#281
      ImageIndex = 1
    end
    inherited ActionEdit: TAction
      Caption = 'Edytuj operacj'#281
      ImageIndex = 0
    end
    inherited ActionDelete: TAction
      Caption = 'Usu'#324' operacj'#281
    end
  end
end