inherited CUnitdefForm: TCUnitdefForm
  Caption = 'Jednostka miary'
  ClientHeight = 282
  ClientWidth = 370
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 370
    Height = 241
    object GroupBox2: TGroupBox
      Left = 16
      Top = 16
      Width = 337
      Height = 217
      Caption = 'jednostki miary '
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
        Top = 108
        Width = 21
        Height = 13
        Alignment = taRightJustify
        Caption = 'Opis'
      end
      object Label3: TLabel
        Left = 19
        Top = 68
        Width = 93
        Height = 13
        Alignment = taRightJustify
        Caption = 'Symbol wy'#347'wietlany'
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
        Top = 104
        Width = 257
        Height = 89
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 2
      end
      object EditSymbol: TEdit
        Left = 120
        Top = 64
        Width = 193
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 40
        TabOrder = 1
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 241
    Width = 370
    inherited BitBtnOk: TBitBtn
      Left = 193
    end
    inherited BitBtnCancel: TBitBtn
      Left = 281
    end
  end
end
