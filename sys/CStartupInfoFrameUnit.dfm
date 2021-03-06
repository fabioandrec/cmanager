inherited CStartupInfoFrame: TCStartupInfoFrame
  object RepaymentList: TCList [0]
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
    Header.AutoSizeIndex = -1
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Sans Serif'
    Header.Font.Style = []
    Header.Height = 21
    Header.Options = [hoColumnResize, hoDrag, hoVisible]
    Header.PopupMenu = VTHeaderPopupMenu
    Header.Style = hsFlatButtons
    HintMode = hmHint
    Images = CImageLists.DoneImageList16x16
    Indent = 40
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
    TreeOptions.MiscOptions = [toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
    TreeOptions.PaintOptions = [toHideFocusRect, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    TreeOptions.StringOptions = [toSaveCaptions, toShowStaticText, toAutoAcceptEditChange]
    OnGetText = RepaymentListGetText
    OnGetImageIndexEx = RepaymentListGetImageIndexEx
    OnGetNodeDataSize = RepaymentListGetNodeDataSize
    OnInitChildren = RepaymentListInitChildren
    OnInitNode = RepaymentListInitNode
    AutoExpand = True
    OnGetRowPreferencesName = RepaymentListGetRowPreferencesName
    Columns = <
      item
        Options = [coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
        Position = 0
        Width = 450
        WideText = 'Opis'
      end
      item
        Alignment = taRightJustify
        Options = [coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
        Position = 1
        Width = 70
        WideText = 'Kwota'
      end
      item
        Options = [coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
        Position = 2
        WideText = 'Waluta'
      end
      item
        Options = [coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark]
        Position = 3
        Width = 70
        WideText = 'Rodzaj'
      end
      item
        Options = [coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark]
        Position = 4
        Width = 70
        WideText = 'Status'
      end>
    WideDefaultText = ''
  end
  object PanelError: TCPanel [1]
    Left = 42
    Top = 56
    Width = 370
    Height = 89
    Anchors = [akLeft, akTop, akRight]
    BevelOuter = bvNone
    Caption = 'Nie masz aktualnie '#380'adnych powiadomie'#324' do wy'#347'wietlenia'
    Color = clWindow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGrayText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object VTHeaderPopupMenu: TVTHeaderPopupMenu
    Left = 160
    Top = 48
  end
end