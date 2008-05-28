unit CDoneFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, ImgList, StdCtrls, ExtCtrls, VirtualTrees,
  ActnList, CComponents, CDatabase, Menus, VTHeaderPopup, GraphUtil, AdoDb,
  Contnrs, CDataObjects, PngImageList, CImageListsUnit, CSchedules, CPreferences,
  Buttons;

type
  TDoneFrameAdditionalData = class
  private
    FmovementType: TBaseEnumeration;
  public
    constructor Create(AMovementType: TBaseEnumeration);
  published
    property movementType: TBaseEnumeration read FmovementType;
  end;

  TCDoneFrame = class(TCBaseFrame)
    PanelFrameButtons: TPanel;
    DoneList: TCList;
    ActionList: TActionList;
    VTHeaderPopupMenu: TVTHeaderPopupMenu;
    Panel: TPanel;
    CStaticFilter: TCStatic;
    Panel2: TPanel;
    Splitter1: TSplitter;
    SumList: TCList;
    Label2: TLabel;
    Label1: TLabel;
    CStaticPeriod: TCStatic;
    Label3: TLabel;
    CDateTimePerStart: TCDateTime;
    Label4: TLabel;
    CDateTimePerEnd: TCDateTime;
    Label5: TLabel;
    ActionOperation: TAction;
    Panel1: TPanel;
    CButtonsStatus: TCButton;
    Bevel: TBevel;
    ActionDooperation: TAction;
    CButtonOperation: TCButton;
    CButtonPlanned: TCButton;
    ActionPlanned: TAction;
    PopupMenuSums: TPopupMenu;
    Ustawienialisty2: TMenuItem;
    PopupMenuIcons: TPopupMenu;
    MenuItemBigIcons: TMenuItem;
    MenuItemSmallIcons: TMenuItem;
    MenuItemsumsVisible: TMenuItem;
    SpeedButtonCloseShortcuts: TSpeedButton;
    procedure DoneListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure DoneListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure DoneListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure DoneListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure DoneListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
    procedure CStaticFilterGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticFilterChanged(Sender: TObject);
    procedure SumListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure SumListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure SumListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure SumListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure CStaticPeriodGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CDateTimePerStartChanged(Sender: TObject);
    procedure DoneListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure ActionOperationExecute(Sender: TObject);
    procedure DoneListDblClick(Sender: TObject);
    procedure ActionDooperationExecute(Sender: TObject);
    procedure DoneListGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
    procedure SumListInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
    procedure ActionPlannedExecute(Sender: TObject);
    procedure Ustawienialisty2Click(Sender: TObject);
    procedure DoneListGetRowPreferencesName(AHelper: TObject; var APrefname: String);
    procedure MenuItemBigIconsClick(Sender: TObject);
    procedure MenuItemSmallIconsClick(Sender: TObject);
    procedure MenuItemsumsVisibleClick(Sender: TObject);
    procedure SpeedButtonCloseShortcutsClick(Sender: TObject);
  private
    FSmallIconsButtonsImageList: TPngImageList;
    FBigIconsButtonsImageList: TPngImageList;
    FPlannedObjects: TDataObjectList;
    FDoneObjects: TDataObjectList;
    FSumRoot: TSumElement;
    FTreeObjects: TObjectList;
    procedure UpdateCustomPeriod;
    procedure UpdateIcons;
  protected
    procedure WndProc(var Message: TMessage); override;
    procedure GetFilterDates(var ADateFrom, ADateTo: TDateTime);
    function GetSelectedId: ShortString; override;
    function GetSelectedText: String; override;
    function IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean; override;
    function GetSelectedType: Integer; override;
    procedure DoRepaintLists; override;
    procedure UpdateSumList;
  public
    procedure LoadFramePreferences; override;
    procedure SaveFramePreferences; override;
    function GetList: TCList; override;
    procedure ReloadDone;
    procedure ReloadSums;
    procedure RecreateTreeHelper;
    constructor Create(AOwner: TComponent); override;
    procedure InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean); override;
    destructor Destroy; override;
    class function GetTitle: String; override;
    function IsValidFilteredObject(AObject: TDataObject): Boolean; override;
    function FindNode(ADataId: ShortString; AList: TCList): PVirtualNode; override;
    class function GetPrefname: String; override;
  end;

implementation

uses CFrameFormUnit, CConfigFormUnit, CDataobjectFormUnit,
  DateUtils, CListFrameUnit, DB, CMovementFormUnit,
  Math, CDoneFormUnit, CConsts, CTools,
  CPluginConsts, CPlannedFrameUnit, CListPreferencesFormUnit, CDatatools;

{$R *.dfm}

constructor TCDoneFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPlannedObjects := Nil;
  FDoneObjects := Nil;
  FSumRoot := TSumElement.Create;
  FTreeObjects := TObjectList.Create(True);
end;

procedure TCDoneFrame.ReloadDone;
var xSqlPlanned, xSqlDone: String;
    xDf, xDt: TDateTime;
