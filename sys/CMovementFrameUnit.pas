unit CMovementFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, ImgList, StdCtrls, ExtCtrls, VirtualTrees,
  ActnList, CComponents, CDatabase, Menus, VTHeaderPopup, GraphUtil, AdoDb,
  Contnrs, PngImageList, CImageListsUnit, CDataObjects;

type
  TCMovementFrame = class(TCBaseFrame)
    PanelFrameButtons: TPanel;
    TodayList: TVirtualStringTree;
    ActionList: TActionList;
    ActionMovement: TAction;
    ActionEditMovement: TAction;
    ActionDelMovement: TAction;
    Panel1: TPanel;
    CButtonOut: TCButton;
    CButtonEdit: TCButton;
    CButtonDel: TCButton;
    Bevel: TBevel;
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
    procedure TodayListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure TodayListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure TodayListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure TodayListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure TodayListHeaderClick(Sender: TVTHeader; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure TodayListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure TodayListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
    procedure TodayListBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
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
    procedure TodayListDblClick(Sender: TObject);
    procedure TodayListPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
  private
    FTodayObjects: TDataObjectList;
    FSumObjects: TSumList;
    procedure MessageMovementAdded(AId: TDataGid);
    procedure MessageMovementEdited(AId: TDataGid);
    procedure MessageMovementDeleted(AId: TDataGid);
    procedure UpdateCustomPeriod;
    procedure FindFontAndBackground(AMovement: TBaseMovement; AFont: TFont; var ABackground: TColor);
  protected
    procedure WndProc(var Message: TMessage); override;
    procedure GetFilterDates(var ADateFrom, ADateTo: TDateTime);
  public
    function GetList: TVirtualStringTree; override;
    procedure ReloadToday;
    procedure ReloadSums;
    constructor Create(AOwner: TComponent); override;
    procedure InitializeFrame(AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList); override;
    destructor Destroy; override;
    class function GetTitle: String; override;
    function IsValidFilteredObject(AObject: TDataObject): Boolean; override;
  end;

implementation

uses CFrameFormUnit, CInfoFormUnit, CConfigFormUnit, CDataobjectFormUnit,
  CAccountsFrameUnit, DateUtils, CListFrameUnit, DB, CMovementFormUnit,
  Types, CDoneFormUnit, CDoneFrameUnit, CConsts, CPreferences;

{$R *.dfm}

procedure TCMovementFrame.ActionMovementExecute(Sender: TObject);
var xForm: TCMovementForm;
    xDataGid: TDataGid;
begin
  xForm := TCMovementForm.Create(Nil);
  xDataGid := xForm.ShowDataobject(coAdd, BaseMovementProxy, Nil, True);
  if xDataGid <> CEmptyDataGid then begin
    SendMessageToFrames(TCMovementFrame, WM_DATAOBJECTADDED, Integer(@xDataGid), 0);
  end;
  xForm.Free;
end;

procedure TCMovementFrame.ActionEditMovementExecute(Sender: TObject);
var xForm: TCDataobjectForm;
    xBase: TBaseMovement;
    xDataGid: TDataGid;
begin
  xBase := TBaseMovement(TodayList.GetNodeData(TodayList.FocusedNode)^);
  xForm := TCMovementForm.Create(Nil);
  xDataGid := xForm.ShowDataobject(coEdit, BaseMovementProxy, xBase, True);
  if xDataGid <> CEmptyDataGid then begin
    SendMessageToFrames(TCMovementFrame, WM_DATAOBJECTEDITED, Integer(@xDataGid), 0);
  end;
  xForm.Free;
end;

procedure TCMovementFrame.ActionDelMovementExecute(Sender: TObject);
var xBase: TBaseMovement;
    xObject: TDataObject;
    xAccount: TAccount;
    xDone: TPlannedDone;
    xIdTemp1, xIdTemp2, xIdTemp3: TDataGid;
    xIdTemp3Frame: TCBaseFrameClass;
begin
  if ShowInfo(itQuestion, 'Czy chcesz usun¹æ wybran¹ operacjê ?', '') then begin
    xBase := TBaseMovement(TodayList.GetNodeData(TodayList.FocusedNode)^);
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
    if TBaseMovement(xObject).idPlannedDone <> CEmptyDataGid then begin
      xDone := TPlannedDone(TPlannedDone.LoadObject(PlannedDoneProxy, TBaseMovement(xObject).idPlannedDone, False));
      xDone.DeleteObject;
    end;
    xObject.DeleteObject;
    GDataProvider.CommitTransaction;
    SendMessageToFrames(TCMovementFrame, WM_DATAOBJECTDELETED, Integer(@xIdTemp1), 0);
    SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTEDITED, Integer(@xIdTemp2), 0);
    if (xIdTemp3 <> CEmptyDataGid) and (xIdTemp3Frame <> Nil) then begin
      SendMessageToFrames(xIdTemp3Frame, WM_DATAOBJECTEDITED, Integer(@xIdTemp3), 0);
    end;
    if TBaseMovement(xObject).idPlannedDone > CEmptyDataGid then begin
      SendMessageToFrames(TCDoneFrame, WM_DATAREFRESH, 0, 0);
    end;
  end;
