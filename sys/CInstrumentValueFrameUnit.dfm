inherited CInstrumentValueFrame: TCInstrumentValueFrame
  inherited FilterPanel: TPanel
    object Label4: TLabel [1]
      Left = 362
      Top = 4
      Width = 12
      Height = 13
      Caption = 'do'
    end
    object Label5: TLabel [2]
      Left = 430
      Top = 4
      Width = 3
      Height = 13
      Caption = ')'
    end
    object Label3: TLabel [3]
      Left = 289
      Top = 4
      Width = 15
      Height = 13
      Caption = '(od'
    end
    object Label1: TLabel [4]
      Left = 210
      Top = 4
      Width = 73
      Height = 13
      Caption = 'Data wa'#380'no'#347'ci:'
    end
    inherited CStaticFilter: TCStatic
      Width = 152
      DataId = 'T'
    end
    object CDateTimePerStart: TCDateTime
      Left = 306
      Top = 4
      Width = 56
      Height = 14
      AutoSize = False
      BevelInner = bvNone
      BevelKind = bkTile
      BevelOuter = bvNone
      Caption = '2006-01-01'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 1
      TabStop = True
      Transparent = False
      OnChanged = CDateTimePerStartChanged
      HotTrack = True
      Withtime = False
    end
    object CDateTimePerEnd: TCDateTime
      Left = 376
      Top = 4
      Width = 55
      Height = 14
      AutoSize = False
      BevelInner = bvNone
      BevelKind = bkTile
      BevelOuter = bvNone
      Caption = '2006-01-01'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 2
      TabStop = True
      Transparent = False
      OnChanged = CDateTimePerEndChanged
      HotTrack = True
      Withtime = False
    end
    object CStaticPeriod: TCStatic
      Left = 291
      Top = 4
      Width = 134
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
      TabOrder = 3
      TabStop = True
      Transparent = False
      DataId = 'T'
      TextOnEmpty = '<tylko dzi'#347'>'
      OnGetDataId = CStaticPeriodGetDataId
      OnChanged = CStaticPeriodChanged
      HotTrack = True
    end
  end
  inherited List: TCDataList
    Header.MainColumn = 0
    Columns = <
      item
        Position = 0
        Width = 170
        WideText = 'Data i czas'
      end
      item
        Position = 1
        Width = 250
        WideText = 'Opis'
      end
      item
        Alignment = taRightJustify
        Position = 2
        Width = 150
        WideText = 'Warto'#347#263
      end
      item
        Position = 3
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
      Left = 141
      Width = 132
    end
    inherited CButtonDelete: TCButton
      Left = 269
      Width = 124
    end
  end
  inherited ListPopupMenu: TPopupMenu
    Left = 112
    Top = 88
  end
  inherited ActionListButtons: TActionList
    Images = CImageLists.CurrencyRateImageList24x24
    inherited ActionAdd: TAction
      Caption = 'Dodaj notowanie'
    end
    inherited ActionEdit: TAction
      Caption = 'Edytuj notowanie'
    end
    inherited ActionDelete: TAction
      Caption = 'Usu'#324' notowanie'
    end
  end
end
