inherited CChoosePeriodFilterForm: TCChoosePeriodFilterForm
  Left = 414
  Top = 197
  ClientHeight = 379
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Height = 338
    inherited GroupBoxView: TGroupBox
      Top = 248
      TabOrder = 2
    end
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
        Caption = '<okre'#347'l warunki wyboru>'
        Color = clWindow
        ParentColor = False
        TabOrder = 0
        TabStop = True
        Transparent = False
        TextOnEmpty = '<okre'#347'l warunki wyboru>'
        OnGetDataId = CStaticFilterGetDataId
        HotTrack = True
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 338
  end
end
