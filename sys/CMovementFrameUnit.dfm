inherited CMovementFrame: TCMovementFrame
  object Splitter1: TSplitter [0]
    Left = 0
    Top = 78
    Width = 435
    Height = 1
    Cursor = crVSplit
    Align = alBottom
  end
  object PanelFrameButtons: TCPanel [1]
    Left = 0
    Top = 79
    Width = 435
    Height = 189
    Align = alBottom
    BevelOuter = bvNone
    Color = clWindow
    TabOrder = 0
    IsFlatButton = False
    object Splitter2: TSplitter
      Left = 327
      Top = 0
      Width = 1
      Height = 147
      Align = alRight
      AutoSnap = False
    end
    object BevelPanel: TCPanel
      Left = 0
      Top = 147
      Width = 435
      Height = 2
      Align = alBottom
      BevelOuter = bvLowered
      TabOrder = 3
      IsFlatButton = False
    end
    object Panel1: TCPanel
      Left = 0
      Top = 149
      Width = 435
      Height = 40
      Align = alBottom
      BevelOuter = bvNone
      Color = clWindow
      PopupMenu = PopupMenuIcons
      TabOrder = 0
      IsFlatButton = False
      object CButtonOut: TCButton
        Left = 13
        Top = 4
        Width = 124
        Height = 33
        Cursor = crHandPoint
        PicPosition = ppLeft
        PicOffset = 10
        TxtOffset = 15
        Framed = False
        Action = ActionMovement
      end
      object CButtonEdit: TCButton
        Left = 260
        Top = 4
        Width = 77
        Height = 33
        Cursor = crHandPoint
        PicPosition = ppLeft
        PicOffset = 10
        TxtOffset = 15
        Framed = False
        Action = ActionEditMovement
      end
      object CButtonDel: TCButton
        Left = 348
        Top = 4
        Width = 77
        Height = 33
        Cursor = crHandPoint
        PicPosition = ppLeft
        PicOffset = 10
        TxtOffset = 15
        Framed = False
        Action = ActionDelMovement
      end
      object CButton1: TCButton
        Left = 133
        Top = 4
        Width = 124
        Height = 33
        Cursor = crHandPoint
        PicPosition = ppLeft
        PicOffset = 10
        TxtOffset = 15
        Framed = False
        Action = ActionAddList
      end
    end
    object PanelSum: TCPanel
      Left = 0
      Top = 0
      Width = 327
      Height = 147
      Align = alClient
      AutoSize = True
      BevelOuter = bvNone
      TabOrder = 1
      IsFlatButton = False
      object SumList: TCList
        Left = 0
        Top = 21
        Width = 327
        Height = 126
        Align = alClient
        BevelEdges = [beRight]
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
        ParentShowHint = False
        PopupMenu = PopupMenuSums
        ShowHint = True
        TabOrder = 0
        TabStop = False
        TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
        TreeOptions.MiscOptions = [toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
        TreeOptions.PaintOptions = [toHideFocusRect, toHideSelection, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toFullRowSelect]
        OnCompareNodes = SumListCompareNodes
        OnGetText = SumListGetText
        OnGetHint = TodayListGetHint
        OnGetNodeDataSize = SumListGetNodeDataSize
        OnInitChildren = SumListInitChildren
        OnInitNode = SumListInitNode
        AutoExpand = True
        Columns = <
          item
            Position = 0
            Width = 160
            WideText = 'Konto'
            WideHint = 'Konto'
          end
          item
            Alignment = taRightJustify
            Position = 1
            Width = 85
            WideText = 'Rozch'#243'd'
          end
          item
            Alignment = taRightJustify
            Position = 2
            Width = 85
            WideText = 'Przych'#243'd'
          end
          item
            Alignment = taRightJustify
            Position = 3
            Width = 85
            WideText = 'Saldo'
          end
          item
            Position = 4
            Width = 10
            WideText = 'Waluta'
          end>
        WideDefaultText = ''
      end
      object Panel2: TCPanel
        Left = 0
        Top = 0
        Width = 327
        Height = 21
        Align = alTop
        Alignment = taLeftJustify
        Caption = '  Sumy przychod'#243'w/rozchod'#243'w w wybranym okresie'
        TabOrder = 1
        IsFlatButton = False
        DesignSize = (
          327
          21)
        object ButtonCloseShortcuts: TCPanel
          Left = 1018
          Top = 4
          Width = 14
          Height = 14
          Anchors = [akTop, akRight]
          BevelOuter = bvNone
          Caption = '6'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -8
          Font.Name = 'Marlett'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnClick = ButtonCloseShortcutsClick
          IsFlatButton = True
        end
      end
    end
    object PanelPatterns: TCPanel
      Left = 328
      Top = 0
      Width = 107
      Height = 147
      Align = alRight
      BevelOuter = bvNone
      Color = clWindow
      TabOrder = 2
      IsFlatButton = False
      object Panel3: TCPanel
        Left = 0
        Top = 0
        Width = 107
        Height = 21
        Align = alTop
        Alignment = taLeftJustify
        Caption = '  Szybka operacja'
        TabOrder = 0
        IsFlatButton = False
        DesignSize = (
          107
          21)
        object ButtonPatternVisible: TCPanel
          Left = 85
          Top = 4
          Width = 14
          Height = 14
          Anchors = [akTop, akRight]
          BevelOuter = bvNone
          Caption = '6'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -8
          Font.Name = 'Marlett'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnClick = ButtonPatternVisibleClick
          IsFlatButton = True
        end
      end
      object QuickpatternList: TCDataList
        Left = 0
        Top = 21
        Width = 107
        Height = 126
        Align = alClient
        BevelEdges = []
        BevelInner = bvNone
        BevelOuter = bvRaised
        BevelKind = bkFlat
        BorderStyle = bsNone
        ButtonStyle = bsTriangle
        DefaultNodeHeight = 24
        Header.AutoSizeIndex = 0
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'MS Sans Serif'
        Header.Font.Style = []
        Header.Height = 21
        Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs]
        Header.Style = hsFlatButtons
        HintMode = hmHint
        HotCursor = crHandPoint
        Images = CImageLists.MovementIcons16x16
        Indent = 8
        ParentShowHint = False
        PopupMenu = PopupMenuQuickPatterns
        ShowHint = True
        TabOrder = 1
        TabStop = False
        TreeOptions.AutoOptions = [toAutoExpand, toAutoScrollOnExpand, toAutoTristateTracking, toAutoDeleteMovedNodes]
        TreeOptions.MiscOptions = [toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
        TreeOptions.PaintOptions = [toHideFocusRect, toHideSelection, toHotTrack, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages, toAlwaysHideSelection]
        TreeOptions.SelectionOptions = [toDisableDrawSelection, toFullRowSelect]
        OnClick = QuickpatternListClick
        AutoExpand = False
        OnGetRowPreferencesName = QuickpatternListGetRowPreferencesName
        OnCDataListReloadTree = QuickpatternListCDataListReloadTree
        Columns = <
          item
            Options = [coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
            Position = 0
            Width = 107
            WideText = 'Szablony'
          end>
        WideDefaultText = ''
      end
    end
  end
  object Panel: TCPanel [2]
    Left = 0
    Top = 0
    Width = 435
    Height = 65
    Align = alTop
    Alignment = taLeftJustify
    TabOrder = 1
    IsFlatButton = False
    object LabelFilterMovement: TLabel
      Left = 24
      Top = 4
      Width = 61
      Height = 13
      Caption = 'Typ operacji:'
    end
    object LabelFilterPeriod: TLabel
      Left = 290
      Top = 4
      Width = 85
      Height = 13
      Caption = 'Okres wykonania:'
    end
    object Label3: TLabel
      Left = 417
      Top = 4
      Width = 15
      Height = 13
      Caption = '(od'
    end
    object Label4: TLabel
      Left = 490
      Top = 4
      Width = 12
      Height = 13
      Caption = 'do'
    end
    object Label5: TLabel
      Left = 558
      Top = 4
      Width = 3
      Height = 13
      Caption = ')'
    end
    object LabelFilterCurrency: TLabel
      Left = 168
      Top = 4
      Width = 32
      Height = 13
      Caption = 'Kwoty:'
    end
    object Label1: TLabel
      Left = 40
      Top = 32
      Width = 41
      Height = 13
      Caption = 'Filtr w/g:'
    end
    object Label2: TLabel
      Left = 313
      Top = 32
      Width = 63
      Height = 13
      Alignment = taRightJustify
      Caption = 'Opis zawiera:'
    end
    object CStaticPeriod: TCStatic
      Left = 379
      Top = 4
      Width = 90
      Height = 15
      Cursor = crHandPoint
      Hint = '<tylko dzi'#347'>'
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
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      TabStop = True
      Transparent = False
      DataId = '1'
      TextOnEmpty = '<tylko dzi'#347'>'
      OnGetDataId = CStaticPeriodGetDataId
      OnChanged = CStaticFilterChanged
      HotTrack = True
    end
    object CStaticFilter: TCStatic
      Left = 89
      Top = 4
      Width = 74
      Height = 15
      Cursor = crHandPoint
      Hint = '<dowolny typ>'
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
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      TabStop = True
      Transparent = False
      DataId = '@'
      TextOnEmpty = '<dowolny typ>'
      OnGetDataId = CStaticFilterGetDataId
      OnChanged = CStaticFilterChanged
      HotTrack = True
    end
    object CDateTimePerStart: TCDateTime
      Left = 434
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
      TabOrder = 4
      TabStop = True
      Transparent = False
      OnChanged = CDateTimePerStartChanged
      HotTrack = True
      Withtime = False
    end
    object CDateTimePerEnd: TCDateTime
      Left = 504
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
      TabOrder = 5
      TabStop = True
      Transparent = False
      OnChanged = CDateTimePerStartChanged
      HotTrack = True
      Withtime = False
    end
    object CStaticViewCurrency: TCStatic
      Left = 201
      Top = 4
      Width = 88
      Height = 15
      Cursor = crHandPoint
      Hint = '<waluta operacji>'
      AutoSize = False
      BevelInner = bvNone
      BevelKind = bkTile
      BevelOuter = bvNone
      Caption = '<waluta operacji>'
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
      TabOrder = 2
      TabStop = True
      Transparent = False
      DataId = 'M'
      TextOnEmpty = '<dowolny typ>'
      OnGetDataId = CStaticViewCurrencyGetDataId
      OnChanged = CStaticViewCurrencyChanged
      HotTrack = True
    end
    object CButtonShowHideFilters: TCPanel
      Left = 4
      Top = 4
      Width = 14
      Height = 14
      Caption = '4'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -8
      Font.Name = 'Marlett'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = CButtonShowHideFiltersClick
      IsFlatButton = True
    end
    object CStaticFastFilter: TCStatic
      Left = 88
      Top = 28
      Width = 193
      Height = 21
      Cursor = crHandPoint
      Hint = '<okre'#347'l warunki wyboru>'
      AutoSize = False
      BevelKind = bkTile
      Caption = '<okre'#347'l warunki wyboru>'
      Color = clWindow
      ParentColor = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      TabStop = True
      Transparent = False
      TextOnEmpty = '<okre'#347'l warunki wyboru>'
      OnGetDataId = CStaticFastFilterGetDataId
      OnChanged = CStaticFastFilterChanged
      HotTrack = True
    end
    object FilterEditDescription: TEdit
      Left = 384
      Top = 28
      Width = 761
      Height = 21
      AutoSelect = False
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 7
      OnChange = FilterEditDescriptionChange
    end
  end
  object TodayList: TCList [3]
    Left = 0
    Top = 65
    Width = 435
    Height = 13
    Align = alClient
    BevelEdges = []
    BevelInner = bvNone
    BevelOuter = bvRaised
    BevelKind = bkFlat
    BorderStyle = bsNone
    ButtonStyle = bsTriangle
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
    Images = CImageLists.MovementIcons16x16
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
    TreeOptions.MiscOptions = [toCheckSupport, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
    TreeOptions.PaintOptions = [toHideFocusRect, toHideSelection, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    OnCompareNodes = TodayListCompareNodes
    OnDblClick = TodayListDblClick
    OnFocusChanged = TodayListFocusChanged
    OnGetText = TodayListGetText
    OnGetImageIndex = TodayListGetImageIndex
    OnGetHint = TodayListGetHint
    OnGetNodeDataSize = TodayListGetNodeDataSize
    OnInitChildren = TodayListInitChildren
    OnInitNode = TodayListInitNode
    AutoExpand = True
    OnGetRowPreferencesName = TodayListGetRowPreferencesName
    Columns = <
      item
        Alignment = taRightJustify
        Options = [coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
        Position = 0
        WideText = 'Lp'
      end
      item
        Position = 1
        Width = 135
        WideText = 'Opis'
        WideHint = 'Opis'
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
        Position = 4
        WideText = 'Waluta'
      end
      item
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark]
        Position = 5
        Width = 150
        WideText = 'Rodzaj'
      end
      item
        Options = [coAllowClick, coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark]
        Position = 6
        WideText = 'Status'
      end>
    WideDefaultText = ''
  end
  inherited ImageList: TPngImageList
    Top = 144
  end
  inherited ListPopupMenu: TPopupMenu
    Left = 464
    Top = 144
    object MenuItemsumsVisible: TMenuItem
      Caption = 'Sumy przychod'#243'w/rozchod'#243'w w wybranym okresie'
      Checked = True
      OnClick = MenuItemsumsVisibleClick
    end
    object MenuItemPatternsVisible: TMenuItem
      Caption = 'Szablony operacji'
      Checked = True
      OnClick = MenuItemPatternsVisibleClick
    end
  end
  object ActionList: TActionList
    Images = CImageLists.OperationsImageList24x24
    Left = 200
    Top = 112
    object ActionMovement: TAction
      Caption = 'Dodaj operacj'#281
      ImageIndex = 0
      OnExecute = ActionMovementExecute
    end
    object ActionEditMovement: TAction
      Caption = 'Edytuj'
      ImageIndex = 1
      OnExecute = ActionEditMovementExecute
    end
    object ActionDelMovement: TAction
      Caption = 'Usu'#324
      ImageIndex = 2
      OnExecute = ActionDelMovementExecute
    end
    object ActionAddList: TAction
      Caption = 'Dodaj list'#281
      ImageIndex = 0
      OnExecute = ActionAddListExecute
    end
  end
  object VTHeaderPopupMenu: TVTHeaderPopupMenu
    Left = 120
    Top = 120
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
  object PopupMenuQuickPatterns: TPopupMenu
    Left = 368
    Top = 168
    object MenuItemshowUserQuickpatterns: TMenuItem
      Caption = 'Pokazuj szablony u'#380'ytkownika'
      Checked = True
      OnClick = MenuItemshowUserQuickpatternsClick
    end
    object MenuItemStatisticQuickPatterns: TMenuItem
      Caption = 'Pokazuj szablony najcz'#281#347'ciej u'#380'ywanych operacji'
      Checked = True
      OnClick = MenuItemStatisticQuickPatternsClick
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object MenuItemQuickpatterns: TMenuItem
      Caption = 'Ustawienia listy'
      OnClick = MenuItemQuickpatternsClick
    end
  end
end
