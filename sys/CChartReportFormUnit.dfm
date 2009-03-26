inherited CChartReportForm: TCChartReportForm
  Left = 231
  Top = 153
  Width = 835
  Height = 694
  Caption = 'CChartReportForm'
  OnMouseWheel = FormMouseWheel
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 819
    Height = 617
    DesignSize = (
      819
      617)
    inherited PanelReport: TPanel
      Anchors = [akLeft, akTop, akRight, akBottom]
      object Splitter: TSplitter
        Left = 132
        Top = 1
        Width = 2
        Height = 556
      end
      object PanelThumbs: TPanel
        Left = 1
        Top = 1
        Width = 131
        Height = 556
        Align = alLeft
        BevelOuter = bvNone
        Caption = 'PanelThumbs'
        TabOrder = 0
        object PanelShortcutsTitle: TPanel
          Left = 0
          Top = 0
          Width = 131
          Height = 21
          Align = alTop
          Alignment = taLeftJustify
          Caption = '  Waluty'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          DesignSize = (
            131
            21)
          object SpeedButtonCloseShortcuts: TSpeedButton
            Left = 135
            Top = 5
            Width = 13
            Height = 13
            Anchors = [akTop, akRight]
            Caption = 'r'
            Flat = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -8
            Font.Name = 'Marlett'
            Font.Style = []
            ParentFont = False
          end
        end
        object Panel1: TPanel
          Left = 0
          Top = 21
          Width = 131
          Height = 535
          Align = alClient
          Caption = 'Panel1'
          TabOrder = 1
          object ThumbsList: TCList
            Left = 1
            Top = 1
            Width = 129
            Height = 533
            Align = alClient
            BevelEdges = []
            BevelInner = bvNone
            BevelOuter = bvRaised
            BevelKind = bkFlat
            BorderStyle = bsNone
            ButtonStyle = bsTriangle
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
            PopupMenu = PopupMenu1
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
            AutoExpand = True
            OnGetRowPreferencesName = ThumbsListGetRowPreferencesName
            Columns = <
              item
                Options = [coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
                Position = 0
                Width = 129
              end>
            WideDefaultText = ''
          end
        end
      end
      object PanelParent: TPanel
        Left = 134
        Top = 1
        Width = 663
        Height = 556
        Align = alClient
        TabOrder = 1
        object PanelChart: TPanel
          Left = 1
          Top = 1
          Width = 661
          Height = 554
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelChart'
          TabOrder = 0
          object PanelNoData: TPanel
            Left = 0
            Top = 0
            Width = 661
            Height = 554
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
    end
  end
  inherited PanelButtons: TPanel
    Top = 617
    Width = 819
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
      Left = 650
    end
    inherited BitBtnCancel: TBitBtn
      Left = 738
    end
  end
  inherited ActionList: TActionList
    Left = 320
    Top = 120
    inherited Action2: TAction
      Visible = False
    end
    object ActionGraph: TAction
      Caption = 'Wygl'#261'd'
      ImageIndex = 3
      OnExecute = ActionGraphExecute
    end
  end
  inherited SaveDialog: TSaveDialog
    Left = 250
    Top = 162
  end
  object PrintDialog: TPrintDialog
    Left = 129
    Top = 65
  end
  object PopupMenu1: TPopupMenu
    Left = 152
    Top = 100
    object MenuItemList: TMenuItem
      Caption = 'Ustawienia listy'
      ImageIndex = 0
      OnClick = MenuItemListClick
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object MenuItemBig: TMenuItem
      Caption = 'Du'#380'e ikony'
      Checked = True
      RadioItem = True
      OnClick = MenuItemBigClick
    end
    object MenuItemSmall: TMenuItem
      Caption = 'Ma'#322'e ikony'
      RadioItem = True
      OnClick = MenuItemSmallClick
    end
  end
end
