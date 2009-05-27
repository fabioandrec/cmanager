inherited CParamDefForm: TCParamDefForm
  Caption = 'Parametr'
  ClientHeight = 317
  ClientWidth = 566
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TCPanel
    Width = 566
    Height = 276
    object GroupBox1: TGroupBox
      Left = 16
      Top = 16
      Width = 529
      Height = 113
      Caption = ' Dane podstawowe '
      TabOrder = 0
      object Label5: TLabel
        Left = 27
        Top = 36
        Width = 29
        Height = 13
        Alignment = taRightJustify
        Caption = 'Grupa'
      end
      object Label1: TLabel
        Left = 239
        Top = 36
        Width = 33
        Height = 13
        Alignment = taRightJustify
        Caption = 'Nazwa'
      end
      object Label3: TLabel
        Left = 18
        Top = 76
        Width = 38
        Height = 13
        Alignment = taRightJustify
        Caption = 'Etykieta'
      end
      object ComboBoxGroup: TComboBox
        Left = 64
        Top = 32
        Width = 161
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        ItemHeight = 13
        TabOrder = 0
      end
      object EditName: TEdit
        Left = 280
        Top = 32
        Width = 225
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 40
        TabOrder = 1
      end
      object EditDesc: TEdit
        Left = 64
        Top = 72
        Width = 441
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 40
        TabOrder = 2
      end
    end
    object GroupBox2: TGroupBox
      Left = 16
      Top = 144
      Width = 529
      Height = 121
      Caption = ' Rodzaj kontrolki parametru '
      TabOrder = 1
      object Label2: TLabel
        Left = 27
        Top = 36
        Width = 69
        Height = 13
        Alignment = taRightJustify
        Caption = 'Klasa kontrolki'
      end
      object Label4: TLabel
        Left = 42
        Top = 76
        Width = 54
        Height = 13
        Alignment = taRightJustify
        Caption = 'Wymagane'
      end
      object Label6: TLabel
        Left = 272
        Top = 36
        Width = 64
        Height = 13
        Alignment = taRightJustify
        Caption = 'Klasa obiektu'
        FocusControl = BitBtnCancel
      end
      object Label7: TLabel
        Left = 275
        Top = 76
        Width = 61
        Height = 13
        Alignment = taRightJustify
        Caption = 'Multiselekcja'
      end
      object Label8: TLabel
        Left = 274
        Top = 92
        Width = 62
        Height = 13
        Alignment = taRightJustify
        Caption = 'Po przecinku'
      end
      object ComboBoxType: TComboBox
        Left = 104
        Top = 32
        Width = 153
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
        OnChange = ComboBoxTypeChange
      end
      object ComboBoxReq: TComboBox
        Left = 104
        Top = 72
        Width = 153
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 2
        Text = 'Tak'
        Items.Strings = (
          'Tak'
          'Nie')
      end
      object ComboBoxFrameType: TComboBox
        Left = 344
        Top = 32
        Width = 153
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 1
      end
      object ComboBoxMultiple: TComboBox
        Left = 344
        Top = 72
        Width = 153
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 1
        TabOrder = 3
        Text = 'Nie'
        Items.Strings = (
          'Tak'
          'Nie')
      end
      object CIntDecimal: TCIntEdit
        Left = 344
        Top = 88
        Width = 153
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 4
        Text = '2'
      end
      object ComboBoxPropertyType: TComboBox
        Left = 344
        Top = 32
        Width = 153
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 5
      end
      object CStaticListvalues: TCStatic
        Left = 344
        Top = 32
        Width = 153
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<zdefiniuj list'#281' warto'#347'ci>'
        Color = clWindow
        ParentColor = False
        TabOrder = 6
        TabStop = True
        Transparent = False
        TextOnEmpty = '<zdefiniuj list'#281' warto'#347'ci>'
        OnGetDataId = CStaticListvaluesGetDataId
        HotTrack = True
      end
    end
  end
  inherited PanelButtons: TCPanel
    Top = 276
    Width = 566
    inherited BitBtnOk: TBitBtn
      Left = 389
    end
    inherited BitBtnCancel: TBitBtn
      Left = 477
    end
  end
end