inherited CDescpatternForm: TCDescpatternForm
  Left = 381
  Top = 246
  Caption = 'Szablon opisu'
  ClientHeight = 312
  ClientWidth = 540
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 540
    Height = 271
    object GroupBox1: TGroupBox
      Left = 16
      Top = 16
      Width = 505
      Height = 73
      Caption = ' Dla nast'#281'puj'#261'cych czynno'#347'ci '
      TabOrder = 0
      object Label5: TLabel
        Left = 18
        Top = 32
        Width = 46
        Height = 13
        Alignment = taRightJustify
        Caption = 'Czynno'#347#263
      end
      object Label7: TLabel
        Left = 278
        Top = 32
        Width = 18
        Height = 13
        Alignment = taRightJustify
        Caption = 'Typ'
      end
      object ComboBoxOperation: TComboBox
        Left = 72
        Top = 28
        Width = 193
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 0
        OnChange = ComboBoxOperationChange
        Items.Strings = (
          'Operacje wykonane'
          'Listy operacji wykonanych'
          'Operacje zaplanowane'
          'Elementy listy operacji'
          'Kursy walut'
          'Wyci'#261'gi bankowe'
          'Elementy wyci'#261'g'#243'w'
          'Notowania instrument'#243'w')
      end
      object ComboBoxType: TComboBox
        Left = 304
        Top = 28
        Width = 177
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 1
        Text = 'Aktywne'
        OnChange = ComboBoxTypeChange
        Items.Strings = (
          'Aktywne'
          'Wy'#322#261'czone')
      end
    end
    object GroupBox2: TGroupBox
      Left = 16
      Top = 106
      Width = 505
      Height = 159
      Caption = ' Definicja '
      TabOrder = 1
      object CButton1: TCButton
        Left = 14
        Top = 124
        Width = 217
        Height = 25
        Cursor = crHandPoint
        PicPosition = ppLeft
        PicOffset = 10
        TxtOffset = 15
        Framed = False
        Action = ActionAdd
        Color = clBtnFace
      end
      object RichEditDesc: TCRichedit
        Left = 24
        Top = 28
        Width = 457
        Height = 89
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 0
        OnChange = RichEditDescChange
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 271
    Width = 540
    inherited BitBtnOk: TBitBtn
      Left = 363
    end
    inherited BitBtnCancel: TBitBtn
      Left = 451
    end
  end
  object ActionManager: TActionManager
    Images = CImageLists.TemplateImageList16x16
    Left = 192
    Top = 162
    StyleName = 'XP Style'
    object ActionAdd: TAction
      Caption = 'Dodaj mnemonik w wybranym miejscu'
      ImageIndex = 0
      OnExecute = ActionAddExecute
    end
  end
end
