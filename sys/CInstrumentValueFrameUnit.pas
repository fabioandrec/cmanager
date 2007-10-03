unit CInstrumentValueFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFrameUnit, ActnList, VTHeaderPopup, Menus, ImgList,
  PngImageList, CComponents, VirtualTrees, StdCtrls, ExtCtrls, CDataobjectFormUnit,
  CDatabase, CImageListsUnit;

type
  TCInstrumentValueFrame = class(TCDataobjectFrame)
    CDateTimePerStart: TCDateTime;
    Label4: TLabel;
    CDateTimePerEnd: TCDateTime;
    Label5: TLabel;
    Label3: TLabel;
    Label1: TLabel;
    CStaticPeriod: TCStatic;
    procedure CDateTimePerStartChanged(Sender: TObject);
    procedure CDateTimePerEndChanged(Sender: TObject);
    procedure CStaticPeriodChanged(Sender: TObject);
    procedure CStaticPeriodGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
  protected
    procedure UpdateCustomPeriod;
    procedure GetFilterDates(var ADateFrom, ADateTo: TDateTime);
    function GetSelectedType: Integer; override;
    function IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean; override;
  public
    class function GetTitle: String; override;
    procedure ReloadDataobjects; override;
    function GetStaticFilter: TStringList; override;
    class function GetDataobjectClass(AOption: Integer): TDataObjectClass; override;
    class function GetDataobjectProxy(AOption: Integer): TDataProxy; override;
    function GetDataobjectForm(AOption: Integer): TCDataobjectFormClass; override;
    procedure InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean); override;
    function IsValidFilteredObject(AObject: TDataObject): Boolean; override;
    function GetInitialFilter: String; override;
  end;

implementation

uses CDataObjects, CConsts, DateUtils,
  CFrameFormUnit, CLimitsFrameUnit, CListFrameUnit, CBaseFrameUnit,
  CPluginConsts, CTools, CInstrumentValueFormUnit;

{$R *.dfm}

class function TCInstrumentValueFrame.GetDataobjectClass(AOption: Integer): TDataObjectClass;
begin
  Result := TInstrumentValue;
end;

function TCInstrumentValueFrame.GetDataobjectForm(AOption: Integer): TCDataobjectFormClass;
begin
  Result := TCInstrumentValueForm;
end;

class function TCInstrumentValueFrame.GetDataobjectProxy(AOption: Integer): TDataProxy;
begin
  Result := InstrumentValueProxy;
end;

procedure TCInstrumentValueFrame.GetFilterDates(var ADateFrom, ADateTo: TDateTime);
var xId: TDataGid;
begin
  ADateFrom := 0;
  ADateTo := 0;
  xId := CStaticPeriod.DataId;
  if xId = CFilterToday then begin
    ADateFrom := GWorkDate;
    ADateTo := GWorkDate;
  end else if xId = CFilterYesterday then begin
    ADateFrom := IncDay(GWorkDate, -1);
    ADateTo := IncDay(GWorkDate, -1);
  end else if xId = CFilterWeek then begin
    ADateFrom := StartOfTheWeek(GWorkDate);
    ADateTo := EndOfTheWeek(GWorkDate);
  end else if xId = CFilterMonth then begin
    ADateFrom := StartOfTheMonth(GWorkDate);
    ADateTo := EndOfTheMonth(GWorkDate);
  end else if xId = CFilterOther then begin
    ADateFrom := CDateTimePerStart.Value;
    ADateTo := CDateTimePerEnd.Value;
  end;
  ADateFrom := StartOfTheDay(ADateFrom);
  ADateTo := EndOfTheDay(ADateTo);
end;

function TCInstrumentValueFrame.GetStaticFilter: TStringList;
begin
  Result := TStringList.Create;
  with Result do begin
    Add(CFilterAllElements + '=<wszystkie elementy>');
    Add(CInstrumentTypeIndex + '=<indeksy gie³dowe>');
    Add(CInstrumentTypeStock + '=<akcje>');
    Add(CInstrumentTypeBond + '=<obligacje>');
    Add(CInstrumentTypeFund + '=<fundusze inwestycyjne>');
  end;
end;

class function TCInstrumentValueFrame.GetTitle: String;
begin
  Result := 'Notowania instrumentów inwestycyjnych';
end;

