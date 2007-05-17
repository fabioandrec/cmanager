unit CDatatools;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses Windows, SysUtils, Classes, Controls, ShellApi, CDatabase, CComponents, CBackups,
     DateUtils, MsXml;

function ExportDatabase(AFilename, ATargetFile: String; var AError: String; var AReport: TStringList; AProgressEvent: TProgressEvent = Nil): Boolean;
function BackupDatabase(AFilename, ATargetFilename: String; var AError: String; AOverwrite: Boolean; AProgressEvent: TProgressEvent = Nil): Boolean;
function RestoreDatabase(AFilename, ATargetFilename: String; var AError: String; AOverwrite: Boolean; AProgressEvent: TProgressEvent = Nil): Boolean;
function GetDefaultBackupFilename(ADatabaseName: String): String;
function CheckDatabase(AFilename: String; var AError: String; var AReport: TStringList; AProgressEvent: TProgressEvent = Nil): Boolean;
function CheckPendingInformations: Boolean;
procedure CheckForUpdates(AQuiet: Boolean);
procedure CheckForBackups;
function CheckDatabaseStructure(AFrom, ATo: Integer; var xError: String): Boolean;
procedure SetDatabaseDefaultData;
procedure CopyListToTreeHelper(AList: TDataObjectList; ARootElement: TCListDataElement);
procedure UpdateCurrencyRates(ARatesText: String);
procedure ReloadCurrencyCache;

implementation

uses Variants, ComObj, CConsts, CWaitFormUnit, ZLib, CProgressFormUnit,
  CDataObjects, CInfoFormUnit, CStartupInfoFormUnit, Forms,
  CTools, StrUtils, CPreferences, CXml, CUpdateCurrencyRatesFormUnit;

function BackupDatabase(AFilename, ATargetFilename: String; var AError: String; AOverwrite: Boolean; AProgressEvent: TProgressEvent = Nil): Boolean;
var xTool: TBackupRestore;
begin
  if not Assigned(AProgressEvent) then begin
    ShowWaitForm(wtProgressbar, 'Trwa wykonywanie kopii pliku danych. Proszê czekaæ...');
  end;
  xTool := TBackupRestore.Create(AOverwrite, AProgressEvent);
  try
    Result := xTool.CompressFile(AFilename, ATargetFilename, AError);
  finally
    xTool.Free;
  end;
  if not Assigned(AProgressEvent) then begin
    HideWaitForm;
  end;
end;

function RestoreDatabase(AFilename, ATargetFilename: String; var AError: String; AOverwrite: Boolean; AProgressEvent: TProgressEvent = Nil): Boolean;
var xTool: TBackupRestore;
begin
  if not Assigned(AProgressEvent) then begin
    ShowWaitForm(wtProgressbar, 'Trwa odtwarzanie kopii pliku danych. Proszê czekaæ...');
  end;
  xTool := TBackupRestore.Create(AOverwrite, AProgressEvent);
  try
    Result := xTool.DecompressFile(AFilename, ATargetFilename, AError);
  finally
    xTool.Free;
  end;
  if not Assigned(AProgressEvent) then begin
    HideWaitForm;
  end;
end;

function CheckDatabase(AFilename: String; var AError: String; var AReport: TStringList; AProgressEvent: TProgressEvent = Nil): Boolean;
var xError, xDesc: String;
    xAccounts: TDataObjectList;
    xAccount: TAccount;
    xStep, xCount: Integer;
    xSum: Currency;
    xSuspectedCount: Integer;
