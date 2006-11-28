inherited CConfigForm: TCConfigForm
  Left = 297
  Top = 170
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'ConfigForm'
  ClientHeight = 439
  ClientWidth = 593
  PixelsPerInch = 96
  TextHeight = 13
  object PanelConfig: TPanel
    Left = 0
    Top = 0
    Width = 593
    Height = 398
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
  end
  object PanelButtons: TPanel
    Left = 0
    Top = 398
    Width = 593
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      593
      41)
    object BitBtnOk: TBitBtn
      Left = 416
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
      Left = 504
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
