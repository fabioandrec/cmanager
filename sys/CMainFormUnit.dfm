object CMainForm: TCMainForm
  Left = 129
  Top = 66
  Width = 863
  Height = 635
  Caption = 'CManager'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object MenuBar: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 855
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
    ParentShowHint = False
    ShowHint = True
    Spacing = 0
  end
  object StatusBar: TCStatusBar
    Left = 0
    Top = 589
    Width = 855
    Height = 19
    Panels = <
      item
        Style = psOwnerDraw
        Width = 400
        ImageIndex = 0
        Clickable = False
      end
      item
        Style = psOwnerDraw
        Width = 50
        ImageIndex = -1
        Clickable = True
      end>
    OnClick = StatusBarClick
    ImageList = CImageLists.StatusbarImagesList16x16
  end
  object PanelNotconnected: TPanel
    Left = 0
    Top = 24
    Width = 855
    Height = 41
    Align = alTop
    BevelOuter = bvLowered
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clInactiveCaption
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object PanelMain: TPanel
    Left = 0
    Top = 65
    Width = 855
    Height = 524
    Align = alClient
    BevelOuter = bvNone
    Caption = 'PanelMain'
    TabOrder = 3
    object BevelU2: TBevel
      Left = 0
      Top = 21
      Width = 855
      Height = 3
      Align = alTop
      Shape = bsSpacer
    end
    object PanelTitle: TPanel
      Left = 0
      Top = 0
      Width = 855
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
        855
        21)
      object BevelU1: TBevel
        Left = 0
        Top = 0
        Width = 855
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
      object PngImage: TPngSpeedButton
        Left = 6
        Top = 3
        Width = 16
        Height = 16
        Enabled = False
        Flat = True
        PngOptions = []
      end
      object CDateTime: TCDateTime
        Left = 770
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
        TabStop = True
        Transparent = False
        Visible = False
        Value = 38949.000000000000000000
        OnChanged = CDateTimeChanged
        HotTrack = True
      end
    end
    object PanelFrames: TPanel
      Left = 170
      Top = 24
      Width = 685
      Height = 500
      Align = alClient
      BevelOuter = bvLowered
      Color = clWindow
      TabOrder = 1
    end
    object PanelShortcuts: TPanel
      Left = 0
      Top = 24
      Width = 170
      Height = 500
      Align = alLeft
      BevelOuter = bvLowered
      Color = clWindow
      TabOrder = 2
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
        Top = 22
        Width = 168
        Height = 477
        Align = alClient
        BevelEdges = []
        BevelInner = bvNone
        BevelOuter = bvRaised
        BevelKind = bkFlat
        BorderStyle = bsNone
        ButtonStyle = bsTriangle
        Colors.HotColor = clNavy
        DefaultNodeHeight = 80
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
        OnMeasureItem = ShortcutListMeasureItem
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
                Action = ActionCreateConnection
                Caption = '&Nowy plik danych'
              end
              item
                Action = ActionOpenConnection
                Caption = '&Otw'#243'rz plik danych'
              end
              item
                Action = ActionCloseConnection
                Caption = '&Zamknij plik danych'
              end
              item
                Items = <
                  item
                    Action = ActionCompact
                    Caption = '&Kompaktuj plik danych'
                  end
                  item
                    Action = ActionExport
                    Caption = '&Eksportuj plik danych'
                  end
                  item
                    Action = ActionBackup
                    Caption = '&Wykonaj kopi'#281' pliku danych'
                  end
                  item
                    Action = ActionRestore
                    Caption = '&Odtw'#243'rz plik danych z kopii'
                  end
                  item
                    Action = ActionCheckDatafile
                    Caption = '&Sprawd'#378' plik danych'
                  end
                  item
                    Action = ActionRandom
                    Caption = 'W&ype'#322'nij losowo dane'
                  end>
                Caption = 'N&arz'#281'dzia'
              end>
            Caption = 'P&lik'
          end
          item
            Items = <
              item
                Action = ActionShortcutStart
                Caption = '&Start'
                ImageIndex = 0
              end
              item
                Action = ActionShorcutOperations
                Caption = '&Operacje wykonane'
                ImageIndex = 1
              end
              item
                Action = ActionShortcutPlannedDone
                Caption = '&Czynno'#347'ci zaplanowane'
                ImageIndex = 2
              end
              item
                Action = ActionShortcutPlanned
                Caption = '&Definicje plan'#243'w'
                ImageIndex = 3
              end
              item
                Action = ActionShortcutAccounts
                Caption = '&Lista kont'
                ImageIndex = 4
              end
              item
                Action = ActionShortcutProducts
                Caption = 'L&ista kategorii'
                ImageIndex = 5
              end
              item
                Action = ActionShortcutCashpoints
                Caption = 'Lis&ta kontrahent'#243'w'
                ImageIndex = 6
              end
              item
                Action = ActionShortcutReports
                Caption = 'St&atystyka, raporty'
                ImageIndex = 7
              end
              item
                Action = ActionShortcutFilters
                Caption = '&Filtry'
                ImageIndex = 8
              end
              item
                Action = ActionShortcutProfiles
                Caption = '&Profile'
                ImageIndex = 9
              end
              item
                Action = ActionShortcutLimits
                Caption = 'Li&mity'
                ImageIndex = 10
              end
              item
                Action = ActionShortcutCurrencydef
                Caption = '&Waluty'
                ImageIndex = 11
              end
              item
                Action = ActionShortcutCurrencyRate
                Caption = '&Kursy walut'
                ImageIndex = 12
              end>
            Caption = '&Skr'#243'ty'
          end
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
                Action = ActionPreferences
                Caption = '&Preferencje'
              end
              item
                Action = ActionLoanCalc
                Caption = '&Kalkulator kredytowy'
              end
              item
                Action = ActionImportCurrencyRates
                Caption = 'W&czytaj kursy walut'
              end
              item
                Caption = '&Wtyczki'
              end>
            Caption = '&Narz'#281'dzia'
          end
          item
            Items = <
              item
                Action = ActionHelp
                Caption = '&Spis tre'#347'ci'
              end
              item
                Action = ActionHistory
              end
              item
                Caption = '-'
              end
              item
                Action = ActionBug
                Caption = '&Zg'#322'o'#347' b'#322#261'd'
                ImageIndex = 13
              end
              item
                Action = ActionFutureRequest
                Caption = 'Z&aproponuj zmian'#281
              end
              item
                Caption = '-'
              end
              item
                Action = ActionCheckUpdates
                Caption = 'S&prawd'#378' aktualizacje'
                ImageIndex = 14
              end
              item
                Action = ActionAbout
                Caption = '&O programie'
              end>
            Caption = '&Pomoc'
          end>
        ActionBar = MenuBar
      end>
    Images = CImageLists.MainImageList16x16
    Left = 440
    Top = 96
    StyleName = 'XP Style'
    object ActionShortcuts: TAction
      Category = 'Widok'
      Caption = 'Pasek skr'#243't'#243'w'
      OnExecute = ActionShortcutsExecute
    end
    object ActionShortcutStart: TAction
      Category = 'Skr'#243'ty'
      Caption = 'Start'
      ImageIndex = 0
    end
    object ActionShorcutOperations: TAction
      Category = 'Skr'#243'ty'
      Caption = 'Operacje wykonane'
      ImageIndex = 1
    end
    object ActionShortcutPlannedDone: TAction
      Category = 'Skr'#243'ty'
      Caption = 'Czynno'#347'ci zaplanowane'
      ImageIndex = 2
    end
    object ActionShortcutPlanned: TAction
      Category = 'Skr'#243'ty'
      Caption = 'Definicje plan'#243'w'
      ImageIndex = 3
    end
    object ActionShortcutAccounts: TAction
      Category = 'Skr'#243'ty'
      Caption = 'Lista kont'
      ImageIndex = 4
    end
    object ActionShortcutProducts: TAction
      Category = 'Skr'#243'ty'
      Caption = 'Lista kategorii'
      ImageIndex = 5
    end
    object ActionShortcutCashpoints: TAction
      Category = 'Skr'#243'ty'
      Caption = 'Lista kontrahent'#243'w'
      ImageIndex = 6
    end
    object ActionShortcutReports: TAction
      Category = 'Skr'#243'ty'
      Caption = 'Statystyka, raporty'
      ImageIndex = 7
    end
    object ActionStatusbar: TAction
      Category = 'Widok'
      Caption = 'Pasek stanu'
      OnExecute = ActionStatusbarExecute
    end
    object ActionHelp: TAction
      Category = 'Pomoc'
      Caption = 'Spis tre'#347'ci'
      OnExecute = ActionHelpExecute
    end
    object ActionCheckUpdates: TAction
      Category = 'Pomoc'
      Caption = 'Sprawd'#378' aktualizacje'
      ImageIndex = 14
      OnExecute = ActionCheckUpdatesExecute
    end
    object ActionAbout: TAction
      Category = 'Pomoc'
      Caption = 'O programie'
      OnExecute = ActionAboutExecute
    end
    object ActionCreateConnection: TAction
      Category = 'Plik'
      Caption = 'Nowy plik danych'
      OnExecute = ActionCreateConnectionExecute
    end
    object ActionOpenConnection: TAction
      Category = 'Plik'
      Caption = 'Otw'#243'rz plik danych'
      OnExecute = ActionOpenConnectionExecute
    end
    object ActionCloseConnection: TAction
      Category = 'Plik'
      Caption = 'Zamknij plik danych'
      OnExecute = ActionCloseConnectionExecute
    end
    object ActionShortcutFilters: TAction
      Category = 'Skr'#243'ty'
      Caption = 'Filtry'
      ImageIndex = 8
    end
    object ActionCompact: TAction
      Category = 'Plik'
      Caption = 'Kompaktuj plik danych'
      OnExecute = ActionCompactExecute
    end
    object ActionExport: TAction
      Category = 'Plik'
      Caption = 'Eksportuj plik danych'
      OnExecute = ActionExportExecute
    end
    object ActionBackup: TAction
      Category = 'Plik'
      Caption = 'Wykonaj kopi'#281' pliku danych'
      OnExecute = ActionBackupExecute
    end
    object ActionRestore: TAction
      Category = 'Plik'
      Caption = 'Odtw'#243'rz plik danych z kopii'
      OnExecute = ActionRestoreExecute
    end
    object ActionCheckDatafile: TAction
      Category = 'Plik'
      Caption = 'Sprawd'#378' plik danych'
      OnExecute = ActionCheckDatafileExecute
    end
    object ActionPreferences: TAction
      Category = 'Narz'#281'dzia'
      Caption = 'Preferencje'
      OnExecute = ActionPreferencesExecute
    end
    object ActionShortcutProfiles: TAction
      Category = 'Skr'#243'ty'
      Caption = 'Profile'
      ImageIndex = 9
    end
    object ActionLoanCalc: TAction
      Category = 'Narz'#281'dzia'
      Caption = 'Kalkulator kredytowy'
      OnExecute = ActionLoanCalcExecute
    end
    object ActionRandom: TAction
      Category = 'Plik'
      Caption = 'Wype'#322'nij losowo dane'
      OnExecute = ActionRandomExecute
    end
    object ActionShortcutLimits: TAction
      Category = 'Skr'#243'ty'
      Caption = 'Limity'
      ImageIndex = 10
    end
    object ActionShortcutCurrencydef: TAction
      Category = 'Skr'#243'ty'
      Caption = 'Waluty'
      ImageIndex = 11
    end
    object ActionShortcutCurrencyRate: TAction
      Category = 'Skr'#243'ty'
      Caption = 'Kursy walut'
      ImageIndex = 12
    end
    object ActionImportCurrencyRates: TAction
      Category = 'Narz'#281'dzia'
      Caption = 'Wczytaj kursy walut'
      OnExecute = ActionImportCurrencyRatesExecute
    end
    object ActionBug: TAction
      Category = 'Pomoc'
      Caption = 'Zg'#322'o'#347' b'#322#261'd'
      ImageIndex = 13
      OnExecute = ActionBugExecute
    end
    object ActionFutureRequest: TAction
      Category = 'Pomoc'
      Caption = 'Zaproponuj zmian'#281
      OnExecute = ActionFutureRequestExecute
    end
    object ActionHistory: TAction
      Category = 'Pomoc'
      Caption = 'Historia'
    end
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'dat'
    Filter = 'Pliki danych|*.dat|Wszystkie pliki|*.*'
    FilterIndex = 0
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 474
    Top = 184
  end
  object SaveDialog: TSaveDialog
    DefaultExt = '.dat'
    Filter = 'Pliki danych|*.dat|Wszystkie pliki|*.*'
    FilterIndex = 0
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Plik danych'
    Left = 514
    Top = 192
  end
  object OpenDialogXml: TOpenDialog
    DefaultExt = 'dat'
    Filter = 'Pliki XML|*.xml|Wszystkie pliki|*.*'
    FilterIndex = 0
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 474
    Top = 232
  end
end
