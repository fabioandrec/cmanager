inherited CReportForm: TCReportForm
  Left = 238
  Top = 193
  Width = 822
  Height = 643
  BorderIcons = [biSystemMenu, biMaximize]
  BorderStyle = bsSizeable
  Caption = 'CReportForm'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TCPanel
    Width = 806
    Height = 566
    DesignSize = (
      806
      566)
    object PanelReport: TCPanel
      Left = 4
      Top = 4
      Width = 798
      Height = 558
      Anchors = [akLeft, akTop, akRight, akBottom]
      BevelOuter = bvLowered
      TabOrder = 0
    end
  end
  inherited PanelButtons: TCPanel
    Top = 566
    Width = 806
    DesignSize = (
      806
      41)
    object CButton1: TCButton [0]
      Left = 8
      Top = 8
      Width = 73
      Height = 25
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Action = Action1
      Color = clBtnFace
    end
    object CButton2: TCButton [1]
      Left = 72
      Top = 8
      Width = 73
      Height = 25
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Action = Action2
      Color = clBtnFace
    end
    object CButton3: TCButton [2]
      Left = 148
      Top = 8
      Width = 67
      Height = 25
      Cursor = crHandPoint
      PicPosition = ppLeft
      PicOffset = 10
      TxtOffset = 15
      Framed = False
      Action = Action3
      Color = clBtnFace
    end
    inherited BitBtnOk: TBitBtn
      Left = 633
    end
    inherited BitBtnCancel: TBitBtn
      Left = 721
    end
  end
  object ActionList: TActionList
    Images = CImageLists.ActionImageList
    Left = 376
    Top = 576
    object Action1: TAction
      Caption = 'Drukuj'
      ImageIndex = 0
      OnExecute = Action1Execute
    end
    object Action2: TAction
      Caption = 'Podgl'#261'd'
      ImageIndex = 1
      OnExecute = Action2Execute
    end
    object Action3: TAction
      Caption = 'Zapisz'
      ImageIndex = 2
      OnExecute = Action3Execute
    end
  end
  object SaveDialog: TSaveDialog
    FilterIndex = 0
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Title = 'Plik danych'
    Left = 306
    Top = 578
  end
end