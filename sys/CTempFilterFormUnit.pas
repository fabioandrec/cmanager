unit CTempFilterFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, CFilterDetailFrameUnit,
  CFrameFormUnit;

type
  TCTempFilterForm = class(TCFrameForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function DoTemporaryMovementFilter(var ADataGid: String; var AText: String): Boolean;

implementation

uses CDataObjects, CConsts, CDatabase;

{$R *.dfm}

function DoTemporaryMovementFilter(var ADataGid: String; var AText: String): Boolean;
var xId, xText: String;
    xData: TFilterDetailData;
    xOutput: TFilterDetailData;
    xFilter: TMovementFilter;
    xMustCreate: Boolean;
begin
  xData := TFilterDetailData.Create;
  xOutput := TFilterDetailData.Create;
  if ADataGid <> CEmptyDataGid then begin
    GDataProvider.BeginTransaction;
    xFilter := TMovementFilter(TMovementFilter.LoadObject(MovementFilterProxy, ADataGid, False));
    xFilter.LoadSubfilters;
    xData.AccountIds.Assign(xFilter.accounts);
    xData.ProductIds.Assign(xFilter.products);
    xData.CashpointIds.Assign(xFilter.cashpoints);
    GDataProvider.RollbackTransaction;
    xMustCreate := False;
  end else begin
    xMustCreate := True;
  end;
  Result := TCFrameForm.ShowFrame(TCFilterDetailFrame, xId, xText, xData, Nil, xOutput, Nil, True, TCTempFilterForm);
  if Result then begin
    GDataProvider.BeginTransaction;
    if xMustCreate then begin
      xFilter := TMovementFilter.CreateObject(MovementFilterProxy, False);
      xFilter.name := '*' + FormatDateTime('yyyymmddhhnnss', Now);
      xFilter.description := 'filtr tymczasowy';
      xFilter.isTemp := True;
      ADataGid := xFilter.id;
      AText := '<zdefiniowano filtr>';
    end else begin
      xFilter := TMovementFilter(TMovementFilter.LoadObject(MovementFilterProxy, ADataGid, False));
    end;
    xFilter.accounts.Assign(xOutput.AccountIds);
    xFilter.products.Assign(xOutput.ProductIds);
    xFilter.cashpoints.Assign(xOutput.CashpointIds);
    GDataProvider.CommitTransaction;
  end;
  xOutput.Free;
end;

end.
