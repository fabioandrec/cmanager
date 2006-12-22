unit CArchFormUnit;

interface

{$WARN UNIT_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CProgressFormUnit, ImgList, PngImageList, ComCtrls, StdCtrls,
  CComponents, Buttons, ExtCtrls;

type
  TArchOperation = (aoBackup, aoRestore);

  TCArchForm = class(TCProgressForm)
    Label5: TLabel;
    CStaticSource: TCStatic;
    CStaticDest: TCStatic;
    Label2: TLabel;
    Label3: TLabel;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    procedure CStaticSourceGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticDestGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
  private
    FArchOperation: TArchOperation;
    procedure ProgressEvent(AStepBy: Integer);
  protected
    procedure ShowProgress(AAdditionalData: Pointer = nil); override;
    procedure InitializeForm; override;
    function CanAccept: Boolean; override;
    function DoWork: Boolean; override;
    function GetProgressType: TWaitType; override;
  end;


implementation

{$R *.dfm}

uses FileCtrl, CDatabase, CDatatools, CInfoFormUnit, CMainFormUnit,
     CConsts, StrUtils;

procedure TCArchForm.InitializeForm;
var xIndex: Integer;
begin
  inherited InitializeForm;
  if FArchOperation = aoBackup then begin
    xIndex := 4;
    Caption := 'Wykonywanie kopii pliku danych';
    Label2.Caption := 'Plik danych';
    Label3.Caption := 'Nazwa kopii';
    SaveDialog.Filter := 'Pliki kopii|*.cmb|Wszystkie pliki|*.*';
    SaveDialog.DefaultExt := '.cmg';
    OpenDialog.Filter := 'Pliki danych|*.dat|Wszystkie pliki|*.*';
    OpenDialog.DefaultExt := '.dat';
    if GDatabaseName <> '' then begin
      CStaticSource.DataId := GDatabaseName;
      CStaticSource.Caption := MinimizeName(CStaticSource.DataId, CStaticSource.Canvas, CStaticSource.Width);
      CStaticDest.DataId := GetDefaultBackupFilename(GDatabaseName);
      CStaticDest.Caption := MinimizeName(CStaticDest.DataId, CStaticDest.Canvas, CStaticDest.Width);
      OpenDialog.FileName := GDatabaseName;
      SaveDialog.FileName := CStaticDest.DataId;
    end;
  end else begin
    xIndex := 3;
    Caption := 'Odtwarzanie pliku danych z kopii';
    Label2.Caption := 'Nazwa kopii';
    Label3.Caption := 'Plik danych';
    CStaticSource.TextOnEmpty := '<kliknij tutaj aby wybraæ kopiê pliku danych>';
    CStaticDest.TextOnEmpty := '<kliknij tutaj aby nazwê pliku danych>';
    SaveDialog.Filter := 'Pliki danych|*.dat|Wszystkie pliki|*.*';
    SaveDialog.DefaultExt := '.dat';
    OpenDialog.Filter := 'Pliki kopii|*.cmb|Wszystkie pliki|*.*';
    OpenDialog.DefaultExt := '.cmg';
    OpenDialog.FileName := '';
    SaveDialog.FileName := '';
  end;
  CImageWork.ImageIndex := xIndex;
  CImageStart.ImageIndex := xIndex;
end;

procedure TCArchForm.ShowProgress(AAdditionalData: Pointer);
begin
  FArchOperation := TArchOperation(AAdditionalData^);
  inherited ShowProgress(AAdditionalData);
end;

procedure TCArchForm.CStaticSourceGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := OpenDialog.Execute;
  if AAccepted then begin
    ADataGid := OpenDialog.FileName;
    AText := MinimizeName(ADataGid, CStaticSource.Canvas, CStaticSource.Width);
  end;
end;

procedure TCArchForm.CStaticDestGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := SaveDialog.Execute;
  if AAccepted then begin
    ADataGid := SaveDialog.FileName;
    AText := MinimizeName(ADataGid, CStaticDest.Canvas, CStaticDest.Width);
  end;
end;

function TCArchForm.CanAccept: Boolean;
var xText: String;
begin
  Result := CStaticSource.DataId <> '';
  if not Result then begin
    if FArchOperation = aoBackup then begin
      xText := 'Nie wybrano pliku danych, dla którego ma zostaæ wykonana kopia. Czy chcesz wybraæ go teraz?';
    end else begin
      xText := 'Nie wybrano kopii pliku danych, która ma zostaæ wgrana. Czy chcesz wybraæ j¹ teraz?';
    end;
    if ShowInfo(itQuestion, xText, '') then begin
      CStaticSource.DoGetDataId;
    end;
  end;
  if Result then begin
    Result := FileExists(CStaticSource.DataId);
    if not Result then begin
      if FArchOperation = aoBackup then begin
        xText := 'Nie mo¿na znaleŸæ wybranego pliku danych.';
      end else begin
        xText := 'Nie mo¿na znaleŸæ wybranej kopii pliku danych.';
      end;
      ShowInfo(itError, xText, '');
    end;
  end;
  if Result then begin
    Result := CStaticDest.DataId <> '';
    if not Result then begin
      if FArchOperation = aoBackup then begin
        xText := 'Nie wybrano nazwy kopii pliku danych. Czy chcesz wybraæ j¹ teraz?';
      end else begin
        xText := 'Nie wybrano nazwy pliku danych. Czy chcesz wybraæ go teraz?';
      end;
      if ShowInfo(itQuestion, xText, '') then begin
        CStaticDest.DoGetDataId;
      end;
    end;
  end;
  if Result then begin
    Result := not FileExists(CStaticDest.DataId);
    if not Result then begin
      if FArchOperation = aoBackup then begin
        xText := 'Istnieje kopia pliku danych o nazwie ' + ExtractFileName(CStaticDest.DataId) + '. Czy potwierdzasz nadpisanie?';
      end else begin
        xText := 'Istnieje plik danych o nazwie ' + ExtractFileName(CStaticDest.DataId) + '. Czy potwierdzasz nadpisanie?';
      end;
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

function TCArchForm.DoWork: Boolean;
var xMustReconect: Boolean;
    xError, xDesc: String;
    xBeforeSize, xAfterSize: Int64;
    xText: String;
    xPrevDatabase: String;
begin
  if FArchOperation = aoBackup then begin
    AddToReport('Rozpoczêcie wykonywania kopii pliku danych...');
    Label5.Caption := 'Trwa wykonywanie kopii pliku danych...';
    Label5.Update;
  end else begin
    AddToReport('Rozpoczêcie wgrywania pliku danych z kopii...');
    Label5.Caption := 'Trwa wgrywanie pliku danych z kopii...';
    Label5.Update;
  end;
  AddToReport('Plik Ÿród³owy ' + CStaticSource.DataId);
  AddToReport('Plik docelowy ' + CStaticDest.DataId);
  xBeforeSize := FileSize(CStaticSource.DataId);
  xMustReconect := GDatabaseName <> '';
  if xMustReconect then begin
    AddToReport('Zamykanie aktualnie wybranego pliku danych...');
    xPrevDatabase := GDatabaseName;
    SendMessage(CMainForm.Handle, WM_CLOSECONNECTION, 0, 0);
  end;
  if FArchOperation = aoBackup then begin
    AddToReport('Wykonywanie kopii pliku danych...');
    Result := BackupDatabase(CStaticSource.DataId, CStaticDest.DataId, xError, True, ProgressEvent);
  end else begin
    AddToReport('Wgrywanie pliku danych z kopii...');
    Result := RestoreDatabase(CStaticSource.DataId, CStaticDest.DataId, xError, True, ProgressEvent);
  end;
  if Result then begin
    xAfterSize := FileSize(CStaticDest.DataId);
    if FArchOperation = aoBackup then begin
      xText := 'Wykonano kopiê pliku danych';
    end else begin
      xText := 'Wgrano plik danych z kopii';
    end;
    AddToReport(xText);
    if FArchOperation = aoBackup then begin
      AddToReport(Format('Wielkoœci pliku danych: %.2f MB, pliku kopii %.2f MB', [xBeforeSize / (1024 * 1024), xAfterSize / (1024 * 1024)]));
    end else begin
      AddToReport(Format('Wielkoœci pliku kopii: %.2f MB, pliku danych %.2f MB', [xBeforeSize / (1024 * 1024), xAfterSize / (1024 * 1024)]));
    end;
  end else begin
    if FArchOperation = aoBackup then begin
      xText := 'Wykonanie kopii pliku danych zakoñczone b³êdem';
    end else begin
      xText := 'Wgranie pliku danych z kopii zakoñczone b³êdem';
    end;
    AddToReport(xText);
    AddToReport(xError);
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
  if FArchOperation = aoBackup then begin
    AddToReport('Procedura tworzenia kopii pliku danych zakoñczona ' + IfThen(Result, 'poprawnie', 'z b³êdami'));
  end else begin
    AddToReport('Procedura wgrywania pliku danych z kopii zakoñczona ' + IfThen(Result, 'poprawnie', 'z b³êdami'));
  end;
end;

procedure TCArchForm.ProgressEvent(AStepBy: Integer);
begin
  ProgressBar.Position := AStepBy;
end;

function TCArchForm.GetProgressType: TWaitType;
begin
  Result := wtProgressbar;
end;

end.
