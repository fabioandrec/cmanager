inherited CInvestmentWalletForm: TCInvestmentWalletForm
  Left = 249
  Top = 177
  Caption = 'Portfel inwestycyjny'
  ClientHeight = 330
  ClientWidth = 370
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 370
    Height = 289
    object GroupBox2: TGroupBox
      Left = 16
      Top = 16
      Width = 337
      Height = 177
      Caption = ' Dane podstawowe  '
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
      object RichEditDesc: TCRichedit
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
      Height = 73
      Caption = ' Konto powi'#261'zane '
      TabOrder = 1
      object Label4: TLabel
        Left = 15
        Top = 33
        Width = 33
        Height = 13
        Alignment = taRightJustify
        Caption = 'Nazwa'
      end
      object CStaticAccount: TCStatic
        Left = 56
        Top = 29
        Width = 257
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wybierz konto zwi'#261'zne z listy>'
        Color = clWindow
        ParentColor = False
        TabOrder = 0
        TabStop = True
        Transparent = False
        TextOnEmpty = '<wybierz konto zwi'#261'zne z listy>'
        OnGetDataId = CStaticAccountGetDataId
        HotTrack = True
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 289
    Width = 370
    inherited BitBtnOk: TBitBtn
      Left = 193
    end
    inherited BitBtnCancel: TBitBtn
      Left = 281
    end
  end
end
