inherited CCashpointsFrame: TCCashpointsFrame
  object CashpointList: TVirtualStringTree [0]
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
    OnBeforeItemErase = CashpointListBeforeItemErase
    OnCompareNodes = CashpointListCompareNodes
    OnDblClick = CashpointListDblClick
    OnFocusChanged = CashpointListFocusChanged
    OnGetText = CashpointListGetText
    OnGetHint = CashpointListGetHint
    OnGetNodeDataSize = CashpointListGetNodeDataSize
    OnHeaderClick = CashpointListHeaderClick
    OnInitNode = CashpointListInitNode
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
    object CButtonAddCashpoint: TCButton
      Left = 13
      Top = 5
      Width = 137
      Height = 33
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Action = ActionAddCashpoint
    end
    object CButtonEditCashpoint: TCButton
      Left = 157
      Top = 5
      Width = 137
      Height = 33
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Action = ActionEditCahpoint
    end
    object CButtonDelCashpoint: TCButton
      Left = 305
      Top = 5
      Width = 137
      Height = 33
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Action = ActionDelCashpoint
    end
  end
  inherited ImageList: TPngImageList
    Height = 32
    Width = 32
    Left = 10
    Top = 56
  end
  object ActionList: TActionList
    Images = ImageList
    Left = 11
    Top = 16
    object ActionAddCashpoint: TAction
      Caption = 'Dodaj kontrahenta'
      ImageIndex = 0
      OnExecute = ActionAddCashpointExecute
    end
    object ActionEditCahpoint: TAction
      Caption = 'Edytuj kontrahenta'
      ImageIndex = 1
      OnExecute = ActionEditCahpointExecute
    end
    object ActionDelCashpoint: TAction
      Caption = 'Usu'#324' kontrahenta'
      ImageIndex = 2
      OnExecute = ActionDelCashpointExecute
    end
  end
  object VTHeaderPopupMenu: TVTHeaderPopupMenu
    Left = 80
    Top = 120
  end
end
