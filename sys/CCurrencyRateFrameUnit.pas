unit CCurrencyRateFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFrameUnit, ActnList, VTHeaderPopup, Menus, ImgList,
  PngImageList, CComponents, VirtualTrees, StdCtrls, ExtCtrls, CDataobjectFormUnit,
  CDatabase, CImageListsUnit;

type
  TRateFrameAdditionalData = class(TCDataobjectFrameData)
  private
    FIdSource: String;
    FIdDest: String;
  public
    constructor CreateRateData(AIdSource, AIdDest: String);
  published
    property idSource: String read FIdSource;
    property idDesc: String read FIdDest;
  end;

  TRateFormAdditionalData = class(TAdditionalData)
  private
    FIdSource: String;
    FIdDest: String;
  public
    constructor CreateRateData(AIdSource, AIdDest: String);
  published
    property idSource: String read FIdSource;
    property idDesc: String read FIdDest;
  end;

  TCCurrencyRateFrame = class(TCDataobjectFrame)
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
    function GetAdditionalDataForObject: TAdditionalData; override;
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

uses CDataObjects, CCurrencyRateFormUnit, CConsts, DateUtils,
  CFrameFormUnit, CLimitsFrameUnit, CListFrameUnit, CBaseFrameUnit,
  CPluginConsts, CTools;

{$R *.dfm}

class function TCCurrencyRateFrame.GetDataobjectClass(AOption: Integer): TDataObjectClass;
begin
  Result := TCurrencyRate;
end;

function TCCurrencyRateFrame.GetDataobjectForm(AOption: Integer): TCDataobjectFormClass;
begin
  Result := TCCurrencyRateForm;
end;

class function TCCurrencyRateFrame.GetDataobjectProxy(AOption: Integer): TDataProxy;
begin
  Result := CurrencyRateProxy;
end;

procedure TCCurrencyRateFrame.GetFilterDates(var ADateFrom, ADateTo: TDateTime);
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
  end else if xId = CFilterAllElements then begin
    ADateFrom := LowestDatetime;
    ADateTo := HighestDatetime;
  end;
end;

function TCCurrencyRateFrame.GetStaticFilter: TStringList;
begin
  Result := TStringList.Create;
  with Result do begin
    Add(CFilterAllElements + '=<wszystkie elementy>');
    Add(CCurrencyRateTypeAverage + '=<kursy œrednie>');
    Add(CCurrencyRateTypeSell + '=<kursy kupna>');
    Add(CCurrencyRateTypeBuy + '=<kursy sprzeda¿y>');
  end;
end;

class function TCCurrencyRateFrame.GetTitle: String;
begin
  Result := 'Kursy walut';
end;

procedure TCCurrencyRateFrame.InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean);
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

function TCCurrencyRateFrame.IsValidFilteredObject(AObject: TDataObject): Boolean;
var xDf, xDt: TDateTime;
begin
  GetFilterDates(xDf, xDt);
  Result := ((inherited IsValidFilteredObject(AObject)) or (CStaticFilter.DataId = TCurrencyRate(AObject).rateType)) and
            (xDf <= TCurrencyRate(AObject).bindingDate) and (TCurrencyRate(AObject).bindingDate <= xDt);
  if Result and (AdditionalData <> Nil) then begin
    with TRateFrameAdditionalData(AdditionalData) do begin
      Result := (FIdSource = TCurrencyRate(AObject).idSourceCurrencyDef) and (FIdDest = TCurrencyRate(AObject).idTargetCurrencyDef);
    end;
  end;
end;

procedure TCCurrencyRateFrame.ReloadDataobjects;
var xCondition: String;
    xDf, xDt: TDateTime;
