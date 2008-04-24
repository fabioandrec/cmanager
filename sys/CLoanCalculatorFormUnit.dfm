inherited CLoanCalculatorForm: TCLoanCalculatorForm
  Left = 336
  Top = 182
  Caption = 'Kalkulator kredytowy'
  ClientHeight = 523
  ClientWidth = 578
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 578
    Height = 482
    object GroupBox1: TGroupBox
      Left = 16
      Top = 16
      Width = 545
      Height = 161
      Caption = ' Dane podstawowe '
      TabOrder = 0
      object Label3: TLabel
        Left = 300
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
        Left = 294
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
        Left = 285
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
      object Label7: TLabel
        Left = 270
        Top = 130
        Width = 131
        Height = 13
        Alignment = taRightJustify
        Caption = 'Suma prowizji i innych op'#322'at'
      end
      object CDateTime: TCDateTime
        Left = 409
        Top = 92
        Width = 112
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz dat'#281' >'
        Color = clWindow
        ParentColor = False
        TabOrder = 5
        TabStop = True
        Transparent = False
        OnChanged = CDateTimeChanged
        HotTrack = True
        Withtime = False
      end
      object ComboBoxType: TComboBox
        Left = 409
        Top = 24
        Width = 112
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
        Width = 123
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
        Width = 123
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 4
        TabOrder = 4
        Text = '0'
        OnChange = CIntEditTimesChange
      end
      object CCurrEditTax: TCCurrEdit
        Left = 409
        Top = 59
        Width = 112
        Height = 21
        BorderStyle = bsNone
        TabOrder = 3
        OnChange = CCurrEditTaxChange
        Decimals = 4
        ThousandSep = True
        CurrencyStr = '%'
        BevelKind = bkTile
        WithCalculator = True
      end
      object CCurrEditCash: TCCurrEdit
        Left = 110
        Top = 59
        Width = 123
        Height = 21
        BorderStyle = bsNone
        TabOrder = 2
        OnChange = CCurrEditCashChange
        Decimals = 2
        ThousandSep = True
        CurrencyStr = 'z'#322
        BevelKind = bkTile
        WithCalculator = True
      end
      object CCurrEditOthers: TCCurrEdit
        Left = 409
        Top = 127
        Width = 112
        Height = 21
        BorderStyle = bsNone
        TabOrder = 6
        OnChange = CCurrEditCashChange
        Decimals = 2
        ThousandSep = True
        CurrencyStr = 'z'#322
        BevelKind = bkTile
        WithCalculator = True
      end
    end
    object GroupBox2: TGroupBox
      Left = 16
      Top = 200
      Width = 545
      Height = 273
      Caption = ' Dane szczeg'#243#322'owe i harmonogram  '
      TabOrder = 1
      object Label8: TLabel
        Left = 207
        Top = 241
        Width = 202
        Height = 13
        Alignment = taRightJustify
        Caption = 'Rzeczywista roczna stopa oprocentowania'
      end
      object CButton1: TCButton
        Left = 16
        Top = 235
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
      object Panel1: TPanel
        Left = 16
        Top = 27
        Width = 513
        Height = 192
        BevelOuter = bvLowered
        Caption = 'Panel1'
        TabOrder = 0
        object Bevel1: TBevel
          Left = 1
          Top = 190
          Width = 511
          Height = 1
          Align = alBottom
          Shape = bsTopLine
        end
        object Bevel2: TBevel
          Left = 511
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
          Width = 510
          Height = 189
          Align = alClient
          BevelEdges = []
          BevelInner = bvNone
          BevelOuter = bvRaised
          BevelKind = bkFlat
          BorderStyle = bsNone
          DefaultNodeHeight = 24
          Header.AutoSizeIndex = 5
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
          AutoExpand = True
          Columns = <
            item
              Alignment = taRightJustify
              Options = [coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
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
              Alignment = taRightJustify
              Options = [coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
              Position = 2
              Width = 90
              WideText = 'Kwota sp'#322'aty'
            end
            item
              Alignment = taRightJustify
              Options = [coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
              Position = 3
              Width = 90
              WideText = 'Kapita'#322
            end
            item
              Alignment = taRightJustify
              Options = [coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
              Position = 4
              Width = 80
              WideText = 'Odsetki'
            end
            item
              Alignment = taRightJustify
              Position = 5
              Width = 125
              WideText = 'Pozosta'#322'o'
            end>
          WideDefaultText = ''
        end
        object PanelError: TPanel
          Left = 96
          Top = 40
          Width = 321
          Height = 41
          BevelOuter = bvNone
          Caption = 'Brak danych do utworzenia harmonogramu'
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
      object Panel2: TPanel
        Left = 413
        Top = 232
        Width = 129
        Height = 33
        BevelOuter = bvNone
        Enabled = False
        TabOrder = 1
        object CCurrEditRrso: TCCurrEdit
          Left = 5
          Top = 4
          Width = 112
          Height = 21
          BorderStyle = bsNone
          Enabled = False
          TabOrder = 0
          OnChange = CCurrEditTaxChange
          Decimals = 4
          ThousandSep = True
          CurrencyStr = '%'
          BevelKind = bkTile
          WithCalculator = True
        end
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 482
    Width = 578
    inherited BitBtnOk: TBitBtn
      Left = 401
    end
    inherited BitBtnCancel: TBitBtn
      Left = 489
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
