object CMainForm: TCMainForm
  Left = 362
  Top = 288
  Width = 869
  Height = 634
  Caption = 'CManager'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object MenuBar: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 861
    Height = 24
    UseSystemFont = False
    ActionManager = ActionManager
    Caption = 'MenuBar'
    ColorMap.HighlightColor = 10725814
    ColorMap.BtnSelectedColor = clBtnFace
    ColorMap.UnusedColor = 10725814
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Microsoft Sans Serif'
    Font.Style = []
    Spacing = 0
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 588
    Width = 861
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object PanelMain: TPanel
    Left = 0
    Top = 24
    Width = 861
    Height = 564
    Align = alClient
    BevelOuter = bvNone
    Caption = 'PanelMain'
    TabOrder = 2
    object BevelU2: TBevel
      Left = 0
      Top = 21
      Width = 861
      Height = 3
      Align = alTop
      Shape = bsSpacer
    end
    object PanelTitle: TPanel
      Left = 0
      Top = 0
      Width = 861
      Height = 21
      Align = alTop
      Alignment = taRightJustify
      BevelOuter = bvNone
      Color = clBtnShadow
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindow
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      DesignSize = (
        861
        21)
      object BevelU1: TBevel
        Left = 0
        Top = 0
        Width = 861
        Height = 3
        Align = alTop
        Shape = bsSpacer
      end
      object LabelShortcut: TLabel
        Left = 30
        Top = 3
        Width = 100
        Height = 16
        Caption = 'ActiveShortcut'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindow
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object ImageShortcut: TImage
        Left = 6
        Top = 3
        Width = 16
        Height = 16
        Center = True
        Transparent = True
      end
      object CDateTime: TCDateTime
        Left = 776
        Top = 3
        Width = 81
        Height = 15
        Cursor = crHandPoint
        Anchors = [akTop, akRight]
        AutoSize = False
        BevelInner = bvNone
        BevelKind = bkTile
        BevelOuter = bvNone
        Caption = '2006-08-20'
        Color = clBtnShadow
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindow
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 0
        Visible = False
        Value = 38949.000000000000000000
        OnChanged = CDateTimeChanged
        HotTrack = True
      end
    end
    object PanelFrames: TPanel
      Left = 170
      Top = 24
      Width = 691
      Height = 540
      Align = alClient
      BevelOuter = bvLowered
      Color = clWindow
      TabOrder = 1
    end
    object PanelShortcuts: TPanel
      Left = 0
      Top = 24
      Width = 170
      Height = 540
      Align = alLeft
      BevelOuter = bvLowered
      Color = clWindow
      TabOrder = 2
      DesignSize = (
        170
        540)
      object PanelShortcutsTitle: TPanel
        Left = 1
        Top = 1
        Width = 168
        Height = 21
        Align = alTop
        Alignment = taLeftJustify
        Caption = '  Skr'#243'ty'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        DesignSize = (
          168
          21)
        object SpeedButtonCloseShortcuts: TSpeedButton
          Left = 151
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
          OnClick = SpeedButtonCloseShortcutsClick
        end
      end
      object ShortcutList: TVirtualStringTree
        Left = 1
        Top = 48
        Width = 168
        Height = 480
        Anchors = [akLeft, akTop, akRight, akBottom]
        BevelEdges = []
        BevelInner = bvNone
        BevelOuter = bvRaised
        BevelKind = bkFlat
        BorderStyle = bsNone
        ButtonStyle = bsTriangle
        Colors.HotColor = clNavy
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
        Images = ImageListActionManager
        Indent = 20
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        TreeOptions.AutoOptions = [toAutoDropExpand, toAutoExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
        TreeOptions.MiscOptions = [toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
        TreeOptions.PaintOptions = [toHideFocusRect, toHideSelection, toHotTrack, toShowDropmark, toThemeAware, toUseBlendedImages, toAlwaysHideSelection]
        TreeOptions.SelectionOptions = [toFullRowSelect]
        OnAfterItemPaint = ShortcutListAfterItemPaint
        OnClick = ShortcutListClick
        OnGetText = ShortcutListGetText
        OnHotChange = ShortcutListHotChange
        Columns = <
          item
            Alignment = taCenter
            Options = [coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
            Position = 0
            Width = 168
          end>
      end
    end
  end
  object ImageListActionManager: TPngImageList
    PngImages = <>
    Left = 483
    Top = 99
  end
  object ActionManager: TActionManager
    ActionBars = <
      item
        Items.SmallIcons = False
        Items = <>
      end
      item
        Items = <
          item
            Items = <
              item
                Action = ActionShortcuts
                Caption = '&Pasek skr'#243't'#243'w'
              end
              item
                Action = ActionStatusbar
                Caption = 'P&asek stanu'
              end>
            Caption = '&Widok'
          end
          item
            Items = <
              item
                Action = ActionShorcutOperations
                Caption = '&Operacje wykonane'
                ImageIndex = 0
              end
              item
                Action = ActionShortcutPlannedDone
                Caption = '&Czynno'#347'ci zaplanowane'
                ImageIndex = 0
              end
              item
                Action = ActionShortcutPlanned
                Caption = '&Definicje plan'#243'w'
                ImageIndex = 0
              end
              item
                Action = ActionShortcutAccounts
                Caption = '&Lista kont'
                ImageIndex = 0
              end
              item
                Action = ActionShortcutProducts
                Caption = 'L&ista kategorii'
                ImageIndex = 1
              end
              item
                Action = ActionShortcutCashpoints
                Caption = 'Li&sta kontrahent'#243'w'
                ImageIndex = 0
              end
              item
                Action = ActionShortcutReports
                Caption = 'S&tatystyka, raporty'
                ImageIndex = 1
              end>
            Caption = '&Skr'#243'ty'
          end
          item
            Items = <
              item
                Action = ActionAbout
                Caption = '&O programie'
              end>
            Caption = '&Pomoc'
          end>
        ActionBar = MenuBar
      end>
    Images = ImageListActionManager
    Left = 440
    Top = 96
    StyleName = 'XP Style'
    object ActionShortcuts: TAction
      Category = 'Widok'
      Caption = 'Pasek skr'#243't'#243'w'
      OnExecute = ActionShortcutsExecute
    end
    object ActionShorcutOperations: TAction
      Category = 'Skr'#243'ty'
      Caption = 'Operacje wykonane'
      ImageIndex = 0
    end
    object ActionShortcutPlannedDone: TAction
      Category = 'Skr'#243'ty'
      Caption = 'Czynno'#347'ci zaplanowane'
      ImageIndex = 1
    end
    object ActionShortcutPlanned: TAction
      Category = 'Skr'#243'ty'
      Caption = 'Definicje plan'#243'w'
    end
    object ActionShortcutAccounts: TAction
      Category = 'Skr'#243'ty'
      Caption = 'Lista kont'
    end
    object ActionShortcutProducts: TAction
      Category = 'Skr'#243'ty'
      Caption = 'Lista kategorii'
    end
    object ActionShortcutCashpoints: TAction
      Category = 'Skr'#243'ty'
      Caption = 'Lista kontrahent'#243'w'
    end
    object ActionShortcutReports: TAction
      Category = 'Skr'#243'ty'
      Caption = 'Statystyka, raporty'
    end
    object ActionStatusbar: TAction
      Category = 'Widok'
      Caption = 'Pasek stanu'
      OnExecute = ActionStatusbarExecute
    end
    object ActionAbout: TAction
      Category = 'Pomoc'
      Caption = 'O programie'
      OnExecute = ActionAboutExecute
    end
  end
end
