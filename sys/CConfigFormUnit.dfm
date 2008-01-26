inherited CConfigForm: TCConfigForm
  Left = 298
  Top = 171
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'ConfigForm'
  ClientHeight = 437
  ClientWidth = 591
  PixelsPerInch = 96
  TextHeight = 13
  object PanelConfig: TPanel
    Left = 0
    Top = 0
    Width = 591
    Height = 396
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
  end
  object PanelButtons: TPanel
    Left = 0
    Top = 396
    Width = 591
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      591
      41)
    object BitBtnOk: TBitBtn
      Left = 414
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
      Left = 502
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
