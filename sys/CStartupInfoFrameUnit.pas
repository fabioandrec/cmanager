unit CStartupInfoFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, Menus, ImgList, PngImageList, VirtualTrees, CDatabase,
  CSchedules, Contnrs, ExtCtrls, GraphUtil, CConfigFormUnit;

type
  TStartupHelperType = (shtGroup, shtDate, shtItem);
  TStartupHelperGroup = (shgIntimeIn, shgIntimeOut, shgOvertimeIn, shgOvertimeOut);
  TStartupHelperList = class;
  TStartupHelper = class;

  TCStartupInfoFrame = class(TCBaseFrame)
    RepaymentList: TVirtualStringTree;
    PanelError: TPanel;
    procedure RepaymentListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure RepaymentListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure RepaymentListInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
    procedure RepaymentListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure RepaymentListPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
    procedure RepaymentListBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
  private
    FPlannedObjects: TDataObjectList;
    FDoneObjects: TDataObjectList;
    FScheduledObjects: TObjectList;
    FHelperList: TStartupHelperList;
    procedure FindFontAndBackground(AHelper: TStartupHelper; AFont: TFont; var ABackground: TColor);
  public
    procedure ReloadInfoTree;
    destructor Destroy; override;
    procedure InitializeFrame(AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList); override;
    class function GetTitle: String; override;
    class function GetOperation: TConfigOperation; override;
    class function GetPrefname: String; override;
    function GetList: TVirtualStringTree; override;
  end;

  TStartupHelper = class(TObject)
  private
    FhelperType: TStartupHelperType;
    Fdate: TDateTime;
    Fgroup: TStartupHelperGroup;
    FplannedCount: Integer;
    FplannedSum: Currency;
    Fchilds: TStartupHelperList;
    Fitem: TPlannedTreeItem;
  public
    constructor Create(ADate: TDateTime; AGroup: TStartupHelperGroup; AItem: TPlannedTreeItem; AType: TStartupHelperType);
    property childs: TStartupHelperList read Fchilds write Fchilds;
    property helperType: TStartupHelperType read FhelperType write FhelperType;
    property group: TStartupHelperGroup read Fgroup write Fgroup;
    property date: TDateTime read Fdate write Fdate;
    property item: TPlannedTreeItem read Fitem write Fitem;
    property plannedCount: Integer read FplannedCount write FplannedCount;
    property plannedSum: Currency read FplannedSum write FplannedSum;
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

uses CPreferences, CConsts, DateUtils, CDataObjects;

{$R *.dfm}

destructor TCStartupInfoFrame.Destroy;
begin
  FreeAndNil(FPlannedObjects);
  FreeAndNil(FDoneObjects);
  FreeAndNil(FScheduledObjects);
  FreeAndNil(FHelperList);
  inherited Destroy;
end;

procedure TCStartupInfoFrame.ReloadInfoTree;
var xDf, xDt: TDateTime;
    xTypes: String;
    xSqlPlanned, xSqlDone: String;
    xCount: Integer;
    xPlannedTreeItem: TPlannedTreeItem;
    xItemGroup: TStartupHelperGroup;
    xGroup: TStartupHelper;
    xDate: TStartupHelper;
    xItem: TStartupHelper;
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
    if startupInfoOldIn or startupInfoOldOut then begin
      xDf := IncDay(xDf, (-1) * DaysInMonth(xDf));
    end;
    xSqlPlanned := 'select plannedMovement.*, (select count(*) from plannedDone where plannedDone.idplannedMovement = plannedMovement.idplannedMovement) as doneCount from plannedMovement where isActive = true ';
    if Length(xTypes) = 1 then begin
      xSqlPlanned := xSqlPlanned + Format(' and movementType = ''%s''', [xTypes]);
    end;
    xSqlPlanned := xSqlPlanned + Format(' and (' +
                          '  (scheduleType = ''O'' and scheduleDate between %s and %s and (select count(*) from plannedDone where plannedDone.idPlannedMovement = plannedMovement.idPlannedMovement) = 0) or ' +
                          '  (scheduleType = ''C'' and scheduleDate <= %s)' +
                          ' )', [DatetimeToDatabase(xDf, False), DatetimeToDatabase(xDt, False), DatetimeToDatabase(xDt, False)]);
    xSqlPlanned := xSqlPlanned + Format(' and (' +
                          '  (endCondition = ''N'') or ' +
                          '  (endCondition = ''D'' and endDate >= %s) or ' +
                          '  (endCondition = ''T'' and endCount > (select count(*) from plannedDone where plannedDone.idPlannedMovement = plannedMovement.idPlannedMovement)) ' +
                          ' )', [DatetimeToDatabase(xDf, False)]);
    xSqlDone := Format('select * from plannedDone where triggerDate between %s and %s', [DatetimeToDatabase(xDf, False), DatetimeToDatabase(xDt, False)]);
    FPlannedObjects := TDataObject.GetList(TPlannedMovement, PlannedMovementProxy, xSqlPlanned);
    FDoneObjects := TDataObject.GetList(TPlannedDone, PlannedDoneProxy, xSqlDone);
    GetScheduledObjects(FScheduledObjects, FPlannedObjects, FDoneObjects, xDF, xDT, sosBoth);
    for xCount := 0 to FScheduledObjects.Count - 1 do begin
      xPlannedTreeItem := TPlannedTreeItem(FScheduledObjects.Items[xCount]);
      if (xPlannedTreeItem.done = Nil) and (xPlannedTreeItem.triggerDate < GWorkDate) then begin
        if xPlannedTreeItem.planned.movementType = CInMovement then begin
          xItemGroup := shgOvertimeIn;
        end else begin
          xItemGroup := shgOvertimeOut;
        end;
      end else begin
        if xPlannedTreeItem.planned.movementType = CInMovement then begin
          xItemGroup := shgIntimeIn;
        end else begin
          xItemGroup := shgIntimeOut;
        end;
      end;
      if ((xItemGroup = shgIntimeIn) and startupInfoIn) or
         ((xItemGroup = shgOvertimeIn) and startupInfoOldIn) or
         ((xItemGroup = shgIntimeOut) and startupInfoOut) or
         ((xItemGroup = shgOvertimeOut) and startupInfoOldOut) then begin
        xGroup := FHelperList.ByGroup(xItemGroup, True);
        xDate := xGroup.childs.ByDate(xPlannedTreeItem.triggerDate, xItemGroup, True);
        xItem := TStartupHelper.Create(xPlannedTreeItem.triggerDate, xItemGroup, xPlannedTreeItem, shtItem);
        xDate.childs.Add(xItem);
        xGroup.plannedCount := xGroup.plannedCount + 1;
        xGroup.plannedSum := xGroup.plannedSum + xPlannedTreeItem.planned.cash;
        xDate.plannedCount := xDate.plannedCount + 1;
        xDate.plannedSum := xDate.plannedSum + xPlannedTreeItem.planned.cash;
      end;
    end;
  end;
  RepaymentList.RootNodeCount := FHelperList.Count;
  RepaymentList.EndUpdate;
  PanelError.Visible := RepaymentList.RootNodeCount = 0;
