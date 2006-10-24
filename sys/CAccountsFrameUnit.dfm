inherited CAccountsFrame: TCAccountsFrame
  Height = 275
  object AccountList: TVirtualStringTree [0]
    Left = 0
    Top = 0
    Width = 443
    Height = 234
    Align = alClient
    BevelEdges = [beBottom]
    BevelInner = bvNone
    BevelOuter = bvRaised
    BevelKind = bkFlat
    BorderStyle = bsNone
    DefaultNodeHeight = 24
    Header.AutoSizeIndex = 0
    Header.Font.Charset = DEFAULT_CHARSET
    Header.Font.Color = clWindowText
    Header.Font.Height = -11
    Header.Font.Name = 'MS Sans Serif'
    Header.Font.Style = []
    Header.Height = 21
    Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
    Header.PopupMenu = VTHeaderPopupMenu
    Header.SortColumn = 0
    Header.Style = hsFlatButtons
    HintMode = hmHint
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
    TreeOptions.MiscOptions = [toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
    TreeOptions.PaintOptions = [toHideFocusRect, toHideSelection, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
    TreeOptions.SelectionOptions = [toFullRowSelect]
    OnBeforeItemErase = AccountListBeforeItemErase
    OnCompareNodes = AccountListCompareNodes
    OnDblClick = AccountListDblClick
    OnFocusChanged = AccountListFocusChanged
    OnGetText = AccountListGetText
    OnGetHint = AccountListGetHint
    OnGetNodeDataSize = AccountListGetNodeDataSize
    OnHeaderClick = AccountListHeaderClick
    OnInitNode = AccountListInitNode
    Columns = <
      item
        Position = 0
        Width = 143
        WideText = 'Nazwa'
        WideHint = 'Nazwa kontrahenta'
      end
      item
        Position = 1
        Width = 150
        WideText = 'Rodzaj'
      end
      item
        Alignment = taRightJustify
        Position = 2
        Width = 150
        WideText = 'Dost'#281'pne '#347'rodki'
      end>
  end
  object PanelFrameButtons: TPanel [1]
    Left = 0
    Top = 234
    Width = 443
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    Color = clWindow
    TabOrder = 1
    object CButtonAddAccount: TCButton
      Left = 13
      Top = 5
      Width = 137
      Height = 33
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Action = ActionAddAccount
    end
    object CButtonEditAccount: TCButton
      Left = 157
      Top = 5
      Width = 137
      Height = 33
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Action = ActionEditAccount
    end
    object CButtonDelAccount: TCButton
      Left = 305
      Top = 5
      Width = 137
      Height = 33
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Action = ActionDelAccount
    end
  end
  object VTHeaderPopupMenu: TVTHeaderPopupMenu
    Left = 80
    Top = 120
  end
  object ActionList: TActionList
    Images = ImageList
    Left = 11
    Top = 64
    object ActionAddAccount: TAction
      Caption = 'Dodaj konto'
      ImageIndex = 0
      OnExecute = ActionAddAccountExecute
    end
    object ActionEditAccount: TAction
      Caption = 'Edytuj konto'
      ImageIndex = 0
      OnExecute = ActionEditAccountExecute
    end
    object ActionDelAccount: TAction
      Caption = 'Usu'#324' konto'
      ImageIndex = 0
      OnExecute = ActionDelAccountExecute
    end
  end
end
