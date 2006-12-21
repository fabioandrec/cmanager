inherited CReportsFrame: TCReportsFrame
  object ReportList: TVirtualStringTree [0]
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
    Header.Style = hsFlatButtons
    HintMode = hmHint
    Images = ImageList
    Indent = 20
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
    TreeOptions.MiscOptions = [toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
    TreeOptions.PaintOptions = [toHideFocusRect, toHideSelection, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    OnBeforeItemErase = ReportListBeforeItemErase
    OnDblClick = ReportListDblClick
    OnFocusChanged = ReportListFocusChanged
    OnGetText = ReportListGetText
    OnGetImageIndex = ReportListGetImageIndex
    OnGetHint = ReportListGetHint
    OnGetNodeDataSize = ReportListGetNodeDataSize
    OnInitChildren = ReportListInitChildren
    OnInitNode = ReportListInitNode
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
    object CButtonExecute: TCButton
      Left = 13
      Top = 5
      Width = 137
      Height = 33
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Action = ActionExecute
    end
  end
  object ActionList: TActionList
    Images = CImageLists.StatsImageList24x24
    Left = 11
    Top = 48
    object ActionExecute: TAction
      Caption = 'Uruchom raport'
      ImageIndex = 0
      OnExecute = ActionExecuteExecute
    end
  end
  object VTHeaderPopupMenu: TVTHeaderPopupMenu
    Left = 80
    Top = 152
  end
end
