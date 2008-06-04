unit CStartupInfoFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, Menus, ImgList, PngImageList, VirtualTrees, CDatabase,
  CSchedules, Contnrs, ExtCtrls, GraphUtil, CConfigFormUnit, VTHeaderPopup,
  CImageListsUnit, CComponents, CDataObjects;

type
  TStartupHelperType = (shtGroup, shtDate, shtPlannedItem, shtLimit, shtExtraction);
  TStartupHelperGroup = (shgIntimeIn, shgIntimeOut, shgIntimeTran, shgOvertimeIn, shgOvertimeOut, shgOvertimeTran, shgLimit, shgExtraction);
  TStartupHelperList = class;
  TStartupHelper = class;

  TCStartupInfoFrame = class(TCBaseFrame)
    RepaymentList: TCList;
    PanelError: TPanel;
    VTHeaderPopupMenu: TVTHeaderPopupMenu;
    procedure RepaymentListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure RepaymentListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure RepaymentListInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
    procedure RepaymentListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure RepaymentListGetImageIndexEx(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer; var ImageList: TCustomImageList);
    procedure RepaymentListGetRowPreferencesName(AHelper: TObject; var APrefname: String);
  private
    FPlannedObjects: TDataObjectList;
    FDoneObjects: TDataObjectList;
    FScheduledObjects: TObjectList;
    FLimitData: TDataObjectList;
    FExtractionsData: TDataObjectList;
    FHelperList: TStartupHelperList;
  public
    procedure ReloadInfoTree;
    destructor Destroy; override;
    procedure InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean); override;
    class function GetTitle: String; override;
    class function GetOperation: TConfigOperation; override;
    class function GetPrefname: String; override;
    function GetList: TCList; override;
    class function GetDataobjectClass(AOption: Integer): TDataObjectClass; override;
    class function GetDataobjectProxy(AOption: Integer): TDataProxy; override;
  end;

  TStartupHelper = class(TObject)
  private
    FhelperType: TStartupHelperType;
    Fdate: TDateTime;
    Fgroup: TStartupHelperGroup;
    Fcount: Integer;
    Fsum: Currency;
    Fchilds: TStartupHelperList;
    Fitem: TObject;
    FidCurrencyDef: TDataGid;
  public
    constructor Create(ADate: TDateTime; AGroup: TStartupHelperGroup; AItem: TObject; AType: TStartupHelperType; AIdCurrencyDef: TDataGid);
    property childs: TStartupHelperList read Fchilds write Fchilds;
    property helperType: TStartupHelperType read FhelperType write FhelperType;
    property group: TStartupHelperGroup read Fgroup write Fgroup;
    property date: TDateTime read Fdate write Fdate;
    property item: TObject read Fitem write Fitem;
    property count: Integer read Fcount write Fcount;
    property sum: Currency read Fsum write Fsum;
    destructor Destroy; override;
  end;

  TStartupHelperList = class(TObjectList)
  private
    function GetItems(AIndex: Integer): TStartupHelper;
    procedure SetItems(AIndex: Integer; const Value: TStartupHelper);
  public
    property Items[AIndex: Integer]: TStartupHelper read GetItems write SetItems;
    function ByDate(ADate: TDateTime; AGroup: TStartupHelperGroup; ACanCreate: Boolean): TStartupHelper;
    function ByGroup(AGroup: TStartupHelperGroup; ACanCreate: Boolean): TStartupHelper;
  end;

implementation

uses CPreferences, CConsts, DateUtils, CTools, CDatatools;

{$R *.dfm}

destructor TCStartupInfoFrame.Destroy;
begin
  FreeAndNil(FPlannedObjects);
  FreeAndNil(FDoneObjects);
  FreeAndNil(FScheduledObjects);
  FreeAndNil(FLimitData);
  FreeAndNil(FExtractionsData);
  FreeAndNil(FHelperList);
  inherited Destroy;
end;

procedure TCStartupInfoFrame.ReloadInfoTree;
var xDf, xDt: TDateTime;
    xTypes: String;
    xSqlPlanned, xSqlDone: String;
    xCount: Integer;
    xPlannedTreeItem: TPlannedTreeItem;
    xLimit: TMovementLimit;
    xItemGroup: TStartupHelperGroup;
    xGroup: TStartupHelper;
    xDate: TStartupHelper;
    xItem: TStartupHelper;
    xAmount: Currency;
    xCurrencyDef: TDataGid;
    xExtraction: TAccountExtraction;
