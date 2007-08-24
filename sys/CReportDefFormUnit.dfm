inherited CReportDefForm: TCReportDefForm
  Left = 318
  Top = 55
  Caption = 'Definicja raportu'
  ClientHeight = 626
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Height = 585
    object GroupBox1: TGroupBox
      Left = 16
      Top = 16
      Width = 561
      Height = 145
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
      Height = 153
      Caption = ' Zapytanie tworz'#261'ce '
      TabOrder = 1
      object CButton1: TCButton
        Left = 432
        Top = 116
        Width = 113
        Height = 25
        Cursor = crHandPoint
        PicPosition = ppLeft
        PicOffset = 10
        TxtOffset = 15
        Framed = False
        Action = ActionSql
        Color = clBtnFace
      end
      object CButton3: TCButton
        Left = 206
        Top = 116
        Width = 217
        Height = 25
        Cursor = crHandPoint
        PicPosition = ppLeft
        PicOffset = 10
        TxtOffset = 15
        Framed = False
        Action = ActionTemp
        Color = clBtnFace
      end
      object RicheditSql: TCRichedit
        Left = 24
        Top = 32
        Width = 513
        Height = 81
        BevelKind = bkTile
        BorderStyle = bsNone
        PlainText = True
        ScrollBars = ssBoth
        TabOrder = 0
        WordWrap = False
      end
    end
    object GroupBox3: TGroupBox
      Left = 16
      Top = 344
      Width = 561
      Height = 233
      Caption = ' Arkusz styli '
      TabOrder = 2
      object CButton2: TCButton
        Left = 432
        Top = 197
        Width = 113
        Height = 25
        Cursor = crHandPoint
        PicPosition = ppLeft
        PicOffset = 10
        TxtOffset = 15
        Framed = False
        Action = ActionXsl
        Color = clBtnFace
      end
      object RicheditXslt: TCRichedit
        Left = 24
        Top = 32
        Width = 513
        Height = 161
        BevelKind = bkTile
        BorderStyle = bsNone
        PlainText = True
        ScrollBars = ssBoth
        TabOrder = 0
        WordWrap = False
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 585
  end
  object ActionManager: TActionManager
    Images = CImageLists.TemplateImageList16x16
    Left = 32
    Top = 114
    StyleName = 'XP Style'
    object ActionSql: TAction
      Caption = 'Wczytaj z pliku'
      ImageIndex = 3
      OnExecute = ActionSqlExecute
    end
    object ActionXsl: TAction
      Caption = 'Wczytaj z pliku'
      ImageIndex = 3
      OnExecute = ActionXslExecute
    end
    object ActionTemp: TAction
      Caption = 'Dodaj mnemonik w wybranym miejscu'
      ImageIndex = 0
      OnExecute = ActionTempExecute
    end
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'xml'
    Filter = 'Pliki XML|*.xml|Wszystkie pliki|*.*'
    FilterIndex = 0
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 74
    Top = 112
  end
end
