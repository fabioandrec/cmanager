inherited CChartReportForm: TCChartReportForm
  Left = 268
  Top = 189
  Width = 678
  Height = 489
  Caption = 'CChartReportForm'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 670
    Height = 421
    BevelOuter = bvNone
    object Splitter: TSplitter
      Left = 131
      Top = 0
      Width = 2
      Height = 421
    end
    object PanelThumbs: TPanel
      Left = 0
      Top = 0
      Width = 131
      Height = 421
      Align = alLeft
      BevelOuter = bvLowered
      Caption = 'PanelThumbs'
      TabOrder = 0
      object ThumbsList: TVirtualStringTree
        Left = 1
        Top = 1
        Width = 129
        Height = 419
        Align = alClient
        BevelEdges = []
        BevelInner = bvNone
        BevelOuter = bvRaised
        BevelKind = bkFlat
        BorderStyle = bsNone
        ButtonStyle = bsTriangle
        Color = clWhite
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
        Images = CImageLists.ChartImageList32x32
        Indent = 20
        Margin = 15
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        TreeOptions.AutoOptions = [toAutoDropExpand, toAutoExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
        TreeOptions.MiscOptions = [toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
        TreeOptions.PaintOptions = [toHideFocusRect, toHotTrack, toShowDropmark, toThemeAware, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toFullRowSelect]
        OnFocusChanged = ThumbsListFocusChanged
        OnGetText = ThumbsListGetText
        OnGetImageIndex = ThumbsListGetImageIndex
        OnHotChange = ThumbsListHotChange
        Columns = <
          item
            Options = [coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
            Position = 0
            Width = 129
          end>
      end
    end
    object PanelParent: TPanel
      Left = 133
      Top = 0
      Width = 537
      Height = 421
      Align = alClient
      BevelOuter = bvLowered
      TabOrder = 1
      object PanelNoData: TPanel
        Left = 1
        Top = 1
        Width = 535
        Height = 419
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Brak danych do utworzenia wykres'#243'w'
        Color = clWhite
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGrayText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 421
    Width = 670
    inherited CButton3: TCButton
      Left = 76
    end
    object CButton4: TCButton [3]
      Left = 148
      Top = 8
      Width = 77
      Height = 25
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Action = ActionGraph
      Color = clBtnFace
    end
    inherited BitBtnOk: TBitBtn
      Left = 493
    end
    inherited BitBtnCancel: TBitBtn
      Left = 581
    end
  end
  inherited ActionList: TActionList
    inherited Action2: TAction
      Visible = False
    end
    object ActionGraph: TAction
      Caption = 'Wygl'#261'd'
      ImageIndex = 3
      OnExecute = ActionGraphExecute
    end
  end
  object PrintDialog: TPrintDialog
    Left = 129
    Top = 65
  end
end
