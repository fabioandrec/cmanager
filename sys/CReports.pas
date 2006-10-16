unit CReports;

interface

uses Classes, CReportFormUnit, Graphics, Controls, Chart, Series, Contnrs, Windows,
     GraphUtil;

type
  TCReportClass = class of TCReport;

  TCReport = class(TObject)
  private
    FreportText: TStringList;
    Fform: TCReportForm;
    Fcharts: TObjectList;
    function GetreportText: String;
  protected
    procedure CleanReportData; virtual;
    function PrepareReportData: Boolean; virtual;
    function GetreportName: String; virtual;
    procedure UpdateReportHeader; virtual;
    procedure UpdateReportBody; virtual; abstract;
    procedure UpdateReportFooter; virtual;
  public
    procedure ShowReport;
    constructor Create;
    destructor Destroy; override;
    function GetChart: TChart;
  published
    property reportText: String read GetreportText;
    property reportName: String read GetreportName;
    property body: TStringList read FreportText;
  end;

  TTodayCashInAccount = class(TCReport)
  protected
    function GetreportName: String; override;
    procedure UpdateReportBody; override;
  end;

implementation

uses Forms, SysUtils, CDatabase, Adodb;

function ColToRgb(AColor: TColor): String;
var xRgb: Integer;
begin
  xRgb := ColorToRGB(AColor);
  Result := '"#' + Format('%.2x%.2x%.2x', [GetRValue(xRgb), GetGValue(xRgb), GetBValue(xRgb)]) + '"';
end;

procedure TCReport.CleanReportData;
begin
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

function TCReport.GetreportName: String;
begin
  Result := 'bez nazwy';
end;

function TCReport.GetreportText: String;
begin
  Result := FreportText.Text;
end;

function TCReport.PrepareReportData: Boolean;
begin
  Result := True;
  with FreportText do begin
    Add('<HTML>');
    Add('<HEAD>');
    Add('<TITLE>' + GetreportName + '</TITLE>');
    Add('</HEAD>');
    Add('<BODY>');
    UpdateReportHeader;
    UpdateReportBody;
    UpdateReportFooter;
    Add('</BODY>');
    Add('</HTML>');
  end;
end;

procedure TCReport.ShowReport;
begin
  Fform := TCReportForm.Create(Nil);
  if PrepareReportData then begin
    Fform.Caption := 'Raport';
    Fform.CBrowser.LoadFromString(reportText);
    Fform.ShowModal;
  end;
  Fform.Free;
end;

procedure TCReport.UpdateReportFooter;
begin
end;

procedure TCReport.UpdateReportHeader;
begin
  with FreportText do begin
    Add('<FONT FACE="VERDANA,ARIAL" SIZE=2 COLOR=' + ColToRgb(clInfoText) + '><B>' + GetreportName + '<B></FONT>');
    Add('<HR SIZE=1>');
  end;
end;

function TTodayCashInAccount.GetreportName: String;
begin
  Result := 'Stan kont na dziœ (' + DateToStr(GWorkDate) + ')';
end;

procedure TTodayCashInAccount.UpdateReportBody;
var xDataset: TADOQuery;
    xSum: Currency;
begin
  xDataset := GDataProvider.OpenSql('select * from account order by name');
  xSum := 0;
  with xDataset, body do begin
    Add('<TABLE COLSPAN=2 CELLSPACING=0 CELLPADDING=0 BORDER=0 WIDTH="100%">');
    Add('<TR BGCOLOR=' + ColToRgb(clActiveBorder) + '>');
    Add('<TD WIDTH="75%">Nazwa konta</TD>');
    Add('<TD ALIGN="RIGHT" WIDTH="25%">Saldo</TD>');
    Add('</TR>');
    Add('</TABLE>');
    Add('<HR SIZE=1>');
    Add('<TABLE COLSPAN=2 CELLSPACING=0 BORDER=0 WIDTH="100%">');
    while not Eof do begin
      if not Odd(RecNo) then begin
        Add('<TR BGCOLOR=' + ColToRgb(GetHighLightColor(clWindow, -10)) + '>');
      end else begin
        Add('<TR>');
      end;
      Add('<TD WIDTH="75%">' + FieldByName('name').AsString + '</TD>');
      Add('<TD ALIGN="RIGHT" WIDTH="25%">' + CurrencyToString(FieldByName('cash').AsCurrency) + '</TD>');
      Add('</TR>');
      xSum := xSum + FieldByName('cash').AsCurrency;
      Next;
    end;
    Add('</TABLE>');
    Add('<HR SIZE=1>');
    Add('<TABLE COLSPAN=2 CELLSPACING=0 BORDER=0 WIDTH="100%">');
    Add('<TR>');
    Add('<TD WIDTH="75%">Wszystkie konta</TD>');
    Add('<TD ALIGN="RIGHT" WIDTH="25%">' + CurrencyToString(xSum) + '</TD>');
    Add('</TR>');
    Add('</TABLE>');
    Add('<HR SIZE=1>');
  end;
  xDataset.Free;
end;

end.
