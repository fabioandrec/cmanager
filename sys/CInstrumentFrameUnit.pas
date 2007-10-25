unit CInstrumentFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFrameUnit, ActnList, VTHeaderPopup, Menus, ImgList,
  PngImageList, CComponents, VirtualTrees, StdCtrls, ExtCtrls, CDatabase, CDataObjects,
  CDataobjectFormUnit;

type
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
  end;

implementation

uses CConsts, CPluginConsts, CInstrumentFormUnit;

{$R *.dfm}

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

end.
