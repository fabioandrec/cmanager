unit CArchDatafileFormUnit;

interface

{$WARN UNIT_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CProgressFormUnit, ImgList, PngImageList, ComCtrls,
  CComponents, StdCtrls, Buttons, ExtCtrls, CDatabase;

type
  TArchOperation = (aoBackup, aoRestore);

  TCArchAdditionalData = class(TCProgressSimpleAdditionalData)
  private
    FOperation: TArchOperation;
  public
    constructor Create(AData: TObject; AOperation: TArchOperation);
    property Operation: TArchOperation read FOperation;
  end;

  TCArchDatafileForm = class(TCProgressForm)
    CStaticFilename: TCStatic;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    procedure CStaticFilenameGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
  private
    FDataProvider: TDataProvider;
    FOperation: TArchOperation;
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

function TCArchDatafileForm.CanAccept: Boolean;
var xText: String;
begin
  Result := inherited CanAccept;
  if Result then begin
    if(CStaticFilename.DataId = '') then begin
      case FOperation of
        aoRestore: xText := 'Nie wybra³eœ nazwy i lokalizacji pliku archiwum, które ma zostaæ odtworzone';
        aoBackup: xText := 'Nie wybra³eœ nazwy i lokalizacji pliku archiwum, które ma byæ utworzone';
      end;
      ShowInfo(itError, xText, '');
      Result := False;
    end else if FOperation = aoRestore then begin
      Result := ShowInfo(itQuestion, 'Wykonanie importu do pliku danych mo¿e spowodowaæ zast¹pienie\n' +
                                     'wszystkich danych znajduj¹cych siê w aktualnie otwartym pliku danych.\n' +
                                     'Czy jesteœ pewny, ¿e chcesz wykonaæ import?', '');
    end;
  end;
end;

function TCArchDatafileForm.DoWork: TDoWorkResult;
var xStr: TStringList;
    xMin, xMax, xCount: Integer;
    xOk: Boolean;
begin
  Result := dwrError;
  AddToReport('Rozpoczêcie wykonywania ' + IfThen(FOperation = aoBackup, 'kopii', 'odtwarzania') + ' pliku danych...');
  xStr := TStringList.Create;
  try
    if FOperation = aoBackup then begin
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
  AddToReport('Procedura ' + IfThen(FOperation = aoBackup, 'kopii', 'odtwarzania') + ' pliku danych zakoñczona ' + IfThen(Result = dwrSuccess, 'poprawnie', 'z b³êdami'));
end;

procedure TCArchDatafileForm.FinalizeLabels;
begin
  case FOperation of
    aoBackup: begin
      if DoWorkResult = dwrSuccess then begin
        LabelInfo.Caption := 'Wykonano kopiê pliku danych';
      end else if DoWorkResult = dwrError then begin
        LabelInfo.Caption := 'B³¹d wykonywania kopii pliku danych';
      end;
    end;
    aoRestore: begin
      if DoWorkResult = dwrSuccess then begin
        LabelInfo.Caption := 'Odtworzono plik danych z kopii';
      end else if DoWorkResult = dwrError then begin
        LabelInfo.Caption := 'B³¹d odtwarzania pliku danych z kopii';
      end;
    end;
  end;
end;

procedure TCArchDatafileForm.InitializeForm;
begin
  inherited InitializeForm;
  FDataProvider := TDataProvider(TCProgressSimpleAdditionalData(AdditionalData).Data);
  FOperation := TCArchAdditionalData(AdditionalData).Operation;
  LabelDescription.Caption := MinimizeName(FDataProvider.Filename, LabelDescription.Canvas, LabelDescription.Width);
  case FOperation of
    aoBackup: begin
      LabelInfo.Caption := 'Archiwizuj plik danych';
      CImage.ImageIndex := 3;
      CStaticFilename.TextOnEmpty := '<kliknij tutaj aby wybraæ nazwê pliku Ÿród³owego>'
    end;
    aoRestore: begin
      LabelInfo.Caption := 'Odtwórz plik danych';
      CImage.ImageIndex := 4;
      CStaticFilename.TextOnEmpty := '<kliknij tutaj aby wybraæ nazwê pliku docelowego>'
    end;
  end;
end;

procedure TCArchDatafileForm.InitializeLabels;
begin
  case FOperation of
    aoBackup: LabelInfo.Caption := 'Trwa wykonywanie kopii pliku danych';
    aoRestore: LabelInfo.Caption := 'Trwa odtwarzanie pliku danych';
  end;
  CStaticFilename.Visible := False;
end;

constructor TCArchAdditionalData.Create(AData: TObject; AOperation: TArchOperation);
begin
  inherited Create(AData);
  FOperation := AOperation;
end;

procedure TCArchDatafileForm.CStaticFilenameGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
var xDialog: TOpenDialog;
begin
  if FOperation = aoRestore then begin
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

procedure TCArchDatafileForm.ProgressEvent(AMin, AMax, AStep: Integer);
begin
  if (ProgressBar.Min = 0) and (ProgressBar.Max = 0) then begin
    ProgressBar.Min := AMin;
    ProgressBar.Max := AMin;
  end;
  ProgressBar.StepBy(AStep);
end;

end.
