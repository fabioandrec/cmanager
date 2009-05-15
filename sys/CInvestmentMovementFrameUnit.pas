unit CInvestmentMovementFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFrameUnit, ActnList, VTHeaderPopup, Menus, ImgList,
  PngImageList, CComponents, VirtualTrees, StdCtrls, ExtCtrls, CDatabase,
  CDataObjectFormUnit, DateUtils, CImageListsUnit, AdoDb;

type
  TCInvestmentFrameAdditionalData = class(TCDataobjectFrameData)
  private
    FAccountId: TDataGid;
    FInstrumentId: TDataGid;
  public
    constructor Create(AAccountId, AInstrumentId: TDataGid);
  end;

  TCInvestmentMovementFrame = class(TCDataobjectFrame)
    Label1: TLabel;
    CStaticPeriod: TCStatic;
    Label6: TLabel;
    CStaticViewCurrency: TCStatic;
    Label3: TLabel;
    CDateTimePerStart: TCDateTime;
    Label4: TLabel;
    CDateTimePerEnd: TCDateTime;
    Label5: TLabel;
    procedure CStaticPeriodChanged(Sender: TObject);
    procedure CStaticPeriodGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticViewCurrencyGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticViewCurrencyChanged(Sender: TObject);
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

uses CDataObjects, CInvestmentMovementFormUnit, CPluginConsts, CConsts,
  CTools, CFrameFormUnit, CListFrameUnit, CBaseFrameUnit,
  CMovementFrameUnit, DB, CAccountsFrameUnit, CInvestmentPortfolioFormUnit,
  CInvestmentPortfolioFrameUnit;

{$R *.dfm}

class function TCInvestmentMovementFrame.GetDataobjectClass(AOption: Integer): TDataObjectClass;
begin
  Result := TInvestmentMovement;
end;

function TCInvestmentMovementFrame.GetDataobjectForm(AOption: Integer): TCDataobjectFormClass;
begin
  Result := TCInvestmentMovementForm;
end;

class function TCInvestmentMovementFrame.GetDataobjectProxy(AOption: Integer): TDataProxy;
begin
  Result := InvestmentMovementProxy;
end;

procedure TCInvestmentMovementFrame.GetFilterDates(var ADateFrom, ADateTo: TDateTime);
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
  end else if xId = '8' then begin
    ADateFrom := LowestDatetime;
    ADateTo := HighestDatetime;
  end;
end;

function TCInvestmentMovementFrame.GetHistoryText: String;
begin
end;

function TCInvestmentMovementFrame.GetSelectedType: Integer;
begin
  if List.FocusedNode <> Nil then begin
    Result := CSELECTEDITEM_INVESTMENTMOVEMENT;
  end else begin
    Result := CSELECTEDITEM_INCORRECT;
  end;
end;

function TCInvestmentMovementFrame.GetStaticFilter: TStringList;
begin
  Result := TStringList.Create;
  with Result do begin
    Add(CFilterAllElements + '=<wszystkie elementy>');
    Add(CInvestmentBuyMovement + '=<tylko zakupy>');
    Add(CInvestmentSellMovement + '=<tylko sprzeda¿>');
  end;
end;

class function TCInvestmentMovementFrame.GetTitle: String;
begin
  Result := 'Operacje inwestycyjne';
end;

procedure TCInvestmentMovementFrame.InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean);
var xSql: String;
    xQuery: TADOQuery;
begin
  CStaticPeriod.DataId := '1';
  UpdateCustomPeriod;
  if AAdditionalData <> Nil then begin
    with TCInvestmentFrameAdditionalData(AAdditionalData) do begin
      xSql := Format('select min(regDateTime) as minDate, max(regDateTime) as maxDate from investmentMovement where idAccount = %s and idInstrument = %s',
              [DataGidToDatabase(FAccountId), DataGidToDatabase(FInstrumentId)]);
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
  Label6.Left := CStaticPeriod.Left + CStaticPeriod.Width;
  CStaticViewCurrency.Left := Label6.Left + Label6.Width + 4;
  Label3.Anchors := [akRight, akTop];
  CDateTimePerStart.Anchors := [akRight, akTop];
  Label4.Anchors := [akRight, akTop];
  CDateTimePerEnd.Anchors := [akRight, akTop];
  Label5.Anchors := [akRight, akTop];
end;

function TCInvestmentMovementFrame.IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean;
begin
  Result := (APluginSelectedItemTypes and CSELECTEDITEM_INVESTMENTMOVEMENT) = CSELECTEDITEM_INVESTMENTMOVEMENT;
end;

function TCInvestmentMovementFrame.IsValidFilteredObject(AObject: TDataObject): Boolean;
var xDf, xDt: TDateTime;
begin
  GetFilterDates(xDf, xDt);
  Result := ((inherited IsValidFilteredObject(AObject)) or (CStaticFilter.DataId = TInvestmentMovement(AObject).movementType)) and
            (xDf <= TInvestmentMovement(AObject).regDateTime) and (TInvestmentMovement(AObject).regDateTime <= xDt);
  if Result and (AdditionalData <> Nil) then begin
    with TCInvestmentFrameAdditionalData(AdditionalData) do begin
      Result := (TInvestmentMovement(AObject).idAccount = FAccountId) and (TInvestmentMovement(AObject).idInstrument = FInstrumentId); 
    end;
  end;
end;

