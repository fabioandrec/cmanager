object MetastockEditForm: TMetastockEditForm
  Left = 284
  Top = 250
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #377'r'#243'd'#322'o notowa'#324
  ClientHeight = 259
  ClientWidth = 393
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object PanelConfig: TPanel
    Left = 0
    Top = 0
    Width = 393
    Height = 218
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object Label1: TLabel
      Left = 38
      Top = 28
      Width = 66
      Height = 13
      Alignment = taRightJustify
      Caption = 'Nazwa '#378'r'#243'd'#322'a'
    end
    object Label2: TLabel
      Left = 28
      Top = 68
      Width = 76
      Height = 13
      Alignment = taRightJustify
      Caption = #377'r'#243'd'#322'o notowa'#324
    end
    object Label3: TLabel
      Left = 24
      Top = 108
      Width = 80
      Height = 13
      Alignment = taRightJustify
      Caption = 'Miejsce notowa'#324
    end
    object Label4: TLabel
      Left = 120
      Top = 148
      Width = 88
      Height = 13
      Alignment = taRightJustify
      Caption = 'Symbol ISO waluty'
    end
    object Label6: TLabel
      Left = 110
      Top = 188
      Width = 98
      Height = 13
      Alignment = taRightJustify
      Caption = 'Rodzaj instrument'#243'w'
    end
    object EditName: TEdit
      Left = 112
      Top = 24
      Width = 249
      Height = 21
      BevelKind = bkTile
      BorderStyle = bsNone
      MaxLength = 40
      TabOrder = 0
    end
    object EditUrl: TEdit
      Left = 112
      Top = 64
      Width = 249
      Height = 21
      BevelKind = bkTile
      BorderStyle = bsNone
      MaxLength = 40
      TabOrder = 1
    end
    object EditCashpoint: TEdit
      Left = 112
      Top = 104
      Width = 249
      Height = 21
      BevelKind = bkTile
      BorderStyle = bsNone
      MaxLength = 40
      TabOrder = 2
    end
    object EditIso: TEdit
      Left = 216
      Top = 144
      Width = 145
      Height = 21
      BevelKind = bkTile
      BorderStyle = bsNone
      MaxLength = 40
      TabOrder = 3
    end
    object ComboBoxType: TComboBox
      Left = 216
      Top = 184
      Width = 145
      Height = 21
      BevelInner = bvNone
      BevelKind = bkTile
      Style = csDropDownList
      ItemHeight = 13
      ItemIndex = 0
      TabOrder = 4
      Text = 'Indeksy'
      Items.Strings = (
        'Indeksy'
        'Akcje'
        'Obligacje'
        'Fundusze inwestycyjne')
    end
  end
  object PanelButtons: TPanel
    Left = 0
    Top = 218
    Width = 393
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      393
      41)
    object BitBtnOk: TBitBtn
      Left = 216
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Default = True
      TabOrder = 0
      OnClick = BitBtnOkClick
    end
    object BitBtnCancel: TBitBtn
      Left = 304
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Anuluj'
      TabOrder = 1
      OnClick = BitBtnCancelClick
    end
  end
end
