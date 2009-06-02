inherited CFilterDetailFrame: TCFilterDetailFrame
  object Splitter: TSplitter [0]
    Left = 131
    Top = 28
    Width = 2
    Height = 240
    Color = clBtnFace
    ParentColor = False
  end
  object PanelThumbs: TCPanel [1]
    Left = 0
    Top = 28
    Width = 131
    Height = 240
    Align = alLeft
    BevelOuter = bvLowered
    Caption = 'PanelThumbs'
    TabOrder = 0
    object ThumbsList: TCList
      Left = 1
      Top = 22
      Width = 129
      Height = 217
      Align = alClient
      BevelEdges = []
      BevelInner = bvNone
      BevelOuter = bvRaised
      BorderStyle = bsNone
      ButtonStyle = bsTriangle
      Colors.HotColor = clNavy
      Colors.UnfocusedSelectionColor = clHighlight
      Colors.UnfocusedSelectionBorderColor = clHighlight
      DefaultNodeHeight = 60
      Header.AutoSizeIndex = -1
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'MS Sans Serif'
      Header.Font.Style = []
      Header.Height = 21
      Header.Options = [hoAutoResize, hoDrag, hoShowSortGlyphs]
      Header.SortColumn = 0
      Header.Style = hsFlatButtons
      HintMode = hmHint
      Images = CImageLists.MainImageList32x32
      Indent = 20
      Margin = 15
      ParentShowHint = False
      PopupMenu = PopupMenu1
      ShowHint = True
      TabOrder = 0
      TreeOptions.AutoOptions = [toAutoDropExpand, toAutoExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
      TreeOptions.MiscOptions = [toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
      TreeOptions.PaintOptions = [toHideFocusRect, toHotTrack, toShowDropmark, toThemeAware, toUseBlendedImages]
      TreeOptions.SelectionOptions = [toFullRowSelect]
      OnChange = ThumbsListChange
      OnGetText = ThumbsListGetText
      OnGetImageIndex = ThumbsListGetImageIndex
      AutoExpand = True
      OnGetRowPreferencesName = ThumbsListGetRowPreferencesName
      Columns = <
        item
          Options = [coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
          Position = 0
          Width = 129
        end>
      WideDefaultText = ''
    end
    object PanelShortcutsTitle: TCPanel
      Left = 1
      Top = 1
      Width = 129
      Height = 21
      Align = alTop
      Alignment = taLeftJustify
      Caption = '  Elementy'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
  end
  object PanelFrames: TCPanel [2]
    Left = 133
    Top = 28
    Width = 302
    Height = 240
    Align = alClient
    BevelOuter = bvLowered
    Color = clWindow
    TabOrder = 1
  end
  object Panel1: TCPanel [3]
    Left = 0
    Top = 0
    Width = 435
    Height = 28
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      435
      28)
    object CStaticFilter: TCStatic
      Left = 0
      Top = 3
      Width = 443
      Height = 21
      Cursor = crHandPoint
      Hint = '<wybierz predefiniowany filtr z listy>'
      Alignment = taCenter
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      BevelKind = bkTile
      Caption = '<wybierz predefiniowany filtr z listy>'
      Color = clWindow
      ParentColor = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TabStop = True
      Transparent = False
      TextOnEmpty = '<wybierz predefiniowany filtr z listy>'
      OnGetDataId = CStaticPredefinedGetDataId
      OnChanged = CStaticPredefinedChanged
      HotTrack = True
    end
  end
  inherited ImageList: TPngImageList
    Left = 24
    Top = 104
  end
  inherited ListPopupMenu: TPopupMenu
    Left = 240
    Top = 128
  end
  object PopupMenu1: TPopupMenu
    Left = 152
    Top = 100
    object MenuItemList: TMenuItem
      Caption = 'Ustawienia listy'
      ImageIndex = 0
      OnClick = Zaznaczwszystkie1Click
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object MenuItemBig: TMenuItem
      Caption = 'Du'#380'e ikony'
      Checked = True
      RadioItem = True
      OnClick = MenuItemBigClick
    end
    object MenuItemSmall: TMenuItem
      Caption = 'Ma'#322'e ikony'
      RadioItem = True
      OnClick = MenuItemSmallClick
    end
  end
end
