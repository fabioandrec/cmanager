inherited CChoosePeriodInstrumentValueForm: TCChoosePeriodInstrumentValueForm
  Left = 374
  Top = 267
  ClientWidth = 433
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TCPanel
    Width = 433
    inherited GroupBox1: TGroupBox
      Width = 401
      inherited Label2: TLabel
        Left = 213
      end
      inherited ComboBoxPredefined: TComboBox
        Width = 297
      end
      inherited CDateTime1: TCDateTime
        Width = 113
        Caption = '<wybierz dat'#281' >'
      end
      inherited CDateTime2: TCDateTime
        Left = 255
        Width = 114
        Caption = '<wybierz dat'#281' >'
      end
    end
    object GroupBox2: TGroupBox
      Left = 16
      Top = 152
      Width = 401
      Height = 81
      Caption = ' Instrument inwestycyjny'
      TabOrder = 2
      object Label3: TLabel
        Left = 31
        Top = 37
        Width = 33
        Height = 13
        Alignment = taRightJustify
        Caption = 'Nazwa'
      end
      object CStaticInstrument: TCStatic
        Left = 72
        Top = 33
        Width = 297
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz z listy>'
        Color = clWindow
        ParentColor = False
        TabOrder = 0
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz z listy>'
        OnGetDataId = CStaticInstrumentGetDataId
        HotTrack = True
      end
    end
  end
  inherited PanelButtons: TCPanel
    Width = 433
    inherited BitBtnOk: TBitBtn
      Left = 256
    end
    inherited BitBtnCancel: TBitBtn
      Left = 344
    end
  end
end