begin
  RepaymentList.BeginUpdate;
  RepaymentList.Clear;
  with GBasePreferences do begin
    if startupInfoType = CStartupInfoToday then begin
      xDf := GWorkDate;
      xDt := xDf;
    end else if startupInfoType = CStartupInfoNextday then begin
      xDf := IncDay(GWorkDate, 1);
      xDt := xDf;
    end else if startupInfoType = CStartupInfoThisweek then begin
      xDf := StartOfTheWeek(GWorkDate);
      xDt := EndOfTheWeek(xDf);
    end else if startupInfoType = CStartupInfoNextweek then begin
      xDf := StartOfTheWeek(IncWeek(GWorkDate, 1));
      xDt := EndOfTheWeek(xDf);
    end else if startupInfoType = CStartupInfoThismonth then begin
      xDf := StartOfTheMonth(GWorkDate);
      xDt := EndOfTheMonth(xDf);
    end else if startupInfoType = CStartupInfoNextmonth then begin
      xDf := StartOfTheMonth(IncMonth(GWorkDate, 1));
      xDt := EndOfTheMonth(xDf);
    end else begin
      xDf := GWorkDate;
      xDt := IncDay(GWorkDate, startupInfoDays);
    end;
    xTypes := '';
    if startupInfoIn or startupInfoOldIn then begin
      xTypes := xTypes + 'I';
    end;
    if startupInfoOut or startupInfoOldOut then begin
      xTypes := xTypes + 'O';
    end;
    if startupInfoTran or startupInfoOldTran then begin
      xTypes := xTypes + 'T';
    end;
    if startupInfoOldIn or startupInfoOldOut or startupInfoOldTran then begin
      xDf := IncDay(xDf, (-1) * startupInfoOldDays);
    end;
    xSqlPlanned := 'select plannedMovement.*, (select count(*) from plannedDone where plannedDone.idplannedMovement = plannedMovement.idplannedMovement) as doneCount from plannedMovement where isActive = true ';
    if Length(xTypes) = 1 then begin
      xSqlPlanned := xSqlPlanned + Format(' and movementType = ''%s''', [xTypes]);
    end;
    xSqlPlanned := xSqlPlanned + Format(' and (' +
                          '  (scheduleType = ''' + CScheduleTypeOnce + ''' and scheduleDate between %s and %s and (select count(*) from plannedDone where plannedDone.idPlannedMovement = plannedMovement.idPlannedMovement) = 0) or ' +
                          '  (scheduleType = ''' + CScheduleTypeCyclic + ''' and scheduleDate <= %s)' +
                          ' )', [DatetimeToDatabase(xDf, False), DatetimeToDatabase(xDt, False), DatetimeToDatabase(xDt, False), DatetimeToDatabase(xDt, False)]);
    xSqlPlanned := xSqlPlanned + Format(' and (' +
                          '  (endCondition = ''' + CEndConditionNever + ''') or ' +
                          '  (endCondition = ''' + CEndConditionDate + ''' and endDate >= %s) or ' +
                          '  (endCondition = ''' + CEndConditionTimes + ''' and endCount > (select count(*) from plannedDone where plannedDone.idPlannedMovement = plannedMovement.idPlannedMovement)) ' +
                          ' )', [DatetimeToDatabase(xDf, False)]);
    xSqlDone := Format('select * from plannedDone where triggerDate between %s and %s', [DatetimeToDatabase(IncDay(xDf, -3), False), DatetimeToDatabase(IncDay(xDt, 3), False)]);
    FPlannedObjects := TDataObject.GetList(TPlannedMovement, PlannedMovementProxy, xSqlPlanned);
    FDoneObjects := TDataObject.GetList(TPlannedDone, PlannedDoneProxy, xSqlDone);
    GetScheduledObjects(FScheduledObjects, FPlannedObjects, FDoneObjects, xDF, xDT, sosPlanned);
    for xCount := 0 to FScheduledObjects.Count - 1 do begin
      xPlannedTreeItem := TPlannedTreeItem(FScheduledObjects.Items[xCount]);
      if (xPlannedTreeItem.done = Nil) and (xPlannedTreeItem.triggerDate < GWorkDate) then begin
        if xPlannedTreeItem.planned.movementType = CInMovement then begin
          xItemGroup := shgOvertimeIn;
        end else if xPlannedTreeItem.planned.movementType = COutMovement then begin
          xItemGroup := shgOvertimeOut;
        end else begin
          xItemGroup := shgOvertimeTran;
        end;
      end else begin
        if xPlannedTreeItem.planned.movementType = CInMovement then begin
          xItemGroup := shgIntimeIn;
        end else if xPlannedTreeItem.planned.movementType = COutMovement then begin
          xItemGroup := shgIntimeOut;
        end else begin
          xItemGroup := shgIntimeTran;
        end;
      end;
      if ((xItemGroup = shgIntimeIn) and startupInfoIn) or
         ((xItemGroup = shgOvertimeIn) and startupInfoOldIn) or
         ((xItemGroup = shgIntimeOut) and startupInfoOut) or
         ((xItemGroup = shgOvertimeOut) and startupInfoOldOut) or
         ((xItemGroup = shgIntimeTran) and startupInfoTran) or
         ((xItemGroup = shgOvertimeTran) and startupInfoOldTran) then begin
        xGroup := FHelperList.ByGroup(xItemGroup, True);
        xDate := xGroup.childs.ByDate(xPlannedTreeItem.triggerDate, xItemGroup, True);
        if xPlannedTreeItem.done <> Nil then begin
          xCurrencyDef := xPlannedTreeItem.done.idDoneCurrencyDef;
        end else begin
          xCurrencyDef := xPlannedTreeItem.planned.idMovementCurrencyDef;
        end;
        xItem := TStartupHelper.Create(xPlannedTreeItem.triggerDate, xItemGroup, xPlannedTreeItem, shtPlannedItem, xCurrencyDef);
        xDate.childs.Add(xItem);
        xGroup.count := xGroup.count + 1;
        xDate.count := xDate.count + 1;
        if (xGroup.FidCurrencyDef = xCurrencyDef) or (xGroup.FidCurrencyDef = CEmptyDataGid) then begin
          xGroup.sum := xGroup.sum + xPlannedTreeItem.planned.cash;
          xGroup.FidCurrencyDef := xCurrencyDef;
        end else begin
          xGroup.FidCurrencyDef := '*';
        end;
        if (xDate.FidCurrencyDef = xCurrencyDef) or (xDate.FidCurrencyDef = CEmptyDataGid) then begin
          xDate.sum := xDate.sum + xPlannedTreeItem.planned.cash;
          xDate.FidCurrencyDef := xCurrencyDef;
        end else begin
          xDate.FidCurrencyDef := '*';
        end;
      end;
    end;
    if startupInfoSurpassedLimit or startupInfoValidLimits then begin
      FLimitData := TMovementLimit.GetList(TMovementLimit, MovementLimitProxy, 'select * from movementLimit where isActive = true');
      for xCount := 0 to FLimitData.Count - 1 do begin
        xLimit := TMovementLimit(FLimitData.Items[xCount]);
        xAmount := xLimit.GetCurrentAmount(GWorkDate, False);
        xGroup := Nil;
        if xLimit.IsSurpassed(xAmount) then begin
          if startupInfoSurpassedLimit then begin
            xGroup := FHelperList.ByGroup(shgLimit, True);
          end;
        end else begin
          if startupInfoValidLimits then begin
            xGroup := FHelperList.ByGroup(shgLimit, True);
          end;
        end;
        if xGroup <> Nil then begin
          xItem := TStartupHelper.Create(GWorkDate, xGroup.group, xLimit, shtLimit, CEmptyDataGid);
          xItem.sum := xAmount;
          xGroup.count := xGroup.count + 1;
          xGroup.childs.Add(xItem);
        end;
      end;
    end;
    if startupUncheckedExtractions then begin
      FExtractionsData := TAccountExtraction.GetList(TAccountExtraction, AccountExtractionProxy, 'select * from accountExtraction where state <> ''S''');
      for xCount := 0 to FExtractionsData.Count - 1 do begin
        xExtraction := TAccountExtraction(FExtractionsData.Items[xCount]);
        xGroup := FHelperList.ByGroup(shgExtraction, True);
        xItem := TStartupHelper.Create(GWorkDate, xGroup.group, xExtraction, shtExtraction, CEmptyDataGid);
        xItem.sum := 0;
        xGroup.count := xGroup.count + 1;
        xGroup.childs.Add(xItem);
      end;
    end;
  end;
  with RepaymentList do begin
    RootNodeCount := FHelperList.Count;
    EndUpdate;
    PanelError.Visible := RootNodeCount = 0;
    if PanelError.Visible then begin
      Header.Options := Header.Options - [hoVisible];
    end else begin
      Header.Options := Header.Options + [hoVisible];
    end;
  end;