begin
  xSuspectedCount := 0;
  Result := InitializeDataProvider(AFilename, xError, xDesc, False);
  if Result then begin
    GDataProvider.BeginTransaction;
    xAccounts := TAccount.GetList(TAccount, AccountProxy, 'select * from account');
    if xAccounts.Count > 0 then begin
      xStep := Trunc(100 / xAccounts.Count);
      for xCount := 0 to xAccounts.Count - 1 do begin
        xAccount := TAccount(xAccounts.Items[xCount]);
        AReport.Add(FormatDateTime('hh:nn:ss', Now) + ' Sprawdzanie konta ' + xAccount.name);
        xSum := GDataProvider.GetSqlCurrency('select sum(cash) as cash from transactions where idAccount = ' + DataGidToDatabase(xAccount.id), 0);
        if xSum + xAccount.initialBalance <> xAccount.cash then begin
          AReport.Add(FormatDateTime('hh:nn:ss', Now) + ' Stan konta ' + xAccount.name +
                  Format(' wynosi %.2f, powinien wynosiæ %.2f', [xAccount.cash, xSum + xAccount.initialBalance]));
          xAccount.cash := xAccount.initialBalance + xSum;
          AReport.Add(FormatDateTime('hh:nn:ss', Now) + ' Zmodyfikowano stan konta ' + xAccount.name);
          inc(xSuspectedCount);
        end else begin
          AReport.Add(FormatDateTime('hh:nn:ss', Now) + ' Stan konta ' + xAccount.name + ' jest poprawny');
        end;
        AProgressEvent(xStep);
      end;
    end;
    if Result then begin
      GDataProvider.CommitTransaction;
    end else begin
      GDataProvider.RollbackTransaction;
    end;
    xAccounts.Free;
    GDataProvider.DisconnectFromDatabase;
    if xSuspectedCount = 0 then begin
      AReport.Add(FormatDateTime('hh:nn:ss', Now) + ' Nie znaleziono ¿adnych nieprawid³owoœci');
    end else begin
      AReport.Add(FormatDateTime('hh:nn:ss', Now) + Format(' Skorygowano %d nieprawid³owoœci', [xSuspectedCount]));
    end;
  end else begin
    AReport.Add(FormatDateTime('hh:nn:ss', Now) + ' ' + xError);
    AReport.Add(FormatDateTime('hh:nn:ss', Now) + ' ' + xDesc);
  end;
end;

function GetDefaultBackupFilename(ADatabaseName: String): String;
var xFilename: String;
begin
  xFilename := FormatDateTime('yymmdd_hhnnss', Now) + '.cmb';
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(ADatabaseName)) + xFilename;
end;

function CheckPendingInformations: Boolean;
var xInfo: TCStartupInfoForm;
begin
  xInfo := TCStartupInfoForm.Create(Nil);
  Result := xInfo.PrepareInfoFrame;
  if Result then begin
    Result := xInfo.ShowModal = mrOk;
  end;
  xInfo.Free;
end;

procedure CheckForUpdates(AQuiet: Boolean);
var xQuiet: String;
begin
  if AQuiet then begin
    xQuiet := '/quiet';
  end else begin
    xQuiet := '';
  end;
  ShellExecute(0, 'open', PChar('cupdate.exe'), PChar(xQuiet), '.', SW_SHOW)
end;

function CheckDatabaseStructure(AFrom, ATo: Integer; var xError: String): Boolean;
var xResName: String;
    xResStream: TResourceStream;
    xCommand: String;
begin
  Result := False;
  try
    xResName := Format('SQLUPD_%d_%d', [AFrom, ATo]);
    xResStream := TResourceStream.Create(HInstance, xResName, RT_RCDATA);
    SetLength(xCommand, xResStream.Size);
    CopyMemory(@xCommand[1], xResStream.Memory, xResStream.Size);
    xResStream.Free;
    Result := GDataProvider.ExecuteSql(xCommand, False);
  except
    on E: Exception do begin
      xError := E.Message;
    end;
  end;
end;

procedure SetDatabaseDefaultData;
var xResStream: TResourceStream;
    xCommand: String;
begin
  xCommand := '';
  xResStream := TResourceStream.Create(HInstance, 'SQLDEFS', RT_RCDATA);
  SetLength(xCommand, xResStream.Size);
  if xResStream.Size > 0 then begin
    CopyMemory(@xCommand[1], xResStream.Memory, xResStream.Size);
    GDataProvider.ExecuteSql(xCommand, True);
  end;
  xResStream.Free;
end;

function ExportDatabase(AFilename, ATargetFile: String; var AError: String; var AReport: TStringList; AProgressEvent: TProgressEvent = Nil): Boolean;
var xError, xDesc: String;
    xStr: TStringList;
    xCount: Integer;
    xMin, xMax: Integer;
begin
  Result := InitializeDataProvider(AFilename, xError, xDesc, False);
  if Result then begin
    xStr := TStringList.Create;
    try
      try
        xMin := Low(CDatafileTables);
        xCount := xMin;
        xMax := High(CDatafileTables);
        while (xCount <= xMax) and Result do begin
          AReport.Add(FormatDateTime('hh:nn:ss', Now) + ' Eksportowanie tabeli ' + CDatafileTables[xCount]);
          Result := GDataProvider.ExportTable(CDatafileTables[xCount], xStr);
          if not Result then begin
            AReport.Add(FormatDateTime('hh:nn:ss', Now) + ' Podczas eksportu wyst¹pi³ b³¹d ' + GDataProvider.LastError);
          end;
          Inc(xCount);
          AProgressEvent(Trunc(100 * xCount/(xMax - xMin)));
        end;
        xStr.SaveToFile(ATargetFile);
      except
        on E: Exception do begin
          Result := False;
          AError := E.Message;
        end;
      end;
    finally
      xStr.Free;
      GDataProvider.DisconnectFromDatabase;
    end;
  end else begin
    AReport.Add(FormatDateTime('hh:nn:ss', Now) + ' ' + xError);
    AReport.Add(FormatDateTime('hh:nn:ss', Now) + ' ' + xDesc);
  end;
