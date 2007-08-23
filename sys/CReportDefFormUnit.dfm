inherited CReportDefForm: TCReportDefForm
  Left = 174
  Top = 55
  Caption = 'Definicja raportu'
  ClientHeight = 365
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Height = 324
    object GroupBox1: TGroupBox
      Left = 16
      Top = 16
      Width = 561
      Height = 145
      Caption = 'Dane podstawowe'
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
        Width = 481
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 40
        TabOrder = 0
      end
      object RichEditDesc: TCRichedit
        Left = 56
        Top = 64
        Width = 481
        Height = 57
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 1
      end
    end
    object GroupBox2: TGroupBox
      Left = 16
      Top = 176
      Width = 561
      Height = 137
      Caption = 'Parametry raportu i zapytanie tworz'#261'ce'
      TabOrder = 1
      object Label3: TLabel
        Left = 33
        Top = 36
        Width = 15
        Height = 13
        Alignment = taRightJustify
        Caption = 'Sql'
      end
      object RicheditSql: TCRichedit
        Left = 56
        Top = 32
        Width = 481
        Height = 81
        BevelKind = bkTile
        BorderStyle = bsNone
        PlainText = True
        TabOrder = 0
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 324
  end
end