end;

constructor TCMovementFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTodayObjects := Nil;
  FSumObjects := TSumList.Create(True);
end;

procedure TCMovementFrame.TodayListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
begin
  CButtonEdit.Enabled := Node <> Nil;
  CButtonDel.Enabled := Node <> Nil;
  if Owner.InheritsFrom(TCFrameForm) then begin
    TCFrameForm(Owner).BitBtnOk.Enabled := (Node <> Nil) or (MultipleChecks <> Nil);
  end;
end;

procedure TCMovementFrame.ReloadToday;
var xSql: String;
    xDf, xDt: TDateTime;
begin
  xSql := 'select * from baseMovement where ';
  GetFilterDates(xDf, xDt);
  xSql := xSql + Format('regDate between %s and %s', [DatetimeToDatabase(xDf, False), DatetimeToDatabase(xDt, False)]);
  if CStaticFilter.DataId = '2' then begin
    xSql := xSql + Format(' and movementType = ''%s''', [COutMovement]);
  end else if CStaticFilter.DataId = '3' then begin
    xSql := xSql + Format(' and movementType = ''%s''', [CInMovement]);
  end else if CStaticFilter.DataId = '4' then begin
    xSql := xSql + ' and movementType = ''' + CTransferMovement + '''';
  end;
  if FTodayObjects <> Nil then begin
    FreeAndNil(FTodayObjects);
  end;
  FTodayObjects := TDataObject.GetList(TBaseMovement, BaseMovementProxy, xSql);
  TodayList.BeginUpdate;
  TodayList.Clear;
  TodayList.RootNodeCount := FTodayObjects.Count;
  TodayListFocusChanged(TodayList, TodayList.FocusedNode, 0);
  TodayList.EndUpdate;
end;

procedure TCMovementFrame.InitializeFrame(AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList);
begin
  inherited InitializeFrame(AAdditionalData, AOutputData, AMultipleCheck);
  UpdateCustomPeriod;
  CDateTimePerStart.Value := GWorkDate;
  CDateTimePerEnd.Value := GWorkDate;
  Label3.Anchors := [akRight, akTop];
  CDateTimePerStart.Anchors := [akRight, akTop];
  Label4.Anchors := [akRight, akTop];
  CDateTimePerEnd.Anchors := [akRight, akTop];
  Label5.Anchors := [akRight, akTop];
  ReloadToday;
  ReloadSums;
end;

destructor TCMovementFrame.Destroy;
begin
  FTodayObjects.Free;
  FSumObjects.Free;
  inherited Destroy;
end;

procedure TCMovementFrame.TodayListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  TDataObject(TodayList.GetNodeData(Node)^) := FTodayObjects.Items[Node.Index];
  if MultipleChecks <> Nil then begin
    Node.CheckType := ctCheckBox;
    Node.CheckState := csCheckedNormal;
  end;
end;

procedure TCMovementFrame.TodayListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TDataObject);
end;

procedure TCMovementFrame.TodayListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var xData: TBaseMovement;
begin
  xData := TBaseMovement(TodayList.GetNodeData(Node)^);
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
    end else begin
      CellText := 'Transfer';
    end;
  end;
end;

procedure TCMovementFrame.TodayListHeaderClick(Sender: TVTHeader; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
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

procedure TCMovementFrame.TodayListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var xData1: TBaseMovement;
    xData2: TBaseMovement;
begin
  xData1 := TBaseMovement(TodayList.GetNodeData(Node1)^);
  xData2 := TBaseMovement(TodayList.GetNodeData(Node2)^);
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

procedure TCMovementFrame.TodayListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
var xData: TBaseMovement;
begin
  xData := TBaseMovement(TodayList.GetNodeData(Node)^);
  HintText := xData.description;
  LineBreakStyle := hlbForceMultiLine;
end;

procedure TCMovementFrame.TodayListBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
var xBase: TBaseMovement;
    xColor: TColor;
begin
  xBase := TBaseMovement(TodayList.GetNodeData(Node)^);
  with TargetCanvas do begin
    if not Odd(Node.Index) then begin
      ItemColor := clWindow;
    end else begin
      ItemColor := GetHighLightColor(clWindow, -10);
    end;
    FindFontAndBackground(xBase, Nil, xColor);
    if xColor <> clWindow then begin
      ItemColor := xColor;
    end;
    EraseAction := eaColor;
  end;
end;

procedure TCMovementFrame.MessageMovementAdded(AId: TDataGid);
var xDataobject: TBaseMovement;
    xNode: PVirtualNode;
begin
  xDataobject := TBaseMovement(TBaseMovement.LoadObject(BaseMovementProxy, AId, True));
  if IsValidFilteredObject(xDataobject) then begin
    FTodayObjects.Add(xDataobject);
    xNode := TodayList.AddChild(Nil, xDataobject);
    TodayList.Sort(xNode, TodayList.Header.SortColumn, TodayList.Header.SortDirection);
    TodayList.FocusedNode := xNode;
    TodayList.Selected[xNode] := True;
  end else begin
    xDataobject.Free;
  end;
  ReloadSums;
end;

procedure TCMovementFrame.MessageMovementDeleted(AId: TDataGid);
var xNode: PVirtualNode;
begin
  xNode := FindDataobjectNode(AId, TodayList);
  if xNode <> Nil then begin
    TodayList.DeleteNode(xNode);
    FTodayObjects.Remove(TBaseMovement(TodayList.GetNodeData(xNode)^));
  end;
  ReloadSums;
end;

procedure TCMovementFrame.MessageMovementEdited(AId: TDataGid);
var xDataobject: TBaseMovement;
    xNode: PVirtualNode;
begin
  xNode := FindDataobjectNode(AId, TodayList);
  if xNode <> Nil then begin
    xDataobject := TBaseMovement(TodayList.GetNodeData(xNode)^);
    xDataobject.ReloadObject;
    if IsValidFilteredObject(xDataobject) then begin
      TodayList.InvalidateNode(xNode);
      TodayList.Sort(xNode, TodayList.Header.SortColumn, TodayList.Header.SortDirection);
    end else begin
      TodayList.DeleteNode(xNode);
      FTodayObjects.Remove(TBaseMovement(TodayList.GetNodeData(xNode)^));
    end;
  end;
  ReloadSums;
end;

function TCMovementFrame.GetList: TVirtualStringTree;
begin
  Result := TodayList;
end;

procedure TCMovementFrame.WndProc(var Message: TMessage);
var xDataGid: TDataGid;
begin
  inherited WndProc(Message);
  with Message do begin
    if Msg = WM_DATAOBJECTADDED then begin
      xDataGid := PDataGid(WParam)^;
      MessageMovementAdded(xDataGid);
    end else if Msg = WM_DATAOBJECTEDITED then begin
      xDataGid := PDataGid(WParam)^;
      MessageMovementEdited(xDataGid);
    end else if Msg = WM_DATAOBJECTDELETED then begin
      xDataGid := PDataGid(WParam)^;
      MessageMovementDeleted(xDataGid);
    end;
  end;
end;

class function TCMovementFrame.GetTitle: String;
begin
  Result := 'Na dziœ';
end;

function TCMovementFrame.IsValidFilteredObject(AObject: TDataObject): Boolean;
var xOt, xFt: String;
    xDf, xDt: TDateTime;
begin
  xOt := TBaseMovement(AObject).movementType;
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
    Result := (xDf <= TBaseMovement(AObject).regDate) and (TBaseMovement(AObject).regDate <= xDt);
  end;
end;

procedure TCMovementFrame.CStaticFilterGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
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

procedure TCMovementFrame.CStaticFilterChanged(Sender: TObject);
begin
  UpdateCustomPeriod;
  ReloadToday;
  ReloadSums;
end;

procedure TCMovementFrame.ReloadSums;
var xDs: TADOQuery;
    xSql: String;
    xObj: TSumElement;
    xOvr: TSumElement;
    xDf, xDt: TDateTime;
begin
  GetFilterDates(xDf, xDt);
  xSql := Format('select v.*, a.name from ' +
                 ' (select idAccount, sum(income) as incomes, sum(expense) as expenses from balances where ' +
                 '   movementType <> ''%s'' and ' +
                 '   regDate between %s and %s group by idAccount) as v ' +
                 '   left outer join account a on a.idAccount = v.idAccount',
       [CTransferMovement, DatetimeToDatabase(xDf, False), DatetimeToDatabase(xDt, False)]);
  xDs := GDataProvider.OpenSql(xSql);
  SumList.BeginUpdate;
  SumList.Clear;
  FSumObjects.Clear;
  xOvr := TSumElement.Create;
  xOvr.name := 'Razem dla wszystkich kont';
  xOvr.cashIn := 0;
  xOvr.cashOut := 0;
  xOvr.id := '*';
  while not xDs.Eof do begin
    xObj := FSumObjects.FindSumObject(xDs.FieldByName('idAccount').AsString, True);
    xObj.id := xDs.FieldByName('idAccount').AsString;
    xObj.name := xDs.FieldByName('name').AsString;
    xObj.cashIn := xObj.cashIn + xDs.FieldByName('incomes').AsCurrency;
    xOvr.cashIn := xOvr.cashIn + xObj.cashIn;
    xObj.cashOut := xObj.cashOut + xDs.FieldByName('expenses').AsCurrency;
    xOvr.cashOut := xOvr.cashOut + xObj.cashOut;
    xDs.Next;
  end;
  FSumObjects.Add(xOvr);
  SumList.RootNodeCount := FSumObjects.Count;
  SumList.EndUpdate;
  GTodayCashIn := xOvr.cashIn;
  GTodayCashOut := xOvr.cashOut;
  xDs.Free;
end;

procedure TCMovementFrame.SumListBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
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

procedure TCMovementFrame.SumListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
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

procedure TCMovementFrame.SumListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TSumElement);
end;

procedure TCMovementFrame.SumListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
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

procedure TCMovementFrame.SumListHeaderClick(Sender: TVTHeader; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
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

procedure TCMovementFrame.SumListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  TSumElement(SumList.GetNodeData(Node)^) := TSumElement(FSumObjects.Items[Node.Index]);
end;

procedure TCMovementFrame.CStaticPeriodGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
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

procedure TCMovementFrame.GetFilterDates(var ADateFrom, ADateTo: TDateTime);
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
    ADateFrom := CDateTimePerStart.Value;
    ADateTo := CDateTimePerEnd.Value;
  end;
end;

procedure TCMovementFrame.UpdateCustomPeriod;
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

procedure TCMovementFrame.CDateTimePerStartChanged(Sender: TObject);
begin
  ReloadToday;
  ReloadSums;
end;

procedure TCMovementFrame.TodayListDblClick(Sender: TObject);
begin
  ActionEditMovement.Execute;
end;

procedure TCMovementFrame.FindFontAndBackground(AMovement: TBaseMovement; AFont: TFont; var ABackground: TColor);
var xKey: String;
    xPref: TFontPreference;
begin
  xKey := AMovement.movementType;
  if AMovement.idPlannedDone <> CEmptyDataGid then begin
    xKey := 'C' + xKey;
  end;
  xPref := GFontpreferences.FindFontPreference('baseMovement', xKey);
  if xPref <> Nil then begin
    ABackground := xPref.Background;
    if AFont <> Nil then begin
      AFont.Assign(xPref.Font);
    end;
  end;
end;

procedure TCMovementFrame.TodayListPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType);
var xBase: TBaseMovement;
    xColor: TColor;
begin
  xBase := TBaseMovement(TodayList.GetNodeData(Node)^);
  FindFontAndBackground(xBase, TargetCanvas.Font, xColor);
end;

end.
