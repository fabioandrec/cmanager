inherited CChoosePeriodRatesHistoryForm: TCChoosePeriodRatesHistoryForm
  Left = 373
  Top = 37
  ClientHeight = 376
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TCPanel
    Height = 335
    inherited GroupBoxView: TGroupBox
      TabOrder = 2
    end
    object GroupBox2: TGroupBox
      Left = 16
      Top = 152
      Width = 337
      Height = 177
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
      object Label6: TLabel
        Left = 28
        Top = 141
        Width = 76
        Height = 13
        Alignment = taRightJustify
        Caption = 'Rodzaje kurs'#243'w'
      end
      object CStaticSource: TCStatic
        Left = 112
        Top = 33
        Width = 193
        Height = 21
        Cursor = crHandPoint
        Hint = '<wybierz walut'#281'>'
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz walut'#281'>'
        Color = clWindow
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
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
        Hint = '<wybierz walut'#281'>'
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz walut'#281'>'
        Color = clWindow
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
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
        Hint = '<wybierz kontrahenta>'
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz kontrahenta>'
        Color = clWindow
        ParentColor = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz kontrahenta>'
        OnGetDataId = CStaticCashpointGetDataId
        HotTrack = True
      end
      object CheckBoxAvg: TCheckBox
        Left = 112
        Top = 140
        Width = 57
        Height = 17
        Caption = #346'rednie'
        Checked = True
        State = cbChecked
        TabOrder = 3
      end
      object CheckBoxBuy: TCheckBox
        Left = 178
        Top = 140
        Width = 57
        Height = 17
        Caption = 'Kupna'
        Checked = True
        State = cbChecked
        TabOrder = 4
      end
      object CheckBoxSell: TCheckBox
        Left = 240
        Top = 140
        Width = 65
        Height = 17
        Caption = 'Sprzeda'#380
        Checked = True
        State = cbChecked
        TabOrder = 5
      end
    end
  end
  inherited PanelButtons: TCPanel
    Top = 335
  end
end