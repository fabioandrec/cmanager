unit CCreateDatafileFormUnit;

interface

{$WARN UNIT_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFormUnit, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  CComponents, ImgList, PngImageList, CXml, AdoDb;

type
  TCCreateDatafileForm = class(TCBaseForm)
    PanelButtons: TPanel;
    BitBtnNext: TBitBtn;
    BitBtnFinish: TBitBtn;
    BitBtnPrev: TBitBtn;
    PanelImage: TPanel;
    PageControl: TPageControl;
    TabSheetStart: TTabSheet;
    CImage: TCImage;
    PngImageList: TPngImageList;
    TabSheetDatafile: TTabSheet;
    CStaticName: TCStatic;
    Label2: TLabel;
    Label3: TLabel;
    Label1: TLabel;
    Label4: TLabel;
    SaveDialog: TSaveDialog;
    TabSheetSecurity: TTabSheet;
    Label5: TLabel;
    Label6: TLabel;
    EditPassword: TEdit;
    TabSheetDefault: TTabSheet;
    Label9: TLabel;
    Label10: TLabel;
    ComboBoxDefault: TComboBox;
    CButtonShowDefault: TCButton;
    TabSheetFinish: TTabSheet;
    LabelInfo: TLabel;
    LabelFinish: TLabel;
    CStaticDesc: TCStatic;
    ProgressBar: TProgressBar;
    TabSheetCurrency: TTabSheet;
    Label7: TLabel;
    Label8: TLabel;
    CStaticCurrency: TCStatic;
    procedure FormCreate(Sender: TObject);
    procedure BitBtnFinishClick(Sender: TObject);
    procedure BitBtnPrevClick(Sender: TObject);
    procedure BitBtnNextClick(Sender: TObject);
    procedure CStaticNameGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure CButtonShowDefaultClick(Sender: TObject);
    procedure CStaticDescGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticCurrencyGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
  private
    FDefaultData: ICXMLDOMDocument;
    FDefaultCurrencies: ICXMLDOMDocument;
    FCheckedData: TStringList;
    FReportList: TStringList;
    FIsDisabled: Boolean;
    procedure UpdateButtons;
    procedure UpdateTabs;
    procedure LoadDefaultDatafileData;
    procedure LoadDefaultCurrencyData;
    function DoCreateDatafile: Boolean;
    function CanSelectNextPage: Boolean;
    function GetDisabled: Boolean;
    procedure SetDisabled(const Value: Boolean);
    procedure AddToReport(AText: String);
    function GetDefaultDataAsString: String;
    function GetDefaultCurrencyAsString: String;
    procedure AppendCommands(ANodes: ICXMLDOMNodeList; AChecks: TStringList; ACommands: TStringList);
  public
    property Disabled: Boolean read GetDisabled write SetDisabled;
  end;

function CreateDatafileWithWizard(var AFilename: String; var APassword: String): Boolean;

implementation

uses CRichtext, FileCtrl, CXmlFrameUnit, CInfoFormUnit, CReportFormUnit,
  CMemoFormUnit, CAdox, CTools, CXmlTlb;

{$R *.dfm}

function CreateDatafileWithWizard(var AFilename: String; var APassword: String): Boolean;
begin
  with TCCreateDatafileForm.Create(Application) do begin
    SaveDialog.FileName := AFilename;
    CStaticName.Caption := MinimizeName(AFilename, CStaticName.Canvas, CStaticName.Width);
    CStaticName.DataId := AFilename;
    Result := ShowModal = mrOk;
    if Result then begin
      AFilename := CStaticName.DataId;
      APassword := EditPassword.Text;
    end;
    Free;
  end;
end;

procedure TCCreateDatafileForm.FormCreate(Sender: TObject);
begin
  inherited;
  PageControl.ActivePage := TabSheetStart;
  FCheckedData := TStringList.Create;
  FReportList := TStringList.Create;
  FIsDisabled := False;
  LoadDefaultDatafileData;
  LoadDefaultCurrencyData;
  UpdateButtons;
  UpdateTabs;
end;

procedure TCCreateDatafileForm.UpdateButtons;
begin
  BitBtnPrev.Enabled := (PageControl.ActivePageIndex <> 0) and (not FIsDisabled);
  BitBtnNext.Enabled := not FIsDisabled;
  BitBtnFinish.Enabled := not FIsDisabled;
end;

procedure TCCreateDatafileForm.BitBtnFinishClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TCCreateDatafileForm.BitBtnPrevClick(Sender: TObject);
begin
  PageControl.SelectNextPage(False, False);
  UpdateButtons;
  UpdateTabs;
end;

procedure TCCreateDatafileForm.BitBtnNextClick(Sender: TObject);
var xProceed: Boolean;
begin
  if PageControl.ActivePageIndex <> PageControl.PageCount - 1 then begin
    if CanSelectNextPage then begin
      PageControl.SelectNextPage(True, False);
      UpdateButtons;
      UpdateTabs;
    end;
  end else begin
    if FileExists(CStaticName.DataId) then begin
      xProceed := ShowInfo(itQuestion, 'Plik danych o nazwie "' + CStaticName.DataId + '" ju¿ istnieje.\nCzy chcesz go nadpisaæ?', '');
    end else begin
      xProceed := True;
    end;
    if xProceed then begin
      if DoCreateDatafile then begin
        ModalResult := mrOk;
      end else begin
        CImage.ImageIndex := 5;
        LabelFinish.Caption := 'CManager nie móg³ utworzyæ nowego pliku danych. SprawdŸ raport z wykonanych czynnoœci. Aby ponowiæ próbê tworzenia pliku wybierz przycisk "Utwórz". Aby zrezygnow¹æ wybierz przycisk "Wyjœcie".';
        LabelInfo.Caption := 'B³¹d tworzenia pliku danych';
      end;
    end;
  end;
end;

procedure TCCreateDatafileForm.CStaticNameGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := SaveDialog.Execute;
  if AAccepted then begin
    ADataGid := SaveDialog.FileName;
    AText := MinimizeName(ADataGid, CStaticName.Canvas, CStaticName.Width);
  end;
end;

procedure TCCreateDatafileForm.LoadDefaultDatafileData;
var xXmlString: String;
begin
  xXmlString := GetStringFromResources('SQLDEFS', RT_RCDATA, HInstance);
  FDefaultData := GetDocumentFromString(xXmlString, Nil);
  SetXmlIdForEach(FDefaultData.documentElement.childNodes, True);
end;

procedure TCCreateDatafileForm.FormDestroy(Sender: TObject);
begin
  FCheckedData.Free;
  FReportList.Free;
  FDefaultData := Nil;
  FDefaultCurrencies := Nil;
  inherited;
end;

procedure TCCreateDatafileForm.CButtonShowDefaultClick(Sender: TObject);
var xId, xText: String;
begin
  ShowXmlFile(FDefaultData,
              FCheckedData,
              'Zaznacz tylko te dane domyœlne, które powinny byæ zapamiêtane w nowym pliku danych',
              'Domyœlne dane',
              xId, xText);
end;

function TCCreateDatafileForm.CanSelectNextPage: Boolean;
begin
  Result := True;
  if PageControl.ActivePage = TabSheetDatafile then begin
    if Trim(CStaticName.DataId) = '' then begin
      ShowInfo(itError, 'Nie wybra³eœ nazwy dla nowego pliku danych', '');
      CStaticName.SetFocus;
      Result := False;
    end;
  end else if PageControl.ActivePage = TabSheetCurrency then begin
    if CStaticCurrency.DataId = CEmptyDataGid then begin
      if ShowInfo(itQuestion, 'Nie wybrano domyœlnej waluty pliku danych. Czy wyœwietliæ listê teraz ?', '') then begin
        CStaticCurrency.DoGetDataId;
      end;
      Result := False;
    end;
  end;
end;

function TCCreateDatafileForm.DoCreateDatafile: Boolean;
var xOverridenBackupFilename: String;
    xProceed: Boolean;
    xError: String;
    xConnection: TADOConnection;
    xNativeError: Integer;
begin
  LabelInfo.Caption := 'Trwa tworzenie pliku danych';
  LabelInfo.Update;
  LabelFinish.Caption := 'Proszê czekaæ. CManager aktualnie tworzy nowy plik danych. Po zakoñczeniu bêdzie on gotowy do u¿ycia.';
  LabelFinish.Update;
  Result := False;
  Disabled := True;
  ProgressBar.Visible := True;
  //Krok 1
  if FileExists(CStaticName.DataId) then begin
    xOverridenBackupFilename := ChangeFileExt(CStaticName.DataId, '.' + FormatDateTime('yymmddhhnnss', Now));
    AddToReport('Wykonywanie kopii pliku ' + CStaticName.DataId + ' do pliku ' + xOverridenBackupFilename);
    if MoveFile(PChar(CStaticName.DataId), PChar(xOverridenBackupFilename)) then begin
      xProceed := True;
      AddToReport('Utworzono kopiê pliku ' + CStaticName.DataId);
    end else begin
      xProceed := False;
      AddToReport('Nie mo¿na utworzyæ kopii istniej¹cego pliku ' + CStaticName.DataId + '. ' + SysErrorMessage(GetLastError));
    end;
  end else begin
    xProceed := True;
  end;
  ProgressBar.StepBy(1);
  //Kork 2
  if xProceed then begin
    AddToReport('Tworzenie nowego pliku danych');
    if DbCreateDatabase(CStaticName.DataId, EditPassword.Text, xError) then begin
      ProgressBar.StepBy(1);
      //Krok 3
      xConnection := TADOConnection.Create(Nil);
      try
        if DbConnectDatabase(CStaticName.DataId, EditPassword.Text, xConnection, xError, xNativeError, True) then begin
          ProgressBar.StepBy(1);
          //Krok 4
          if DbExecuteSql(xConnection, GetStringFromResources('SQLPATTERN', RT_RCDATA), False, xError) then begin
            ProgressBar.StepBy(1);
            //Krok 5
            if DbExecuteSql(xConnection, Format(CInsertCmanagerInfo , [FileVersion(ParamStr(0)), DatetimeToDatabase(Now, True)]), False, xError) then begin
               ProgressBar.StepBy(1);
               //Krok 6
               if DbExecuteSql(xConnection, GetDefaultCurrencyAsString, False, xError) then begin
                 ProgressBar.StepBy(1);
                 // Krok 7
                 if (ComboBoxDefault.ItemIndex = 0) then begin
                   if DbExecuteSql(xConnection, GetDefaultDataAsString, False, xError) then begin
                     ProgressBar.StepBy(1);
                     Result := True;
                   end else begin
                     AddToReport('B³¹d tworzenia domyœlnych danych w pliku, opis b³êdu ' + xError);
                   end;
                 end else begin
                   ProgressBar.StepBy(1);
                   Result := True;
                 end;
               end else begin
                 AddToReport('B³¹d tworzenia walut w pliku, opis b³êdu ' + xError);
               end;
            end else begin
              AddToReport('B³¹d zapisu CManagerInfo, opis b³êdu ' + xError);
            end;
          end else begin
            AddToReport('B³¹d tworzenia struktur pliku danych, opis b³êdu ' + xError);
          end;
        end else begin
          AddToReport('B³¹d podczas pod³¹czania do pliku danych');
          AddToReport('Kod b³êdu ' + IntToStr(xNativeError) + ', opis b³êdu ' + xError);
        end;
      finally
        xConnection.Free;
      end;
      if not Result then begin
        if not Windows.DeleteFile(PChar(CStaticName.DataId)) then begin
          AddToReport('Nie uda³o siê usun¹æ utworzonego pliku danych. Plik mo¿e byæ niepoprawny');
        end;
      end;
    end else begin
      AddToReport('B³¹d podczas tworzenia pliku danych');
      AddToReport(xError);
    end;
  end;
  //Krok 7
  if (xOverridenBackupFilename <> '') then begin
    if Result then begin
      AddToReport('Usuwanie nadpisywanego pliku danych');
      if not Windows.DeleteFile(PChar(xOverridenBackupFilename)) then begin
        AddToReport('Nie uda³o siê usun¹æ kopii pliku danych');
      end;
    end else begin
      AddToReport('Przywracanie pliku ' + CStaticName.DataId + ' z kopii ' + xOverridenBackupFilename);
      if MoveFile(PChar(xOverridenBackupFilename), PChar(CStaticName.DataId)) then begin
        AddToReport('Przywrócono kopiê pliku ' + CStaticName.DataId + ' z pliku ' + xOverridenBackupFilename);
      end else begin
        AddToReport('Nie mo¿na przywróciæ pliku ' + CStaticName.DataId + ' z kopii ' + xOverridenBackupFilename + '. ' + SysErrorMessage(GetLastError));
      end;
    end;
  end;
  ProgressBar.StepBy(1);
  ProgressBar.Visible := False;
  CStaticDesc.Visible := not Result;
  Disabled := False;
end;

function TCCreateDatafileForm.GetDisabled: Boolean;
begin
  Result := FIsDisabled;
end;

procedure TCCreateDatafileForm.SetDisabled(const Value: Boolean);
var hMenu: THandle;
    xOpt: Cardinal;
begin
  FIsDisabled := Value;
  hMenu := GetSystemMenu(Handle, False);
  if Value then begin
    xOpt := MF_DISABLED + MF_GRAYED;
  end else begin
    xOpt := MF_ENABLED;
  end;
  EnableMenuItem(hMenu, SC_CLOSE, xOpt);
  UpdateButtons;
end;

procedure TCCreateDatafileForm.UpdateTabs;
begin
  CImage.ImageIndex := PageControl.ActivePageIndex;
  if PageControl.ActivePage = TabSheetDatafile then begin
    CStaticName.SetFocus;
  end else if PageControl.ActivePage = TabSheetSecurity then begin
    EditPassword.SetFocus;
  end else if PageControl.ActivePage = TabSheetDefault then begin
    ComboBoxDefault.SetFocus;
  end;
  if PageControl.ActivePage = TabSheetFinish then begin
    CStaticDesc.Visible := False;
    LabelFinish.Caption := 'CManager jest gotowy do utworzenia nowego pliku danych. Wybierz przycisk "Utwórz" aby rozpocz¹æ tworzenie pliku danych. Je¿eli chcesz zrezygnowaæ wybierz przycisk "Wyjœcie".';
    LabelInfo.Caption := 'PotwierdŸ utworzenie pliku danych';
    BitBtnNext.Caption := 'Utwórz';
    BitBtnNext.SetFocus;
  end else begin
    BitBtnNext.Caption := 'Dalej';
  end;
end;

procedure TCCreateDatafileForm.AddToReport(AText: String);
begin
  FReportList.Add(FormatDateTime('hh:nn:ss', Now) + ' ' + AText);
end;

procedure TCCreateDatafileForm.CStaticDescGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := False;
  ShowReport('Raport z wykonanych czynnoœci', FReportList.Text, 400, 300);
end;

procedure TCCreateDatafileForm.AppendCommands(ANodes: ICXMLDOMNodeList; AChecks: TStringList; ACommands: TStringList);
var xCount: Integer;
    xNode: ICXMLDOMNode;
    xId: String;
    xSql: String;
    xIsChecked: Boolean;
begin
  for xCount := 0 to ANodes.length - 1 do begin
    xNode := ANodes.item[xCount];
    xId := GetXmlAttribute('id', xNode, CEmptyDataGid);
    xSql := GetXmlAttribute('sql', xNode, '');
    if AChecks = Nil then begin
      xIsChecked := True;
    end else begin
      xIsChecked := ((FCheckedData.Count = 0) or (FCheckedData.IndexOf(xId) >= 0));
    end;
    if (xSql <> '') and (xId <> CEmptyDataGid) and xIsChecked then begin
      ACommands.Add(xSql);
    end;
    AppendCommands(xNode.childNodes, AChecks, ACommands);
  end;
end;

function TCCreateDatafileForm.GetDefaultDataAsString: String;
var xCommands: TStringList;
begin
  xCommands := TStringList.Create;
  AppendCommands(FDefaultData.documentElement.childNodes, FCheckedData, xCommands);
  Result := xCommands.Text;
  xCommands.Free;
end;

procedure TCCreateDatafileForm.LoadDefaultCurrencyData;
var xXmlString: String;
begin
  xXmlString := GetStringFromResources('CURDEFS', RT_RCDATA, HInstance);
  FDefaultCurrencies := GetDocumentFromString(xXmlString, Nil);
end;

procedure TCCreateDatafileForm.CStaticCurrencyGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ShowXmlFile(FDefaultCurrencies, Nil, 'Wybierz walutê domyœl¹. Je¿eli nie ma jej wsród poni¿szych walut wybierz dowoln¹ ' + sLineBreak +
                                                    'z nich, a po utworzeniu pliku danych bêdziesz móg³ dodaæ w³asne waluty i wybraæ' + sLineBreak +
                                                    'spoœród nich domyœn¹.',
                                                    'Wybór domyœlnej waluty pliku danych',
                                                    ADataGid, AText);
end;

function TCCreateDatafileForm.GetDefaultCurrencyAsString: String;
var xCommands: TStringList;
begin
  xCommands := TStringList.Create;
  AppendCommands(FDefaultCurrencies.documentElement.childNodes, Nil, xCommands);
  xCommands.Append('insert into cmanagerParams (paramName, paramValue) values (''GDefaultCurrencyId'', ''' + CStaticCurrency.DataId + ''');');
  Result := xCommands.Text;
  xCommands.Free;
end;

end.
