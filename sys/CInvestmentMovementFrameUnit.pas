unit CInvestmentMovementFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFrameUnit, ActnList, VTHeaderPopup, Menus, ImgList,
  PngImageList, CComponents, VirtualTrees, StdCtrls, ExtCtrls, CDatabase,
  CDataObjectFormUnit, DateUtils, CImageListsUnit;

type
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
  CTools, CFrameFormUnit, CListFrameUnit;

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
  Result := 'Inwestycje';
end;

procedure TCInvestmentMovementFrame.InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean);
begin
  inherited InitializeFrame(AOwner, AAdditionalData, AOutputData, AMultipleCheck, AWithButtons);
  CStaticPeriod.DataId := '1';
  UpdateCustomPeriod;
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
begin
  Result := (inherited IsValidFilteredObject(AObject));
end;

procedure TCInvestmentMovementFrame.ReloadDataobjects;
var xCondition: String;
    xDf, xDt: TDateTime;
begin
  GetFilterDates(xDf, xDt);
  xCondition := Format('regDateTime between %s and %s', [DatetimeToDatabase(xDf, True), DatetimeToDatabase(xDt, True)]);
  if CStaticFilter.DataId = CInvestmentSellMovement then begin
    xCondition := xCondition + Format(' and movementType = ''%s''', [CInvestmentSellMovement]);
  end else if CStaticFilter.DataId = CInvestmentBuyMovement then begin
    xCondition := xCondition + Format(' and movementType = ''%s''', [CInvestmentBuyMovement]);
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
  if CStaticPeriod.DataId <> '7' then begin
    GetFilterDates(xF, xE);
    CDateTimePerStart.Value := xF;
    CDateTimePerEnd.Value := xE;
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

end.
 