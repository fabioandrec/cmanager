unit CReports;

interface

uses Classes, CReportFormUnit;

type
  TCReport = class(TObject)
  private
    FreportText: TStringList;
    Fform: TCReportForm;
    function GetreportText: String;
  protected
    procedure CleanReportData; virtual;
    function PrepareReportData: Boolean;
    function GetreportName: String; virtual;
  public
    procedure ShowReport;
    constructor Create;
    destructor Destroy; override;
  published
    property reportText: String read GetreportText;
    property reportName: String read GetreportName;
  end;

  TTestReport = class(TCReport)
  end;

implementation

uses Forms;

procedure TCReport.CleanReportData;
begin
end;

constructor TCReport.Create;
begin
  inherited Create;
  FreportText := TStringList.Create;
end;

destructor TCReport.Destroy;
begin
  CleanReportData;
  FreportText.Free;
  inherited Destroy;
end;

function TCReport.GetreportName: String;
begin
  Result := '<bez nazwy>';
end;

function TCReport.GetreportText: String;
begin
  Result := FreportText.Text;
end;

function TCReport.PrepareReportData: Boolean;
begin
  Result := True;
  FreportText.Text := '<HTML><HEAD><TITLE>template page</TITLE></HEAD><BODY BGCOLOR="#EDB681"><IMG src="d:\a.bmp"></BODY></HTML>';
end;

procedure TCReport.ShowReport;
begin
  if PrepareReportData then begin
    Fform := TCReportForm.Create(Nil);
    Fform.Caption := reportName;
    Fform.CBrowser.LoadFromString(reportText);
    Fform.ShowModal;
    Fform.Free;
  end;
end;

end.
