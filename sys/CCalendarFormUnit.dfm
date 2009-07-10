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
  object Bevel: TBevel
    Left = 0
    Top = 0
    Width = 169
    Height = 7
    Align = alTop
    Shape = bsSpacer
    Style = bsRaised
  end
  object CLabelToday: TCLabel
    Left = 120
    Top = 172
    Width = 38
    Height = 13
    Alignment = taRightJustify
    Caption = 'Dzisiaj'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = CLabelTodayClick
    OnMouseDown = CLabelTodayMouseDown
    Hottrack = True
  end
  object CLabelNow: TCLabel
    Left = 8
    Top = 172
    Width = 27
    Height = 13
    Caption = '22:22'
    OnClick = CLabelNowClick
    Hottrack = True
  end
  object MonthCalendar: TMonthCalendar
    Left = 0
    Top = 7
    Width = 169
    Height = 136
    Align = alTop
    AutoSize = True
    CalColors.BackColor = clBtnFace
    CalColors.MonthBackColor = clBtnFace
    CalColors.TrailingTextColor = clBtnFace
    Date = 38974.310786145830000000
    ShowToday = False
    ShowTodayCircle = False
    TabOrder = 0
    TabStop = True
    OnClick = MonthCalendarDblClick
    OnDblClick = MonthCalendarDblClick
  end
  object TrackBarTime: TTrackBar
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
    OnChange = TrackBarTimeChange
  end
end
