inherited CFilterDetailFrame: TCFilterDetailFrame
  object Splitter: TSplitter [0]
    Left = 131
    Top = 0
    Width = 2
    Height = 277
    Color = clBtnFace
    ParentColor = False
  end
  object PanelThumbs: TPanel [1]
    Left = 0
    Top = 0
    Width = 131
    Height = 277
    Align = alLeft
    BevelOuter = bvLowered
    Caption = 'PanelThumbs'
    TabOrder = 0
    object ThumbsList: TVirtualStringTree
      Left = 1
      Top = 1
      Width = 129
      Height = 275
      Align = alClient
      BevelEdges = []
      BevelInner = bvNone
      BevelOuter = bvRaised
      BevelKind = bkFlat
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
      ShowHint = True
      TabOrder = 0
      TreeOptions.AutoOptions = [toAutoDropExpand, toAutoExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
      TreeOptions.MiscOptions = [toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
      TreeOptions.PaintOptions = [toHideFocusRect, toHotTrack, toShowDropmark, toThemeAware, toUseBlendedImages]
      TreeOptions.SelectionOptions = [toFullRowSelect]
      OnChange = ThumbsListChange
      OnGetText = ThumbsListGetText
      OnGetImageIndex = ThumbsListGetImageIndex
      Columns = <
        item
          Options = [coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
          Position = 0
          Width = 129
        end>
    end
  end
  object PanelFrames: TPanel [2]
    Left = 133
    Top = 0
    Width = 310
    Height = 277
    Align = alClient
    BevelOuter = bvLowered
    Color = clWindow
    TabOrder = 1
  end
end
