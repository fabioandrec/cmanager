unit CCashpointFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  ImgList, CComponents, CDatabase, CBaseFrameUnit;

type
  TCCashpointForm = class(TCDataobjectForm)
    GroupBox2: TGroupBox;
    EditName: TEdit;
    Label1: TLabel;
    RichEditDesc: TRichEdit;
    Label2: TLabel;
  protected
    procedure ReadValues; override;
    function GetDataobjectClass: TDataObjectClass; override;
    procedure FillForm; override;
    function CanAccept: Boolean; override;
    function GetUpdateFrameClass: TCBaseFrameClass; override;
  end;

implementation

uses CDataObjects, CInfoFormUnit, CCashpointsFrameUnit;

{$R *.dfm}

function TCCashpointForm.CanAccept: Boolean;
begin
  Result := inherited CanAccept;
  if Trim(EditName.Text) = '' then begin
    Result := False;
    ShowInfo(itError, 'Nazwa kontrahenta nie mo¿e byæ pusta', '');
    EditName.SetFocus;
  end;
end;

procedure TCCashpointForm.FillForm;
begin
  with TCashPoint(Dataobject) do begin
    EditName.Text := name;
    RichEditDesc.Text := description;
  end;
end;

function TCCashpointForm.GetDataobjectClass: TDataObjectClass;
begin
  Result := TCashpoint;
end;

function TCCashpointForm.GetUpdateFrameClass: TCBaseFrameClass;
begin
  Result := TCCashpointsFrame;
end;

procedure TCCashpointForm.ReadValues;
begin
  inherited ReadValues;
  with TCashPoint(Dataobject) do begin
    name := EditName.Text;
    description := RichEditDesc.Text;
  end;
end;

end.
