inherited CConfigForm: TCConfigForm
  Left = 296
  Top = 169
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'ConfigForm'
  ClientHeight = 441
  ClientWidth = 595
  PixelsPerInch = 96
  TextHeight = 13
  object PanelConfig: TPanel
    Left = 0
    Top = 0
    Width = 595
    Height = 400
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
  end
  object PanelButtons: TPanel
    Left = 0
    Top = 400
    Width = 595
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      595
      41)
    object BitBtnOk: TBitBtn
      Left = 418
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
      Left = 506
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
