inherited CProductsFrame: TCProductsFrame
  object ProductList: TVirtualStringTree [0]
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
    Indent = 20
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
    TreeOptions.MiscOptions = [toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
    TreeOptions.PaintOptions = [toHideFocusRect, toHideSelection, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    OnBeforeItemErase = ProductListBeforeItemErase
    OnCompareNodes = ProductListCompareNodes
    OnDblClick = ProductListDblClick
    OnFocusChanged = ProductListFocusChanged
    OnGetText = ProductListGetText
    OnGetHint = ProductListGetHint
    OnGetNodeDataSize = ProductListGetNodeDataSize
    OnHeaderClick = ProductListHeaderClick
    OnInitChildren = ProductListInitChildren
    OnInitNode = ProductListInitNode
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
    object CButtonAddCategory: TCButton
      Left = 13
      Top = 5
      Width = 137
      Height = 33
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Action = ActionAddRootCategory
    end
    object CButtonAddSubcategory: TCButton
      Left = 157
      Top = 5
      Width = 137
      Height = 33
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Action = ActionAddSubCategory
    end
    object CButtonEditCategory: TCButton
      Left = 301
      Top = 5
      Width = 137
      Height = 33
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Action = ActionEditCategory
    end
    object CButtonDelCategory: TCButton
      Left = 449
      Top = 5
      Width = 137
      Height = 33
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Action = ActionDelCategory
    end
  end
  object ActionList: TActionList
    Images = ImageList
    Left = 11
    Top = 48
    object ActionAddSubCategory: TAction
      Caption = 'Dodaj podkategori'#281
      ImageIndex = 0
      OnExecute = ActionAddSubCategoryExecute
    end
    object ActionEditCategory: TAction
      Caption = 'Edytuj kategori'#281
      ImageIndex = 0
      OnExecute = ActionEditCategoryExecute
    end
    object ActionDelCategory: TAction
      Caption = 'Usu'#324' kategori'#281
      ImageIndex = 0
      OnExecute = ActionDelCategoryExecute
    end
    object ActionAddRootCategory: TAction
      Caption = 'Dodaj kategori'#281
      ImageIndex = 0
      OnExecute = ActionAddRootCategoryExecute
    end
  end
  object VTHeaderPopupMenu: TVTHeaderPopupMenu
    Left = 80
    Top = 152
  end
end
