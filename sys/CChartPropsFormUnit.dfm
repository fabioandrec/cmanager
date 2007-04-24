inherited CChartPropsForm: TCChartPropsForm
  Left = 268
  Top = 15
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Wygl'#261'd wykresu'
  ClientHeight = 426
  ClientWidth = 340
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 16
    Top = 16
    Width = 305
    Height = 217
    Caption = ' Tr'#243'jwymiar '
    TabOrder = 0
    object Label1: TLabel
      Left = 27
      Top = 112
      Width = 67
      Height = 13
      Alignment = taRightJustify
      Caption = 'Obr'#243't poziomy'
    end
    object Label2: TLabel
      Left = 240
      Top = 112
      Width = 32
      Height = 13
      Caption = 'Label2'
    end
    object Label3: TLabel
      Left = 27
      Top = 136
      Width = 68
      Height = 13
      Alignment = taRightJustify
      Caption = 'Obr'#243't pionowy'
    end
    object Label4: TLabel
      Left = 240
      Top = 136
      Width = 32
      Height = 13
      Caption = 'Label2'
    end
    object Label5: TLabel
      Left = 27
      Top = 160
      Width = 61
      Height = 13
      Alignment = taRightJustify
      Caption = 'Perspektywa'
    end
    object Label6: TLabel
      Left = 240
      Top = 160
      Width = 32
      Height = 13
      Caption = 'Label2'
    end
    object Label7: TLabel
      Left = 27
      Top = 184
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = 'Nachylenie'
    end
    object Label8: TLabel
      Left = 240
      Top = 184
      Width = 32
      Height = 13
      Caption = 'Label2'
    end
    object Label9: TLabel
      Left = 27
      Top = 64
      Width = 53
      Height = 13
      Alignment = taRightJustify
      Caption = 'G'#322#281'boko'#347#263
    end
    object Label10: TLabel
      Left = 240
      Top = 64
      Width = 32
      Height = 13
      Caption = 'Label2'
    end
    object Label11: TLabel
      Left = 27
      Top = 88
      Width = 42
      Height = 13
      Alignment = taRightJustify
      Caption = 'Zbli'#380'enie'
    end
    object Label12: TLabel
      Left = 240
      Top = 88
      Width = 32
      Height = 13
      Caption = 'Label2'
    end
    object ComboBox: TComboBox
      Left = 27
      Top = 28
      Width = 249
      Height = 21
      BevelInner = bvNone
      BevelKind = bkTile
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      OnChange = ComboBoxChange
      Items.Strings = (
        'wy'#322#261'czony'
        'rzut ortogonalny'
        'w'#322'asne ustawienia')
    end
    object TrackBarRotate: TTrackBar
      Left = 96
      Top = 112
      Width = 137
      Height = 17
      Max = 360
      PageSize = 1
      TabOrder = 3
      ThumbLength = 10
      TickStyle = tsNone
      OnChange = TrackBarRotateChange
    end
    object TrackBarElevation: TTrackBar
      Left = 96
      Top = 136
      Width = 137
      Height = 17
      Max = 360
      PageSize = 1
      TabOrder = 4
      ThumbLength = 10
      TickStyle = tsNone
      OnChange = TrackBarElevationChange
    end
    object TrackBarPerspective: TTrackBar
      Left = 96
      Top = 160
      Width = 137
      Height = 17
      Max = 100
      PageSize = 1
      TabOrder = 5
      ThumbLength = 10
      TickStyle = tsNone
      OnChange = TrackBarPerspectiveChange
    end
    object TrackBarTilt: TTrackBar
      Left = 96
      Top = 184
      Width = 137
      Height = 17
      Max = 360
      PageSize = 1
      TabOrder = 6
      ThumbLength = 10
      TickStyle = tsNone
      OnChange = TrackBarTiltChange
    end
    object TrackBarDepth: TTrackBar
      Left = 96
      Top = 64
      Width = 137
      Height = 17
      Max = 100
      Min = 1
      PageSize = 1
      Position = 1
      TabOrder = 1
      ThumbLength = 10
      TickStyle = tsNone
      OnChange = TrackBarDepthChange
    end
    object TrackBarZoom: TTrackBar
      Left = 96
      Top = 88
      Width = 137
      Height = 17
      Max = 500
      Min = 1
      PageSize = 1
      Position = 1
      TabOrder = 2
      ThumbLength = 10
      TickStyle = tsNone
      OnChange = TrackBarZoomChange
    end
  end
  object GroupBox2: TGroupBox
    Left = 16
    Top = 248
    Width = 305
    Height = 73
    Caption = ' Legenda '
    TabOrder = 1
    object ComboBoxLegendPos: TComboBox
      Left = 27
      Top = 28
      Width = 249
      Height = 21
      BevelInner = bvNone
      BevelKind = bkTile
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      OnChange = ComboBoxLegendPosChange
      Items.Strings = (
        'z lewej'
        'z prawej'
        'z g'#243'ry'
        'z do'#322'u')
    end
  end
  object GroupBoxMarks: TGroupBox
    Left = 16
    Top = 336
    Width = 305
    Height = 73
    Caption = ' Warto'#347'ci '
    TabOrder = 2
    object ComboBoxMarks: TComboBox
      Left = 27
      Top = 28
      Width = 249
      Height = 21
      BevelInner = bvNone
      BevelKind = bkTile
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      OnChange = ComboBoxMarksChange
      Items.Strings = (
        'Ukryte'
        'Warto'#347'ci'
        'Nazwy')
    end
  end
end
