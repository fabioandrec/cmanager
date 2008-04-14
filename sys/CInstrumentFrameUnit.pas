unit CInstrumentFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFrameUnit, ActnList, VTHeaderPopup, Menus, ImgList,
  PngImageList, CComponents, VirtualTrees, StdCtrls, ExtCtrls, CDatabase, CDataObjects,
  CDataobjectFormUnit, CImageListsUnit;

type
  TCInstrumentFrameAdditionalData = class(TCDataobjectFrameData)
  private
    FOnlyWithCurrency: Boolean;
  public
    constructor Create(AOnlyWithCurrency: Boolean);
  published
    property OnlyWithCurrency: Boolean read FOnlyWithCurrency write FOnlyWithCurrency;
  end;

  TCInstrumentFrame = class(TCDataobjectFrame)
  protected
    function IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean; override;
    function GetSelectedType: Integer; override;
  public
    class function GetTitle: String; override;
    function IsValidFilteredObject(AObject: TDataObject): Boolean; override;
    procedure ReloadDataobjects; override;
    function GetStaticFilter: TStringList; override;
    class function GetDataobjectClass(AOption: Integer): TDataObjectClass; override;
    class function GetDataobjectProxy(AOption: Integer): TDataProxy; override;
    function GetDataobjectForm(AOption: Integer): TCDataobjectFormClass; override;
    function GetHistoryText: String; override;
    procedure ShowHistory(AGid: ShortString); override;
    function CanAcceptSelectedObject: Boolean; override;
  end;

implementation

uses CConsts, CPluginConsts, CInstrumentFormUnit, CReports, CBaseFrameUnit,
  CTools, CInfoFormUnit;

{$R *.dfm}

function TCInstrumentFrame.CanAcceptSelectedObject: Boolean;
begin
  Result := inherited CanAcceptSelectedObject;
  if Result and (AdditionalData <> Nil)then begin
    if TCInstrumentFrameAdditionalData(AdditionalData).OnlyWithCurrency then begin
      GDataProvider.BeginTransaction;
      Result := TInstrument(TInstrument.LoadObject(InstrumentProxy, SelectedId, False)).idCurrencyDef <> CEmptyDataGid;
      GDataProvider.RollbackTransaction;
      if not Result then begin
        ShowInfo(itWarning, 'Musisz wybraæ instrument ze zdefiniowan¹ walut¹ notowañ', '');
      end;
    end;
  end;
end;

class function TCInstrumentFrame.GetDataobjectClass(AOption: Integer): TDataObjectClass;
begin
  Result := TInstrument;
end;

function TCInstrumentFrame.GetDataobjectForm(AOption: Integer): TCDataobjectFormClass;
begin
  Result := TCInstrumentForm;
end;

class function TCInstrumentFrame.GetDataobjectProxy(AOption: Integer): TDataProxy;
begin
  Result := InstrumentProxy;
end;

function TCInstrumentFrame.GetHistoryText: String;
begin
  Result := 'Wykres notowañ';
end;

function TCInstrumentFrame.GetSelectedType: Integer;
begin
  Result := CSELECTEDITEM_INSTRUMENT;
end;

function TCInstrumentFrame.GetStaticFilter: TStringList;
begin
  Result := TStringList.Create;
  with Result do begin
    Add(CFilterAllElements + '=<wszystkie elementy>');
    Add(CInstrumentTypeIndex + '=<indeksy gie³dowe>');
    Add(CInstrumentTypeStock + '=<akcje>');
    Add(CInstrumentTypeBond + '=<obligacje>');
    Add(CInstrumentTypeFundinv + '=<fundusze inwestycyjne>');
    Add(CInstrumentTypeFundret + '=<fundusze emerytalne>');
    Add(CInstrumentTypeUndefined + '=<nieokreœlone>');
  end;
end;

class function TCInstrumentFrame.GetTitle: String;
begin
  Result := 'Instrumenty inwestycyjne'
end;

function TCInstrumentFrame.IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean;
begin
  Result := (APluginSelectedItemTypes and CSELECTEDITEM_INSTRUMENT) = CSELECTEDITEM_INSTRUMENT;
end;

function TCInstrumentFrame.IsValidFilteredObject(AObject: TDataObject): Boolean;
begin
  Result := (inherited IsValidFilteredObject(AObject)) or
            (TInstrument(AObject).instrumentType = CStaticFilter.DataId);
end;

procedure TCInstrumentFrame.ReloadDataobjects;
var xCondition: String;
begin
  inherited ReloadDataobjects;
  if CStaticFilter.DataId = CFilterAllElements then begin
    xCondition := '';
  end else if CStaticFilter.DataId = CCashpointTypeAll then begin
    xCondition := ' where instrumentType = ''' + CStaticFilter.DataId + '''';
  end;
  Dataobjects := TDataObject.GetList(TInstrument, InstrumentProxy, 'select * from instrument' + xCondition);
end;

procedure TCInstrumentFrame.ShowHistory(AGid: ShortString);
var xReport: TInstrumentValueChartReport;
    xParams: TCReportParams;
begin
  xParams := TCWithGidParams.Create(AGid);
  xReport := TInstrumentValueChartReport.CreateReport(xParams);
  xReport.ShowReport;
  xReport.Free;
  xParams.Free;
end;

{ TCInstrumentFrameAdditionalData }

constructor TCInstrumentFrameAdditionalData.Create(AOnlyWithCurrency: Boolean);
begin
  CreateNew;
  FOnlyWithCurrency := AOnlyWithCurrency;
end;

end.
