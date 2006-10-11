unit CDoneFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, ImgList, StdCtrls, ExtCtrls, VirtualTrees,
  ActnList, CComponents, CDatabase, Menus, VTHeaderPopup, GraphUtil, AdoDb,
  Contnrs;

type
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
    procedure ActionMovementExecute(Sender: TObject);
    procedure ActionEditMovementExecute(Sender: TObject);
    procedure ActionDelMovementExecute(Sender: TObject);
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
  private
    FDoneObjects: TDataObjectList;
    FSumObjects: TSumList;
    procedure UpdateCustomPeriod;
  protected
    procedure WndProc(var Message: TMessage); override;
    function GetList: TVirtualStringTree; override;
    procedure GetFilterDates(var ADateFrom, ADateTo: TDateTime);
  public
    procedure ReloadDone;
    procedure ReloadSums;
    constructor Create(AOwner: TComponent); override;
    procedure InitializeFrame(AAdditionalData: TObject); override;
    destructor Destroy; override;
    class function GetTitle: String; override;
    function IsValidFilteredObject(AObject: TDataObject): Boolean; override;
  end;

implementation

uses CFrameFormUnit, CDataObjects, CInfoFormUnit, CConfigFormUnit, CDataobjectFormUnit,
  CAccountsFrameUnit, DateUtils, CListFrameUnit, DB, CMovementFormUnit;

{$R *.dfm}

procedure TCDoneFrame.ActionMovementExecute(Sender: TObject);
var xForm: TCMovementForm;
    xDataGid: TDataGid;
begin
  xForm := TCMovementForm.Create(Nil);
  xDataGid := xForm.ShowDataobject(coAdd, BaseMovementProxy, Nil, True);
  if xDataGid <> CEmptyDataGid then begin
    SendMessageToFrames(TCDoneFrame, WM_DATAOBJECTADDED, Integer(@xDataGid), 0);
  end;
  xForm.Free;
end;

procedure TCDoneFrame.ActionEditMovementExecute(Sender: TObject);
var xForm: TCDataobjectForm;
    xBase: TBaseMovement;
    xDataGid: TDataGid;
begin
  xBase := TBaseMovement(DoneList.GetNodeData(DoneList.FocusedNode)^);
  xForm := TCMovementForm.Create(Nil);
  xDataGid := xForm.ShowDataobject(coEdit, BaseMovementProxy, xBase, True);
  if xDataGid <> CEmptyDataGid then begin
    SendMessageToFrames(TCDoneFrame, WM_DATAOBJECTEDITED, Integer(@xDataGid), 0);
  end;
  xForm.Free;
end;

procedure TCDoneFrame.ActionDelMovementExecute(Sender: TObject);
var xBase: TBaseMovement;
    xObject: TDataObject;
    xAccount: TAccount;
    xIdTemp1, xIdTemp2, xIdTemp3: TDataGid;
    xIdTemp3Frame: TCBaseFrameClass;
begin
  if ShowInfo(itQuestion, 'Czy chcesz usun¹æ wybran¹ operacjê ?', '') then begin
    xBase := TBaseMovement(DoneList.GetNodeData(DoneList.FocusedNode)^);
    xIdTemp1 := xBase.id;
    xIdTemp2 := xBase.idAccount;
    xIdTemp3 := CEmptyDataGid;
    xIdTemp3Frame := Nil;
    if (xBase.movementType = CInMovement) then begin
      xObject := TBaseMovement(TBaseMovement.LoadObject(BaseMovementProxy, xBase.id, False));
      xAccount := TAccount(TAccount.LoadObject(AccountProxy, xBase.idAccount, False));
      xAccount.cash := xAccount.cash - xBase.cash;
    end else if (xBase.movementType = COutMovement) then begin
      xObject := TBaseMovement(TBaseMovement.LoadObject(BaseMovementProxy, xBase.id, False));
      xAccount := TAccount(TAccount.LoadObject(AccountProxy, xBase.idAccount, False));
      xAccount.cash := xAccount.cash + xBase.cash;
    end else begin
      xObject := TBaseMovement(TBaseMovement.LoadObject(BaseMovementProxy, xBase.id, False));
      xAccount := TAccount(TAccount.LoadObject(AccountProxy, TBaseMovement(xObject).idSourceAccount, False));
      xAccount.cash := xAccount.cash + TBaseMovement(xObject).cash;
      xAccount := TAccount(TAccount.LoadObject(AccountProxy, xBase.idAccount, False));
      xAccount.cash := xAccount.cash - xBase.cash;
      xIdTemp3 := TBaseMovement(xObject).idSourceAccount;
      xIdTemp3Frame := TCAccountsFrame;
    end;
    xObject.DeleteObject;
    GDataProvider.CommitTransaction;
    SendMessageToFrames(TCDoneFrame, WM_DATAOBJECTDELETED, Integer(@xIdTemp1), 0);
    SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTEDITED, Integer(@xIdTemp2), 0);
    if (xIdTemp3 <> CEmptyDataGid) and (xIdTemp3Frame <> Nil) then begin
      SendMessageToFrames(xIdTemp3Frame, WM_DATAOBJECTEDITED, Integer(@xIdTemp3), 0);
    end;
  end;
