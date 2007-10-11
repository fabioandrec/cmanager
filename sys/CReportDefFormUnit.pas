unit CReportDefFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  CComponents, CDatabase, CBaseFrameUnit, ActnList, XPStyleActnCtrls,
  ActnMan, Contnrs, VirtualTrees, CReports;

type
  TCReportDefForm = class(TCDataobjectForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    EditName: TEdit;
    Label2: TLabel;
    RichEditDesc: TCRichedit;
    GroupBox2: TGroupBox;
    RicheditSql: TCRichedit;
    GroupBox3: TGroupBox;
    RicheditXslt: TCRichedit;
    ActionManager: TActionManager;
    ActionSql: TAction;
    ActionXsl: TAction;
    CButton2: TCButton;
    CButton1: TCButton;
    OpenDialog: TOpenDialog;
    CButton3: TCButton;
    ActionTemp: TAction;
    ActionParams: TAction;
    CButton4: TCButton;
    CButton5: TCButton;
    ActionAddParam: TAction;
    Label5: TLabel;
    ComboBoxxslType: TComboBox;
    procedure ActionSqlExecute(Sender: TObject);
    procedure ActionXslExecute(Sender: TObject);
    procedure ActionTempExecute(Sender: TObject);
    procedure ActionParamsExecute(Sender: TObject);
    procedure ActionAddParamExecute(Sender: TObject);
    procedure ComboBoxxslTypeChange(Sender: TObject);
  private
    FparamsDefs: TReportDialogParamsDefs;
    function CheckValidXsl: Boolean;
    function CheckValidParams: Boolean;
  protected
    procedure LoadFromFile(ASql: Boolean);
    procedure ReadValues; override;
    function GetDataobjectClass: TDataObjectClass; override;
    procedure FillForm; override;
    function CanAccept: Boolean; override;
    function GetUpdateFrameClass: TCBaseFrameClass; override;
    procedure InitializeForm; override;
  public
    destructor Destroy; override;
  end;

implementation

uses CInfoFormUnit, CDataObjects, CReportsFrameUnit, CRichtext, StrUtils,
  CTemplates, CDescpatternFormUnit, CXml, CBase64, CConsts;

{$R *.dfm}

function TCReportDefForm.CanAccept: Boolean;
begin
  if Trim(EditName.Text) = '' then begin
    Result := False;
    ShowInfo(itError, 'Nazwa raportu nie mo¿e byæ pusta', '');
    EditName.SetFocus;
  end else begin
    if (RicheditXslt.Text <> '') and (ComboBoxxslType.ItemIndex = 2) then begin
      Result := CheckValidXsl;
    end else begin
      Result := True;
    end;
    if Result then begin
      Result := CheckValidParams;
    end;
  end;
end;

procedure TCReportDefForm.FillForm;
var xBufferOut: String;
begin
  with TReportDef(Dataobject) do begin
    EditName.Text := name;
    SimpleRichText(description, RichEditDesc);
    if DecodeBase64Buffer(queryText, xBufferOut) then begin
      SimpleRichText(xBufferOut, RicheditSql);
    end else begin
      ShowInfo(itWarning, 'Dane zapytania tworz¹cego s¹ uszkodzone i nie zostan¹ wyœwietlone. Prawdopodobnie plik danych jest uszkodzony.' +
                          'Mo¿esz kontynuowaæ pracê, ale zalecane jest abyœ uruchomi³ CManager-a ponownie, wykona³ kopiê pliku danych ' +
                          'i nastêpnie kompaktowanie pliku danych.', '');
    end;
    if DecodeBase64Buffer(xsltText, xBufferOut) then begin
      SimpleRichText(xBufferOut, RicheditXslt);
    end else begin
      ShowInfo(itWarning, 'Dane arkusza styli s¹ uszkodzone i nie zostan¹ wyœwietlone. Prawdopodobnie plik danych jest uszkodzony.' +
                          'Mo¿esz kontynuowaæ pracê, ale zalecane jest abyœ uruchomi³ CManager-a ponownie, wykona³ kopiê pliku danych ' +
                          'i nastêpnie kompaktowanie pliku danych.', '');
    end;
    if DecodeBase64Buffer(paramsDefs, xBufferOut) then begin
      FparamsDefs.AsString := xBufferOut;
    end else begin
      ShowInfo(itWarning, 'Dane parametrów raportu s¹ uszkodzone i nie bêd¹ dostêpne. Prawdopodobnie plik danych jest uszkodzony.' +
                          'Mo¿esz kontynuowaæ pracê, ale zalecane jest abyœ uruchomi³ CManager-a ponownie, wykona³ kopiê pliku danych ' +
                          'i nastêpnie kompaktowanie pliku danych.', '');
    end;
    if xsltType = CXsltTypePrivate then begin
      ComboBoxxslType.ItemIndex := 2;
    end else if xsltType = CXsltTypeSystem then begin
      ComboBoxxslType.ItemIndex := 1;
    end else begin
      ComboBoxxslType.ItemIndex := 0;
    end;
  end;
  ComboBoxxslTypeChange(Nil);
end;

function TCReportDefForm.GetDataobjectClass: TDataObjectClass;
begin
  Result := TReportDef;
end;

function TCReportDefForm.GetUpdateFrameClass: TCBaseFrameClass;
begin
  Result := TCReportsFrame;
end;

procedure TCReportDefForm.LoadFromFile(ASql: Boolean);
var xFile: TStringList;
begin
  OpenDialog.Filter := IfThen(ASql, 'Pliki SQL|*.sql|Wszystkie pliki|*.*', 'Pliki XML|*.xml|Wszystkie pliki|*.*');
  OpenDialog.FilterIndex := 0;
  OpenDialog.DefaultExt := IfThen(ASql, 'sql', 'xml');
  if OpenDialog.Execute then begin
    xFile := TStringList.Create;
    try
      try
        xFile.LoadFromFile(OpenDialog.FileName);
        if ASql then begin
          SimpleRichText(xFile.Text, RicheditSql);
        end else begin
          SimpleRichText(xFile.Text, RicheditXslt);
        end;
      except
        on E: Exception do begin
          ShowInfo(itError, 'Nie uda³o siê otworzyæ pliku ' + OpenDialog.FileName, E.Message);
        end;
      end;
    finally
      xFile.Free;
    end;
  end;
end;

procedure TCReportDefForm.ReadValues;
var xBufferOut: String;
begin
  inherited ReadValues;
  with TReportDef(Dataobject) do begin
    name := EditName.Text;
    description := RichEditDesc.Text;
    EncodeBase64Buffer(RicheditSql.Text, xBufferOut);
    queryText := xBufferOut;
    EncodeBase64Buffer(RicheditXslt.Text, xBufferOut);
    xsltText := xBufferOut;
    EncodeBase64Buffer(FparamsDefs.AsString, xBufferOut);
    paramsDefs := xBufferOut;
    if ComboBoxxslType.ItemIndex = 2 then begin
      xsltType := CXsltTypePrivate;
    end else if ComboBoxxslType.ItemIndex = 1 then begin
      xsltType := CXsltTypeSystem;
    end else begin
      xsltType := CXsltTypeDefault;
    end;
  end;
end;

procedure TCReportDefForm.ActionSqlExecute(Sender: TObject);
begin
  LoadFromFile(True);
end;

procedure TCReportDefForm.ActionXslExecute(Sender: TObject);
begin
  LoadFromFile(False);
end;

procedure TCReportDefForm.ActionTempExecute(Sender: TObject);
var xData: TObjectList;
begin
  xData := TObjectList.Create(False);
  xData.Add(GBaseTemlatesList);
  EditAddTemplate(xData, Self, RicheditSql, False);
  xData.Free;
end;

function TCReportDefForm.CheckValidXsl: Boolean;
var xXml: ICXMLDOMDocument;
begin
  xXml := GetDocumentFromString(RicheditXslt.Text, Nil);
  Result := xXml.parseError.errorCode = 0;
  if not Result then begin
    ShowInfo(itError, 'Zdefiniowany arkusz styli jest niepoprawny', GetParseErrorDescription(xXml.parseError, True));
  end;
end;

procedure TCReportDefForm.InitializeForm;
begin
  inherited InitializeForm;
  FparamsDefs := TReportDialogParamsDefs.Create;
  FparamsDefs.AsString := '';
  ComboBoxxslTypeChange(Nil);
end;

destructor TCReportDefForm.Destroy;
begin
  FparamsDefs.Free;
  inherited Destroy;
end;

procedure TCReportDefForm.ActionParamsExecute(Sender: TObject);
begin
  FparamsDefs.ShowParamsDefsList(False, RicheditSql.Text);
end;

procedure TCReportDefForm.ActionAddParamExecute(Sender: TObject);
var xParam: String;
    xDesc: String;
    xSelStart, xSelLength: Integer;
begin
  xParam := FparamsDefs.ShowParamsDefsList(True, RicheditSql.Text);
  if xParam <> '' then begin
    xParam := '$' + xParam + '$';
    RicheditSql.Lines.BeginUpdate;
    xDesc := RicheditSql.Text;
    xSelStart := RicheditSql.SelStart + 1;
    xSelLength := RicheditSql.SelLength;
    System.Delete(xDesc, xSelStart, xSelLength);
    xDesc := Copy(xDesc, 1, xSelStart - 1) + xParam + Copy(xDesc, xSelStart, MaxInt);
    RicheditSql.Text := xDesc;
    RicheditSql.SelStart := xSelStart + Length(xParam) - 1;
    RicheditSql.SelLength := 0;
    RicheditSql.Lines.EndUpdate
  end;
end;

function TCReportDefForm.CheckValidParams: Boolean;
var xError: String;
    xPos: Integer;
begin
  Result := FparamsDefs.CheckStringWithParams(RicheditSql.Text, xError, xPos);
  if not Result then begin
    ShowInfo(itError, xError, '');
    if xPos > 0 then begin
      RicheditSql.SelStart := xPos;
      RicheditSql.SelLength := 0;
      RicheditSql.SetFocus;
    end;
  end;
end;

procedure TCReportDefForm.ComboBoxxslTypeChange(Sender: TObject);
begin
  CButton2.Enabled := ComboBoxxslType.ItemIndex = 2;
  RicheditXslt.Enabled := ComboBoxxslType.ItemIndex = 2;
end;

end.
