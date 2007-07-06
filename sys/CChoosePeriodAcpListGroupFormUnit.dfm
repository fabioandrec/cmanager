inherited CChoosePeriodAcpListGroupForm: TCChoosePeriodAcpListGroupForm
  Left = 247
  Top = 31
  ClientHeight = 569
  ClientWidth = 363
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 363
    Height = 528
    inherited GroupBox1: TGroupBox
      Width = 329
    end
    inherited GroupBoxView: TGroupBox
      Top = 440
      Width = 329
      TabOrder = 4
    end
    inherited GroupBox2: TGroupBox
      Width = 329
    end
    object GroupBox3: TGroupBox
      Left = 16
      Top = 344
      Width = 329
      Height = 81
      Caption = ' Grupowanie '
      TabOrder = 3
      object Label3: TLabel
        Left = 38
        Top = 36
        Width = 26
        Height = 13
        Alignment = taRightJustify
        Caption = 'Sumy'
      end
      object ComboBoxSums: TComboBox
        Left = 72
        Top = 32
        Width = 233
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 0
        Text = 'dzienne'
        OnChange = ComboBoxPredefinedChange
        Items.Strings = (
          'dzienne'
          'tygodniowe '
          'miesi'#281'czne')
      end
    end
    object GroupBox4: TGroupBox
      Left = 16
      Top = 248
      Width = 329
      Height = 81
      Caption = ' Zakres danych '
      TabOrder = 2
      object Label4: TLabel
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
    Top = 528
    Width = 363
    inherited BitBtnOk: TBitBtn
      Left = 186
    end
    inherited BitBtnCancel: TBitBtn
      Left = 274
    end
  end
end
