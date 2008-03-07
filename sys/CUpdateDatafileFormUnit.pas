unit CUpdateDatafileFormUnit;

interface

{$WARN UNIT_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFormUnit, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  CComponents, ImgList, PngImageList, CXml, AdoDb;

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
    procedure UpdateButtons;
    function DoUpdateDatafile: Boolean;
    function GetDisabled: Boolean;
    procedure SetDisabled(const Value: Boolean);
    procedure AddToReport(AText: String);
  public
    property Disabled: Boolean read GetDisabled write SetDisabled;
  end;

function UpdateDatafileWithWizard(AFilename: String; AConnection: TADOConnection): Boolean;

implementation

uses CRichtext, FileCtrl, CXmlFrameUnit, CInfoFormUnit, CReportFormUnit,
  CMemoFormUnit, CAdox, CTools, CXmlTlb;

{$R *.dfm}

function UpdateDatafileWithWizard(AFilename: String; AConnection: TADOConnection): Boolean;
begin
  with TCUpdateDatafileForm.Create(Application) do begin
    {
    CStaticName.Caption := MinimizeName(AFilename, CStaticName.Canvas, CStaticName.Width);
    CStaticName.DataId := AFilename;
    }
    CImage.ImageIndex := 0;
    Result := ShowModal = mrOk;
    Free;
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
{
var xOverridenBackupFilename: String;
    xProceed: Boolean;
    xError: String;
    xConnection: TADOConnection;
    xNativeError: Integer;
}
begin
{
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
}
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