begin
  DoneList.BeginUpdate;
  DoneList.Clear;
  xSqlPlanned := 'select plannedMovement.*, (select count(*) from plannedDone where plannedDone.idplannedMovement = plannedMovement.idplannedMovement) as doneCount from plannedMovement where isActive = true ';
  if CStaticFilter.DataId = '2' then begin
    xSqlPlanned := xSqlPlanned + Format(' and movementType = ''%s''', [COutMovement]);
  end else if CStaticFilter.DataId = '3' then begin
    xSqlPlanned := xSqlPlanned + Format(' and movementType = ''%s''', [CInMovement]);
  end else if CStaticFilter.DataId = '4' then begin
    xSqlPlanned := xSqlPlanned + Format(' and movementType = ''%s''', [CTransferMovement]);
  end;
  GetFilterDates(xDf, xDt);
  xSqlPlanned := xSqlPlanned + Format(' and (' +
                        '  (scheduleType = ''%s'' and scheduleDate between %s and %s and (select count(*) from plannedDone where plannedDone.idPlannedMovement = plannedMovement.idPlannedMovement) = 0) or ' +
                        '  (scheduleType = ''%s'' and scheduleDate <= %s)' +
                        ' )', [CScheduleTypeOnce, DatetimeToDatabase(xDf, False), DatetimeToDatabase(xDt, False),
                               CScheduleTypeCyclic, DatetimeToDatabase(xDt, False)]);
  xSqlPlanned := xSqlPlanned + Format(' and (' +
                        '  (endCondition = ''%s'') or ' +
                        '  (endCondition = ''%s'' and endDate >= %s) or ' +
                        '  (endCondition = ''%s'' and endCount > (select count(*) from plannedDone where plannedDone.idPlannedMovement = plannedMovement.idPlannedMovement)) ' +
                        ' )', [CEndConditionNever, CEndConditionDate, DatetimeToDatabase(xDf, False), CEndConditionTimes]);
  xSqlDone := Format('select * from plannedDone where triggerDate between %s and %s', [DatetimeToDatabase(IncDay(xDf, -3), False), DatetimeToDatabase(IncDay(xDt, 3), False)]);
  if FPlannedObjects <> Nil then begin
    FreeAndNil(FPlannedObjects);
  end;
  if FDoneObjects <> Nil then begin
    FreeAndNil(FDoneObjects);
  end;
  FPlannedObjects := TDataObject.GetList(TPlannedMovement, PlannedMovementProxy, xSqlPlanned);
  FDoneObjects := TDataObject.GetList(TPlannedDone, PlannedDoneProxy, xSqlDone);
  RecreateTreeHelper;
  DoneList.RootNodeCount := FTreeObjects.Count;
  DoneList.EndUpdate;
  ReloadSums;
  DoneListFocusChanged(DoneList, DoneList.FocusedNode, 0);
end;

procedure TCDoneFrame.InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean);
var xDf, xDe: TDateTime;
begin
  inherited InitializeFrame(AOwner, AAdditionalData, AOutputData, AMultipleCheck, AWithButtons);
  FSmallIconsButtonsImageList := Nil;
  FBigIconsButtonsImageList := TPngImageList(ActionList.Images);
  UpdateCustomPeriod;
  GetFilterDates(xDf, xDe);
  CDateTimePerStart.Value := xDf;
  CDateTimePerEnd.Value := xDe;
  Label3.Anchors := [akRight, akTop];
  CDateTimePerStart.Anchors := [akRight, akTop];
  Label4.Anchors := [akRight, akTop];
  CDateTimePerEnd.Anchors := [akRight, akTop];
  Label5.Anchors := [akRight, akTop];
  if AAdditionalData <> Nil then begin
    PanelFrameButtons.Visible := False;
    MenuItemsumsVisible.Visible := False;
    Splitter1.Visible := False;
    CStaticFilter.HotTrack := False;
    if TDoneFrameAdditionalData(AAdditionalData).movementType = COutMovement then begin
      CStaticFilter.DataId := '2';
      CStaticFilter.Caption := '<rozchód>';
    end else if TDoneFrameAdditionalData(AAdditionalData).movementType = CInMovement then begin
      CStaticFilter.DataId := '3';
      CStaticFilter.Caption := '<przychód>';
    end else if TDoneFrameAdditionalData(AAdditionalData).movementType = CTransferMovement then begin
      CStaticFilter.DataId := '4';
      CStaticFilter.Caption := '<transfer>';
    end;
  end;
  SumList.ViewPref := TViewPref(GViewsPreferences.ByPrefname[CFontPreferencesDoneListSum]);
  if List.ViewPref <> Nil then begin
    MenuItemSmallIcons.Checked := List.ViewPref.ButtonSmall;
    UpdateIcons;
  end;
  ReloadDone;
  if not AWithButtons then begin
    Bevel.Visible := False;
    Panel1.Visible := False;
  end;
  DoneListFocusChanged(DoneList, DoneList.FocusedNode, 0)
end;

