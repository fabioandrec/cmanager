object CBaseFrame: TCBaseFrame
  Left = 0
  Top = 0
  Width = 443
  Height = 277
  Align = alClient
  AutoSize = True
  Color = clWindow
  ParentColor = False
  TabOrder = 0
  object ImageList: TPngImageList
    PngImages = <>
    Left = 16
    Top = 16
  end
  object ListPopupMenu: TPopupMenu
    Left = 72
    Top = 24
    object N1: TMenuItem
      Caption = '-'
    end
    object Ustawienialisty1: TMenuItem
      Caption = 'Ustawienia listy'
      OnClick = Ustawienialisty1Click
    end
  end
end
