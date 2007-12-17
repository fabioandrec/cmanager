unit CSurpassedFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, CBaseFrameUnit, CDatabase,
  VirtualTrees, CComponents, Contnrs, CDataObjects, CImageListsUnit, CTools;

type
  TSurpassedLimit = class(TCDataListElementObject)
  private
    Flimit: TMovementLimit;
    Famount: Currency;
  public
    constructor Create(AMovementLimit: TMovementLimit; ACash: Currency);
    function GetElementHint(AColumnIndex: Integer): String; override;
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String; override;
    function GetColumnImage(AColumnIndex: Integer): Integer; override;
  end;

  TCSurpassedForm = class(TCConfigForm)
    PanelFrame: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    SurpassedList: TCDataList;
    procedure SurpassedListCDataListReloadTree(Sender: TCDataList; ARootElement: TCListDataElement);
  private
    FMovementType: TBaseEnumeration;
    FDate: TDateTime;
    FDataobjects: TDataObjectList;
    FAccountIds: TDataGids;
    FCategorySums: TSumList;
    FCashpointIds: TDataGids;
  public
    destructor Destroy; override;
  end;

function CheckSurpassedLimits(AMovementType: TBaseEnumeration; ADate: TDateTime; AAccountIds, ACashpointIds: TDataGids; ACategorySums: TSumList): Boolean;

implementation

uses CConsts;

{$R *.dfm}

function CheckSurpassedLimits(AMovementType: TBaseEnumeration; ADate: TDateTime; AAccountIds, ACashpointIds: TDataGids; ACategorySums: TSumList): Boolean;
var xForm: TCSurpassedForm;
begin
  xForm := TCSurpassedForm.Create(Application);
  xForm.FDate := ADate;
  xForm.FAccountIds := AAccountIds;
  xForm.FCategorySums := ACategorySums;
  xForm.FCashpointIds := ACashpointIds;
  xForm.FMovementType := AMovementType;
  xForm.SurpassedList.ReloadTree;
  if xForm.SurpassedList.RootNodeCount <> 0 then begin
    Result := xForm.ShowConfig(coEdit);
  end else begin
    Result := True;
  end;
  xForm.Free;
end;

destructor TCSurpassedForm.Destroy;
begin
  if FAccountIds <> Nil then begin
    FAccountIds.Free;
  end;
  if FCategorySums <> Nil then begin
    FCategorySums.Free;
  end;
  if FCashpointIds <> Nil then begin
    FCashpointIds.Free;
  end;
  FDataobjects.Free;
  inherited Destroy;
end;

procedure TCSurpassedForm.SurpassedListCDataListReloadTree(Sender: TCDataList; ARootElement: TCListDataElement);
var xSql: String;
    xCondition, xCondA, xCondC, xCondP: String;
    xCount: Integer;
    xLimit: TMovementLimit;
    xElement: TCListDataElement;
    xAmount: Currency;
    xCash: Currency;
    xFilterCats: TStringList;
