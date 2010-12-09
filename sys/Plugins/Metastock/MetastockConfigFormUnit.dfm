object MetastockConfigForm: TMetastockConfigForm
  Left = 334
  Top = 273
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Konfiguracja'
  ClientHeight = 292
  ClientWidth = 581
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
    Width = 581
    Height = 251
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      581
      251)
    object ListView: TListView
      Left = 12
      Top = 12
      Width = 555
      Height = 233
      Anchors = [akLeft, akTop, akRight]
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
  end
  object PanelButtons: TPanel
    Left = 0
    Top = 251
    Width = 581
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      581
      41)
    object BitBtnOk: TBitBtn
      Left = 404
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
      Left = 492
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Anuluj'
      TabOrder = 1
      OnClick = BitBtnCancelClick
    end
    object BitBtnAdd: TBitBtn
      Left = 12
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Dodaj'
      TabOrder = 2
      OnClick = BitBtnAddClick
    end
    object BitBtnEdit: TBitBtn
      Left = 98
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Edytuj'
      TabOrder = 3
      OnClick = BitBtnEditClick
    end
    object BitBtnDel: TBitBtn
      Left = 186
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Usu'#324
      TabOrder = 4
      OnClick = BitBtnDelClick
    end
    object BitBtnDefault: TBitBtn
      Left = 274
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Domy'#347'lne'
      TabOrder = 5
      OnClick = BitBtnDefaultClick
    end
  end
end
