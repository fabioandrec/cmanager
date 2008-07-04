unit CExportDatafileFormUnit;

interface

{$WARN UNIT_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CProgressFormUnit, ImgList, PngImageList, ComCtrls,
  CComponents, StdCtrls, Buttons, ExtCtrls, CDatabase, CXml;

type
  TCExportDatafileForm = class(TCProgressForm)
    CStaticFilename: TCStatic;
    SaveDialog: TSaveDialog;
    CStaticTables: TCStatic;
    procedure CStaticFilenameGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CStaticTablesGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
  private
    FDataProvider: TDataProvider;
    FTables: TStringList;
    FDefaultData: ICXMLDOMDocument;
  protected
    procedure InitializeLabels; override;
    procedure InitializeForm; override;
    function DoWork: TDoWorkResult; override;
    procedure FinalizeLabels; override;
    function CanAccept: Boolean; override;
  end;

implementation

{$R *.dfm}

uses FileCtrl, StrUtils, CAdox, CDataObjects, CInfoFormUnit, CXmlFrameUnit,
  CTools, CXmlTlb;

function TCExportDatafileForm.CanAccept: Boolean;
begin
  Result := inherited CanAccept;
  if Result and (CStaticFilename.DataId = '') then begin
    ShowInfo(itError, 'Nie wybra³eœ nazwy pliku, w którym zostan¹ zapisane wyeksportowane dane', '');
    Result := False;
  end;
end;

function TCExportDatafileForm.DoWork: TDoWorkResult;
var xStr: TStringList;
    xOk: Boolean;
    xNode: ICXMLDOMNode;
    xId: TDataGid;
begin
  Result := dwrError;
  AddToReport('Rozpoczêcie wykonywania eksportu pliku danych...');
  xStr := TStringList.Create;
  try
    try
      xOk := True;
      ProgressBar.Min := 0;
      ProgressBar.Max := FDefaultData.documentElement.childNodes.length - 1;
      xNode := FDefaultData.documentElement.firstChild;
      while (xNode <> Nil) and xOk do begin
        xId := GetXmlAttribute('id', xNode, CEmptyDataGid);
        if ((FTables.Count = 0) or (FTables.IndexOf(xId) >= 0)) then begin
          AddToReport('Eksportowanie tabeli ' + GetXmlAttribute('name', xNode, ''));
          if GetXmlAttribute('exportDeletes', xNode, 0) <> 0 then begin
            xStr.Add('delete from ' + GetXmlAttribute('name', xNode, '') + ';');
          end;
          if not FDataProvider.ExportTable(GetXmlAttribute('name', xNode, ''), GetXmlAttribute('exportCondition', xNode, ''), GetXmlAttribute('exportOrder', xNode, ''), xStr) then begin
            AddToReport('Podczas eksportu wyst¹pi³ b³¹d ' + GDbLastError);
            AddToReport('Wykonywana komenda "' + GDbLastStatement + '"');
            xOk := False;
          end;
        end;
        xNode := xNode.nextSibling;
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
  finally
    xStr.Free;
  end;
  AddToReport('Procedura eksportu pliku danych zakoñczona ' + IfThen(Result = dwrSuccess, 'poprawnie', 'z b³êdami'));
end;

procedure TCExportDatafileForm.FinalizeLabels;
begin
  if DoWorkResult = dwrSuccess then begin
    LabelInfo.Caption := 'Wyeksportowano z pliku danych';
  end else if DoWorkResult = dwrError then begin
    LabelInfo.Caption := 'B³¹d eksportu z pliku danych';
  end;
end;

procedure TCExportDatafileForm.InitializeForm;
var xXmlString: String;
begin
  inherited InitializeForm;
  xXmlString := GetStringFromResources('TABLEDEFS', RT_RCDATA, HInstance);
  FDefaultData := GetDocumentFromString(xXmlString, Nil);
  SetXmlIdForEach(FDefaultData.documentElement.childNodes, True);
  FDataProvider := TDataProvider(TCProgressSimpleAdditionalData(AdditionalData).Data);
  LabelDescription.Caption := MinimizeName(FDataProvider.Filename, LabelDescription.Canvas, LabelDescription.Width);
  LabelInfo.Caption := 'Eksportuj z pliku danych';
  CImage.ImageIndex := 4;
  CStaticFilename.TextOnEmpty := '<kliknij tutaj aby wybraæ nazwê pliku docelowego>'
end;

procedure TCExportDatafileForm.InitializeLabels;
begin
  LabelInfo.Caption := 'Trwa eksport z pliku danych';
  CStaticFilename.Visible := False;
end;

procedure TCExportDatafileForm.CStaticFilenameGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := SaveDialog.Execute;
  if AAccepted then begin
    ADataGid := SaveDialog.FileName;
    AText := MinimizeName(ADataGid, CStaticFilename.Canvas, CStaticFilename.Width);
  end;
end;

procedure TCExportDatafileForm.FormCreate(Sender: TObject);
begin
  inherited;
  FTables := TStringList.Create;
end;

procedure TCExportDatafileForm.FormDestroy(Sender: TObject);
begin
  FTables.Free;
  inherited;
end;

procedure TCExportDatafileForm.CStaticTablesGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
var xId, xText: String;
begin
  ShowXmlFile(FDefaultData, FTables,
              'Zaznacz tylko tabele, które chcesz wyeksportowaæ',
              'Wybór tabel do eksportu', xId, xText);
end;

end.
