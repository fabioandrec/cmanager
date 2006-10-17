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

  TTodayCashInAccount = class(TCReport)
  protected
    function GetReportTitle: String; override;
    function GetReportBody: String; override;
  end;

implementation

uses Forms, SysUtils, CDatabase, Adodb;

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
  Result := 'CManager wer. ' + FileVersion(ParamStr(0));
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
    Fform.ShowModal;
  end;
  Fform.Free;
end;

function TTodayCashInAccount.GetReportBody: String;
var xDataset: TADOQuery;
    xSum: Currency;
    xBody: TStringList;
begin
  xDataset := GDataProvider.OpenSql('select * from account order by name');
  xSum := 0;
  xBody := TStringList.Create;
  with xDataset, xBody do begin
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
      Add('<td class="cash" width="25%">' + CurrencyToString(FieldByName('cash').AsCurrency) + '</td>');
      Add('</tr>');
      xSum := xSum + FieldByName('cash').AsCurrency;
      Next;
    end;
    Add('</table><hr><table class="base" colspan=2>');
    Add('<tr class="base">');
    Add('<td class="sumtext" width="75%">Wszystkie konta</td>');
    Add('<td class="sumcash" width="25%">' + CurrencyToString(xSum) + '</td>');
    Add('</tr>');
    Add('</table>');
  end;
  xDataset.Free;
  Result := xBody.Text;
  xBody.Free;
end;

function TTodayCashInAccount.GetReportTitle: String;
begin
  Result := 'Stan kont na dziœ (' + DateToStr(GWorkDate) + ')';
end;

end.
