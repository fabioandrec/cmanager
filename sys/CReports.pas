unit CReports;

interface

uses Classes, CReportFormUnit, Graphics, Controls, Chart, Series, Contnrs, Windows,
     GraphUtil;

type
  TCReportClass = class of TCReport;

  TCReport = class(TObject)
  private
    FreportPath: String;
    FreportText: TStringList;
    Fform: TCReportForm;
    Fcharts: TObjectList;
    function PrepareReportData: Boolean;
    procedure PrepareReportPath;
  protected
    procedure CleanReportData; virtual;
    function PrepareReportConditions: Boolean; virtual;
    function GetReportTitle: String; virtual; abstract;
    function GetReportBody: String; virtual; abstract;
    function GetReportFooter: String; virtual;
  public
    procedure ShowReport;
    constructor Create;
    destructor Destroy; override;
    function GetChart: TChart;
  published
    property reportTitle: String read GetReportTitle;
    property reportBody: String read GetReportBody;
    property reportFooter: String read GetReportFooter;
  end;

  TAccountBalanceOnDayReport = class(TCReport)
  private
    FDate: TDateTime;
  protected
    function GetReportTitle: String; override;
    function GetReportBody: String; override;
    function PrepareReportConditions: Boolean; override;
  end;

  TDoneOperationsListReport = class(TCReport)
  private
    FStartDate: TDateTime;
    FEndDate: TDateTime;
  protected
    function GetReportTitle: String; override;
    function GetReportBody: String; override;
    function PrepareReportConditions: Boolean; override;
  end;

  TPlannedOperationsListReport = class(TCReport)
  private
    FStartDate: TDateTime;
    FEndDate: TDateTime;
  protected
    function GetReportTitle: String; override;
    function GetReportBody: String; override;
    function PrepareReportConditions: Boolean; override;
  end;

  TCashFlowListReport = class(TCReport)
  private
    FStartDate: TDateTime;
    FEndDate: TDateTime;
  protected
    function GetReportTitle: String; override;
    function GetReportBody: String; override;
    function PrepareReportConditions: Boolean; override;
  end;


implementation

uses Forms, SysUtils, CDatabase, Adodb, CConfigFormUnit,
     CChooseDateFormUnit, DB, CChoosePeriodFormUnit, CConsts, CDataObjects,
  DateUtils, CSchedules;

function DayName(ADate: TDateTime): String;
var xDay: Integer;
begin
  xDay := DayOfTheWeek(ADate);
  Result := CShortDayNames[xDay - 1];
end;

function ColToRgb(AColor: TColor): String;
var xRgb: Integer;
begin
  xRgb := ColorToRGB(AColor);
  Result := '"#' + Format('%.2x%.2x%.2x', [GetRValue(xRgb), GetGValue(xRgb), GetBValue(xRgb)]) + '"';
end;

function GetReportPath(ASubpath: String): string;
var i: integer;
begin
  SetLength(Result, MAX_PATH);
	i := GetTempPath(Length(Result), PChar(Result));
	SetLength(Result, i);
  Result := IncludeTrailingPathDelimiter(Result) + IncludeTrailingPathDelimiter('Cmanager') + IncludeTrailingPathDelimiter(ASubpath);
end;

procedure TCReport.CleanReportData;
var xRec: TSearchRec;
    xRes: Integer;
begin
  xRes := FindFirst(FreportPath + '*.*', faAnyFile, xRec);
  while (xRes = 0) do begin
    DeleteFile(FreportPath + xRec.Name);
    xRes := FindNext(xRec);
  end;
  FindClose(xRec);
  RemoveDir(FreportPath);
end;

constructor TCReport.Create;
begin
  inherited Create;
  FreportText := TStringList.Create;
  Fcharts := TObjectList.Create(False);
end;

destructor TCReport.Destroy;
begin
  CleanReportData;
  Fcharts.Free;
  FreportText.Free;
  inherited Destroy;
end;

function TCReport.GetChart: TChart;
begin
  Result := TChart.Create(Fform);
  Result.Visible := False;
  Result.BorderStyle := bsNone;
  Result.BevelInner := bvNone;
  Result.BevelOuter := bvNone;
  Result.Color := clWindow;
  Result.Parent := Fform;
  Fcharts.Add(Result)
end;

function TCReport.GetReportFooter: String;
begin
  Result := 'CManager wer. ' + FileVersion(ParamStr(0)) + ', ' + DateTimeToStr(Now);
