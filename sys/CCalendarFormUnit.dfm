object CCalendarForm: TCCalendarForm
  Left = 571
  Top = 347
  Anchors = [akLeft, akTop, akRight, akBottom]
  AutoSize = True
  BorderStyle = bsNone
  Caption = 'CCalendarForm'
  ClientHeight = 168
  ClientWidth = 171
  Color = clWindow
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
  object Bevel: TBevel
    Left = 0
    Top = 0
    Width = 171
    Height = 3
    Align = alTop
    Shape = bsTopLine
    Style = bsRaised
  end
  object CButton: TCButton
    Left = 55
    Top = 144
    Width = 58
    Height = 24
    Cursor = crHandPoint
    PicPosition = ppLeft
    PicOffset = 10
    TxtOffset = 15
    Framed = False
    Caption = 'Dzisiaj'
    OnClick = CButtonClick
  end
  object MonthCalendar: TMonthCalendar
    Left = 0
    Top = 3
    Width = 171
    Height = 136
    Align = alTop
    AutoSize = True
    CalColors.TitleBackColor = clBtnShadow
    CalColors.MonthBackColor = clWindow
    CalColors.TrailingTextColor = clBtnFace
    Date = 38974.605777500000000000
    ShowToday = False
    ShowTodayCircle = False
    TabOrder = 0
    TabStop = True
    OnClick = MonthCalendarDblClick
    OnDblClick = MonthCalendarDblClick
  end
end
