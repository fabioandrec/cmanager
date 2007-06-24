unit CCurrencydefFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, ComCtrls, CDatabase,
  CBaseFrameUnit, CComponents;

type
  TCCurrencydefForm = class(TCDataobjectForm)
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    EditName: TEdit;
    RichEditDesc: TCRichEdit;
    Label3: TLabel;
    EditSymbol: TEdit;
    Label4: TLabel;
    EditIso: TEdit;
  protected
    procedure ReadValues; override;
    function GetDataobjectClass: TDataObjectClass; override;
    procedure FillForm; override;
    function CanAccept: Boolean; override;
    function GetUpdateFrameClass: TCBaseFrameClass; override;
  end;

implementation

uses CDataObjects, CInfoFormUnit, CRichtext, CCurrencydefFrameUnit,
  CConfigFormUnit;

{$R *.dfm}

function TCCurrencydefForm.CanAccept: Boolean;
var xCur: TCurrencyDef;
begin
  if Trim(EditName.Text) = '' then begin
    Result := False;
    ShowInfo(itError, 'Nazwa waluty nie mo¿e byæ pusta', '');
    EditName.SetFocus;
  end else if Trim(EditSymbol.Text) = '' then begin
    Result := False;
    ShowInfo(itError, 'Symbol waluty nie mo¿e byæ pusty', '');
    EditSymbol.SetFocus;
  end else if Trim(EditIso.Text) = '' then begin
    Result := False;
    ShowInfo(itError, 'Symbol ISO waluty nie mo¿e byæ pusty', '');
    EditIso.SetFocus;
  end else begin
    xCur := TCurrencyDef.FindByIso(EditIso.Text);
    Result := xCur = Nil;
    if (not Result) and (Operation = coEdit) then begin
      Result := xCur.id = Dataobject.id;
    end;
    if not Result then begin
      ShowInfo(itError, 'Istnieje ju¿ waluta o symbolu ISO "' + EditIso.Text + '"', '');
      EditIso.SetFocus;
    end;
  end;
end;

procedure TCCurrencydefForm.FillForm;
begin
  with TCurrencyDef(Dataobject) do begin
    EditName.Text := name;
    EditSymbol.Text := symbol;
    EditIso.Text := iso;
    SimpleRichText(description, RichEditDesc);
  end;
end;

function TCCurrencydefForm.GetDataobjectClass: TDataObjectClass;
begin
  Result := TCurrencyDef;
end;

function TCCurrencydefForm.GetUpdateFrameClass: TCBaseFrameClass;
begin
  Result := TCCurrencydefFrame;
end;

procedure TCCurrencydefForm.ReadValues;
begin
  inherited ReadValues;
  with TCurrencyDef(Dataobject) do begin
    name := EditName.Text;
    description := RichEditDesc.Text;
    symbol := EditSymbol.Text;
    iso := EditIso.Text;
  end;
end;

end.
 