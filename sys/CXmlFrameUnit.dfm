inherited CXmlFrame: TCXmlFrame
  Color = clBtnFace
  object Panel1: TCPanel [0]
    Left = 0
    Top = 0
    Width = 443
    Height = 277
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 0
    object Panel3: TCPanel
      Left = 0
      Top = 0
      Width = 443
      Height = 277
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel3'
      TabOrder = 0
      object List: TCDataList
        Left = 0
        Top = 0
        Width = 443
        Height = 277
        Align = alClient
        BevelEdges = []
        BevelInner = bvNone
        BevelOuter = bvNone
        BevelKind = bkFlat
        BorderStyle = bsNone
        ButtonStyle = bsTriangle
        CheckImageKind = ckDarkTick
        DefaultNodeHeight = 24
        Header.AutoSizeIndex = -1
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'MS Sans Serif'
        Header.Font.Style = []
        Header.Height = 21
        Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
        Header.Style = hsFlatButtons
        HintMode = hmHint
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
        TreeOptions.MiscOptions = [toCheckSupport, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
        TreeOptions.PaintOptions = [toHideFocusRect, toHideSelection, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toFullRowSelect]
        OnFocusChanged = ListFocusChanged
        AutoExpand = False
        OnGetRowPreferencesName = ListGetRowPreferencesName
        OnCDataListReloadTree = ListCDataListReloadTree
        Columns = <
          item
            Position = 0
            Width = 443
            WideText = 'Nazwa'
          end>
        WideDefaultText = ''
      end
    end
  end
  inherited ImageList: TPngImageList
    Left = 32
    Top = 96
  end
  inherited ListPopupMenu: TPopupMenu
    Left = 112
    Top = 104
  end
end