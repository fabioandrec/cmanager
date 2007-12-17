inherited CInvestmentMovementFrame: TCInvestmentMovementFrame
  inherited FilterPanel: TPanel
    object Label1: TLabel [1]
      Left = 194
      Top = 4
      Width = 85
      Height = 13
      Caption = 'Okres wykonania:'
    end
    object Label6: TLabel [2]
      Left = 352
      Top = 4
      Width = 32
      Height = 13
      Caption = 'Kwoty:'
    end
    object Label3: TLabel [3]
      Left = 481
      Top = 4
      Width = 15
      Height = 13
      Caption = '(od'
    end
    object Label4: TLabel [4]
      Left = 554
      Top = 4
      Width = 12
      Height = 13
      Caption = 'do'
    end
    object Label5: TLabel [5]
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
    object CStaticViewCurrency: TCStatic
      Left = 385
      Top = 4
      Width = 105
      Height = 15
      Cursor = crHandPoint
      AutoSize = False
      BevelInner = bvNone
      BevelKind = bkTile
      BevelOuter = bvNone
      Caption = '<waluta instrumentu>'
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 2
      TabStop = True
      Transparent = False
      DataId = 'M'
      TextOnEmpty = '<dowolny typ>'
      OnGetDataId = CStaticViewCurrencyGetDataId
      OnChanged = CStaticViewCurrencyChanged
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
      TabOrder = 3
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
      TabOrder = 4
      TabStop = True
      Transparent = False
      OnChanged = CDateTimePerEndChanged
      HotTrack = True
      Withtime = True
    end
  end
  inherited List: TCDataList
    Header.AutoSizeIndex = 1
    Header.MainColumn = 0
    Columns = <
      item
        Alignment = taRightJustify
        Options = [coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
        Position = 0
        WideText = 'Lp'
      end
      item
        Position = 1
        Width = 93
        WideText = 'Opis'
        WideHint = 'Nazwa kontrahenta'
      end
      item
        Position = 2
        Width = 100
        WideText = 'Data'
      end
      item
        Alignment = taRightJustify
        Position = 3
        Width = 70
        WideText = 'Ilo'#347#263
      end
      item
        Alignment = taRightJustify
        Position = 4
        Width = 80
        WideText = 'Kwota'
      end
      item
        Position = 5
        WideText = 'Waluta'
      end
      item
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark]
        Position = 6
        Width = 10
        WideText = 'Rodzaj'
      end>
    WideDefaultText = ''
  end
end
