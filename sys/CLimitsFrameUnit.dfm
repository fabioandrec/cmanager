inherited CLimitsFrame: TCLimitsFrame
  object ProfileList: TVirtualStringTree [0]
    Left = 0
    Top = 0
    Width = 443
    Height = 236
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
    Columns = <
      item
        Position = 0
        Width = 443
        WideText = 'Nazwa'
        WideHint = 'Nazwa kontrahenta'
      end>
  end
  object PanelFrameButtons: TPanel [1]
    Left = 0
    Top = 236
    Width = 443
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    Color = clWindow
    TabOrder = 1
    object CButtonAddProfile: TCButton
      Left = 13
      Top = 5
      Width = 108
      Height = 33
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Action = ActionAddLimit
    end
    object CButtonEditProfile: TCButton
      Left = 125
      Top = 5
      Width = 108
      Height = 33
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Action = ActionEditLimit
    end
    object CButtonDelProfile: TCButton
      Left = 257
      Top = 5
      Width = 112
      Height = 33
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Action = ActionDelLimit
    end
  end
  object VTHeaderPopupMenu: TVTHeaderPopupMenu
    Left = 80
    Top = 120
  end
  object ActionList: TActionList
    Images = CImageLists.LimitsImageList24x24
    Left = 19
    Top = 56
    object ActionAddLimit: TAction
      Caption = 'Dodaj limit'
      ImageIndex = 0
    end
    object ActionEditLimit: TAction
      Caption = 'Edytuj limit'
      ImageIndex = 1
    end
    object ActionDelLimit: TAction
      Caption = 'Usu'#324' limit'
      ImageIndex = 2
    end
  end
end
