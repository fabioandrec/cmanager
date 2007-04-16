inherited CUpdateCurrencyRatesForm: TCUpdateCurrencyRatesForm
  Left = 441
  Top = 181
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Tabela kurs'#243'w walut'
  ClientHeight = 447
  ClientWidth = 536
  PixelsPerInch = 96
  TextHeight = 13
  object PanelButtons: TPanel
    Left = 0
    Top = 406
    Width = 536
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      536
      41)
    object BitBtnOk: TBitBtn
      Left = 359
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Zapisz'
      Default = True
      TabOrder = 0
    end
    object BitBtnCancel: TBitBtn
      Left = 447
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Anuluj'
      TabOrder = 1
      OnClick = BitBtnCancelClick
    end
  end
  object PanelConfig: TPanel
    Left = 0
    Top = 0
    Width = 536
    Height = 406
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object GroupBox4: TGroupBox
      Left = 16
      Top = 16
      Width = 505
      Height = 65
      Caption = ' Dane podstawowe '
      TabOrder = 0
      object Label15: TLabel
        Left = 19
        Top = 28
        Width = 61
        Height = 13
        Alignment = taRightJustify
        Caption = 'Kurs dla dnia'
      end
      object Label2: TLabel
        Left = 186
        Top = 29
        Width = 19
        Height = 13
        Alignment = taRightJustify
        Caption = 'w/g'
      end
      object CDateTime: TCDateTime
        Left = 88
        Top = 24
        Width = 89
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz dat'#281'>'
        Color = clWindow
        ParentColor = False
        TabOrder = 0
        TabStop = True
        Transparent = False
        HotTrack = True
      end
      object CStaticCashpoint: TCStatic
        Left = 213
        Top = 25
        Width = 268
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz kontrahenta z listy>'
        Color = clWindow
        ParentColor = False
        TabOrder = 1
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz kontrahenta z listy>'
        OnGetDataId = CStaticCashpointGetDataId
        HotTrack = True
      end
    end
    object GroupBox1: TGroupBox
      Left = 16
      Top = 97
      Width = 505
      Height = 297
      Caption = ' Kursy walut  '
      TabOrder = 1
      object Panel1: TPanel
        Left = 24
        Top = 28
        Width = 457
        Height = 249
        BevelOuter = bvLowered
        Caption = 'Panel1'
        TabOrder = 0
        object Bevel1: TBevel
          Left = 1
          Top = 205
          Width = 455
          Height = 2
          Align = alBottom
          Shape = bsBottomLine
        end
        object Panel2: TPanel
          Left = 1
          Top = 207
          Width = 455
          Height = 41
          Align = alBottom
          BevelOuter = bvNone
          Color = clWindow
          TabOrder = 0
        end
        object RatesList: TCList
          Left = 1
          Top = 1
          Width = 455
          Height = 204
          Align = alClient
          BevelEdges = []
          BevelInner = bvNone
          BevelOuter = bvRaised
          BevelKind = bkFlat
          BorderStyle = bsNone
          CheckImageKind = ckDarkTick
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
          ShowHint = True
          TabOrder = 1
          TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
          TreeOptions.MiscOptions = [toCheckSupport, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
          TreeOptions.PaintOptions = [toHideFocusRect, toHideSelection, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
          TreeOptions.SelectionOptions = [toFullRowSelect]
          OnGetText = RatesListGetText
          OnGetHint = RatesListGetHint
          OnGetNodeDataSize = RatesListGetNodeDataSize
          OnInitNode = RatesListInitNode
          OddColor = 12437200
          AutoExpand = True
          Columns = <
            item
              Alignment = taRightJustify
              Position = 0
              Width = 100
              WideText = 'Ilo'#347#263
            end
            item
              Position = 1
              Width = 120
              WideText = 'Waluta bazowa'
            end
            item
              Alignment = taRightJustify
              Position = 2
              Width = 100
              WideText = 'Warto'#347#263
            end
            item
              Position = 3
              Width = 135
              WideText = 'Waluta docelowa'
            end>
          WideDefaultText = ''
        end
      end
    end
  end
end
