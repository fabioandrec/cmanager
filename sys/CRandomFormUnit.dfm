inherited CRandomForm: TCRandomForm
  Left = 275
  Top = 228
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Generowanie losowych danych'
  ClientHeight = 419
  ClientWidth = 442
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 16
    Top = 16
    Width = 409
    Height = 73
    Caption = ' Zakres dat '
    TabOrder = 0
    object Label1: TLabel
      Left = 35
      Top = 32
      Width = 45
      Height = 13
      Alignment = taRightJustify
      Caption = 'Pocz'#261'tek'
    end
    object Label2: TLabel
      Left = 231
      Top = 32
      Width = 33
      Height = 13
      Alignment = taRightJustify
      Caption = 'Koniec'
    end
    object CDateTime1: TCDateTime
      Left = 91
      Top = 28
      Width = 102
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
      Left = 275
      Top = 28
      Width = 102
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
    Top = 224
    Width = 409
    Height = 145
    Caption = ' Ilo'#347'ci '
    TabOrder = 2
    object Label4: TLabel
      Left = 52
      Top = 32
      Width = 28
      Height = 13
      Alignment = taRightJustify
      Caption = 'Konta'
    end
    object Label5: TLabel
      Left = 207
      Top = 32
      Width = 57
      Height = 13
      Alignment = taRightJustify
      Caption = 'Kontrahenci'
    end
    object Label6: TLabel
      Left = 35
      Top = 68
      Width = 45
      Height = 13
      Alignment = taRightJustify
      Caption = 'Kategorie'
    end
    object Label9: TLabel
      Left = 231
      Top = 68
      Width = 33
      Height = 13
      Alignment = taRightJustify
      Caption = 'Waluty'
    end
    object Label10: TLabel
      Left = 35
      Top = 104
      Width = 45
      Height = 13
      Alignment = taRightJustify
      Caption = 'Jednostki'
    end
    object Label11: TLabel
      Left = 210
      Top = 104
      Width = 54
      Height = 13
      Alignment = taRightJustify
      Caption = 'Instrumenty'
    end
    object CIntEdit2: TCIntEdit
      Left = 91
      Top = 28
      Width = 102
      Height = 21
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 0
      Text = '0'
    end
    object CIntEdit3: TCIntEdit
      Left = 275
      Top = 28
      Width = 102
      Height = 21
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 1
      Text = '0'
    end
    object CIntEdit4: TCIntEdit
      Left = 91
      Top = 64
      Width = 102
      Height = 21
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 2
      Text = '0'
    end
    object CIntEdit7: TCIntEdit
      Left = 275
      Top = 64
      Width = 102
      Height = 21
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 3
      Text = '0'
    end
    object CIntEdit8: TCIntEdit
      Left = 91
      Top = 100
      Width = 102
      Height = 21
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 4
      Text = '0'
    end
    object CIntEdit9: TCIntEdit
      Left = 275
      Top = 100
      Width = 102
      Height = 21
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 5
      Text = '0'
    end
  end
  object BitBtnOk: TBitBtn
    Left = 16
    Top = 384
    Width = 75
    Height = 25
    Caption = 'Generuj'
    TabOrder = 3
    OnClick = BitBtnOkClick
  end
  object BitBtn1: TBitBtn
    Left = 350
    Top = 384
    Width = 75
    Height = 25
    Caption = 'Zamknij'
    Default = True
    TabOrder = 4
    OnClick = BitBtn1Click
  end
  object GroupBox3: TGroupBox
    Left = 16
    Top = 104
    Width = 409
    Height = 105
    Caption = ' Operacje '
    TabOrder = 1
    object Label3: TLabel
      Left = 32
      Top = 32
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Caption = 'Rozchody'
    end
    object Label7: TLabel
      Left = 215
      Top = 32
      Width = 49
      Height = 13
      Alignment = taRightJustify
      Caption = 'Przychody'
    end
    object Label8: TLabel
      Left = 36
      Top = 68
      Width = 44
      Height = 13
      Alignment = taRightJustify
      Caption = 'Transfery'
    end
    object CIntEdit1: TCIntEdit
      Left = 91
      Top = 28
      Width = 102
      Height = 21
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 0
      Text = '20'
    end
    object CIntEdit5: TCIntEdit
      Left = 275
      Top = 28
      Width = 102
      Height = 21
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 1
      Text = '5'
    end
    object CIntEdit6: TCIntEdit
      Left = 91
      Top = 64
      Width = 102
      Height = 21
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 2
      Text = '5'
    end
  end
end
