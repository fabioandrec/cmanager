inherited CDepositCalculatorForm: TCDepositCalculatorForm
  Left = 244
  Top = 175
  Caption = 'Kalkulator kredytowy'
  ClientHeight = 573
  ClientWidth = 805
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TCPanel
    Width = 805
    Height = 532
    object GroupBox1: TGroupBox
      Left = 16
      Top = 16
      Width = 769
      Height = 217
      Caption = ' Dane podstawowe '
      TabOrder = 0
      object Label6: TLabel
        Left = 13
        Top = 68
        Width = 91
        Height = 13
        Alignment = taRightJustify
        Caption = 'Czas trwania lokaty'
      end
      object Label7: TLabel
        Left = 308
        Top = 68
        Width = 76
        Height = 13
        Alignment = taRightJustify
        Caption = 'Po zako'#324'czeniu'
      end
      object Label1: TLabel
        Left = 30
        Top = 104
        Width = 74
        Height = 13
        Alignment = taRightJustify
        Caption = 'Naliczaj odsetki'
      end
      object Label9: TLabel
        Left = 563
        Top = 104
        Width = 13
        Height = 13
        Alignment = taRightJustify
        Caption = 'Co'
      end
      object Label11: TLabel
        Left = 41
        Top = 140
        Width = 63
        Height = 13
        Alignment = taRightJustify
        Caption = 'Po naliczeniu'
      end
      object Label3: TLabel
        Left = 27
        Top = 32
        Width = 77
        Height = 13
        Alignment = taRightJustify
        Caption = 'Data utworzenia'
      end
      object Label2: TLabel
        Left = 592
        Top = 68
        Width = 56
        Height = 13
        Alignment = taRightJustify
        Caption = 'Data ko'#324'ca'
      end
      object Label15: TLabel
        Left = 319
        Top = 32
        Width = 65
        Height = 13
        Alignment = taRightJustify
        Caption = 'Kapita'#322' lokaty'
      end
      object Label4: TLabel
        Left = 570
        Top = 32
        Width = 78
        Height = 13
        Alignment = taRightJustify
        Caption = 'Oprocentowanie'
      end
      object Label5: TLabel
        Left = 586
        Top = 174
        Width = 62
        Height = 13
        Alignment = taRightJustify
        Caption = 'Prognozuj do'
      end
      object Label10: TLabel
        Left = 599
        Top = 140
        Width = 49
        Height = 13
        Alignment = taRightJustify
        Caption = 'Naliczanie'
      end
      object CIntEditPeriodCount: TCIntEdit
        Left = 112
        Top = 64
        Width = 57
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 4
        TabOrder = 3
        Text = '1'
        OnChange = CIntEditPeriodCountChange
      end
      object ComboBoxPeriodType: TComboBox
        Left = 184
        Top = 64
        Width = 105
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 2
        TabOrder = 4
        Text = 'miesi'#281'cy'
        OnChange = ComboBoxPeriodTypeChange
        Items.Strings = (
          'dni'
          'tygodni'
          'miesi'#281'cy'
          'lat')
      end
      object ComboBoxPeriodAction: TComboBox
        Left = 392
        Top = 64
        Width = 161
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 5
        Text = 'zmie'#324' status na nieaktywna'
        OnChange = ComboBoxPeriodActionChange
        Items.Strings = (
          'zmie'#324' status na nieaktywna'
          'automatycznie odn'#243'w lokat'#281)
      end
      object ComboBoxDueMode: TComboBox
        Left = 112
        Top = 100
        Width = 441
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 7
        Text = 'jednorazowo, po zako'#324'czeniu czasu trwania lokaty'
        OnChange = ComboBoxDueModeChange
        Items.Strings = (
          'jednorazowo, po zako'#324'czeniu czasu trwania lokaty'
          'wielokrotnie, co wskazany okres czasu')
      end
      object CIntEditDueCount: TCIntEdit
        Left = 584
        Top = 100
        Width = 57
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 4
        TabOrder = 8
        Text = '1'
        OnChange = CIntEditDueCountChange
      end
      object ComboBoxDueType: TComboBox
        Left = 656
        Top = 100
        Width = 89
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 2
        TabOrder = 9
        Text = 'miesi'#281'cy'
        OnChange = ComboBoxDueTypeChange
        Items.Strings = (
          'dni'
          'tygodni'
          'miesi'#281'cy'
          'lat')
      end
      object ComboBoxDueAction: TComboBox
        Left = 112
        Top = 136
        Width = 441
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 10
        Text = 'dopisz odsetki do kapita'#322'u'
        OnChange = ComboBoxDueActionChange
        Items.Strings = (
          'dopisz odsetki do kapita'#322'u'
          'pozostaw do wyp'#322'aty')
      end
      object CDateTimeStart: TCDateTime
        Left = 112
        Top = 28
        Width = 177
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz dat'#281' >'
        Color = clWindow
        ParentColor = False
        TabOrder = 0
        TabStop = True
        Transparent = False
        OnChanged = CDateTimeStartChanged
        HotTrack = True
        Withtime = False
      end
      object CDateTimeEnd: TCDateTime
        Left = 656
        Top = 64
        Width = 89
        Height = 21
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz dat'#281' >'
        Color = clWindow
        Enabled = False
        ParentColor = False
        TabOrder = 6
        TabStop = True
        Transparent = False
        HotTrack = False
        Withtime = False
      end
      object CCurrEditActualCash: TCCurrEdit
        Left = 392
        Top = 28
        Width = 161
        Height = 21
        BorderStyle = bsNone
        TabOrder = 1
        OnChange = CCurrEditActualCashChange
        Decimals = 2
        ThousandSep = True
        CurrencyStr = 'z'#322
        BevelKind = bkTile
        WithCalculator = True
      end
      object CCurrEditRate: TCCurrEdit
        Left = 656
        Top = 28
        Width = 89
        Height = 21
        BorderStyle = bsNone
        TabOrder = 2
        OnChange = CCurrEditRateChange
        Decimals = 4
        ThousandSep = True
        CurrencyStr = '%'
        BevelKind = bkTile
        WithCalculator = True
      end
      object CDateTimeProg: TCDateTime
        Left = 656
        Top = 170
        Width = 89
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz dat'#281' >'
        Color = clWindow
        ParentColor = False
        TabOrder = 12
        TabStop = True
        Transparent = False
        OnChanged = CDateTimeProgChanged
        HotTrack = True
        Withtime = False
      end
      object CDateTimeDueEnd: TCDateTime
        Left = 656
        Top = 136
        Width = 89
        Height = 21
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz dat'#281' >'
        Color = clWindow
        Enabled = False
        ParentColor = False
        TabOrder = 11
        TabStop = True
        Transparent = False
        HotTrack = False
        Withtime = False
      end
    end
    object GroupBox2: TGroupBox
      Left = 16
      Top = 252
      Width = 769
      Height = 273
      Caption = ' Prognoza lokaty '
      TabOrder = 1
      object Label8: TLabel
        Left = 563
        Top = 237
        Width = 62
        Height = 13
        Alignment = taRightJustify
        Caption = 'Stopa zwrotu'
      end
      object CButton1: TCButton
        Left = 24
        Top = 231
        Width = 105
        Height = 25
        Cursor = crHandPoint
        PicPosition = ppLeft
        PicOffset = 10
        TxtOffset = 15
        Framed = False
        Action = Action1
        Color = clBtnFace
      end
      object Label12: TLabel
        Left = 345
        Top = 237
        Width = 88
        Height = 13
        Alignment = taRightJustify
        Caption = 'Razem do wyp'#322'aty'
      end
      object Panel1: TCPanel
        Left = 24
        Top = 27
        Width = 721
        Height = 192
        BevelOuter = bvLowered
        Caption = 'Panel1'
        TabOrder = 0
        object Bevel1: TBevel
          Left = 1
          Top = 190
          Width = 719
          Height = 1
          Align = alBottom
          Shape = bsTopLine
        end
        object Bevel2: TBevel
          Left = 719
          Top = 1
          Width = 1
          Height = 189
          Align = alRight
          Shape = bsRightLine
          Style = bsRaised
        end
        object RepaymentList: TCList
          Left = 1
          Top = 1
          Width = 718
          Height = 189
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
          Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
          Header.Style = hsFlatButtons
          HintMode = hmHint
          ParentShowHint = False
          PopupMenu = PopupMenu1
          ShowHint = True
          TabOrder = 0
          TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
          TreeOptions.MiscOptions = [toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
          TreeOptions.PaintOptions = [toHideFocusRect, toHideSelection, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
          TreeOptions.SelectionOptions = [toFullRowSelect]
          OnGetText = RepaymentListGetText
          OnGetHint = RepaymentListGetHint
          AutoExpand = True
          Columns = <
            item
              Alignment = taRightJustify
              Options = [coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
              Position = 0
              WideText = 'Lp'
            end
            item
              Options = [coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
              Position = 1
              Width = 75
              WideText = 'Data'
            end
            item
              Options = [coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
              Position = 2
              Width = 200
              WideText = 'Operacja'
            end
            item
              Options = [coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
              Position = 3
              Width = 75
              WideText = 'Kapita'#322
            end
            item
              Options = [coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
              Position = 4
              Width = 75
              WideText = 'Odsetki'
            end
            item
              Position = 5
              Width = 75
              WideText = 'Razem'
            end
            item
              Options = [coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
              Position = 6
              Width = 168
              WideText = 'Wolne odsetki'
            end>
          WideDefaultText = ''
        end
        object PanelError: TCPanel
          Left = 200
          Top = 40
          Width = 321
          Height = 41
          BevelOuter = bvNone
          Caption = 'Brak danych do utworzenia prognozy'
          Color = clWindow
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGrayText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
      end
      object CCurrEditRor: TCCurrEdit
        Left = 633
        Top = 233
        Width = 112
        Height = 21
        BorderStyle = bsNone
        Enabled = False
        TabOrder = 1
        Decimals = 4
        ThousandSep = True
        CurrencyStr = '%'
        BevelKind = bkTile
        WithCalculator = True
      end
      object CCurrEditReadyCash: TCCurrEdit
        Left = 441
        Top = 233
        Width = 112
        Height = 21
        BorderStyle = bsNone
        Enabled = False
        TabOrder = 2
        Decimals = 2
        ThousandSep = True
        CurrencyStr = 'z'#322
        BevelKind = bkTile
        WithCalculator = True
      end
    end
  end
  inherited PanelButtons: TCPanel
    Top = 532
    Width = 805
    inherited BitBtnOk: TBitBtn
      Left = 628
    end
    inherited BitBtnCancel: TBitBtn
      Left = 716
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
  object ActionList: TActionList
    Images = CImageLists.ActionImageList
    Left = 196
    Top = 132
    object Action1: TAction
      Caption = 'Do druku'
      ImageIndex = 0
      OnExecute = Action1Execute
    end
  end
end