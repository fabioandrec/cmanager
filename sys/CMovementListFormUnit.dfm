inherited CMovementListForm: TCMovementListForm
  Left = 348
  Top = 32
  Caption = 'Lista operacji'
  ClientHeight = 641
  ClientWidth = 536
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 536
    Height = 600
    object GroupBox4: TGroupBox
      Left = 16
      Top = 16
      Width = 505
      Height = 137
      Caption = ' Dane podstawowe '
      TabOrder = 0
      object Label15: TLabel
        Left = 17
        Top = 28
        Width = 23
        Height = 13
        Alignment = taRightJustify
        Caption = 'Data'
      end
      object Label16: TLabel
        Left = 151
        Top = 28
        Width = 33
        Height = 13
        Alignment = taRightJustify
        Caption = 'Rodzaj'
      end
      object Label4: TLabel
        Left = 96
        Top = 65
        Width = 88
        Height = 13
        Alignment = taRightJustify
        Caption = 'Konto listy operacji'
      end
      object Label2: TLabel
        Left = 72
        Top = 101
        Width = 112
        Height = 13
        Alignment = taRightJustify
        Caption = 'Kontrahent listy operacji'
      end
      object CDateTime1: TCDateTime
        Left = 48
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
      object ComboBox1: TComboBox
        Left = 192
        Top = 24
        Width = 289
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 1
        Text = 'Rozch'#243'd'
        Items.Strings = (
          'Rozch'#243'd'
          'Przych'#243'd')
      end
      object CStaticInoutOnceAccount: TCStatic
        Left = 192
        Top = 61
        Width = 289
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz konto '#378'r'#243'd'#322'owe z listy>'
        Color = clWindow
        ParentColor = False
        TabOrder = 2
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz konto '#378'r'#243'd'#322'owe z listy>'
        OnGetDataId = CStaticInoutOnceAccountGetDataId
        HotTrack = True
      end
      object CStaticInoutOnceCashpoint: TCStatic
        Left = 192
        Top = 97
        Width = 289
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz kontrahenta z listy>'
        Color = clWindow
        ParentColor = False
        TabOrder = 3
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz kontrahenta z listy>'
        OnGetDataId = CStaticInoutOnceCashpointGetDataId
        HotTrack = True
      end
    end
    object GroupBox2: TGroupBox
      Left = 16
      Top = 481
      Width = 505
      Height = 112
      Caption = ' Opis '
      TabOrder = 1
      object RichEditDesc: TRichEdit
        Left = 24
        Top = 28
        Width = 457
        Height = 61
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 0
      end
    end
    object GroupBox1: TGroupBox
      Left = 16
      Top = 168
      Width = 505
      Height = 297
      Caption = ' Lista operacji '
      TabOrder = 2
      object Panel1: TPanel
        Left = 24
        Top = 28
        Width = 457
        Height = 213
        BevelOuter = bvLowered
        Caption = 'Panel1'
        TabOrder = 0
        object Bevel1: TBevel
          Left = 1
          Top = 169
          Width = 455
          Height = 2
          Align = alBottom
          Shape = bsBottomLine
        end
        object Panel2: TPanel
          Left = 1
          Top = 171
          Width = 455
          Height = 41
          Align = alBottom
          BevelOuter = bvNone
          Color = clWindow
          TabOrder = 0
          object CButtonOut: TCButton
            Left = 13
            Top = 4
            Width = 124
            Height = 33
            Cursor = crHandPoint
            PicPosition = ppLeft
            PicOffset = 10
            TxtOffset = 15
            Framed = False
            Action = Action1
          end
          object CButtonEdit: TCButton
            Left = 164
            Top = 4
            Width = 125
            Height = 33
            Cursor = crHandPoint
            PicPosition = ppLeft
            PicOffset = 10
            TxtOffset = 15
            Framed = False
            Action = Action2
          end
          object CButtonDel: TCButton
            Left = 316
            Top = 4
            Width = 125
            Height = 33
            Cursor = crHandPoint
            PicPosition = ppLeft
            PicOffset = 10
            TxtOffset = 15
            Framed = False
            Action = Action3
          end
        end
        object MovementList: TVirtualStringTree
          Left = 1
          Top = 1
          Width = 455
          Height = 168
          Align = alClient
          BevelEdges = []
          BevelInner = bvNone
          BevelOuter = bvRaised
          BevelKind = bkFlat
          BorderStyle = bsNone
          DefaultNodeHeight = 24
          Header.AutoSizeIndex = 1
          Header.Font.Charset = DEFAULT_CHARSET
          Header.Font.Color = clWindowText
          Header.Font.Height = -11
          Header.Font.Name = 'MS Sans Serif'
          Header.Font.Style = []
          Header.Height = 21
          Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
          Header.Style = hsFlatButtons
          HintMode = hmHint
          Images = CImageLists.MovementIcons16x16
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
          TreeOptions.MiscOptions = [toCheckSupport, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
          TreeOptions.PaintOptions = [toHideFocusRect, toHideSelection, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
          TreeOptions.SelectionOptions = [toFullRowSelect]
          OnBeforeItemErase = MovementListBeforeItemErase
          OnCompareNodes = MovementListCompareNodes
          OnDblClick = MovementListDblClick
          OnFocusChanged = MovementListFocusChanged
          OnGetText = MovementListGetText
          OnGetHint = MovementListGetHint
          OnGetNodeDataSize = MovementListGetNodeDataSize
          OnHeaderClick = MovementListHeaderClick
          OnInitNode = MovementListInitNode
          Columns = <
            item
              Alignment = taRightJustify
              Options = [coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
              Position = 0
              WideText = 'Lp'
            end
            item
              Position = 1
              Width = 305
              WideText = 'Opis'
              WideHint = 'Nazwa kontrahenta'
            end
            item
              Alignment = taRightJustify
              Position = 2
              Width = 100
              WideText = 'Kwota'
            end>
        end
      end
      object Panel3: TPanel
        Left = 184
        Top = 248
        Width = 305
        Height = 41
        BevelOuter = bvNone
        Enabled = False
        TabOrder = 1
        object Label6: TLabel
          Left = 21
          Top = 12
          Width = 147
          Height = 13
          Alignment = taRightJustify
          Caption = 'Suma kwot wszystkich operacji'
        end
        object CCurrEditCash: TCCurrEdit
          Left = 175
          Top = 8
          Width = 123
          Height = 21
          BorderStyle = bsNone
          TabOrder = 0
          Decimals = 2
          ThousandSep = True
          CurrencyStr = 'z'#322
          BevelKind = bkTile
        end
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 600
    Width = 536
    inherited BitBtnOk: TBitBtn
      Left = 359
    end
    inherited BitBtnCancel: TBitBtn
      Left = 447
    end
  end
  object ActionManager1: TActionManager
    Images = CImageLists.OperationsImageList24x24
    Left = 248
    Top = 232
    StyleName = 'XP Style'
    object Action1: TAction
      Caption = 'Dodaj operacj'#281
      ImageIndex = 0
      OnExecute = Action1Execute
    end
    object Action2: TAction
      Caption = 'Edytuj operacj'#281
      ImageIndex = 1
      OnExecute = Action2Execute
    end
    object Action3: TAction
      Caption = 'Usu'#324' operacj'#281
      ImageIndex = 2
      OnExecute = Action3Execute
    end
  end
end
