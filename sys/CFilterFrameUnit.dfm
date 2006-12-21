inherited CFilterFrame: TCFilterFrame
  object FilterList: TVirtualStringTree [0]
    Left = 0
    Top = 0
    Width = 443
    Height = 236
    Align = alClient
    BevelEdges = [beBottom]
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
    Header.SortColumn = 0
    Header.Style = hsFlatButtons
    HintMode = hmHint
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
    TreeOptions.MiscOptions = [toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
    TreeOptions.PaintOptions = [toHideFocusRect, toHideSelection, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    OnBeforeItemErase = FilterListBeforeItemErase
    OnCompareNodes = FilterListCompareNodes
    OnDblClick = FilterListDblClick
    OnFocusChanged = FilterListFocusChanged
    OnGetText = FilterListGetText
    OnGetHint = FilterListGetHint
    OnGetNodeDataSize = FilterListGetNodeDataSize
    OnHeaderClick = FilterListHeaderClick
    OnInitNode = FilterListInitNode
    Columns = <
      item
        Position = 0
        Width = 443
        WideText = 'Nazwa'
        WideHint = 'Nazwa kontrahenta'
      end>
  end
  object PanelFrameButtons: TPanel [1]
    Left = 0
    Top = 236
    Width = 443
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    Color = clWindow
    TabOrder = 1
    object CButtonAddFilter: TCButton
      Left = 13
      Top = 5
      Width = 137
      Height = 33
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Action = ActionAddFilter
    end
    object CButtonEditFilter: TCButton
      Left = 157
      Top = 5
      Width = 137
      Height = 33
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Action = ActionEditFilter
    end
    object CButtonDelFilter: TCButton
      Left = 305
      Top = 5
      Width = 137
      Height = 33
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Action = ActionDelFilter
    end
  end
  inherited ImageList: TPngImageList
    Left = 10
    Top = 56
  end
  object ActionList: TActionList
    Images = CImageLists.FilterImageList24x24
    Left = 11
    Top = 16
    object ActionAddFilter: TAction
      Caption = 'Dodaj filtr'
      ImageIndex = 0
      OnExecute = ActionAddFilterExecute
    end
    object ActionEditFilter: TAction
      Caption = 'Edytuj filtr'
      ImageIndex = 1
      OnExecute = ActionEditFilterExecute
    end
    object ActionDelFilter: TAction
      Caption = 'Usu'#324' filtr'
      ImageIndex = 2
      OnExecute = ActionDelFilterExecute
    end
  end
  object VTHeaderPopupMenu: TVTHeaderPopupMenu
    Left = 80
    Top = 120
  end
end
