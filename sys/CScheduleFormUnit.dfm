inherited CScheduleForm: TCScheduleForm
  Left = 275
  Top = 86
  Caption = 'Harmonogram'
  ClientHeight = 374
  ClientWidth = 491
  Position = poDesigned
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 491
    Height = 333
    object GroupBox1: TGroupBox
      Left = 16
      Top = 16
      Width = 457
      Height = 73
      Caption = ' Dane podstawowe '
      TabOrder = 0
      object Label1: TLabel
        Left = 22
        Top = 32
        Width = 18
        Height = 13
        Alignment = taRightJustify
        Caption = 'Typ'
      end
      object Label3: TLabel
        Left = 259
        Top = 32
        Width = 77
        Height = 13
        Alignment = taRightJustify
        Caption = 'Data wykonania'
      end
      object ComboBoxType: TComboBox
        Left = 48
        Top = 28
        Width = 161
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 0
        Text = 'Operacja jednorazowa'
        OnChange = ComboBoxTypeChange
        Items.Strings = (
          'Operacja jednorazowa'
          'Operacja cykliczna')
      end
      object CDateTime: TCDateTime
        Left = 344
        Top = 28
        Width = 89
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz dat'#281'>'
        Color = clWindow
        ParentColor = False
        TabOrder = 1
        HotTrack = True
      end
    end
    object GroupBox2: TGroupBox
      Left = 16
      Top = 104
      Width = 457
      Height = 133
      Caption = ' Warunki zako'#324'czenia '
      TabOrder = 1
      object Label2: TLabel
        Left = 280
        Top = 66
        Width = 56
        Height = 13
        Alignment = taRightJustify
        Caption = 'Data ko'#324'ca'
      end
      object Label4: TLabel
        Left = 268
        Top = 34
        Width = 68
        Height = 13
        Alignment = taRightJustify
        Caption = 'Ilo'#347#263' wykona'#324
      end
      object RadioButtonTimes: TRadioButton
        Left = 24
        Top = 32
        Width = 193
        Height = 17
        Caption = 'Planuj tylko okre'#347'lon'#261' ilo'#347#263' razy'
        TabOrder = 0
        OnClick = RadioButtonTimesClick
      end
      object RadioButtonEnd: TRadioButton
        Left = 24
        Top = 64
        Width = 193
        Height = 17
        Caption = 'Planuj tylko do okre'#347'lonej daty'
        TabOrder = 2
        OnClick = RadioButtonTimesClick
      end
      object RadioButtonAlways: TRadioButton
        Left = 24
        Top = 96
        Width = 161
        Height = 17
        Caption = 'Nie ko'#324'czy si'#281' nigdy'
        Checked = True
        TabOrder = 4
        TabStop = True
        OnClick = RadioButtonTimesClick
      end
      object CDateTimeEnd: TCDateTime
        Left = 344
        Top = 62
        Width = 89
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz dat'#281'>'
        Color = clWindow
        ParentColor = False
        TabOrder = 1
        HotTrack = True
      end
      object CIntEditTimes: TCIntEdit
        Left = 344
        Top = 30
        Width = 89
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 3
        Text = '0'
      end
    end
    object GroupBox3: TGroupBox
      Left = 16
      Top = 248
      Width = 457
      Height = 73
      Caption = ' Warunek wykonania '
      TabOrder = 2
      object Label5: TLabel
        Left = 30
        Top = 32
        Width = 42
        Height = 13
        Alignment = taRightJustify
        Caption = 'Wykonaj'
      end
      object Label6: TLabel
        Left = 185
        Top = 32
        Width = 39
        Height = 13
        Alignment = taRightJustify
        Caption = 'w ka'#380'dy'
      end
      object Label7: TLabel
        Left = 369
        Top = 32
        Width = 69
        Height = 13
        Caption = 'dzie'#324' miesi'#261'ca'
      end
      object ComboBoxWeekday: TComboBox
        Left = 232
        Top = 28
        Width = 201
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 1
        Text = 'Poniedzia'#322'ek'
        Items.Strings = (
          'Poniedzia'#322'ek'
          'Wtorek'
          #346'roda'
          'Czwartek'
          'Pi'#261'tek'
          'Sobota'
          'Niedziela')
      end
      object ComboBoxInterval: TComboBox
        Left = 80
        Top = 28
        Width = 97
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 1
        TabOrder = 0
        Text = 'Co miesi'#261#263
        OnChange = ComboBoxIntervalChange
        Items.Strings = (
          'Co tydzie'#324
          'Co miesi'#261#263)
      end
      object ComboBoxMonthday: TComboBox
        Left = 232
        Top = 28
        Width = 129
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 2
        Text = '1'
        Items.Strings = (
          '1'
          '2'
          '3'
          '4'
          '5'
          '6'
          '7'
          '8'
          '9'
          '10'
          '11'
          '12'
          '13'
          '14'
          '15'
          '16'
          '17'
          '18'
          '19'
          '20'
          '21'
          '22'
          '23'
          '24'
          '25'
          '26'
          '27'
          '28'
          '29'
          '30'
          '31'
          'Ostatni')
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 333
    Width = 491
    inherited BitBtnOk: TBitBtn
      Left = 314
    end
    inherited BitBtnCancel: TBitBtn
      Left = 402
    end
  end
end
