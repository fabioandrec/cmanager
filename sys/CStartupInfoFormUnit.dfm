inherited CStartupInfoForm: TCStartupInfoForm
  Width = 603
  Height = 427
  Caption = 'CManager - Informacje'
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 4
    Top = 4
    Width = 587
    Height = 392
    BevelOuter = bvLowered
    TabOrder = 0
    object Panel2: TPanel
      Left = 1
      Top = 352
      Width = 585
      Height = 39
      Align = alBottom
      BevelOuter = bvNone
      Color = clWindow
      TabOrder = 0
      object CButton1: TCButton
        Left = 480
        Top = 8
        Width = 105
        Height = 27
        Cursor = crHandPoint
        PicPosition = ppLeft
        PicOffset = 10
        TxtOffset = 15
        Framed = False
        Action = Action1
      end
      object CButton2: TCButton
        Left = 0
        Top = 8
        Width = 137
        Height = 27
        Cursor = crHandPoint
        PicPosition = ppLeft
        PicOffset = 10
        TxtOffset = 15
        Framed = False
        Action = Action2
      end
    end
    object Panel3: TPanel
      Left = 1
      Top = 1
      Width = 585
      Height = 351
      Align = alClient
      BevelOuter = bvNone
      Color = clWindow
      TabOrder = 1
      object RepaymentList: TVirtualStringTree
        Left = 0
        Top = 0
        Width = 585
        Height = 351
        Align = alClient
        BevelEdges = []
        BevelInner = bvNone
        BevelOuter = bvRaised
        BevelKind = bkFlat
        BorderStyle = bsNone
        DefaultNodeHeight = 24
        Header.AutoSizeIndex = -1
        Header.Font.Charset = DEFAULT_CHARSET
        Header.Font.Color = clWindowText
        Header.Font.Height = -11
        Header.Font.Name = 'MS Sans Serif'
        Header.Font.Style = []
        Header.Height = 21
        Header.MainColumn = -1
        Header.Options = [hoColumnResize, hoDrag]
        Header.Style = hsFlatButtons
        HintMode = hmHint
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
        TreeOptions.MiscOptions = [toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
        TreeOptions.PaintOptions = [toHideFocusRect, toHideSelection, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toFullRowSelect]
        Columns = <>
      end
      object PanelError: TPanel
        Left = 128
        Top = 56
        Width = 321
        Height = 89
        BevelOuter = bvNone
        Caption = 'Brak danych do utworzenia harmonogramu'
        Color = clWindow
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
  object ActionManager1: TActionManager
    Left = 469
    Top = 205
    StyleName = 'XP Style'
    object Action1: TAction
      Caption = 'Zamknij to okno'
      OnExecute = Action1Execute
    end
    object Action2: TAction
      Caption = 'Przejd'#378' do CManager-a'
      OnExecute = Action2Execute
    end
  end
  object PngImageList1: TPngImageList
    Height = 24
    Width = 24
    PngImages = <>
    Left = 213
    Top = 237
  end
end