end;

function TCReport.PrepareReportConditions: Boolean;
begin
  Result := True;
end;

function TCReport.PrepareReportData: Boolean;
var xText: String;
begin
  Result := PrepareReportConditions;
  PrepareReportPath;
  xText := FreportText.Text;
  xText := StringReplace(xText, '[reptitle]', reportTitle, [rfReplaceAll, rfIgnoreCase]);
  xText := StringReplace(xText, '[repbody]', reportBody, [rfReplaceAll, rfIgnoreCase]);
  xText := StringReplace(xText, '[repfooter]', reportFooter, [rfReplaceAll, rfIgnoreCase]);
  FreportText.Text := xText;
end;

procedure TCReport.PrepareReportPath;
var xRes: TResourceStream;
begin
  FreportPath := GetReportPath(IntToStr(GetTickCount));
  if not FileExists('report.css') then begin
    xRes := TResourceStream.Create(HInstance, 'REPCSS', RT_RCDATA);
    xRes.SaveToFile('report.css');
    xRes.Free;
  end;
  if not FileExists('report.htm') then begin
    xRes := TResourceStream.Create(HInstance, 'REPBASE', RT_RCDATA);
    xRes.SaveToFile('report.htm');
    xRes.Free;
  end;
  FreportText.LoadFromFile('report.htm');
  ForceDirectories(FreportPath)
end;

procedure TCReport.ShowReport;
begin
  Fform := TCReportForm.Create(Nil);
  if PrepareReportData then begin
    Fform.Caption := 'Raport';
    FreportText.SaveToFile(FreportPath + 'report.htm');
    CopyFile('report.css', PChar(FreportPath + 'report.css'), False); 
    Fform.CBrowser.Navigate('file://' + FreportPath + 'report.htm');
    Fform.ShowConfig(coNone);
  end;
  Fform.Free;
end;

function TAccountBalanceOnDayReport.GetReportBody: String;
var xAccounts: TADOQuery;
    xOperations: TADOQuery;
    xSum, xDelta: Currency;
    xBody: TStringList;
begin
  xAccounts := GDataProvider.OpenSql('select * from account order by name');
  xOperations := GDataProvider.OpenSql(Format('select sum(cash) as cash, idAccount from transactions where regDate > %s group by idAccount', [DatetimeToDatabase(FDate, False)]));
  xSum := 0;
  xBody := TStringList.Create;
  with xAccounts, xBody do begin
    Add('<table class="base" colspan=2>');
    Add('<tr class="base">');
    Add('<td class="headtext" width="75%">Nazwa konta</td>');
    Add('<td class="headcash" width="25%">Saldo</td>');
    Add('</tr>');
    Add('</table><hr><table class="base" colspan=2>');
    while not Eof do begin
      if not Odd(RecNo) then begin
        Add('<tr class="base" bgcolor=' + ColToRgb(GetHighLightColor(clWhite, -10)) + '>');
      end else begin
        Add('<tr class="base">');
      end;
      Add('<td class="text" width="75%">' + FieldByName('name').AsString + '</td>');
      xOperations.Filter := 'idAccount = ' + DataGidToDatabase(FieldByName('idAccount').AsString);
      xOperations.Filtered := True;
      if xOperations.IsEmpty then begin
        xDelta := 0;
      end else begin
        xDelta := xOperations.FieldByName('cash').AsCurrency;
      end;
      Add('<td class="cash" width="25%">' + CurrencyToString(FieldByName('cash').AsCurrency - xDelta) + '</td>');
      Add('</tr>');
      xSum := xSum + FieldByName('cash').AsCurrency - xDelta;
      Next;
    end;
    Add('</table><hr><table class="base" colspan=2>');
    Add('<tr class="base">');
    Add('<td class="sumtext" width="75%">Razem</td>');
    Add('<td class="sumcash" width="25%">' + CurrencyToString(xSum) + '</td>');
    Add('</tr>');
    Add('</table>');
  end;
  xAccounts.Free;
  xOperations.Free;
  Result := xBody.Text;
  xBody.Free;
end;

function TAccountBalanceOnDayReport.GetReportTitle: String;
begin
  Result := 'Stan kont (' + DayName(FDate) + ', ' + DateToStr(FDate) + ')';
end;