destructor TCDoneFrame.Destroy;
begin
  if FSmallIconsButtonsImageList <> Nil then begin
    FSmallIconsButtonsImageList.Free;
  end;
  FPlannedObjects.Free;
  FDoneObjects.Free;
  FSumRoot.Free;
  FTreeObjects.Free;
  inherited Destroy;
end;

procedure TCDoneFrame.DoneListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  TPlannedTreeItem(DoneList.GetNodeData(Node)^) := TPlannedTreeItem(FTreeObjects.Items[Node.Index]);
  if MultipleChecks <> Nil then begin
    Node.CheckType := ctCheckBox;
    Node.CheckState := csCheckedNormal;
  end;
end;

procedure TCDoneFrame.DoneListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TPlannedTreeItem);
end;

procedure TCDoneFrame.DoneListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var xData: TPlannedTreeItem;
begin
  xData := TPlannedTreeItem(DoneList.GetNodeData(Node)^);
  if Column = 0 then begin
    CellText := IntToStr(Node.Index + 1);
  end else if Column = 1 then begin
    if xData.done = Nil then begin
      CellText := GetDescText(xData.planned.description);
    end else begin
      CellText := GetDescText(xData.done.description);
    end;
  end else if Column = 2 then begin
    CellText := Date2StrDate(xData.triggerDate);
  end else if Column = 3 then begin
    if xData.done = Nil then begin
      CellText := CurrencyToString(xData.planned.cash, '', False);
    end else begin
      CellText := CurrencyToString(xData.done.cash, '', False);
    end;
  end else if Column = 4 then begin
    if (xData.planned.movementType = CInMovement) then begin
      CellText := CInMovementDescription;
    end else if (xData.planned.movementType = COutMovement) then begin
      CellText := COutMovementDescription;
    end else if (xData.planned.movementType = CTransferMovement) then begin
      CellText := CTransferMovementDescription;
    end;
  end else if Column = 5 then begin
    if (xData.done <> Nil) then begin
      if (xData.done.doneState = CDoneOperation) then begin
        CellText := CPlannedDoneDescription;
      end else if (xData.done.doneState = CDoneDeleted) then begin
        CellText := CPlannedRejectedDescription;
      end else if (xData.done.doneState = CDoneAccepted) then begin
        CellText := CPlannedAcceptedDescription;
      end;
    end else begin
      if xData.triggerDate = GWorkDate then begin
        CellText := CPlannedScheduledTodayDescription;
      end else if xData.triggerDate > GWorkDate then begin
        CellText := CPlannedScheduledReady;
      end else begin
        CellText := CPlannedScheduledOvertime;
      end;
    end;
  end else if Column = 6 then begin
    if xData.done = Nil then begin
      CellText := GCurrencyCache.GetSymbol(xData.planned.idMovementCurrencyDef);
    end else begin
      CellText := GCurrencyCache.GetSymbol(xData.done.idDoneCurrencyDef);
    end;
  end else if Column = 7 then begin
    if xData.done <> Nil then begin
      CellText := Date2StrDate(xData.done.doneDate);
    end else begin
      CellText := '';
    end;
  end;
end;

procedure TCDoneFrame.DoneListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var xData1: TPlannedTreeItem;
    xData2: TPlannedTreeItem;
begin
  xData1 := TPlannedTreeItem(DoneList.GetNodeData(Node1)^);
  xData2 := TPlannedTreeItem(DoneList.GetNodeData(Node2)^);
  if Column = 0 then begin
    if Node1.Index > Node2.Index then begin
      Result := 1;
    end else if Node1.Index < Node2.Index then begin
      Result := -1;
    end else begin
      Result := 0;
    end;
  end else if Column = 1 then begin
    Result := AnsiCompareText(xData1.planned.description, xData2.planned.description);
  end else if Column = 2 then begin
    if xData1.triggerDate > xData2.triggerDate then begin
      Result := 1;
    end else if xData1.triggerDate < xData2.triggerDate then begin
      Result := -1;
    end else begin
      Result := 0;
    end;
  end else if Column = 3 then begin
    if xData1.planned.cash > xData2.planned.cash then begin
      Result := 1;
    end else if xData1.planned.cash < xData2.planned.cash then begin
      Result := -1;
    end else begin
      Result := 0;
    end;
  end else if Column = 4 then begin
    Result := AnsiCompareText(xData1.planned.movementType, xData2.planned.movementType);
  end;
end;

procedure TCDoneFrame.DoneListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
var xData: TPlannedTreeItem;
begin
  xData := TPlannedTreeItem(DoneList.GetNodeData(Node)^);
  HintText := xData.planned.description;
  LineBreakStyle := hlbForceMultiLine;
end;

function TCDoneFrame.GetList: TCList;
begin
  Result := DoneList;
end;

procedure TCDoneFrame.WndProc(var Message: TMessage);
begin
  inherited WndProc(Message);
  with Message do begin
    if Msg = WM_DATAREFRESH then begin
      ReloadDone;
    end;
  end;
end;

class function TCDoneFrame.GetTitle: String;
begin
  Result := 'Operacje zaplanowane';
