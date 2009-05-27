inherited CMovementStateForm: TCMovementStateForm
  Left = 490
  Top = 295
  Caption = 'Status operacji'
  ClientHeight = 244
  ClientWidth = 372
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TCPanel
    Width = 372
    Height = 203
    object GroupBox1: TGroupBox
      Left = 16
      Top = 8
      Width = 337
      Height = 65
      Caption = ' Status  '
      TabOrder = 0
      object ComboBoxStatus: TComboBox
        Left = 24
        Top = 24
        Width = 289
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
        OnChange = ComboBoxStatusChange
        Items.Strings = (
          'Do uzgodnienia'
          'Uzgodniona')
      end
    end
    object GroupBox2: TGroupBox
      Left = 16
      Top = 88
      Width = 337
      Height = 105
      Caption = ' Informacje o wyci'#261'gu '
      TabOrder = 1
      object Label20: TLabel
        Left = 21
        Top = 68
        Width = 43
        Height = 13
        Alignment = taRightJustify
        Caption = 'Operacja'
      end
      object Label17: TLabel
        Left = 28
        Top = 32
        Width = 36
        Height = 13
        Alignment = taRightJustify
        Caption = 'Wyci'#261'g'
      end
      object CStaticExtItem: TCStatic
        Left = 72
        Top = 64
        Width = 241
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz operacj'#281' z wyci'#261'gu>'
        Color = clWindow
        Enabled = False
        ParentColor = False
        TabOrder = 0
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz operacj'#281' z wyci'#261'gu>'
        OnGetDataId = CStaticExtItemGetDataId
        HotTrack = True
      end
      object CStaticAccountExt: TCStatic
        Left = 72
        Top = 28
        Width = 241
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz wyci'#261'g>'
        Color = clWindow
        ParentColor = False
        TabOrder = 1
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz wyci'#261'g>'
        OnGetDataId = CStaticAccountExtGetDataId
        HotTrack = True
      end
    end
  end
  inherited PanelButtons: TCPanel
    Top = 203
    Width = 372
    inherited BitBtnOk: TBitBtn
      Left = 195
    end
    inherited BitBtnCancel: TBitBtn
      Left = 283
    end
  end
end