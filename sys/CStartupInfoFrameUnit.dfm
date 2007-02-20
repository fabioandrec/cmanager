inherited CStartupInfoFrame: TCStartupInfoFrame
  Width = 500
  object RepaymentList: TVirtualStringTree [0]
    Left = 0
    Top = 0
    Width = 500
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
    Header.Options = [hoAutoResize, hoColumnResize, hoVisible]
    Header.Style = hsFlatButtons
    HintMode = hmHint
    Indent = 40
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
    TreeOptions.MiscOptions = [toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
    TreeOptions.PaintOptions = [toHideFocusRect, toHideSelection, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages, toAlwaysHideSelection]
    TreeOptions.SelectionOptions = [toDisableDrawSelection, toFullRowSelect]
    TreeOptions.StringOptions = [toSaveCaptions, toShowStaticText, toAutoAcceptEditChange]
    OnBeforeItemErase = RepaymentListBeforeItemErase
    OnGetText = RepaymentListGetText
    OnPaintText = RepaymentListPaintText
    OnGetNodeDataSize = RepaymentListGetNodeDataSize
    OnInitChildren = RepaymentListInitChildren
    OnInitNode = RepaymentListInitNode
    Columns = <
      item
        Options = [coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
        Position = 0
        Width = 450
        WideText = 'Rodzaj/Data/Opis'
      end
      item
        Alignment = taRightJustify
        Options = [coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
        Position = 1
        WideText = 'Kwota'
      end>
  end
  object PanelError: TPanel [1]
    Left = 56
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
end