end;

constructor TStartupHelper.Create(ADate: TDateTime; AGroup: TStartupHelperGroup; AItem: TObject; AType: TStartupHelperType; AIdCurrencyDef: TDataGid);
begin
  inherited Create;
  Fdate := ADate;
  Fgroup := AGroup;
  Fitem := AItem;
  FhelperType := AType;
  FidCurrencyDef := AIdCurrencyDef;
  Fchilds := TStartupHelperList.Create(True);
  Fcount := 0;
  Fsum := 0;
end;

destructor TStartupHelper.Destroy;
begin
  Fchilds.Free;
  inherited Destroy;
end;

function TStartupHelperList.ByDate(ADate: TDateTime; AGroup: TStartupHelperGroup; ACanCreate: Boolean): TStartupHelper;
var xCount: Integer;
begin
  Result := Nil;
  xCount := 0;
  while (xCount <= Count - 1) and (Result = Nil) do begin
    if Items[xCount].date = ADate then begin
      Result := Items[xCount];
    end;
    Inc(xCount);
  end;
  if ACanCreate and (Result = Nil) then begin
    Result := TStartupHelper.Create(ADate, AGroup, Nil, shtDate, CEmptyDataGid);
    Add(Result);
  end;
end;

function TStartupHelperList.ByGroup(AGroup: TStartupHelperGroup; ACanCreate: Boolean): TStartupHelper;
var xCount: Integer;
begin
  Result := Nil;
  xCount := 0;
  while (xCount <= Count - 1) and (Result = Nil) do begin
    if Items[xCount].group = AGroup then begin
      Result := Items[xCount];
    end;
    Inc(xCount);
  end;
  if ACanCreate and (Result = Nil) then begin
    Result := TStartupHelper.Create(0, AGroup, Nil, shtGroup, CEmptyDataGid);
    Add(Result);
  end;
