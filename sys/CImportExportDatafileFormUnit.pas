unit CImportExportDatafileFormUnit;

interface

{$WARN UNIT_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CProgressFormUnit, ImgList, PngImageList, ComCtrls,
  CComponents, StdCtrls, Buttons, ExtCtrls, CDatabase;

type
  TImportExportOperation = (ieoImport, ieoExport);

  TCImportExportAdditionalData = class(TCProgressSimpleAdditionalData)
  private
    FOperation: TImportExportOperation;
  public
    constructor Create(AData: TObject; AOperation: TImportExportOperation); 
    property Operation: TImportExportOperation read FOperation;
  end;

  TCImportExportDatafileForm = class(TCProgressForm)
    CStaticFilename: TCStatic;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    procedure CStaticFilenameGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
  private
    FDataProvider: TDataProvider;
    FOperation: TImportExportOperation;
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

function TCImportExportDatafileForm.CanAccept: Boolean;
var xText: String;
begin
  Result := inherited CanAccept;
  if Result and (CStaticFilename.DataId = '') then begin
    case FOperation of
      ieoImport: xText := 'Nie wybra³eœ nazwy pliku, z którego dane maj¹ byæ zaimportowane';
      ieoExport: xText := 'Nie wybra³eœ nazwy pliku, w którym zostan¹ zapisane wyeksportowane dane';
    end;
    ShowInfo(itError, xText, '');
    Result := False;
  end;
end;

function TCImportExportDatafileForm.DoWork: TDoWorkResult;
var xStr: TStringList;
    xMin, xMax, xCount: Integer;
    xOk: Boolean;
begin
  Result := dwrError;
  AddToReport('Rozpoczêcie wykonywania ' + IfThen(FOperation = ieoImport, 'importu', 'eksportu') + ' pliku danych...');
  xStr := TStringList.Create;
  try
    if FOperation = ieoImport then begin
      try
        xStr.LoadFromFile(CStaticFilename.DataId);
        FDataProvider.BeginTransaction;
        if not FDataProvider.ExecuteSql(xStr.Text, False, False, ProgressEvent) then begin
          AddToReport('Podczas importu wyst¹pi³ b³¹d ' + DbLastError);
          AddToReport('Wykonywana komenda "' + DbLastStatement + '"');
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
    end else begin
      try
        xMin := Low(CDatafileTables);
        xMax := High(CDatafileTables);
        xCount := xMin;
        xOk := True;
        ProgressBar.Min := xMin;
        ProgressBar.Max := xMax;
        while (xCount <= xMax) and xOk do begin
          AddToReport('Eksportowanie tabeli ' + CDatafileTables[xCount]);
          if CDatafileDeletes[xCount] <> '' then begin
            xStr.Add('delete from ' + CDatafileDeletes[xCount] + ';');
          end;
          if not FDataProvider.ExportTable(CDatafileTables[xCount], CDatafileTablesExportConditions[xCount], CDatafileTablesExportOrders[xCount], xStr) then begin
            AddToReport('Podczas eksportu wyst¹pi³ b³¹d ' + DbLastError);
            AddToReport('Wykonywana komenda "' + DbLastStatement + '"');
            xOk := False;
          end;
          Inc(xCount);
          ProgressBar.StepBy(1);
        end;
        if xOk then begin
          xStr.SaveToFile(CStaticFilename.DataId);
          Result := dwrSuccess;
        end;
      except
        on E: Exception do begin
          AddToReport('Podczas eksportu wyst¹pi³ b³¹d ' + E.Message);
        end;
      end;
    end;
  finally
    xStr.Free;
  end;
  AddToReport('Procedura ' + IfThen(FOperation = ieoImport, 'importu', 'eksportu') + ' pliku danych zakoñczona ' + IfThen(Result = dwrSuccess, 'poprawnie', 'z b³êdami'));
end;

procedure TCImportExportDatafileForm.FinalizeLabels;
begin
  case FOperation of
    ieoImport: begin
      if DoWorkResult = dwrSuccess then begin
        LabelInfo.Caption := 'Zaimportowano do plik danych';
      end else if DoWorkResult = dwrError then begin
        LabelInfo.Caption := 'B³¹d importu do pliku danych';
      end;
    end;
    ieoExport: begin
      if DoWorkResult = dwrSuccess then begin
        LabelInfo.Caption := 'Wyeksportowano z pliku danych';
      end else if DoWorkResult = dwrError then begin
        LabelInfo.Caption := 'B³¹d eksportu z pliku danych';
      end;
    end;
  end;
end;

procedure TCImportExportDatafileForm.InitializeForm;
begin
  inherited InitializeForm;
  FDataProvider := TDataProvider(TCProgressSimpleAdditionalData(AdditionalData).Data);
  FOperation := TCImportExportAdditionalData(AdditionalData).Operation;
  LabelDescription.Caption := MinimizeName(FDataProvider.Filename, LabelDescription.Canvas, LabelDescription.Width);
  case FOperation of
    ieoImport: begin
      LabelInfo.Caption := 'Importuj do pliku danych';
      CImage.ImageIndex := 3;
      CStaticFilename.TextOnEmpty := '<kliknij tutaj aby wybraæ nazwê pliku Ÿród³owego>'
    end;
    ieoExport: begin
      LabelInfo.Caption := 'Eksportuj z pliku danych';
      CImage.ImageIndex := 4;
      CStaticFilename.TextOnEmpty := '<kliknij tutaj aby wybraæ nazwê pliku docelowego>'
    end;
  end;
end;

procedure TCImportExportDatafileForm.InitializeLabels;
begin
  case FOperation of
    ieoImport: LabelInfo.Caption := 'Trwa import do pliku danych';
    ieoExport: LabelInfo.Caption := 'Trwa eksport z pliku danych';
  end;
  CStaticFilename.Visible := False;
end;

constructor TCImportExportAdditionalData.Create(AData: TObject; AOperation: TImportExportOperation);
begin
  inherited Create(AData);
  FOperation := AOperation;
end;

procedure TCImportExportDatafileForm.CStaticFilenameGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
var xDialog: TOpenDialog;
begin
  if FOperation = ieoImport then begin
    xDialog := OpenDialog;
  end else begin
    xDialog := SaveDialog;
  end;
  AAccepted := xDialog.Execute;
  if AAccepted then begin
    ADataGid := xDialog.FileName;
    AText := MinimizeName(ADataGid, CStaticFilename.Canvas, CStaticFilename.Width);
  end;
end;

procedure TCImportExportDatafileForm.ProgressEvent(AMin, AMax, AStep: Integer);
begin
  if (ProgressBar.Min = 0) and (ProgressBar.Max = 0) then begin
    ProgressBar.Min := AMin;
    ProgressBar.Max := AMin;
  end;
  ProgressBar.StepBy(AStep);
end;

end.
