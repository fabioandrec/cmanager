inherited CStartupInfoForm: TCStartupInfoForm
  Left = 304
  Top = 323
  Width = 639
  Height = 468
  Caption = 'CManager - Powiadomienia na dzi'#347
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 631
    Height = 441
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 0
    DesignSize = (
      631
      441)
    object Panel2: TPanel
      Left = 2
      Top = 2
      Width = 627
      Height = 400
      Anchors = [akLeft, akTop, akRight, akBottom]
      BevelOuter = bvLowered
      TabOrder = 0
      object Bevel1: TBevel
        Left = 625
        Top = 1
        Width = 1
        Height = 397
        Align = alRight
        Shape = bsRightLine
        Style = bsRaised
      end
      object Bevel2: TBevel
        Left = 1
        Top = 398
        Width = 625
        Height = 1
        Align = alBottom
        Shape = bsTopLine
      end
    end
    object Panel3: TPanel
      Left = 0
      Top = 404
      Width = 631
      Height = 37
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      DesignSize = (
        631
        37)
      object CButton1: TCButton
        Left = 500
        Top = 6
        Width = 130
        Height = 25
        Cursor = crHandPoint
        PicPosition = ppRight
        PicOffset = 10
        TxtOffset = 15
        Framed = False
        Action = Action1
        Anchors = [akRight, akBottom]
        Color = clBtnFace
      end
      object CButton2: TCButton
        Left = 0
        Top = 6
        Width = 161
        Height = 25
        Cursor = crHandPoint
        PicPosition = ppLeft
        PicOffset = 10
        TxtOffset = 15
        Framed = False
        Action = Action2
        Anchors = [akLeft, akBottom]
        Color = clBtnFace
      end
    end
  end
  object ActionManager1: TActionManager
    Images = PngImageList1
    Left = 472
    Top = 205
    StyleName = 'XP Style'
    object Action1: TAction
      Caption = 'Zamknij to okno'
      ImageIndex = 1
      OnExecute = Action1Execute
    end
    object Action2: TAction
      Caption = 'Przejd'#378' do CManager-a'
      ImageIndex = 0
      OnExecute = Action2Execute
    end
  end
  object PngImageList1: TPngImageList
    Height = 24
    Width = 24
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000018000000180806000000E0773D
          F800000006624B474400FF00FF00FFA0BDA793000000097048597300000B0D00
          000B0D01ED07C02C0000000774494D45000000000000000973942E0000055A49
          44415478DA95566B6C145514FEEECCECCEEE761F6577BB5DFAD8DA17A540295D
          50A228095179C71834E107C65F5650235143D41F44EB1FF0AF100C8A8F184592
          428824221840015BB148BBB4145A29140A2D7D6FBBAFEE6B66AE777668B74BEB
          83939C9DBBF79E73BE7BBE73EE9D21F80FF1BED6AA07941C80DA40291B53C2A6
          13A04A9028B1212FBE8DAB76070E1C98D59FFC4B60337B3CA9A9E205211E10C1
          9CF251121150F92E1BB710AA341AA8BF61013D1A6020F47F01B0E0052CE02E36
          5C05C1E426A25DB01A814A57180641C26DBF0977C64528D11109C9D01020DDE4
          E4899D3538F83BF391A667431E08CC28C07A16FC13BDC1E229CC73604D9584A7
          2AF570DB45F05CDA3C1091D0782D84DF3A81D61B630887C2015E89EC71E0FABE
          42FAC7E024C88300CF83F0BBB32C96F96B1FB5635D35459E43044754330ADF2D
          29655753AC039D06D4D029E1C8B9010C8C8423BC1CDCB3841EFC902D25551092
          0E7E99D1C2359ACC36CF0B2B6C585D2DC028F253E0577A24D82DBAD4D81F4AA2
          AA48985A93158AA6CE097CF7EB18864682415DBC77E562E1C7AB2A5D440BDEC2
          8A47BED61BAD2FAE792C07EBAB0151C7A59CE9FD3473ED8CA6391A4063471CFD
          FE24CADD64CA86B29FE69B097CFFCB308201FFB15CD9B73D9FF87A35806DCD6B
          D9EE0F94977A0A5E5A416133EB6614BEC825C2C3745254901BFD3194B8D22C27
          920A8E374771AEB97F48AF8CBE5B450FD713EFB64B6A613F80CEF6DEE6951661
          9147C76A3CB3B90C7A0E4BCBCDB09AD2B49D6B8FA1E36E14454E2D8389988CDB
          031338D41097497CE8CBDC64539D0A90AF9E13C15AB4EEF5A715E80582709C30
          5EC93482D2646D589E8D42279F91C9F9B671B4F71BD013B0A5E662113F68A0EB
          825DE9785B0558C0E8A977CFCD5FF89C574138C6C1ED34C16CE4319B382D1C56
          548A19732AC8FBF5E25467C9F13012FECE5B0EDAF9A60AB004BCE1878A227B51
          CD230A2A0AB3F04C8D0D26F11F0FF9AC52DF04EC3DA9E5A924A388FB6F0C3A59
          A155801A15C093EFF294B924ACF65AF06C8DF9A182ABE2EB01B67FA3D54203E8
          1ACC917D6FA9000B194587AD39C5952E9B808A7C1DDE58AB47AEEDE132D8750C
          38D1CAAAC4DCA45818F1D1CEDB2EA56D07F16EBD58C866BFE0ACA5ABB36DD694
          B1DA7A59864900EDA9504DCB72D94ED76406DFF33370E422C013CD3C1C1C8732
          DE79D1ADB4EC244B6BCF8B9437D6413F6787C35D22CCD2A19014B5AB5460E0AB
          57D3F3117651EF3B4571E232A05E5302AF51343AD02D73D1DE4385F2D98F496D
          6D2D69E15ED948896E7F4E7E699E354B98D19AB12487F90502DE59CFC39D9D06
          F8EC540C67DA950CFB20BB9B86FBBA46CC72CFEE0A9CAC5701708D6CCA8E728E
          FD668B6D73B9C7C9CEC28C6B1D1B9699981AA7FE1FBD10C1E9D658864D82DD3C
          5D7746100D0C9E2E56CED4D9C8BDAB2968350B1FB69452C17CB620D79CAFB6AA
          5EE0329CBD6526AC5BA6D5E8C4A5205A6E4E00747A70057FDD8DA07730346C8E
          B66E9DA76BFA934D0F4C31CE40381F79790B2798EA8ADCC692AA120B0441C800
          A92ED13268ED8E66D6489270A53B849E8148AF2ED1F7F90272BC9E4DF7329D98
          0E803B586E1925F3368137ED9AEB30E42D2AB1C265D369BD379BB08A0E059268
          EF0EA27F343A2C26FBF616A3E127230974B1D5B0DA7C199E2A08137D9BB4B152
          D2BB3EE278DDE30E9BE8A82CE0798B394D9B4A47281C4147AF2C8F8EC7C62047
          2F9B12D73F65B45C63CBFD4C4393EFE7195B53EBC11E7C1FADC9F37365AB9230
          3D41212CE679CE6D3270298ED8AD1995656588A3F1EB268CFADCB4AD8915949D
          658C318DB2E0CA64BC5973BF9F89BA5DB14F9A9F9DE0ED1EC2094EF639914540
          3942E5244763415119BEE7E4FB02F7E9505556899BFED2FF1B38613B1EF22F23
          EA0000000049454E44AE426082}
        Name = 'PngImage0'
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000018000000180806000000E0773D
          F800000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E000005DE49
          44415478DA85565B4F545718FD0E73E6CADC60B80CCC3017151894CA452080A0
          24DA0779B1AD6D6C6B5F4C4D5A5B7F80261A636CA23FA0AD2F367D333136F6A1
          06A389F74B2C15152FDC44618081810119E63E672EA76BEFC20422A627D93927
          E79CFDADBDD75ADFF76D81FEE7DABEFD6B1137138641966535EE02061EE52446
          18CF4B8F1E5D4C7F68BEF0A10F1D1DDFB0C0E5B29CDD807B952008360C039E15
          089CC966B3610C1F9E47F0CF5BBC9FEEEDFD23FDBF0008AC60AB45B03A8542B1
          4BA55276EAF53A677EBED6A8D16854A2A81032998C9C4824A570381A0A8723DE
          4422714F92A41B00ECC7DCF0E3C79733EB0220B812B75204DF81C0C7CD6663A5
          DD5E267A3C1BC9E9B45169A985F2F335944AA5697E3E486FDE4CD0C0C00879BD
          BE7420B0F03A1E8FFF841DDDC598EDEBFB33B5066079E565185F88A278C4E9B4
          BB5B5BEB85BA3A0F555494905AAD7A8F4606343BBB48FDFD83F4F0E153797070
          782C994CFE8C9D5CC2E7198064560398B1F2EEBCBCBCD3454516F781037B85CA
          4A0769B56ACACB13A02AFB4B5E87619924294D3EDF2C5DB8F0973C3CFC9A819C
          C02E7A001014560445F0ED4AA578AEACCCEAD9B367A7B069938392C91415161A
          96579B61D6C985668F0C58A7D3904291474B4B5180F8E9F2E5EBF2E8E8DB21E8
          72389BCD3C58017040D0432693F1587373BDD8DC5CCB0358AD1672B9AC944848
          A0E21D854231C224FE0D625371B199D32749299A9C0CD0DC1CA36B886EDDBA0F
          4DE6CF6027E785659F77C02127EDF6F2AE8E8E168859481098B66C7191D1984F
          994C960281204D4CF86971314C4AA592CACB2D10DECA454FA7B37C014F9F8ED0
          D4D41CDDBBF708C27B6FC762B1530CC002807D0683E1A8C753E5DEBAB51AAB13
          31514B9B37BBC9E12821B83327A8DFBFC07571B9CA408F9A07F7F90274E74E1F
          BD78314291488CDEBD5BA4E969DF1800CE0AEDED5FB920EC41B3D9FC636DED66
          8BCD56CA3966BC5A2C66AAA971D2C68D361E9451118D26383D7ABD96838E8FCF
          D0CD9BBDF4E4C920740863B7FF693537E75F8846A3BF30806AF0FF1D000E5557
          571ACC66534E4816A8A4A4809A9A6A72202B42C38AA06C96AE5EBDCF830783A1
          35FE0A04E6C29148F83C03A801C06183C178D0E974E8753AED9A1F552A915A5A
          6AA9ADED232E2ADCC6DF472271EAED7D45172F5EA58585E07B39028008007EE7
          3B0045DFEB74F9DF5AAD5603AC9AFB09C0705211EDDCD948F5F5D5105E9F0360
          54BD7C394A57AEDC45464F823E690D0028623BF84D686BFBD28D4907351AED0F
          45C83080F11FD8BDACAC983A3B1B5151EB900F464E4B3C2E7110E69E50284A7D
          7D8374E3462F8D8E7AC17F9A5B98D13833330D0D22BF0AADADFBE122799F4AA5
          395A5050E0661664018A8B0B69F7EED6E5E0262EDEF4F43C8D8D4DF3E4620E63
          7746D5B367C3D4D3731F824FF1E04832B86D662C1E8F9E65002292A703814F42
          872EA3D1C46DDADEDE40FBF77F4C0505465831C37380B9E5F9F3D710BE90BABA
          9AA8A1A11A6ED2512C96C02EFEA14B97AEC159120AE102F265E176329938C509
          6D69F91C992C1E024DC74A4B4B449D4E471ECF06EAEEEEE099CC3294F9BCBF7F
          04568C70E15D2E1BEDD8B18DEAEA3641D02500FC8D82D78F1D85916C9369D073
          26954A9D5F0160CAA21629CF592C451ED42341AD565355958B1A1B3DF4EAD55B
          1A1919E72B5D29785810D96C257C177EFF3CAC3A84EF31948C497976D63F04D1
          518BB20F72D5B4A9E93354D3BC6E809C2E2F2F773B1C7641A55271B199B8AB0B
          5DAE96422B56F0B259198551823EE3B2D73B3E2649C91398D33338783DB81A80
          F7034C423F501EA9A8B0BBED769BA0D7E77310619DE6CA301938BA1A6ACF843C
          3E3EB6DC0F64F4037906009935D3B66DFB34D7D140D17193C954595C5C22DA6C
          563218F4BC7CAC5CAC00864211F0ED438DF2A7517FD0D162B98E86E06B3BDACA
          D5D8F809EFC958751DE8DA85D1894AEBD46AB5467435156814D2E9347A725C42
          8B0CC1925EAC9AF76458B99F9D34D8CAD7EDC9ABAF8686BD227EC6A942E6A70A
          00D9419D81D18E4059040DA7D3A92976AAC0777EAA1818B8F6DEA9E25F396D04
          0E01BF43D90000000049454E44AE426082}
        Name = 'PngImage1'
      end>
    Left = 213
    Top = 237
    Bitmap = {}
  end
end
