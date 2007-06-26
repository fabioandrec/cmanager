unit CCashpointsFrameUnit;

interface

uses CDataobjectFrameUnit, Classes, ActnList, VTHeaderPopup, Menus,
     ImgList, Controls, PngImageList, CComponents, VirtualTrees, StdCtrls,
     ExtCtrls, CDatabase, SysUtils, CDataobjectFormUnit, CImageListsUnit,
     Dialogs;

type
  TCCashpointsFrame = class(TCDataobjectFrame)
  public
    class function GetTitle: String; override;
    function IsValidFilteredObject(AObject: TDataObject): Boolean; override;
    procedure ReloadDataobjects; override;
    function GetStaticFilter: TStringList; override;
    function GetDataobjectClass(AOption: Integer): TDataObjectClass; override;
    function GetDataobjectProxy(AOption: Integer): TDataProxy; override;
    function GetDataobjectForm(AOption: Integer): TCDataobjectFormClass; override;
    function GetHistoryText: String; override;
    procedure ShowHistory(AGid: ShortString); override;
  end;

implementation

{$R *.dfm}

uses CConsts, CDataObjects, CCashpointFormUnit, CReports;

function TCCashpointsFrame.GetDataobjectClass(AOption: Integer): TDataObjectClass;
begin
  Result := TCashPoint;
end;

function TCCashpointsFrame.GetDataobjectForm(AOption: Integer): TCDataobjectFormClass;
begin
  Result := TCCashpointForm;
end;

function TCCashpointsFrame.GetDataobjectProxy(AOption: Integer): TDataProxy;
begin
  Result := CashPointProxy;
end;

function TCCashpointsFrame.GetHistoryText: String;
begin
  Result := 'Historia kontrahenta';
end;

function TCCashpointsFrame.GetStaticFilter: TStringList;
begin
  Result := TStringList.Create;
  with Result do begin
    Add(CFilterAllElements + '=<wszystkie elementy>');
    Add(CCashpointTypeAll + '=<dostêpne wszêdzie>');
    Add(CCashpointTypeOut + '=<tylko rozchody>');
    Add(CCashpointTypeIn + '=<tylko przychody>');
    Add(CCashpointTypeOther + '=<pozosta³e>');
  end;
end;

class function TCCashpointsFrame.GetTitle: String;
begin
  Result := 'Kontrahenci';
end;

function TCCashpointsFrame.IsValidFilteredObject(AObject: TDataObject): Boolean;
begin
  Result := (inherited IsValidFilteredObject(AObject)) or
            (CStaticFilter.DataId = CCashpointTypeAll) or
            (TCashPoint(AObject).cashpointType = CCashpointTypeAll) or
            (TCashPoint(AObject).cashpointType = CStaticFilter.DataId);
end;

procedure TCCashpointsFrame.ReloadDataobjects;
var xCondition: String;
begin
  inherited ReloadDataobjects;
  if CStaticFilter.DataId = CFilterAllElements then begin
    xCondition := '';
  end else if CStaticFilter.DataId = CCashpointTypeAll then begin
    xCondition := ' where cashpointType = ''' + CCashpointTypeAll + '''';
  end else if CStaticFilter.DataId = CCashpointTypeIn then begin
    xCondition := ' where cashpointType not in (''' + CCashpointTypeOut + ''', ''' + CCashpointTypeOther + ''')';
  end else if CStaticFilter.DataId = CCashpointTypeOut then begin
    xCondition := ' where cashpointType not in (''' + CCashpointTypeIn + ''', ''' + CCashpointTypeOther + ''')';
  end else if CStaticFilter.DataId = CCashpointTypeOther then begin
    xCondition := ' where cashpointType not in (''' + CCashpointTypeIn + ''', ''' + CCashpointTypeOut + ''')';
  end;
  Dataobjects := TDataObject.GetList(TCashPoint, CashPointProxy, 'select * from cashPoint' + xCondition);
end;

procedure TCCashpointsFrame.ShowHistory(AGid: ShortString);
var xReport: TCPHistoryReport;
    xParams: TCReportParams;
begin
  xParams := TCWithGidParams.Create(AGid);
  xParams.acp := CGroupByCashpoint;
  xReport := TCPHistoryReport.CreateReport(xParams);
  xReport.ShowReport;
  xReport.Free;
  xParams.Free;
end;

end.
