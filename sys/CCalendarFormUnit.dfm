object CCalendarForm: TCCalendarForm
  Left = 571
  Top = 347
  Anchors = [akLeft, akTop, akRight, akBottom]
  AutoSize = True
  BorderStyle = bsNone
  Caption = 'CCalendarForm'
  ClientHeight = 164
  ClientWidth = 171
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
    Left = 55
    Top = 140
    Width = 58
    Height = 24
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
  end
  object Bevel: TBevel
    Left = 0
    Top = 0
    Width = 171
    Height = 7
    Align = alTop
    Shape = bsSpacer
    Style = bsRaised
  end
  object MonthCalendar: TMonthCalendar
    Left = 0
    Top = 7
    Width = 171
    Height = 136
    Align = alTop
    AutoSize = True
    CalColors.BackColor = clBtnFace
    CalColors.MonthBackColor = clBtnFace
    CalColors.TrailingTextColor = clBtnFace
    Date = 38974.342490798610000000
    ShowToday = False
    ShowTodayCircle = False
    TabOrder = 0
    TabStop = True
    OnClick = MonthCalendarDblClick
    OnDblClick = MonthCalendarDblClick
  end
end
