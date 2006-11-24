unit CChoosePeriodFilterFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CChoosePeriodFormUnit, CComponents, StdCtrls, Buttons, ExtCtrls,
  CDatabase;

type
  TCChoosePeriodFilterForm = class(TCChoosePeriodForm)
    GroupBox2: TGroupBox;
    Label14: TLabel;
    CStaticFilter: TCStatic;
    procedure CStaticFilterGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
  private
    FCanBeEmpty: Boolean;
  protected
    function CanAccept: Boolean; override;
  public
    property CanBeEmpty: Boolean read FCanBeEmpty write FCanBeEmpty;
  end;

function ChoosePeriodFilterByForm(var AStartDate, AEndDate: TDateTime; var AIdFilter: TDataGid; ACanBeEmpty: Boolean = False): Boolean;

implementation

uses CFilterFrameUnit, CFrameFormUnit, CConfigFormUnit, CInfoFormUnit;

{$R *.dfm}

function ChoosePeriodFilterByForm(var AStartDate, AEndDate: TDateTime; var AIdFilter: TDataGid; ACanBeEmpty: Boolean = False): Boolean;
var xForm: TCChoosePeriodFilterForm;
begin
  xForm := TCChoosePeriodFilterForm.Create(Nil);
  xForm.CanBeEmpty := ACanBeEmpty;
  Result := xForm.ShowConfig(coEdit);
  if Result then begin
    AStartDate := xForm.CDateTime1.Value;
    AEndDate := xForm.CDateTime2.Value;
    AIdFilter := xForm.CStaticFilter.DataId;
  end;
  xForm.Free;
end;

function TCChoosePeriodFilterForm.CanAccept: Boolean;
begin
  Result := True;
  if (CStaticFilter.DataId = CEmptyDataGid) and (not FCanBeEmpty) then begin
    Result := False;
    if ShowInfo(itQuestion, 'Nie wybrano filtru. Czy wyœwietliæ listê teraz ?', '') then begin
      CStaticFilter.DoGetDataId;
    end;
  end;
end;

procedure TCChoosePeriodFilterForm.CStaticFilterGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCFilterFrame, ADataGid, AText);
end;

end.
