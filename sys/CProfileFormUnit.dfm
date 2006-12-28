inherited CProfileForm: TCProfileForm
  Caption = 'Profil'
  ClientHeight = 403
  ClientWidth = 375
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 375
    Height = 362
    object GroupBox2: TGroupBox
      Left = 16
      Top = 16
      Width = 337
      Height = 177
      Caption = ' Dane podstawowe '
      TabOrder = 0
      object Label1: TLabel
        Left = 15
        Top = 32
        Width = 33
        Height = 13
        Alignment = taRightJustify
        Caption = 'Nazwa'
      end
      object Label2: TLabel
        Left = 27
        Top = 68
        Width = 21
        Height = 13
        Alignment = taRightJustify
        Caption = 'Opis'
      end
      object EditName: TEdit
        Left = 56
        Top = 28
        Width = 257
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 40
        TabOrder = 0
      end
      object RichEditDesc: TRichEdit
        Left = 56
        Top = 64
        Width = 257
        Height = 89
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 1
      end
    end
    object GroupBox1: TGroupBox
      Left = 16
      Top = 208
      Width = 337
      Height = 145
      Caption = ' Definicja zakresu '
      TabOrder = 1
      object Label14: TLabel
        Left = 44
        Top = 29
        Width = 28
        Height = 13
        Alignment = taRightJustify
        Caption = 'Konto'
      end
      object Label3: TLabel
        Left = 20
        Top = 65
        Width = 52
        Height = 13
        Alignment = taRightJustify
        Caption = 'Kontrahent'
      end
      object Label4: TLabel
        Left = 27
        Top = 101
        Width = 45
        Height = 13
        Alignment = taRightJustify
        Caption = 'Kategoria'
      end
      object CStaticAccount: TCStatic
        Left = 80
        Top = 25
        Width = 233
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz konto '#378'r'#243'd'#322'owe z listy>'
        Color = clWindow
        ParentColor = False
        TabOrder = 0
        TextOnEmpty = '<wybierz konto '#378'r'#243'd'#322'owe z listy>'
        OnGetDataId = CStaticAccountGetDataId
        HotTrack = True
      end
      object CStaticCashpoint: TCStatic
        Left = 80
        Top = 61
        Width = 233
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz kontrahenta z listy>'
        Color = clWindow
        ParentColor = False
        TabOrder = 1
        TextOnEmpty = '<wybierz kontrahenta z listy>'
        OnGetDataId = CStaticCashpointGetDataId
        HotTrack = True
      end
      object CStaticProducts: TCStatic
        Left = 80
        Top = 97
        Width = 233
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz kategori'#281' z listy>'
        Color = clWindow
        ParentColor = False
        TabOrder = 2
        TextOnEmpty = '<wybierz kategori'#281' z listy>'
        OnGetDataId = CStaticProductsGetDataId
        HotTrack = True
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 362
    Width = 375
    inherited BitBtnOk: TBitBtn
      Left = 198
    end
    inherited BitBtnCancel: TBitBtn
      Left = 286
    end
  end
end
