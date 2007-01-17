inherited CPreferencesForm: TCPreferencesForm
  Left = 298
  Top = 289
  Caption = 'Preferencje'
  ClientWidth = 604
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 604
    object PanelMain: TPanel
      Left = 0
      Top = 0
      Width = 604
      Height = 398
      Align = alClient
      BevelOuter = bvNone
      Caption = 'PanelMain'
      TabOrder = 0
      object PanelShortcuts: TPanel
        Left = 129
        Top = 0
        Width = 475
        Height = 398
        Align = alClient
        BevelOuter = bvLowered
        TabOrder = 0
        object PanelShortcutsTitle: TPanel
          Left = 1
          Top = 1
          Width = 473
          Height = 21
          Align = alTop
          Alignment = taLeftJustify
          Caption = '  Kategorie'
          Color = clActiveCaption
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindow
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
        object PageControl: TPageControl
          Left = 1
          Top = 22
          Width = 473
          Height = 375
          ActivePage = TabSheetView
          Align = alClient
          Style = tsFlatButtons
          TabOrder = 1
          object TabSheetBase: TTabSheet
            Caption = 'TabSheetBase'
            TabVisible = False
            object GroupBox1: TGroupBox
              Left = 8
              Top = 8
              Width = 449
              Height = 121
              Caption = ' Przy starcie systemu '
              TabOrder = 0
              object RadioButtonLast: TRadioButton
                Left = 16
                Top = 32
                Width = 209
                Height = 17
                Caption = 'Otwieraj ostatnio u'#380'ywany plik danych'
                Checked = True
                TabOrder = 0
                TabStop = True
                OnClick = RadioButtonLastClick
              end
              object RadioButtonNever: TRadioButton
                Left = 16
                Top = 80
                Width = 193
                Height = 17
                Caption = 'Nie otwieraj '#380'adnego pliku danych'
                TabOrder = 2
                OnClick = RadioButtonNeverClick
              end
              object RadioButtonThis: TRadioButton
                Left = 16
                Top = 56
                Width = 161
                Height = 17
                Caption = 'Otwieraj wybrany plik danych'
                TabOrder = 1
                OnClick = RadioButtonThisClick
              end
              object CStaticFileName: TCStatic
                Left = 192
                Top = 54
                Width = 241
                Height = 21
                AutoSize = False
                BevelKind = bkTile
                Caption = '<kliknij tutaj aby wybra'#263' plik danych>'
                Color = clWindow
                ParentColor = False
                TabOrder = 3
                TabStop = True
                Transparent = False
                TextOnEmpty = '<kliknij tutaj aby wybra'#263' plik danych>'
                OnGetDataId = CStaticFileNameGetDataId
                HotTrack = True
              end
            end
          end
          object TabSheetView: TTabSheet
            Caption = 'TabSheetView'
            ImageIndex = 1
            TabVisible = False
            object GroupBox2: TGroupBox
              Left = 8
              Top = 8
              Width = 449
              Height = 97
              Caption = ' Okno g'#322#243'wne '
              TabOrder = 0
              object CheckBoxShortcutVisible: TCheckBox
                Left = 16
                Top = 32
                Width = 145
                Height = 17
                Caption = 'Pasek skr'#243't'#243'w widoczny'
                TabOrder = 0
              end
              object CheckBoxStatusVisible: TCheckBox
                Left = 16
                Top = 56
                Width = 145
                Height = 17
                Caption = 'Pasek statusu widoczny'
                TabOrder = 1
              end
            end
          end
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 129
        Height = 398
        Align = alLeft
        BevelOuter = bvLowered
        Color = clWindow
        TabOrder = 1
        object CButton1: TCButton
          Left = 16
          Top = 40
          Width = 100
          Height = 57
          Cursor = crHandPoint
          PicPosition = ppTop
          PicOffset = 10
          TxtOffset = 15
          Framed = False
          Action = Action1
        end
        object CButton2: TCButton
          Left = 16
          Top = 112
          Width = 100
          Height = 57
          Cursor = crHandPoint
          PicPosition = ppTop
          PicOffset = 10
          TxtOffset = 15
          Framed = False
          Action = Action2
        end
        object Panel2: TPanel
          Left = 1
          Top = 1
          Width = 127
          Height = 21
          Align = alTop
          Alignment = taLeftJustify
          Caption = '  Kategorie'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
      end
    end
  end
  inherited PanelButtons: TPanel
    Width = 604
    inherited BitBtnOk: TBitBtn
      Left = 427
    end
    inherited BitBtnCancel: TBitBtn
      Left = 515
    end
  end
  object ActionManager1: TActionManager
    Images = CategoryImageList
    Left = 225
    Top = 272
    StyleName = 'XP Style'
    object Action1: TAction
      Caption = 'Podstawowe'
      ImageIndex = 0
    end
    object Action2: TAction
      Caption = 'Widok'
      ImageIndex = 1
    end
  end
  object CategoryImageList: TPngImageList
    Height = 24
    Width = 24
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000018000000180806000000E0773D
          F800000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E000005C349
          44415478DAA595095053571486EF4BF2B2EF81802422904858442888D42A295B
          41689D8AED38B6DA5A2D5628DA3A535BB1D81695222E23568B8888756DDDEA36
          622B05C1B25A5915212801040C814012124276D29B543BB4338AB467E6CC9B3B
          EFBEFB9D73EE7FCE43C0045BB264291A1919C9D568D423A5A525B6DDBB73D2F9
          7CB7958B162D9A333A3A3274E0401E2F333343515656A6032F68C8C4C5FEFD07
          85A1A121DBACD6F17683D1AA71E6BA24B9BA70FD9A1A1BF69ACD066940C0ACC5
          7979870E67677F7BE13F01F6EDCB9D2D16479C4770443749FBA371021EA5E109
          2842A5900C5C2796619AAB136DC386F529C78F17164C0580E4E7FFF0B297C03B
          56A55209500263996A4487F2795C4020E0E1060458AD566081CE6133815221AB
          1854A86E49A5D2475F6DF9F4C88B00707BF6E47EF45A6CFC0E85524B93F50F21
          5C673620125080A23880C16280D9680626B3C50171E2B0C0887AD4565C5C7463
          E78EB404F8BD6DD20CC2C2E6FBA56FC93AADD25A0269540A2091086064440BE4
          72B959AF1F1BF7F4F42250286480C12040A73300C5E0A0B2A6AA24F5D4C9DC33
          936690BA6E13C7CD6D7A82B74F60A66ECCE4CE62D181C5620355D5552D3F9EFC
          6EAB5CD6DDB762E56719D13109B10C0615E9E9ED07369BCDA4510DECD7E97485
          B907BE7E089FD667025252BF4C8A8A7E63CFB80DA1EB0D068449A7C2B2E0406D
          75697E56E6C6F5708F796DCAA6A47071DC2114256055AA1160B238CEB33D6C6F
          B976B420732504A89E0958101E9718122ACEF0F17DC9874422E36194800C4B34
          363A5C517824E7839090A02E2A9D971B1010966C349911955A03EC9086FA1A49
          6B6B7DC1BDA68A7C93C9F4CCBE70C8542010F9AF5E937ED6D34BE8CFA0910193
          49054C3AC586C502250C5467B361A78FEAF48846AB03C3F0F036C9034D75C56F
          AB6EFC72FAE2A477C066B3D1A5CBD62DF712CEDAE5EACA75E6BB39031A950C28
          64D28436B101332C8B4E3706FAFA15A0A5B5C37CB7B1E6E8E59FF392270510A0
          4544BF9D4AA3313F74E3B973E262A35D041E3CF80A0BF53F6EBF5080C3611CAE
          D268C1B90B45DAE6C63BBD4AA5BCBEEE76F1FBE5E5BF87A8D52ABFC58BDF3CF9
          24A27FC8F6698864E8A4D0B09898F9E1AFE70606CEE204CD1600BB34ED1BF406
          23E8EA7A6C6BBEDF85FC742A37337C5EE01F09097129C36AC379A150F0AE3387
          1D5A51599921F21686D6D6D65C4E4BDB78FEDF0087892312C5AE6E9E27A0F665
          0C0605E1F36788D81C5796542AE9EE923EEC6072A605AA06A50509F151F205E2
          C80C83C146A750883838521C75B4675B7CE35A567FFFC0D19A9A4A7965E5CDB1
          7F00DC3D7CB94422255233A294184D46E34C51F01ABF8079C9B72B8B767677DE
          3D31C353147730F7E0661C4A421004C3137AF1B1F67182850D68309A806C4009
          AC6653FFA31EB9E47AD1A5ED50856508788EE1F124770A8D15AF1A9615C1651F
          74F49BAD7BAF46462D5CE8CEE7022D5455FB832EBDDE3066160ABCE84C060DA8
          357A70B3B4B47AF7CEB4F7341A55E773014F4A88816EEF2CCC176999C19E9EA2
          EF453EFE611C160DD435DCD75CBC74EE746F8FB463F98A359B4382839CD46A2D
          782C7BDCDA2E69FEBCE14EF5CDC9007F1B8D46A3A7A5E7140884BE89783C8A52
          C84430A450749F3B7378F5952B67ABB3771DA9F4F4F29BA3D18EC2CC46AD6D6D
          4D57AB2B7E5DFFC200876E01F0FEF8936DC7E6CC7D752E18B702368B6A211391
          7A8D46D947223B2576F7C83116286D38429A0A0F6F5F0BC5D2301500E07279CE
          49C99BAB3C3C66CEB4CB5DAF370206AC3BCC080C0C0C39F6D8C77BBBE481A4AA
          A26855736379ED94002412755AD82BB1D910E01B111513442212517BCDEDFF0A
          3A1C31F60E2B2F2B69696EBA533E34283BD6DBD3563F25C0D38B8F887EEB1D28
          E11DAE5CC6388FEFC62292A8F44E69477F9F6C08DF7AAF2EABB6EA6ACE44954C
          D984A2E000024A147777B5B588FCC3E2DD3D442B6E955CD8C8643B13CD26434B
          5F8FA4EE7F019E5C380EBAD1D965863B8DC60AEDEC68BA0ED716E8E3E02F593B
          EC4F7BFD819E95FB6B850000000049454E44AE426082}
        Name = 'PngImage1'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000018000000180806000000E0773D
          F800000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000042149
          44415478DAB594DB4F5C5514C6BF339733F719866180014F3B17868E14148D4D
          14142FA98DAD1ADFF465FE00DFFAE483F11F6824965EF0417DB15A5B686923C8
          140AB5B58D3151B494DA024543E1944BCBDC18E672606698E33A874BA1C034C4
          F64B76CE4ECEDEEBB7F75ADF5E0C9EB298CF3E3DE3C889F84004144F3876DFA1
          431FF6318D9F77FE50F39CAB4EAD56E84411E2762288620ED1680A2CAB42369B
          5392F44AA5021A8D5A9C9E0EFD76F597FE8F99E3C7BAC75F6B7861C7C2C2FCB6
          8F383B9B446C368148340E8FBB8C6071795E5BEBC5FDFB91546F4FEF474C53D3
          05BEBEFE792E9BCD6C3FBF0C83B9D802B45A95FCD5689460B54AE8742CC6C766
          8440A0DDCF1CFE22C0FB7C159C7492C7E9991D564CF0D147288FE60D60352AA4
          5249A1B7B7CB4F35E8E09DCE1D9CCBAD81D5CA6E19FCEE68022AB501C10751BC
          F852611E0255F7F7107152427B7B8F74834EDEE5DCC955780DB015699188C761
          B158A0D3EB110E87E534B02C8B913B7472468370288657EA1CF40D219D4EAF0B
          6C349960A2F1EBB52928550BC2B973013FD37498002E27E7F51A65C0E55B4124
          C9B17A9D1A436311BC5B530C57B11E7786A3742A3522A139D4BD5A064110B098
          CDAE03B01A8D7C986B5727E8B659A1ADADD3CF1C690AF06E09B0CB04BB5D8FF3
          7FCEE06610482B58C909F8E4ED123C5B66C0D060088B391522E1381A5EE7A888
          6394E7D43A4091DD4E31ECB872799C408BC2D9B3CB008FDBC5EDF299612FA640
          93090C4E25573735F8ACB09B58DCA69B65171588461278E3CD9D79CDF0F3A5BB
          E4AC9CD0DADAE1678E1EB9C07B3C4ECEE72B40718971C908F4E2A4DCAF9DDFFA
          FB01D21906B304786BAF7BD3352BF34B3DA354435138DD42363D765402B8B9AA
          2A2B4A4A4DF282158FAF9DDF1C98C6FC8288583489BDFB2A365DB332BFD8FD0F
          0C06463875EABC04E8E22B2A5C5CD56E1B4A09B095066E4C4198CF616E36857D
          EF54E64D515760981CA5104E9E6CF353AB90006EAEBADA8E528709539393B24D
          4D663326272656AD77A37F12C954965EAC80FD077C181E1A429C2CBD56E5E5E5
          28A311F86910268B52F8FEBB337EA6F97837EF25C0EE1A3B1C0E3384EB8D50A7
          87A1B4E590FAF70FB0B5DF40EDA8C3F5BF260890419C0007DEAB427C6E0E99CC
          FAF622BD1D9D4E87CE8EDB3017A88413275A97015E02543F04E4EE7D05A53585
          4C3803EDCB3F12A07E0340BA9DF416D6AAB0B01085369B0CB058D50468214073
          375FE9F5500D8A64402E710F8B717E7593CA560D86B56C00E493042820C0B712
          E0CBE68B7C65A5872B2DD5C366336CB145C4C8C80C594581703041ADC29917D0
          D7C74B7D6DE90654E4D13D7BAA5DB1584A0EB4510F9B5991DD483D68EBAEBBFC
          1460346AC900B1D8E9162AF2C1838DEFABD5C9FDE461B3286E129A411EADFD29
          CA6309A2403018991A18E8FF9A595EA55A1E4F52391A69E67F87798C9E3AE03F
          F3DEE5BA0D09DD950000000049454E44AE426082}
        Name = 'PngImage0'
        Background = clWindow
      end>
    Left = 185
    Top = 240
    Bitmap = {}
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'dat'
    Filter = 'Pliki danych|*.dat|Wszystkie pliki|*.*'
    FilterIndex = 0
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 8
    Top = 85
  end
end
