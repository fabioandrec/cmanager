inherited CSurpassedForm: TCSurpassedForm
  Caption = 'Przekroczone limity'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
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
      Left = 158
      Top = 372
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
      Width = 591
      Height = 313
      Anchors = [akLeft, akTop, akRight, akBottom]
      BevelOuter = bvLowered
      TabOrder = 0
      object SurpassedList: TCDataList
        Left = 1
        Top = 1
        Width = 589
        Height = 311
        Align = alClient
        BevelEdges = []
        BevelInner = bvNone
        BevelOuter = bvRaised
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
        ShowHint = True
        TabOrder = 0
        TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
        TreeOptions.MiscOptions = [toCheckSupport, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
        TreeOptions.PaintOptions = [toHideFocusRect, toHideSelection, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toFullRowSelect]
        OddColor = 12437200
        AutoExpand = True
        OnCDataListReloadTree = SurpassedListCDataListReloadTree
        Columns = <
          item
            Position = 0
            Width = 200
            WideText = 'Nazwa'
          end
          item
            Position = 1
            Width = 100
            WideText = 'Suma'
          end
          item
            Position = 2
            Width = 150
            WideText = 'Rodzaj'
          end
          item
            Position = 3
            Width = 139
            WideText = 'Status'
          end>
        WideDefaultText = ''
      end
    end
  end
end
