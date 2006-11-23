inherited CFilterForm: TCFilterForm
  Left = 274
  Top = 180
  Caption = 'Filtr'
  ClientHeight = 402
  ClientWidth = 371
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 371
    Height = 361
    object GroupBox2: TGroupBox
      Left = 16
      Top = 16
      Width = 337
      Height = 177
      Caption = ' Dane podstawowe '
      TabOrder = 0
      object Label1: TLabel
        Left = 15
        Top = 32
        Width = 33
        Height = 13
        Alignment = taRightJustify
        Caption = 'Nazwa'
      end
      object Label2: TLabel
        Left = 27
        Top = 68
        Width = 21
        Height = 13
        Alignment = taRightJustify
        Caption = 'Opis'
      end
      object EditName: TEdit
        Left = 56
        Top = 28
        Width = 257
        Height = 21
        BevelKind = bkTile
        BorderStyle = bsNone
        MaxLength = 40
        TabOrder = 0
      end
      object RichEditDesc: TRichEdit
        Left = 56
        Top = 64
        Width = 257
        Height = 89
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 1
      end
    end
    object GroupBox1: TGroupBox
      Left = 16
      Top = 208
      Width = 337
      Height = 145
      Caption = ' Definicja zakresu '
      TabOrder = 1
      object Label14: TLabel
        Left = 63
        Top = 29
        Width = 73
        Height = 13
        Alignment = taRightJustify
        Caption = 'Wybrane konta'
      end
      object Label3: TLabel
        Left = 38
        Top = 65
        Width = 98
        Height = 13
        Alignment = taRightJustify
        Caption = 'Wybrani kontrahenci'
      end
      object Label4: TLabel
        Left = 46
        Top = 101
        Width = 90
        Height = 13
        Alignment = taRightJustify
        Caption = 'Wybrane kategorie'
      end
      object CStaticAccount: TCStatic
        Left = 144
        Top = 25
        Width = 169
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wszystkie konta>'
        Color = clWindow
        ParentColor = False
        TabOrder = 0
        TextOnEmpty = '<wszystkie konta>'
        OnGetDataId = CStaticAccountGetDataId
        HotTrack = True
      end
      object CStaticCashpoint: TCStatic
        Left = 144
        Top = 61
        Width = 169
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wszyscy kontrahenci>'
        Color = clWindow
        ParentColor = False
        TabOrder = 1
        TextOnEmpty = '<wszyscy kontrahenci>'
        OnGetDataId = CStaticCashpointGetDataId
        HotTrack = True
      end
      object CStaticProducts: TCStatic
        Left = 144
        Top = 97
        Width = 169
        Height = 21
        Cursor = crHandPoint
        AutoSize = False
        BevelKind = bkTile
        Caption = '<wszystkie kategorie>'
        Color = clWindow
        ParentColor = False
        TabOrder = 2
        TextOnEmpty = '<wszystkie kategorie>'
        OnGetDataId = CStaticProductsGetDataId
        HotTrack = True
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 361
    Width = 371
    inherited BitBtnOk: TBitBtn
      Left = 194
    end
    inherited BitBtnCancel: TBitBtn
      Left = 282
    end
  end
end