function TAccountBalanceOnDayReport.PrepareReportConditions: Boolean;
begin
  Result := ChooseDateByForm(FDate);
end;

function TDoneOperationsListReport.GetReportBody: String;
var xOperations: TADOQuery;
    xInSum, xOutSum: Currency;
    xIn, xOut: String;
    xBody: TStringList;
    xCash: Currency;
begin
  xOperations := GDataProvider.OpenSql(
            Format('select b.*, a.name from balances b' +
                   ' left outer join account a on a.idAccount = b.idAccount ' +
                   '  where movementType <> ''%s'' and b.regDate between %s and %s order by b.created',
                   [CTransferMovement, DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False)]));
  xInSum := 0;
  xOutSum := 0;
  xBody := TStringList.Create;
  with xOperations, xBody do begin
    Add('<table class="base" colspan=5>');
    Add('<tr class="base">');
    Add('<td class="headtext" width="10%">Lp</td>');
    Add('<td class="headtext" width="50%">Opis</td>');
    Add('<td class="headtext" width="20%">Konto</td>');
    Add('<td class="headcash" width="10%">PrzychÛd</td>');
    Add('<td class="headcash" width="10%">RozchÛd</td>');
    Add('</tr>');
    Add('</table><hr><table class="base" colspan=5>');
    while not Eof do begin
      if not Odd(RecNo) then begin
        Add('<tr class="base" bgcolor=' + ColToRgb(GetHighLightColor(clWhite, -10)) + '>');
      end else begin
        Add('<tr class="base">');
      end;
      xCash := FieldByName('income').AsCurrency;
      if xCash > 0 then begin
        xIn := CurrencyToString(xCash);
        xInSum := xInSum + xCash;
      end else begin
        xIn := '';
      end;
      xCash := FieldByName('expense').AsCurrency;
      if xCash > 0 then begin
        xOut := CurrencyToString(xCash);
        xOutSum := xOutSum + xCash;
      end else begin
        xOut := '';
      end;
      Add('<td class="text" width="10%">' + IntToStr(RecNo) + '</td>');
      Add('<td class="text" width="50%">' + FieldByName('description').AsString + '</td>');
      Add('<td class="text" width="20%">' + FieldByName('name').AsString + '</td>');
      Add('<td class="cash" width="10%">' + xIn + '</td>');
      Add('<td class="cash" width="10%">' + xOut + '</td>');
      Add('</tr>');
      Next;
    end;
    Add('</table><hr><table class="base" colspan=2>');
    Add('<tr class="base">');
    Add('<td class="sumtext" width="80%">Razem</td>');
    Add('<td class="sumcash" width="10%">' + CurrencyToString(xInSum) + '</td>');
    Add('<td class="sumcash" width="10%">' + CurrencyToString(xOutSum) + '</td>');
    Add('</tr>');
    Add('</table>');
  end;
  xOperations.Free;
  Result := xBody.Text;
  xBody.Free;
end;

function TDoneOperationsListReport.GetReportTitle: String;
begin
  Result := 'Operacje wykonane (' + DayName(FStartDate) + ', ' + DateToStr(FStartDate) + ' - ' +  DayName(FEndDate) + ', ' + DateToStr(FEndDate) + ')';
end;

function TDoneOperationsListReport.PrepareReportConditions: Boolean;
begin
  Result := ChoosePeriodByForm(FStartDate, FEndDate);
end;

function TPlannedOperationsListReport.GetReportBody: String;
var xSqlPlanned, xSqlDone: String;
    xPlannedObjects, xDoneObjects: TDataObjectList;
    xInSum, xOutSum: Currency;
    xBody: TStringList;
    xCount: Integer;
    xList: TObjectList;
    xElement: TPlannedTreeItem;
    xIn, xOut: String;
    xDesc, xStat: String;
