inherited CDescTemplatesFrame: TCDescTemplatesFrame
  object TempList: TCList [0]
    Left = 0
    Top = 0
    Width = 443
    Height = 277
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
    Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoVisible]
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
    OnDblClick = TempListDblClick
    OnFocusChanged = TempListFocusChanged
    OnGetText = TempListGetText
    OnGetHint = TempListGetHint
    OnGetNodeDataSize = TempListGetNodeDataSize
    OnInitChildren = TempListInitChildren
    OnInitNode = TempListInitNode
    AutoExpand = True
    OnGetRowPreferencesName = TempListGetRowPreferencesName
    Columns = <
      item
        Options = [coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
        Position = 0
        Width = 150
        WideText = 'Mnemonik'
        WideHint = 'Nazwa kontrahenta'
      end
      item
        Options = [coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
        Position = 1
        Width = 143
        WideText = 'Opis'
      end
      item
        Options = [coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
        Position = 2
        Width = 150
        WideText = 'Aktualna warto'#347#263
      end>
    WideDefaultText = ''
  end
end
