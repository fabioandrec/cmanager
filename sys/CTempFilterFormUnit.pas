unit CTempFilterFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, CFilterDetailFrameUnit,
  CFrameFormUnit, CComponents, CBaseFrameUnit;

type
  TCTempFilterForm = class(TCFrameForm)
    CStaticPredefined: TCStatic;
    procedure CStaticPredefinedGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticPredefinedChanged(Sender: TObject);
  private
    procedure CheckChanged(ASender: TObject);
  protected
    procedure ReadValues; override;
    procedure FillForm; override;
  public
    constructor CreateFrame(AOwner: TComponent; AFrameClass: TCBaseFrameClass; AAdditionalData: TObject = nil; AOutData: TObject = nil; AMultipleCheck: TStringList = nil; AIsChoice: Boolean = True; AWithButtons: Boolean = True); override;
  end;

function DoTemporaryMovementFilter(var ADataGid: String; var AText: String): Boolean;

implementation

uses CDataObjects, CConsts, CDatabase, CFilterFrameUnit;

{$R *.dfm}

function DoTemporaryMovementFilter(var ADataGid: String; var AText: String): Boolean;
var xId, xText: String;
    xData: TFilterDetailData;
    xOutput: TFilterDetailData;
    xFilter: TMovementFilter;
    xWasTemp: Boolean;
    xPrevious: TDataGid;
begin
  xData := TFilterDetailData.Create;
  xOutput := TFilterDetailData.Create;
  xPrevious := ADataGid;
  if ADataGid <> CEmptyDataGid then begin
    GDataProvider.BeginTransaction;
    xFilter := TMovementFilter(TMovementFilter.LoadObject(MovementFilterProxy, ADataGid, False));
    xFilter.LoadSubfilters;
    xData.AccountIds.Assign(xFilter.accounts);
    xData.ProductIds.Assign(xFilter.products);
    xData.CashpointIds.Assign(xFilter.cashpoints);
    xData.PredefinedId := ADataGid;
    xWasTemp := xFilter.isTemp;
    GDataProvider.RollbackTransaction;
  end else begin
    xWasTemp := True;
  end;
  Result := TCFrameForm.ShowFrame(TCFilterDetailFrame, xId, xText, xData, Nil, xOutput, Nil, True, TCTempFilterForm);
  if Result then begin
    GDataProvider.BeginTransaction;
    xFilter := Nil;
    if not ((ADataGid = CEmptyDataGid) and (xOutput.PredefinedId = CEmptyDataGid)) then begin
      if xWasTemp and (xOutput.PredefinedId <> CEmptyDataGid) and (xOutput.PredefinedId <> xPrevious) then begin
        if xPrevious <> CEmptyDataGid then begin
          xFilter := TMovementFilter(TMovementFilter.LoadObject(MovementFilterProxy, xPrevious, False));
          xFilter.DeleteObject;
        end;
        xFilter := TMovementFilter(TMovementFilter.LoadObject(MovementFilterProxy, xOutput.PredefinedId, False));
      end else begin
        if xPrevious = xOutput.PredefinedId then begin
          xFilter := TMovementFilter(TMovementFilter.LoadObject(MovementFilterProxy, xPrevious, False));
        end;
      end;
    end;
    if xFilter = Nil then begin
      xFilter := TMovementFilter.CreateObject(MovementFilterProxy, False);
      xFilter.name := 'szczegó³y filtru';
      xFilter.description := 'filtr tymczasowy';
      xFilter.isTemp := True;
    end;
    if xFilter.isTemp then begin
      xFilter.accounts := xOutput.AccountIds;
      xFilter.products := xOutput.ProductIds;
      xFilter.cashpoints := xOutput.CashpointIds;
    end;
    ADataGid := xFilter.id;
    AText := xFilter.name;
    GDataProvider.CommitTransaction;
  end;
  xOutput.Free;
end;

procedure TCTempFilterForm.CStaticPredefinedGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCFilterFrame, ADataGid, AText);
end;

procedure TCTempFilterForm.CStaticPredefinedChanged(Sender: TObject);
var xFilter: TMovementFilter;
begin
  GDataProvider.BeginTransaction;
  xFilter := TMovementFilter(TMovementFilter.LoadObject(MovementFilterProxy, CStaticPredefined.DataId, False));
  xFilter.LoadSubfilters;
  TCFilterDetailFrame(Frame).ElementChecks[0].Assign(xFilter.accounts);
  TCFilterDetailFrame(Frame).ElementChecks[1].Assign(xFilter.products);
  TCFilterDetailFrame(Frame).ElementChecks[2].Assign(xFilter.cashpoints);
  GDataProvider.RollbackTransaction;
  TCFilterDetailFrame(Frame).RecheckMarks;
end;

procedure TCTempFilterForm.CheckChanged(ASender: TObject);
begin
  CStaticPredefined.DataId := CEmptyDataGid;
end;

constructor TCTempFilterForm.CreateFrame(AOwner: TComponent; AFrameClass: TCBaseFrameClass; AAdditionalData, AOutData: TObject; AMultipleCheck: TStringList; AIsChoice, AWithButtons: Boolean);
begin
  inherited CreateFrame(AOwner, AFrameClass, AAdditionalData, AOutData, AMultipleCheck, AIsChoice, AWithButtons);
  Frame.OnCheckChanged := CheckChanged;
end;

procedure TCTempFilterForm.ReadValues;
begin
  inherited ReadValues;
  with TFilterDetailData(Frame.Outputdata) do begin
    PredefinedId := CStaticPredefined.DataId;
  end;
end;

procedure TCTempFilterForm.FillForm;
var xFilter: TMovementFilter;
begin
  inherited FillForm;
  with TFilterDetailData(Frame.AdditionalData) do begin
    if PredefinedId <> CEmptyDataGid then begin
      GDataProvider.BeginTransaction;
      xFilter := TMovementFilter(TMovementFilter.LoadObject(MovementFilterProxy, PredefinedId, False));
      if not xFilter.isTemp then begin
        CStaticPredefined.DataId := xFilter.id;
        CStaticPredefined.Caption := xFilter.name;
      end;
      GDataProvider.RollbackTransaction;
    end;
  end;
end;

end.