begin
  inherited ReloadDataobjects;
  if CStaticPeriod.DataId = CFilterAllElements then begin
    xCondition := '';
  end else begin
    GetFilterDates(xDf, xDt);
    xCondition := Format(' where bindingDate between %s and %s', [DatetimeToDatabase(xDf, False), DatetimeToDatabase(xDt, False)]);
  end;
  if CStaticFilter.DataId <> CFilterAllElements then begin
    xCondition := xCondition + ' and rateType = ''' + CStaticFilter.DataId + '''';
  end;
  if AdditionalData <> Nil then begin
    with TRateFrameAdditionalData(AdditionalData) do begin
      xCondition := xCondition + Format(' and ((idSourceCurrencyDef = %s and idTargetCurrencyDef = %s) or (idSourceCurrencyDef = %s and idTargetCurrencyDef = %s))', [FIdSource, FIdDest, FIdDest, FIdSource]);
    end;
  end;
  Dataobjects := TCurrencyRate.GetList(TCurrencyRate, CurrencyRateProxy, 'select * from currencyRate' + xCondition);
end;

procedure TCCurrencyRateFrame.UpdateCustomPeriod;
var xF, xE: TDateTime;
begin
  CDateTimePerStart.HotTrack := CStaticPeriod.DataId = CFilterOther;
  CDateTimePerEnd.HotTrack := CStaticPeriod.DataId = CFilterOther;
  CDateTimePerStart.Visible := CStaticPeriod.DataId <> CFilterAllElements;
  CDateTimePerEnd.Visible := CStaticPeriod.DataId <> CFilterAllElements;
  Label3.Visible := CDateTimePerEnd.Visible;
  Label3.Update;
  Label4.Visible := CDateTimePerEnd.Visible;
  Label4.Update;
  Label5.Visible := CDateTimePerEnd.Visible;
  Label5.Update;
  if CStaticPeriod.DataId <> CFilterOther then begin
    GetFilterDates(xF, xE);
    CDateTimePerStart.Value := xF;
    CDateTimePerEnd.Value := xE;
  end else begin
    if IsLowestDatetime(CDateTimePerStart.Value) then begin
      CDateTimePerStart.Value := GWorkDate;
    end;
    if IsHighestDatetime(CDateTimePerEnd.Value) then begin
      CDateTimePerEnd.Value := GWorkDate;
    end;
  end;
end;

procedure TCCurrencyRateFrame.CDateTimePerStartChanged(Sender: TObject);
begin
  RefreshData;
end;

procedure TCCurrencyRateFrame.CDateTimePerEndChanged(Sender: TObject);
begin
  RefreshData;
end;

function TCCurrencyRateFrame.GetInitialFilter: String;
begin
  Result := CFilterAllElements;
end;

procedure TCCurrencyRateFrame.CStaticPeriodChanged(Sender: TObject);
begin
  UpdateCustomPeriod;
  RefreshData;
end;

procedure TCCurrencyRateFrame.CStaticPeriodGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
var xList: TStringList;
    xGid, xText: String;
    xRect: TRect;
begin
  xList := TStringList.Create;
  xList.Add(CFilterToday + '=<wa¿ne dziœ>');
  xList.Add(CFilterYesterday + '=<wa¿ne wczoraj>');
  xList.Add(CFilterWeek + '=<wa¿ne w tym tygodniu>');
  xList.Add(CFilterMonth + '=<wa¿ne w tym miesi¹cu>');
  xList.Add(CFilterOther + '=<wybrany okres>');
  xList.Add(CFilterAllElements + '=<wszystkie>');
  xGid := CFilterAllElements;
  xText := '';
  xRect := Rect(10, 10, 200, 300);
  AAccepted := TCFrameForm.ShowFrame(TCListFrame, xGid, xText, xList, @xRect);
  if AAccepted then begin
    ADataGid := xGid;
    AText := xText;
  end;
end;

constructor TRateFrameAdditionalData.CreateRateData(AIdSource, AIdDest: String);
begin
  inherited CreateNew;
  FIdSource := AIdSource;
  FIdDest := AIdDest;
end;

function TCCurrencyRateFrame.GetAdditionalDataForObject: TAdditionalData;
begin
  if AdditionalData = Nil then begin
    Result := inherited GetAdditionalDataForObject;
  end else begin
    Result := TRateFormAdditionalData.CreateRateData(TRateFrameAdditionalData(AdditionalData).idSource, TRateFrameAdditionalData(AdditionalData).idDesc);
  end;
end;

constructor TRateFormAdditionalData.CreateRateData(AIdSource, AIdDest: String);
begin
  inherited Create;
  FIdSource := AIdSource;
  FIdDest := AIdDest;
end;

function TCCurrencyRateFrame.GetSelectedType: Integer;
begin
  if List.FocusedNode <> Nil then begin
    Result := CSELECTEDITEM_CURRENCYRATE;
  end else begin
    Result := CSELECTEDITEM_INCORRECT;
  end;
end;

function TCCurrencyRateFrame.IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean;
begin
  Result := (APluginSelectedItemTypes and CSELECTEDITEM_CURRENCYRATE) = CSELECTEDITEM_CURRENCYRATE;
end;

end.