begin
  xCondA := '';
  xCondC := '';
  xCondP := '';
  xCondition := '';
  for xCount := 0 to FAccountIds.Count - 1 do begin
    xCondA := xCondition + DataGidToDatabase(FAccountIds.Strings[xCount]);
    if xCount <> FAccountIds.Count - 1 then begin
      xCondA := xCondA + ', ';
    end;
  end;
  if FAccountIds.Count > 0 then begin
    xCondition := xCondition + '(idAccount in (' + xCondA + ') or idAccount is null)';
  end;
  for xCount := 0 to FCategorySums.Count - 1 do begin
    xCondP := xCondP + DataGidToDatabase(FCategorySums.Items[xCount].name);
    if xCount <> FCategorySums.Count - 1 then begin
      xCondP := xCondP + ', ';
    end;
  end;
  if FCategorySums.Count > 0 then begin
    if xCondition <> '' then begin
      xCondition := xCondition + ' or ';
    end;
    xCondition := xCondition + '(idProduct in (' + xCondP + ') or idProduct is null)';
  end;
  for xCount := 0 to FCashpointIds.Count - 1 do begin
    xCondC := xCondC + DataGidToDatabase(FCashpointIds.Strings[xCount]);
    if xCount <> FCashpointIds.Count - 1 then begin
      xCondC := xCondC + ', ';
    end;
  end;
  if FCashpointIds.Count > 0 then begin
    if xCondition <> '' then begin
      xCondition := xCondition + ' or ';
    end;
    xCondition := xCondition + '(idCashpoint in (' + xCondC + ') or idCashpoint is null)';
  end;
  if xCondition <> '' then begin
    xCondition := ' where ' + xCondition;
  end;
  xSql := 'select * from movementLimit where isActive = true and (idMovementFilter is null or idMovementFilter in (select distinct(idMovementFilter) from filters' + xCondition + '))';
  FDataobjects := TMovementLimit.GetList(TMovementLimit, MovementLimitProxy, xSql);
  for xCount := 0 to FDataobjects.Count - 1 do begin
    xLimit := TMovementLimit(FDataobjects.Items[xCount]);
    if xLimit.idFilter = CEmptyDataGid then begin
      xCash := FCategorySums.GetSum(xLimit.idCurrencyDef);
    end else begin
      xFilterCats := GDataProvider.GetSqlStringList('select idProduct from productFilter where idMovementFilter = ' + DataGidToDatabase(xLimit.idFilter));
      if xFilterCats.Count > 0 then begin
        xCash := FCategorySums.GetSum(xFilterCats, xLimit.idCurrencyDef);
      end else begin
        xCash := FCategorySums.GetSum(xLimit.idCurrencyDef);
      end;
      xFilterCats.Free;
    end;
    if xLimit.sumType = CLimitSumtypeOut then begin
      if FMovementType = COutMovement then begin
        xAmount := xLimit.GetCurrentAmount(FDate, False) + xCash;
      end else begin
        xAmount := 0;
      end;
    end else if xLimit.sumType = CLimitSumtypeIn then begin
      if FMovementType = CInMovement then begin
        xAmount := xLimit.GetCurrentAmount(FDate, False) + xCash;
      end else begin
        xAmount := 0;
      end;
    end else begin
      if FMovementType = CInMovement then begin
        xAmount := xLimit.GetCurrentAmount(FDate, False) + xCash;
      end else begin
        xAmount := xLimit.GetCurrentAmount(FDate, False) - xCash;
      end;
    end;
    if xLimit.IsSurpassed(xAmount) then begin
      xElement := TCListDataElement.Create(False, SurpassedList, TSurpassedLimit.Create(xLimit, xAmount), True);
      ARootElement.Add(xElement);
    end;
  end;
end;

constructor TSurpassedLimit.Create(AMovementLimit: TMovementLimit; ACash: Currency);
begin
  inherited Create;
  Flimit := AMovementLimit;
  Famount := ACash;
end;

function TSurpassedLimit.GetColumnImage(AColumnIndex: Integer): Integer;
begin
  Result := -1;
  if AColumnIndex = 3 then begin
    if Flimit.sumType = CLimitSumtypeOut then begin
      Result := 1;
    end else if Flimit.sumType = CLimitSumtypeIn then begin
      Result := 0;
    end else begin
      Result := 7;
    end;
  end else if AColumnIndex = 4 then begin
    if Flimit.IsSurpassed(Famount) then begin
      Result := 4;
    end else begin
      Result := 2;
    end;
  end;
end;

function TSurpassedLimit.GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String;
begin
  if AColumnIndex = 0 then begin
    Result := Flimit.name;
  end else if AColumnIndex = 1 then begin
    Result := GCurrencyCache.GetIso(Flimit.idCurrencyDef);
  end else if AColumnIndex = 2 then begin
    Result := CurrencyToString(Famount, '', False);
  end else if AColumnIndex = 3 then begin
    if Flimit.sumType = CLimitSumtypeOut then begin
      Result := CLimitSumtypeOutDescription;
    end else if Flimit.sumType = CLimitSumtypeOut then begin
      Result := CLimitSumtypeInDescription;
    end else begin
      Result := CLimitSumtypeBalanceDescription;
    end;
  end else begin
    if Flimit.IsSurpassed(Famount) then begin
      Result := CLimitSupressedDesc;
    end else begin
      Result := CLimitValidDesc;
    end;
  end;
end;

function TSurpassedLimit.GetElementHint(AColumnIndex: Integer): String;
begin
  Result := Flimit.description;
end;

end.
