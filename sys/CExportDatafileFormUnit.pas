unit CExportDatafileFormUnit;

interface

{$WARN UNIT_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CProgressFormUnit, ImgList, PngImageList, CComponents, StdCtrls,
  ComCtrls, Buttons, ExtCtrls, FileCtrl;

type
  TCExportDatafileForm = class(TCProgressForm)
    Label3: TLabel;
    CStaticDest: TCStatic;
    Label2: TLabel;
    CStaticSource: TCStatic;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    Label5: TLabel;
    procedure CStaticSourceGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticDestGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
  private
    procedure ProgressEvent(AStepBy: Integer);
  protected
    function CanAccept: Boolean; override;
    function GetProgressType: TWaitType; override;
    function DoWork: Boolean; override;
    procedure InitializeForm; override;
  end;

implementation

{$R *.dfm}

uses StrUtils, CInfoFormUnit, CDatabase, CMainFormUnit, CConsts,
  CDatatools;

procedure TCExportDatafileForm.CStaticSourceGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := OpenDialog.Execute;
  if AAccepted then begin
    ADataGid := OpenDialog.FileName;
    AText := MinimizeName(ADataGid, CStaticSource.Canvas, CStaticSource.Width);
  end;
end;

procedure TCExportDatafileForm.CStaticDestGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := SaveDialog.Execute;
  if AAccepted then begin
    ADataGid := SaveDialog.FileName;
    AText := MinimizeName(ADataGid, CStaticDest.Canvas, CStaticDest.Width);
  end;
end;

function TCExportDatafileForm.CanAccept: Boolean;
var xText: String;
begin
  Result := CStaticSource.DataId <> '';
  if not Result then begin
    xText := 'Nie wybrano pliku danych, który ma zostaæ wyeksportowany. Czy chcesz wybraæ go teraz?';
    if ShowInfo(itQuestion, xText, '') then begin
      CStaticSource.DoGetDataId;
    end;
  end;
  if Result then begin
    Result := FileExists(CStaticSource.DataId);
    if not Result then begin
      xText := 'Nie mo¿na znaleŸæ wybranego pliku danych.';
      ShowInfo(itError, xText, '');
    end;
  end;
  if Result then begin
    Result := CStaticDest.DataId <> '';
    if not Result then begin
      xText := 'Nie wybrano nazwy pliku eksportu. Czy chcesz wybraæ j¹ teraz?';
      if ShowInfo(itQuestion, xText, '') then begin
        CStaticDest.DoGetDataId;
      end;
    end;
  end;
  if Result then begin
    Result := not FileExists(CStaticDest.DataId);
    if not Result then begin
      xText := 'Istnieje plik eksportu o nazwie ' + ExtractFileName(CStaticDest.DataId) + '. Czy potwierdzasz nadpisanie?';
      Result := ShowInfo(itQuestion, xText, '');
    end;
  end;
  if Result then begin
    Result := CStaticSource.DataId <> CStaticDest.DataId;
    if not Result then begin
      ShowInfo(itError, 'Plik Ÿród³owy jest taki sam jak plik docelowy.', '');
    end;
  end;
end;

function TCExportDatafileForm.GetProgressType: TWaitType;
begin
  Result := wtProgressbar;
end;

function TCExportDatafileForm.DoWork: Boolean;
var xMustReconect: Boolean;
    xError, xDesc: String;
    xText: String;
    xPrevDatabase: String;
    xReport: TStringList;
begin
  AddToReport('Rozpoczêcie wykonywania eksportu pliku danych...');
  Label5.Caption := 'Trwa wykonywanie eksportu pliku danych...';
  Label5.Update;
  ProgressBar.Min := 0;
  ProgressBar.Max := 100;
  ProgressBar.Position := 0;
  AddToReport('Plik Ÿród³owy ' + CStaticSource.DataId);
  AddToReport('Plik docelowy ' + CStaticDest.DataId);
  xMustReconect := GDatabaseName <> '';
  if xMustReconect then begin
    AddToReport('Zamykanie aktualnie wybranego pliku danych...');
    xPrevDatabase := GDatabaseName;
    SendMessage(CMainForm.Handle, WM_CLOSECONNECTION, 0, 0);
  end;
  AddToReport('Wykonywanie eksportu pliku danych...');
  xReport := TStringList.Create;
  Result := ExportDatabase(CStaticSource.DataId, CStaticDest.DataId, xError, xReport, ProgressEvent);
  if xReport.Count > 0 then begin
    Report.Text := Report.Text + xReport.Text;
  end;
  xReport.Free;
  if Result then begin
    xText := 'Wykonano eksport pliku danych';
    AddToReport(xText);
  end else begin
    xText := 'Wykonanie eksportu pliku danych zakoñczone b³êdem';
    AddToReport(xText);
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
  AddToReport('Procedura tworzenia eksportu pliku danych zakoñczona ' + IfThen(Result, 'poprawnie', 'z b³êdami'));
end;

procedure TCExportDatafileForm.ProgressEvent(AStepBy: Integer);
begin
  ProgressBar.Position := AStepBy;
end;

procedure TCExportDatafileForm.InitializeForm;
begin
  CStaticSource.DataId := GDatabaseName;
  if GDatabaseName <> '' then begin
    CStaticSource.Caption := MinimizeName(CStaticSource.DataId, CStaticSource.Canvas, CStaticSource.Width);
  end;
  OpenDialog.FileName := GDatabaseName;
end;

end.
 