end;

function TCDoneFrame.IsValidFilteredObject(AObject: TDataObject): Boolean;
var xOt, xFt: String;
    xDf, xDt: TDateTime;
begin
  xOt := TPlannedTreeItem(AObject).planned.movementType;
  if CStaticFilter.DataId = '2' then begin
    xFt := COutMovement;
  end else if CStaticFilter.DataId = '3' then begin
    xFt := CInMovement;
  end else if CStaticFilter.DataId = '4' then begin
    xFt := CTransferMovement;
  end else begin
    xFt := '';
  end;
  Result := (Pos(xOt, xFt) > 0) or (xFt = '');
  if Result then begin
    GetFilterDates(xDf, xDt);
    Result := (xDf <= TPlannedTreeItem(AObject).triggerDate) and (TPlannedTreeItem(AObject).triggerDate <= xDt);
  end;
end;

procedure TCDoneFrame.CStaticFilterGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
var xList: TStringList;
    xGid, xText: String;
    xRect: TRect;
begin
  xList := TStringList.Create;
  xList.Add('1=<dowolny typ>');
  xList.Add('2=<rozchód>');
  xList.Add('3=<przychód>');
  xList.Add('4=<transfer>');
  xGid := CEmptyDataGid;
  xText := '';
  xRect := Rect(10, 10, 200, 300);
  AAccepted := TCFrameForm.ShowFrame(TCListFrame, xGid, xText, xList, @xRect);
  if AAccepted then begin
    ADataGid := xGid;
    AText := xText;
  end;
end;

procedure TCDoneFrame.CStaticFilterChanged(Sender: TObject);
begin
  UpdateCustomPeriod;
  ReloadDone;
end;

procedure TCDoneFrame.SumListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var xData1: TSumElement;
    xData2: TSumElement;
begin
  xData1 := TSumElement(SumList.GetNodeData(Node1)^);
  xData2 := TSumElement(SumList.GetNodeData(Node2)^);
  if (xData1.id = '*') then begin
    if TCList(Sender).Header.SortDirection = sdAscending then begin
      Result := -1;
    end else begin
      Result := 1;
    end;
  end else if (xData2.id = '*') then begin
    if TCList(Sender).Header.SortDirection = sdAscending then begin
      Result := 1;
    end else begin
      Result := -1;
    end;
  end else begin
    if Column = 0 then begin
      Result := AnsiCompareText(xData1.name, xData2.name);
    end else if Column = 1 then begin
      if xData1.cashOut > xData2.cashOut then begin
        Result := 1;
      end else if xData1.cashOut < xData2.cashOut then begin
        Result := -1;
      end else begin
        Result := 0;
      end;
    end else if Column = 2 then begin
      if xData1.cashIn > xData2.cashIn then begin
        Result := 1;
      end else if xData1.cashIn < xData2.cashIn then begin
        Result := -1;
      end else begin
        Result := 0;
      end;
    end else if Column = 3 then begin
      if (xData1.cashIn - xData1.cashOut) > (xData2.cashIn - xData2.cashOut) then begin
        Result := 1;
      end else if (xData1.cashIn - xData1.cashOut) < (xData2.cashIn - xData2.cashOut) then begin
        Result := -1;
      end else begin
        Result := 0;
      end;
    end;
  end;
end;

procedure TCDoneFrame.SumListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TSumElement);
end;

procedure TCDoneFrame.SumListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var xData: TSumElement;
begin
  xData := TSumElement(SumList.GetNodeData(Node)^);
  if Column = 0 then begin
    CellText := xData.name;
  end else if Column = 1 then begin
    CellText := CurrencyToString(xData.cashOut, '', False);
  end else if Column = 2 then begin
    CellText := CurrencyToString(xData.cashIn, '', False);
  end else if Column = 3 then begin
    CellText := CurrencyToString(xData.cashIn - xData.cashOut, '', False);
  end else if Column = 4 then begin
    CellText := GCurrencyCache.GetSymbol(xData.idCurrencyDef);
  end;
end;

procedure TCDoneFrame.SumListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var xDate: TSumElement;
begin
  if ParentNode = Nil then begin
    TSumElement(SumList.GetNodeData(Node)^) := TSumElement(FSumRoot.childs.Items[Node.Index]);
  end else begin
    xDate := TSumElement(SumList.GetNodeData(ParentNode)^);
    TSumElement(SumList.GetNodeData(Node)^) := TSumElement(xDate.childs.Items[Node.Index]);
  end;
  if TSumElement(SumList.GetNodeData(Node)^).childs.Count > 0 then begin
    InitialStates := InitialStates + [ivsHasChildren];
  end;
end;

procedure TCDoneFrame.CStaticPeriodGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
var xList: TStringList;
    xGid, xText: String;
    xRect: TRect;