end;

function TStartupHelperList.GetItems(AIndex: Integer): TStartupHelper;
begin
  Result := TStartupHelper(inherited Items[AIndex]);
end;

procedure TStartupHelperList.SetItems(AIndex: Integer; const Value: TStartupHelper);
begin
  inherited Items[AIndex] := Value;
end;

procedure TCStartupInfoFrame.RepaymentListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TStartupHelper);
end;

procedure TCStartupInfoFrame.RepaymentListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var xPar: TStartupHelper;
begin
  if ParentNode = Nil then begin
    TStartupHelper(RepaymentList.GetNodeData(Node)^) := TStartupHelper(FHelperList.Items[Node.Index]);
  end else begin
    xPar := TStartupHelper(RepaymentList.GetNodeData(ParentNode)^);
    TStartupHelper(RepaymentList.GetNodeData(Node)^) := TStartupHelper(xPar.childs.Items[Node.Index]);
  end;
  if TStartupHelper(RepaymentList.GetNodeData(Node)^).childs.Count > 0 then begin
    InitialStates := InitialStates + [ivsHasChildren, ivsExpanded];
  end;
end;

procedure TCStartupInfoFrame.RepaymentListInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
begin
  ChildCount := TStartupHelper(RepaymentList.GetNodeData(Node)^).childs.Count;
end;

procedure TCStartupInfoFrame.RepaymentListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var xData: TStartupHelper;
    xSumStr: String;
