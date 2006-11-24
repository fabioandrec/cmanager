inherited CChooseDateAccountListForm: TCChooseDateAccountListForm
  Left = 328
  Top = 256
  Caption = 'CChooseDateAccountListForm'
  ClientHeight = 248
  ClientWidth = 372
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 372
    Height = 207
    inherited GroupBox1: TGroupBox
      Width = 337
      inherited CDateTime1: TCDateTime
        Width = 281
      end
    end
    object GroupBox2: TGroupBox
      Left = 16
      Top = 112
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
    Top = 207
    Width = 372
    inherited BitBtnOk: TBitBtn
      Left = 195
    end
    inherited BitBtnCancel: TBitBtn
      Left = 283
    end
  end
end
