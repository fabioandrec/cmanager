object CMainForm: TCMainForm
  Left = 161
  Top = 187
  Width = 996
  Height = 641
  ActiveControl = ShortcutList
  Caption = 'CManager'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object MenuBar: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 980
    Height = 24
    UseSystemFont = False
    ActionManager = ActionManager
    AllowHiding = True
    Caption = 'MenuBar'
    ColorMap.HighlightColor = clWhite
    ColorMap.BtnSelectedColor = clBtnFace
    ColorMap.UnusedColor = clWhite
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
    Top = 586
    Width = 980
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
  object PanelNotconnected: TCPanel
    Left = 0
    Top = 24
    Width = 980
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
    IsFlatButton = False
  end
  object PanelMain: TCPanel
    Left = 0
    Top = 65
    Width = 980
    Height = 521
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 3
    IsFlatButton = False
    object BevelU2: TBevel
      Left = 0
      Top = 21
      Width = 980
      Height = 3
      Align = alTop
      Shape = bsSpacer
    end
    object Splitter: TSplitter
      Left = 195
      Top = 24
      Width = 2
      Height = 497
    end
    object PanelTitle: TCPanel
      Left = 0
      Top = 0
      Width = 980
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
      IsFlatButton = False
      DesignSize = (
        980
        21)
      object BevelU1: TBevel
        Left = 0
        Top = 0
        Width = 980
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
      object CImageTitle: TCImage
        Left = 6
        Top = 3
        Width = 16
        Height = 16
        ImageList = CImageLists.MainImageList16x16
        ImageIndex = -1
      end
      object CDateTime: TCDateTime
        Left = 903
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
        Withtime = False
      end
    end
    object PanelFrames: TCPanel
      Left = 197
      Top = 24
      Width = 783
      Height = 497
      Align = alClient
      BevelOuter = bvLowered
      Color = clWindow
      TabOrder = 1
      IsFlatButton = False
    end
    object PanelShortcuts: TCPanel
      Left = 0
      Top = 24
      Width = 195
      Height = 497
      Align = alLeft
      BevelOuter = bvLowered
      Color = clWindow
      TabOrder = 2
      IsFlatButton = False
      object ShortcutList: TCList
        Left = 1
        Top = 22
        Width = 193
        Height = 474
        Align = alClient
        BevelEdges = []
        BevelInner = bvNone
        BevelOuter = bvRaised
        BevelKind = bkFlat
        BorderStyle = bsNone
        ButtonStyle = bsTriangle
        Colors.HotColor = clNavy
        Colors.UnfocusedSelectionColor = clHighlight
        DefaultNodeHeight = 60
        Header.AutoSizeIndex = -1
        Header.DefaultHeight = 17
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
        Images = CImageLists.MainImageList32x32
        Indent = 20
        Margin = 15
        ParentShowHint = False
        PopupMenu = PopupMenuShortcutView
        ShowHint = True
        TabOrder = 1
        TreeOptions.AutoOptions = [toAutoDropExpand, toAutoExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
        TreeOptions.MiscOptions = [toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
        TreeOptions.PaintOptions = [toHideFocusRect, toHotTrack, toShowDropmark, toThemeAware, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toFullRowSelect]
        OnFocusChanged = ShortcutListFocusChanged
        OnGetText = ShortcutListGetText
        OnGetImageIndex = ShortcutListGetImageIndex
        OnGetNodeDataSize = ShortcutListGetNodeDataSize
        OnHotChange = ShortcutListHotChange
        AutoExpand = True
        OnGetRowPreferencesName = ShortcutListGetRowPreferencesName
        Columns = <
          item
            Options = [coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
            Position = 0
            Width = 193
          end>
        WideDefaultText = ''
      end
      object PanelShortcutsTitle: TCPanel
        Left = 1
        Top = 1
        Width = 193
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
        IsFlatButton = False
        object ButtonCloseShortcuts: TCPanel
          Left = 172
          Top = 4
          Width = 14
          Height = 14
          BevelOuter = bvNone
          Caption = '3'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -8
          Font.Name = 'Marlett'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnClick = ButtonCloseShortcutsClick
          IsFlatButton = True
        end
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
                    Action = ActionCompactDatafile
                    Caption = '&Kompaktuj plik danych'
                  end
                  item
                    Action = ActionExportDatafile
                    Caption = '&Eksportuj plik danych'
                  end
                  item
                    Action = ActionImportDatafile
                    Caption = '&Importuj plik danych'
                  end
                  item
                    Action = ActionBackupDatafile
                    Caption = '&Wykonaj archiwum pliku danych'
                  end
                  item
                    Action = ActionRestoreDatafile
                    Caption = '&Odtw'#243'rz plik danych z archiwum'
                  end
                  item
                    Action = ActionCheckDatafile
                    Caption = '&Sprawd'#378' plik danych'
                  end
                  item
                    Action = ActionRandom
                    Caption = 'W&ype'#322'nij losowo dane'
                  end
                  item
                    Caption = '-'
                  end
                  item
                    Action = ActionPasswordDatafile
                    Caption = '&Ustaw/zmie'#324' has'#322'o pliku danych'
                  end>
                Caption = 'N&arz'#281'dzia pliku danych'
              end>
            Caption = 'P&lik'
          end
          item
            Items = <
              item
                Caption = '&ActionClientItem0'
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
                Caption = '&ActionClientItem0'
              end>
            Caption = 'S'#322'&owniki'
          end
          item
            Items = <
              item
                Action = ActionImportCurrencyRates
                Caption = 'W&czytaj kursy walut'
              end
              item
                Action = ActionImportExtraction
                Caption = 'Wc&zytaj wyci'#261'g bankowy'
              end
              item
                Action = ActionImportStockExchanges
                Caption = 'Wcz&ytaj notowania'
              end
              item
                Caption = '-'
              end
              item
                Action = ActionPreferences
                Caption = '&Preferencje'
              end
              item
                Action = ActionLoanCalc
                Caption = '&Kalkulator kredyt'#243'w'
              end
              item
                Action = ActionDepositCalc
                Caption = 'Ka&lkulator lokat'
              end
              item
                Action = ActionCss
                Caption = '&Arkusz styli raport'#243'w'
              end
              item
                Action = ActionXsl
              end>
            Caption = '&Narz'#281'dzia'
          end
          item
            Items = <
              item
                Caption = '&ActionClientItem0'
              end>
            Caption = 'W&tyczki'
          end
          item
            Items = <
              item
                Action = ActionHelp
                Caption = '&Spis tre'#347'ci'
              end
              item
                Action = ActionHistory
                Caption = '&Historia'
              end
              item
                Caption = '-'
              end
              item
                Action = ActionBug
                Caption = '&Zg'#322'o'#347' b'#322#261'd'
                ImageIndex = 19
              end
              item
                Action = ActionSystemInfo
              end
              item
                Action = ActionFutureRequest
                Caption = 'Z&aproponuj zmian'#281
              end
              item
                Action = ActionDiscForum
                Caption = '&Forum dyskusyjne'
              end
              item
                Action = ActionGreenGrass
                Caption = '&Na zielonej trawie'
                ImageIndex = 22
              end
              item
                Action = ActionCmd
                Caption = '&Linia polece'#324
              end
              item
                Caption = '-'
              end
              item
                Action = ActionCheckUpdates
                Caption = 'S&prawd'#378' aktualizacje'
                ImageIndex = 20
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
      Caption = 'Operacje finansowe'
      ImageIndex = 1
    end
    object ActionShortcutPlannedDone: TAction
      Category = 'Skr'#243'ty'
      Caption = 'Operacje zaplanowane'
      ImageIndex = 2
    end
    object ActionShortcutAccounts: TAction
      Category = 'Skr'#243'ty'
      Caption = 'Konta'
      ImageIndex = 4
    end
    object ActionShortcutExtractions: TAction
      Category = 'Skr'#243'ty'
      Caption = 'Wyci'#261'gi'
      ImageIndex = 13
    end
    object ActionShortcutDepositInvestment: TAction
      Category = 'Skr'#243'ty'
      Caption = 'Lokaty'
      ImageIndex = 18
    end
    object ActionShortcutInvestmentPortfolio: TAction
      Category = 'Skr'#243'ty'
      Caption = 'Portfel inwestycyjny'
      ImageIndex = 17
    end
    object ActionShortcutProducts: TAction
      Category = 'S'#322'owniki'
      Caption = 'Kategorie'
      ImageIndex = 5
    end
    object ActionShortcutCashpoints: TAction
      Category = 'S'#322'owniki'
      Caption = 'Kontrahenci'
      ImageIndex = 6
    end
    object ActionShortcutPlanned: TAction
      Category = 'S'#322'owniki'
      Caption = 'Harmonogramy'
      ImageIndex = 3
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
      ImageIndex = 20
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
      Category = 'S'#322'owniki'
      Caption = 'Filtry'
      ImageIndex = 8
    end
    object ActionCompactDatafile: TAction
      Category = 'Plik'
      Caption = 'Kompaktuj plik danych'
      OnExecute = ActionCompactDatafileExecute
    end
    object ActionExportDatafile: TAction
      Category = 'Plik'
      Caption = 'Eksportuj plik danych'
      OnExecute = ActionExportDatafileExecute
    end
    object ActionBackupDatafile: TAction
      Category = 'Plik'
      Caption = 'Wykonaj archiwum pliku danych'
      OnExecute = ActionBackupDatafileExecute
    end
    object ActionRestoreDatafile: TAction
      Category = 'Plik'
      Caption = 'Odtw'#243'rz plik danych z archiwum'
      OnExecute = ActionRestoreDatafileExecute
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
      Category = 'S'#322'owniki'
      Caption = 'Profile'
      ImageIndex = 9
    end
    object ActionLoanCalc: TAction
      Category = 'Narz'#281'dzia'
      Caption = 'Kalkulator kredyt'#243'w'
      OnExecute = ActionLoanCalcExecute
    end
    object ActionRandom: TAction
      Category = 'Plik'
      Caption = 'Wype'#322'nij losowo dane'
      OnExecute = ActionRandomExecute
    end
    object ActionShortcutLimits: TAction
      Category = 'S'#322'owniki'
      Caption = 'Limity'
      ImageIndex = 10
    end
    object ActionShortcutCurrencydef: TAction
      Category = 'S'#322'owniki'
      Caption = 'Waluty'
      ImageIndex = 11
    end
    object ActionShortcutCurrencyRate: TAction
      Category = 'Skr'#243'ty'
      Caption = 'Kursy'
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
      ImageIndex = 19
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
      OnExecute = ActionHistoryExecute
    end
    object ActionImportExtraction: TAction
      Category = 'Narz'#281'dzia'
      Caption = 'Wczytaj wyci'#261'g bankowy'
      OnExecute = ActionImportExtractionExecute
    end
    object ActionCss: TAction
      Category = 'Narz'#281'dzia'
      Caption = 'Arkusz styli raport'#243'w'
      OnExecute = ActionCssExecute
    end
    object ActionImportDatafile: TAction
      Category = 'Plik'
      Caption = 'Importuj plik danych'
      OnExecute = ActionImportDatafileExecute
    end
    object ActionXsl: TAction
      Category = 'Narz'#281'dzia'
      Caption = 'Domy'#347'lna transformacja raport'#243'w'
      OnExecute = ActionXslExecute
    end
    object ActionShortcutInstruments: TAction
      Category = 'S'#322'owniki'
      Caption = 'Instrumenty'
      ImageIndex = 14
    end
    object ActionShortcutExch: TAction
      Category = 'Skr'#243'ty'
      Caption = 'Notowania'
      ImageIndex = 15
    end
    object ActionShortcutReports: TAction
      Category = 'Skr'#243'ty'
      Caption = 'Raporty'
      ImageIndex = 7
    end
    object ActionImportStockExchanges: TAction
      Category = 'Narz'#281'dzia'
      Caption = 'Wczytaj notowania'
      OnExecute = ActionImportStockExchangesExecute
    end
    object ActionDiscForum: TAction
      Category = 'Pomoc'
      Caption = 'Forum dyskusyjne'
      OnExecute = ActionDiscForumExecute
    end
    object ActionPasswordDatafile: TAction
      Category = 'Plik'
      Caption = 'Ustaw/zmie'#324' has'#322'o pliku danych'
      OnExecute = ActionPasswordDatafileExecute
    end
    object ActionCmd: TAction
      Category = 'Pomoc'
      Caption = 'Linia polece'#324
      OnExecute = ActionCmdExecute
    end
    object ActionShortcutQuickpatterns: TAction
      Category = 'S'#322'owniki'
      Caption = 'Szybkie operacje'
      ImageIndex = 21
      OnExecute = ActionShortcutQuickpatternsExecute
    end
    object ActionDepositCalc: TAction
      Category = 'Narz'#281'dzia'
      Caption = 'Kalkulator lokat'
      OnExecute = ActionDepositCalcExecute
    end
    object ActionGreenGrass: TAction
      Category = 'Pomoc'
      Caption = 'Na zielonej trawie'
      ImageIndex = 22
      OnExecute = ActionGreenGrassExecute
    end
    object ActionSystemInfo: TAction
      Category = 'Pomoc'
      Caption = 'Informacje o systemie'
      OnExecute = ActionSystemInfoExecute
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
  object PopupMenuShortcutView: TPopupMenu
    Left = 128
    Top = 337
    object Ustawienialisty1: TMenuItem
      Caption = 'Ustawienia listy'
      OnClick = Ustawienialisty1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object MenuItemSmallShortcut: TMenuItem
      Caption = 'Ma'#322'e ikony'
      GroupIndex = 1
      RadioItem = True
      OnClick = MenuItemSmallShortcutClick
    end
    object MenuItemBigShortcut: TMenuItem
      Caption = 'Du'#380'e ikony'
      Checked = True
      GroupIndex = 1
      RadioItem = True
      OnClick = MenuItemBigShortcutClick
    end
  end
  object XPManifest: TXPManifest
    Left = 349
    Top = 265
  end
end
