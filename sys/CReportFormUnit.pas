unit CReportFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, OleCtrls, SHDocVw,
  CComponents, ActnList, ImgList, PngImageList, CImageListsUnit;

type
  TCReportForm = class(TCConfigForm)
    ActionList: TActionList;
    Action1: TAction;
    Action2: TAction;
    Action3: TAction;
    CButton1: TCButton;
    CButton2: TCButton;
    CButton3: TCButton;
    SaveDialog: TSaveDialog;
    PanelReport: TCPanel;
    procedure Action1Execute(Sender: TObject);
    procedure Action3Execute(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
  private
    FReport: TObject;
  protected
    procedure DoPrint; virtual;
    procedure DoPreview; virtual;
    procedure DoSave; virtual;
    procedure DoAfterLoadPosition; override;
  public
    constructor CreateForm(AReport: TObject); virtual;
    property Report: TObject read FReport write FReport;
  end;

implementation

{$R *.dfm}

uses CReports;

procedure TCReportForm.DoPreview;
begin
end;

procedure TCReportForm.DoPrint;
begin
end;

procedure TCReportForm.Action1Execute(Sender: TObject);
begin
  DoPrint;
end;

procedure TCReportForm.Action3Execute(Sender: TObject);
begin
  DoSave;
end;

procedure TCReportForm.DoSave;
var xFilter, xDefExtension: String;
begin
  TCBaseReport(FReport).GetSaveDialogProperties(xFilter, xDefExtension);
  SaveDialog.Filter := xFilter;
  SaveDialog.DefaultExt := xDefExtension;
end;

procedure TCReportForm.Action2Execute(Sender: TObject);
begin
  DoPreview;
end;

constructor TCReportForm.CreateForm(AReport: TObject);
begin
  inherited Create(Nil);
  FReport := AReport;
end;

procedure TCReportForm.DoAfterLoadPosition;
begin
  inherited DoAfterLoadPosition;
  PanelReport.Width := PanelConfig.Width - 2 * PanelReport.Left;
  PanelReport.Height := PanelConfig.Height - 2 * PanelReport.Top;
end;

end.