unit CUnitdefFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, ComCtrls, CDatabase,
  CBaseFrameUnit, CComponents;

type
  TCUnitdefForm = class(TCDataobjectForm)
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    EditName: TEdit;
    RichEditDesc: TCRichEdit;
    Label3: TLabel;
    EditSymbol: TEdit;
  protected
    procedure ReadValues; override;
    function GetDataobjectClass: TDataObjectClass; override;
    procedure FillForm; override;
    function CanAccept: Boolean; override;
    function GetUpdateFrameClass: TCBaseFrameClass; override;
  end;

implementation

uses CDataObjects, CInfoFormUnit, CRichtext, CConfigFormUnit, CUnitDefFrameUnit;

{$R *.dfm}

function TCUnitdefForm.CanAccept: Boolean;
begin
  Result := True;
  if Trim(EditName.Text) = '' then begin
    Result := False;
    ShowInfo(itError, 'Nazwa jednostki miary nie mo¿e byæ pusta', '');
    EditName.SetFocus;
  end else if Trim(EditSymbol.Text) = '' then begin
    Result := False;
    ShowInfo(itError, 'Symbol jednostki miary nie mo¿e byæ pusty', '');
    EditSymbol.SetFocus;
  end;
end;

procedure TCUnitdefForm.FillForm;
begin
  with TUnitDef(Dataobject) do begin
    EditName.Text := name;
    EditSymbol.Text := symbol;
    SimpleRichText(description, RichEditDesc);
  end;
end;

function TCUnitdefForm.GetDataobjectClass: TDataObjectClass;
begin
  Result := TUnitDef;
end;

function TCUnitdefForm.GetUpdateFrameClass: TCBaseFrameClass;
begin
  Result := TCUnitDefFrame;
end;

procedure TCUnitdefForm.ReadValues;
begin
  inherited ReadValues;
  with TUnitDef(Dataobject) do begin
    name := EditName.Text;
    description := RichEditDesc.Text;
    symbol := EditSymbol.Text;
  end;
end;

end.
