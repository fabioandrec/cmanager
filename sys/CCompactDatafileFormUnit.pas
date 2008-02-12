unit CCompactDatafileFormUnit;

interface

{$WARN UNIT_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CProgressFormUnit, ComCtrls, StdCtrls, Buttons, ExtCtrls,
  ImgList, PngImageList, CComponents;

type
  TCCompactDatafileForm = class(TCProgressForm)
    CStaticName: TCStatic;
    OpenDialog: TOpenDialog;
    Label1: TLabel;
    LabelPass: TLabel;
    EditPassword: TEdit;
    LabelProgress: TLabel;
    procedure CStaticNameGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
  protected
    function DoWork: Boolean; override;
    function GetProgressType: TWaitType; override;
    procedure InitializeForm; override;
    function CanAccept: Boolean; override;
  end;

implementation

{$R *.dfm}

uses FileCtrl, CDatabase, CMainFormUnit, CDatatools, CMemoFormUnit,
  StrUtils, CInfoFormUnit, CConsts, CTools, CAdox;

function TCCompactDatafileForm.DoWork: Boolean;
var xMustReconect: Boolean;
    xError, xDesc: String;
    xBeforeSize, xAfterSize: Int64;
    xText: String;
    xPrevDatabase: String;
    xStatus: TInitializeProviderResult;
begin
  AddToReport('Rozpoczêcie wykonywania kompaktowania pliku danych...');
  AddToReport('Plik ' + CStaticName.DataId);
  xMustReconect := GDatabaseName <> '';
  if xMustReconect then begin
    AddToReport('Zamykanie aktualnie wybranego pliku danych...');
    xPrevDatabase := GDatabaseName;
    SendMessage(CMainForm.Handle, WM_CLOSECONNECTION, 0, 0);
  end;
  xBeforeSize := FileSize(CStaticName.DataId);
  AddToReport('Kompaktowanie pliku danych...');
  Result := CompactDatabase(CStaticName.DataId, EditPassword.Text, xError);
  if Result then begin
    xAfterSize := FileSize(CStaticName.DataId);
    xText := 'Wykonano kompaktowanie pliku danych';
    AddToReport(xText);
    AddToReport(Format('Wielkoœci pliku danych: przed %.2f MB, po %.2f MB (mniej o %.2f', [xBeforeSize / (1024 * 1024), xAfterSize / (1024 * 1024), 100 - xAfterSize * 100 / xBeforeSize]) + '%)');
  end else begin
    xText := 'Kompaktowanie pliku danych zakoñczone b³êdem';
    AddToReport(xText);
    AddToReport(xError);
  end;
  if xMustReconect then begin
    AddToReport('Otwieranie poprzednio wybranego pliku danych...');
    xStatus := CMainForm.OpenConnection(xPrevDatabase, xError, xDesc);
    if xStatus = iprSuccess then begin
      CMainForm.ActionShortcutExecute(CMainForm.ActionShortcutStart);
      CMainForm.UpdateStatusbar;
    end else begin
      AddToReport('Nie mo¿na otworzyæ pliku danych ' + xError);
      AddToReport(xDesc);
    end;
  end;
  LabelEnd.Caption := xText;
  AddToReport('Procedura kompaktowania pliku danych zakoñczona ' + IfThen(Result, 'poprawnie', 'z b³êdami'));
end;

function TCCompactDatafileForm.GetProgressType: TWaitType;
begin
  Result := wtAnimate;
end;

procedure TCCompactDatafileForm.InitializeForm;
begin
  CStaticName.DataId := GDatabaseName;
  if GDatabaseName <> '' then begin
    CStaticName.Caption := MinimizeName(CStaticName.DataId, CStaticName.Canvas, CStaticName.Width);
  end;
  OpenDialog.FileName := GDatabaseName;
end;

procedure TCCompactDatafileForm.CStaticNameGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := OpenDialog.Execute;
  if AAccepted then begin
    ADataGid := OpenDialog.FileName;
    AText := MinimizeName(ADataGid, CStaticName.Canvas, CStaticName.Width);
  end;
end;

function TCCompactDatafileForm.CanAccept: Boolean;
begin
  Result := CStaticName.DataId <> '';
  if not Result then begin
    if ShowInfo(itQuestion, 'Nie wybrano pliku danych do skompaktowania. Czy chcesz wybraæ go teraz?', '') then begin
      CStaticName.DoGetDataId;
    end;
  end;
end;

end.