end;

constructor TCDoneFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDoneObjects := Nil;
  FSumObjects := TSumList.Create(True);
end;

procedure TCDoneFrame.ReloadDone;
var xSql: String;
    xDf, xDt: TDateTime;
begin
  xSql := 'select * from plannedMovement where isActive = true ';
  if CStaticFilter.DataId = '2' then begin
    xSql := xSql + Format(' and movementType = ''%s''', [COutMovement]);
  end else if CStaticFilter.DataId = '3' then begin
    xSql := xSql + Format(' and movementType = ''%s''', [CInMovement]);
  end;
  GetFilterDates(xDf, xDt);
  xSql := xSql + Format(' and (' +
                        '  (scheduleType = ''O'' and scheduleDate between dateValue(%s) and dateValue (%s) and (select count(*) from plannedDone where plannedDone.idPlannedMovement = plannedMovement.idPlannedMovement) = 0) or ' +
                        '  (scheduleType = ''C'' and scheduleDate >= dateValue(%s))' +
                        ' )', [DatetimeToDatabase(xDf), DatetimeToDatabase(xDt), DatetimeToDatabase(xDf)]);
  xSql := xSql + Format(' and (' +
                        '  (endCondition = ''N'') or ' +
                        '  (endCondition = ''D'' and endDate >= dateValue(%s)) or ' +
                        '  (endCondition = ''T'' and endCount > (select count(*) from plannedDone where plannedDone.idPlannedMovement = plannedMovement.idPlannedMovement)) ' +
                        ' )', [DatetimeToDatabase(xDf)]);
  if FDoneObjects <> Nil then begin
    FreeAndNil(FDoneObjects);
  end;
  FDoneObjects := TDataObject.GetList(TPlannedMovement, PlannedMovementProxy, xSql);
  DoneList.BeginUpdate;
  DoneList.Clear;
  DoneList.RootNodeCount := FDoneObjects.Count;
  DoneList.EndUpdate;
end;

procedure TCDoneFrame.InitializeFrame(AAdditionalData: TObject);
begin
  inherited InitializeFrame(AAdditionalData);
  UpdateCustomPeriod;
  CDateTimePerStart.Value := GWorkDate;
  CDateTimePerEnd.Value := GWorkDate;
  Label3.Anchors := [akRight, akTop];
  CDateTimePerStart.Anchors := [akRight, akTop];
  Label4.Anchors := [akRight, akTop];
  CDateTimePerEnd.Anchors := [akRight, akTop];
  Label5.Anchors := [akRight, akTop];
  ReloadDone;
  ReloadSums;
end;

destructor TCDoneFrame.Destroy;
begin
  FDoneObjects.Free;
  FSumObjects.Free;
  inherited Destroy;
end;

procedure TCDoneFrame.DoneListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  TDataObject(DoneList.GetNodeData(Node)^) := FDoneObjects.Items[Node.Index];
end;

procedure TCDoneFrame.DoneListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TDataObject);
end;

procedure TCDoneFrame.DoneListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var xData: TBaseMovement;
begin
  xData := TBaseMovement(DoneList.GetNodeData(Node)^);
  if Column = 0 then begin
    CellText := IntToStr(Node.Index + 1);
  end else if Column = 1 then begin
    CellText := xData.description;
  end else if Column = 2 then begin
    CellText := DateToStr(xData.regDate);
  end else if Column = 3 then begin
    CellText := CurrencyToString(xData.cash);
  end else if Column = 4 then begin
    if (xData.movementType = CInMovement) then begin
      CellText := 'Przychód';
    end else if (xData.movementType = COutMovement) then begin
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
var xData1: TBaseMovement;
    xData2: TBaseMovement;
