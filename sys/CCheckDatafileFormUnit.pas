unit CCheckDatafileFormUnit;

interface

{$WARN UNIT_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CProgressFormUnit, ComCtrls, StdCtrls, Buttons, ExtCtrls,
  ImgList, PngImageList, CComponents;

type
  TCCheckDatafileFormUnit = class(TCProgressForm)
    CStaticName: TCStatic;
    OpenDialog: TOpenDialog;
    Label2: TLabel;
    Label1: TLabel;
    procedure CStaticNameGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
  private
    procedure ProgressEvent(AStepBy: Integer);
  protected
    function DoWork: Boolean; override;
    function GetProgressType: TWaitType; override;
    procedure InitializeForm; override;
    function CanAccept: Boolean; override;
  end;

implementation

{$R *.dfm}

uses FileCtrl, CDatabase, CMainFormUnit, CDatatools, CMemoFormUnit,
  StrUtils, CInfoFormUnit, CConsts;

function TCCheckDatafileFormUnit.DoWork: Boolean;
var xMustReconect: Boolean;
    xError, xDesc: String;
    xText: String;
    xPrevDatabase: String;
    xReport: TStringList;
begin
  AddToReport('Rozpoczêcie wykonywania sprawdzania pliku danych...');
  AddToReport('Plik ' + CStaticName.DataId);
  xMustReconect := GDatabaseName <> '';
  if xMustReconect then begin
    AddToReport('Zamykanie aktualnie wybranego pliku danych...');
    xPrevDatabase := GDatabaseName;
    SendMessage(CMainForm.Handle, WM_CLOSECONNECTION, 0, 0);
  end;
  AddToReport('Sprawdzanie pliku danych...');
  xReport := TStringList.Create;
  Result := CheckDatabase(CStaticName.DataId, xError, xReport, ProgressEvent);
  if xReport.Count > 0 then begin
    Report.Text := Report.Text + xReport.Text;
  end;
  xReport.Free;
  if Result then begin
    xText := 'Wykonano sprawdzanie pliku danych';
    AddToReport(xText);
  end else begin
    xText := 'Sprawdzanie pliku danych zakoñczone b³êdem';
    AddToReport(xText);
    if xError <> '' then begin
      AddToReport(xError);
    end;
  end;
  if xMustReconect then begin
    AddToReport('Otwieranie poprzednio wybranego pliku danych...');
    if CMainForm.OpenConnection(xPrevDatabase, xError, xDesc) then begin
      CMainForm.ActionShortcutExecute(CMainForm.ActionShortcutStart);
      CMainForm.UpdateStatusbar;
    end else begin
      AddToReport('Nie mo¿na otworzyæ pliku danych ' + xError);
      AddToReport(xDesc);
    end;
  end;
  LabelEnd.Caption := xText;
  AddToReport('Procedura sprawdzania pliku danych zakoñczona ' + IfThen(Result, 'poprawnie', 'z b³êdami'));
end;

function TCCheckDatafileFormUnit.GetProgressType: TWaitType;
begin
  Result := wtProgressbar;
end;

procedure TCCheckDatafileFormUnit.InitializeForm;
begin
  CStaticName.DataId := GDatabaseName;
  if GDatabaseName <> '' then begin
    CStaticName.Caption := MinimizeName(CStaticName.DataId, CStaticName.Canvas, CStaticName.Width);
  end;
  OpenDialog.FileName := GDatabaseName;
end;

procedure TCCheckDatafileFormUnit.CStaticNameGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := OpenDialog.Execute;
  if AAccepted then begin
    ADataGid := OpenDialog.FileName;
    AText := MinimizeName(ADataGid, CStaticName.Canvas, CStaticName.Width);
  end;
end;

function TCCheckDatafileFormUnit.CanAccept: Boolean;
begin
  Result := CStaticName.DataId <> '';
  if not Result then begin
    if ShowInfo(itQuestion, 'Nie wybrano pliku danych do skompaktowania. Czy chcesz wybraæ go teraz?', '') then begin
      CStaticName.DoGetDataId;
    end;
  end;
end;

procedure TCCheckDatafileFormUnit.ProgressEvent(AStepBy: Integer);
begin
  ProgressBar.StepBy(AStepBy);
  Application.ProcessMessages;
end;

end.
