inherited CReportDefForm: TCReportDefForm
  Left = 204
  Top = 33
  Caption = 'Definicja raportu'
  ClientHeight = 643
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Height = 602
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
      Height = 193
      Caption = ' Zapytanie tworz'#261'ce '
      TabOrder = 1
      object CButton1: TCButton
        Left = 424
        Top = 132
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
        Left = 198
        Top = 132
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
      object CButton4: TCButton
        Left = 422
        Top = 156
        Width = 147
        Height = 25
        Cursor = crHandPoint
        PicPosition = ppLeft
        PicOffset = 10
        TxtOffset = 15
        Framed = False
        Action = ActionParams
        Color = clBtnFace
      end
      object CButton5: TCButton
        Left = 198
        Top = 156
        Width = 217
        Height = 25
        Cursor = crHandPoint
        PicPosition = ppLeft
        PicOffset = 10
        TxtOffset = 15
        Framed = False
        Action = ActionAddParam
        Color = clBtnFace
      end
      object RicheditSql: TCRichedit
        Left = 24
        Top = 32
        Width = 513
        Height = 97
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
      Top = 384
      Width = 561
      Height = 217
      Caption = ' Dokument wynikowy  '
      TabOrder = 2
      object CButton2: TCButton
        Left = 424
        Top = 22
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
      object Label5: TLabel
        Left = 23
        Top = 28
        Width = 33
        Height = 13
        Alignment = taRightJustify
        Caption = 'Rodzaj'
      end
      object RicheditXslt: TCRichedit
        Left = 24
        Top = 64
        Width = 513
        Height = 133
        BevelKind = bkTile
        BorderStyle = bsNone
        PlainText = True
        ScrollBars = ssBoth
        TabOrder = 0
        WordWrap = False
      end
      object ComboBoxxslType: TComboBox
        Left = 64
        Top = 24
        Width = 353
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 1
        Text = 'Wygeneruj za pomoc'#261' domy'#347'lnego arkusza styli'
        OnChange = ComboBoxxslTypeChange
        Items.Strings = (
          'Wygeneruj za pomoc'#261' domy'#347'lnego arkusza styli'
          'Przedstaw w postaci dokumentu xml'
          'Wygeneruj za pomoc'#261' w'#322'asnego arkusza styli')
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 602
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
    object ActionParams: TAction
      Caption = 'Lista parametr'#243'w'
      ImageIndex = 4
      OnExecute = ActionParamsExecute
    end
    object ActionAddParam: TAction
      Caption = 'Dodaj parametr w wybranym miejscu'
      ImageIndex = 5
      OnExecute = ActionAddParamExecute
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
