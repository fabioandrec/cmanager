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
  public
    class function GetTitle: String; override;
    procedure ReloadDataobjects; override;
    function GetStaticFilter: TStringList; override;
    function GetDataobjectClass(AOption: Integer): TDataObjectClass; override;
    function GetDataobjectProxy(AOption: Integer): TDataProxy; override;
    function GetDataobjectForm(AOption: Integer): TCDataobjectFormClass; override;
    procedure InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean); override;
    function IsValidFilteredObject(AObject: TDataObject): Boolean; override;
    function GetInitialiFilter: String; override;
  end;

implementation

uses CDataObjects, CCurrencyRateFormUnit, CConsts, DateUtils,
  CFrameFormUnit, CLimitsFrameUnit, CListFrameUnit, CBaseFrameUnit;

{$R *.dfm}

function TCCurrencyRateFrame.GetDataobjectClass(AOption: Integer): TDataObjectClass;
begin
  Result := TCurrencyRate;
end;

function TCCurrencyRateFrame.GetDataobjectForm(AOption: Integer): TCDataobjectFormClass;
begin
  Result := TCCurrencyRateForm;
end;

function TCCurrencyRateFrame.GetDataobjectProxy(AOption: Integer): TDataProxy;
begin
  Result := CurrencyRateProxy;
end;

procedure TCCurrencyRateFrame.GetFilterDates(var ADateFrom, ADateTo: TDateTime);
var xId: TDataGid;
begin
  ADateFrom := 0;
  ADateTo := 0;
  xId := CStaticPeriod.DataId;
  if xId = CCurrencyRateFilterToday then begin
    ADateFrom := GWorkDate;
    ADateTo := GWorkDate;
  end else if xId = CCurrencyRateFilterYesterday then begin
    ADateFrom := IncDay(GWorkDate, -1);
    ADateTo := IncDay(GWorkDate, -1);
  end else if xId = CCurrencyRateFilterWeek then begin
    ADateFrom := StartOfTheWeek(GWorkDate);
    ADateTo := EndOfTheWeek(GWorkDate);
  end else if xId = CCurrencyRateFilterMonth then begin
    ADateFrom := StartOfTheMonth(GWorkDate);
    ADateTo := EndOfTheMonth(GWorkDate);
  end else if xId = CCurrencyRateFilterOther then begin
    ADateFrom := CDateTimePerStart.Value;
    ADateTo := CDateTimePerEnd.Value;
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
  Result := (inherited IsValidFilteredObject(AObject)) or
            ((xDf <= TCurrencyRate(AObject).bindingDate) and (TCurrencyRate(AObject).bindingDate <= xDt)
            and (CStaticFilter.DataId = TCurrencyRate(AObject).rateType));
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
  CDateTimePerStart.HotTrack := CStaticPeriod.DataId = CCurrencyRateFilterOther;
  CDateTimePerEnd.HotTrack := CStaticPeriod.DataId = CCurrencyRateFilterOther;
  if CStaticPeriod.DataId <> CCurrencyRateFilterOther then begin
    GetFilterDates(xF, xE);
    CDateTimePerStart.Value := xF;
    CDateTimePerEnd.Value := xE;
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

function TCCurrencyRateFrame.GetInitialiFilter: String;
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
  xList.Add(CFilterAllElements + '=<wszystkie elementy>');
  xList.Add(CCurrencyRateFilterToday + '=<wa¿ne dziœ>');
  xList.Add(CCurrencyRateFilterYesterday + '=<wa¿ne wczoraj>');
  xList.Add(CCurrencyRateFilterWeek + '=<wa¿ne w tym tygodniu>');
  xList.Add(CCurrencyRateFilterMonth + '=<wa¿ne w tym miesi¹cu>');
  xList.Add(CCurrencyRateFilterOther + '=<dowolny okres>');
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

end.
