unit CDepositMovementFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFrameUnit, ActnList, VTHeaderPopup, Menus, ImgList,
  PngImageList, CComponents, VirtualTrees, StdCtrls, ExtCtrls, CDatabase,
  CDataObjectFormUnit, DateUtils, CImageListsUnit, AdoDb;

type
  TCDepositFrameAdditionalData = class(TCDataobjectFrameData)
  private
    FDepositId: TDataGid;
  public
    constructor Create(ADepositId: TDataGid);
  end;

  TCDepositMovementFrame = class(TCDataobjectFrame)
    Label1: TLabel;
    CStaticPeriod: TCStatic;
    Label3: TLabel;
    CDateTimePerStart: TCDateTime;
    Label4: TLabel;
    CDateTimePerEnd: TCDateTime;
    Label5: TLabel;
    procedure CStaticPeriodChanged(Sender: TObject);
    procedure CStaticPeriodGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CDateTimePerStartChanged(Sender: TObject);
    procedure CDateTimePerEndChanged(Sender: TObject);
  private
    procedure UpdateCustomPeriod;
    procedure GetFilterDates(var ADateFrom, ADateTo: TDateTime);
  protected
    function IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean; override;
    function GetSelectedType: Integer; override;
    procedure AfterDeleteObject(ADataobject: TDataObject); override;
    procedure DoAddingNewDataobject(ADataobject: TDataObject); override;
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
    procedure InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean); override;
  end;

implementation

uses CDataObjects, CPluginConsts, CConsts, CTools, CFrameFormUnit, CListFrameUnit, CBaseFrameUnit,
  CMovementFrameUnit, DB;

{$R *.dfm}

class function TCDepositMovementFrame.GetDataobjectClass(AOption: Integer): TDataObjectClass;
begin
  Result := TDepositMovement;
end;

function TCDepositMovementFrame.GetDataobjectForm(AOption: Integer): TCDataobjectFormClass;
begin
  //Result := TCInvestmentMovementForm;
end;

class function TCDepositMovementFrame.GetDataobjectProxy(AOption: Integer): TDataProxy;
begin
  Result := DepositMovementProxy;
end;

procedure TCDepositMovementFrame.GetFilterDates(var ADateFrom, ADateTo: TDateTime);
var xId: TDataGid;
begin
  ADateFrom := 0;
  ADateTo := 0;
  xId := CStaticPeriod.DataId;
  if xId = '1' then begin
    ADateFrom := StartOfTheDay(GWorkDate);
    ADateTo := EndOfTheDay(GWorkDate);
  end else if xId = '2' then begin
    ADateFrom := StartOfTheWeek(GWorkDate);
    ADateTo := EndOfTheWeek(GWorkDate);
  end else if xId = '3' then begin
    ADateFrom := StartOfTheMonth(GWorkDate);
    ADateTo := EndOfTheMonth(GWorkDate);
  end else if xId = '4' then begin
    ADateFrom := StartOfTheDay(IncDay(GWorkDate, -6));
    ADateTo := EndOfTheDay(GWorkDate);
  end else if xId = '5' then begin
    ADateFrom := StartOfTheDay(IncDay(GWorkDate, -13));
    ADateTo := EndOfTheDay(GWorkDate);
  end else if xId = '6' then begin
    ADateFrom := StartOfTheDay(IncDay(GWorkDate, -29));
    ADateTo := EndOfTheDay(GWorkDate);
  end else if xId = '7' then begin
    ADateFrom := CDateTimePerStart.Value;
    ADateTo := CDateTimePerEnd.Value;
  end;
end;

function TCDepositMovementFrame.GetHistoryText: String;
begin
end;

function TCDepositMovementFrame.GetSelectedType: Integer;
begin
  if List.FocusedNode <> Nil then begin
    Result := CSELECTEDITEM_DEPOSITMOVEMENT;
  end else begin
    Result := CSELECTEDITEM_INCORRECT;
  end;
end;

