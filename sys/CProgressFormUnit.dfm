object CProgressForm: TCProgressForm
  Left = 201
  Top = 336
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'CProgressForm'
  ClientHeight = 212
  ClientWidth = 499
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PanelButtons: TPanel
    Left = 0
    Top = 171
    Width = 499
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      499
      41)
    object BitBtnOk: TBitBtn
      Left = 322
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Wy&konaj'
      Default = True
      TabOrder = 0
      OnClick = BitBtnOkClick
    end
    object BitBtnCancel: TBitBtn
      Left = 410
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Anuluj'
      TabOrder = 1
      OnClick = BitBtnCancelClick
    end
  end
  object PanelConfig: TPanel
    Left = 0
    Top = 0
    Width = 499
    Height = 171
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object StaticText: TStaticText
      Left = 16
      Top = 48
      Width = 329
      Height = 13
      AutoSize = False
      BorderStyle = sbsSunken
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ShowAccelChar = False
      TabOrder = 0
    end
    object ProgressBar: TProgressBar
      Left = 16
      Top = 80
      Width = 329
      Height = 13
      Smooth = True
      TabOrder = 1
    end
  end
end
