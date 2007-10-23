object MetastockEditForm: TMetastockEditForm
  Left = 408
  Top = 151
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #377'r'#243'd'#322'o notowa'#324
  ClientHeight = 459
  ClientWidth = 416
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
    Width = 416
    Height = 418
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object GroupBox1: TGroupBox
      Left = 16
      Top = 16
      Width = 385
      Height = 225
      Caption = ' Dane podstawowe '
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
    object GroupBox2: TGroupBox
      Left = 16
      Top = 256
      Width = 385
      Height = 153
      Caption = ' Format pliku '
      TabOrder = 1
      object Label5: TLabel
        Left = 26
        Top = 28
        Width = 46
        Height = 13
        Alignment = taRightJustify
        Caption = 'Separator'
      end
      object Label8: TLabel
        Left = 22
        Top = 68
        Width = 50
        Height = 13
        Alignment = taRightJustify
        Caption = 'Format dat'
      end
      object Label7: TLabel
        Left = 29
        Top = 108
        Width = 43
        Height = 13
        Alignment = taRightJustify
        Caption = 'Dane dla'
      end
      object Label9: TLabel
        Left = 226
        Top = 68
        Width = 28
        Height = 13
        Alignment = taRightJustify
        Caption = 'czasu'
      end
      object Label10: TLabel
        Left = 214
        Top = 108
        Width = 40
        Height = 13
        Alignment = taRightJustify
        Caption = 'kolumna'
      end
      object Label11: TLabel
        Left = 236
        Top = 28
        Width = 18
        Height = 13
        Alignment = taRightJustify
        Caption = 'u'#380'yj'
      end
      object EditSep: TEdit
        Left = 264
        Top = 24
        Width = 97
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 40
        TabOrder = 1
        OnChange = EditSepChange
      end
      object ComboBoxSepType: TComboBox
        Left = 80
        Top = 24
        Width = 121
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 0
        Text = 'p'#243'l'
        OnChange = ComboBoxSepTypeChange
        Items.Strings = (
          'p'#243'l'
          'dziesi'#281'tny'
          'dat'
          'czasu')
      end
      object ComboBoxDate: TComboBox
        Left = 80
        Top = 64
        Width = 121
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 2
        TabOrder = 2
        Text = 'RMD'
        Items.Strings = (
          'MDR'
          'DMR'
          'RMD'
          'MRD'
          'DRM'
          'RDM')
      end
      object ComboBoxTime: TComboBox
        Left = 264
        Top = 64
        Width = 97
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 3
        Text = 'HN'
        Items.Strings = (
          'HN'
          'NH'
          'HNS'
          'NHS'
          'SHN'
          'HSN'
          'NSH'
          'SNH')
      end
      object ComboBoxField: TComboBox
        Left = 80
        Top = 104
        Width = 121
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 4
        Text = 'Identyfikator'
        OnChange = ComboBoxFieldChange
        Items.Strings = (
          'Identyfikator'
          'Data i czas'
          'Warto'#347#263)
      end
      object ComboBoxColumn: TComboBox
        Left = 264
        Top = 104
        Width = 97
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 5
        Text = '1'
        OnChange = ComboBoxColumnChange
        Items.Strings = (
          '1'
          '2'
          '3'
          '4'
          '5'
          '6'
          '7'
          '8'
          '9')
      end
    end
  end
  object PanelButtons: TPanel
    Left = 0
    Top = 418
    Width = 416
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      416
      41)
    object BitBtnOk: TBitBtn
      Left = 239
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
      Left = 327
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