begin
  xList := TStringList.Create;
  xList.Add('1=<tylko dziœ>');
  xList.Add('2=<w tym tygodniu>');
  xList.Add('3=<w tym miesi¹cu>');
  xList.Add('15=<w tym roku>');
  xList.Add('4=<ostatnie 7 dni>');
  xList.Add('5=<ostatnie 14 dni>');
  xList.Add('6=<ostatnie 30 dni>');
  xList.Add('13=<od pocz¹tku roku>');
  xList.Add('7=<w przysz³ym tygodni>');
  xList.Add('8=<w przysz³ym miesi¹cu>');
  xList.Add('9=<nastêpne 7 dni>');
  xList.Add('10=<nastêpne 14 dni>');
  xList.Add('11=<nastêpne 30 dni>');
  xList.Add('14=<do koñca roku>');
  xList.Add('12=<dowolny>');
  xGid := CEmptyDataGid;
  xText := '';
  xRect := Rect(10, 10, 200, 400);
  AAccepted := TCFrameForm.ShowFrame(TCListFrame, xGid, xText, xList, @xRect);
  if AAccepted then begin
    ADataGid := xGid;
    AText := xText;
  end;
end;

procedure TCDoneFrame.GetFilterDates(var ADateFrom, ADateTo: TDateTime);
var xId: TDataGid;
begin
  ADateFrom := 0;
  ADateTo := 0;
  xId := CStaticPeriod.DataId;
  if xId = '1' then begin
    ADateFrom := GWorkDate;
    ADateTo := GWorkDate;
  end else if xId = '2' then begin
    ADateFrom := StartOfTheWeek(GWorkDate);
    ADateTo := EndOfTheWeek(GWorkDate);
  end else if xId = '3' then begin
    ADateFrom := StartOfTheMonth(GWorkDate);
    ADateTo := EndOfTheMonth(GWorkDate);
  end else if xId = '4' then begin
    ADateFrom := IncDay(GWorkDate, -6);
    ADateTo := GWorkDate;
  end else if xId = '5' then begin
    ADateFrom := IncDay(GWorkDate, -13);
    ADateTo := GWorkDate;
  end else if xId = '6' then begin
    ADateFrom := IncDay(GWorkDate, -29);
    ADateTo := GWorkDate;
  end else if xId = '7' then begin
    ADateFrom := StartOfTheWeek(IncDay(GWorkDate, 7));
    ADateTo := EndOfTheWeek(IncDay(GWorkDate, 7));
  end else if xId = '8' then begin
    ADateFrom := StartOfTheMonth(IncDay(EndOfTheMonth(GWorkDate), 1));
    ADateTo := EndOfTheMonth(IncDay(EndOfTheMonth(GWorkDate), 1));
  end else if xId = '9' then begin
    ADateFrom := GWorkDate;
    ADateTo := IncDay(GWorkDate, 6);
  end else if xId = '10' then begin
    ADateFrom := GWorkDate;
    ADateTo := IncDay(GWorkDate, 13);
  end else if xId = '11' then begin
    ADateFrom := GWorkDate;
    ADateTo := IncDay(GWorkDate, 29);
  end else if xId = '12' then begin
    ADateFrom := CDateTimePerStart.Value;
    ADateTo := CDateTimePerEnd.Value;
  end else if xId = '13' then begin
    ADateFrom := StartOfTheYear(CDateTimePerStart.Value);
    ADateTo := CDateTimePerEnd.Value;
  end else if xId = '14' then begin
    ADateFrom := CDateTimePerStart.Value;
    ADateTo := EndOfTheYear(CDateTimePerEnd.Value);
  end else if xId = '15' then begin
    ADateFrom := StartOfTheYear(CDateTimePerStart.Value);
    ADateTo := EndOfTheYear(CDateTimePerEnd.Value);
  end;
end;

procedure TCDoneFrame.UpdateCustomPeriod;
var xF, xE: TDateTime;
begin
  CDateTimePerStart.HotTrack := CStaticPeriod.DataId = '12';
  CDateTimePerEnd.HotTrack := CStaticPeriod.DataId = '12';
  if CStaticPeriod.DataId <> '12' then begin
    GetFilterDates(xF, xE);
    CDateTimePerStart.Value := xF;
    CDateTimePerEnd.Value := xE;
  end;
end;

procedure TCDoneFrame.CDateTimePerStartChanged(Sender: TObject);
begin
  ReloadDone;
end;

procedure TCDoneFrame.RecreateTreeHelper;
var xDF, xDT: TDateTime;
begin
  GetFilterDates(xDF, xDT);
  GetScheduledObjects(FTreeObjects, FPlannedObjects, FDoneObjects, xDF, xDT, sosBoth);
end;

constructor TDoneFrameAdditionalData.Create(AMovementType: TBaseEnumeration);
begin
  inherited Create;
  FmovementType := AMovementType;
end;

function TCDoneFrame.GetSelectedId: ShortString;
var xData: TPlannedTreeItem;
begin
  if DoneList.FocusedNode <> Nil then begin
    xData := TPlannedTreeItem(DoneList.GetNodeData(DoneList.FocusedNode)^);
    Result := xData.planned.id + '|' + DatetimeToDatabase(xData.triggerDate, False) + '|' + DatetimeToDatabase(xData.dueDate, False);
  end else begin
    Result := CEmptyDataGid;
  end;