function TCDepositMovementFrame.GetStaticFilter: TStringList;
begin
  Result := TStringList.Create;
  with Result do begin
    Add(CFilterAllElements + '=<wszystkie elementy>');
    Add(CInvestmentBuyMovement + '=<tylko zakupy>');
    Add(CInvestmentSellMovement + '=<tylko sprzeda¿>');
  end;
end;

class function TCDepositMovementFrame.GetTitle: String;
begin
  Result := 'Operacje lokat';
end;

procedure TCDepositMovementFrame.InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean);
var xSql: String;
    xQuery: TADOQuery;
begin
  CStaticPeriod.DataId := '1';
  UpdateCustomPeriod;
  if AAdditionalData <> Nil then begin
    with TCDepositFrameAdditionalData(AAdditionalData) do begin
      xSql := Format('select min(regDate) as minDate, max(regDate) as maxDate from depositMovement where idDepositInvestment = %s',
              [DataGidToDatabase(FDepositId)]);
      xQuery := GDataProvider.OpenSql(xSql);
      if not xQuery.IsEmpty then begin
        CStaticPeriod.DataId := '7';
        CStaticPeriod.Caption := '<dowolny>';
        CDateTimePerStart.Value := xQuery.FieldByName('minDate').AsDateTime;
        CDateTimePerEnd.Value := xQuery.FieldByName('maxDate').AsDateTime;
        UpdateCustomPeriod;
      end;
      xQuery.Free;
    end;
  end;
  inherited InitializeFrame(AOwner, AAdditionalData, AOutputData, AMultipleCheck, AWithButtons);
  Label5.Left := FilterPanel.Width - 8;
  CDateTimePerEnd.Left := Label5.Left - CDateTimePerEnd.Width;
  Label4.Left := CDateTimePerEnd.Left - 15;
  CDateTimePerStart.Left := Label4.Left - CDateTimePerStart.Width;
  Label3.Left := CDateTimePerStart.Left - 18;
  Label3.Anchors := [akRight, akTop];
  CDateTimePerStart.Anchors := [akRight, akTop];
  Label4.Anchors := [akRight, akTop];
  CDateTimePerEnd.Anchors := [akRight, akTop];
  Label5.Anchors := [akRight, akTop];
end;

function TCDepositMovementFrame.IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean;
begin
  Result := (APluginSelectedItemTypes and CSELECTEDITEM_DEPOSITMOVEMENT) = CSELECTEDITEM_DEPOSITMOVEMENT;
end;

function TCDepositMovementFrame.IsValidFilteredObject(AObject: TDataObject): Boolean;
var xDf, xDt: TDateTime;
begin
  GetFilterDates(xDf, xDt);
  Result := ((inherited IsValidFilteredObject(AObject)) or (CStaticFilter.DataId = TDepositMovement(AObject).movementType)) and
            (xDf <= TDepositMovement(AObject).regDate) and (TDepositMovement(AObject).regDate <= xDt);
  if Result and (AdditionalData <> Nil) then begin
    with TCDepositFrameAdditionalData(AdditionalData) do begin
      Result := (TDepositMovement(AObject).idDepositInvestment = FDepositId);
    end;
  end;
end;

procedure TCDepositMovementFrame.ReloadDataobjects;
var xCondition: String;
    xDf, xDt: TDateTime;
begin
  inherited ReloadDataobjects;
  GetFilterDates(xDf, xDt);
  xCondition := Format('regDate between %s and %s', [DatetimeToDatabase(xDf, False), DatetimeToDatabase(xDt, False)]);
  if CStaticFilter.DataId = CInvestmentSellMovement then begin
    xCondition := xCondition + Format(' and movementType = ''%s''', [CInvestmentSellMovement]);
  end else if CStaticFilter.DataId = CInvestmentBuyMovement then begin
    xCondition := xCondition + Format(' and movementType = ''%s''', [CInvestmentBuyMovement]);
  end;
  if AdditionalData <> Nil then begin
    with TCDepositFrameAdditionalData(AdditionalData) do begin
      xCondition := xCondition + Format(' and idDepositInvestment = %s', [DataGidToDatabase(FDepositId)]);
    end;
  end;
  Dataobjects := TDataObject.GetList(TDepositMovement, DepositMovementProxy, 'select * from depositMovement where ' + xCondition + ' order by created');
