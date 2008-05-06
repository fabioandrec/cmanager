inherited CDoneFrame: TCDoneFrame
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
      PopupMenu = PopupMenuIcons
      TabOrder = 2
      DesignSize = (
        443
        40)
      object CButtonsStatus: TCButton
        Left = 149
        Top = 4
        Width = 116
        Height = 33
        Cursor = crHandPoint
        PicPosition = ppLeft
        PicOffset = 10
        TxtOffset = 15
        Framed = False
        Action = ActionOperation
      end
      object CButtonOperation: TCButton
        Left = 13
        Top = 4
        Width = 132
        Height = 33
        Cursor = crHandPoint
        PicPosition = ppLeft
        PicOffset = 10
        TxtOffset = 15
        Framed = False
        Action = ActionDooperation
      end
      object CButtonPlanned: TCButton
        Left = 317
        Top = 3
        Width = 116
        Height = 33
        Cursor = crHandPoint
        PicPosition = ppLeft
        PicOffset = 10
        TxtOffset = 15
        Framed = False
        Action = ActionPlanned
        Anchors = [akTop, akRight]
      end
    end
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 443
      Height = 21
      Align = alTop
      Alignment = taLeftJustify
      Caption = '  Sumy niezrealizowanych operacji w wybranym okresie'
      TabOrder = 0
      DesignSize = (
        443
        21)
      object SpeedButtonCloseShortcuts: TSpeedButton
        Left = 432
        Top = 5
        Width = 11
        Height = 13
        Anchors = [akTop, akRight]
        Caption = 'r'
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -8
        Font.Name = 'Marlett'
        Font.Style = []
        ParentFont = False
        OnClick = SpeedButtonCloseShortcutsClick
      end
    end
    object SumList: TCList
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
      PopupMenu = PopupMenuSums
      ShowHint = True
      TabOrder = 1
      TabStop = False
      TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
      TreeOptions.MiscOptions = [toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
      TreeOptions.PaintOptions = [toHideFocusRect, toHideSelection, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
      TreeOptions.SelectionOptions = [toFullRowSelect]
      OnCompareNodes = SumListCompareNodes
      OnGetText = SumListGetText
      OnGetHint = DoneListGetHint
      OnGetNodeDataSize = SumListGetNodeDataSize
      OnInitChildren = SumListInitChildren
      OnInitNode = SumListInitNode
      AutoExpand = True
      Columns = <
        item
          Position = 0
          Width = 10
          WideText = 'Konto'
          WideHint = 'Konto'
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
        end
        item
          Position = 4
          WideText = 'Waluta'
        end>
      WideDefaultText = ''
    end
  end
  object DoneList: TCList [2]
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
    Header.AutoSizeIndex = -1
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
    Images = CImageLists.DoneImageList16x16
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
    TreeOptions.MiscOptions = [toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
    TreeOptions.PaintOptions = [toHideFocusRect, toHideSelection, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    OnCompareNodes = DoneListCompareNodes
    OnDblClick = DoneListDblClick
    OnFocusChanged = DoneListFocusChanged
    OnGetText = DoneListGetText
    OnGetImageIndex = DoneListGetImageIndex
    OnGetHint = DoneListGetHint
    OnGetNodeDataSize = DoneListGetNodeDataSize
    OnInitNode = DoneListInitNode
    AutoExpand = True
    OnGetRowPreferencesName = DoneListGetRowPreferencesName
    Columns = <
      item
        Alignment = taRightJustify
        Options = [coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
        Position = 0
        WideText = 'Lp'
      end
      item
        Position = 1
        Width = 200
        WideText = 'Opis'
        WideHint = 'Opis'
      end
      item
        Position = 2
        Width = 100
        WideText = 'Do kiedy'
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
      end
      item
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark]
        Position = 5
        Width = 100
        WideText = 'Status'
      end
      item
        Position = 6
        WideText = 'Waluta'
      end
      item
        Position = 7
        Width = 10
        WideText = 'Data wykonania'
      end>
    WideDefaultText = ''
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
    object CStaticFilter: TCStatic
      Left = 73
      Top = 4
      Width = 74
      Height = 15
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
      TabStop = True
      Transparent = False
      DataId = '1'
      TextOnEmpty = '<dowolny typ>'
      OnGetDataId = CStaticFilterGetDataId
      OnChanged = CStaticFilterChanged
      HotTrack = True
    end
    object CStaticPeriod: TCStatic
      Left = 235
      Top = 4
      Width = 118
      Height = 15
      Cursor = crHandPoint
      AutoSize = False
      BevelInner = bvNone
      BevelKind = bkTile
      BevelOuter = bvNone
      Caption = '<w tym tygodniu>'
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
      DataId = '2'
      TextOnEmpty = '<tylko dzi'#347'>'
      OnGetDataId = CStaticPeriodGetDataId
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
      Caption = '<wybierz dat'#281' >'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 2
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
      Caption = '<wybierz dat'#281' >'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 3
      TabStop = True
      Transparent = False
      OnChanged = CDateTimePerStartChanged
      HotTrack = True
      Withtime = False
    end
  end
  inherited ImageList: TPngImageList
    Top = 144
  end
  inherited ListPopupMenu: TPopupMenu
    object MenuItemsumsVisible: TMenuItem
      Caption = 'Sumy przychod'#243'w/rozchod'#243'w w wybranym okresie'
      Checked = True
      OnClick = MenuItemsumsVisibleClick
    end
  end
  object ActionList: TActionList
    Images = CImageLists.DoneImageList24x24
    Left = 200
    Top = 112
    object ActionOperation: TAction
      Caption = 'Zmie'#324' status'
      ImageIndex = 0
      OnExecute = ActionOperationExecute
    end
    object ActionDooperation: TAction
      Caption = 'Wykonaj operacj'#281
      ImageIndex = 1
      OnExecute = ActionDooperationExecute
    end
    object ActionPlanned: TAction
      Caption = 'Harmonogramy'
      ImageIndex = 2
      OnExecute = ActionPlannedExecute
    end
  end
  object VTHeaderPopupMenu: TVTHeaderPopupMenu
    Left = 128
    Top = 152
  end
  object PopupMenuSums: TPopupMenu
    Left = 152
    Top = 160
    object Ustawienialisty2: TMenuItem
      Caption = 'Ustawienia listy'
      OnClick = Ustawienialisty2Click
    end
  end
  object PopupMenuIcons: TPopupMenu
    Left = 256
    Top = 168
    object MenuItemBigIcons: TMenuItem
      Caption = 'Du'#380'e ikony'
      Checked = True
      RadioItem = True
      OnClick = MenuItemBigIconsClick
    end
    object MenuItemSmallIcons: TMenuItem
      Caption = 'Ma'#322'e ikony'
      RadioItem = True
      OnClick = MenuItemSmallIconsClick
    end
  end
end
