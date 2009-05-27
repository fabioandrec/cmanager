inherited CQuickpatternForm: TCQuickpatternForm
  Left = 414
  Top = 154
  Caption = 'Szybka operacja'
  ClientHeight = 428
  ClientWidth = 375
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TCPanel
    Width = 375
    Height = 387
    object GroupBox2: TGroupBox
      Left = 16
      Top = 16
      Width = 337
      Height = 209
      Caption = ' Dane podstawowe '
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
      object Label5: TLabel
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
      object RichEditDesc: TCRichedit
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
        Text = 'Rozch'#243'd jednorazowy'
        OnChange = ComboBoxTypeChange
        Items.Strings = (
          'Rozch'#243'd jednorazowy'
          'Przych'#243'd jednorazowy'
          'Transfer '#347'rodk'#243'w')
      end
    end
    object GroupBox1: TGroupBox
      Left = 16
      Top = 240
      Width = 337
      Height = 137
      Caption = ' Dane startowe '
      TabOrder = 1
      object Label14: TLabel
        Left = 21
        Top = 29
        Width = 75
        Height = 13
        Alignment = taRightJustify
        Caption = 'Konto '#378'r'#243'd'#322'owe'
      end
      object Label3: TLabel
        Left = 44
        Top = 65
        Width = 52
        Height = 13
        Alignment = taRightJustify
        Caption = 'Kontrahent'
      end
      object Label4: TLabel
        Left = 51
        Top = 101
        Width = 45
        Height = 13
        Alignment = taRightJustify
        Caption = 'Kategoria'
      end
      object Label6: TLabel
        Left = 19
        Top = 65
        Width = 77
        Height = 13
        Alignment = taRightJustify
        Caption = 'Konto docelowe'
      end
      object CStaticAccount: TCStatic
        Left = 104
        Top = 25
        Width = 209
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz konto '#378'r'#243'd'#322'owe z listy>'
        Color = clWindow
        ParentColor = False
        TabOrder = 0
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz konto '#378'r'#243'd'#322'owe z listy>'
        OnGetDataId = CStaticAccountGetDataId
        HotTrack = True
      end
      object CStaticCashpoint: TCStatic
        Left = 104
        Top = 61
        Width = 209
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
      object CStaticProducts: TCStatic
        Left = 104
        Top = 97
        Width = 209
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz kategori'#281' z listy>'
        Color = clWindow
        ParentColor = False
        TabOrder = 2
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz kategori'#281' z listy>'
        OnGetDataId = CStaticProductsGetDataId
        HotTrack = True
      end
      object CStaticDestAccount: TCStatic
        Left = 104
        Top = 61
        Width = 209
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz konto docelowe z listy>'
        Color = clWindow
        ParentColor = False
        TabOrder = 3
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz konto docelowe z listy>'
        OnGetDataId = CStaticAccountGetDataId
        HotTrack = True
      end
    end
  end
  inherited PanelButtons: TCPanel
    Top = 387
    Width = 375
    inherited BitBtnOk: TBitBtn
      Left = 198
    end
    inherited BitBtnCancel: TBitBtn
      Left = 286
    end
  end
end