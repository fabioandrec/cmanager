inherited CMovementFrame: TCMovementFrame
  object Splitter1: TSplitter [0]
    Left = 0
    Top = 85
    Width = 443
    Height = 3
    Cursor = crVSplit
    Align = alBottom
  end
  object PanelFrameButtons: TPanel [1]
    Left = 0
    Top = 88
    Width = 443
    Height = 189
    Align = alBottom
    BevelOuter = bvNone
    Color = clWindow
    TabOrder = 0
    object Bevel: TBevel
      Left = 0
      Top = 146
      Width = 443
      Height = 3
      Align = alBottom
      Shape = bsBottomLine
    end
    object Panel1: TPanel
      Left = 0
      Top = 149
      Width = 443
      Height = 40
      Align = alBottom
      BevelOuter = bvNone
      Color = clWindow
      TabOrder = 0
      object CButtonOut: TCButton
        Left = 13
        Top = 4
        Width = 116
        Height = 33
        Cursor = crHandPoint
        PicPosition = ppLeft
        PicOffset = 10
        TxtOffset = 15
        Framed = False
        Action = ActionMovement
      end
      object CButtonEdit: TCButton
        Left = 116
        Top = 4
        Width = 110
        Height = 33
        Cursor = crHandPoint
        PicPosition = ppLeft
        PicOffset = 10
        TxtOffset = 15
        Framed = False
        Action = ActionEditMovement
      end
      object CButtonDel: TCButton
        Left = 228
        Top = 4
        Width = 110
        Height = 33
        Cursor = crHandPoint
        PicPosition = ppLeft
        PicOffset = 10
        TxtOffset = 15
        Framed = False
        Action = ActionDelMovement
      end
    end
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 443
      Height = 21
      Align = alTop
      Alignment = taLeftJustify
      Caption = '  Sumy przychod'#243'w/rozchod'#243'w w wybranym okresie'
      TabOrder = 1
    end
    object SumList: TVirtualStringTree
      Left = 0
      Top = 21
      Width = 443
      Height = 125
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
      Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
      Header.PopupMenu = VTHeaderPopupMenu
      Header.Style = hsFlatButtons
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      TabStop = False
      TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
      TreeOptions.MiscOptions = [toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
      TreeOptions.PaintOptions = [toHideFocusRect, toHideSelection, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
      TreeOptions.SelectionOptions = [toFullRowSelect]
      OnBeforeItemErase = SumListBeforeItemErase
      OnCompareNodes = SumListCompareNodes
      OnFocusChanged = TodayListFocusChanged
      OnGetText = SumListGetText
      OnGetHint = TodayListGetHint
      OnGetNodeDataSize = SumListGetNodeDataSize
      OnHeaderClick = SumListHeaderClick
      OnInitNode = SumListInitNode
      Columns = <
        item
          Position = 0
          Width = 10
          WideText = 'Konto'
          WideHint = 'Nazwa kontrahenta'
        end
        item
          Alignment = taRightJustify
          Position = 1
          Width = 150
          WideText = 'Rozch'#243'd'
        end
        item
          Alignment = taRightJustify
          Position = 2
          Width = 150
          WideText = 'Przych'#243'd'
        end
        item
          Alignment = taRightJustify
          Position = 3
          Width = 150
          WideText = 'Saldo'
        end>
    end
  end
  object TodayList: TVirtualStringTree [2]
    Left = 0
    Top = 21
    Width = 443
    Height = 64
    Align = alClient
    BevelEdges = []
    BevelInner = bvNone
    BevelOuter = bvRaised
    BevelKind = bkFlat
    BorderStyle = bsNone
    DefaultNodeHeight = 24
    Header.AutoSizeIndex = 1
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Sans Serif'
    Header.Font.Style = []
    Header.Height = 21
    Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
    Header.PopupMenu = VTHeaderPopupMenu
    Header.Style = hsFlatButtons
    HintMode = hmHint
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
    TreeOptions.MiscOptions = [toCheckSupport, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
    TreeOptions.PaintOptions = [toHideFocusRect, toHideSelection, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    OnBeforeItemErase = TodayListBeforeItemErase
    OnCompareNodes = TodayListCompareNodes
    OnFocusChanged = TodayListFocusChanged
    OnGetText = TodayListGetText
    OnGetHint = TodayListGetHint
    OnGetNodeDataSize = TodayListGetNodeDataSize
    OnHeaderClick = TodayListHeaderClick
    OnInitNode = TodayListInitNode
    Columns = <
      item
        Alignment = taRightJustify
        Options = [coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
        Position = 0
        WideText = 'Lp'
      end
      item
        Position = 1
        Width = 193
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
        Width = 100
        WideText = 'Kwota'
      end
      item
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark]
        Position = 4
        Width = 150
        WideText = 'Rodzaj'
      end>
  end
  object Panel: TPanel [3]
    Left = 0
    Top = 0
    Width = 443
    Height = 21
    Align = alTop
    Alignment = taLeftJustify
    TabOrder = 2
    object Label2: TLabel
      Left = 8
      Top = 4
      Width = 61
      Height = 13
      Caption = 'Typ operacji:'
    end
    object Label1: TLabel
      Left = 146
      Top = 4
      Width = 85
      Height = 13
      Caption = 'Okres wykonania:'
    end
    object Label3: TLabel
      Left = 289
      Top = 4
      Width = 15
      Height = 13
      Caption = '(od'
    end
    object Label4: TLabel
      Left = 362
      Top = 4
      Width = 12
      Height = 13
      Caption = 'do'
    end
    object Label5: TLabel
      Left = 430
      Top = 4
      Width = 3
      Height = 13
      Caption = ')'
    end
    object CStaticPeriod: TCStatic
      Left = 235
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
      TabOrder = 1
      DataId = '1'
      TextOnEmpty = '<tylko dzi'#347'>'
      OnGetDataId = CStaticPeriodGetDataId
      OnChanged = CStaticFilterChanged
      HotTrack = True
    end
    object CStaticFilter: TCStatic
      Left = 73
      Top = 4
      Width = 74
      Height = 15
      Cursor = crHandPoint
      AutoSize = False
      BevelInner = bvNone
      BevelKind = bkTile
      BevelOuter = bvNone
      Caption = '<dowolny typ>'
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
      TextOnEmpty = '<dowolny typ>'
      OnGetDataId = CStaticFilterGetDataId
      OnChanged = CStaticFilterChanged
      HotTrack = True
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
      TabOrder = 2
      OnChanged = CDateTimePerStartChanged
      HotTrack = True
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
      TabOrder = 3
      OnChanged = CDateTimePerStartChanged
      HotTrack = True
    end
  end
  inherited ImageList: TPngImageList
    Top = 144
  end
  object ActionList: TActionList
    Images = ImageList
    Left = 200
    Top = 112
    object ActionMovement: TAction
      Caption = 'Dodaj operacj'#281
      ImageIndex = 0
      OnExecute = ActionMovementExecute
    end
    object ActionEditMovement: TAction
      Caption = 'Edytuj operacj'#281
      ImageIndex = 1
      OnExecute = ActionEditMovementExecute
    end
    object ActionDelMovement: TAction
      Caption = 'Usu'#324' operacj'#281
      ImageIndex = 4
      OnExecute = ActionDelMovementExecute
    end
  end
  object VTHeaderPopupMenu: TVTHeaderPopupMenu
    Left = 80
    Top = 120
  end
end
