unit CChoosePeriodInstrumentValueFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CChoosePeriodFormUnit, StdCtrls, Buttons, CComponents, ExtCtrls,
  CDatabase;

type
  TCChoosePeriodInstrumentValueForm = class(TCChoosePeriodForm)
    GroupBox2: TGroupBox;
    CStaticInstrument: TCStatic;
    Label3: TLabel;
    procedure CStaticInstrumentGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
  protected
    function CanAccept: Boolean; override;
  end;

function ChoosePeriodInstrumentValueHistory(var AStartDate, AEndDate: TDateTime; var AInstrumentId: TDataGid): Boolean;

implementation

uses CFrameFormUnit, CInstrumentFrameUnit, CTools, CInfoFormUnit,
  CDataObjects, CConfigFormUnit;

{$R *.dfm}

function ChoosePeriodInstrumentValueHistory(var AStartDate, AEndDate: TDateTime; var AInstrumentId: TDataGid): Boolean;
var xForm: TCChoosePeriodInstrumentValueForm;
begin
  xForm := TCChoosePeriodInstrumentValueForm.Create(Nil);
  GDataProvider.BeginTransaction;
  if AInstrumentId <> CEmptyDataGid then begin
    xForm.CStaticInstrument.DataId := AInstrumentId;
    xForm.CStaticInstrument.Caption := TInstrument(TInstrument.LoadObject(InstrumentProxy, AInstrumentId, False)).GetElementText;
  end;
  GDataProvider.RollbackTransaction;
  xForm.CDateTime1.Withtime := True;
  xForm.CDateTime2.Withtime := True;
  Result := xForm.ShowConfig(coEdit);
  if Result then begin
    AStartDate := xForm.CDateTime1.Value;
    AEndDate := xForm.CDateTime2.Value;
    AInstrumentId := xForm.CStaticInstrument.DataId;
  end;
  xForm.Free;
end;

function TCChoosePeriodInstrumentValueForm.CanAccept: Boolean;
begin
  Result := True;
  if CStaticInstrument.DataId = CEmptyDataGid then begin
    Result := False;
    if ShowInfo(itQuestion, 'Nie wybrano instrumentu inwestycyjnego. Czy wyœwietliæ listê teraz ?', '') then begin
      CStaticInstrument.DoGetDataId;
    end;
  end;
end;

procedure TCChoosePeriodInstrumentValueForm.CStaticInstrumentGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCInstrumentFrame, ADataGid, AText);
end;

end.
 