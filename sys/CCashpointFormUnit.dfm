inherited CCashpointForm: TCCashpointForm
  Left = 280
  Top = 107
  Caption = 'Kontrahent'
  ClientHeight = 273
  ClientWidth = 370
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TCPanel
    Width = 370
    Height = 232
    object GroupBox2: TGroupBox
      Left = 16
      Top = 16
      Width = 337
      Height = 209
      Caption = ' Dane kontrahenta '
      TabOrder = 0
      object Label1: TLabel
        Left = 15
        Top = 32
        Width = 33
        Height = 13
        Alignment = taRightJustify
        Caption = 'Nazwa'
      end
      object Label2: TLabel
        Left = 27
        Top = 68
        Width = 21
        Height = 13
        Alignment = taRightJustify
        Caption = 'Opis'
      end
      object Label3: TLabel
        Left = 15
        Top = 172
        Width = 33
        Height = 13
        Alignment = taRightJustify
        Caption = 'Rodzaj'
      end
      object EditName: TEdit
        Left = 56
        Top = 28
        Width = 257
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 40
        TabOrder = 0
      end
      object RichEditDesc: TCRichEdit
        Left = 56
        Top = 64
        Width = 257
        Height = 89
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 1
      end
      object ComboBoxType: TComboBox
        Left = 56
        Top = 168
        Width = 257
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 2
        Text = 'Dost'#281'pny wsz'#281'dzie'
        Items.Strings = (
          'Dost'#281'pny wsz'#281'dzie'
          'Tylko rozchody'
          'Tylko przychody'
          'Pozosta'#322'e')
      end
    end
  end
  inherited PanelButtons: TCPanel
    Top = 232
    Width = 370
    inherited BitBtnOk: TBitBtn
      Left = 193
    end
    inherited BitBtnCancel: TBitBtn
      Left = 281
    end
  end
end