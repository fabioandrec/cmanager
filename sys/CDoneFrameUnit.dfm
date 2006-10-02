inherited CDoneFrame: TCDoneFrame
  Height = 333
  object Panel: TPanel [0]
    Left = 0
    Top = 0
    Width = 443
    Height = 21
    Align = alTop
    Alignment = taLeftJustify
    TabOrder = 0
    object Label1: TLabel
      Left = 10
      Top = 4
      Width = 85
      Height = 13
      Caption = 'Okres wykonania:'
    end
    object CStaticPeriod: TCStatic
      Left = 99
      Top = 4
      Width = 118
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
      TabOrder = 0
      DataId = '1'
      TextOnEmpty = '<tylko dzi'#347'>'
      HotTrack = True
    end
  end
  object TodayList: TVirtualStringTree [1]
    Left = 0
    Top = 21
    Width = 443
    Height = 312
    Align = alClient
    BevelEdges = []
    BevelInner = bvNone
    BevelOuter = bvRaised
    BevelKind = bkFlat
    BorderStyle = bsNone
    DefaultNodeHeight = 24
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Sans Serif'
    Header.Font.Style = []
    Header.Height = 21
    Header.MainColumn = 1
    Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
    Header.Style = hsFlatButtons
    HintMode = hmHint
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
    TreeOptions.MiscOptions = [toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
    TreeOptions.PaintOptions = [toHideFocusRect, toHideSelection, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    Columns = <
      item
        Position = 0
        Width = 243
        WideText = 'Opis'
        WideHint = 'Nazwa kontrahenta'
      end
      item
        Position = 1
        Width = 100
        WideText = 'Data'
      end
      item
        Alignment = taRightJustify
        Position = 2
        Width = 100
        WideText = 'Kwota'
      end
      item
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark]
        Position = 3
        Width = 150
        WideText = 'Rodzaj'
      end>
  end
end
