inherited CAboutForm: TCAboutForm
  Left = 444
  Top = 213
  Caption = 'O programie'
  ClientHeight = 333
  ClientWidth = 377
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 377
    Height = 292
    object Image: TImage
      Left = 16
      Top = 16
      Width = 32
      Height = 32
      AutoSize = True
    end
    object Label1: TLabel
      Left = 48
      Top = 26
      Width = 50
      Height = 13
      Caption = 'Manager'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 281
      Top = 26
      Width = 81
      Height = 13
      Alignment = taRightJustify
      Caption = 'wersja 2.2.2.2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object CButtonMail: TCButton
      Left = 200
      Top = 40
      Width = 162
      Height = 17
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Caption = 'levin_a@users.sourceforge.net'
      OnClick = CButtonMailClick
      Color = clBtnFace
    end
    object CButton1: TCButton
      Left = 192
      Top = 56
      Width = 177
      Height = 17
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Caption = 'http://cmanager.sourceforge.net'
      OnClick = CButton1Click
      Color = clBtnFace
    end
    object RichEditContrib: TRichEdit
      Left = 16
      Top = 80
      Width = 346
      Height = 203
      TabStop = False
      Anchors = [akLeft, akTop, akRight, akBottom]
      BevelInner = bvNone
      BevelKind = bkTile
      BorderStyle = bsNone
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Lines.Strings = (
        'RichEditContrib')
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 0
      WordWrap = False
    end
  end
  inherited PanelButtons: TPanel
    Top = 292
    Width = 377
    inherited BitBtnOk: TBitBtn
      Left = 200
    end
    inherited BitBtnCancel: TBitBtn
      Left = 288
    end
  end
end
