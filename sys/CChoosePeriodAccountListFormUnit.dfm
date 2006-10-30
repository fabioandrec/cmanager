inherited CChoosePeriodAccountListForm: TCChoosePeriodAccountListForm
  Left = 394
  Top = 239
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
      Caption = ' Lista kont  '
      TabOrder = 1
      object Label14: TLabel
        Left = 21
        Top = 37
        Width = 43
        Height = 13
        Alignment = taRightJustify
        Caption = 'Wybrano'
      end
      object CStaticAccount: TCStatic
        Left = 72
        Top = 33
        Width = 233
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wszystkie konta>'
        Color = clWindow
        ParentColor = False
        TabOrder = 0
        TextOnEmpty = '<wszystkie konta>'
        OnGetDataId = CStaticAccountGetDataId
        HotTrack = True
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 246
  end
end
