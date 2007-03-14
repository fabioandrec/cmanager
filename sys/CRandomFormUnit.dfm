inherited CRandomForm: TCRandomForm
  Left = 409
  Top = 102
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Generowanie losowych danych'
  ClientHeight = 430
  ClientWidth = 356
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 16
    Top = 16
    Width = 321
    Height = 113
    Caption = ' Zakres dat '
    TabOrder = 0
    object Label1: TLabel
      Left = 36
      Top = 32
      Width = 84
      Height = 13
      Alignment = taRightJustify
      Caption = 'Data pocz'#261'tkowa'
    end
    object Label2: TLabel
      Left = 50
      Top = 72
      Width = 70
      Height = 13
      Alignment = taRightJustify
      Caption = 'Data ko'#324'cowa'
    end
    object CDateTime1: TCDateTime
      Left = 131
      Top = 28
      Width = 150
      Height = 21
      AutoSize = False
      BevelKind = bkTile
      Caption = '<wybierz dat'#281'>'
      Color = clWindow
      ParentColor = False
      TabOrder = 0
      TabStop = True
      Transparent = False
      HotTrack = True
    end
    object CDateTime2: TCDateTime
      Left = 131
      Top = 68
      Width = 150
      Height = 21
      AutoSize = False
      BevelKind = bkTile
      Caption = '<wybierz dat'#281'>'
      Color = clWindow
      ParentColor = False
      TabOrder = 1
      TabStop = True
      Transparent = False
      HotTrack = True
    end
  end
  object GroupBox2: TGroupBox
    Left = 16
    Top = 144
    Width = 321
    Height = 233
    Caption = ' Ilo'#347'ci '
    TabOrder = 1
    object Label3: TLabel
      Left = 29
      Top = 32
      Width = 91
      Height = 13
      Alignment = taRightJustify
      Caption = 'Rozchody na dzie'#324
    end
    object Label4: TLabel
      Left = 74
      Top = 112
      Width = 46
      Height = 13
      Alignment = taRightJustify
      Caption = 'Ilo'#347#263' kont'
    end
    object Label5: TLabel
      Left = 30
      Top = 152
      Width = 90
      Height = 13
      Alignment = taRightJustify
      Caption = 'Ilo'#347#263' kontrahent'#243'w'
    end
    object Label6: TLabel
      Left = 55
      Top = 192
      Width = 65
      Height = 13
      Alignment = taRightJustify
      Caption = 'Ilo'#347#263' kategorii'
    end
    object Label7: TLabel
      Left = 28
      Top = 72
      Width = 92
      Height = 13
      Alignment = taRightJustify
      Caption = 'Przychody na dzie'#324
    end
    object CIntEdit1: TCIntEdit
      Left = 131
      Top = 28
      Width = 150
      Height = 21
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 0
      Text = '20'
    end
    object CIntEdit2: TCIntEdit
      Left = 131
      Top = 108
      Width = 150
      Height = 21
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 2
      Text = '5'
    end
    object CIntEdit3: TCIntEdit
      Left = 131
      Top = 148
      Width = 150
      Height = 21
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 3
      Text = '10'
    end
    object CIntEdit4: TCIntEdit
      Left = 131
      Top = 188
      Width = 150
      Height = 21
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 4
      Text = '20'
    end
    object CIntEdit5: TCIntEdit
      Left = 131
      Top = 68
      Width = 150
      Height = 21
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 1
      Text = '5'
    end
  end
  object ProgressBar: TProgressBar
    Left = 98
    Top = 398
    Width = 157
    Height = 13
    Smooth = True
    TabOrder = 2
    Visible = False
  end
  object BitBtnOk: TBitBtn
    Left = 16
    Top = 392
    Width = 75
    Height = 25
    Caption = 'Generuj'
    TabOrder = 3
    OnClick = BitBtnOkClick
  end
  object BitBtn1: TBitBtn
    Left = 262
    Top = 392
    Width = 75
    Height = 25
    Caption = 'Zamknij'
    Default = True
    TabOrder = 4
    OnClick = BitBtn1Click
  end
end
