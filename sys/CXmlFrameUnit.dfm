inherited CXmlFrame: TCXmlFrame
  Width = 468
  Color = clBtnFace
  object Panel1: TPanel [0]
    Left = 0
    Top = 0
    Width = 468
    Height = 277
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 0
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 468
      Height = 40
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object Label1: TLabel
        Left = 16
        Top = 12
        Width = 417
        Height = 13
        Caption = 
          'Zaznacz tylko te dane domy'#347'lne, kt'#243're powinny by'#263' zapami'#281'tane w ' +
          'nowym pliku danych'
      end
    end
    object Panel3: TPanel
      Left = 0
      Top = 40
      Width = 468
      Height = 237
      Align = alClient
      BevelOuter = bvLowered
      Caption = 'Panel3'
      TabOrder = 1
      object List: TCDataList
        Left = 1
        Top = 1
        Width = 466
        Height = 235
        Align = alClient
        BevelEdges = []
        BevelInner = bvNone
        BevelOuter = bvNone
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
        AutoExpand = False
        OnGetRowPreferencesName = ListGetRowPreferencesName
        OnCDataListReloadTree = ListCDataListReloadTree
        Columns = <
          item
            Position = 0
            Width = 466
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