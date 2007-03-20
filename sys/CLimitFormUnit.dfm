inherited CLimitForm: TCLimitForm
  Caption = 'Limit'
  ClientHeight = 499
  ClientWidth = 368
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 368
    Height = 458
    object GroupBox2: TGroupBox
      Left = 16
      Top = 16
      Width = 337
      Height = 217
      Caption = ' Dane podstawowe '
      TabOrder = 0
      object Label1: TLabel
        Left = 15
        Top = 72
        Width = 33
        Height = 13
        Alignment = taRightJustify
        Caption = 'Nazwa'
      end
      object Label2: TLabel
        Left = 27
        Top = 109
        Width = 21
        Height = 13
        Alignment = taRightJustify
        Caption = 'Opis'
      end
      object Label7: TLabel
        Left = 18
        Top = 36
        Width = 30
        Height = 13
        Alignment = taRightJustify
        Caption = 'Status'
      end
      object EditName: TEdit
        Left = 56
        Top = 68
        Width = 257
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 40
        TabOrder = 1
      end
      object RichEditDesc: TRichEdit
        Left = 56
        Top = 105
        Width = 257
        Height = 89
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 2
      end
      object ComboBoxStatus: TComboBox
        Left = 56
        Top = 32
        Width = 257
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 0
        Text = 'Aktywny'
        Items.Strings = (
          'Aktywny'
          'Wy'#322#261'czony')
      end
    end
    object GroupBox1: TGroupBox
      Left = 16
      Top = 248
      Width = 337
      Height = 81
      Caption = ' Zakres danych '
      TabOrder = 1
      object Label3: TLabel
        Left = 22
        Top = 36
        Width = 90
        Height = 13
        Alignment = taRightJustify
        Caption = 'Filtruj operacje w/g'
      end
      object CStaticFilter: TCStatic
        Left = 120
        Top = 33
        Width = 193
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wszystkie operacje>'
        Color = clWindow
        ParentColor = False
        TabOrder = 0
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wszystkie operacje>'
        OnGetDataId = CStaticFilterGetDataId
        HotTrack = True
      end
    end
    object GroupBox3: TGroupBox
      Left = 16
      Top = 344
      Width = 337
      Height = 105
      Caption = ' Zakres dat '
      TabOrder = 2
      object Label4: TLabel
        Left = 145
        Top = 66
        Width = 39
        Height = 13
        Alignment = taRightJustify
        Caption = 'Ilo'#347#263' dni'
      end
      object Label5: TLabel
        Left = 235
        Top = 66
        Width = 78
        Height = 13
        Caption = '(w'#322#261'cznie z dzi'#347')'
      end
      object Label6: TLabel
        Left = 17
        Top = 32
        Width = 95
        Height = 13
        Alignment = taRightJustify
        Caption = 'Operacje wykonane'
      end
      object CIntEditDays: TCIntEdit
        Left = 192
        Top = 62
        Width = 33
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 0
        Text = '0'
      end
      object ComboBoxDays: TComboBox
        Left = 120
        Top = 28
        Width = 193
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 1
        Text = 'Dzi'#347
        OnChange = ComboBoxDaysChange
        Items.Strings = (
          'Dzi'#347
          'Wczoraj i dzi'#347
          'Ten tydzie'#324
          'Ten miesi'#261'c'
          'Ten kwarta'#322
          'To p'#243#322'rocze'
          'Ten rok'
          'Okre'#347'lon'#261' ilo'#347#263' poprzednich dni')
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 458
    Width = 368
    inherited BitBtnOk: TBitBtn
      Left = 191
    end
    inherited BitBtnCancel: TBitBtn
      Left = 279
    end
  end
end
