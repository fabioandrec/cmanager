object MetastockConfigForm: TMetastockConfigForm
  Left = 384
  Top = 188
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Konfiguracja'
  ClientHeight = 326
  ClientWidth = 275
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
    Width = 275
    Height = 285
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object ListView: TListView
      Left = 12
      Top = 12
      Width = 249
      Height = 233
      BevelKind = bkTile
      BorderStyle = bsNone
      Columns = <
        item
          AutoSize = True
          Caption = 'Nazwa'
        end>
      ColumnClick = False
      HideSelection = False
      ReadOnly = True
      RowSelect = True
      ShowColumnHeaders = False
      TabOrder = 0
      ViewStyle = vsReport
      OnSelectItem = ListViewSelectItem
    end
    object BitBtnAdd: TBitBtn
      Left = 12
      Top = 256
      Width = 75
      Height = 25
      Caption = 'Dodaj'
      TabOrder = 1
    end
    object BitBtnEdit: TBitBtn
      Left = 98
      Top = 256
      Width = 75
      Height = 25
      Caption = 'Edytuj'
      TabOrder = 2
    end
    object BitBtnDel: TBitBtn
      Left = 186
      Top = 256
      Width = 75
      Height = 25
      Caption = 'Usu'#324
      TabOrder = 3
      OnClick = BitBtnDelClick
    end
  end
  object PanelButtons: TPanel
    Left = 0
    Top = 285
    Width = 275
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      275
      41)
    object BitBtnOk: TBitBtn
      Left = 98
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
      Left = 186
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
