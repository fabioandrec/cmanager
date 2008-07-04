unit CImportDatafileFormUnit;

interface

{$WARN UNIT_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CProgressFormUnit, ImgList, PngImageList, ComCtrls,
  CComponents, StdCtrls, Buttons, ExtCtrls, CDatabase;

type
  TCImportDatafileForm = class(TCProgressForm)
    CStaticFilename: TCStatic;
    OpenDialog: TOpenDialog;
    procedure CStaticFilenameGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
  private
    FDataProvider: TDataProvider;
    procedure ProgressEvent(AMin, AMax, AStep: Integer);
  protected
    procedure InitializeLabels; override;
    procedure InitializeForm; override;
    function DoWork: TDoWorkResult; override;
    procedure FinalizeLabels; override;
    function CanAccept: Boolean; override;
  end;

implementation

{$R *.dfm}

uses FileCtrl, StrUtils, CAdox, CDataObjects, CInfoFormUnit;

function TCImportDatafileForm.CanAccept: Boolean;
begin
  Result := inherited CanAccept;
  if Result and (CStaticFilename.DataId = '') then begin
    ShowInfo(itError, 'Nie wybra³eœ nazwy pliku, z którego dane maj¹ byæ zaimportowane', '');
    Result := False;
  end;
end;

function TCImportDatafileForm.DoWork: TDoWorkResult;
var xStr: TStringList;
begin
  Result := dwrError;
  AddToReport('Rozpoczêcie wykonywania importu pliku danych...');
  xStr := TStringList.Create;
  try
    try
      xStr.LoadFromFile(CStaticFilename.DataId);
      FDataProvider.BeginTransaction;
      if not FDataProvider.ExecuteSql(xStr.Text, False, False, ProgressEvent) then begin
        AddToReport('Podczas importu wyst¹pi³ b³¹d ' + GDbLastError);
        AddToReport('Wykonywana komenda "' + GDbLastStatement + '"');
        FDataProvider.RollbackTransaction;
      end else begin
        FDataProvider.CommitTransaction;
        Result := dwrSuccess;
      end;
    except
      on E: Exception do begin
        AddToReport('Podczas importu wyst¹pi³ b³¹d ' + E.Message);
      end;
    end;
  finally
    xStr.Free;
  end;
  AddToReport('Procedura importu pliku danych zakoñczona ' + IfThen(Result = dwrSuccess, 'poprawnie', 'z b³êdami'));
end;

procedure TCImportDatafileForm.FinalizeLabels;
begin
  if DoWorkResult = dwrSuccess then begin
    LabelInfo.Caption := 'Zaimportowano do plik danych';
  end else if DoWorkResult = dwrError then begin
    LabelInfo.Caption := 'B³¹d importu do pliku danych';
  end;
end;

procedure TCImportDatafileForm.InitializeForm;
begin
  inherited InitializeForm;
  FDataProvider := TDataProvider(TCProgressSimpleAdditionalData(AdditionalData).Data);
  LabelDescription.Caption := MinimizeName(FDataProvider.Filename, LabelDescription.Canvas, LabelDescription.Width);
  LabelInfo.Caption := 'Importuj do pliku danych';
  CImage.ImageIndex := 3;
  CStaticFilename.TextOnEmpty := '<kliknij tutaj aby wybraæ nazwê pliku Ÿród³owego>'
end;

procedure TCImportDatafileForm.InitializeLabels;
begin
  LabelInfo.Caption := 'Trwa import do pliku danych';
  CStaticFilename.Visible := False;
end;

procedure TCImportDatafileForm.CStaticFilenameGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := OpenDialog.Execute;
  if AAccepted then begin
    ADataGid := OpenDialog.FileName;
    AText := MinimizeName(ADataGid, CStaticFilename.Canvas, CStaticFilename.Width);
  end;
end;

procedure TCImportDatafileForm.ProgressEvent(AMin, AMax, AStep: Integer);
begin
  if (ProgressBar.Min = 0) and (ProgressBar.Max = 0) then begin
    ProgressBar.Min := AMin;
    ProgressBar.Max := AMin;
  end;
  ProgressBar.StepBy(AStep);
end;

end.