end;

procedure CopyListToTreeHelper(AList: TDataObjectList; ARootElement: TCListDataElement);
var xCount: Integer;
    xElement: TCListDataElement;
begin
  for xCount := 0 to AList.Count - 1 do begin
    xElement := TCListDataElement.Create(ARootElement.ParentList, AList.Items[xCount]);
    ARootElement.Add(xElement);
  end;
end;

procedure CheckForBackups;
var xPref: TBackupPref;
    xMustbackup: Boolean;
begin
  xMustbackup := False;
  xPref := TBackupPref(GBackupsPreferences.ByPrefname[GDatabaseName]);
  if GBasePreferences.backupAction = CBackupActionOnce then begin
    if xPref <> Nil then begin
      xMustbackup := DateOf(xPref.lastBackup) <> DateOf(Now);
    end else begin
      xMustbackup := True;
    end;
  end else if GBasePreferences.backupAction = CBackupActionAlways then begin
    xMustbackup := True;
  end else if GBasePreferences.backupAction = CBackupActionAsk then begin
    if xPref = Nil then begin
      xMustbackup := ShowInfo(itQuestion, 'Nie uda³o siê uzyskaæ informacji kiedy wykonywano ostatni raz kopiê pliku danych.' + sLineBreak +
                                          'Czy chcesz wykonaæ kopiê pliku danych teraz?', '');
    end else begin
      if DaysBetween(Today, xPref.lastBackup) + 1 >= GBasePreferences.backupDaysOld then begin
        xMustbackup := ShowInfo(itQuestion, 'Ostatnio wykonywa³eœ kopiê pliku danych ' + IntToStr(DaysBetween(Today, xPref.lastBackup) + 1) + ' dni temu.' + sLineBreak +
                                            'Czy chcesz wykonaæ kopiê pliku danych teraz?', '');
      end;
    end;
  end;
  if xMustbackup then begin
    GBackupThread := TBackupThread.Create(GDatabaseName);
  end;
end;

procedure UpdateCurrencyRates(ARatesText: String);
var xDoc: IXMLDOMDocument;
    xRoot: IXMLDOMNode;
    xList: IXMLDOMNodeList;
    xValid: Boolean;
    xError: String;
    xBindingDate: TDateTime;
    xCahpointName: String;
    xForm: TCUpdateCurrencyRatesForm;
begin
  xValid := False;
  xDoc := GetDocumentFromString(ARatesText);
  if xDoc.parseError.errorCode = 0 then begin
    xRoot := xDoc.selectSingleNode('currencyRates');
    if xRoot <> Nil then begin
      xBindingDate := DmyToDate(GetXmlAttribute('bindingDate', xRoot, ''), 0);
      if xBindingDate <> 0 then begin
        xCahpointName := GetXmlAttribute('cashpointName', xRoot, '');
        if xCahpointName <> '' then begin
          xValid := True;
          xList := xRoot.selectNodes('currencyRate');
          if xList.length > 0 then begin
            xForm := TCUpdateCurrencyRatesForm.Create(Application);
            xForm.Xml := xDoc;
            xForm.Root := xRoot;
            xForm.Rates := xList;
            xForm.BindingDate := xBindingDate;
            xForm.CashpointName := xCahpointName;
            xForm.InitializeForm;
            xForm.ShowModal;
            xForm.Free;
          end else begin
            ShowInfo(itInfo, 'Tabela nie zawiera ¿adnych kursów walut', xError);
          end;
        end else begin
          xError := 'Brak okreœlenia kontrahenta - dostawcy tabeli kursów';
        end;
      end else begin
        xError := 'Brak okreœlenia daty wa¿noœci tabeli kursów';
      end;
    end else begin
      xError := 'Brak elementu zbiorczego';
    end;
  end else begin
    xError := xDoc.parseError.reason;
  end;
  if not xValid then begin
    ShowInfo(itError, 'Otrzymane dane nie s¹ poprawn¹ tabel¹ kursów walut', xError);
  end;
end;

procedure ReloadCurrencyCache;
var xC: TDataObjectList;
    xCount: Integer;
    xCur: TCurrencyDef;
begin
  xC := TCurrencyDef.GetAllObjects(CurrencyDefProxy);
  for xCount := 0 to xC.Count - 1 do begin
    xCur := TCurrencyDef(xC.Items[xCount]);
    GCurrencyCache.Change(xCur.id, xCur.symbol);
  end;
  xC.Free;
end;

end.
