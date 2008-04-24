inherited CSurpassedForm: TCSurpassedForm
  Left = 266
  Top = 196
  Caption = 'Przekroczone limity'
  ClientWidth = 594
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 594
    object Label1: TLabel
      Left = 16
      Top = 12
      Width = 323
      Height = 13
      Caption = 
        'Akceptacja operacji spowoduje przekroczenie nast'#281'puj'#261'cych limit'#243 +
        'w'
    end
    object Label2: TLabel
      Left = 162
      Top = 356
      Width = 421
      Height = 13
      Alignment = taRightJustify
      Caption = 
        'Wci'#347'nij OK aby zaakceptowa'#263' przekroczenie limit'#243'w, lub Anuluj ab' +
        'y powr'#243'ci'#263' do operacji'
    end
    object PanelFrame: TPanel
      Left = 2
      Top = 40
      Width = 588
      Height = 301
      Anchors = [akLeft, akTop, akRight, akBottom]
      BevelOuter = bvLowered
      TabOrder = 0
      object Bevel1: TBevel
        Left = 1
        Top = 299
        Width = 586
        Height = 1
        Align = alBottom
        Shape = bsTopLine
      end
      object Bevel2: TBevel
        Left = 586
        Top = 1
        Width = 1
        Height = 298
        Align = alRight
        Shape = bsRightLine
        Style = bsRaised
      end
      object SurpassedList: TCDataList
        Left = 1
        Top = 1
        Width = 585
        Height = 298
        Align = alClient
        BevelEdges = []
        BevelInner = bvNone
        BevelOuter = bvSpace
        BevelKind = bkFlat
        BorderStyle = bsNone
        ButtonStyle = bsTriangle
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
        Images = CImageLists.DoneImageList16x16
        ParentShowHint = False
        PopupMenu = PopupMenu1
        ShowHint = True
        TabOrder = 0
        TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
        TreeOptions.MiscOptions = [toCheckSupport, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
        TreeOptions.PaintOptions = [toHideFocusRect, toHideSelection, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toFullRowSelect]
        AutoExpand = True
        OnGetRowPreferencesName = SurpassedListGetRowPreferencesName
        OnCDataListReloadTree = SurpassedListCDataListReloadTree
        Columns = <
          item
            Position = 0
            Width = 200
            WideText = 'Nazwa'
          end
          item
            Position = 1
            WideText = 'Waluta'
          end
          item
            Position = 2
            Width = 100
            WideText = 'Suma'
          end
          item
            Position = 3
            Width = 125
            WideText = 'Rodzaj'
          end
          item
            Position = 4
            Width = 110
            WideText = 'Status'
          end>
        WideDefaultText = ''
      end
    end
  end
  inherited PanelButtons: TPanel
    Width = 594
    inherited BitBtnOk: TBitBtn
      Left = 417
    end
    inherited BitBtnCancel: TBitBtn
      Left = 505
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 152
    Top = 297
    object Zaznaczwszystkie1: TMenuItem
      Caption = 'Ustawienia listy'
      ImageIndex = 0
      OnClick = Zaznaczwszystkie1Click
    end
  end
end
