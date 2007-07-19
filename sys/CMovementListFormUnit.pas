unit CMovementListFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, CComponents,
  ComCtrls, VirtualTrees, ActnList, XPStyleActnCtrls, ActnMan, Contnrs,
  CMovmentListElementFormUnit, CDatabase, CBaseFrameUnit, CTools,
  CMovementStateFormUnit;

type
  TCMovementListForm = class(TCDataobjectForm)
    GroupBox4: TGroupBox;
    Label15: TLabel;
    Label16: TLabel;
    CDateTime1: TCDateTime;
    ComboBox1: TComboBox;
    GroupBox2: TGroupBox;
    RichEditDesc: TCRichEdit;
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
    MovementList: TCList;
    ActionManager: TActionManager;
    ActionAdd: TAction;
    ActionTemplate: TAction;
    CButton1: TCButton;
    CButton2: TCButton;
    ComboBoxTemplate: TComboBox;
    Label17: TLabel;
    CStaticCurrency: TCStatic;
    Label21: TLabel;
    CCurrEditCash: TCCurrEdit;
    Panel: TPanel;
    Label8: TLabel;
    CStaticViewCurrency: TCStatic;
    ActionManagerStates: TActionManager;
    ActionStateOnce: TAction;
    CButtonStateOnce: TCButton;
    procedure CStaticInoutOnceAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticInoutOnceCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure Action1Execute(Sender: TObject);
    procedure MovementListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure MovementListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure MovementListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure MovementListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure MovementListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
    procedure MovementListDblClick(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
    procedure Action3Execute(Sender: TObject);
    procedure MovementListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure ActionAddExecute(Sender: TObject);
    procedure ActionTemplateExecute(Sender: TObject);
    procedure CDateTime1Changed(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure CStaticInoutOnceAccountChanged(Sender: TObject);
    procedure CStaticInoutOnceCashpointChanged(Sender: TObject);
    procedure ComboBoxTemplateChange(Sender: TObject);
    procedure CStaticCurrencyChanged(Sender: TObject);
    procedure CStaticCurrencyGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticViewCurrencyGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticViewCurrencyChanged(Sender: TObject);
    procedure ActionStateOnceExecute(Sender: TObject);
  private
    Fmovements: TObjectList;
    Fdeleted: TObjectList;
    Fmodified: TObjectList;
    Fadded: TObjectList;
    FbaseAccount: TDataGid;
    FbaseCashpoint: TDataGid;
    FbaseDate: TDateTime;
    FprevSums: TSumList;
    FonceState: TMovementStateRecord;
    procedure MessageMovementAdded(AData: TMovementListElement);
    procedure MessageMovementEdited(AData: TMovementListElement);
    procedure MessageMovementDeleted(AData: TMovementListElement);
    function FindNodeByData(AData: TMovementListElement): PVirtualNode;
    function GetCash: Currency;
    procedure UpdateButtons;
    procedure ChooseState(AStateRecord: TMovementStateRecord; AAction: TAction; AButton: TCButton);
    procedure UpdateState(AStateRecord: TMovementStateRecord; AAction: TAction; AButton: TCButton);
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
    procedure UpdateDescription;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function ExpandTemplate(ATemplate: String): String; override;
  end;

implementation

uses CFrameFormUnit, CAccountsFrameUnit, CCashpointsFrameUnit, CConfigFormUnit,
     CBaseFormUnit, CConsts, GraphUtil, CInfoFormUnit, Math,
  CDataObjects, StrUtils, CMovementFrameUnit, CPreferences, CTemplates,
  CDescpatternFormUnit, CRichtext, CDataobjectFrameUnit,
  CCurrencydefFrameUnit, CSurpassedFormUnit, CListFrameUnit;

{$R *.dfm}

constructor TCMovementListForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Fadded := TObjectList.Create(False);
  Fmovements := TObjectList.Create(True);
  Fmodified := TObjectList.Create(False);
  Fdeleted := TObjectList.Create(True);
  FprevSums := TSumList.Create(True);
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
  AAccepted := TCFrameForm.ShowFrame(TCCashpointsFrame, ADataGid, AText, TCDataobjectFrameData.CreateWithFilter(xCt));
end;

destructor TCMovementListForm.Destroy;
begin
  FonceState.Free;
  Fadded.Free;
  Fdeleted.Free;
  Fmodified.Free;
  Fmovements.Free;
  FprevSums.Free;
  inherited Destroy;
end;

procedure TCMovementListForm.Action1Execute(Sender: TObject);
var xForm: TCMovmentListElementForm;
    xElement: TMovementListElement;
begin
  if CStaticInoutOnceAccount.DataId = CEmptyDataGid then begin
    if ShowInfo(itQuestion, 'Nie wybrano konta operacji. Czy wyœwietliæ listê teraz ?', '') then begin
      CStaticInoutOnceAccount.DoGetDataId;
    end;
  end else if CStaticInoutOnceCashpoint.DataId = CEmptyDataGid then begin
    if ShowInfo(itQuestion, 'Nie wybrano kontrahenta operacji. Czy wyœwietliæ listê teraz ?', '') then begin
      CStaticInoutOnceCashpoint.DoGetDataId;
    end;
  end else begin
    xElement := TMovementListElement.Create;
    xElement.isNew := True;
    xElement.movementType := IfThen(ComboBox1.ItemIndex = 0, COutMovement, CInMovement);
    xElement.idAccountCurrencyDef := CStaticCurrency.DataId;
    xElement.idMovementCurrencyDef := CCurrencyDefGid_PLN;
    xElement.dateTime := CDateTime1.Value;
    xElement.idCashpoint := CStaticInoutOnceCashpoint.DataId;
    xElement.idAccount := CStaticInoutOnceAccount.DataId;
    xForm := TCMovmentListElementForm.CreateFormElement(Application, xElement);
    if xForm.ShowConfig(coAdd) then begin
      Perform(WM_DATAOBJECTADDED, Integer(xElement), 0);
      UpdateButtons;
    end else begin
      xElement.Free;
    end;
    xForm.Free;
  end;
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
    MovementList.BeginUpdate;
    if Fmodified.IndexOf(AData) <> -1 then begin
      Fmodified.Remove(AData);
    end;
    if Fadded.IndexOf(AData) <> -1 then begin
      Fadded.Remove(AData);
    end;
    xData := TMovementListElement(Fmovements.Extract(AData));
    if not xData.isNew then begin
      Fdeleted.Add(xData);
    end;
    MovementList.DeleteNode(xNode);
    MovementList.EndUpdate;
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
  FonceState := TMovementStateRecord.Create(CEmptyDataGid, False, CEmptyDataGid);
  CCurrEditCash.Value := GetCash;
  CDateTime1.Value := GWorkDate;
  if Operation = coAdd then begin
    CCurrEditCash.SetCurrencyDef(CEmptyDataGid, '');
  end;
  MovementListFocusChanged(MovementList, MovementList.FocusedNode, 0);
  FbaseAccount := CEmptyDataGid;
  FbaseCashpoint := CEmptyDataGid;
  FbaseDate := 0;
  if Operation = coAdd then begin
    if GActiveProfileId <> CEmptyDataGid then begin
      GDataProvider.BeginTransaction;
      xProfile := TProfile(TProfile.LoadObject(ProfileProxy, GActiveProfileId, False));
      Caption := Caption + ' - ' + xProfile.name;
      if xProfile.idAccount <> CEmptyDataGid then begin
        CStaticInoutOnceAccount.DataId := xProfile.idAccount;
        CStaticInoutOnceAccount.Caption := TAccount(TAccount.LoadObject(AccountProxy, xProfile.idAccount, False)).name;
      end;
      if xProfile.idCashPoint <> CEmptyDataGid then begin
        CStaticInoutOnceCashpoint.DataId := xProfile.idCashPoint;
        CStaticInoutOnceCashpoint.Caption := TCashPoint(TCashPoint.LoadObject(CashPointProxy, xProfile.idCashPoint, False)).name;
      end;
      GDataProvider.RollbackTransaction;
    end;
  end;
  UpdateState(FonceState, ActionStateOnce, CButtonStateOnce);
  CButtonStateOnce.Enabled := False;
  UpdateDescription;
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
    if CStaticViewCurrency.DataId = CCurrencyViewMovements then begin
      CellText := CurrencyToString(xData.movementCash, '', False);
    end else begin
      CellText := CurrencyToString(xData.cash, '', False);
    end;
  end else if Column = 3 then begin
    if CStaticViewCurrency.DataId = CCurrencyViewMovements then begin
      CellText := GCurrencyCache.GetSymbol(xData.idMovementCurrencyDef);
    end else begin
      CellText := GCurrencyCache.GetSymbol(xData.idAccountCurrencyDef);
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
      UpdateButtons;
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
    UpdateButtons;
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
var xSums: TSumList;
    xCount: Integer;
    xElement: TMovementListElement;
    xSum: TSum;
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
  if Result then begin
    xSums := TSumList.Create(True);
    for xCount := 0 to Fmovements.Count - 1 do begin
      xElement := TMovementListElement(Fmovements.Items[xCount]);
      xSums.AddSum(xElement.productId, xElement.movementCash, xElement.idMovementCurrencyDef);
    end;
    if Operation = coEdit then begin
      for xCount := 0 to xSums.Count - 1 do begin
        xSum := FprevSums.ByNameCurrency[xSums.Items[xCount].name, xSums.Items[xCount].currency];
        if xSum <> Nil then begin
          xSums.AddSum(xSums.Items[xCount].name, (-1) * xSum.value, xSums.Items[xCount].currency);
        end;
      end;
    end;
    Result := CheckSurpassedLimits(IfThen(ComboBox1.ItemIndex = 0, COutMovement, CInMovement), CDateTime1.Value,
                                   TDataGids.CreateFromGid(CStaticInoutOnceAccount.DataId),
                                   TDataGids.CreateFromGid(CStaticInoutOnceCashpoint.DataId),
                                   xSums);
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
    ComboBoxTemplate.ItemIndex := IfThen(Operation = coEdit, 0, 1);
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
    SimpleRichText(description, RichEditDesc);
    ComboBox1.ItemIndex := IfThen(movementType = COutMovement, 0, 1);
    CStaticCurrency.DataId := idAccountCurrencyDef;
    CStaticCurrency.Caption := TCurrencyDef(TCurrencyDef.LoadObject(CurrencyDefProxy, idAccountCurrencyDef, False)).GetElementText;
    CCurrEditCash.SetCurrencyDef(idAccountCurrencyDef, GCurrencyCache.GetSymbol(idAccountCurrencyDef));
    FonceState.AccountId := idAccount;
    FonceState.ExtrId := idExtractionItem;
    FonceState.Stated := isStated;
    UpdateState(FonceState, ActionStateOnce, CButtonStateOnce);
    CButtonStateOnce.Enabled := idAccount <> CEmptyDataGid;
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
      xElement.idAccountCurrencyDef := idAccountCurrencyDef;
      xElement.idMovementCurrencyDef := xMovement.idMovementCurrencyDef;
      xElement.movementCash := xMovement.movementCash;
      xElement.idCurrencyRate := xMovement.idCurrencyRate;
      xElement.currencyQuantity := xMovement.currencyQuantity;
      xElement.currencyRate := xMovement.currencyRate;
      xElement.rateDescription := xMovement.rateDescription;
      xElement.dateTime := xMovement.regDate;
      xElement.idCashpoint := xMovement.idCashPoint;
      xElement.idAccount := xMovement.idAccount;
      Fmovements.Add(xElement);
      FprevSums.AddSum(xMovement.idProduct, xMovement.movementCash, xMovement.idMovementCurrencyDef);
    end;
    xList.Free;
    GDataProvider.RollbackTransaction;
    MovementList.RootNodeCount := Fmovements.Count;
    UpdateButtons;
  end;
end;

procedure TCMovementListForm.ReadValues;
begin
  inherited ReadValues;
  with TMovementList(Dataobject) do begin
    description := RichEditDesc.Text;
    idAccount := CStaticInoutOnceAccount.DataId;
    idCashPoint := CStaticInoutOnceCashpoint.DataId;
    idAccountCurrencyDef := CStaticCurrency.DataId;
    regDate := CDateTime1.Value;
    movementType := IfThen(ComboBox1.ItemIndex = 0, COutMovement, CInMovement);
    idAccountCurrencyDef := CStaticCurrency.DataId;
    isStated := FonceState.Stated;
    idExtractionItem := FonceState.ExtrId;
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
      xMovement.movementCash := movementCash;
      xMovement.movementType := movementType;
      xMovement.idAccount := CStaticInoutOnceAccount.DataId;
      xMovement.regDate := CDateTime1.Value;
      xMovement.idCashPoint := CStaticInoutOnceCashpoint.DataId;
      xMovement.idProduct := productId;
      xMovement.idMovementList := Dataobject.id;
      xMovement.idAccountCurrencyDef := CStaticCurrency.DataId;
      xMovement.idMovementCurrencyDef := idMovementCurrencyDef;
      xMovement.currencyQuantity := currencyQuantity;
      xMovement.currencyRate := currencyRate;
      xMovement.idCurrencyRate := idCurrencyRate;
      xMovement.rateDescription := rateDescription;
    end;
  end;
  for xCount := 0 to Fmodified.Count - 1 do begin
    with TMovementListElement(Fmodified.Items[xCount]) do begin
      xMovement := TBaseMovement(TBaseMovement.LoadObject(BaseMovementProxy, id, False));
      xMovement.description := description;
      xMovement.cash := cash;
      xMovement.movementCash := movementCash;
      xMovement.movementType := movementType;
      xMovement.idAccount := CStaticInoutOnceAccount.DataId;
      xMovement.regDate := CDateTime1.Value;
      xMovement.idCashPoint := CStaticInoutOnceCashpoint.DataId;
      xMovement.idProduct := productId;
      xMovement.idMovementList := Dataobject.id;
      xMovement.idAccountCurrencyDef := CStaticCurrency.DataId;
      xMovement.idMovementCurrencyDef := idMovementCurrencyDef;
      xMovement.currencyQuantity := currencyQuantity;
      xMovement.currencyRate := currencyRate;
      xMovement.idCurrencyRate := idCurrencyRate;
      xMovement.rateDescription := rateDescription;
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

procedure TCMovementListForm.ActionAddExecute(Sender: TObject);
var xData: TObjectList;
begin
  xData := TObjectList.Create(False);
  xData.Add(GBaseTemlatesList);
  xData.Add(GMovementListTemplatesList);
  EditAddTemplate(xData, Self, RichEditDesc, True);
  xData.Free;
end;

procedure TCMovementListForm.ActionTemplateExecute(Sender: TObject);
var xPattern: String;
begin
  if EditDescPattern(CDescPatternsKeys[1][ComboBox1.ItemIndex], xPattern) then begin
    UpdateDescription;
  end;
end;

procedure TCMovementListForm.UpdateDescription;
var xDesc: String;
begin
  if ComboBoxTemplate.ItemIndex = 1 then begin
    xDesc := GDescPatterns.GetPattern(CDescPatternsKeys[1][ComboBox1.ItemIndex], '');
    if xDesc <> '' then begin
      xDesc := GBaseTemlatesList.ExpandTemplates(xDesc, Self);
      xDesc := GMovementListTemplatesList.ExpandTemplates(xDesc, Self);
      SimpleRichText(xDesc, RichEditDesc);
    end;
  end;
end;

procedure TCMovementListForm.CDateTime1Changed(Sender: TObject);
begin
  UpdateDescription;
end;

procedure TCMovementListForm.ComboBox1Change(Sender: TObject);
begin
  UpdateDescription;
end;

procedure TCMovementListForm.CStaticInoutOnceAccountChanged(Sender: TObject);
var xCurrencyId: TDataGid;
begin
  if CStaticInoutOnceAccount.DataId <> CEmptyDataGid then begin
    xCurrencyId := TAccount.GetCurrencyDefinition(CStaticInoutOnceAccount.DataId);
    CStaticCurrency.DataId := xCurrencyId;
    CStaticCurrency.Caption := GCurrencyCache.GetIso(xCurrencyId);
    CCurrEditCash.SetCurrencyDef(xCurrencyId, GCurrencyCache.GetSymbol(xCurrencyId));
  end else begin
    CStaticCurrency.DataId := CEmptyDataGid;
    CCurrEditCash.SetCurrencyDef(CEmptyDataGid, '');
  end;
  CButtonStateOnce.Enabled := CStaticInoutOnceAccount.DataId <> CEmptyDataGid;
  FonceState.AccountId := CStaticInoutOnceAccount.DataId;
  UpdateState(FonceState, ActionStateOnce, CButtonStateOnce);
  UpdateDescription;
end;

procedure TCMovementListForm.CStaticInoutOnceCashpointChanged(Sender: TObject);
begin
  UpdateDescription;
end;

function TCMovementListForm.ExpandTemplate(ATemplate: String): String;
begin
  Result := inherited ExpandTemplate(ATemplate);
  if ATemplate = '@dataoperacji@' then begin
    Result := GetFormattedDate(CDateTime1.Value, 'yyyy-MM-dd');
  end else if ATemplate = '@rodzaj@' then begin
    Result := ComboBox1.Text;
  end else if ATemplate = '@kontozrodlowe@' then begin
    Result := '<konto Ÿród³owe>';
    if CStaticInoutOnceAccount.DataId <> CEmptyDataGid then begin
      Result := CStaticInoutOnceAccount.Caption;
    end;
  end else if ATemplate = '@kontrahent@' then begin
    Result := '<kontrahent>';
    if CStaticInoutOnceCashpoint.DataId <> CEmptyDataGid then begin
      Result := CStaticInoutOnceCashpoint.Caption;
    end;
  end else if ATemplate = '@isowalutykonta@' then begin
    Result := '<iso waluty konta>';
    if CStaticCurrency.DataId <> CEmptyDataGid then begin
      Result := GCurrencyCache.GetIso(CStaticCurrency.DataId);
    end;
  end else if ATemplate = '@symbolwalutykonta@' then begin
    Result := '<symbol waluty konta>';
    if CStaticCurrency.DataId <> CEmptyDataGid then begin
      Result := GCurrencyCache.GetSymbol(CStaticCurrency.DataId);
    end;
  end;
end;

procedure TCMovementListForm.ComboBoxTemplateChange(Sender: TObject);
begin
  UpdateDescription;
end;

procedure TCMovementListForm.CStaticCurrencyChanged(Sender: TObject);
begin
  CCurrEditCash.SetCurrencyDef(CStaticCurrency.DataId, GCurrencyCache.GetSymbol(CStaticCurrency.DataId));
end;

procedure TCMovementListForm.CStaticCurrencyGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCCurrencydefFrame, ADataGid, AText);
end;

procedure TCMovementListForm.UpdateButtons;
begin
  CDateTime1.Enabled := (Fmovements.Count = 0) and (Operation = coAdd);
  ComboBox1.Enabled := (Fmovements.Count = 0) and (Operation = coAdd);
  CStaticInoutOnceAccount.Enabled := Fmovements.Count = 0;
  CStaticInoutOnceCashpoint.Enabled := Fmovements.Count = 0;
end;

procedure TCMovementListForm.CStaticViewCurrencyGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ShowCurrencyViewType(ADataGid, AText);
end;

procedure TCMovementListForm.CStaticViewCurrencyChanged(Sender: TObject);
begin
  MovementList.Repaint;
end;

procedure TCMovementListForm.ChooseState(AStateRecord: TMovementStateRecord; AAction: TAction; AButton: TCButton);
begin
  if ShowMovementState(AStateRecord) then begin
    UpdateState(AStateRecord, AAction, AButton);
  end;
end;

procedure TCMovementListForm.UpdateState(AStateRecord: TMovementStateRecord; AAction: TAction; AButton: TCButton);
begin
  AAction.ImageIndex := IfThen(AStateRecord.Stated, 0, 1);
  AAction.Caption := IfThen(AStateRecord.Stated, 'Uzgodniona', 'Do uzgodnienia');
  AButton.Action := AAction;
  AButton.Enabled := AStateRecord.AccountId <> CEmptyDataGid;
end;

procedure TCMovementListForm.ActionStateOnceExecute(Sender: TObject);
begin
  ChooseState(FonceState, ActionStateOnce, CButtonStateOnce);
end;

end.