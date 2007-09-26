inherited CPreferencesForm: TCPreferencesForm
  Left = 313
  Top = 226
  Caption = 'Preferencje'
  ClientHeight = 486
  ClientWidth = 602
  PixelsPerInch = 96
  TextHeight = 13
  inherited PanelConfig: TPanel
    Width = 602
    Height = 445
    object PanelMain: TPanel
      Left = 0
      Top = 0
      Width = 602
      Height = 445
      Align = alClient
      BevelOuter = bvNone
      Caption = 'PanelMain'
      TabOrder = 0
      object PanelShortcuts: TPanel
        Left = 129
        Top = 0
        Width = 473
        Height = 445
        Align = alClient
        BevelOuter = bvLowered
        TabOrder = 0
        object PanelShortcutsTitle: TPanel
          Left = 1
          Top = 1
          Width = 471
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
          Width = 471
          Height = 422
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
              Height = 137
              Caption = ' Przy starcie CManager-a  '
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
              object CheckBoxCheckForupdates: TCheckBox
                Left = 18
                Top = 104
                Width = 247
                Height = 17
                Caption = 'Sprawdzaj dost'#281'pne aktualizacje CManager-a'
                TabOrder = 4
              end
            end
            object GroupBox5: TGroupBox
              Left = 8
              Top = 160
              Width = 449
              Height = 61
              Caption = ' Dni pracuj'#261'ce '
              TabOrder = 1
              object CheckBoxSat: TCheckBox
                Left = 344
                Top = 28
                Width = 35
                Height = 17
                Caption = 'So'
                TabOrder = 5
              end
              object CheckBoxTue: TCheckBox
                Left = 72
                Top = 28
                Width = 35
                Height = 17
                Caption = 'Wt'
                TabOrder = 1
              end
              object CheckBoxWed: TCheckBox
                Left = 128
                Top = 28
                Width = 35
                Height = 17
                Caption = #346'r'
                TabOrder = 2
              end
              object CheckBoxMon: TCheckBox
                Left = 16
                Top = 28
                Width = 35
                Height = 17
                Caption = 'Pn'
                TabOrder = 0
              end
              object CheckBoxFri: TCheckBox
                Left = 240
                Top = 28
                Width = 35
                Height = 17
                Caption = 'Pt'
                TabOrder = 4
              end
              object CheckBoxSun: TCheckBox
                Left = 400
                Top = 28
                Width = 35
                Height = 17
                Caption = 'N'
                TabOrder = 6
              end
              object CheckBoxThu: TCheckBox
                Left = 184
                Top = 28
                Width = 35
                Height = 17
                Caption = 'Cz'
                TabOrder = 3
              end
            end
            object GroupBox6: TGroupBox
              Left = 8
              Top = 240
              Width = 449
              Height = 161
              Caption = ' Automatyczne kopie plik'#243'w danych '
              TabOrder = 2
              object Label3: TLabel
                Left = 416
                Top = 32
                Width = 14
                Height = 13
                Caption = 'dni'
              end
              object Label2: TLabel
                Left = 17
                Top = 68
                Width = 61
                Height = 13
                Alignment = taRightJustify
                Caption = 'Katalog kopii'
              end
              object Label5: TLabel
                Left = 51
                Top = 32
                Width = 27
                Height = 13
                Alignment = taRightJustify
                Caption = 'Akcja'
              end
              object Label6: TLabel
                Left = 22
                Top = 104
                Width = 58
                Height = 13
                Alignment = taRightJustify
                Caption = 'Nazwa kopii'
              end
              object CButton8: TCButton
                Left = 316
                Top = 96
                Width = 115
                Height = 25
                Cursor = crHandPoint
                PicPosition = ppLeft
                PicOffset = 10
                TxtOffset = 15
                Framed = False
                Action = ActionAdd
                Color = clBtnFace
              end
              object ComboBoxBackupAction: TComboBox
                Left = 88
                Top = 28
                Width = 265
                Height = 21
                BevelInner = bvNone
                BevelKind = bkTile
                Style = csDropDownList
                ItemHeight = 13
                ItemIndex = 2
                TabOrder = 0
                Text = 'Monituj, je'#380'eli ostatnia kopia jest starsza ni'#380
                OnChange = ComboBoxBackupActionChange
                Items.Strings = (
                  'Wykonaj raz dziennie, przy pierwszym uruchomieniu'
                  'Wykonaj zawsze podczas uruchamiania'
                  'Monituj, je'#380'eli ostatnia kopia jest starsza ni'#380
                  'Nie wykonuj kopii, po prostu uruchom CManager-a')
              end
              object CStaticBackupCat: TCStatic
                Left = 88
                Top = 64
                Width = 321
                Height = 21
                AutoSize = False
                BevelKind = bkTile
                Caption = '<kliknij tutaj aby wybra'#263' katalog kopii>'
                Color = clWindow
                ParentColor = False
                TabOrder = 1
                TabStop = True
                Transparent = False
                TextOnEmpty = '<kliknij tutaj aby wybra'#263' katalog kopii>'
                OnGetDataId = CStaticBackupCatGetDataId
                HotTrack = True
              end
              object CIntEditBackupAge: TCIntEdit
                Left = 376
                Top = 28
                Width = 33
                Height = 21
                BevelKind = bkTile
                BorderStyle = bsNone
                TabOrder = 2
                Text = '7'
              end
              object EditBackupName: TEdit
                Left = 88
                Top = 100
                Width = 227
                Height = 21
                BevelKind = bkTile
                BorderStyle = bsNone
                MaxLength = 40
                TabOrder = 3
              end
              object CheckBoxCanOverwrite: TCheckBox
                Left = 88
                Top = 124
                Width = 353
                Height = 17
                Caption = 'Zezwalaj na nadpisywanie istniej'#261'cych kopii'
                TabOrder = 4
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
              Width = 169
              Height = 161
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
            object GroupBox4: TGroupBox
              Left = 192
              Top = 8
              Width = 265
              Height = 161
              Caption = ' Czcionki '
              TabOrder = 1
              object CButton4: TCButton
                Left = 5
                Top = 24
                Width = 250
                Height = 25
                Cursor = crHandPoint
                PicPosition = ppLeft
                PicOffset = 10
                TxtOffset = 15
                Framed = False
                Action = Action4
                Color = clBtnFace
              end
              object CButton5: TCButton
                Left = 5
                Top = 56
                Width = 250
                Height = 25
                Cursor = crHandPoint
                PicPosition = ppLeft
                PicOffset = 10
                TxtOffset = 15
                Framed = False
                Action = Action5
                Color = clBtnFace
              end
              object CButton6: TCButton
                Left = 5
                Top = 88
                Width = 250
                Height = 25
                Cursor = crHandPoint
                PicPosition = ppLeft
                PicOffset = 10
                TxtOffset = 15
                Framed = False
                Action = Action6
                Color = clBtnFace
              end
              object CButton7: TCButton
                Left = 5
                Top = 120
                Width = 250
                Height = 25
                Cursor = crHandPoint
                PicPosition = ppLeft
                PicOffset = 10
                TxtOffset = 15
                Framed = False
                Action = Action7
                Color = clBtnFace
              end
            end
            object GroupBox7: TGroupBox
              Left = 192
              Top = 184
              Width = 265
              Height = 121
              Caption = ' Wy'#347'wietlanie element'#243'w list '
              TabOrder = 2
              object Panel4: TPanel
                Left = 24
                Top = 32
                Width = 217
                Height = 25
                Cursor = crHandPoint
                BevelOuter = bvLowered
                Caption = 'Elementy nieparzyste'
                TabOrder = 0
                OnClick = Panel4Click
              end
              object Panel5: TPanel
                Left = 24
                Top = 72
                Width = 217
                Height = 25
                Cursor = crHandPoint
                BevelOuter = bvLowered
                Caption = 'Elementy parzyste'
                TabOrder = 1
                OnClick = Panel5Click
              end
            end
          end
          object TabSheetAutostart: TTabSheet
            Caption = 'TabSheetAutostart'
            ImageIndex = 2
            TabVisible = False
            object GroupBox3: TGroupBox
              Left = 8
              Top = 8
              Width = 449
              Height = 305
              Caption = ' Powiadomienia o operacjach i limitach '
              TabOrder = 0
              object Label4: TLabel
                Left = 265
                Top = 66
                Width = 39
                Height = 13
                Alignment = taRightJustify
                Caption = 'Ilo'#347#263' dni'
              end
              object Label1: TLabel
                Left = 352
                Top = 66
                Width = 78
                Height = 13
                Caption = '(w'#322#261'cznie z dzi'#347')'
              end
              object CheckBoxAutostartOperations: TCheckBox
                Left = 16
                Top = 32
                Width = 242
                Height = 17
                Caption = 'Powiadamiaj przy starcie systemu o planach na'
                TabOrder = 0
                OnClick = CheckBoxAutostartOperationsClick
              end
              object ComboBoxDays: TComboBox
                Left = 264
                Top = 28
                Width = 169
                Height = 21
                BevelInner = bvNone
                BevelKind = bkTile
                Style = csDropDownList
                ItemHeight = 13
                ItemIndex = 0
                TabOrder = 1
                Text = 'Dzi'#347
                OnChange = ComboBoxDaysChange
                Items.Strings = (
                  'Dzi'#347
                  'Jutro'
                  'Ten tydzie'#324
                  'Przysz'#322'y tydzie'#324
                  'Ten miesi'#261'c'
                  'Przysz'#322'y miesi'#261'c'
                  'Okre'#347'lon'#261' ilo'#347#263' kolejnych dni')
              end
              object CIntEditDays: TCIntEdit
                Left = 312
                Top = 62
                Width = 33
                Height = 21
                BevelKind = bkTile
                BorderStyle = bsNone
                TabOrder = 2
                Text = '0'
              end
              object CheckBoxAutoIn: TCheckBox
                Left = 16
                Top = 104
                Width = 313
                Height = 17
                Caption = 'Powiadamiaj o zaplanowanych operacjach przychodowych'
                TabOrder = 3
              end
              object CheckBoxAutoOut: TCheckBox
                Left = 16
                Top = 152
                Width = 313
                Height = 17
                Caption = 'Powiadamiaj o zaplanowanych operacjach rozchodowych'
                TabOrder = 5
              end
              object CheckBoxAutoAlways: TCheckBox
                Left = 16
                Top = 272
                Width = 417
                Height = 17
                Caption = 
                  'Wy'#347'wietlaj okno powiadomienia nawet gdy nie ma '#380'adnych informacj' +
                  'i'
                TabOrder = 9
              end
              object CheckBoxAutoOldIn: TCheckBox
                Left = 16
                Top = 128
                Width = 313
                Height = 17
                Caption = 'Powiadamiaj o zaleg'#322'ych operacjach przychodowych'
                TabOrder = 4
              end
              object CheckBoxAutoOldOut: TCheckBox
                Left = 16
                Top = 176
                Width = 313
                Height = 17
                Caption = 'Powiadamiaj o zaleg'#322'ych operacjach rozchodowych'
                TabOrder = 6
              end
              object CheckBoxSurpassed: TCheckBox
                Left = 16
                Top = 200
                Width = 313
                Height = 17
                Caption = 'Powiadamiaj o przekroczonych limitach'
                TabOrder = 7
                OnClick = CheckBoxSurpassedClick
              end
              object CheckBoxValid: TCheckBox
                Left = 16
                Top = 224
                Width = 233
                Height = 17
                Caption = 'Powiadamiaj o poprawnych limitach'
                TabOrder = 8
                OnClick = CheckBoxValidClick
              end
              object CheckBoxExtractions: TCheckBox
                Left = 16
                Top = 248
                Width = 233
                Height = 17
                Caption = 'Powiadamiaj nieuzgodnionych wyci'#261'gach'
                TabOrder = 10
                OnClick = CheckBoxValidClick
              end
            end
          end
          object TabSheetPlugins: TTabSheet
            Caption = 'TabSheetPlugins'
            ImageIndex = 3
            TabVisible = False
            object CButton10: TCButton
              Left = 324
              Top = 380
              Width = 125
              Height = 25
              Cursor = crHandPoint
              PicPosition = ppLeft
              PicOffset = 10
              TxtOffset = 15
              Framed = False
              Action = Action9
              Color = clBtnFace
            end
            object CButton11: TCButton
              Left = 0
              Top = 380
              Width = 161
              Height = 25
              Cursor = crHandPoint
              PicPosition = ppLeft
              PicOffset = 10
              TxtOffset = 15
              Framed = False
              Action = Action10
              Color = clBtnFace
            end
            object Panel3: TPanel
              Left = 8
              Top = 8
              Width = 441
              Height = 361
              BevelOuter = bvLowered
              TabOrder = 0
              object List: TCDataList
                Left = 1
                Top = 1
                Width = 439
                Height = 359
                Align = alClient
                BevelEdges = []
                BevelInner = bvNone
                BevelOuter = bvRaised
                BevelKind = bkFlat
                BorderStyle = bsNone
                ButtonStyle = bsTriangle
                CheckImageKind = ckDarkTick
                DefaultNodeHeight = 24
                Header.AutoSizeIndex = -1
                Header.Font.Charset = DEFAULT_CHARSET
                Header.Font.Color = clWindowText
                Header.Font.Height = -11
                Header.Font.Name = 'MS Sans Serif'
                Header.Font.Style = []
                Header.Height = 21
                Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
                Header.Style = hsFlatButtons
                HintMode = hmHint
                Indent = 0
                ParentShowHint = False
                ShowHint = True
                TabOrder = 0
                TreeOptions.AutoOptions = [toAutoDropExpand, toAutoScrollOnExpand, toAutoSort, toAutoTristateTracking, toAutoDeleteMovedNodes]
                TreeOptions.MiscOptions = [toCheckSupport, toFullRepaintOnResize, toInitOnSave, toToggleOnDblClick, toWheelPanning]
                TreeOptions.PaintOptions = [toHideFocusRect, toHideSelection, toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
                TreeOptions.SelectionOptions = [toFullRowSelect]
                OnChecked = ListChecked
                OnFocusChanged = ListFocusChanged
                OnInitNode = ListInitNode
                OddColor = 12437200
                AutoExpand = True
                OnCDataListReloadTree = ListCDataListReloadTree
                Columns = <
                  item
                    Position = 0
                    Width = 55
                    WideText = 'Aktywna'
                  end
                  item
                    Position = 1
                    Width = 150
                    WideText = 'Nazwa'
                  end
                  item
                    Position = 2
                    Width = 234
                    WideText = 'Opis'
                  end>
                WideDefaultText = ''
              end
            end
          end
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 129
        Height = 445
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
        object CButton3: TCButton
          Left = 16
          Top = 184
          Width = 100
          Height = 57
          Cursor = crHandPoint
          PicPosition = ppTop
          PicOffset = 10
          TxtOffset = 15
          Framed = False
          Action = Action3
        end
        object CButton9: TCButton
          Left = 16
          Top = 256
          Width = 100
          Height = 57
          Cursor = crHandPoint
          PicPosition = ppTop
          PicOffset = 10
          TxtOffset = 15
          Framed = False
          Action = Action8
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
    Top = 445
    Width = 602
    inherited BitBtnOk: TBitBtn
      Left = 425
    end
    inherited BitBtnCancel: TBitBtn
      Left = 513
    end
  end
  object ActionManager1: TActionManager
    Images = CategoryImageList
    Left = 81
    Top = 336
    StyleName = 'XP Style'
    object Action1: TAction
      Caption = 'Podstawowe'
      ImageIndex = 0
    end
    object Action2: TAction
      Caption = 'Widok'
      ImageIndex = 1
    end
    object Action3: TAction
      Caption = 'Powiadamianie'
      ImageIndex = 2
    end
    object Action8: TAction
      Caption = 'Wtyczki'
      ImageIndex = 3
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
          000B1301009A9C180000000774494D45000000000000000973942E0000067649
          44415478DA95557B7054D519FFCED9BB77EFDDBBCF244B24244202A80331C81F
          11B5545A02033EAA829D38A330D3A93823A0526C6DF9033A3E98A96D07C73A3A
          8EE323BEEAA3A90E0F03541443789820C484900412B27927FBCADEDDBB8F7BF7
          3ECEE95908290CA8F49B39735EDFF7FDBE73CEEF3B1F82ABC8238DB46494C20D
          39676EBAAD474B1E59EBDB5BF30EB5650AA18A6BA7A64960A8F9599C846B1074
          B5C5D59FD1AD912A78212800148473A6EF5F43B504B923CAEAC05BA98C0DBBD5
          DC111AD45FEA7CD2D379CD008F1EA66E19419D63185E8A4553F7F14BF8CDFB0B
          1C3C6703B849CE851D1652FA9CDCCC04607E8646403A786673F753F35FBE2680
          87BFA0D7F7155A3BBF9F635B5816D789F7FB740C2DF5FB4EE6109FD7E0750A36
          83526A016808A30266E36E8A243C843C91327C2BB109239916F5D5F0A705A357
          05786837DD305E4EFE3658849D83065BC3173685B441DD5D32728D67A9DD2094
          0042EA341159650574C2674745119D66DD3CB2A54C08F493FAE8D7EAB6F8C7FE
          B357003CB88BAE773B8DBF9B1211DB67F2D061222C1826BDFEC018158232064A
          81E63509056C630389A7DC0D01E364798007ED82A305B9DC68FF8E8EF5CA97D5
          0D79CD2980073EA00E13CC3F8982F634E741F6130B24B1979DA2A22B6DCEE856
          82C425854C4D69C3766701C6788695532AA96505A86E001790C8A992EB70C6C6
          41E0F381EF52CD476BD5936B86995F6B0A60F9D7E457B2D37C41C9A825C8C7E1
          F075CEC204DB58D4669CC567DA1E6DFEE3EDED94583A5B321D45A5B87A47F32A
          4E703C4E4CFD17C834B1E196AC76C18F254A74E974EACBF4A0AD29DA633B085F
          B95ACF03DCDD485EEB9D031BFAD96D9964129BBDC11D41683CF64BB49CCDE8A5
          11553CB205CA6B9F998939EB0DC06805C7EEAF9F78A157E7916011D03354AF48
          5B07CEBE79FCB7D0F6F308FAF517D6B1F87CBAA893C38029420ABB9E0C73579E
          A3DFCE3938B4F2C0A659CA0F51F0FED64C070BA652C881F169D0693F1F0A0BD2
          A1E572F6FDC3DBD24DCFEF40AB3ED13B3028372508A19297C79159123D81388E
          4513BF7150DB74F25EE9C31F02589BA4358646F6883A11DF6DE418010066EB19
          90477286DE2BBF9EDCFBCC1674579D7A58190E2F4E2826F80322AD5E5668EC14
          1DDC900E78B606037333B0AAA106B55D0D601DA5159A02EF8959BAF8CD7D8CDD
          0E8079E782834387427B9591A6F780D10A2D792DF5A212921F332D2A94CE710B
          3E09517D9E0B7F96E510B088E667C12854AD5B9B567057803C46A9A0CBF42FB1
          6EBAB1A11BDBF3FAC5A198063D034F86BBC4DDD052194177BE61961AA9CC3243
          D55D2E0F7D7EE62D2E6F934740FD2A42E79F96DD6BA94E07FC1EF4EECD0EA8FF
          6801EABA08B0B18D96F565C9DBCD03687922C3F2C3BC9059C56066D58EC8C7CA
          77F1AD17FFA27C4F97FE2334ECBF775AE9AE08639431992EE68526310D96CA9D
          B32588961602E418787F3F786349A84AEB60C36C7E47094030061067B6AED170
          57B4FEE89AA9CFAE6ABBB1A2480CBFECABF64F3B2288BE0ACB82B96389CCAC00
          6FFF4877E1A48EF9983A09684CF69327CC8F6FF5EB96D5DC677A8A841C9A1570
          0D77CAFFEC7D7BEBD40960FEB6C4FB4585EA1A0706ADA052B252C7E36257BF86
          45AF1DDD5EE592C74AFCC2BE985DCC3B9B66678D3DA89BE54B4F1460220D5053
          A8D2C18341128AE8592D8D062C25F82C3DF1E07FFE07F09CB64DE222EB31679B
          5EEE02737FD304299E21E8BCD3E12A7383665F18D076C6451FCFA2FE994B9569
          CF84483503B91694EAFB06EDEEE92E46A9F0F0F8B17D9188259F7A02BAFFD00B
          863C7159C199BD39FE8A5B4ADF65646959349CAA3734E39CC5714BFFBCB664D1
          69A753FF2424B87DCCA2321523A79A4268C93C275A748B57DFA3F86D6306C278
          44D6B56F5B360CEEBEFBDFCC9D7259C1C94BD9E3235E04E47E4353CBA23BEFAB
          33136763704F70EB8BEBA42D4984E9714D3003454E94ED0AE9071A4264436DB1
          9703428A2ABCD6E1E349ADA7436D3C73E89DED30FCD7D68B3FEA1525D339B716
          A9030D1C35F2BC031D3F107D68E33D5A5D4BAF26A634CBE0394E97FB22F543E7
          063EBF6DF1C20F57DEE9F31C6A9553DF1CD54EC3F8AE4D30B4FD0C502B75593D
          F83171AC8ECDF3F3A3754874546204283EAEB6A8A3EDDBE1D46F0EF3CBBB9612
          A23E6D6A68144EAF7B0E92AD13CC2475A9FD4F02E405D774DE464C5A6D03B9D8
          CAE93168AE799F2D2761D91807E1DD1EE8FC9D0144CB93373B49DCFF0F604A2A
          7E2F41780F824C8F369909177D20B8A48A5D2AFF0546223617F50AA343000000
          0049454E44AE426082}
        Name = 'PngImage0'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000018000000180806000000E0773D
          F800000006624B474400FF00FF00FFA0BDA793000000097048597300000B1200
          000B1201D2DD7EFC0000000774494D45000000000000000973942E000002BD49
          44415478DAB5957948146118C69FD9ACF558512A5D6FC948C4D074B5BC30C242
          3484288B2893C48AA2880E108910F5DF88A2F08F02C9400AA2C334DD95525B88
          2C330F8A2C520B49DD5557D43CD6D963BEBE996FCBDDE80099FDE065DE993FDE
          87E7797F33C3C1CD8773BB80CFE19A047F6FE5557F6F4F59074F2F2CD2E2CF71
          C9A54DA4604BC2B2072DF076F0560205CD627CC60AC3A4055BE3FC60B513DCED
          EC051773BA896842D7FFCA8A38E5F6BF5EA0CDD4AC0D69B1BE30F3022C54A867
          600E3525D168E99EC6656D17B8A0E20612A18A58B603410042D6AC4278801226
          EA606CCA8AE46815BD5AF07CE0333875711D498D0A464CA4122B14F2ECDC4EAD
          7D1AE2F1FA8B015CF0913A52BE3709C773C26519FEF3DC6CFE86CA0734A2B063
          8FA9800647B3E515A87E2A0A74838B3C514F2AF23528DA1186D9513DBEB61E80
          6057511AC2109F5504537F1594BE26B65941F4EF28DB6F6565D70F8346E45F31
          E376CB302A1E5281A893A240120AB342313BA4C7F7BE6BF0A4EF44C75B233651
          012F7F2356AF6B6643795A0BB4161D35EFB837D39A63BDB6BB173B2F4DA1B66D
          840AD088369C6A90222AD8168AF17E3DDA6FEDA6C316A154A722222E07831D55
          58E935BCE4C0E670E0DC3B39A2AF010EDD20B8A31F6111C59C69901CECCF0C91
          7507F75E8C32071BCF3E9128DA97112CABC0FD97064651FCF94629A23D69F20A
          3C7A65601125963491721AD1AE1435A3A8CD4191E90F1491BF10243EB3B85254
          DF31864A31A2E4522D15D0206FB39A51F49151F4A6D32809B8506471A2C8ECA0
          C8EC4A91AEAB17B994A2C64E51803A48B9A0951CE426052E5124508A02FF4191
          E0E4C4EEDA4FF28C225DD73873907E512709642706C8BA83673D138CA2CCB266
          69C9DBE3E515687D37C1969C51A62585E9B130CDCFC1267E7B65381E0A05D6FA
          A850DBDE07CEE360F5F5203F9F3877FC328D33F3EFDDFFD377B7C00F81D76846
          E8A838D60000000049454E44AE426082}
        Name = 'PngImage1'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000018000000180806000000E0773D
          F800000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E000005E549
          44415478DAB5557B50547514FE7EF7B5BBDCDD855D4044791468B4016ABE7214
          490DD18629B39934B1B4981E9AA958A395CF4A9BD422682AC73F444D7174344A
          6D281531C812B5C047884F141F88222CCBEEB2ECEE7DF5BB6A9AAF9A66ECCC9C
          7FEE9C73BEF3F87EDF25B84FC6463FCA114660E5867D81BF7F27F70B60D0B839
          232CA1E162E9D68DDB948B7B7DF711C01E92F1DADCECB75F7F7E4EB3CB2717AD
          DB94BB7DE57B25FF08608943F89333D2F32D21A166689AC6100286053975F644
          53D9C2E3D36988BE06A67FF6A2017DFAF47D27FDB1D49116030403CF636F6D43
          D3EAC2C29175655F1EA431DA5D011ECC343F3B33EFDDE2302E1CB436585A5D81
          848DBF7CEDFB2E67FF03B0A5047A3F3D39AB7FEF947989F15D1C461EE058029E
          21301A04ECDC5B5BBA63FB8FD32FEE2A387A37002663BE237FEC9809D3884213
          09439359B4069AB176FB5AE7A1CF230627674D7BD591FCC8B828BB394AE06861
          8EA54EC031349E82C88A162CDD5DB5FEA71F36CFBA03C094C0C4BDB8F4896F52
          127AF603540A400BB01CEA5A6BB0794BF549C9F995FA40B7B824D108D8CC3C04
          81838167E89484EE5B435052517BAE0D87CF78E0395EBEE40E80A4B1D6E15939
          830BA36C91B17A92DE913EFE1F8DFBD56D459E3D6E69451AC34A888EB1E2E144
          3B38DA364BA7941415DE0E09F5E75D6838EF81CAF0089CA9D87A3B0019F159D4
          D49E7D933EB618CD217A4F3CCB8061541CACAB7697AF747FD470FC9904D6C0DB
          7B8C7E6958547C7C38C35E2B21C92AFC0105C776EFBE78E5C0CE72CA0A169E73
          1584EFDCCB943A306B745464441A212A2F74750F0A89240EDE7604298E567A38
          1E6EF522AA7FABAFAEDAE2C93EBF553DEE18333BA37BD6A442A3D91CA74FA09B
          2CC970367BB59AE2E59F5E2A5DFCCE75866AA473DAA4C4ACAC516BFAF57C78A0
          1ECB6880BF83C1C6539F2039B3884E40E0F505B4BA4A69C3FE7C795A7B93AD75
          C4C2E2A9518E3E8BCCA251D4011455BBDAFDE92327DD47BE5F9BD354B6B4F8C6
          4A1E9B583074E0A0F44DDDE23A85EB47D257D2D8AC6043D53CF591216B247A02
          04FDC457FF333E3CB84C5DD63535534C7FEBD3FC98EEC913C24318C2B340870C
          3479341CAAF8E57075F1AAF19EAA553537001E9FBCFC83E1A3C6CF371BF44379
          29EFBD38D5E8C78665B38A4CBE1D5B6808B95C136C5065D4D27857E6DCD5C98E
          B4B4F58E87125363C46B45AE50613876C9AFFD5A525AB4A7E08D5CD57BC179F3
          A8B92B360E1BF5C2730C65C1E5603EC22CCD50140E8AB7E1B43584BD1C605C28
          5C5432FBF44EB55C4F189BB7F9E91EE943D775EB2C9AE343E93AE95BB9D0061C
          AC777A776DD8B4A07AF9942FF49BDF00E83F69F556C790ECA7021D2D888D7913
          03127A42A087157801022BC0A59D45EE8B79D967CBB4F57A42C2E8C593637B0F
          FFCA162690300B0F5E60F5678C36B7FB5CE59A25AF9CFF797DE92DB4EC3E72DA
          CCF85E992360F83DA657E6B7490E5B7F88820881A30F88E3D112A843E11725F3
          62BB99AA3515A8ABB1F472B9BA64311C6FE0058197FD9CDBEFB4D54A7EB9F65C
          65C95A48EDCE5B00A887EADE6706BB2075347222F84EE862894584291A21BC05
          AA16C495B6C6004338CA150D2A3D8622CB9AA21004148DD41CABAB3B50D63CB1
          B648ABB9BE1AED76009822D129238FFD263A41196CE44027E01066B22254E802
          33170D910FA7526000A1DAA8683224B5037ED943F5C9898ACA9367AB2ABCCFD6
          AF52AAEF269C5701BA8FE13206BCAC14DAED8813299B448187854E62E26D3030
          567A0B110C61E93432EDDA4369D98A76A5092DED2E946FD37EAF2961C7BB774B
          27EE05407ACC60739286212FD216126A358AB01AECB019A361162260E6A9DE10
          13A570103EC90D77A0051EEA6DC16634381BB57D3BFCEB4EAE5373954B5ACB3D
          01625F61A784F55017DB2339D16AE560117998AF2B254B382A030C7C1D0A3C1E
          19AD2E092E974C5D426B8BEC433D79DFB9452A40F02635EF00B0A7B143C4446D
          92498485FE2FC01B40694A65E39ACCD07741AF47D3A520E5BD9FFECEE8FF2CD0
          0112EC20978247B582F613EA21DCC3FE5253C37536B1F86FA677EDD2B5EEDF00
          FE37FB138923613760AC8B400000000049454E44AE426082}
        Name = 'PngImage2'
        Background = clWindow
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D4948445200000018000000180806000000E0773D
          F800000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000049249
          44415478DAA5956D4C535718C7FFB78552DAF2DA0A14024E70208222E2440804
          E56504C72251999963580C6E3A3B07736F8E0F6E900DB60F6E8CCDB1B081812C
          C00061098180039B189DE032C5318713C22820054A6DA12DACEDEDDD2908296F
          2AF3499E9C739E73EEFF77CE739F732F052BFBB8F00E9BA1FF3DC0980D050F26
          546F7F959FD480A734CA7A905BD4E363C3A27F98D66987F2DE0BCF785AF16580
          2F2EC82526E3CCE9A9496D66EEE9ED1DD673EF9E9209188639606618CDB9AF63
          9FF8648B008515C36D5C0E3D3E3CF4409A7B3A446989BD734A664F5148E20938
          EF7B7A39868D2B759A318526D76434959C2FD9AB5F13E07CD5C84D1E979EE9B9
          21CFD74F685924A4B4B5B57DDE7BBD7376D036B1C0DB578451851657DB7B14F2
          016541714972E11A4F3054486BB5C70D1A9D82CD6171C607D5FA4D41EE9EE151
          CF70F90E5C98CC148C460623C31AB435DF56DD1F9A909695EFAF7C6280F4448B
          9F50EC541E1CB13172E0961C5B43DC1014220645B160A231EB46E234718D7A06
          F59557558A1155AE81A4ABAAFAB0FEB1802369B51B5DC5AE154E0E825D717BBC
          1118EC0E86A116C467DD34D7D2666050AE82ACF59662A05F515055FD4AE16301
          478FD40BB9767645317B7C5F4E7CE1593060CDEE76198088D3A4359A180C0DAA
          D0D2D8A91A19564A6B6BD32B1F09C83AD9BA2F24D4BD343925C0D59E6737276E
          9E13A597A4C8E2C68771BD4E8FB2E2A63EB57A3A9D40AEAD0878E35813679D1B
          FF4AEAA1CD3BFD03458B766B0D581AB761031E22E0F3FCE67FEEDD536610806C
          45C0F1CCC6D81DCF79B6A64B42D8149BB590EB79A7978A933E65D4C0C3F42B1C
          D6872127EFB747038E1DFD5992921A5A1617E73DBBABA5A2D6E9B2C42C26EE7E
          15DC07ADD0B2FC90D39472E5BE4E9C4600F21501E4054BE293B7974544FAC05D
          8805C8A2CA793826371BCE0E00BFDE1308D801B06DA0EB68FF854F69DEA45E47
          CF8A8023693592F098A0B2E8DD817012006E04C230CBC549084E7C806B07FC75
          310F3EFA5208A21281892103BA5A9B401BDF2210F93240DAE16A7B7B1EE7A788
          98CDF13BC37DB942171B380AE6E6E6ABC522EEC8B3F44D90C9FA70A1F4FAB5AC
          2DDF5CDAE5D5958E3D191BA01903FE68EFC4B426751EB2A84C5F4AADF011AE73
          3C1311B5292D66B7BF40C09BDBE9ACB85E01EE702DCCCEC168FBD31D0D0DDDBD
          6AF54C464D42FA75F2E87E38BA7D8B6D89AEE8BF496E60F7970490BD0C60B183
          07CB45CE2EFCB37B5F0C9546446E008F0B70180DD85D9FC05627C3E4A801353D
          89BD97FBFCB37FACCE6CB43CC37C0736285626784E9FC26CB2C7F4D43E02B8B4
          2260A1AA5EAB2B4A480C964447FB0A5C38E3B0E9CC02CB590F4AE40574D4AB30
          A5FC108CF97B22442F408030E25A12BBB3E24D5E7A120FB1734E6C5C4066F84E
          2FC1ED962A04AA0B0CEB776FE180E708FCDEACC2E4D809B2F4221134ADA6B32A
          601E2214F2CFFAF8B848FFBEABE84DF2A8FBEC5050EB47D81AEF052737E07259
          3F4C860FC8D2BAF993AC0960053A499A1BE41275925484826D5B8C908430F2C5
          6391D2AC2373520218FDDF006B2300CB9F2E9240F261CB156166EA0C1937AE96
          A63503AC207EC4498DE12E1137ACB6F63F88303437171E96350000000049454E
          44AE426082}
        Name = 'PngImage3'
        Background = clWindow
      end>
    Left = 49
    Top = 344
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
  object PngImageList: TPngImageList
    PngImages = <
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000030549
          44415478DA63642011FC7F2567F5FC924766E7CCA32513575F7DC90893E0305A
          C5F4E7EF3FB63F17237EB01AAC3666FAF54AE7E7B5EC85289ADFCA983330FEDF
          7EFF8CB8E0D6439237366E3F67033740C27E6B9C8D9144C686BD775B62820D96
          8809F3094E9EB6A4F9FBB5923A8466C6ED0C8F3F08FE7FF693E1DF570786097B
          DF97800D60D45DCE9319A677BC214B4DA9A8F73A67538E2AA3AC180743EDAC57
          0C13272C697AB8BD67A7A810CB16864740CD4F7F31FCBD2FCFB0FCE4E71D718B
          9EC7820D9076DA51B4A8CDB28A8F8745888F9B9971E9D6470C3181B20C82FC1C
          0C2B36EEFB1FEF94F093F7D5078EFFCF809AEF81347F016A7E1603D4FA969159
          77857894B7CE9110771925617E162646A0917FFF31306CDCFF842131448E4195
          D39181EDC535066C9AC1AE97B0DFD59313AD5FA4A1C0CEC8CCF49FE13F032303
          88FCFF9F91E1C0B1DB0CD5CE0B19C43F2F62F873578C61F2618EDBC52BAF58C2
          34830D882DE8EEB036642EDF764C93414D4D9F81839D914180979981978B89E1
          CBFBE70CF7EEDD674837DAC5F0E0C91F868D9FF2FE2F5BB9BDE5FBF5E23AB801
          6B67AA24CE3BE05D2926EFA6222D21C0F8E19B1C033333231033317CFBF48C81
          9D9D83E1C1AB1F0C89F15A0C62429C0CCB56BD62983B7F71F3F7EB90D8616467
          6364D65261570A890DDABCE1B4B7BA16D015FC8282608FFCFACBC0C0C6C2C4F0
          1B1826CF5EBD63888850669012E1609832E329C386D53DE9BFEE4F98058E052E
          0E26C6BE6AD1EC53AFE3832C4C241C371DD1645050D20346FE7F869F7FC01498
          E6E4F9CEE06629CF50DAB4FFF3C35355D1FF3E9EDDCC889CD2D6CF514998B3D7
          BB5A44CE4D59565280F1E5273906262646869F4097BC7BFF95C1C6589061DA82
          F39F1F9DA94EFDF7F1CC2A50FA423100E69D6090774EF9A8ABAAE83170F30A82
          63E5DEE3770C8F1FBDF87CEF441548F34A7820A2671664EF98194B38AE3FACC9
          C0C6A9C870F2DC8DCF6FAEB4A068C66A00B277E6EEF3AE7EFD2F52E5CEC3C79F
          3F5CEF4AFDFBE1F44A7475380D007947459E59FA1E537DE4CF575B6FFE7B7F62
          033675003D684674E4F263690000000049454E44AE426082}
        Name = 'PngImage0'
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E000002F149
          44415478DA75927B48537114C7CFBD9B9B7373A999CFA553E78252D3C86869BE
          2B358CF241203D45FF482D8A5252A43F8A44099FFD53A4294608118449B41274
          3A9D4D99AF5EA4CE57AE7473E9746E779BF7DEAE42905E3D70FE38E7777E9F73
          BEE7F743601B93B577ECE3F2B8E12C16CB1D10C442128476D5B8AA88381E39BB
          B516F93F68BD1587E0B1050126E38A9787975F575C4CF8465EDE256759AD96D0
          A52543605A7ADACB1D01B79384518971BA0B92F4472E305355C78B1E93AEE7DF
          3764207B842777FD98E548944F0BBED776FF9EA2013AABC11D2740C14411FF3F
          C6409854ABB19F822CF12CFFACA1D839F54D484C7EB44A2D98AABDFF50FAA267
          219F0618AA631459314169F9ABBDB0E6731AC242C5C0E039DBF436144F3425D8
          4B0EF280EF150E3AAD911C98E42727E67C906E02B4577024CDAAAC8EE0A44C76
          7ABC0FB8B97B028659802448502B2BC1CF5A0A7C71DEC60DCDB7D7CD8294E9CC
          4D0076FC5BC19D54A7D1EB69228E9B9B0710040138A5892449D02EE840332E03
          023180C8655EF3B9BF3B2521AB7D7013C02FBBB754FE4054E4EAEC086C367B03
          B086E3A01AEA040FB700309BAC70A991049DC5AE71A6467495B6832B55238AE2
          24A6C45F24A69E1E01BD5E0F235F062028281450840140E050D862030DEAAD6A
          CB460FD30025F583D2C20CBF534C260B180C0628FB9520F4110297CB033386C1
          F2921E3E8E394288D85711B71F89A0018EDC1DCEAE48459E058B7D014511D0EA
          67C181CD07046552CBC4C062B54165DF6E70E1A26565E79C8A6800D78B9DDCBC
          64C1D76BB11C5F6A776032AF50525060A076407D63908D5AA1BCDF737EB9BB2C
          D420AF9EDBF62706E4F685DD8CE52892C2B8F61866A2BAA380994D306D70801B
          8F27E61627DA3257876BE454294E394903C8641DE567CE678F1E4AC8C93D1179
          40E0C8B343C6A7E616DFB5F4E8D5AAA627405AC6A9B251CA17B69DE0A8E458D4
          A75EC5FA789408B05F57B63E5849C9BDCBCF1BEA9B7E6934AD54ACFDD79D06D8
          C9BCBD059E5AEDBCCE66B3AD6D3DFB0BDFEE2E202446E4FD0000000049454E44
          AE426082}
        Name = 'PngImage1'
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B474400FF00FF00FFA0BDA793000000097048597300000B1300
          000B1301009A9C180000000774494D45000000000000000973942E0000029749
          44415478DAA593CF6B134114C7BFFBA393DFD59A6E3055C490FEF05A2137F1EC
          4928F424FE011E52BC15721129B45E7A28140A3D0503D6A6562D94582F0D9A1E
          3C28947A911E6A3D68432142B5D9CD667666D7B71B6B28220A0E7CF7CD0E6F3E
          EFBD79330AFE7328FEE7D1B584AA2ACA7955674C6521683D21A88C41D17BE049
          094F38909CC375DA646D4F3AFCDBED37D6D12FC0B31B7D977A43DA8EA7B1B38A
          1E02F430941E0622C1152290B06D88760B8E6DBB82F3E27E53DE296C5B22006C
          DCEABF323AC03EB8AE0A2ED091542024D9B624EB92F525D02699B6BBBEF1858F
          3FFCC87900784180AB04203F70EEA1ED78E00E2025CDB90B21FC7F0270490037
          00BC3C70C64BFB3F0177AFA72F8E8DDDACC5CF0D640441A4EB51542F007087D2
          A712381105C9A1F4F676DE3D58DDDABEF7FE48764AC866B346A954AA6432999C
          9422487977F7139A4D13BAAEC1322D38045155201A65D8AABDCACFCDCD2DD2D6
          0E606464C4585B5BAB8423677266B3E37C78D880767C807E34F0592461220AC6
          34C46261D46A9BF9E9E9E92E607878D8585D7D5A69BBD19CA247A0BBC7308F9B
          881FBE0D5AD8D2E3F8CA2E221E8F507612B5D79BF9A9A9A9D38095952795664B
          CBB5694995165A2D13301B48EA4DD4ED285A1EA3E81118A9249550CD4F4E4E9E
          062C2F972BDF2D35E777C0075816F5DCE1482422B0ED363CCF43221EA7F3BA8C
          F5F5E7F98989892E606868C8585A5AAE70C97236B54A912DCAC0268083C1EC05
          78AE8B503804C33002D0ECEC6C7E6666A60BA0D3371616162AE9F4408ED395F5
          DB76224D53491A7A7B7B83CDF57A1DE572395F2C16BB80743A9D2C140A8BA954
          6AD4BFDEBEE36F8F46510231C6DC6AB57A7F7E7EFE312DCB004011F4582C3648
          D3BE93F7F1C7D7A728924ADBB32CAB81BF39FFCBF80177417720EA59B2E20000
          000049454E44AE426082}
        Name = 'PngImage2'
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          61000000097048597300000B1300000B1301009A9C1800000A4D694343505068
          6F746F73686F70204943432070726F66696C65000078DA9D53775893F7163EDF
          F7650F5642D8F0B1976C81002223AC08C81059A21092006184101240C585880A
          561415119C4855C482D50A489D88E2A028B867418A885A8B555C38EE1FDCA7B5
          7D7AEFEDEDFBD7FBBCE79CE7FCCE79CF0F8011122691E6A26A003952853C3AD8
          1F8F4F48C4C9BD80021548E0042010E6CBC26705C50000F00379787E74B03FFC
          01AF6F00020070D52E2412C7E1FF83BA50265700209100E02212E70B01905200
          C82E54C81400C81800B053B3640A009400006C797C422200AA0D00ECF4493E05
          00D8A993DC1700D8A21CA908008D0100992847240240BB00605581522C02C0C2
          00A0AC40222E04C0AE018059B632470280BD0500768E58900F4060008099422C
          CC0020380200431E13CD03204C03A030D2BFE0A95F7085B8480100C0CB95CD97
          4BD23314B895D01A77F2F0E0E221E2C26CB142611729106609E4229C979B2313
          48E7034CCE0C00001AF9D1C1FE383F90E7E6E4E1E666E76CEFF4C5A2FE6BF06F
          223E21F1DFFEBC8C020400104ECFEFDA5FE5E5D60370C701B075BF6BA95B00DA
          560068DFF95D33DB09A05A0AD07AF98B7938FC401E9EA150C83C1D1C0A0B0BED
          2562A1BD30E38B3EFF33E16FE08B7EF6FC401EFEDB7AF000719A4099ADC0A383
          FD71616E76AE528EE7CB0442316EF7E723FEC7857FFD8E29D1E234B15C2C158A
          F15889B850224DC779B952914421C995E212E97F32F11F96FD0993770D00AC86
          4FC04EB607B5CB6CC07EEE01028B0E58D27600407EF32D8C1A0B910010673432
          79F7000093BFF98F402B0100CD97A4E30000BCE8185CA894174CC608000044A0
          812AB041070CC114ACC00E9CC11DBCC01702610644400C24C03C104206E4801C
          0AA11896411954C03AD804B5B0031AA0119AE110B4C131380DE7E0125C81EB70
          170660189EC218BC86090441C8081361213A8811628ED822CE0817998E042261
          48349280A420E988145122C5C872A402A9426A915D4823F22D7214398D5C40FA
          90DBC820328AFC8ABC47319481B25103D4027540B9A81F1A8AC6A073D174340F
          5D8096A26BD11AB41E3D80B6A2A7D14BE87574007D8A8E6380D1310E668CD961
          5C8C87456089581A26C71663E55835568F35631D583776151BC09E61EF082402
          8B8013EC085E8410C26C82909047584C5843A825EC23B412BA085709838431C2
          272293A84FB4257A12F9C478623AB1905846AC26EE211E219E255E270E135F93
          48240EC992E44E0A21259032490B496B48DB482DA453A43ED210699C4C26EB90
          6DC9DEE408B280AC209791B7900F904F92FBC9C3E4B7143AC588E24C09A22452
          A494124A35653FE504A59F324299A0AA51CDA99ED408AA883A9F5A496DA07650
          2F5387A91334759A25CD9B1643CBA42DA3D5D09A696769F7682FE974BA09DD83
          1E4597D097D26BE807E9E7E983F4770C0D860D83C7486228196B197B19A718B7
          192F994CA605D39799C85430D7321B9967980F986F55582AF62A7C1591CA1295
          3A9556957E95E7AA545573553FD579AA0B54AB550FAB5E567DA64655B350E3A9
          09D416ABD5A91D55BBA936AECE5277528F50CF515FA3BE5FFD82FA630DB28685
          46A08648A35463B7C6198D2116C63265F15842D6725603EB2C6B984D625BB2F9
          EC4C7605FB1B762F7B4C534373AA66AC6691669DE671CD010EC6B1E0F039D99C
          4ACE21CE0DCE7B2D032D3F2DB1D66AAD66AD7EAD37DA7ADABEDA62ED72ED16ED
          EBDAEF75709D409D2C9DF53A6D3AF77509BA36BA51BA85BADB75CFEA3ED363EB
          79E909F5CAF50EE9DDD147F56DF4A3F517EAEFD6EFD11F373034083690196C31
          3863F0CC9063E86B9869B8D1F084E1A811CB68BA91C468A3D149A327B826EE87
          67E33578173E66AC6F1C62AC34DE65DC6B3C61626932DBA4C4A4C5E4BE29CD94
          6B9A66BAD1B4D374CCCCC82CDCACD8ACC9EC8E39D59C6B9E61BED9BCDBFC8D85
          A5459CC54A8B368BC796DA967CCB05964D96F7AC98563E567956F556D7AC49D6
          5CEB2CEB6DD6576C501B579B0C9B3A9BCBB6A8AD9BADC4769B6DDF14E2148F29
          D229F5536EDA31ECFCEC0AEC9AEC06ED39F661F625F66DF6CF1DCC1C121DD63B
          743B7C727475CC766C70BCEBA4E134C3A9C4A9C3E957671B67A1739DF33517A6
          4B90CB1297769717536DA78AA76E9F7ACB95E51AEEBAD2B5D3F5A39BBB9BDCAD
          D96DD4DDCC3DC57DABFB4D2E9B1BC95DC33DEF41F4F0F758E271CCE39DA79BA7
          C2F390E72F5E765E595EFBBD1E4FB39C269ED6306DC8DBC45BE0BDCB7B603A3E
          3D65FACEE9033EC63E029F7A9F87BEA6BE22DF3DBE237ED67E997E07FC9EFB3B
          FACBFD8FF8BFE179F216F14E056001C101E501BD811A81B3036B031F049904A5
          0735058D05BB062F0C3E15420C090D591F72936FC017F21BF96333DC672C9AD1
          15CA089D155A1BFA30CC264C1ED6118E86CF08DF107E6FA6F94CE9CCB60888E0
          476C88B81F69199917F97D14292A32AA2EEA51B453747174F72CD6ACE459FB67
          BD8EF18FA98CB93BDB6AB6727667AC6A6C526C63EC9BB880B8AAB8817887F845
          F1971274132409ED89E4C4D8C43D89E37302E76C9A339CE49A54967463AEE5DC
          A2B917E6E9CECB9E773C593559907C3885981297B23FE5832042502F184FE5A7
          6E4D1D13F2849B854F45BEA28DA251B1B7B84A3C92E69D5695F638DD3B7D43FA
          68864F4675C633094F522B79911992B923F34D5644D6DEACCFD971D92D39949C
          949CA3520D6996B42BD730B728B74F662B2B930DE479E66DCA1B9387CAF7E423
          F973F3DB156C854CD1A3B452AE500E164C2FA82B785B185B78B848BD485AD433
          DF66FEEAF9230B82167CBD90B050B8B0B3D8B87859F1E022BF45BB16238B5317
          772E315D52BA647869F0D27DCB68CBB296FD50E2585255F26A79DCF28E5283D2
          A5A5432B82573495A994C9CB6EAEF45AB9631561956455EF6A97D55B567F2A17
          955FAC70ACA8AEF8B046B8E6E2574E5FD57CF5796DDADADE4AB7CAEDEB48EBA4
          EB6EACF759BFAF4ABD6A41D5D086F00DAD1BF18DE51B5F6D4ADE74A17A6AF58E
          CDB4CDCACD03356135ED5BCCB6ACDBF2A136A3F67A9D7F5DCB56FDADABB7BED9
          26DAD6BFDD777BF30E831D153BDEEF94ECBCB52B78576BBD457DF56ED2EE82DD
          8F1A621BBABFE67EDDB847774FC59E8F7BA57B07F645EFEB6A746F6CDCAFBFBF
          B2096D52368D1E483A70E59B806FDA9BED9A77B5705A2A0EC241E5C127DFA67C
          7BE350E8A1CEC3DCC3CDDF997FB7F508EB48792BD23ABF75AC2DA36DA03DA1BD
          EFE88CA39D1D5E1D47BEB7FF7EEF31E36375C7358F579EA09D283DF1F9E48293
          E3A764A79E9D4E3F3DD499DC79F74CFC996B5D515DBD6743CF9E3F1774EE4CB7
          5FF7C9F3DEE78F5DF0BC70F422F762DB25B74BAD3DAE3D477E70FDE148AF5B6F
          EB65F7CBED573CAE74F44DEB3BD1EFD37FFA6AC0D573D7F8D72E5D9F79BDEFC6
          EC1BB76E26DD1CB825BAF5F876F6ED17770AEE4CDC5D7A8F78AFFCBEDAFDEA07
          FA0FEA7FB4FEB165C06DE0F860C060CFC3590FEF0E09879EFE94FFD387E1D247
          CC47D52346238D8F9D1F1F1B0D1ABDF264CE93E1A7B2A713CFCA7E56FF79EB73
          ABE7DFFDE2FB4BCF58FCD8F00BF98BCFBFAE79A9F372EFABA9AF3AC723C71FBC
          CE793DF1A6FCADCEDB7DEFB8EFBADFC7BD1F9928FC40FE50F3D1FA63C7A7D04F
          F73EE77CFEFC2FF784F3FB25D29F33000003964944415478DA95936B4C5B7518
          C69FFFE969CF694B5BC08E4291815CA59B30D8064E230166BC2C6C264234338B
          98A95350AA9BBB28D1C44B5CE2361458040DBB24EA362F6CCAAAC996902D33A6
          8B73437003A688B66385D5D6D2D29E5ECF397F4B6762F49BCF97376FDEE7F97D
          7A1F925E85946409D067B030ACC94548C98350205B11C2E5434A186E6B078328
          BC210FCC1A639B7B766A381217A620C741FE0BD0D5E620A8E45200331BC695C3
          AA14804A6144A5B0F9CEA2F2CF267F9DE8BDE6767D81A81B24A33A994E9AA545
          40A652C7571775F1C6340D0322A7CBBEF18B1F24DEE173B740ABA40D8DB595FD
          D68EB565FD7D679D874FD8EE91E747678866590158D59F90224170E5B91DB69E
          4FBA192561627218874EBFE7F9A8D35551B5E285D7EF5F5FD55ABDF256DE3B1F
          4681498F7DFB4ED9CF7CDDDB4490DF0CA6A0022AE9002C557CCFE6675AAC1AAA
          82824B60E0CBA169CF85B6999DEDCDF5BFFB050484387896406614A8BFDD848E
          8EEEA3044BEF034A1E07849FB0BE75F0877BEBEF5A45222A2478370EEE9F38E7
          187D29277F5591B97879499A321916658A5F7E9E155D930E1FE7738E13B6B0C9
          58686EEA22CA84B47CDDA5E6929AA03ECF1CC55CC4899E9DCED782A798FD55AD
          DD278B5B36D64951019455E3E291816F660677EF804A0C90AC3B366DB4BEB8EB
          E8B20213A69D3CCEC8CF8AC50D27E9E56F1138DF195A9D5DF284AF6243DB8F96
          B535857282C227109CDEF572D7EC6FC3DBA5D07590BA8707CE6D7EF5A9BA85E0
          1CC6A76FC8478E3F6F6338FBD59868D470768DD5D2B063EBA6BD5BF6588C2A76
          3E067C7562327EACF3D135A2303F02290AF260BB6D6265CBDDE501FF1BC8BE45
          A6728CCE84437FDCD87BDCFEBD2EBED45AAA7CB2AF657B6B5BBE5A4444CBC136
          343C3268DD50071A11000588A571F7417D2D53BDAD55AE30E805C6A033C2EDBF
          465FF970E8734F847AB49EA27C03BFA294D7428A05D29C9EB1D1637EC7858F09
          A34C3D20E175C5D0AD0B74BDFDE603DB5C91B3306BF35099F908E58991B08C1A
          31C92B4B9228DAE73EA53DBD8EAD0BDF99FAE3DE0018567113C036E665D53645
          6C8F3D5458E38B8F209337C1C89541C7658121480202081327461C3338F0AEF4
          1CF5A9FAE4200730F42640FBF492B2D24AE152F56AAA4D579990A1CE8141BD24
          79E7E01782F02E78E08DBA7075CC1B1DDB830A86C314F93B9C02E81BD57A9AC1
          BDA5318846804D1563D1B0D80D310124E2C9995CE4EBD1F38A2B783F59CB7FD2
          8B004AFFB5FF6FFD05F5748A3694A3668A0000000049454E44AE426082}
        Name = 'PngImage3'
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          61000000097048597300000B1100000B11017F645F9100000A4D694343505068
          6F746F73686F70204943432070726F66696C65000078DA9D53775893F7163EDF
          F7650F5642D8F0B1976C81002223AC08C81059A21092006184101240C585880A
          561415119C4855C482D50A489D88E2A028B867418A885A8B555C38EE1FDCA7B5
          7D7AEFEDEDFBD7FBBCE79CE7FCCE79CF0F8011122691E6A26A003952853C3AD8
          1F8F4F48C4C9BD80021548E0042010E6CBC26705C50000F00379787E74B03FFC
          01AF6F00020070D52E2412C7E1FF83BA50265700209100E02212E70B01905200
          C82E54C81400C81800B053B3640A009400006C797C422200AA0D00ECF4493E05
          00D8A993DC1700D8A21CA908008D0100992847240240BB00605581522C02C0C2
          00A0AC40222E04C0AE018059B632470280BD0500768E58900F4060008099422C
          CC0020380200431E13CD03204C03A030D2BFE0A95F7085B8480100C0CB95CD97
          4BD23314B895D01A77F2F0E0E221E2C26CB142611729106609E4229C979B2313
          48E7034CCE0C00001AF9D1C1FE383F90E7E6E4E1E666E76CEFF4C5A2FE6BF06F
          223E21F1DFFEBC8C020400104ECFEFDA5FE5E5D60370C701B075BF6BA95B00DA
          560068DFF95D33DB09A05A0AD07AF98B7938FC401E9EA150C83C1D1C0A0B0BED
          2562A1BD30E38B3EFF33E16FE08B7EF6FC401EFEDB7AF000719A4099ADC0A383
          FD71616E76AE528EE7CB0442316EF7E723FEC7857FFD8E29D1E234B15C2C158A
          F15889B850224DC779B952914421C995E212E97F32F11F96FD0993770D00AC86
          4FC04EB607B5CB6CC07EEE01028B0E58D27600407EF32D8C1A0B910010673432
          79F7000093BFF98F402B0100CD97A4E30000BCE8185CA894174CC608000044A0
          812AB041070CC114ACC00E9CC11DBCC01702610644400C24C03C104206E4801C
          0AA11896411954C03AD804B5B0031AA0119AE110B4C131380DE7E0125C81EB70
          170660189EC218BC86090441C8081361213A8811628ED822CE0817998E042261
          48349280A420E988145122C5C872A402A9426A915D4823F22D7214398D5C40FA
          90DBC820328AFC8ABC47319481B25103D4027540B9A81F1A8AC6A073D174340F
          5D8096A26BD11AB41E3D80B6A2A7D14BE87574007D8A8E6380D1310E668CD961
          5C8C87456089581A26C71663E55835568F35631D583776151BC09E61EF082402
          8B8013EC085E8410C26C82909047584C5843A825EC23B412BA085709838431C2
          272293A84FB4257A12F9C478623AB1905846AC26EE211E219E255E270E135F93
          48240EC992E44E0A21259032490B496B48DB482DA453A43ED210699C4C26EB90
          6DC9DEE408B280AC209791B7900F904F92FBC9C3E4B7143AC588E24C09A22452
          A494124A35653FE504A59F324299A0AA51CDA99ED408AA883A9F5A496DA07650
          2F5387A91334759A25CD9B1643CBA42DA3D5D09A696769F7682FE974BA09DD83
          1E4597D097D26BE807E9E7E983F4770C0D860D83C7486228196B197B19A718B7
          192F994CA605D39799C85430D7321B9967980F986F55582AF62A7C1591CA1295
          3A9556957E95E7AA545573553FD579AA0B54AB550FAB5E567DA64655B350E3A9
          09D416ABD5A91D55BBA936AECE5277528F50CF515FA3BE5FFD82FA630DB28685
          46A08648A35463B7C6198D2116C63265F15842D6725603EB2C6B984D625BB2F9
          EC4C7605FB1B762F7B4C534373AA66AC6691669DE671CD010EC6B1E0F039D99C
          4ACE21CE0DCE7B2D032D3F2DB1D66AAD66AD7EAD37DA7ADABEDA62ED72ED16ED
          EBDAEF75709D409D2C9DF53A6D3AF77509BA36BA51BA85BADB75CFEA3ED363EB
          79E909F5CAF50EE9DDD147F56DF4A3F517EAEFD6EFD11F373034083690196C31
          3863F0CC9063E86B9869B8D1F084E1A811CB68BA91C468A3D149A327B826EE87
          67E33578173E66AC6F1C62AC34DE65DC6B3C61626932DBA4C4A4C5E4BE29CD94
          6B9A66BAD1B4D374CCCCC82CDCACD8ACC9EC8E39D59C6B9E61BED9BCDBFC8D85
          A5459CC54A8B368BC796DA967CCB05964D96F7AC98563E567956F556D7AC49D6
          5CEB2CEB6DD6576C501B579B0C9B3A9BCBB6A8AD9BADC4769B6DDF14E2148F29
          D229F5536EDA31ECFCEC0AEC9AEC06ED39F661F625F66DF6CF1DCC1C121DD63B
          743B7C727475CC766C70BCEBA4E134C3A9C4A9C3E957671B67A1739DF33517A6
          4B90CB1297769717536DA78AA76E9F7ACB95E51AEEBAD2B5D3F5A39BBB9BDCAD
          D96DD4DDCC3DC57DABFB4D2E9B1BC95DC33DEF41F4F0F758E271CCE39DA79BA7
          C2F390E72F5E765E595EFBBD1E4FB39C269ED6306DC8DBC45BE0BDCB7B603A3E
          3D65FACEE9033EC63E029F7A9F87BEA6BE22DF3DBE237ED67E997E07FC9EFB3B
          FACBFD8FF8BFE179F216F14E056001C101E501BD811A81B3036B031F049904A5
          0735058D05BB062F0C3E15420C090D591F72936FC017F21BF96333DC672C9AD1
          15CA089D155A1BFA30CC264C1ED6118E86CF08DF107E6FA6F94CE9CCB60888E0
          476C88B81F69199917F97D14292A32AA2EEA51B453747174F72CD6ACE459FB67
          BD8EF18FA98CB93BDB6AB6727667AC6A6C526C63EC9BB880B8AAB8817887F845
          F1971274132409ED89E4C4D8C43D89E37302E76C9A339CE49A54967463AEE5DC
          A2B917E6E9CECB9E773C593559907C3885981297B23FE5832042502F184FE5A7
          6E4D1D13F2849B854F45BEA28DA251B1B7B84A3C92E69D5695F638DD3B7D43FA
          68864F4675C633094F522B79911992B923F34D5644D6DEACCFD971D92D39949C
          949CA3520D6996B42BD730B728B74F662B2B930DE479E66DCA1B9387CAF7E423
          F973F3DB156C854CD1A3B452AE500E164C2FA82B785B185B78B848BD485AD433
          DF66FEEAF9230B82167CBD90B050B8B0B3D8B87859F1E022BF45BB16238B5317
          772E315D52BA647869F0D27DCB68CBB296FD50E2585255F26A79DCF28E5283D2
          A5A5432B82573495A994C9CB6EAEF45AB9631561956455EF6A97D55B567F2A17
          955FAC70ACA8AEF8B046B8E6E2574E5FD57CF5796DDADADE4AB7CAEDEB48EBA4
          EB6EACF759BFAF4ABD6A41D5D086F00DAD1BF18DE51B5F6D4ADE74A17A6AF58E
          CDB4CDCACD03356135ED5BCCB6ACDBF2A136A3F67A9D7F5DCB56FDADABB7BED9
          26DAD6BFDD777BF30E831D153BDEEF94ECBCB52B78576BBD457DF56ED2EE82DD
          8F1A621BBABFE67EDDB847774FC59E8F7BA57B07F645EFEB6A746F6CDCAFBFBF
          B2096D52368D1E483A70E59B806FDA9BED9A77B5705A2A0EC241E5C127DFA67C
          7BE350E8A1CEC3DCC3CDDF997FB7F508EB48792BD23ABF75AC2DA36DA03DA1BD
          EFE88CA39D1D5E1D47BEB7FF7EEF31E36375C7358F579EA09D283DF1F9E48293
          E3A764A79E9D4E3F3DD499DC79F74CFC996B5D515DBD6743CF9E3F1774EE4CB7
          5FF7C9F3DEE78F5DF0BC70F422F762DB25B74BAD3DAE3D477E70FDE148AF5B6F
          EB65F7CBED573CAE74F44DEB3BD1EFD37FFA6AC0D573D7F8D72E5D9F79BDEFC6
          EC1BB76E26DD1CB825BAF5F876F6ED17770AEE4CDC5D7A8F78AFFCBEDAFDEA07
          FA0FEA7FB4FEB165C06DE0F860C060CFC3590FEF0E09879EFE94FFD387E1D247
          CC47D52346238D8F9D1F1F1B0D1ABDF264CE93E1A7B2A713CFCA7E56FF79EB73
          ABE7DFFDE2FB4BCF58FCD8F00BF98BCFBFAE79A9F372EFABA9AF3AC723C71FBC
          CE793DF1A6FCADCEDB7DEFB8EFBADFC7BD1F9928FC40FE50F3D1FA63C7A7D04F
          F73EE77CFEFC2FF784F3FB25D29F330000032A4944415478DA75D36F4C13671C
          07F0EF73D7B3BD260D850ECDC018158352038812A789DA1A24C63F61CC383623
          6FD80BC216DD16B6BDD29898F967C67F115EF1469010C53F89E21CDA2D44896F
          48B60CAD4006CB3040E9FA87D216EE7A6DCFDEEDD72204753EC9E5F2DC3DF779
          9EDFF79E879D397315AB56E5815AB6D1B8A4AFA86875BEA6A5F45028EAF37A03
          5766679556555565FC4F6B6838089606F2F23E48F705834168B4DB579EDDB061
          2D4B3F181DF5E0E9D3672D8A123F4A5DF57D80A02809B5A0201F0420180C7F5D
          5EBEEED4962DC5169EE7E1768FC0E5EA3B4448E7E28F4F9CA8CFDCD3C01D02CE
          85C391DF79DE008BC50C9B2DEBB7DADABDBB6C362B221109376E3C6C27F80B1A
          9F7A07686FFF458FC7132FDDEEE18F097841C0B1AA2AE7F1929235265D0708C7
          EDDBBF3E1E1A9EACA6F133F3C0E50B47E780CECE47B2C3B1C9DCD6F660C8E79B
          EAADAE767EB971A31D845249064C4F4770ADC3757D7BFCC2E15C7106D11807C7
          4F130BA5B093275B06EBEAAAEC91884CF54FA3B0700552298D5E69608CC7E464
          00B7EEF6F5ECE12E7D4BC0C03B404DCD0FF595955B5B2A2A36231D9AA224C171
          0C9AA6C1EB0D428AF3D07CBD581E6A9EE064E53C01CDAF01812E3D0D2091481C
          2F2BB31F2B2D5D6B329B4524934988A211467336929E27C879791ECB121390AC
          5998F418BE9F957171596925CBDFFC39E60144A3D23E51343928C475B29CF0E5
          2CFDB0ACC6692D5F1E68429E3A8AF44E898902C699E5D53F7FF3DF4909AD69C7
          91D637009AD58499999868B55A94A5DAD0479F140D773BECD11C8B919F2B98FE
          4A92034682626A60108D9473138BC59485402459CE24DFEDEAC1EE5D4E3C6CB4
          1F295ECF2E956E62020543FF94B681A4424FA5E01E33EAFD43DC578B01FD6DC0
          40A132C630F8D708628A02E7B6AD0847A299B0EF3D7884DC3FBE09B0D0747801
          0804A7209A4CE8EA76E1B3035599BDC0D1CCFDEE810C54B97307C6C63D34098F
          9FEFDF45C9D8E9572C42E23C109C0AC1F41AF8B47A3FE814CE01CF07A87C3D03
          4C78BC732BE8EA02D7FBE39FACADE3E63C20FBFC7EB34110927470D4C23505FA
          BF7E3F6DAA546625B69C6C66140C267F708A172853599254A9A769DB7F357B83
          82737CE3490000000049454E44AE426082}
        Name = 'PngImage4'
      end
      item
        PngImage.Data = {
          89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
          6100000006624B4744000000000000F943BB7F000000097048597300000B1300
          000B1301009A9C18000002B44944415478DA7D53494C5351143DEFF79796F653
          8AA5D0A240881094C932B8348118773571E1861D2C4C4C1C481C161AE3408803
          6022261A8D22DDE19E1AA32E5C187161808A0295188310DB022DB4B674F8A3EF
          7F0258416FF236F7BE7BCEB913C13F6CF0CE8C030AF6290AA0288AFFC4E59AD0
          4EFFC8DF8E67BDFE0E42D0C5E8888BB330200C412C2242E0659F2C290327AFD6
          7A7604F0F4FB3959C6306761DD352D56ECA9E0C0F322583D0386300887929878
          1FC17220E3A58ADA4FDDA84F640150E691A2DD0677F3A12288A200B3458F029B
          498BF119913E19A93509E3A3017C9B4C794F77D71FDD0450659B38DDD0C1563B
          F52870949A6032E7602D2E523019967CBD564A3894A63E011FDE84B01C4C779E
          ED69F06800437DFE89CA3A8BCBEECC05A3935155B70BE994841FB3714D412E07
          94EDB5221AC9203097C4E2CF38A63EC67C677A1A1A89DA6D5A67707F9315AC8E
          D6CB129457712A03125101922CA2BCDA0C7B711EA6C656E01F8F429D4C6431A5
          9238C9E0ED9956A389795B5A99B76D448A22A2B6A500B6220E619AF0EE451092
          B81E8BAD64F02B2AB491A7B7D6016CC5C66D00D54D665454D9A89A14465F8720
          F2CA666C35AC02F06DE4C9CD69079BC3040B6C3959C932FD7BE4B80346A3012F
          9FCF431494AC78682149A7223AB5263EEE999EB097185C0C93BD5735CD569A08
          CC4E46B3FC92A8D006277CE77A0F346A198FBAA73A38AB6EA8D061DA5240B7AA
          B2DEA42998198BE14FFEC05C022B4B7CE7857E976793F2E1F52F238E32BDDB6A
          33AFB3D06E1D3E560642F77AF45508998CA4F99717E398FF9AF65EBCDBB8B548
          AA3DB8F699A3E3192E74EADD25E566B0AC1E9C95858E8E3616E121080216BEC7
          119CCB78E9F7760A90BDCA1B76FFCA6407C3285DF9858CCB60A493A1DA93C914
          5697249F24900155F67FAF71C3EE5DFAE4A06DA0E7ACDE33FCE7FB5C3B9EF36F
          B6322E251644F2710000000049454E44AE426082}
        Name = 'PngImage5'
      end>
    Left = 46
    Top = 340
    Bitmap = {}
  end
  object ActionManager2: TActionManager
    Images = PngImageList
    Left = 88
    Top = 272
    StyleName = 'XP Style'
    object Action4: TAction
      Caption = 'Ustawienia dla listy wykonanych operacji'
      ImageIndex = 0
      OnExecute = Action4Execute
    end
    object Action5: TAction
      Caption = 'Ustawienia dla listy zaplanowanych operacji'
      ImageIndex = 1
      OnExecute = Action5Execute
    end
    object Action6: TAction
      Caption = 'Ustawienia dla listy definicji plan'#243'w'
      ImageIndex = 2
      OnExecute = Action6Execute
    end
    object Action7: TAction
      Caption = 'Ustawienia dla listy powiadomie'#324
      ImageIndex = 3
      OnExecute = Action7Execute
    end
    object Action9: TAction
      Caption = 'Konfiguruj wtyczk'#281
      ImageIndex = 4
      OnExecute = Action9Execute
    end
    object Action10: TAction
      Caption = 'Informacje o wtyczce'
      ImageIndex = 5
      OnExecute = Action10Execute
    end
  end
  object ActionManager: TActionManager
    Images = CImageLists.TemplateImageList16x16
    Left = 80
    Top = 378
    StyleName = 'XP Style'
    object ActionAdd: TAction
      Caption = 'Wstaw mnemonik'
      ImageIndex = 0
      OnExecute = ActionAddExecute
    end
  end
  object ColorDialog: TColorDialog
    Options = [cdFullOpen]
    Left = 222
    Top = 268
  end
end
