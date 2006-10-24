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

  TOperationsListReport = class(TCReport)
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
     CChooseDateFormUnit, DB, CChoosePeriodFormUnit, CConsts;

function DayName(ADate: TDateTime): String;
var xDay: Integer;
begin
  xDay := DayOfWeek(ADate);
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
  xOperations := GDataProvider.OpenSql(Format('select sum(cash) as cash, idAccount from transactions where regDate > %s group by idAccount', [DatetimeToDatabase(FDate)]));
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
    Add('<td class="sumtext" width="75%">Wszystkie konta</td>');
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

function TOperationsListReport.GetReportBody: String;
var xOperations: TADOQuery;
    xInSum, xOutSum: Currency;
    xIn, xOut: String;
    xBody: TStringList;
    xCash: Currency;
begin
  xOperations := GDataProvider.OpenSql(Format('select * from transactions where regDate between %s and %s order by created',
                                              [DatetimeToDatabase(FStartDate), DatetimeToDatabase(FEndDate)]));
  xInSum := 0;
  xOutSum := 0;
  xBody := TStringList.Create;
  with xOperations, xBody do begin
    Add('<table class="base" colspan=4>');
    Add('<tr class="base">');
    Add('<td class="headtext" width="10%">Lp</td>');
    Add('<td class="headtext" width="50%">Opis</td>');
    Add('<td class="headcash" width="20%">Przychód</td>');
    Add('<td class="headcash" width="20%">Rozchód</td>');
    Add('</tr>');
    Add('</table><hr><table class="base" colspan=4>');
    while not Eof do begin
      if not Odd(RecNo) then begin
        Add('<tr class="base" bgcolor=' + ColToRgb(GetHighLightColor(clWhite, -10)) + '>');
      end else begin
        Add('<tr class="base">');
      end;
      xCash := FieldByName('cash').AsCurrency;
      if xCash > 0 then begin
        xIn := CurrencyToString(xCash);
        xInSum := xInSum + xCash;
        xOut := '';
      end else begin
        xOut := CurrencyToString((-1) * xCash);
        xOutSum := xOutSum + (-1) * xCash;
        xIn := '';
      end;
      Add('<td class="text" width="10%">' + IntToStr(RecNo) + '</td>');
      Add('<td class="text" width="50%">' + FieldByName('description').AsString + '</td>');
      Add('<td class="cash" width="20%">' + xIn + '</td>');
      Add('<td class="cash" width="20%">' + xOut + '</td>');
      Add('</tr>');
      Next;
    end;
    Add('</table><hr><table class="base" colspan=2>');
    Add('<tr class="base">');
    Add('<td class="sumtext" width="60%">Wszystkie konta</td>');
    Add('<td class="sumcash" width="20%">' + CurrencyToString(xInSum) + '</td>');
    Add('<td class="sumcash" width="20%">' + CurrencyToString(xOutSum) + '</td>');
    Add('</tr>');
    Add('</table>');
  end;
  xOperations.Free;
  Result := xBody.Text;
  xBody.Free;
end;

function TOperationsListReport.GetReportTitle: String;
begin
  Result := 'Operacje wykonane (' + DayName(FStartDate) + ', ' + DateToStr(FStartDate) + ' - ' +  DayName(FEndDate) + ', ' + DateToStr(FEndDate) + ')';
end;

function TOperationsListReport.PrepareReportConditions: Boolean;
begin
  Result := ChoosePeriodByForm(FStartDate, FEndDate);
end;

end.
