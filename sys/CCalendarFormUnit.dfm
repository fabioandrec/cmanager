object CCalendarForm: TCCalendarForm
  Left = 424
  Top = 215
  Anchors = [akLeft, akTop, akRight, akBottom]
  BorderStyle = bsNone
  Caption = 'CCalendarForm'
  ClientHeight = 194
  ClientWidth = 169
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object CButton: TCButton
    Left = 103
    Top = 173
    Width = 58
    Height = 18
    Cursor = crHandPoint
    PicPosition = ppLeft
    PicOffset = 10
    TxtOffset = 15
    Framed = False
    Caption = 'Dzisiaj'
    OnClick = CButtonClick
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    OnMouseDown = CButtonMouseDown
  end
  object Bevel: TBevel
    Left = 0
    Top = 0
    Width = 169
    Height = 7
    Align = alTop
    Shape = bsSpacer
    Style = bsRaised
  end
  object CButtonChoose: TCButton
    Left = 1
    Top = 173
    Width = 56
    Height = 18
    Cursor = crHandPoint
    PicPosition = ppLeft
    PicOffset = 10
    TxtOffset = 15
    Framed = False
    Caption = '20:20'
    OnClick = CButtonChooseClick
    Color = clBtnFace
  end
  object MonthCalendar: TMonthCalendar
    Left = 0
    Top = 7
    Width = 169
    Height = 146
    Align = alTop
    CalColors.BackColor = clBtnFace
    CalColors.MonthBackColor = clBtnFace
    CalColors.TrailingTextColor = clBtnFace
    Date = 38974.628708078700000000
    ShowToday = False
    ShowTodayCircle = False
    TabOrder = 0
    TabStop = True
    OnClick = MonthCalendarDblClick
    OnDblClick = MonthCalendarDblClick
  end
  object TrackBar1: TTrackBar
    Left = 12
    Top = 157
    Width = 147
    Height = 10
    Max = 1439
    TabOrder = 1
    TabStop = False
    ThumbLength = 7
    TickMarks = tmTopLeft
    TickStyle = tsNone
    OnChange = TrackBar1Change
  end
end
