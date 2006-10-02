inherited CPlannedForm: TCPlannedForm
  Left = 245
  Top = 74
  Caption = 'Planowana operacja'
  ClientHeight = 518
  ClientWidth = 536
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 536
    Height = 477
    object GroupBox2: TGroupBox
      Left = 16
      Top = 328
      Width = 505
      Height = 137
      Caption = ' Opis '
      TabOrder = 0
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
      Top = 136
      Width = 505
      Height = 177
      Caption = ' Szczeg'#243#322'y operacji '
      TabOrder = 1
      object Label4: TLabel
        Left = 36
        Top = 29
        Width = 68
        Height = 13
        Alignment = taRightJustify
        Caption = 'Konto operacji'
      end
      object Label2: TLabel
        Left = 59
        Top = 65
        Width = 45
        Height = 13
        Alignment = taRightJustify
        Caption = 'Kategoria'
      end
      object Label6: TLabel
        Left = 52
        Top = 101
        Width = 52
        Height = 13
        Alignment = taRightJustify
        Caption = 'Kontrahent'
      end
      object Label9: TLabel
        Left = 226
        Top = 139
        Width = 30
        Height = 13
        Alignment = taRightJustify
        Caption = 'Kwota'
      end
      object CStaticInoutOnceAccount: TCStatic
        Left = 112
        Top = 25
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
        Top = 61
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
        Top = 97
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
        Top = 135
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
    object GroupBox1: TGroupBox
      Left = 16
      Top = 16
      Width = 505
      Height = 105
      Caption = ' Dane podstawowe '
      TabOrder = 2
      object Label5: TLabel
        Left = 31
        Top = 32
        Width = 73
        Height = 13
        Alignment = taRightJustify
        Caption = 'Rodzaj operacji'
      end
      object Label7: TLabel
        Left = 290
        Top = 32
        Width = 30
        Height = 13
        Alignment = taRightJustify
        Caption = 'Status'
      end
      object Label1: TLabel
        Left = 38
        Top = 69
        Width = 66
        Height = 13
        Alignment = taRightJustify
        Caption = 'Harmonogram'
      end
      object ComboBoxType: TComboBox
        Left = 112
        Top = 28
        Width = 161
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 0
        Text = 'Rozch'#243'd'
        OnChange = ComboBoxTypeChange
        Items.Strings = (
          'Rozch'#243'd'
          'Przych'#243'd')
      end
      object ComboBoxStatus: TComboBox
        Left = 328
        Top = 28
        Width = 137
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 1
        Text = 'Aktywne'
        OnChange = ComboBoxTypeChange
        Items.Strings = (
          'Aktywne'
          'Wy'#322#261'czone')
      end
      object CStaticSchedule: TCStatic
        Left = 112
        Top = 65
        Width = 353
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<ustaw harmonogram wykonywania operacji>'
        Color = clWindow
        ParentColor = False
        TabOrder = 2
        TextOnEmpty = '<ustaw harmonogram wykonywania operacji>'
        OnGetDataId = CStaticScheduleGetDataId
        HotTrack = True
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 477
    Width = 536
    inherited BitBtnOk: TBitBtn
      Left = 359
    end
    inherited BitBtnCancel: TBitBtn
      Left = 447
    end
  end
end