end;

function TCDoneFrame.GetSelectedText: String;
var xData: TPlannedTreeItem;
begin
  Result := '';
  if DoneList.FocusedNode <> Nil then begin
    xData := TPlannedTreeItem(DoneList.GetNodeData(DoneList.FocusedNode)^);
    if xData.planned.movementType = COutMovement then begin
      Result := xData.planned.description + ' (p³atne do ' + Date2StrDate(xData.triggerDate) + ')';
    end else if xData.planned.movementType = CInMovement then begin
      Result := xData.planned.description + ' (wp³yw do ' + Date2StrDate(xData.triggerDate) + ')';
    end else if xData.planned.movementType = CTransferMovement then begin
      Result := xData.planned.description + ' (transfer do ' + Date2StrDate(xData.triggerDate) + ')';
    end;
  end;
end;

procedure TCDoneFrame.DoneListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
var xData: TPlannedTreeItem;
    xCanAccept: Boolean;
    xStat: Boolean;
    xOper: Boolean;
begin
  UpdateButtons(Node <> Nil);
  xCanAccept := False;
  xOper := False;
  xStat := False;
  if Node <> Nil then begin
    xData := TPlannedTreeItem(DoneList.GetNodeData(Node)^);
    if xData.done = Nil then begin
      xCanAccept := True;
      xStat := True;
      xOper := True;
    end else begin
      xStat := xData.done.doneState <> CDoneOperation;
    end;
  end;
  if Owner.InheritsFrom(TCFrameForm) then begin
    TCFrameForm(Owner).BitBtnOk.Enabled := xCanAccept;
  end;
  CButtonsStatus.Enabled := xStat;
  CButtonOperation.Enabled := xOper;
end;

function TCDoneFrame.FindNode(ADataId: ShortString; AList: TCList): PVirtualNode;
var xCurNode: PVirtualNode;
    xDataobject: TPlannedTreeItem;
    xNodeId: TDataGid;
begin
  Result := Nil;
  xCurNode := AList.GetFirst;
  while (Result = Nil) and (xCurNode <> Nil) do begin
    xDataobject := TPlannedTreeItem(AList.GetNodeData(xCurNode)^);
    xNodeId := xDataobject.planned.id + '|' + DatetimeToDatabase(xDataobject.triggerDate, False) + '|' + DatetimeToDatabase(xDataobject.dueDate, False);
    if xNodeId = ADataId then begin
      Result := xCurNode;
    end else begin
      xCurNode := AList.GetNext(xCurNode);
    end;
  end;
end;

procedure TCDoneFrame.ActionOperationExecute(Sender: TObject);
var xForm: TCDoneForm;
    xData: TPlannedTreeItem;
begin
  if DoneList.FocusedNode <> Nil then begin
    xData := TPlannedTreeItem(DoneList.GetNodeData(DoneList.FocusedNode)^);
    xForm := TCDoneForm.Create(Nil);
    xForm.TreeElement := xData;
    if xForm.ShowConfig(coEdit) then begin
      if xForm.ComboBoxStatus.ItemIndex = 0 then begin
        if xData.done <> Nil then begin
          GDataProvider.BeginTransaction;
          xData.done.DeleteObject;
          GDataProvider.CommitTransaction;
          FDoneObjects.Remove(xData.done);
          xData.done := Nil;
        end;
      end else begin
        GDataProvider.BeginTransaction;
        if xData.done = Nil then begin
          xData.done := TPlannedDone.CreateObject(PlannedDoneProxy, True);
          FDoneObjects.Add(xData.done);
          xData.done.idPlannedMovement := xData.planned.id;
          xData.done.triggerDate := xData.triggerDate;
          xData.done.dueDate := xData.dueDate;
        end;
        xData.done.doneDate := xForm.CDateTime.Value;
        xData.done.description := xForm.RichEditDesc.Text;
        xData.done.cash := xForm.CCurrCash.Value;
        xData.done.idDoneCurrencyDef := xData.planned.idMovementCurrencyDef;
        if xForm.ComboBoxStatus.ItemIndex = 1 then begin
          xData.done.doneState := CDoneAccepted;
        end else begin
          xData.done.doneState := CDoneDeleted;
        end;
        GDataProvider.CommitTransaction;
      end;
      DoneList.InvalidateNode(DoneList.FocusedNode);
      DoneListFocusChanged(DoneList, DoneList.FocusedNode, 0);
      ReloadSums;
    end;
    xForm.Free;
  end;
end;

procedure TCDoneFrame.ReloadSums;
var xCount: Integer;
    xElement: TPlannedTreeItem;
    xSum: TSumElement;
    xMultiCurrency: Boolean;
    xOneCurrency: TDataGid;
    xPar: TSumElement;
