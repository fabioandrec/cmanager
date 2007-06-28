inherited CTempFilterForm: TCTempFilterForm
  Caption = 'CTempFilterForm'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    inherited PanelFrame: TPanel
      Top = 32
      Height = 543
      BevelOuter = bvNone
    end
    object CStaticPredefined: TCStatic
      Left = 2
      Top = 5
      Width = 871
      Height = 21
      Cursor = crHandPoint
      Alignment = taCenter
      AutoSize = False
      BevelKind = bkTile
      Caption = '<wybierz predefiniowany filtr>'
      Color = clWindow
      ParentColor = False
      TabOrder = 1
      TabStop = True
      Transparent = False
      TextOnEmpty = '<wybierz predefiniowany filtr>'
      OnGetDataId = CStaticPredefinedGetDataId
      OnChanged = CStaticPredefinedChanged
      HotTrack = True
    end
  end
end