end;

procedure TCDepositMovementFrame.ShowHistory(AGid: ShortString);
begin
end;

procedure TCDepositMovementFrame.UpdateCustomPeriod;
var xF, xE: TDateTime;
begin
  CDateTimePerStart.HotTrack := CStaticPeriod.DataId = '7';
  CDateTimePerEnd.HotTrack := CStaticPeriod.DataId = '7';
  if CStaticPeriod.DataId <> '7' then begin
    GetFilterDates(xF, xE);
    CDateTimePerStart.Value := xF;
    CDateTimePerEnd.Value := xE;
  end;
end;

procedure TCDepositMovementFrame.CStaticPeriodChanged(Sender: TObject);
begin
  UpdateCustomPeriod;
  RefreshData;
end;

procedure TCDepositMovementFrame.CStaticPeriodGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
var xList: TStringList;
    xGid, xText: String;
    xRect: TRect;
begin
  xList := TStringList.Create;
  xList.Add('1=<tylko dziœ>');
  xList.Add('2=<w tym tygodniu>');
  xList.Add('3=<w tym miesi¹cu>');
  xList.Add('4=<ostatnie 7 dni>');
  xList.Add('5=<ostatnie 14 dni>');
  xList.Add('6=<ostatnie 30 dni>');
  xList.Add('7=<dowolny>');
  xGid := CEmptyDataGid;
  xText := '';
  xRect := Rect(10, 10, 200, 300);
  AAccepted := TCFrameForm.ShowFrame(TCListFrame, xGid, xText, xList, @xRect);
  if AAccepted then begin
    ADataGid := xGid;
    AText := xText;
  end;
end;

procedure TCDepositMovementFrame.CDateTimePerStartChanged(Sender: TObject);
begin
  RefreshData;
end;

procedure TCDepositMovementFrame.CDateTimePerEndChanged(Sender: TObject);
begin
  RefreshData;
end;

procedure TCDepositMovementFrame.AfterDeleteObject(ADataobject: TDataObject);
var xInvest: TDepositMovement;
    xMovement: TBaseMovement;
    xBaseId: TDataGid;
begin
  xInvest := TDepositMovement(ADataobject);
  xBaseId := xInvest.idBaseMovement;
  if (xBaseId <> CEmptyDataGid) then begin
    GDataProvider.BeginTransaction;
    xMovement := TBaseMovement(TBaseMovement.LoadObject(BaseMovementProxy, xInvest.idBaseMovement, False));
    xMovement.DeleteObject;
    GDataProvider.CommitTransaction;
    SendMessageToFrames(TCMovementFrame, WM_DATAOBJECTDELETED, Integer(@xBaseId), WMOPT_BASEMOVEMENT);
  end;
  inherited AfterDeleteObject(ADataobject);
end;

constructor TCDepositFrameAdditionalData.Create(ADepositId: TDataGid);
begin
  inherited CreateNew;
  FDepositId := ADepositId;
end;

procedure TCDepositMovementFrame.DoAddingNewDataobject(ADataobject: TDataObject);
begin
  inherited DoAddingNewDataobject(ADataobject);
  if AdditionalData <> Nil then begin
    if TDepositMovement(ADataobject).regDate < CDateTimePerStart.Value then begin
      CDateTimePerStart.Value := TDepositMovement(ADataobject).regDate;
    end;
    if TDepositMovement(ADataobject).regDate > CDateTimePerEnd.Value then begin
      CDateTimePerEnd.Value := TDepositMovement(ADataobject).regDate;
    end;
  end;
end;

end.
