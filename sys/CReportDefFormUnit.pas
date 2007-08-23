unit CReportDefFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  CComponents, CDatabase, CBaseFrameUnit;

type
  TCReportDefForm = class(TCDataobjectForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    EditName: TEdit;
    Label2: TLabel;
    RichEditDesc: TCRichedit;
    GroupBox2: TGroupBox;
    RicheditSql: TCRichedit;
    Label3: TLabel;
  protected
    procedure ReadValues; override;
    function GetDataobjectClass: TDataObjectClass; override;
    procedure FillForm; override;
    function CanAccept: Boolean; override;
    function GetUpdateFrameClass: TCBaseFrameClass; override;
  end;

implementation

uses CInfoFormUnit, CDataObjects, CReportsFrameUnit, CRichtext;

{$R *.dfm}

function TCReportDefForm.CanAccept: Boolean;
begin
  Result := inherited CanAccept;
  if Trim(EditName.Text) = '' then begin
    Result := False;
    ShowInfo(itError, 'Nazwa raportu nie mo¿e byæ pusta', '');
    EditName.SetFocus;
  end;
end;

procedure TCReportDefForm.FillForm;
begin
  with TReportDef(Dataobject) do begin
    EditName.Text := name;
    SimpleRichText(description, RichEditDesc);
    SimpleRichText(queryText, RicheditSql);
  end;
end;

function TCReportDefForm.GetDataobjectClass: TDataObjectClass;
begin
  Result := TReportDef;
end;

function TCReportDefForm.GetUpdateFrameClass: TCBaseFrameClass;
begin
  Result := TCReportsFrame;
end;

procedure TCReportDefForm.ReadValues;
begin
  inherited ReadValues;
  with TReportDef(Dataobject) do begin
    name := EditName.Text;
    description := RichEditDesc.Text;
    queryText := RicheditSql.Text;
    paramsDefs := 'test';
    xsltText := 'test';
  end;
end;

end.