begin
  if AdditionalData = Nil then begin
    SumList.BeginUpdate;
    SumList.Clear;
    xMultiCurrency := False;
    xOneCurrency := CEmptyDataGid;
    xCount := 0;
    while (not xMultiCurrency) and (xCount <= FTreeObjects.Count - 1) do begin
      xElement := TPlannedTreeItem(FTreeObjects.Items[xCount]);
      if xElement.done = Nil then begin
        if xElement.planned.movementType <> CTransferMovement then begin
          if xOneCurrency = CEmptyDataGid then begin
            xOneCurrency := xElement.planned.idMovementCurrencyDef;
          end else begin
            xMultiCurrency := xOneCurrency <> xElement.planned.idMovementCurrencyDef;
          end;
        end;
      end;
      Inc(xCount);
    end;
    FSumRoot.childs.Clear;
    if xMultiCurrency then begin
      for xCount := 0 to FTreeObjects.Count - 1 do begin
        xElement := TPlannedTreeItem(FTreeObjects.Items[xCount]);
        if xElement.done = Nil then begin
          if xElement.planned.movementType <> CTransferMovement then begin
            xSum := FSumRoot.childs.FindSumObjectByCur(xElement.planned.idMovementCurrencyDef, False);
            if xSum = Nil then begin
              xSum := TSumElement.Create;
              xSum.id := '*';
              xSum.idCurrencyDef := xElement.planned.idMovementCurrencyDef;
              xSum.cashIn := 0;
              xSum.cashOut := 0;
              xSum.name := 'Razem w ' + GCurrencyCache.GetSymbol(xElement.planned.idMovementCurrencyDef);
              FSumRoot.AddChild(xSum);
            end;
          end;
        end;
      end;
    end else begin
      xSum := TSumElement.Create;
      xSum.id := '*';
      xSum.idCurrencyDef := xOneCurrency;
      xSum.cashIn := 0;
      xSum.cashOut := 0;
      xSum.name := 'Razem wszystkie operacje';
      FSumRoot.AddChild(xSum);
    end;
    for xCount := 0 to FTreeObjects.Count - 1 do begin
      xElement := TPlannedTreeItem(FTreeObjects.Items[xCount]);
      if xElement.done = Nil then begin
        if xElement.planned.movementType <> CTransferMovement then begin
          if xMultiCurrency then begin
            xPar := FSumRoot.childs.FindSumObjectByCur(xElement.planned.idMovementCurrencyDef, False);
          end else begin
            xPar := FSumRoot;
          end;
          if xPar <> Nil then begin
            xSum := xPar.childs.FindSumObjectById(xElement.planned.idAccount, False);
            if xSum = Nil then begin
              xSum := TSumElement.Create;
              xSum.id := xElement.planned.idAccount;
              xSum.idCurrencyDef := xElement.planned.idMovementCurrencyDef;
              if xSum.id = CEmptyDataGid then begin
                xSum.name := 'Bez zdefiniowanego konta';
              end else begin
                xSum.name := TAccount(TAccount.LoadObject(AccountProxy, xElement.planned.idAccount, False)).name;
              end;
              xPar.AddChild(xSum);
            end;
            xSum.cashIn := xSum.cashIn + IfThen(xElement.planned.movementType = CInMovement, xElement.planned.cash, 0);
            xSum.cashOut := xSum.cashOut + IfThen(xElement.planned.movementType = COutMovement, xElement.planned.cash, 0);
            xPar.cashIn := xPar.cashIn + xSum.cashIn;
            xPar.cashOut := xPar.cashOut + xSum.cashOut;
          end;
        end;
      end;
    end;
    SumList.RootNodeCount := FSumRoot.childs.Count;
    SumList.EndUpdate;
  end;
end;

procedure TCDoneFrame.DoneListDblClick(Sender: TObject);
begin
  if CButtonsStatus.Enabled then begin
    ActionOperation.Execute;
  end;
end;

class function TCDoneFrame.GetPrefname: String;
begin
  Result := 'plannedDone';
end;

procedure TCDoneFrame.ActionDooperationExecute(Sender: TObject);
var xForm: TCMovementForm;
    xBase: TPlannedTreeItem;
    xNode: PVirtualNode;
begin
  xNode := DoneList.FocusedNode;
  if xNode <> Nil then begin
    xBase := TPlannedTreeItem(DoneList.GetNodeData(xNode)^);
    xForm := TCMovementForm.Create(Nil);
    xForm.ShowDataobject(coAdd, BaseMovementProxy, Nil, True, TMovementAdditionalData.Create(xBase.triggerDate, xBase.dueDate, xBase.planned, Nil));
    xForm.Free;
    ReloadSums;
  end;
end;

procedure TCDoneFrame.DoneListGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
var xBase: TPlannedTreeItem;
begin
  if Column = 4 then begin
    xBase := TPlannedTreeItem(DoneList.GetNodeData(Node)^);
    if xBase.planned.movementType = CInMovement then begin
      ImageIndex := 0;
    end else if xBase.planned.movementType = COutMovement then begin
      ImageIndex := 1;
    end else if xBase.planned.movementType = CTransferMovement then begin
      ImageIndex := 10;
    end;
  end else if Column = 5 then begin
    xBase := TPlannedTreeItem(DoneList.GetNodeData(Node)^);
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
  end;
