unit CChooseByParamsDefsFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, CReports;

type
  TCChooseByParamsDefsForm = class(TCConfigForm)
  private
    FParams: TReportDialogParamsDefs;
  public
    procedure PrepareFromParams(AParams: TReportDialogParamsDefs);
  end;

function ChooseByParamsDefs(var AParams: TReportDialogParamsDefs): Boolean;

implementation

{$R *.dfm}

function ChooseByParamsDefs(var AParams: TReportDialogParamsDefs): Boolean;
var xForm: TCChooseByParamsDefsForm;
begin
  Result := AParams.Count = 0;
  if not Result then begin
    xForm := TCChooseByParamsDefsForm.Create(Nil);
    xForm.PrepareFromParams(AParams);
    Result := xForm.ShowConfig(coEdit);
    xForm.Free;
  end;
end;

procedure TCChooseByParamsDefsForm.PrepareFromParams(AParams: TReportDialogParamsDefs);
begin
  FParams := AParams;
end;

end.
