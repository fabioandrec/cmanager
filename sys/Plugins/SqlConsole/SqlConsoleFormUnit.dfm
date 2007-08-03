object SqlConsoleForm: TSqlConsoleForm
  Left = 277
  Top = 207
  Width = 870
  Height = 640
  Caption = 'Kosola Sql'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter: TSplitter
    Left = 0
    Top = 193
    Width = 862
    Height = 2
    Cursor = crVSplit
    Align = alTop
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 862
    Height = 193
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object RichEditCommand: TRichEdit
      Left = 0
      Top = 41
      Width = 862
      Height = 152
      Align = alClient
      BevelKind = bkTile
      BorderStyle = bsNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 0
      OnKeyDown = RichEditCommandKeyDown
    end
    object Panel3: TPanel
      Left = 0
      Top = 0
      Width = 862
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 195
    Width = 862
    Height = 418
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object RichEditResult: TRichEdit
      Left = 0
      Top = 0
      Width = 862
      Height = 418
      Align = alClient
      BevelKind = bkTile
      BorderStyle = bsNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 0
      WordWrap = False
    end
  end
end
