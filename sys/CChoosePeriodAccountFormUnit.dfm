inherited CChoosePeriodAccountForm: TCChoosePeriodAccountForm
  Left = 359
  Top = 266
  ClientHeight = 283
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Height = 242
    object GroupBox2: TGroupBox
      Left = 16
      Top = 152
      Width = 337
      Height = 81
      Caption = ' Konto '
      TabOrder = 1
      object Label14: TLabel
        Left = 31
        Top = 37
        Width = 33
        Height = 13
        Alignment = taRightJustify
        Caption = 'Nazwa'
      end
      object CStaticAccount: TCStatic
        Left = 72
        Top = 33
        Width = 233
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz konto z listy>'
        Color = clWindow
        ParentColor = False
        TabOrder = 0
        TextOnEmpty = '<wybierz konto z listy>'
        OnGetDataId = CStaticAccountGetDataId
        HotTrack = True
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 242
  end
end
