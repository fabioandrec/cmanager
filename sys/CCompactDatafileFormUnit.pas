unit CCompactDatafileFormUnit;

interface

{$WARN UNIT_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CProgressFormUnit, ImgList, PngImageList, ComCtrls,
  CComponents, StdCtrls, Buttons, ExtCtrls, CDatabase;

type
  TCCompactDatafileForm = class(TCProgressForm)
  private
    FDataProvider: TDataProvider;
  protected
    procedure InitializeLabels; override;
    procedure InitializeForm; override;
    function DoWork: TDoWorkResult; override;
    function GetProgressType: TWaitType; override;
    procedure FinalizeLabels; override;
  end;

implementation

uses FileCtrl, CInitializeProviderFormUnit, CMainFormUnit,
  CConsts, CTools, CAdox, StrUtils;

{$R *.dfm}

function TCCompactDatafileForm.DoWork: TDoWorkResult;
var xError, xDesc: String;
    xBeforeSize, xAfterSize: Int64;
    xText: String;
    xPrevDatabase, xPrevPassword: String;
    xStatus: TInitializeProviderResult;
begin
  AddToReport('Rozpoczêcie wykonywania kompaktowania pliku danych...');
  AddToReport('Zamykanie pliku danych...');
  xPrevDatabase := FDataProvider.Filename;
  xPrevPassword := FDataProvider.Password;
  SendMessage(CMainForm.Handle, WM_CLOSECONNECTION, 0, 0);
  xBeforeSize := FileSize(xPrevDatabase);
  AddToReport('Kompaktowanie pliku danych...');
  if DbCompactDatabase(xPrevDatabase, xPrevPassword, xError) then begin
    xAfterSize := FileSize(xPrevDatabase);
    xText := 'Wykonano kompaktowanie pliku danych';
    AddToReport(xText);
    AddToReport(Format('Wielkoœci pliku danych: przed %.2f MB, po %.2f MB (mniej o %.2f', [xBeforeSize / (1024 * 1024), xAfterSize / (1024 * 1024), 100 - xAfterSize * 100 / xBeforeSize]) + '%)');
    Result := dwrSuccess;
  end else begin
    xText := 'Kompaktowanie pliku danych zakoñczone b³êdem';
    AddToReport(xText);
    AddToReport(xError);
    Result := dwrError;
  end;
  AddToReport('Otwieranie pliku danych...');
  xStatus := InitializeDataProvider(xPrevDatabase, xPrevPassword, FDataProvider);
  if xStatus = iprSuccess then begin
    CMainForm.ActionShortcutExecute(CMainForm.ActionShortcutStart);
    CMainForm.UpdateStatusbar;
  end else begin
    AddToReport('Nie mo¿na otworzyæ pliku danych ' + xError);
    AddToReport(xDesc);
  end;
  AddToReport('Procedura kompaktowania pliku danych zakoñczona ' + IfThen(Result = dwrSuccess, 'poprawnie', 'z b³êdami'));
end;


procedure TCCompactDatafileForm.FinalizeLabels;
begin
  if DoWorkResult = dwrSuccess then begin
    LabelInfo.Caption := 'Plik danych zosta³ skompaktowany';
  end else if DoWorkResult = dwrError then begin
    LabelInfo.Caption := 'B³¹d kompaktowania pliku danych';
  end;
end;

function TCCompactDatafileForm.GetProgressType: TWaitType;
begin
  Result := wtAnimate;
end;

procedure TCCompactDatafileForm.InitializeForm;
begin
  inherited InitializeForm;
  FDataProvider := TDataProvider(TCProgressSimpleAdditionalData(AdditionalData).Data);
  LabelDescription.Caption := MinimizeName(FDataProvider.Filename, LabelDescription.Canvas, LabelDescription.Width);
end;

procedure TCCompactDatafileForm.InitializeLabels;
begin
  LabelInfo.Caption := 'Trwa kompaktowanie pliku danych';
end;

end.
 