begin
  CellText := '';
  xData := TStartupHelper(RepaymentList.GetNodeData(Node)^);
  if TextType = ttNormal then begin
    if Column = 0 then begin
      if xData.helperType = shtGroup then begin
        case xData.group of
          shgIntimeIn: CellText := 'Zaplanowane operacje przychodowe';
          shgIntimeOut: CellText := 'Zaplanowane operacje rozchodowe';
          shgIntimeTran: CellText := 'Zaplanowane transfery';
          shgOvertimeIn: CellText := 'Zaleg³e operacje przychodowe';
          shgOvertimeOut: CellText := 'Zaleg³e operacje rozchodowe';
          shgOvertimeTran: CellText := 'Zaleg³e transfery';
          shgLimit: CellText := 'Limity';
          shgExtraction: CellText := 'Nieuzgodnione wyci¹gi';
        end;
      end else if xData.helperType = shtDate then begin
        if xData.date = GWorkDate then begin
          CellText := 'Dzisiaj'
        end else if xData.date = IncDay(GWorkDate) then begin
          CellText := 'Jutro';
        end else begin
          CellText := GetFormattedDate(xData.date, CLongDateFormat);
        end;
      end else if xData.helperType = shtPlannedItem then begin
        CellText := GetDescText(TPlannedTreeItem(xData.item).planned.description);
      end else if xData.helperType = shtLimit then begin
        CellText := TMovementLimit(xData.item).name;
      end else if xData.helperType = shtExtraction then begin
        CellText := TAccountExtraction(xData.item).GetElementText;
      end;
    end else if Column = 1 then begin
      if xData.helperType = shtPlannedItem then begin
        CellText := CurrencyToString(TPlannedTreeItem(xData.item).planned.cash, '', False);
      end else if xData.helperType = shtLimit then begin
        CellText := CurrencyToString(TStartupHelper(xData).sum, '', False);
      end;
    end else if Column = 2 then begin
      if xData.helperType = shtPlannedItem then begin
        CellText := GCurrencyCache.GetSymbol(TPlannedTreeItem(xData.item).planned.idMovementCurrencyDef);
      end else if xData.helperType = shtLimit then begin
        CellText := GCurrencyCache.GetSymbol(TMovementLimit(xData.item).idCurrencyDef);
      end;
    end else if Column = 3 then begin
      if xData.helperType = shtPlannedItem then begin
        if (TPlannedTreeItem(xData.item).planned.movementType = CInMovement) then begin
          CellText := CInMovementDescription;
        end else if (TPlannedTreeItem(xData.item).planned.movementType = COutMovement) then begin
          CellText := COutMovementDescription;
        end else if (TPlannedTreeItem(xData.item).planned.movementType = CTransferMovement) then begin
          CellText := CTransferMovementDescription;
        end;
      end else if xData.helperType = shtLimit then begin
        if TMovementLimit(xData.item).sumType = CLimitSumtypeOut then begin
          CellText := CLimitSumtypeOutDescription;
        end else if TMovementLimit(xData.item).sumType = CLimitSumtypeOut then begin
          CellText := CLimitSumtypeInDescription;
        end else begin
          CellText := CLimitSumtypeBalanceDescription;
        end;
      end;
    end else if Column = 4 then begin
      if xData.helperType = shtPlannedItem then begin
        if (TPlannedTreeItem(xData.item).done <> Nil) then begin
          if (TPlannedTreeItem(xData.item).done.doneState = CDoneOperation) then begin
            CellText := CPlannedDoneDescription;
          end else if (TPlannedTreeItem(xData.item).done.doneState = CDoneDeleted) then begin
            CellText := CPlannedRejectedDescription;
          end else if (TPlannedTreeItem(xData.item).done.doneState = CDoneAccepted) then begin
            CellText := CPlannedAcceptedDescription;
          end;
        end else begin
          if TPlannedTreeItem(xData.item).triggerDate = GWorkDate then begin
            CellText := CPlannedScheduledTodayDescription;
          end else if TPlannedTreeItem(xData.item).triggerDate > GWorkDate then begin
            CellText := CPlannedScheduledReady;
          end else begin
            CellText := CPlannedScheduledOvertime;
          end;
        end;
      end else if xData.helperType = shtLimit then begin
        if xData.group = shgLimit then begin
          if TMovementLimit(xData.item).IsSurpassed(xData.sum) then begin
            CellText := CLimitSupressedDesc;
          end else begin
            CellText := CLimitValidDesc;
          end;
        end;
      end else if xData.helperType = shtExtraction then begin
        if xData.group = shgExtraction then begin
          if TAccountExtraction(xData.item).extractionState = CExtractionStateOpen then begin
            CellText := CExtractionStateOpenDescription;
          end else begin
            CellText := CExtractionStateCloseDescription;
          end;
        end;
      end;
    end;
  end else begin
    if (xData.helperType = shtGroup) and (Column = 0) then begin
      if xData.group = shgLimit then begin
        CellText := '(razem ' + IntToStr(xData.count) + ')';
      end else if xData.group = shgExtraction then begin
        CellText := '(razem ' + IntToStr(xData.count) + ')';
      end else begin
        if xData.FidCurrencyDef = '*' then begin
          xSumStr := ', operacje wielowalutowe';
        end else begin
          xSumStr := ', na kwotê ' + CurrencyToString(xData.sum, xData.FidCurrencyDef);
        end;
        CellText := '(razem ' + IntToStr(xData.count) + xSumStr + ')';
      end;
    end;
  end;
end;

