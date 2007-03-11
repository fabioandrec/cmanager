unit CMovementListFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, CComponents,
  ComCtrls, VirtualTrees, ActnList, XPStyleActnCtrls, ActnMan, Contnrs,
  CMovmentListElementFormUnit, CDatabase, CBaseFrameUnit;

type
  TCMovementListForm = class(TCDataobjectForm)
    GroupBox4: TGroupBox;
    Label15: TLabel;
    Label16: TLabel;
    CDateTime1: TCDateTime;
    ComboBox1: TComboBox;
    GroupBox2: TGroupBox;
    RichEditDesc: TRichEdit;
    Label4: TLabel;
    CStaticInoutOnceAccount: TCStatic;
    Label2: TLabel;
    CStaticInoutOnceCashpoint: TCStatic;
    ActionManager1: TActionManager;
    Action1: TAction;
    Action2: TAction;
    Action3: TAction;
    GroupBox1: TGroupBox;
    Panel1: TPanel;
    Bevel1: TBevel;
    Panel2: TPanel;
    CButtonOut: TCButton;
    CButtonEdit: TCButton;
    CButtonDel: TCButton;
    MovementList: TVirtualStringTree;
    Panel3: TPanel;
    Label6: TLabel;
    CCurrEditCash: TCCurrEdit;
    procedure CStaticInoutOnceAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticInoutOnceCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure Action1Execute(Sender: TObject);
    procedure MovementListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure MovementListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure MovementListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure MovementListHeaderClick(Sender: TVTHeader; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MovementListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure MovementListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
    procedure MovementListBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
    procedure MovementListDblClick(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
    procedure Action3Execute(Sender: TObject);
    procedure MovementListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
  private
    Fmovements: TObjectList;
    Fdeleted: TObjectList;
    Fmodified: TObjectList;
    Fadded: TObjectList;
    FbaseAccount: TDataGid;
    FbaseCashpoint: TDataGid;
    FbaseDate: TDateTime;
    procedure MessageMovementAdded(AData: TMovementListElement);
    procedure MessageMovementEdited(AData: TMovementListElement);
    procedure MessageMovementDeleted(AData: TMovementListElement);
    function FindNodeByData(AData: TMovementListElement): PVirtualNode;
    function GetCash: Currency;
  protected
    procedure WndProc(var Message: TMessage); override;
    procedure InitializeForm; override;
    function CanAccept: Boolean; override;
    function GetDataobjectClass: TDataObjectClass; override;
    procedure FillForm; override;
    procedure ReadValues; override;
    procedure AfterCommitData; override;
    function GetUpdateFrameOption: Integer; override;
    function GetUpdateFrameClass: TCBaseFrameClass; override;
    procedure UpdateFrames(ADataGid: ShortString; AMessage: Integer; AOption: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

uses CFrameFormUnit, CAccountsFrameUnit, CCashpointsFrameUnit, CConfigFormUnit,
     CBaseFormUnit, CConsts, GraphUtil, CInfoFormUnit, Math,
  CDataObjects, StrUtils, CMovementFrameUnit;

{$R *.dfm}

constructor TCMovementListForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Fadded := TObjectList.Create(False);
  Fmovements := TObjectList.Create(True);
  Fmodified := TObjectList.Create(False);
  Fdeleted := TObjectList.Create(True);
end;

procedure TCMovementListForm.CStaticInoutOnceAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCAccountsFrame, ADataGid, AText);
end;

procedure TCMovementListForm.CStaticInoutOnceCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
var xCt: String;
begin
  if ComboBox1.ItemIndex = 0 then begin
    xCt := CCashpointTypeOut;
  end else begin
    xCt := CCashpointTypeIn;
  end;
  AAccepted := TCFrameForm.ShowFrame(TCCashpointsFrame, ADataGid, AText, TCashpointFrameAdditionalData.Create(xCt));
end;

destructor TCMovementListForm.Destroy;
begin
  Fadded.Free;
  Fdeleted.Free;
  Fmodified.Free;
  Fmovements.Free;
  inherited Destroy;
end;

procedure TCMovementListForm.Action1Execute(Sender: TObject);
var xForm: TCMovmentListElementForm;
    xElement: TMovementListElement;
begin
  xElement := TMovementListElement.Create;
  xElement.movementType := IfThen(ComboBox1.ItemIndex = 0, COutMovement, CInMovement);
  xForm := TCMovmentListElementForm.CreateFormElement(Application, xElement);
  if xForm.ShowConfig(coAdd) then begin
    Perform(WM_DATAOBJECTADDED, Integer(xElement), 0);
  end else begin
    xElement.Free;
  end;
  xForm.Free;
end;

procedure TCMovementListForm.WndProc(var Message: TMessage);
var xData: TMovementListElement;
begin
  inherited WndProc(Message);
  with Message do begin
    if Msg = WM_DATAOBJECTADDED then begin
      xData := TMovementListElement(WParam);
      MessageMovementAdded(xData);
    end else if Msg = WM_DATAOBJECTEDITED then begin
      xData := TMovementListElement(WParam);
      MessageMovementEdited(xData);
    end else if Msg = WM_DATAOBJECTDELETED then begin
      xData := TMovementListElement(WParam);
      MessageMovementDeleted(xData);
    end;
  end;
end;

procedure TCMovementListForm.MessageMovementAdded(AData: TMovementListElement);
var xNode: PVirtualNode;
begin
  Fmovements.Add(AData);
  Fadded.Add(AData);
  xNode := MovementList.AddChild(Nil, AData);
  MovementList.Sort(xNode, MovementList.Header.SortColumn, MovementList.Header.SortDirection);
  MovementList.FocusedNode := xNode;
  MovementList.Selected[xNode] := True;
  CCurrEditCash.Value := GetCash;
end;

procedure TCMovementListForm.MessageMovementDeleted(AData: TMovementListElement);
var xNode: PVirtualNode;
    xData: TMovementListElement;
begin
  xNode := FindNodeByData(AData);
  if xNode <> Nil then begin
    MovementList.DeleteNode(xNode);
    if Fmodified.IndexOf(AData) <> -1 then begin
      Fmodified.Remove(AData);
    end;
    if Fadded.IndexOf(AData) <> -1 then begin
      Fadded.Remove(AData);
    end;
    xData := TMovementListElement(Fmovements.Extract(AData));
    Fdeleted.Add(xData);
  end;
  CCurrEditCash.Value := GetCash;
end;

procedure TCMovementListForm.MessageMovementEdited(AData: TMovementListElement);
var xNode:  PVirtualNode;
begin
  if (Fmodified.IndexOf(AData) = -1) and (Fadded.IndexOf(AData) = -1) then begin
    Fmodified.Add(AData);
  end;
  xNode := FindNodeByData(AData);
  MovementList.InvalidateNode(xNode);
  MovementList.Sort(xNode, MovementList.Header.SortColumn, MovementList.Header.SortDirection);
  CCurrEditCash.Value := GetCash;
end;

procedure TCMovementListForm.InitializeForm;
var xProfile: TProfile;
begin
  inherited InitializeForm;
  CCurrEditCash.Value := GetCash;
  CDateTime1.Value := GWorkDate;
  MovementListFocusChanged(MovementList, MovementList.FocusedNode, 0);
  FbaseAccount := CEmptyDataGid;
  FbaseCashpoint := CEmptyDataGid;
  FbaseDate := 0;
  if Operation = coAdd then begin
    if GActiveProfileId <> CEmptyDataGid then begin
      GDataProvider.BeginTransaction;
      xProfile := TProfile(TProfile.LoadObject(ProfileProxy, GActiveProfileId, False));
      Caption := Caption + ' - ' + xProfile.name;
      CStaticInoutOnceAccount.DataId := xProfile.idAccount;
      CStaticInoutOnceAccount.Caption := TAccount(TAccount.LoadObject(AccountProxy, xProfile.idAccount, False)).name;
      CStaticInoutOnceCashpoint.DataId := xProfile.idCashPoint;
      CStaticInoutOnceCashpoint.Caption := TCashPoint(TCashPoint.LoadObject(CashPointProxy, xProfile.idCashPoint, False)).name;
      GDataProvider.RollbackTransaction;
    end;
  end;
end;

procedure TCMovementListForm.MovementListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TMovementListElement);
end;

procedure TCMovementListForm.MovementListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  TMovementListElement(MovementList.GetNodeData(Node)^) := TMovementListElement(Fmovements.Items[Node.Index]);
end;

procedure TCMovementListForm.MovementListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var xData: TMovementListElement;
begin
  xData := TMovementListElement(MovementList.GetNodeData(Node)^);
  if Column = 0 then begin
    CellText := IntToStr(Node.Index + 1);
  end else if Column = 1 then begin
    CellText := xData.description;
  end else if Column = 2 then begin
    CellText := CurrencyToString(xData.cash);
  end;
end;

procedure TCMovementListForm.MovementListHeaderClick(Sender: TVTHeader; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
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

procedure TCMovementListForm.MovementListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var xData1: TMovementListElement;
    xData2: TMovementListElement;
begin
  xData1 := TMovementListElement(MovementList.GetNodeData(Node1)^);
  xData2 := TMovementListElement(MovementList.GetNodeData(Node2)^);
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
    if xData1.cash > xData2.cash then begin
      Result := 1;
    end else if xData1.cash < xData2.cash then begin
      Result := -1;
    end else begin
      Result := 0;
    end;
  end;
end;

procedure TCMovementListForm.MovementListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
var xData: TMovementListElement;
begin
  xData := TMovementListElement(MovementList.GetNodeData(Node)^);
  HintText := xData.description;
  LineBreakStyle := hlbForceMultiLine;
end;

procedure TCMovementListForm.MovementListBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
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

procedure TCMovementListForm.MovementListDblClick(Sender: TObject);
begin
  Action2.Execute;
end;

procedure TCMovementListForm.Action2Execute(Sender: TObject);
var xForm: TCMovmentListElementForm;
    xElement: TMovementListElement;
begin
  if MovementList.FocusedNode <> Nil then begin
    xElement := TMovementListElement(MovementList.GetNodeData(MovementList.FocusedNode)^);
    xForm := TCMovmentListElementForm.CreateFormElement(Application, xElement);
    if xForm.ShowConfig(coEdit) then begin
      Perform(WM_DATAOBJECTEDITED, Integer(xElement), 0);
    end;
    xForm.Free;
  end;
end;

function TCMovementListForm.FindNodeByData(AData: TMovementListElement): PVirtualNode;
var xCurNode: PVirtualNode;
begin
  Result := Nil;
  xCurNode := MovementList.GetFirst;
  while (xCurNode <> Nil) and (Result = Nil) do begin
    if TMovementListElement(MovementList.GetNodeData(xCurNode)^) = AData then begin
      Result := xCurNode;
    end else begin
      xCurNode := MovementList.GetNextSibling(xCurNode);
    end;
  end;
end;

procedure TCMovementListForm.Action3Execute(Sender: TObject);
var xElement: TMovementListElement;
begin
  if ShowInfo(itQuestion, 'Czy chcesz usun¹æ wybran¹ operacjê ?', '') then begin
    xElement := TMovementListElement(MovementList.GetNodeData(MovementList.FocusedNode)^);
    Perform(WM_DATAOBJECTDELETED, Integer(xElement), 0);
  end;
end;

function TCMovementListForm.GetCash: Currency;
var xCount: Integer;
begin
  Result := 0;
  for xCount := 0 to Fmovements.Count - 1 do begin
    Result := Result + TMovementListElement(Fmovements.Items[xCount]).cash;
  end;
end;

function TCMovementListForm.CanAccept: Boolean;
begin
  Result := True;
  if CStaticInoutOnceAccount.DataId = CEmptyDataGid then begin
    Result := False;
    if ShowInfo(itQuestion, 'Nie wybrano konta operacji. Czy wyœwietliæ listê teraz ?', '') then begin
      CStaticInoutOnceAccount.DoGetDataId;
    end;
  end else if CStaticInoutOnceCashpoint.DataId = CEmptyDataGid then begin
    Result := False;
    if ShowInfo(itQuestion, 'Nie wybrano kontrahenta operacji. Czy wyœwietliæ listê teraz ?', '') then begin
      CStaticInoutOnceCashpoint.DoGetDataId;
    end;
  end;
end;

procedure TCMovementListForm.MovementListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
begin
  CButtonEdit.Enabled := Node <> Nil;
  CButtonDel.Enabled := Node <> Nil;
end;

function TCMovementListForm.GetDataobjectClass: TDataObjectClass;
begin
  Result := TmovementList;
end;

procedure TCMovementListForm.FillForm;
var xList: TDataObjectList;
    xCount: Integer;
    xElement: TMovementListElement;
    xMovement: TBaseMovement;
begin
  inherited FillForm;
  with TMovementList(Dataobject) do begin
    GDataProvider.BeginTransaction;
    CStaticInoutOnceAccount.DataId := idAccount;
    CStaticInoutOnceAccount.Caption := TAccount(TAccount.LoadObject(AccountProxy, idAccount, False)).name;
    FbaseAccount := idAccount;
    FbaseCashpoint := idCashPoint;
    FbaseDate := regDate;
    CStaticInoutOnceCashpoint.DataId := idCashPoint;
    CStaticInoutOnceCashpoint.Caption := TCashPoint(TCashPoint.LoadObject(CashPointProxy, idCashPoint, False)).name;
    CDateTime1.Value := regDate;
    CCurrEditCash.Value := cash;
    RichEditDesc.Text := description;
    ComboBox1.ItemIndex := IfThen(movementType = COutMovement, 0, 1);
    ComboBox1.Enabled := False;
    xList := GetMovements;
    Fmovements.Clear;
    for xCount := 0 to xList.Count - 1 do begin
      xElement := TMovementListElement.Create;
      xMovement := TBaseMovement(xList.Items[xCount]);
      xElement.id := xMovement.id;
      xElement.description := xMovement.description;
      xElement.productId := xMovement.idProduct;
      xElement.movementType := xMovement.movementType;
      xElement.cash := xMovement.cash;
      Fmovements.Add(xElement);
    end;
    xList.Free;
    GDataProvider.RollbackTransaction;
    MovementList.RootNodeCount := Fmovements.Count;
  end;
end;

procedure TCMovementListForm.ReadValues;
begin
  inherited ReadValues;
  with TMovementList(Dataobject) do begin
    description := RichEditDesc.Text;
    idAccount := CStaticInoutOnceAccount.DataId;
    idCashPoint := CStaticInoutOnceCashpoint.DataId;
    regDate := CDateTime1.Value;
    movementType := IfThen(ComboBox1.ItemIndex = 0, COutMovement, CInMovement);
  end;
end;

procedure TCMovementListForm.AfterCommitData;
var xCount: Integer;
    xMovement: TBaseMovement;
    xUpdate: String;
begin
  inherited AfterCommitData;
  GDataProvider.BeginTransaction;
  for xCount := 0 to Fadded.Count - 1 do begin
    with TMovementListElement(Fadded.Items[xCount]) do begin
      xMovement := TBaseMovement.CreateObject(BaseMovementProxy, False);
      xMovement.id := id;
      xMovement.description := description;
      xMovement.cash := cash;
      xMovement.movementType := movementType;
      xMovement.idAccount := CStaticInoutOnceAccount.DataId;
      xMovement.regDate := CDateTime1.Value;
      xMovement.idCashPoint := CStaticInoutOnceCashpoint.DataId;
      xMovement.idProduct := productId;
      xMovement.idMovementList := Dataobject.id;
    end;
  end;
  for xCount := 0 to Fmodified.Count - 1 do begin
    with TMovementListElement(Fmodified.Items[xCount]) do begin
      xMovement := TBaseMovement(TBaseMovement.LoadObject(BaseMovementProxy, id, False));
      xMovement.description := description;
      xMovement.cash := cash;
      xMovement.movementType := movementType;
      xMovement.idAccount := CStaticInoutOnceAccount.DataId;
      xMovement.regDate := CDateTime1.Value;
      xMovement.idCashPoint := CStaticInoutOnceCashpoint.DataId;
      xMovement.idProduct := productId;
      xMovement.idMovementList := Dataobject.id;
    end;
  end;
  for xCount := 0 to Fdeleted.Count - 1 do begin
    with TMovementListElement(Fdeleted.Items[xCount]) do begin
      xMovement := TBaseMovement(TBaseMovement.LoadObject(BaseMovementProxy, id, False));
      xMovement.DeleteObject;
    end;
  end;
  GDataProvider.CommitTransaction;
  if Operation = coEdit then begin
    xUpdate := '';
    if FbaseAccount <> CStaticInoutOnceAccount.DataId then begin
      xUpdate := xUpdate + 'idAccount = ' + DataGidToDatabase(CStaticInoutOnceAccount.DataId);
    end;
    if FbaseCashpoint <> CStaticInoutOnceCashpoint.DataId then begin
      if xUpdate <> '' then begin
        xUpdate := xUpdate + ', ';
      end;
      xUpdate := xUpdate + 'idCashpoint = ' + DataGidToDatabase(CStaticInoutOnceCashpoint.DataId);
    end;
    if FbaseDate <> CDateTime1.Value then begin
      if xUpdate <> '' then begin
        xUpdate := xUpdate + ', ';
      end;
      xUpdate := xUpdate + 'regDate = ' + DatetimeToDatabase(TMovementList(Dataobject).regDate, False) + ', ' +
                           'weekDate = ' + DatetimeToDatabase(TMovementList(Dataobject).weekDate, False) + ', ' +
                           'monthDate = ' + DatetimeToDatabase(TMovementList(Dataobject).monthDate, False) + ', ' +
                           'yearDate = ' + DatetimeToDatabase(TMovementList(Dataobject).yearDate, False);
    end;
    if xUpdate <> '' then begin
      GDataProvider.ExecuteSql('update baseMovement set ' + xUpdate + ' where idMovementList = ' + DataGidToDatabase(Dataobject.id));
    end;
  end;
end;

function TCMovementListForm.GetUpdateFrameOption: Integer;
begin
  Result := WMOPT_MOVEMENTLIST;
end;

function TCMovementListForm.GetUpdateFrameClass: TCBaseFrameClass;
begin
  Result := TCMovementFrame;
end;

procedure TCMovementListForm.UpdateFrames(ADataGid: ShortString; AMessage, AOption: Integer);
var xCount: Integer;
    xId: TDataGid;
begin
  inherited UpdateFrames(ADataGid, AMessage, AOption);
  xId := CStaticInoutOnceAccount.DataId;
  SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTEDITED, Integer(@xId), 0);
  if Operation = coEdit then begin
    if xId <> FbaseAccount then begin
      SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTEDITED, Integer(@FbaseAccount), 0);
    end;
  end;
  for xCount := 0 to Fadded.Count - 1 do begin
    xId := TMovementListElement(Fadded.Items[xCount]).id;
    SendMessageToFrames(TCMovementFrame, WM_DATAOBJECTADDED, Integer(@xId), WMOPT_BASEMOVEMENT);
  end;
  for xCount := 0 to Fmodified.Count - 1 do begin
    xId := TMovementListElement(Fmodified.Items[xCount]).id;
    SendMessageToFrames(TCMovementFrame, WM_DATAOBJECTEDITED, Integer(@xId), WMOPT_BASEMOVEMENT);
  end;
  for xCount := 0 to Fdeleted.Count - 1 do begin
    xId := TMovementListElement(Fdeleted.Items[xCount]).id;
    SendMessageToFrames(TCMovementFrame, WM_DATAOBJECTDELETED, Integer(@xId), WMOPT_BASEMOVEMENT);
  end;
end;

end.
