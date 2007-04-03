unit CCurrencydefFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, ComCtrls, CDatabase,
  CBaseFrameUnit;

type
  TCCurrencydefForm = class(TCDataobjectForm)
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    EditName: TEdit;
    RichEditDesc: TRichEdit;
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

uses CDataObjects, CInfoFormUnit, CRichtext, CCurrencydefFrameUnit;

{$R *.dfm}

function TCCurrencydefForm.CanAccept: Boolean;
begin
  Result := inherited CanAccept;
  if Trim(EditName.Text) = '' then begin
    Result := False;
    ShowInfo(itError, 'Nazwa waluty nie mo�e by� pusta', '');
    EditName.SetFocus;
  end else if Trim(EditSymbol.Text) = '' then begin
    Result := False;
    ShowInfo(itError, 'Symbol waluty nie mo�e by� pusty', '');
    EditSymbol.SetFocus;
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
 