begin
  xSqlPlanned := 'select plannedMovement.*, (select count(*) from plannedDone where plannedDone.idplannedMovement = plannedMovement.idplannedMovement) as doneCount from plannedMovement where isActive = true ';
  xSqlPlanned := xSqlPlanned + Format(' and (' +
                        '  (scheduleType = ''O'' and scheduleDate between %s and %s and (select count(*) from plannedDone where plannedDone.idPlannedMovement = plannedMovement.idPlannedMovement) = 0) or ' +
                        '  (scheduleType = ''C'' and scheduleDate <= %s)' +
                        ' )', [DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False), DatetimeToDatabase(FEndDate, False)]);
  xSqlPlanned := xSqlPlanned + Format(' and (' +
                        '  (endCondition = ''N'') or ' +
                        '  (endCondition = ''D'' and endDate >= %s) or ' +
                        '  (endCondition = ''T'' and endCount > (select count(*) from plannedDone where plannedDone.idPlannedMovement = plannedMovement.idPlannedMovement)) ' +
                        ' )', [DatetimeToDatabase(FStartDate, False)]);
  xSqlDone := Format('select * from plannedDone where triggerDate between %s and %s', [DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False)]);
  GDataProvider.BeginTransaction;
  xPlannedObjects := TDataObject.GetList(TPlannedMovement, PlannedMovementProxy, xSqlPlanned);
  xDoneObjects := TDataObject.GetList(TPlannedDone, PlannedDoneProxy, xSqlDone);
  xInSum := 0;
  xOutSum := 0;
  xBody := TStringList.Create;
  xList := TObjectList.Create(True);
  with xBody do begin
    Add('<table class="base" colspan=5>');
    Add('<tr class="base">');
    Add('<td class="headtext" width="10%">Lp</td>');
    Add('<td class="headtext" width="40%">Opis</td>');
    Add('<td class="headtext" width="30%">Status</td>');
    Add('<td class="headcash" width="10%">PrzychÛd</td>');
    Add('<td class="headcash" width="10%">RozchÛd</td>');
    Add('</tr>');
    Add('</table><hr><table class="base" colspan=5>');
    GetScheduledObjects(xList, Nil, xPlannedObjects, xDoneObjects, FStartDate, FEndDate);
    for xCount := 1 to xList.Count do begin
      xElement := TPlannedTreeItem(xList.Items[xCount - 1]);
      if not Odd(xCount) then begin
        Add('<tr class="base" bgcolor=' + ColToRgb(GetHighLightColor(clWhite, -10)) + '>');
      end else begin
        Add('<tr class="base">');
      end;
      if xElement.done <> Nil then begin
        xDesc := xElement.done.description;
        if xElement.planned.movementType = CInMovement then begin
          xIn := CurrencyToString(xElement.done.cash);
          xOut := '';
          xInSum := xInSum + xElement.done.cash;
        end else begin
          xOut := CurrencyToString(xElement.done.cash);
          xIn := '';
          xOutSum := xOutSum + xElement.done.cash;
        end;
        if xElement.done.doneState = CDoneOperation then begin
          xStat := 'Zrealizowana';
        end else if xElement.done.doneState = CDoneDeleted then begin
          xStat := 'Odrzucona';
        end else begin
          xStat := 'Uznana';
        end;
        xStat := xStat + ' (' + DateToStr(xElement.done.doneDate) + ')';
      end else begin
        xDesc := xElement.planned.description;
        if xElement.planned.movementType = CInMovement then begin
          xIn := CurrencyToString(xElement.planned.cash);
          xOut := '';
          xInSum := xInSum + xElement.planned.cash;
        end else begin
          xOut := CurrencyToString(xElement.planned.cash);
          xIn := '';
          xOutSum := xOutSum + xElement.planned.cash;
        end;
        xStat := '';
      end;
      Add('<td class="text" width="10%">' + IntToStr(xCount) + '</td>');
      Add('<td class="text" width="40%">' + xDesc + '</td>');
      Add('<td class="text" width="30%">' + xStat + '</td>');
      Add('<td class="cash" width="10%">' + xIn + '</td>');
      Add('<td class="cash" width="10%">' + xOut + '</td>');
      Add('</tr>');
    end;
    Add('</table><hr><table class="base" colspan=2>');
    Add('<tr class="base">');
    Add('<td class="sumtext" width="80%">Razem</td>');
    Add('<td class="sumcash" width="10%">' + CurrencyToString(xInSum) + '</td>');
    Add('<td class="sumcash" width="10%">' + CurrencyToString(xOutSum) + '</td>');
    Add('</tr>');
    Add('</table>');
  end;
  GDataProvider.RollbackTransaction;
  xPlannedObjects.Free;
  xDoneObjects.Free;
  xList.Free;
  Result := xBody.Text;
  xBody.Free;
end;

