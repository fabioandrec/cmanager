inherited CDescpatternForm: TCDescpatternForm
  Left = 381
  Top = 246
  Caption = 'Szablon opisu'
  ClientHeight = 312
  ClientWidth = 540
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 540
    Height = 271
    object GroupBox1: TGroupBox
      Left = 16
      Top = 16
      Width = 505
      Height = 73
      Caption = ' Dla nast'#281'puj'#261'cych czynno'#347'ci '
      TabOrder = 0
      object Label5: TLabel
        Left = 18
        Top = 32
        Width = 46
        Height = 13
        Alignment = taRightJustify
        Caption = 'Czynno'#347#263
      end
      object Label7: TLabel
        Left = 278
        Top = 32
        Width = 18
        Height = 13
        Alignment = taRightJustify
        Caption = 'Typ'
      end
      object ComboBoxOperation: TComboBox
        Left = 72
        Top = 28
        Width = 193
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 0
        Text = 'Operacje wykonane'
        OnChange = ComboBoxOperationChange
        Items.Strings = (
          'Operacje wykonane'
          'Listy operacji wykonanych'
          'Operacje zaplanowane')
      end
      object ComboBoxType: TComboBox
        Left = 304
        Top = 28
        Width = 177
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        ItemIndex = 0
        TabOrder = 1
        Text = 'Aktywne'
        OnChange = ComboBoxTypeChange
        Items.Strings = (
          'Aktywne'
          'Wy'#322#261'czone')
      end
    end
    object GroupBox2: TGroupBox
      Left = 16
      Top = 106
      Width = 505
      Height = 159
      Caption = ' Definicja '
      TabOrder = 1
      object CButton1: TCButton
        Left = 268
        Top = 124
        Width = 217
        Height = 25
        Cursor = crHandPoint
        PicPosition = ppLeft
        PicOffset = 10
        TxtOffset = 15
        Framed = False
        Action = ActionAdd
        Color = clBtnFace
      end
      object RichEditDesc: TRichEdit
        Left = 24
        Top = 28
        Width = 457
        Height = 89
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 0
        OnChange = RichEditDescChange
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 271
    Width = 540
    inherited BitBtnOk: TBitBtn
      Left = 363
    end
    inherited BitBtnCancel: TBitBtn
      Left = 451
    end
  end
  object PngImageList: TPngImageList
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B0F00
          000B0F0192F903A50000000774494D45000000000000000973942E000002E649
          44415478DA85945D48936114C7FFEF9CB36DE29A98AE9CAE975C190599959216
          4479A309E65013E647E02E1ADE54A45D68202CEA22C9AB8617952895B5329142
          74681795159298CDAF32BFF17B33E736F7E1F4E9F19D9812E5E13D9CC3CB39BF
          E7FD3FEF791EA64825972C7956B0D902FC79B03ABC8E87C6192FB631A6382382
          0802C53425F459E17CD9E58569C8AE2ED3377F56A9545E83C180848404272D32
          FB0A37014AF20F905B9557811527887312C43182AA07DDA86A72A2EE4D2B7272
          72505E5E01B5BAE0754F4F4F1EED59A4BEBA15705F0BE271005E02B23481C6A6
          39C8A28F43BA4BBA5E26C2D808BFEB7689B642111A302611F397A9C46E2AD1CA
          94E44511DDBD4C80170946944C01BD189995A0CD5803FBAFF175009F2AA38BBA
          073989D3536E987EDA55F59F2C4D4CF14505C9C83E0469582C84122586DA7568
          FECA22BF5003A5328C6B379B3DE8EBE844A2F23D95EA4255F5182A0D93455F06
          EC35CCB5ACE8DAB83329D942118F7EA90266DB02D7949A7A04A1A1415C3E3C6C
          414B43030ACED33D5AA5809A69E89F4F97760EDA1F3185858551F1F107070EB3
          760C7F1F80AA20F7AF5F35316143FBDB16A49DE8F0011E5BA037CCF9003A9D2E
          42A1908EFD0B60B57A71F7CE47C4CA9F20ED6C2095E046D5D345E85FCCFB005A
          AD56CEB2F2F1A493720A3081EC8C04CBB2686D6D8546A341D9CD524488850812
          BBC1865B39C0E8D008F42F177C00BA88382626E6923AF558122B9BBFB077BF14
          21C112F4F79A9098180763631D4E1D0D4675BD0CB58D915027F743E2FF8D026C
          1B803517659D0EC9CB4A67F5E92A05B7D3DC60D1C850CD7D8302E4DE8843679F
          14E5573E402230415FE7D80070037539459695746EF7B3F4B43DDC467190B5E8
          75C1665B41573F1D77B20C566681F19D07FA57CE2D005C5785670608F90691C8
          CF37A9846C8ABE9CACE74B0E3FB474DA4ADB7FD8FE003212438246675DB1E645
          EFBE554204FF3B813C86C1CC82676AC9BDDAC66C7ABF96EFE0069FD66C778CA9
          ADDD01B6DFC64365225D20F0A80000000049454E44AE426082}
        Name = 'PngImage0'
      end>
    Left = 32
    Top = 234
    Bitmap = {}
  end
  object ActionManager: TActionManager
    Images = PngImageList
    Left = 192
    Top = 162
    StyleName = 'XP Style'
    object ActionAdd: TAction
      Caption = 'Dodaj mnemonik w wybranym miejscu'
      ImageIndex = 0
      OnExecute = ActionAddExecute
    end
  end
end
