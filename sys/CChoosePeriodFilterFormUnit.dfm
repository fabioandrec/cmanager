inherited CChoosePeriodFilterForm: TCChoosePeriodFilterForm
  Left = 388
  Top = 268
  ClientHeight = 287
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Height = 246
    object GroupBox2: TGroupBox
      Left = 16
      Top = 152
      Width = 337
      Height = 81
      Caption = ' Zakres danych '
      TabOrder = 1
      object Label14: TLabel
        Left = 18
        Top = 37
        Width = 46
        Height = 13
        Alignment = taRightJustify
        Caption = 'Filtruj w/g'
      end
      object CStaticFilter: TCStatic
        Left = 72
        Top = 33
        Width = 233
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<brak aktywnego filtru>'
        Color = clWindow
        ParentColor = False
        TabOrder = 0
        TextOnEmpty = '<brak aktywnego filtru>'
        OnGetDataId = CStaticFilterGetDataId
        HotTrack = True
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 246
  end
end
