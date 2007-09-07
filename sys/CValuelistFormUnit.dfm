inherited CValuelistForm: TCValuelistForm
  Caption = 'Lista warto'#347'ci'
  ClientHeight = 533
  ClientWidth = 595
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 595
    Height = 492
    object TPanel
      Left = 8
      Top = 8
      Width = 580
      Height = 481
      BevelOuter = bvLowered
      TabOrder = 0
      object ValueListEditor: TValueListEditor
        Left = 1
        Top = 1
        Width = 578
        Height = 479
        Align = alClient
        BorderStyle = bsNone
        KeyOptions = [keyEdit, keyAdd, keyDelete]
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing, goTabs, goAlwaysShowEditor, goThumbTracking]
        TabOrder = 0
        TitleCaptions.Strings = (
          'Nazwa'
          'Warto'#347#263)
        ColWidths = (
          271
          305)
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 492
    Width = 595
    inherited BitBtnOk: TBitBtn
      Left = 418
    end
    inherited BitBtnCancel: TBitBtn
      Left = 506
    end
  end
end