function TPlannedOperationsListReport.GetReportTitle: String;
begin
  Result := 'Operacje zaplanowane (' + DayName(FStartDate) + ', ' + DateToStr(FStartDate) + ' - ' +  DayName(FEndDate) + ', ' + DateToStr(FEndDate) + ')';
end;

function TPlannedOperationsListReport.PrepareReportConditions: Boolean;
begin
  Result := ChoosePeriodByForm(FStartDate, FEndDate);
end;

function TCashFlowListReport.GetReportBody: String;
var xOperations: TADOQuery;
    xBody: TStringList;
    xSum: Currency;
begin
  xOperations := GDataProvider.OpenSql(
             Format('select ' +
                    '  b.created, b.description, b.cash, b.movementType, b.regDate, ' +
                    '  b.idCashpoint as sourceid, c.name as sourcename, ' +
                    '  a.idAccount as destid, a.name as destname ' +
                    '  from baseMovement b, account a, cashpoint c where b.regDate between %s and %s and ' +
                    '  a.idAccount = b.idAccount and c.idCashpoint = b.idCashpoint and b.movementType in ('''+ CInMovement + ''') ' +
                    '  union all ' +
                    'select ' +
                    '  b.created, b.description, b.cash, b.movementType, b.regDate, ' +
                    '  a.idAccount as sourceid, a.name as sourcename, ' +
                    '  b.idCashpoint as destid, c.name as destname ' +
                    '  from baseMovement b, account a, cashpoint c where b.regDate between %s and %s and ' +
                    '  a.idAccount = b.idAccount and c.idCashpoint = b.idCashpoint and b.movementType in (''' + COutMovement + ''') ' +
                    '  union all ' +
                    'select ' +
                    '  b.created, b.description, b.cash, b.movementType, b.regDate, ' +
                    '  b.idSourceAccount as sourceid, c.name as sourcename, ' +
                    '  a.idAccount as destid, a.name as destname ' +
                    '  from baseMovement b, account a, account c where b.regDate between %s and %s and ' +
                    '  a.idAccount = b.idAccount and c.idAccount = b.idSourceAccount and b.movementType in (''' + CTransferMovement + ''') ' +
                    'order by b.regDate, b.created ',
                   [DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False),
                    DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False),
                    DatetimeToDatabase(FStartDate, False), DatetimeToDatabase(FEndDate, False)]));
  xBody := TStringList.Create;
  xSum := 0;
  with xOperations, xBody do begin
    Add('<table class="base" colspan=4>');
    Add('<tr class="base">');
    Add('<td class="headtext" width="10%">Lp</td>');
    Add('<td class="headtext" width="35%">èrÛd≥o</td>');
    Add('<td class="headtext" width="35%">Cel</td>');
    Add('<td class="headcash" width="20%">Kwota</td>');
    Add('</tr>');
    Add('</table><hr><table class="base" colspan=4>');
    while not Eof do begin
      if not Odd(RecNo) then begin
        Add('<tr class="base" bgcolor=' + ColToRgb(GetHighLightColor(clWhite, -10)) + '>');
      end else begin
        Add('<tr class="base">');
      end;
      Add('<td class="text" width="10%">' + IntToStr(RecNo) + '</td>');
      Add('<td class="text" width="35%">' + FieldByName('sourcename').AsString + '</td>');
      Add('<td class="text" width="35%">' + FieldByName('destname').AsString + '</td>');
      Add('<td class="cash" width="20%">' + CurrencyToString(FieldByName('cash').AsCurrency) + '</td>');
      Add('</tr>');
      xSum := xSum + FieldByName('cash').AsCurrency;
      Next;
    end;
    Add('</table><hr><table class="base" colspan=2>');
    Add('<tr class="base">');
    Add('<td class="sumtext" width="80%">Razem</td>');
    Add('<td class="sumcash" width="20%">' + CurrencyToString(xSum) + '</td>');
    Add('</tr>');
    Add('</table>');
  end;
  xOperations.Free;
  Result := xBody.Text;
  xBody.Free;
end;

function TCashFlowListReport.GetReportTitle: String;
begin
  Result := 'Przep≥yw gotÛwki (' + DayName(FStartDate) + ', ' + DateToStr(FStartDate) + ' - ' +  DayName(FEndDate) + ', ' + DateToStr(FEndDate) + ')';
end;

function TCashFlowListReport.PrepareReportConditions: Boolean;
begin
  Result := ChoosePeriodByForm(FStartDate, FEndDate);
end;

end.