procedure TCStartupInfoFrame.InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean);
begin
  inherited InitializeFrame(AOwner, AAdditionalData, AOutputData, AMultipleCheck, AWithButtons);
  FPlannedObjects := Nil;
  FDoneObjects := Nil;
  FScheduledObjects := TObjectList.Create(True);
  FHelperList := TStartupHelperList.Create(True);
  ReloadInfoTree;  
end;

class function TCStartupInfoFrame.GetTitle: String;
begin
  Result := 'Powiadomienia na dziœ';
end;

class function TCStartupInfoFrame.GetOperation: TConfigOperation;
begin
  Result := coNone;
end;

class function TCStartupInfoFrame.GetPrefname: String;
begin
  Result := 'startupInfo';
end;

function TCStartupInfoFrame.GetList: TCList;
begin
  Result := RepaymentList;
end;

procedure TCStartupInfoFrame.RepaymentListGetImageIndexEx(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer; var ImageList: TCustomImageList);
var xData: TStartupHelper;
    xBase: TPlannedTreeItem;
begin
  ImageList := CImageLists.DoneImageList16x16;
  xData := TStartupHelper(RepaymentList.GetNodeData(Node)^);
  if Column = 3 then begin
    if xData.helperType = shtPlannedItem then begin
      if TPlannedTreeItem(xData.item).planned.movementType = CInMovement then begin
        ImageIndex := 0;
      end else if TPlannedTreeItem(xData.item).planned.movementType = COutMovement then begin
        ImageIndex := 1;
      end else if TPlannedTreeItem(xData.item).planned.movementType = CTransferMovement then begin
        ImageIndex := 10;
      end;
    end else if xData.helperType = shtLimit then begin
      if TMovementLimit(xData.item).sumType = CLimitSumtypeOut then begin
        ImageIndex := 1;
      end else if TMovementLimit(xData.item).sumType = CLimitSumtypeIn then begin
        ImageIndex := 0;
      end else begin
        ImageIndex := 7;
      end;
    end;
  end else if Column = 4 then begin
    if xData.helperType = shtPlannedItem then begin
      xBase := TPlannedTreeItem(xData.item);
      if (xBase.done <> Nil) then begin
        if (xBase.done.doneState = CDoneOperation) then begin
          ImageIndex := 2;
        end else if (xBase.done.doneState = CDoneDeleted) then begin
          ImageIndex := 6;
        end else if (xBase.done.doneState = CDoneAccepted) then begin
          ImageIndex := 2;
        end;
      end else begin
        if xBase.triggerDate = GWorkDate then begin
          ImageIndex := 3;
        end else if xBase.triggerDate > GWorkDate then begin
          ImageIndex := 5;
        end else begin
          ImageIndex := 4;
        end;
      end;
    end else if xData.helperType = shtLimit then begin
      if TMovementLimit(xData.item).IsSurpassed(xData.sum) then begin
        ImageIndex := 4;
      end else begin
        ImageIndex := 2;
      end;
    end else if xData.helperType = shtExtraction then begin
      if TAccountExtraction(xData.item).extractionState = CExtractionStateOpen then begin
        ImageIndex := 8;
      end else begin
        ImageIndex := 9;
      end;
    end;
  end;
end;

class function TCStartupInfoFrame.GetDataobjectClass(AOption: Integer): TDataObjectClass;
begin
  Result := Nil;
end;

class function TCStartupInfoFrame.GetDataobjectProxy(AOption: Integer): TDataProxy;
begin
  Result := Nil;
end;

procedure TCStartupInfoFrame.RepaymentListGetRowPreferencesName(AHelper: TObject; var APrefname: String);
var xHelper: TStartupHelper;
begin
  xHelper := TStartupHelper(AHelper);
  if xHelper.helperType = shtGroup then begin
    APrefname := 'TT';
  end else if xHelper.helperType = shtDate then begin
    APrefname := 'DD';
  end else if xHelper.helperType = shtExtraction then begin
    APrefname := 'UE';
  end else if xHelper.helperType = shtLimit then begin
    if TMovementLimit(xHelper.item).IsSurpassed(xHelper.sum) then begin
      APrefname := 'SL';
    end else begin
      APrefname := 'VL';
    end;
  end else begin
    if TPlannedTreeItem(xHelper.item).triggerDate < GWorkDate then begin
      APrefname := 'O';
    end else begin
      APrefname := 'I';
    end;
    APrefname := APrefname + TPlannedTreeItem(xHelper.item).planned.movementType;
  end;
end;

end.