end;

procedure TCDoneFrame.SumListInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
var xDate: TSumElement;
begin
  xDate := TSumElement(SumList.GetNodeData(Node)^);
  ChildCount := xDate.childs.Count;
end;

function TCDoneFrame.IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean;
begin
  Result := (APluginSelectedItemTypes and CSELECTEDITEM_PLANNEDDONE) = CSELECTEDITEM_PLANNEDDONE; 
end;

function TCDoneFrame.GetSelectedType: Integer;
begin
  Result := CSELECTEDITEM_PLANNEDDONE;
end;

procedure TCDoneFrame.ActionPlannedExecute(Sender: TObject);
var xGid, xText: String;
begin
  TCFrameForm.ShowFrame(TCPlannedFrame, xGid, xText, nil, nil, nil, nil, False);
end;

procedure TCDoneFrame.DoRepaintLists;
begin
  inherited DoRepaintLists;
  SumList.ReinitNode(SumList.RootNode, True);
  SumList.Repaint;
end;

procedure TCDoneFrame.Ustawienialisty2Click(Sender: TObject);
var xPrefs: TCListPreferencesForm;
begin
  xPrefs := TCListPreferencesForm.Create(Nil);
  if xPrefs.ShowListPreferences(SumList.ViewPref) then begin
    SendMessageToFrames(TCBaseFrameClass(ClassType), WM_MUSTREPAINT, 0, 0);
  end;
  xPrefs.Free;
end;

procedure TCDoneFrame.DoneListGetRowPreferencesName(AHelper: TObject; var APrefname: String);
begin
  if TPlannedTreeItem(AHelper).done <> Nil then begin
    APrefname := 'D' + TPlannedTreeItem(AHelper).done.doneState;
  end else begin
    if TPlannedTreeItem(AHelper).triggerDate >= GWorkDate then begin
      APrefname := 'R';
    end else begin
      APrefname := 'W';
    end;
  end;
end;

procedure TCDoneFrame.MenuItemBigIconsClick(Sender: TObject);
begin
  if not MenuItemBigIcons.Checked then begin
    MenuItemBigIcons.Checked := True;
    if List.ViewPref <> Nil then begin
      List.ViewPref.ButtonSmall := False;
    end;
    UpdateIcons;
  end;
end;

procedure TCDoneFrame.MenuItemSmallIconsClick(Sender: TObject);
begin
  if not MenuItemSmallIcons.Checked then begin
    MenuItemSmallIcons.Checked := True;
    if List.ViewPref <> Nil then begin
      List.ViewPref.ButtonSmall := True;
    end;
    UpdateIcons;
  end;
end;

procedure TCDoneFrame.UpdateIcons;
var xDummy: TPngImageList;
begin
  xDummy := Nil;
  UpdatePanelIcons(Panel1,
                   MenuItemBigIcons, MenuItemSmallIcons,
                   FBigIconsButtonsImageList, Nil,
                   ActionList, Nil,
                   FSmallIconsButtonsImageList,
                   xDummy);
end;


procedure TCDoneFrame.MenuItemsumsVisibleClick(Sender: TObject);
begin
  TFrameWithSumlistPref(FramePreferences).sumListVisible := not MenuItemsumsVisible.Checked;
  UpdateSumList;
end;

procedure TCDoneFrame.SpeedButtonCloseShortcutsClick(Sender: TObject);
begin
  TFrameWithSumlistPref(FramePreferences).sumListVisible := False;
  UpdateSumList;
end;

procedure TCDoneFrame.UpdateSumList;
begin
  if TFrameWithSumlistPref(FramePreferences).sumListVisible then begin
    Splitter1.Enabled := True;
    Panel2.Visible := True;
    SumList.Visible := True;
    MenuItemsumsVisible.Checked := True;
    if TFrameWithSumlistPref(FramePreferences).sumListHeight <> -1 then begin
      PanelFrameButtons.AutoSize := False;
      PanelFrameButtons.Height := TFrameWithSumlistPref(FramePreferences).sumListHeight;
    end;
  end else begin
    TFrameWithSumlistPref(FramePreferences).sumListHeight := PanelFrameButtons.Height;
    PanelFrameButtons.AutoSize := True;
    SumList.Visible := False;
    Panel2.Visible := False;
    Splitter1.Enabled := False;
    MenuItemsumsVisible.Checked := False;
  end;
  SpeedButtonCloseShortcuts.Left := PanelFrameButtons.Width - 16;
end;

procedure TCDoneFrame.SaveFramePreferences;
begin
  if TFrameWithSumlistPref(FramePreferences).sumListVisible then begin
    TFrameWithSumlistPref(FramePreferences).sumListHeight := PanelFrameButtons.Height;
  end;
  inherited SaveFramePreferences;
end;

procedure TCDoneFrame.LoadFramePreferences;
begin
  inherited LoadFramePreferences;
  UpdateSumList;
end;

end.
