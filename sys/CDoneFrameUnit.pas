unit CDoneFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, ImgList, StdCtrls, ExtCtrls, VirtualTrees,
  ActnList, CComponents, CDatabase, Menus, VTHeaderPopup, GraphUtil, AdoDb,
  Contnrs, CDataObjects, PngImageList;

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
    DoneList: TVirtualStringTree;
    ActionList: TActionList;
    VTHeaderPopupMenu: TVTHeaderPopupMenu;
    Panel: TPanel;
    CStaticFilter: TCStatic;
    Panel2: TPanel;
    Splitter1: TSplitter;
    SumList: TVirtualStringTree;
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
    procedure DoneListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure DoneListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure DoneListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure DoneListHeaderClick(Sender: TVTHeader; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DoneListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure DoneListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
    procedure DoneListBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
    procedure CStaticFilterGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticFilterChanged(Sender: TObject);
    procedure SumListBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
    procedure SumListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure SumListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure SumListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure SumListHeaderClick(Sender: TVTHeader; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SumListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure CStaticPeriodGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CDateTimePerStartChanged(Sender: TObject);
    procedure DoneListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure ActionOperationExecute(Sender: TObject);
  private
    FPlannedObjects: TDataObjectList;
    FDoneObjects: TDataObjectList;
    FSumObjects: TSumList;
    FTreeObjects: TObjectList;
    procedure UpdateCustomPeriod;
  protected
    procedure WndProc(var Message: TMessage); override;
    function GetList: TVirtualStringTree; override;
    procedure GetFilterDates(var ADateFrom, ADateTo: TDateTime);
    function GetSelectedId: ShortString; override;
    function GetSelectedText: String; override;
  public
    procedure ReloadDone;
    procedure ReloadSums;
    procedure RecreateTreeHelper;
    constructor Create(AOwner: TComponent); override;
    procedure InitializeFrame(AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList); override;
    destructor Destroy; override;
    class function GetTitle: String; override;
    function IsValidFilteredObject(AObject: TDataObject): Boolean; override;
    function FindNode(ADataId: ShortString; AList: TVirtualStringTree): PVirtualNode; override;
  end;

implementation

uses CFrameFormUnit, CInfoFormUnit, CConfigFormUnit, CDataobjectFormUnit,
  CAccountsFrameUnit, DateUtils, CListFrameUnit, DB, CMovementFormUnit,
  Math, CDoneFormUnit, CSchedules;

{$R *.dfm}

constructor TCDoneFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPlannedObjects := Nil;
  FDoneObjects := Nil;
  FSumObjects := TSumList.Create(True);
  FTreeObjects := TObjectList.Create(True);
end;

procedure TCDoneFrame.ReloadDone;
var xSqlPlanned, xSqlDone: String;
    xDf, xDt: TDateTime;
begin
  xSqlPlanned := 'select plannedMovement.*, (select count(*) from plannedDone where plannedDone.idplannedMovement = plannedMovement.idplannedMovement) as doneCount from plannedMovement where isActive = true ';
  if CStaticFilter.DataId = '2' then begin
    xSqlPlanned := xSqlPlanned + Format(' and movementType = ''%s''', [COutMovement]);
  end else if CStaticFilter.DataId = '3' then begin
    xSqlPlanned := xSqlPlanned + Format(' and movementType = ''%s''', [CInMovement]);
  end;
  GetFilterDates(xDf, xDt);
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
  if FPlannedObjects <> Nil then begin
    FreeAndNil(FPlannedObjects);
  end;
  if FDoneObjects <> Nil then begin
    FreeAndNil(FDoneObjects);
  end;
  FPlannedObjects := TDataObject.GetList(TPlannedMovement, PlannedMovementProxy, xSqlPlanned);
  FDoneObjects := TDataObject.GetList(TPlannedDone, PlannedDoneProxy, xSqlDone);
  RecreateTreeHelper;
  DoneList.BeginUpdate;
  DoneList.Clear;
  DoneList.RootNodeCount := FTreeObjects.Count;
  DoneList.EndUpdate;
  ReloadSums;
  DoneListFocusChanged(DoneList, DoneList.FocusedNode, 0);
end;

procedure TCDoneFrame.InitializeFrame(AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList);
var xDf, xDe: TDateTime;
begin
  inherited InitializeFrame(AAdditionalData, AOutputData, AMultipleCheck);
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
    Splitter1.Visible := False;
    CStaticFilter.HotTrack := False;
    if TDoneFrameAdditionalData(AAdditionalData).movementType = COutMovement then begin
      CStaticFilter.DataId := '2';
      CStaticFilter.Caption := '<rozchód>';
    end else begin
      CStaticFilter.DataId := '3';
      CStaticFilter.Caption := '<przychód>';
    end;
  end;
  ReloadDone;
  DoneListFocusChanged(DoneList, DoneList.FocusedNode, 0)
end;

destructor TCDoneFrame.Destroy;
begin
  FPlannedObjects.Free;
  FDoneObjects.Free;
  FSumObjects.Free;
  FTreeObjects.Free;
  inherited Destroy;
end;

procedure TCDoneFrame.DoneListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  TPlannedTreeItem(DoneList.GetNodeData(Node)^) := TPlannedTreeItem(FTreeObjects.Items[Node.Index]);
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
      CellText := xData.planned.description;
    end else begin
      CellText := xData.done.description;
    end;
  end else if Column = 2 then begin
    CellText := DateToStr(xData.triggerDate);
  end else if Column = 3 then begin
    if xData.done = Nil then begin
      CellText := CurrencyToString(xData.planned.cash);
    end else begin
      CellText := CurrencyToString(xData.done.cash);
    end;
  end else if Column = 4 then begin
    if (xData.planned.movementType = CInMovement) then begin
      CellText := 'Przychód';
    end else if (xData.planned.movementType = COutMovement) then begin
      CellText := 'Rozchód';
    end;
  end;
end;

procedure TCDoneFrame.DoneListHeaderClick(Sender: TVTHeader; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then begin
    with Sender do begin
      if SortColumn <> Column then begin
        SortColumn := Column;
        SortDirection := sdAscending;
      end else begin
        case SortDirection of
          sdAscending: SortDirection := sdDescending;
          sdDescending: SortDirection := sdAscending;
        end;
      end;
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

procedure TCDoneFrame.DoneListBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
begin
  with TargetCanvas do begin
    if not Odd(Node.Index) then begin
      ItemColor := clWindow;
    end else begin
      ItemColor := GetHighLightColor(clWindow, -10);
    end;
    EraseAction := eaColor;
  end;
end;

function TCDoneFrame.GetList: TVirtualStringTree;
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

procedure TCDoneFrame.SumListBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
begin
  with TargetCanvas do begin
    if not Odd(Node.Index) then begin
      ItemColor := clWindow;
    end else begin
      ItemColor := GetHighLightColor(clWindow, -10);
    end;
    EraseAction := eaColor;
  end;
end;

procedure TCDoneFrame.SumListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var xData1: TSumElement;
    xData2: TSumElement;
begin
  xData1 := TSumElement(SumList.GetNodeData(Node1)^);
  xData2 := TSumElement(SumList.GetNodeData(Node2)^);
  if (xData1.id = '*') then begin
    if TVirtualStringTree(Sender).Header.SortDirection = sdAscending then begin
      Result := -1;
    end else begin
      Result := 1;
    end;
  end else if (xData2.id = '*') then begin
    if TVirtualStringTree(Sender).Header.SortDirection = sdAscending then begin
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
    CellText := CurrencyToString(xData.cashOut);
  end else if Column = 2 then begin
    CellText := CurrencyToString(xData.cashIn);
  end else if Column = 3 then begin
    CellText := CurrencyToString(xData.cashIn - xData.cashOut);
  end;
end;

procedure TCDoneFrame.SumListHeaderClick(Sender: TVTHeader; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then begin
    with Sender do begin
      if SortColumn <> Column then begin
        SortColumn := Column;
        SortDirection := sdAscending;
      end else begin
        case SortDirection of
          sdAscending: SortDirection := sdDescending;
          sdDescending: SortDirection := sdAscending;
        end;
      end;
    end;
  end;
end;

procedure TCDoneFrame.SumListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  TSumElement(SumList.GetNodeData(Node)^) := TSumElement(FSumObjects.Items[Node.Index]);
end;

procedure TCDoneFrame.CStaticPeriodGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
var xList: TStringList;
    xGid, xText: String;
    xRect: TRect;
begin
  xList := TStringList.Create;
  xList.Add('1=<tylko dziœ>');
  xList.Add('2=<w tym tygodni>');
  xList.Add('3=<w tym miesi¹cu>');
  xList.Add('4=<ostatnie 7 dni>');
  xList.Add('5=<ostatnie 14 dni>');
  xList.Add('6=<ostatnie 30 dni>');
  xList.Add('7=<w przysz³ym tygodni>');
  xList.Add('8=<w przysz³ym miesi¹cu>');
  xList.Add('9=<nastêpne 7 dni>');
  xList.Add('10=<nastêpne 14 dni>');
  xList.Add('11=<nastêpne 30 dni>');
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
  GetScheduledObjects(FTreeObjects, FPlannedObjects, FDoneObjects, xDF, xDT);
end;

constructor TDoneFrameAdditionalData.Create(AMovementType: TBaseEnumeration);
begin
  inherited Create;
  FmovementType := AMovementType;
end;

function TCDoneFrame.GetSelectedId: ShortString;
var xData: TPlannedTreeItem;
begin
  Result := '';
  if DoneList.FocusedNode <> Nil then begin
    xData := TPlannedTreeItem(DoneList.GetNodeData(DoneList.FocusedNode)^);
    Result := xData.planned.id + '|' + DatetimeToDatabase(xData.triggerDate, False);
  end;
end;

function TCDoneFrame.GetSelectedText: String;
var xData: TPlannedTreeItem;
begin
  Result := '';
  if DoneList.FocusedNode <> Nil then begin
    xData := TPlannedTreeItem(DoneList.GetNodeData(DoneList.FocusedNode)^);
    if xData.planned.movementType = COutMovement then begin
      Result := xData.planned.description + ' (p³atne do ' + DateToStr(xData.triggerDate) + ')'
    end else begin
      Result := xData.planned.description + ' (wp³yw do ' + DateToStr(xData.triggerDate) + ')'
    end;
  end;
end;

procedure TCDoneFrame.DoneListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
var xData: TPlannedTreeItem;
    xCanAccept: Boolean;
    xStat: Boolean;
begin
  xCanAccept := False;
  xStat := False;
  if Node <> Nil then begin
    xData := TPlannedTreeItem(DoneList.GetNodeData(Node)^);
    if xData.done = Nil then begin
      xCanAccept := True;
      xStat := True;
    end else begin
      xStat := xData.done.doneState <> CDoneOperation;
    end;
  end;
  if Owner.InheritsFrom(TCFrameForm) then begin
    TCFrameForm(Owner).BitBtnOk.Enabled := xCanAccept;
  end;
  CButtonsStatus.Enabled := xStat;
end;

function TCDoneFrame.FindNode(ADataId: ShortString; AList: TVirtualStringTree): PVirtualNode;
var xCurNode: PVirtualNode;
    xDataobject: TPlannedTreeItem;
begin
  Result := Nil;
  xCurNode := AList.GetFirst;
  while (Result = Nil) and (xCurNode <> Nil) do begin
    xDataobject := TPlannedTreeItem(AList.GetNodeData(xCurNode)^);
    if (xDataobject.planned.id + '|' + DatetimeToDatabase(xDataobject.triggerDate, False)) = ADataId then begin
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
        end;
        xData.done.doneDate := xForm.CDateTime.Value;
        xData.done.description := xForm.RichEditDesc.Text;
        xData.done.cash := xForm.CCurrCash.Value;
        if xForm.ComboBoxStatus.ItemIndex = 1 then begin
          xData.done.doneState := CDoneAccepted;
        end else begin
          xData.done.doneState := CDoneDeleted;
        end;
        GDataProvider.CommitTransaction;
      end;
      DoneList.InvalidateNode(DoneList.FocusedNode);
      ReloadSums;
    end;
    xForm.Free;
  end;
end;

procedure TCDoneFrame.ReloadSums;
var xCount: Integer;
    xElement: TPlannedTreeItem;
    xSum: TSumElement;
begin
  if AdditionalData = Nil then begin
    SumList.BeginUpdate;
    SumList.Clear;
    FSumObjects.Clear;
    xSum := TSumElement.Create;
    xSum.id := '*';
    xSum.name := 'Ogó³em dla wszystkich kont';
    xSum.cashIn := 0;
    xSum.cashOut := 0;
    FSumObjects.Add(xSum);
    for xCount := 0 to FTreeObjects.Count - 1 do begin
      xElement := TPlannedTreeItem(FTreeObjects.Items[xCount]);
      if xElement.done = Nil then begin
        xSum := FSumObjects.FindSumObject('*', True);
        xSum.cashIn := xSum.cashIn + IfThen(xElement.planned.movementType = CInMovement, xElement.planned.cash, 0);
        xSum.cashOut := xSum.cashOut + IfThen(xElement.planned.movementType = COutMovement, xElement.planned.cash, 0);
        xSum := FSumObjects.FindSumObject(xElement.planned.idAccount, False);
        if xSum = Nil then begin
          xSum := TSumElement.Create;
          xSum.id := xElement.planned.idAccount;
          if xSum.id = CEmptyDataGid then begin
            xSum.name := 'Bez zdefiniowanego konta';
          end else begin
            xSum.name := TAccount(TAccount.LoadObject(AccountProxy, xElement.planned.idAccount, False)).name;
          end;
          FSumObjects.Add(xSum);
        end;
        xSum.cashIn := xSum.cashIn + IfThen(xElement.planned.movementType = CInMovement, xElement.planned.cash, 0);
        xSum.cashOut := xSum.cashOut + IfThen(xElement.planned.movementType = COutMovement, xElement.planned.cash, 0);
      end;
    end;
    SumList.RootNodeCount := FSumObjects.Count;
    SumList.EndUpdate;
  end;
end;

end.
