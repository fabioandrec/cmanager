inherited CExtractionForm: TCExtractionForm
  Left = 211
  Top = 25
  Caption = 'Wyci'#261'g'
  ClientHeight = 659
  ClientWidth = 595
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 595
    Height = 618
    object GroupBox1: TGroupBox
      Left = 16
      Top = 16
      Width = 561
      Height = 105
      Caption = ' Dane podstawowe '
      TabOrder = 0
      object Label3: TLabel
        Left = 23
        Top = 28
        Width = 65
        Height = 13
        Alignment = taRightJustify
        Caption = 'Data wyci'#261'gu'
      end
      object Label5: TLabel
        Left = 266
        Top = 68
        Width = 38
        Height = 13
        Alignment = taRightJustify
        Caption = 'Dotyczy'
      end
      object Label1: TLabel
        Left = 58
        Top = 68
        Width = 30
        Height = 13
        Alignment = taRightJustify
        Caption = 'Status'
      end
      object Label2: TLabel
        Left = 247
        Top = 28
        Width = 57
        Height = 13
        Alignment = taRightJustify
        Caption = 'Za okres od'
      end
      object Label4: TLabel
        Left = 420
        Top = 28
        Width = 12
        Height = 13
        Alignment = taRightJustify
        Caption = 'do'
      end
      object CDateTime: TCDateTime
        Left = 96
        Top = 24
        Width = 137
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
        OnChanged = CDateTimeChanged
        HotTrack = True
      end
      object CStaticAccount: TCStatic
        Left = 312
        Top = 64
        Width = 225
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz konto z listy>'
        Color = clWindow
        ParentColor = False
        TabOrder = 1
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz konto z listy>'
        OnGetDataId = CStaticAccountGetDataId
        OnChanged = CStaticAccountChanged
        HotTrack = True
      end
      object ComboBoxState: TComboBox
        Left = 96
        Top = 64
        Width = 137
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 2
        Text = 'Otwarty'
        OnChange = ComboBoxStateChange
        Items.Strings = (
          'Otwarty'
          'Zamkni'#281'ty'
          'Uzgodniony')
      end
      object CDateTime1: TCDateTime
        Left = 312
        Top = 24
        Width = 97
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz dat'#281'>'
        Color = clWindow
        ParentColor = False
        TabOrder = 3
        TabStop = True
        Transparent = False
        OnChanged = CDateTime1Changed
        HotTrack = True
      end
      object CDateTime2: TCDateTime
        Left = 440
        Top = 24
        Width = 97
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz dat'#281'>'
        Color = clWindow
        ParentColor = False
        TabOrder = 4
        TabStop = True
        Transparent = False
        OnChanged = CDateTime2Changed
        HotTrack = True
      end
    end
    object GroupBox2: TGroupBox
      Left = 16
      Top = 443
      Width = 561
      Height = 169
      Caption = ' Opis '
      TabOrder = 1
      object CButton1: TCButton
        Left = 294
        Top = 126
        Width = 115
        Height = 25
        Cursor = crHandPoint
        PicPosition = ppLeft
        PicOffset = 10
        TxtOffset = 15
        Framed = False
        Action = ActionAdd
        Color = clBtnFace
      end
      object CButton2: TCButton
        Left = 412
        Top = 126
        Width = 129
        Height = 25
        Cursor = crHandPoint
        PicPosition = ppLeft
        PicOffset = 10
        TxtOffset = 15
        Framed = False
        Action = ActionTemplate
        Color = clBtnFace
      end
      object RichEditDesc: TCRichedit
        Left = 24
        Top = 28
        Width = 513
        Height = 89
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 0
      end
      object ComboBoxTemplate: TComboBox
        Left = 24
        Top = 128
        Width = 97
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 1
        TabOrder = 1
        Text = 'W/g szablonu'
        Items.Strings = (
          'W'#322'asny'
          'W/g szablonu')
      end
    end
    object GroupBox3: TGroupBox
      Left = 16
      Top = 136
      Width = 561
      Height = 289
      Caption = ' Lista operacji '
      TabOrder = 2
      object Panel1: TPanel
        Left = 24
        Top = 32
        Width = 513
        Height = 233
        BevelOuter = bvLowered
        Caption = 'Panel1'
        TabOrder = 0
        object Bevel1: TBevel
          Left = 1
          Top = 189
          Width = 511
          Height = 2
          Align = alBottom
          Shape = bsBottomLine
        end
        object Panel2: TPanel
          Left = 1
          Top = 191
          Width = 511
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
            Left = 188
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
            Left = 372
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
        object MovementList: TCList
          Left = 1
          Top = 1
          Width = 511
          Height = 188
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
          Images = CImageLists.MovementIcons16x16
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
          TreeOptions.MiscOptions = [toCheckSupport, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
          TreeOptions.PaintOptions = [toHideFocusRect, toHideSelection, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
          TreeOptions.SelectionOptions = [toFullRowSelect]
          OnCompareNodes = MovementListCompareNodes
          OnDblClick = MovementListDblClick
          OnFocusChanged = MovementListFocusChanged
          OnGetText = MovementListGetText
          OnGetImageIndex = MovementListGetImageIndex
          OnGetHint = MovementListGetHint
          OnGetNodeDataSize = MovementListGetNodeDataSize
          OnInitNode = MovementListInitNode
          OddColor = 12437200
          AutoExpand = True
          Columns = <
            item
              Alignment = taRightJustify
              Options = [coDraggable, coEnabled, coParentBidiMode, coParentColor, coResizable, coShowDropMark, coVisible]
              Position = 0
              Width = 60
              WideText = 'Lp'
            end
            item
              Position = 1
              Width = 80
              WideText = 'Data operacji'
            end
            item
              Position = 2
              Width = 160
              WideText = 'Opis'
              WideHint = 'Opis'
            end
            item
              Alignment = taRightJustify
              Position = 3
              Width = 60
              WideText = 'Kwota'
            end
            item
              Position = 4
              WideText = 'Waluta'
            end
            item
              Position = 5
              Width = 81
              WideText = 'Rodzaj'
            end>
          WideDefaultText = ''
        end
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 618
    Width = 595
    inherited BitBtnOk: TBitBtn
      Left = 418
    end
    inherited BitBtnCancel: TBitBtn
      Left = 506
    end
  end
  object ActionManager: TActionManager
    Images = CImageLists.TemplateImageList16x16
    Left = 32
    Top = 74
    StyleName = 'XP Style'
    object ActionAdd: TAction
      Caption = 'Wstaw mnemonik'
      ImageIndex = 0
      OnExecute = ActionAddExecute
    end
    object ActionTemplate: TAction
      Caption = 'Konfiguruj szablony'
      ImageIndex = 1
      OnExecute = ActionTemplateExecute
    end
  end
  object ActionManager1: TActionManager
    Images = CImageLists.OperationsImageList24x24
    Left = 256
    Top = 88
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
