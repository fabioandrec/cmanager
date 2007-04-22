object DBStatsForm: TDBStatsForm
  Left = 284
  Top = 346
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Informacje o pliku danych'
  ClientHeight = 260
  ClientWidth = 490
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object PanelButtons: TPanel
    Left = 0
    Top = 219
    Width = 490
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      490
      41)
    object BitBtnCancel: TBitBtn
      Left = 401
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = '&Zamknij'
      TabOrder = 0
      OnClick = BitBtnCancelClick
    end
  end
  object PanelConfig: TPanel
    Left = 0
    Top = 0
    Width = 490
    Height = 219
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      490
      219)
    object RichEdit: TRichEdit
      Left = 4
      Top = 5
      Width = 484
      Height = 213
      TabStop = False
      Anchors = [akLeft, akTop, akRight, akBottom]
      BevelKind = bkTile
      BorderStyle = bsNone
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 0
      WordWrap = False
    end
  end
end
