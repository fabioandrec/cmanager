inherited CListPreferencesForm: TCListPreferencesForm
  Caption = 'Ustawienia listy'
  ClientHeight = 378
  ClientWidth = 428
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 428
    Height = 337
    object GroupBox2: TGroupBox
      Left = 16
      Top = 16
      Width = 393
      Height = 313
      Caption = ' Ustawienia czcionek i kolor'#243'w '
      TabOrder = 0
      object CButton5: TCButton
        Left = 232
        Top = 76
        Width = 137
        Height = 25
        Cursor = crHandPoint
        PicPosition = ppLeft
        PicOffset = 10
        TxtOffset = 15
        Framed = False
        Action = Action3
        Color = clBtnFace
      end
      object CButton6: TCButton
        Left = 232
        Top = 108
        Width = 145
        Height = 25
        Cursor = crHandPoint
        PicPosition = ppLeft
        PicOffset = 10
        TxtOffset = 15
        Framed = False
        Action = Action4
        Color = clBtnFace
      end
      object Label1: TLabel
        Left = 264
        Top = 253
        Width = 50
        Height = 13
        Caption = 'Wysoko'#347#263
      end
      object CButton1: TCButton
        Left = 232
        Top = 172
        Width = 150
        Height = 25
        Cursor = crHandPoint
        PicPosition = ppLeft
        PicOffset = 10
        TxtOffset = 15
        Framed = False
        Action = Action1
        Color = clBtnFace
      end
      object CButton2: TCButton
        Left = 232
        Top = 204
        Width = 147
        Height = 25
        Cursor = crHandPoint
        PicPosition = ppLeft
        PicOffset = 10
        TxtOffset = 15
        Framed = False
        Action = Action2
        Color = clBtnFace
      end
      object CButton3: TCButton
        Left = 232
        Top = 140
        Width = 145
        Height = 25
        Cursor = crHandPoint
        PicPosition = ppLeft
        PicOffset = 10
        TxtOffset = 15
        Framed = False
        Action = Action5
        Color = clBtnFace
      end
      object PanelExample: TPanel
        Left = 24
        Top = 68
        Width = 201
        Height = 221
        BevelOuter = bvLowered
        Color = clWindow
        TabOrder = 0
        object PanelRow: TPanel
          Left = 1
          Top = 1
          Width = 200
          Height = 56
          BevelOuter = bvNone
          Caption = 'Przyk'#322'adowy widok elementu'
          Color = clWindow
          TabOrder = 0
        end
        object PanelActive: TPanel
          Left = 1
          Top = 97
          Width = 200
          Height = 56
          BevelOuter = bvNone
          Caption = 'Przyk'#322'adowy aktywny element'
          Color = clWindow
          TabOrder = 1
        end
      end
      object ComboBoxType: TComboBox
        Left = 24
        Top = 28
        Width = 345
        Height = 21
        BevelInner = bvNone
        BevelKind = bkTile
        Style = csDropDownList
        ItemHeight = 13
        TabOrder = 1
        OnChange = ComboBoxTypeChange
      end
      object TrackBar: TTrackBar
        Left = 247
        Top = 240
        Width = 10
        Height = 38
        Max = 60
        Min = 8
        Orientation = trVertical
        Position = 24
        TabOrder = 2
        ThumbLength = 8
        TickStyle = tsNone
        OnChange = TrackBarChange
      end
    end
  end
  inherited PanelButtons: TPanel
    Top = 337
    Width = 428
    inherited BitBtnOk: TBitBtn
      Left = 251
    end
    inherited BitBtnCancel: TBitBtn
      Left = 339
    end
  end
  object FontImageList: TPngImageList
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          61000002554944415478DA8D925F68926114C61F7573324B67E6906A58A44E6D
          C558575137651752561B2485B08B2017181415514454B01841417551EBAF302A
          C26249231ADDAC15C4AC6D6C4134FF4412284A6959DF9A857EDA793F32A7D9E8
          B9F85EBEF3BEEFEF3CE7BC4784DFF2FBFD3F0B8542165524128924C96472DC6E
          B76FA7DF44D91EFB68349A8E4422F100FF50369B05ED6394E470383652E85B25
          A09D0EF8E602442211188D4678BDDE11A7D3B995C2C9FF065069080402D06AB5
          50A954F0783C7E97CBD5C1CAF90388C7E3BE5C2E47D9726597A5D25AF43F1AC2
          92C679A8ADA981582C66E761B3D9F68442A16B650E58A64AC5E21FB1F7F845DC
          BD74820012F03C0F994C068BC5E20E0683BD7302F87C1E376E0F6070F815AE9C
          39086DE3C2E2AB540730FA6CBD09BE477D5D1D0E9FEEC5B17D9D58BDAA59884B
          2492EA00D6EDD98D1B7E3181F5EBDAD0B9BF1B3BB758B1C9BA06797255B504D6
          C44C264335E6298318A3135388C63F61855187F3D7EFA1B5A519BB9D9B05FB72
          B91C66B3D91D0E874B80582CE64BA53E5386021DA8C7FD81212C5FB65870F2E4
          E94B4C7FCFE0E4A15D823BB57AC1DF00E680E3386168C65E0760322C854A395F
          B8F06C6412576F3DC4E59E0368685040A150C064329500341CED34EBBE743A8D
          99CC0F745FE843CFD12EC12ED3E4DB773875D6839BE78E507625944A250C0683
          9BA6B304604D8C443EA0CFFB185FBE4EA375A5111BD6B681E366D03FF81CA954
          1A8BB46AECD86685AEA90996164B39803960F5B22E3315D7E28B944FA7147ABD
          BE0420E928D0C5B327280E51C54C144560E14E341ABD43CBD42F743037200C8A
          0DB50000000049454E44AE426082}
        Name = 'PngImage0'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          61000000097048597300000B1300000B1301009A9C18000003194944415478DA
          A5935B4C54571486BFCD0C534E0771101546A11522F1126FC930B1425488C65A
          2F4089971AD1C4881A2B46B4C63425F5C5625522DE62BCD26A1FA886B450AC1A
          BC15051F4045F141D1C0B41DE374046F9D09736566BB076BA2519FBA9275CE4E
          CE7FBEB5D6BFF716524AFE4F88539FBF5C44294ED04F3F9DC6BCF8B41133BD09
          13AC492949FD34A386EB9123F4BCA3F55ECDE5BBE74EB685AABA02FCF90660CE
          AF9253B96266528675CBB895E519AD3153B198E04E10C646832ED2656F9070B0
          87A69D058EEF8F346C3E6B97957D80DF725575BDAE68C292958793F32B04C420
          76A8E718F0DD8296BC0EACA7D722E716231A9B617929B6EA12B96CC3C192CB0E
          B957D4E592352C27FBE2E3B0C953B5BFF6E191B24963F64C3FC7CFDDB1D89D01
          1C59EDB0623C5834BCBF7B3154DD441767A6A57C9EBFA0AC699A68FE6678FDC7
          13B36624E61E139196460A51DA2E7FFA8E9E01E0B1AB1E0781CB81D7A721DDED
          689A5589BE00C709362E5CFC8BB0552F707F34A728B6714D5E176EEF3DF3F4C9
          93472C5806DD76A45F99100A41741CA2370CFE00F2F12EF86C3EE2CE4D6AB6D9
          FE117FFF30C59352F8A526F43DAA5237847B919D3625F6ABB5020483FFBD15C8
          1D8D48AE83CCD9D0D94063C5076EB1EE13C3F60D4596AF52268DD2892189C8F6
          4EE87129D715C0EF533FAA0C0594A30184DFAD8A483C86783E34386968F6B822
          738B8C046664A61B161517A42E4A9F9F69907F3995F0DFBEEA22F048CDABBCD0
          0BAE3F95E8D73EC36C32917848507D06479F71AF4EE3E8FE22FF60A1A972CAAA
          CC01F27E37C2A746D2B9799EB011D3934A563CE8E0E8A61CA534B1EA582DC9BB
          65FD1B803E8849CCAD5B6FAE199E6DD671BB95C6AE2652B76411AA569B7245F0
          E9BE74F4C4B3F5EB16B61F60FD5B80489458A38E57140F591A15E7E4D03E07C6
          9CC1B45D82F234254F57934545535A156CDDD946FE3B01438D62D8E61CFD99C2
          6CFDA8182D96B0E547C4D56FD11B6FE15796ECAEE77ED93556BB7BF943BCEF96
          1975A4CD4A658D6528D3061A196C34209C2EBC176D9CBF60A7D217E6869285DE
          0B782D06AA8C8DEC964A759AE852E97DF5F105915D3E24BA8F6AEF0000000049
          454E44AE426082}
        Name = 'PngImage1'
        Background = clWindow
      end>
    Left = 113
    Top = 152
    Bitmap = {}
  end
  object ActionManager: TActionManager
    Images = FontImageList
    Left = 145
    Top = 152
    StyleName = 'XP Style'
    object Action3: TAction
      Caption = 'Czcionka elementu'
      ImageIndex = 0
      OnExecute = Action3Execute
    end
    object Action4: TAction
      Caption = 'Elementy nieparzyste'
      ImageIndex = 1
      OnExecute = Action4Execute
    end
    object Action5: TAction
      Caption = 'Elementy parzyste'
      ImageIndex = 1
    end
    object Action1: TAction
      Caption = 'Aktywny element'
      ImageIndex = 1
      OnExecute = Action1Execute
    end
    object Action2: TAction
      Caption = 'Czcionka aktywnego'
      ImageIndex = 1
      OnExecute = Action2Execute
    end
  end
  object FontDialog: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 47
    Top = 155
  end
  object ColorDialog: TColorDialog
    Left = 79
    Top = 155
  end
end
