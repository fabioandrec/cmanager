inherited CCurrencyRateForm: TCCurrencyRateForm
  Left = 201
  Top = 152
  Caption = 'Kurs waluty'
  ClientHeight = 205
  ClientWidth = 461
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 461
    Height = 164
    object GroupBox4: TGroupBox
      Left = 16
      Top = 16
      Width = 433
      Height = 65
      Caption = ' Dane podstawowe '
      TabOrder = 0
      object Label15: TLabel
        Left = 19
        Top = 28
        Width = 61
        Height = 13
        Alignment = taRightJustify
        Caption = 'Kurs dla dnia'
      end
      object Label2: TLabel
        Left = 186
        Top = 29
        Width = 19
        Height = 13
        Alignment = taRightJustify
        Caption = 'w/g'
      end
      object CDateTime: TCDateTime
        Left = 88
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
      object CStaticCashpoint: TCStatic
        Left = 213
        Top = 25
        Width = 196
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
    end
    object GroupBox1: TGroupBox
      Left = 16
      Top = 92
      Width = 433
      Height = 65
      Caption = ' Przelicznik '
      TabOrder = 1
      object Label1: TLabel
        Left = 198
        Top = 28
        Width = 39
        Height = 13
        Alignment = taRightJustify
        Caption = 'kosztuje'
      end
      object CIntQuantity: TCIntEdit
        Left = 24
        Top = 24
        Width = 65
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 0
        Text = '1'
      end
      object CStaticBaseCurrencydef: TCStatic
        Left = 101
        Top = 24
        Width = 89
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz walut'#281'>'
        Color = clWindow
        ParentColor = False
        TabOrder = 1
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz walut'#281'>'
        OnGetDataId = CStaticBaseCurrencydefGetDataId
        HotTrack = True
      end
      object CStaticTargetCurrencydef: TCStatic
        Left = 321
        Top = 24
        Width = 89
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz walut'#281'>'
        Color = clWindow
        ParentColor = False
        TabOrder = 3
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz walut'#281'>'
        OnGetDataId = CStaticTargetCurrencydefGetDataId
        HotTrack = True
      end
      object CCurrRate: TCCurrEdit
        Left = 245
        Top = 24
        Width = 64
        Height = 21
        BorderStyle = bsNone
        TabOrder = 2
        Decimals = 4
        ThousandSep = True
        BevelKind = bkTile
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 164
    Width = 461
    inherited BitBtnOk: TBitBtn
      Left = 284
    end
    inherited BitBtnCancel: TBitBtn
      Left = 372
    end
  end
end
