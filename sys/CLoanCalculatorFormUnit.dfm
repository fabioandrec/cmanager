inherited CLoanCalculatorForm: TCLoanCalculatorForm
  Left = 330
  Top = 227
  Caption = 'Kalkulator kredytowy'
  ClientHeight = 445
  ClientWidth = 483
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 483
    Height = 404
    object GroupBox1: TGroupBox
      Left = 16
      Top = 16
      Width = 453
      Height = 137
      Caption = ' Dane podstawowe '
      TabOrder = 0
      object Label3: TLabel
        Left = 236
        Top = 96
        Width = 101
        Height = 13
        Alignment = taRightJustify
        Caption = 'Data pierwszej sp'#322'aty'
      end
      object Label5: TLabel
        Left = 17
        Top = 28
        Width = 85
        Height = 13
        Alignment = taRightJustify
        Caption = 'Sp'#322'ata kredytu co'
      end
      object Label1: TLabel
        Left = 230
        Top = 28
        Width = 107
        Height = 13
        Alignment = taRightJustify
        Caption = 'Rodzaj sp'#322'acanych rat'
      end
      object Label4: TLabel
        Left = 65
        Top = 96
        Width = 37
        Height = 13
        Alignment = taRightJustify
        Caption = 'Ilo'#347#263' rat'
      end
      object Label2: TLabel
        Left = 221
        Top = 62
        Width = 116
        Height = 13
        Alignment = taRightJustify
        Caption = 'Roczne oprocentowanie'
      end
      object Label6: TLabel
        Left = 37
        Top = 62
        Width = 68
        Height = 13
        Alignment = taRightJustify
        Caption = 'Kwota kredytu'
      end
      object CDateTime: TCDateTime
        Left = 345
        Top = 92
        Width = 87
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz dat'#281'>'
        Color = clWindow
        ParentColor = False
        TabOrder = 5
        TabStop = True
        Transparent = False
        OnChanged = CDateTimeChanged
        HotTrack = True
      end
      object ComboBoxType: TComboBox
        Left = 345
        Top = 24
        Width = 87
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 1
        TabOrder = 1
        Text = 'malej'#261'ce'
        OnChange = ComboBoxTypeChange
        Items.Strings = (
          'sta'#322'e'
          'malej'#261'ce')
      end
      object ComboBoxPeriod: TComboBox
        Left = 110
        Top = 24
        Width = 99
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 0
        Text = 'miesi'#261'c'
        OnChange = ComboBoxPeriodChange
        Items.Strings = (
          'miesi'#261'c'
          'tydzie'#324)
      end
      object CIntEditTimes: TCIntEdit
        Left = 110
        Top = 92
        Width = 99
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 4
        TabOrder = 4
        Text = '0'
        OnChange = CIntEditTimesChange
      end
      object CCurrEditTax: TCCurrEdit
        Left = 344
        Top = 59
        Width = 87
        Height = 21
        BorderStyle = bsNone
        TabOrder = 3
        OnChange = CCurrEditTaxChange
        Decimals = 4
        ThousandSep = True
        CurrencyStr = '%'
        BevelKind = bkTile
      end
      object CCurrEditCash: TCCurrEdit
        Left = 110
        Top = 59
        Width = 99
        Height = 21
        BorderStyle = bsNone
        TabOrder = 2
        OnChange = CCurrEditCashChange
        Decimals = 2
        ThousandSep = True
        CurrencyStr = 'z'#322
        BevelKind = bkTile
      end
    end
    object GroupBox2: TGroupBox
      Left = 16
      Top = 168
      Width = 453
      Height = 225
      Caption = ' Harmonogram '
      TabOrder = 1
      object Panel1: TPanel
        Left = 16
        Top = 24
        Width = 417
        Height = 185
        BevelOuter = bvLowered
        Caption = 'Panel1'
        TabOrder = 0
        object RepaymentList: TVirtualStringTree
          Left = 1
          Top = 1
          Width = 415
          Height = 183
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
          Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
          Header.Style = hsFlatButtons
          HintMode = hmHint
          ParentShowHint = False
          ShowHint = True
          TabOrder = 0
          TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
          TreeOptions.MiscOptions = [toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
          TreeOptions.PaintOptions = [toHideFocusRect, toHideSelection, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
          TreeOptions.SelectionOptions = [toFullRowSelect]
          OnGetText = RepaymentListGetText
          Columns = <
            item
              Alignment = taRightJustify
              Options = [coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
              Position = 0
              Width = 60
              WideText = 'Lp'
            end
            item
              Options = [coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
              Position = 1
              Width = 75
              WideText = 'Data'
            end
            item
              Alignment = taRightJustify
              Options = [coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
              Position = 2
              Width = 90
              WideText = 'Rata'
            end
            item
              Alignment = taRightJustify
              Options = [coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
              Position = 3
              Width = 90
              WideText = 'Odsetki'
            end
            item
              Alignment = taRightJustify
              Options = [coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
              Position = 4
              Width = 80
              WideText = 'Pozosta'#322'o'
            end>
        end
        object PanelError: TPanel
          Left = 48
          Top = 40
          Width = 321
          Height = 41
          BevelOuter = bvNone
          Caption = 'Brak danych do utworzenia harmonogramu'
          Color = clWindow
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clInactiveCaption
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
        end
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 404
    Width = 483
    inherited BitBtnOk: TBitBtn
      Left = 306
      TabOrder = 1
    end
    inherited BitBtnCancel: TBitBtn
      Left = 394
      TabOrder = 2
    end
    object BitBtnPrint: TBitBtn
      Left = 16
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Do druku'
      Enabled = False
      TabOrder = 0
      OnClick = BitBtnOkClick
    end
  end
end
