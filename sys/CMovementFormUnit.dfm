inherited CMovementForm: TCMovementForm
  Caption = 'Operacja'
  ClientHeight = 477
  ClientWidth = 536
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 536
    Height = 436
    object GroupBox1: TGroupBox
      Left = 16
      Top = 16
      Width = 505
      Height = 65
      Caption = ' Dane podstawowe '
      TabOrder = 0
      object Label3: TLabel
        Left = 17
        Top = 28
        Width = 23
        Height = 13
        Alignment = taRightJustify
        Caption = 'Data'
      end
      object Label5: TLabel
        Left = 151
        Top = 28
        Width = 33
        Height = 13
        Alignment = taRightJustify
        Caption = 'Rodzaj'
      end
      object CDateTime: TCDateTime
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
        HotTrack = True
      end
      object ComboBoxType: TComboBox
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
        Text = 'Rozch'#243'd jednorazowy'
        OnChange = ComboBoxTypeChange
        Items.Strings = (
          'Rozch'#243'd jednorazowy'
          'Przych'#243'd jednorazowy'
          'Transfer '#347'rodk'#243'w'
          'Planowany rozch'#243'd'
          'Planowany przych'#243'd')
      end
    end
    object GroupBox2: TGroupBox
      Left = 16
      Top = 288
      Width = 505
      Height = 137
      Caption = ' Opis '
      TabOrder = 1
      object RichEditDesc: TRichEdit
        Left = 24
        Top = 28
        Width = 457
        Height = 89
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 0
      end
    end
    object GroupBox3: TGroupBox
      Left = 16
      Top = 96
      Width = 505
      Height = 177
      Caption = ' Szczeg'#243#322'y operacji '
      TabOrder = 2
      object PageControl: TPageControl
        Left = 2
        Top = 15
        Width = 501
        Height = 160
        ActivePage = TabSheetInOutCyclic
        Align = alClient
        Style = tsFlatButtons
        TabOrder = 0
        TabStop = False
        object TabSheetInOutCyclic: TTabSheet
          Caption = 'TabSheetInOutCyclic'
          TabVisible = False
          object Label10: TLabel
            Left = 226
            Top = 119
            Width = 30
            Height = 13
            Alignment = taRightJustify
            Caption = 'Kwota'
          end
          object Label11: TLabel
            Left = 61
            Top = 9
            Width = 43
            Height = 13
            Alignment = taRightJustify
            Caption = 'Operacja'
          end
          object Label14: TLabel
            Left = 36
            Top = 45
            Width = 68
            Height = 13
            Alignment = taRightJustify
            Caption = 'Konto operacji'
          end
          object Label12: TLabel
            Left = 59
            Top = 81
            Width = 45
            Height = 13
            Alignment = taRightJustify
            Caption = 'Kategoria'
          end
          object Label13: TLabel
            Left = 268
            Top = 81
            Width = 52
            Height = 13
            Alignment = taRightJustify
            Caption = 'Kontrahent'
          end
          object CCurrEditInoutCyclic: TCCurrEdit
            Left = 264
            Top = 115
            Width = 209
            Height = 21
            BorderStyle = bsNone
            TabOrder = 0
            Decimals = 2
            CurrencyStr = 'z'#322
            ThousandSep = True
            BevelKind = bkTile
          end
          object CStaticInoutCyclic: TCStatic
            Left = 112
            Top = 5
            Width = 361
            Height = 21
            Cursor = crHandPoint
            AutoSize = False
            BevelKind = bkTile
            Caption = '<wybierz operacj'#281' z listy zaplanowanych operacji>'
            Color = clWindow
            ParentColor = False
            TabOrder = 1
            TextOnEmpty = '<wybierz operacj'#281' z listy zaplanowanych operacji>'
            OnGetDataId = CStaticInoutCyclicGetDataId
            OnChanged = CStaticInoutCyclicChanged
            HotTrack = True
          end
          object CStaticInoutCyclicAccount: TCStatic
            Left = 112
            Top = 41
            Width = 361
            Height = 21
            Cursor = crHandPoint
            AutoSize = False
            BevelKind = bkTile
            Caption = '<wybierz konto z listy>'
            Color = clWindow
            ParentColor = False
            TabOrder = 2
            TextOnEmpty = '<wybierz konto z listy>'
            OnGetDataId = CStaticInoutCyclicAccountGetDataId
            OnChanged = CStaticInoutOnceAccountChanged
            HotTrack = True
          end
          object CStaticInoutCyclicCategory: TCStatic
            Left = 112
            Top = 77
            Width = 145
            Height = 21
            Cursor = crHandPoint
            AutoSize = False
            BevelKind = bkTile
            Caption = '<wybierz kategori'#281' z listy>'
            Color = clWindow
            ParentColor = False
            TabOrder = 3
            TextOnEmpty = '<wybierz kategori'#281' z listy>'
            OnGetDataId = CStaticInoutCyclicCategoryGetDataId
            OnChanged = CStaticInoutOnceAccountChanged
            HotTrack = True
          end
          object CStaticInoutCyclicCashpoint: TCStatic
            Left = 328
            Top = 77
            Width = 145
            Height = 21
            Cursor = crHandPoint
            AutoSize = False
            BevelKind = bkTile
            Caption = '<wybierz kontrahenta z listy>'
            Color = clWindow
            ParentColor = False
            TabOrder = 4
            TextOnEmpty = '<wybierz kontrahenta z listy>'
            OnGetDataId = CStaticInoutCyclicCashpointGetDataId
            OnChanged = CStaticInoutOnceAccountChanged
            HotTrack = True
          end
        end
        object TabSheetTrans: TTabSheet
          Caption = 'TabSheetTrans'
          ImageIndex = 2
          TabVisible = False
          object Label6: TLabel
            Left = 29
            Top = 9
            Width = 75
            Height = 13
            Alignment = taRightJustify
            Caption = 'Konto '#378'r'#243'd'#322'owe'
          end
          object Label7: TLabel
            Left = 27
            Top = 45
            Width = 77
            Height = 13
            Alignment = taRightJustify
            Caption = 'Konto docelowe'
          end
          object Label8: TLabel
            Left = 226
            Top = 119
            Width = 30
            Height = 13
            Alignment = taRightJustify
            Caption = 'Kwota'
          end
          object CStaticTransSourceAccount: TCStatic
            Left = 112
            Top = 5
            Width = 361
            Height = 21
            Cursor = crHandPoint
            AutoSize = False
            BevelKind = bkTile
            Caption = '<wybierz konto '#378'r'#243'd'#322'owe z listy>'
            Color = clWindow
            ParentColor = False
            TabOrder = 0
            TextOnEmpty = '<wybierz konto '#378'r'#243'd'#322'owe z listy>'
            OnGetDataId = CStaticTransSourceAccountGetDataId
            OnChanged = CStaticInoutOnceAccountChanged
            HotTrack = True
          end
          object CStaticTransDestAccount: TCStatic
            Left = 112
            Top = 41
            Width = 361
            Height = 21
            Cursor = crHandPoint
            AutoSize = False
            BevelKind = bkTile
            Caption = '<wybierz konto docelowe z listy>'
            Color = clWindow
            ParentColor = False
            TabOrder = 1
            TextOnEmpty = '<wybierz konto docelowe z listy>'
            OnGetDataId = CStaticTransDestAccountGetDataId
            OnChanged = CStaticInoutOnceAccountChanged
            HotTrack = True
          end
          object CCurrEditTrans: TCCurrEdit
            Left = 264
            Top = 115
            Width = 209
            Height = 21
            BorderStyle = bsNone
            TabOrder = 2
            Decimals = 2
            CurrencyStr = 'z'#322
            ThousandSep = True
            BevelKind = bkTile
          end
        end
        object TabSheetInOutOnce: TTabSheet
          Caption = 'TabSheetInOutOnce'
          ImageIndex = 4
          TabVisible = False
          object Label4: TLabel
            Left = 36
            Top = 9
            Width = 68
            Height = 13
            Alignment = taRightJustify
            Caption = 'Konto operacji'
          end
          object Label1: TLabel
            Left = 59
            Top = 45
            Width = 45
            Height = 13
            Alignment = taRightJustify
            Caption = 'Kategoria'
          end
          object Label2: TLabel
            Left = 52
            Top = 81
            Width = 52
            Height = 13
            Alignment = taRightJustify
            Caption = 'Kontrahent'
          end
          object Label9: TLabel
            Left = 226
            Top = 119
            Width = 30
            Height = 13
            Alignment = taRightJustify
            Caption = 'Kwota'
          end
          object CStaticInoutOnceAccount: TCStatic
            Left = 112
            Top = 5
            Width = 361
            Height = 21
            Cursor = crHandPoint
            AutoSize = False
            BevelKind = bkTile
            Caption = '<wybierz konto '#378'r'#243'd'#322'owe z listy>'
            Color = clWindow
            ParentColor = False
            TabOrder = 0
            TextOnEmpty = '<wybierz konto '#378'r'#243'd'#322'owe z listy>'
            OnGetDataId = CStaticInoutOnceAccountGetDataId
            OnChanged = CStaticInoutOnceAccountChanged
            HotTrack = True
          end
          object CStaticInoutOnceCategory: TCStatic
            Left = 112
            Top = 41
            Width = 361
            Height = 21
            Cursor = crHandPoint
            AutoSize = False
            BevelKind = bkTile
            Caption = '<wybierz kategori'#281' z listy>'
            Color = clWindow
            ParentColor = False
            TabOrder = 1
            TextOnEmpty = '<wybierz kategori'#281' z listy>'
            OnGetDataId = CStaticInoutOnceCategoryGetDataId
            OnChanged = CStaticInoutOnceAccountChanged
            HotTrack = True
          end
          object CStaticInoutOnceCashpoint: TCStatic
            Left = 112
            Top = 77
            Width = 361
            Height = 21
            Cursor = crHandPoint
            AutoSize = False
            BevelKind = bkTile
            Caption = '<wybierz kontrahenta z listy>'
            Color = clWindow
            ParentColor = False
            TabOrder = 2
            TextOnEmpty = '<wybierz kontrahenta z listy>'
            OnGetDataId = CStaticInoutOnceCashpointGetDataId
            OnChanged = CStaticInoutOnceAccountChanged
            HotTrack = True
          end
          object CCurrEditInoutOnce: TCCurrEdit
            Left = 264
            Top = 115
            Width = 209
            Height = 21
            BorderStyle = bsNone
            TabOrder = 3
            Decimals = 2
            CurrencyStr = 'z'#322
            ThousandSep = True
            BevelKind = bkTile
          end
        end
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 436
    Width = 536
    inherited BitBtnOk: TBitBtn
      Left = 359
    end
    inherited BitBtnCancel: TBitBtn
      Left = 447
    end
  end
end
