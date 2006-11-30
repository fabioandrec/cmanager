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
    Label2: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    CStaticDesc: TCStatic;
    procedure CStaticNameGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticDescGetDataId(var ADataGid, AText: String;
      var AAccepted: Boolean);
  protected
    function DoWork: Boolean; override;
    function GetProgressType: TWaitType; override;
    procedure InitializeForm; override;
  end;

implementation

{$R *.dfm}

uses FileCtrl, CDatabase, CMainFormUnit, CDatatools, CMemoFormUnit,
  StrUtils;

function TCCompactDatafileForm.DoWork: Boolean;
var xMustReconect: Boolean;
    xError, xDesc: String;
    xBeforeSize, xAfterSize: Int64;
    xText: String;
begin
  AddToReport('Rozpoczêcie wykonywania kompaktowania pliku danych...');
  AddToReport('Plik ' + CStaticName.DataId);
  xMustReconect := GDataProvider.IsConnected;
  if xMustReconect then begin
    AddToReport('Zamykanie aktualnie wybranego pliku danych...');
    CMainForm.ActionCloseConnection.Execute;
  end;
  xBeforeSize := FileSize(CStaticName.DataId);
  AddToReport('Kompaktowanie pliku danych...');
  Result := CompactDatabase(CStaticName.DataId, xError);
  if Result then begin
    xAfterSize := FileSize(CStaticName.DataId);
    xText := 'Wykonano kompaktowanie pliku danych';
    AddToReport(xText);
    AddToReport(Format('Wielkoœci pliku danych %.2f MB przed, %.2f MB po (%.2f', [xBeforeSize / (1024 * 1024), xAfterSize / (1024 * 1024), xAfterSize * 100 / xBeforeSize]) + '%)');
  end else begin
    xText := 'Kompaktowanie pliku danych zakoñczone b³êdem';
    AddToReport(xText);
    AddToReport(xError);
  end;
  if xMustReconect then begin
    AddToReport('Otwieranie poprzednio wybranego pliku danych...');
    if CMainForm.OpenConnection(GDatabaseName, xError, xDesc) then begin
      CMainForm.ActionShortcutExecute(CMainForm.ActionShorcutOperations);
      CMainForm.UpdateStatusbar;
    end else begin
      AddToReport('Nie mo¿na otworzyæ pliku danych ' + xError);
      AddToReport(xDesc);
    end;
  end;
  Label3.Caption := xText;
  AddToReport('Procedura kompaktowania pliku danych zakoñczona ' + IfThen(Result, 'poprawnie', 'z b³êdami'));
end;

function TCCompactDatafileForm.GetProgressType: TWaitType;
begin
  Result := wtAnimate;
end;

procedure TCCompactDatafileForm.InitializeForm;
begin
  CStaticName.DataId := GDatabaseName;
  CStaticName.Caption := MinimizeName(CStaticName.DataId, CStaticName.Canvas, CStaticName.Width);
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

procedure TCCompactDatafileForm.CStaticDescGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := False;
  ShowReport('Raport z wykonanych czynnoœci', Report.Text, 400, 300);
end;

end.
