inherited CFilterDetailFrame: TCFilterDetailFrame
  object Splitter: TSplitter [0]
    Left = 131
    Top = 28
    Width = 2
    Height = 249
    Color = clBtnFace
    ParentColor = False
  end
  object PanelThumbs: TPanel [1]
    Left = 0
    Top = 28
    Width = 131
    Height = 249
    Align = alLeft
    BevelOuter = bvLowered
    Caption = 'PanelThumbs'
    TabOrder = 0
    object ThumbsList: TVirtualStringTree
      Left = 1
      Top = 22
      Width = 129
      Height = 226
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
    object PanelShortcutsTitle: TPanel
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
      DesignSize = (
        129
        21)
      object SpeedButtonCloseShortcuts: TSpeedButton
        Left = 133
        Top = 5
        Width = 13
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
      end
    end
  end
  object PanelFrames: TPanel [2]
    Left = 133
    Top = 28
    Width = 310
    Height = 249
    Align = alClient
    BevelOuter = bvLowered
    Color = clWindow
    TabOrder = 1
  end
  object Panel1: TPanel [3]
    Left = 0
    Top = 0
    Width = 443
    Height = 28
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      443
      28)
    object CStaticFilter: TCStatic
      Left = 0
      Top = 3
      Width = 443
      Height = 21
      Cursor = crHandPoint
      Alignment = taCenter
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      BevelKind = bkTile
      Caption = '<wybierz predefiniowany filtr z listy>'
      Color = clWindow
      ParentColor = False
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
end
