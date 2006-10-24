inherited CChooseDateForm: TCChooseDateForm
  Left = 362
  Top = 400
  Caption = 'Parametry raportu'
  ClientHeight = 155
  ClientWidth = 234
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 234
    Height = 114
    object GroupBox1: TGroupBox
      Left = 16
      Top = 16
      Width = 201
      Height = 81
      Caption = ' Dla daty '
      TabOrder = 0
      object CDateTime1: TCDateTime
        Left = 24
        Top = 32
        Width = 150
        Height = 21
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz dat'#281'>'
        Color = clWindow
        ParentColor = False
        TabOrder = 0
        HotTrack = True
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 114
    Width = 234
    inherited BitBtnOk: TBitBtn
      Left = 57
    end
    inherited BitBtnCancel: TBitBtn
      Left = 145
    end
  end
end
