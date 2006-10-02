inherited CCashpointForm: TCCashpointForm
  Left = 274
  Top = 180
  Caption = 'Kontrahent'
  ClientHeight = 245
  ClientWidth = 370
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 370
    Height = 204
    object GroupBox2: TGroupBox
      Left = 16
      Top = 16
      Width = 337
      Height = 177
      Caption = ' Dane kontrahenta '
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
  end
  inherited PanelButtons: TPanel
    Top = 204
    Width = 370
    inherited BitBtnOk: TBitBtn
      Left = 193
    end
    inherited BitBtnCancel: TBitBtn
      Left = 281
    end
  end
end