procedure TCInvestmentMovementFrame.ReloadDataobjects;
var xCondition: String;
    xDf, xDt: TDateTime;
begin
  inherited ReloadDataobjects;
  GetFilterDates(xDf, xDt);
  xCondition := Format('regDateTime between %s and %s', [DatetimeToDatabase(xDf, True), DatetimeToDatabase(xDt, True)]);
  if CStaticFilter.DataId = CInvestmentSellMovement then begin
    xCondition := xCondition + Format(' and movementType = ''%s''', [CInvestmentSellMovement]);
  end else if CStaticFilter.DataId = CInvestmentBuyMovement then begin
    xCondition := xCondition + Format(' and movementType = ''%s''', [CInvestmentBuyMovement]);
  end;
  if AdditionalData <> Nil then begin
    with TCInvestmentFrameAdditionalData(AdditionalData) do begin
      xCondition := xCondition + Format(' and idAccount = %s and idInstrument = %s', [DataGidToDatabase(FAccountId), DataGidToDatabase(FInstrumentId)]);
    end;
  end;
  Dataobjects := TDataObject.GetList(TInvestmentMovement, InvestmentMovementProxy, 'select * from investmentMovement where ' + xCondition + ' order by created');
end;

procedure TCInvestmentMovementFrame.ShowHistory(AGid: ShortString);
begin
end;

procedure TCInvestmentMovementFrame.UpdateCustomPeriod;
var xF, xE: TDateTime;
begin
  CDateTimePerStart.HotTrack := CStaticPeriod.DataId = '7';
  CDateTimePerEnd.HotTrack := CStaticPeriod.DataId = '7';
  CDateTimePerStart.Visible := CStaticPeriod.DataId <> '8';
  CDateTimePerEnd.Visible := CStaticPeriod.DataId <> '8';
  Label3.Visible := CDateTimePerEnd.Visible;
  Label3.Update;
  Label4.Visible := CDateTimePerEnd.Visible;
  Label4.Update;
  Label5.Visible := CDateTimePerEnd.Visible;
  Label5.Update;
  if CStaticPeriod.DataId <> '7' then begin
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

procedure TCInvestmentMovementFrame.CStaticPeriodChanged(Sender: TObject);
begin
  UpdateCustomPeriod;
  RefreshData;
end;

procedure TCInvestmentMovementFrame.CStaticPeriodGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
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
  xList.Add('7=<wybrany zakres>');
  xList.Add('8=<dowolny>');
  xGid := CEmptyDataGid;
  xText := '';
  xRect := Rect(10, 10, 200, 300);
  AAccepted := TCFrameForm.ShowFrame(TCListFrame, xGid, xText, xList, @xRect);
  if AAccepted then begin
    ADataGid := xGid;
    AText := xText;
  end;
end;

procedure TCInvestmentMovementFrame.CStaticViewCurrencyGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ShowCurrencyViewTypeInvestmentMovement(ADataGid, AText);
end;

procedure TCInvestmentMovementFrame.CStaticViewCurrencyChanged(Sender: TObject);
begin
  List.ViewTextSelector := CStaticViewCurrency.DataId;
end;

procedure TCInvestmentMovementFrame.CDateTimePerStartChanged(Sender: TObject);
begin
  RefreshData;
end;

procedure TCInvestmentMovementFrame.CDateTimePerEndChanged(Sender: TObject);
begin
  RefreshData;
end;

procedure TCInvestmentMovementFrame.AfterDeleteObject(ADataobject: TDataObject);
var xInvest: TInvestmentMovement;
    xMovement: TBaseMovement;
    xBaseId: TDataGid;
    xAccountId: TDataGid;
begin
  xInvest := TInvestmentMovement(ADataobject);
  xBaseId := xInvest.idBaseMovement;
  xAccountId := xInvest.idAccount;
  if (xBaseId <> CEmptyDataGid) then begin
    GDataProvider.BeginTransaction;
    xMovement := TBaseMovement(TBaseMovement.LoadObject(BaseMovementProxy, xInvest.idBaseMovement, False));
    xMovement.DeleteObject;
    GDataProvider.CommitTransaction;
    SendMessageToFrames(TCMovementFrame, WM_DATAOBJECTDELETED, Integer(@xBaseId), WMOPT_BASEMOVEMENT);
    SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTEDITED, Integer(@xAccountId), WMOPT_NONE);
    SendMessageToFrames(TCInvestmentPortfolioFrame, WM_DATAREFRESH, 0, WMOPT_NONE);
  end;
  inherited AfterDeleteObject(ADataobject);
end;

constructor TCInvestmentFrameAdditionalData.Create(AAccountId, AInstrumentId: TDataGid);
begin
  inherited CreateNew;
  FAccountId := AAccountId;
  FInstrumentId := AInstrumentId;
end;

procedure TCInvestmentMovementFrame.DoAddingNewDataobject(ADataobject: TDataObject);
begin
  inherited DoAddingNewDataobject(ADataobject);
  if AdditionalData <> Nil then begin
    if TInvestmentMovement(ADataobject).regDateTime < CDateTimePerStart.Value then begin
      CDateTimePerStart.Value := TInvestmentMovement(ADataobject).regDateTime;
    end;
    if TInvestmentMovement(ADataobject).regDateTime > CDateTimePerEnd.Value then begin
      CDateTimePerEnd.Value := TInvestmentMovement(ADataobject).regDateTime;
    end;
  end;
end;

end.