procedure TCInstrumentValueFrame.InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean);
begin
  inherited InitializeFrame(AOwner, AAdditionalData, AOutputData, AMultipleCheck, AWithButtons);
  UpdateCustomPeriod;
  CDateTimePerStart.Value := GWorkDate;
  CDateTimePerEnd.Value := GWorkDate;
  Label3.Anchors := [akRight, akTop];
  CDateTimePerStart.Anchors := [akRight, akTop];
  Label4.Anchors := [akRight, akTop];
  CDateTimePerEnd.Anchors := [akRight, akTop];
  Label5.Anchors := [akRight, akTop];
end;

function TCInstrumentValueFrame.IsValidFilteredObject(AObject: TDataObject): Boolean;
var xDf, xDt: TDateTime;
begin
  GetFilterDates(xDf, xDt);
  Result := (inherited IsValidFilteredObject(AObject)) and
            (xDf <= TInstrumentValue(AObject).regDateTime) and (TInstrumentValue(AObject).regDateTime <= xDt)
            and ((CStaticFilter.DataId = CFilterAllElements) or (TInstrumentValue(AObject).instrumentType = CStaticFilter.DataId));
end;

procedure TCInstrumentValueFrame.ReloadDataobjects;
var xCondition: String;
    xDf, xDt: TDateTime;
begin
  inherited ReloadDataobjects;
  if CStaticPeriod.DataId = CFilterAllElements then begin
    xCondition := '';
  end else begin
    GetFilterDates(xDf, xDt);
    xCondition := Format(' where regDateTime between %s and %s', [DatetimeToDatabase(xDf, True), DatetimeToDatabase(xDt, True)]);
  end;
  if CStaticFilter.DataId <> CFilterAllElements then begin
    xCondition := xCondition + ' and instrumentType = ''' + CStaticFilter.DataId + '''';
  end;
  Dataobjects := TInstrumentValue.GetList(TInstrumentValue, InstrumentValueProxy, 'select * from StnInstrumentValue ' + xCondition);
end;

procedure TCInstrumentValueFrame.UpdateCustomPeriod;
var xF, xE: TDateTime;
begin
  CDateTimePerStart.HotTrack := CStaticPeriod.DataId = CFilterOther;
  CDateTimePerEnd.HotTrack := CStaticPeriod.DataId = CFilterOther;
  if CStaticPeriod.DataId <> CFilterOther then begin
    GetFilterDates(xF, xE);
    CDateTimePerStart.Value := xF;
    CDateTimePerEnd.Value := xE;
  end;
end;

procedure TCInstrumentValueFrame.CDateTimePerStartChanged(Sender: TObject);
begin
  RefreshData;
end;

procedure TCInstrumentValueFrame.CDateTimePerEndChanged(Sender: TObject);
begin
  RefreshData;
end;

function TCInstrumentValueFrame.GetInitialFilter: String;
begin
  Result := CFilterAllElements;
end;

procedure TCInstrumentValueFrame.CStaticPeriodChanged(Sender: TObject);
begin
  UpdateCustomPeriod;
  RefreshData;
end;

procedure TCInstrumentValueFrame.CStaticPeriodGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
var xList: TStringList;
    xGid, xText: String;
    xRect: TRect;
begin
  xList := TStringList.Create;
  xList.Add(CFilterToday + '=<wa¿ne dziœ>');
  xList.Add(CFilterYesterday + '=<wa¿ne wczoraj>');
  xList.Add(CFilterWeek + '=<wa¿ne w tym tygodniu>');
  xList.Add(CFilterMonth + '=<wa¿ne w tym miesi¹cu>');
  xList.Add(CFilterOther + '=<dowolny okres>');
  xGid := CFilterAllElements;
  xText := '';
  xRect := Rect(10, 10, 200, 300);
  AAccepted := TCFrameForm.ShowFrame(TCListFrame, xGid, xText, xList, @xRect);
  if AAccepted then begin
    ADataGid := xGid;
    AText := xText;
  end;
end;

function TCInstrumentValueFrame.GetSelectedType: Integer;
begin
  if List.FocusedNode <> Nil then begin
    Result := CSELECTEDITEM_INSTRUMENTVALUE;
  end else begin
    Result := CSELECTEDITEM_INCORRECT;
  end;
end;

function TCInstrumentValueFrame.IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean;
begin
  Result := (APluginSelectedItemTypes and CSELECTEDITEM_INSTRUMENTVALUE) = CSELECTEDITEM_INSTRUMENTVALUE;
end;

end.
