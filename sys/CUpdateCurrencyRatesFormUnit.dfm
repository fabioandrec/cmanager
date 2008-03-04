inherited CUpdateCurrencyRatesForm: TCUpdateCurrencyRatesForm
  Left = 256
  Top = 114
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Tabela kurs'#243'w walut'
  ClientHeight = 497
  ClientWidth = 536
  PixelsPerInch = 96
  TextHeight = 13
  object PanelButtons: TPanel
    Left = 0
    Top = 456
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
      OnClick = BitBtnOkClick
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
    Height = 456
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
        Caption = '<wybierz dat'#281' >'
        Color = clWindow
        ParentColor = False
        TabOrder = 0
        TabStop = True
        Transparent = False
        HotTrack = True
        Withtime = False
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
      Height = 352
      Caption = ' Kursy walut '
      TabOrder = 1
      object Label1: TLabel
        Left = 26
        Top = 32
        Width = 86
        Height = 13
        Alignment = taRightJustify
        Caption = 'Tryb importu walut'
      end
      object Panel1: TPanel
        Left = 24
        Top = 64
        Width = 457
        Height = 265
        BevelOuter = bvLowered
        Caption = 'Panel1'
        TabOrder = 0
        object Bevel1: TBevel
          Left = 1
          Top = 220
          Width = 455
          Height = 2
          Align = alBottom
          Shape = bsBottomLine
        end
        object Panel2: TPanel
          Left = 1
          Top = 222
          Width = 455
          Height = 42
          Align = alBottom
          BevelOuter = bvNone
          Color = clWindow
          TabOrder = 0
          object CButtonOut: TCButton
            Left = 173
            Top = 4
            Width = 140
            Height = 33
            Cursor = crHandPoint
            PicPosition = ppLeft
            PicOffset = 10
            TxtOffset = 15
            Framed = False
            Action = Action1
          end
          object CButtonEdit: TCButton
            Left = 308
            Top = 4
            Width = 141
            Height = 33
            Cursor = crHandPoint
            PicPosition = ppLeft
            PicOffset = 10
            TxtOffset = 15
            Framed = False
            Action = Action3
          end
        end
        object RatesList: TCList
          Left = 1
          Top = 1
          Width = 455
          Height = 219
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
          Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
          Header.Style = hsFlatButtons
          HintMode = hmHint
          ParentShowHint = False
          PopupMenu = PopupMenu1
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
          AutoExpand = True
          Columns = <
            item
              Alignment = taRightJustify
              Position = 0
              Width = 70
              WideText = 'Ilo'#347#263
            end
            item
              Position = 1
              Width = 185
              WideText = 'Opis'
            end
            item
              Alignment = taRightJustify
              Position = 2
              Width = 100
              WideText = 'Warto'#347#263
            end
            item
              Position = 3
              Width = 85
              WideText = 'Rodzaj'
            end>
          WideDefaultText = ''
        end
      end
      object ComboBoxType: TComboBox
        Left = 120
        Top = 28
        Width = 361
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        MaxLength = 1
        TabOrder = 1
        Text = 
          'Importuj kursy tylko tych walut, kt'#243're znajduj'#261' si'#281' w bazie dany' +
          'ch'
        OnChange = ComboBoxTypeChange
        Items.Strings = (
          
            'Importuj kursy tylko tych walut, kt'#243're znajduj'#261' si'#281' w bazie dany' +
            'ch'
          'Podczas importu utw'#243'rz waluty, kt'#243'rych brak w bazie danych')
      end
    end
  end
  object ActionManager1: TActionManager
    Images = CImageLists.OperationsImageList24x24
    Left = 248
    Top = 232
    StyleName = 'XP Style'
    object Action1: TAction
      Caption = 'Zaznacz wszystkie'
      ImageIndex = 0
      OnExecute = Action1Execute
    end
    object Action3: TAction
      Caption = 'Odznacz wszystkie'
      ImageIndex = 2
      OnExecute = Action3Execute
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