end;

constructor TStartupHelper.Create(ADate: TDateTime; AGroup: TStartupHelperGroup; AItem: TPlannedTreeItem; AType: TStartupHelperType);
begin
  inherited Create;
  Fdate := ADate;
  Fgroup := AGroup;
  Fitem := AItem;
  FhelperType := AType;
  Fchilds := TStartupHelperList.Create(True);
  FplannedCount := 0;
  FplannedSum := 0;
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
    Result := TStartupHelper.Create(ADate, AGroup, Nil, shtDate);
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
    Result := TStartupHelper.Create(0, AGroup, Nil, shtGroup);
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
begin
  CellText := '';
  xData := TStartupHelper(RepaymentList.GetNodeData(Node)^);
  if TextType = ttNormal then begin
    if Column = 0 then begin
      if xData.helperType = shtGroup then begin
        case xData.group of
          shgIntimeIn: CellText := 'Zaplanowane operacje przychodowe';
          shgIntimeOut: CellText := 'Zaplanowane operacje rozchodowe';
          shgOvertimeIn: CellText := 'Zaleg³e operacje przychodowe';
          shgOvertimeOut: CellText := 'Zaleg³e operacje rozchodowe';
        end;
      end else if xData.helperType = shtDate then begin
        if xData.date = GWorkDate then begin
          CellText := 'Dzisiaj'
        end else if xData.date = IncDay(GWorkDate) then begin
          CellText := 'Jutro';
        end else begin
          CellText := GetFormattedDate(xData.date, CLongDateFormat);
        end;
      end else if xData.helperType = shtItem then begin
        CellText := xData.item.planned.description;
      end;
    end else if Column = 1 then begin
      if xData.helperType = shtItem then begin
        CellText := CurrencyToString(xData.item.planned.cash);
      end;
    end;
  end else begin
    if (xData.helperType = shtGroup) and (Column = 0) then begin
      CellText := '(razem ' + IntToStr(xData.plannedCount) + ', na kwotê ' + CurrencyToString(xData.plannedSum) + ')';
    end;
  end;
end;

procedure TCStartupInfoFrame.RepaymentListPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
var xData: TStartupHelper;
    xColor: TColor;
begin
  xData := TStartupHelper(RepaymentList.GetNodeData(Node)^);
  FindFontAndBackground(xData, TargetCanvas.Font, xColor);
end;

procedure TCStartupInfoFrame.RepaymentListBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
begin
  with TargetCanvas do begin
    if not Odd(Sender.AbsoluteIndex(Node)) then begin
      ItemColor := clWindow;
    end else begin
      ItemColor := GetHighLightColor(clWindow, -10);
    end;
    EraseAction := eaColor;
  end;
end;

procedure TCStartupInfoFrame.InitializeFrame(AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList);
begin
  inherited InitializeFrame(AAdditionalData, AOutputData, AMultipleCheck);
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

function TCStartupInfoFrame.GetList: TVirtualStringTree;
begin
  Result := RepaymentList;
end;

procedure TCStartupInfoFrame.FindFontAndBackground(AHelper: TStartupHelper; AFont: TFont; var ABackground: TColor);
var xKey: String;
    xPref: TFontPref;
begin
  if AHelper.helperType = shtGroup then begin
    xKey := 'TT';
  end else if AHelper.helperType = shtDate then begin
    xKey := 'DD';
  end else begin
    if AHelper.item.triggerDate < GWorkDate then begin
      xKey := 'O';
    end else begin
      xKey := 'I';
    end;
    xKey := xKey + AHelper.item.planned.movementType;
  end;
  xPref := TFontPref(TViewPref(GViewsPreferences.ByPrefname['startupInfo']).Fontprefs.ByPrefname[xKey]);
  if xPref <> Nil then begin
    ABackground := xPref.Background;
    if AFont <> Nil then begin
      AFont.Assign(xPref.Font);
    end;
  end;
end;

end.