begin
  xData1 := TBaseMovement(DoneList.GetNodeData(Node1)^);
  xData2 := TBaseMovement(DoneList.GetNodeData(Node2)^);
  if Column = 0 then begin
    if Node1.Index > Node2.Index then begin
      Result := 1;
    end else if Node1.Index < Node2.Index then begin
      Result := -1;
    end else begin
      Result := 0;
    end;
  end else if Column = 1 then begin
    Result := AnsiCompareText(xData1.description, xData2.description);
  end else if Column = 2 then begin
    if xData1.regDate > xData2.regDate then begin
      Result := 1;
    end else if xData1.regDate < xData2.regDate then begin
      Result := -1;
    end else begin
      Result := 0;
    end;
  end else if Column = 3 then begin
    if xData1.cash > xData2.cash then begin
      Result := 1;
    end else if xData1.cash < xData2.cash then begin
      Result := -1;
    end else begin
      Result := 0;
    end;
  end else if Column = 4 then begin
    Result := AnsiCompareText(xData1.movementType, xData2.movementType);
  end;
end;

procedure TCDoneFrame.DoneListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
var xData: TBaseMovement;
begin
  xData := TBaseMovement(DoneList.GetNodeData(Node)^);
  HintText := xData.description;
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
      ReloadSums;
    end;
  end;
end;

class function TCDoneFrame.GetTitle: String;
begin
  Result := 'Na dziœ';
end;

function TCDoneFrame.IsValidFilteredObject(AObject: TDataObject): Boolean;
var xOt, xFt: String;
    xDf, xDt: TDateTime;
begin
  xOt := TBaseMovement(AObject).movementType;
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
    Result := (xDf <= TBaseMovement(AObject).regDate) and (TBaseMovement(AObject).regDate <= xDt);
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
  ReloadSums;
end;

procedure TCDoneFrame.ReloadSums;
var xDs: TADOQuery;
    xSql: String;
    xObj: TSumElement;
    xOvr: TSumElement;
    xDf, xDt: TDateTime;
begin
  GetFilterDates(xDf, xDt);
  xSql := Format(
          'select T1.*, account.name from ( ' +
          '   select sum(cash) as deltaCash, movementType, idAccount from baseMovement where ' +
          '   regDate between DateValue(%s) and DateValue(%s) and movementType <> ''' + CTransferMovement + ''' group by idAccount, movementType) as T1 ' +
          '   left join account on account.idAccount = T1.idAccount', [DatetimeToDatabase(xDf), DatetimeToDatabase(xDt)]);
  xDs := GDataProvider.OpenSql(xSql);
  SumList.BeginUpdate;
  SumList.Clear;
  FSumObjects.Clear;
  xOvr := TSumElement.Create;
  xOvr.name := 'Ogó³em dla wszystkich kont';
  xOvr.cashIn := 0;
  xOvr.cashOut := 0;
  xOvr.id := '*';
  while not xDs.Eof do begin
    xObj := FSumObjects.FindSumObject(xDs.FieldByName('idAccount').AsString);
    xObj.id := xDs.FieldByName('idAccount').AsString;
    xObj.name := xDs.FieldByName('name').AsString;
    if xDs.FieldByName('movementType').AsString = CInMovement then begin
      xObj.cashIn := xObj.cashIn + xDs.FieldByName('deltaCash').AsCurrency;
      xOvr.cashIn := xOvr.cashIn + xObj.cashIn;
    end else begin
      xObj.cashOut := xObj.cashOut + xDs.FieldByName('deltaCash').AsCurrency;
      xOvr.cashOut := xOvr.cashOut + xObj.cashOut;
    end;
    xDs.Next;
  end;
  FSumObjects.Add(xOvr);
  SumList.RootNodeCount := FSumObjects.Count;
  SumList.EndUpdate;
  GTodayCashIn := xOvr.cashIn;
  GTodayCashOut := xOvr.cashOut;
  xDs.Free;
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
      Result := -11;
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
  ReloadSums;
end;

end.
