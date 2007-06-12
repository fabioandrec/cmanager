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
    object Wywietljakoraport1: TMenuItem
      Caption = 'Wy'#347'wietl jako raport'
      OnClick = Wywietljakoraport1Click
    end
    object Eksportuj1: TMenuItem
      Caption = 'Zapisz jako'
      object JakoplikTXT1: TMenuItem
        Caption = 'prosty tekst'
        OnClick = JakoplikTXT1Click
      end
      object JakoplikRTF1: TMenuItem
        Caption = 'tekst sformatowany'
        OnClick = JakoplikRTF1Click
      end
      object JakoplikHTML1: TMenuItem
        Caption = 'strona web'
        OnClick = JakoplikHTML1Click
      end
      object plikExcel1: TMenuItem
        Caption = 'plik Excel'
        OnClick = plikExcel1Click
      end
    end
  end
  object ExportSaveDialog: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 72
    Top = 120
  end
end
