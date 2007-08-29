inherited CParamDefForm: TCParamDefForm
  Caption = 'Parametr'
  ClientHeight = 316
  ClientWidth = 524
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 524
    Height = 275
    object GroupBox1: TGroupBox
      Left = 16
      Top = 16
      Width = 489
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
        Width = 177
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 40
        TabOrder = 1
      end
      object EditDesc: TEdit
        Left = 64
        Top = 72
        Width = 393
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
      Width = 489
      Height = 121
      Caption = ' Rodzaj kontrolki parametru '
      TabOrder = 1
      object Label2: TLabel
        Left = 30
        Top = 36
        Width = 26
        Height = 13
        Alignment = taRightJustify
        Caption = 'Klasa'
      end
      object Label4: TLabel
        Left = 338
        Top = 76
        Width = 54
        Height = 13
        Alignment = taRightJustify
        Caption = 'Wymagane'
      end
      object Label6: TLabel
        Left = 73
        Top = 76
        Width = 71
        Height = 13
        Alignment = taRightJustify
        Caption = 'Rodzaj obiektu'
        FocusControl = BitBtnCancel
      end
      object ComboBoxType: TComboBox
        Left = 64
        Top = 32
        Width = 393
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
        OnChange = ComboBoxTypeChange
      end
      object ComboBoxReq: TComboBox
        Left = 400
        Top = 72
        Width = 57
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 1
        Text = 'Tak'
        Items.Strings = (
          'Tak'
          'Nie')
      end
      object ComboBoxFrameType: TComboBox
        Left = 152
        Top = 72
        Width = 169
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 2
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 275
    Width = 524
    inherited BitBtnOk: TBitBtn
      Left = 347
    end
    inherited BitBtnCancel: TBitBtn
      Left = 435
    end
  end
end
