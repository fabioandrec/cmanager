inherited CChoosePeriodRatesHistoryForm: TCChoosePeriodRatesHistoryForm
  Left = 432
  Top = 205
  ClientHeight = 354
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Height = 313
    object GroupBox2: TGroupBox
      Left = 16
      Top = 152
      Width = 337
      Height = 153
      Caption = ' Zakres danych '
      TabOrder = 1
      object Label14: TLabel
        Left = 30
        Top = 37
        Width = 74
        Height = 13
        Alignment = taRightJustify
        Caption = 'Waluta bazowa'
      end
      object Label3: TLabel
        Left = 21
        Top = 73
        Width = 83
        Height = 13
        Alignment = taRightJustify
        Caption = 'Waluta docelowa'
      end
      object Label4: TLabel
        Left = 61
        Top = 109
        Width = 43
        Height = 13
        Alignment = taRightJustify
        Caption = 'Kurs w/g'
      end
      object CStaticSource: TCStatic
        Left = 112
        Top = 33
        Width = 193
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz walut'#281'>'
        Color = clWindow
        ParentColor = False
        TabOrder = 0
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz walut'#281'>'
        OnGetDataId = CStaticSourceGetDataId
        HotTrack = True
      end
      object CStaticTarget: TCStatic
        Left = 112
        Top = 69
        Width = 193
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
        OnGetDataId = CStaticTargetGetDataId
        HotTrack = True
      end
      object CStaticCashpoint: TCStatic
        Left = 112
        Top = 105
        Width = 193
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz kontrahenta>'
        Color = clWindow
        ParentColor = False
        TabOrder = 2
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz kontrahenta>'
        OnGetDataId = CStaticCashpointGetDataId
        HotTrack = True
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 313
  end
end
