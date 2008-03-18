unit CUpdateDatafileFormUnit;

interface

{$WARN UNIT_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFormUnit, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  CComponents, ImgList, PngImageList, CXml, AdoDb, Types;

type
  TCUpdateDatafileForm = class(TCBaseForm)
    PanelButtons: TPanel;
    BitBtnNext: TBitBtn;
    BitBtnFinish: TBitBtn;
    PanelImage: TPanel;
    CImage: TCImage;
    PngImageList: TPngImageList;
    LabelInfo: TLabel;
    LabelFinish: TLabel;
    CStaticDesc: TCStatic;
    ProgressBar: TProgressBar;
    procedure FormCreate(Sender: TObject);
    procedure BitBtnFinishClick(Sender: TObject);
    procedure BitBtnNextClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CStaticDescGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
  private
    FReportList: TStringList;
    FIsDisabled: Boolean;
    FFilename: String;
    FConnection: TADOConnection;
    FFromDbversion: Integer;
    FToDbversion: Integer;
    FFromVersion: String;
    FToVersion: String;
    procedure UpdateButtons;
    function DoUpdateDatafile: Boolean;
    function GetDisabled: Boolean;
    procedure SetDisabled(const Value: Boolean);
    procedure AddToReport(AText: String);
  public
    property Disabled: Boolean read GetDisabled write SetDisabled;
    property Filename: String read FFilename write FFilename;
    property Connection: TADOConnection read FConnection write FConnection;
    property FromDbversion: Integer read FFromDbversion write FFromDbversion;
    property ToDbversion: Integer read FToDbversion write FToDbversion;
    property FromVersion: String read FFromVersion write FFromVersion;
    property ToVersion: String read FToVersion write FToVersion;
  end;

function UpdateDatafileWithWizard(AFilename: String; AConnection: TADOConnection; var AFromVersion, AToVersion: String): Boolean;

implementation

uses CRichtext, FileCtrl, CXmlFrameUnit, CInfoFormUnit, CReportFormUnit,
  CMemoFormUnit, CAdox, CTools, CXmlTlb;

{$R *.dfm}

function UpdateDatafileWithWizard(AFilename: String; AConnection: TADOConnection; var AFromVersion, AToVersion: String): Boolean;
var xDataset: TADOQuery;
    xError: String;
    xFromDynArray, xToDynArray: TStringDynArray;
    xFromDb, xToDb: Integer;
begin
  Result := False;
  AFromVersion := '';
  AToVersion := '';
  xDataset := DbOpenSql(AConnection, 'select * from cmanagerInfo', xError);
  if xDataset <> Nil then begin
    AFromVersion := xDataset.FieldByName('version').AsString;
    AToVersion := FileVersion(ParamStr(0));
    xDataset.Free;
    xFromDynArray := StringToStringArray(AFromVersion, '.');
    xToDynArray := StringToStringArray(AToVersion, '.');
    if Length(xFromDynArray) <> 4 then begin
      ShowInfo(itError, 'Informacja o wersji pliku danych jest niew³aœciwa. Byæ mo¿e wskazany plik\n' +
                        'nie jest poprawnym plikiem danych programu CManager lub jest uszkodzony', '');
    end else begin
      xFromDb := StrToIntDef(xFromDynArray[1], -1);
      xToDb := StrToIntDef(xToDynArray[1], -1);
      Result := xFromDb = xToDb;
      if not Result then begin
        with TCUpdateDatafileForm.Create(Application) do begin
          Filename := AFilename;
          Connection := AConnection;
          FToVersion := AToVersion;
          FFromVersion := AFromVersion;
          FFromDbversion := xFromDb;
          FToDbversion := xToDb;
          LabelFinish.Caption := Format(LabelFinish.Caption, [FFromVersion, FToVersion]);
          CImage.ImageIndex := 0;
          Result := ShowModal = mrOk;
          Free;
        end;
      end;
      if Result and (AFromVersion <> AToVersion) then begin
        DbExecuteSql(AConnection, 'update cmanagerInfo set version = ''' + AToVersion + '''', False, xError);
      end;
    end;
  end else begin
    ShowInfo(itError, 'Nie uda³o siê odczytaæ informacji o wersji pliku danych. Byæ mo¿e wskazany plik\n' +
                      'nie jest poprawnym plikiem danych programu CManager lub jest uszkodzony', xError);
  end;
end;

procedure TCUpdateDatafileForm.FormCreate(Sender: TObject);
begin
  FReportList := TStringList.Create;
  FIsDisabled := False;
  UpdateButtons;
end;

procedure TCUpdateDatafileForm.UpdateButtons;
begin
  BitBtnNext.Enabled := not FIsDisabled;
  BitBtnFinish.Enabled := not FIsDisabled;
end;

procedure TCUpdateDatafileForm.BitBtnFinishClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TCUpdateDatafileForm.BitBtnNextClick(Sender: TObject);
begin
  if DoUpdateDatafile then begin
    ModalResult := mrOk;
  end else begin
    CImage.ImageIndex := 1;
    LabelFinish.Caption := 'CManager nie móg³ uaktualniæ pliku danych. SprawdŸ raport z wykonanych czynnoœci. Aby ponowiæ próbê uaktualnienia wybierz przycisk "Uaktualnij". Aby zrezygnow¹æ wybierz przycisk "Wyjœcie".';
    LabelInfo.Caption := 'B³¹d uaktualniania pliku danych';
  end;
end;

procedure TCUpdateDatafileForm.FormDestroy(Sender: TObject);
begin
  FReportList.Free;
  inherited;
end;

function TCUpdateDatafileForm.DoUpdateDatafile: Boolean;
var xBackupFilename: String;
    xProceed: Boolean;
    xError: String;
    xNativeError: Integer;
    xLogFile: String;
    xCommand: String;
    xCurDbversion: Integer;
    xBackupCreated: Boolean;
begin
  LabelInfo.Caption := 'Trwa uaktualnianie pliku danych';
  LabelInfo.Update;
  LabelFinish.Caption := 'Proszê czekaæ. CManager w³aœnie uaktualnia wybrany plik danych. Po zakoñczeniu bêdzie on gotowy do u¿ycia.';
  LabelFinish.Update;
  Result := False;
  Disabled := True;
  ProgressBar.Max := 4 + (FToDbversion - FFromDbversion);
  ProgressBar.Visible := True;
  xBackupCreated := False;
  //Krok 1
  xProceed := True;
  if not FConnection.Connected then begin
    if not DbConnectDatabase(FConnection.ConnectionString, FConnection, xError, xNativeError, False) then begin
      AddToReport('Nie uda³o siê pod³¹czyæ do pliku danych, opis b³êdu ' + xError);
      xProceed := False;
    end;
  end;
  ProgressBar.StepBy(1);
  if xProceed then begin
    //Krok 2
    xBackupFilename := ChangeFileExt(FFilename, '.' + FormatDateTime('yymmddhhnnss', Now));
    AddToReport('Wykonywanie kopii pliku ' + FFilename + ' do pliku ' + xBackupFilename);
    if CopyFile(PChar(FFilename), PChar(xBackupFilename), True) then begin
      xProceed := True;
      AddToReport('Utworzono kopiê pliku ' + FFilename);
      xBackupCreated := True;
    end else begin
      xProceed := False;
      AddToReport('Nie mo¿na utworzyæ kopii pliku ' + FFilename + '. ' + SysErrorMessage(GetLastError));
    end;
    ProgressBar.StepBy(1);
    //Kork 3
    if xProceed then begin
      AddToReport('Uaktualnianie pliku danych');
      Result := True;
      xLogFile := DbSqllogfile;
      DbSqllogfile := GetSystemPathname(ChangeFileExt(FFilename, '') + '_update.log');
      SaveToLog('Sesja uaktualnienia z ' + FFromVersion + ' do ' + FToVersion, DbSqllogfile);
      xCurDbversion := FFromDbversion;
      while Result and (xCurDbversion <> FToDbversion) do begin
        SaveToLog(IntToStr(xCurDbversion) + ' -> ' + IntToStr(xCurDbversion + 1), DbSqllogfile);
        xCommand := GetStringFromResources(Format('SQLUPD_%d_%d', [xCurDbversion, xCurDbversion + 1]), RT_RCDATA);
        Result := DbExecuteSql(FConnection, xCommand, False, xError);
        Inc(xCurDbversion);
        ProgressBar.StepBy(1);
      end;
      if not Result then begin
        AddToReport('B³¹d uaktualniania struktur pliku danych, opis b³êdu ' + xError);
      end;
      DbSqllogfile := xLogFile;
    end;
    ProgressBar.StepBy(1);
    //Krok 4
    if Result then begin
      AddToReport('Usuwanie kopii pliku danych');
      if not Windows.DeleteFile(PChar(xBackupFilename)) then begin
        AddToReport('Nie uda³o siê usun¹æ kopii pliku danych');
      end;
    end else begin
      if xBackupCreated then begin
        AddToReport('Przywracanie pliku ' + FFilename + ' z kopii ' + xBackupFilename);
        FConnection.Close;
        if Windows.DeleteFile(PChar(FFilename)) then begin
          if MoveFile(PChar(xBackupFilename), PChar(FFilename)) then begin
            AddToReport('Przywrócono kopiê pliku ' + FFilename + ' z pliku ' + xBackupFilename);
          end else begin
            AddToReport('Nie mo¿na przywróciæ pliku ' + FFilename + ' z kopii ' + xBackupFilename + '. ' + SysErrorMessage(GetLastError));
          end;
        end else begin
          AddToReport('Nie mo¿na usun¹æ pliku danych ' + FFilename + ', aby przywróciæ go z kopii ' + xBackupFilename + '. ' + SysErrorMessage(GetLastError));
          AddToReport('Usuñ plik rêcznie, zmieñ nazwê dla kopii pliku z ' + xBackupFilename + ' na ' + FFilename + ' i nastêpnie ponów próbê uaktualnienia');
        end;
      end;
    end;
  end;
  ProgressBar.StepBy(1);
  ProgressBar.Visible := False;
  CStaticDesc.Visible := not Result;
  Disabled := False;
end;

function TCUpdateDatafileForm.GetDisabled: Boolean;
begin
  Result := FIsDisabled;
end;

procedure TCUpdateDatafileForm.SetDisabled(const Value: Boolean);
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

procedure TCUpdateDatafileForm.AddToReport(AText: String);
begin
  FReportList.Add(FormatDateTime('hh:nn:ss', Now) + ' ' + AText);
end;

procedure TCUpdateDatafileForm.CStaticDescGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := False;
  ShowReport('Raport z wykonanych czynnoœci', FReportList.Text, 400, 300);
end;

end.
