unit CAccountsFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, ImgList, ActnList, Menus, VTHeaderPopup,
  ExtCtrls, CComponents, VirtualTrees, CDatabase;

type
  TCAccountsFrame = class(TCBaseFrame)
    AccountList: TVirtualStringTree;
    VTHeaderPopupMenu: TVTHeaderPopupMenu;
    ActionList: TActionList;
    ActionAddAccount: TAction;
    ActionEditAccount: TAction;
    ActionDelAccount: TAction;
    PanelFrameButtons: TPanel;
    CButtonAddAccount: TCButton;
    CButtonEditAccount: TCButton;
    CButtonDelAccount: TCButton;
    procedure AccountListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure AccountListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure AccountListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure AccountListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure AccountListHeaderClick(Sender: TVTHeader; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure AccountListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure AccountListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
    procedure ActionAddAccountExecute(Sender: TObject);
    procedure ActionEditAccountExecute(Sender: TObject);
    procedure ActionDelAccountExecute(Sender: TObject);
    procedure AccountListBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
    procedure AccountListDblClick(Sender: TObject);
  private
    FAccountObjects: TDataObjectList;
    procedure ReloadAccounts;
    procedure MessageAccountAdded(AId: TDataGid);
    procedure MessageAccountEdited(AId: TDataGid);
    procedure MessageAccountDeleted(AId: TDataGid);
  protected
    procedure WndProc(var Message: TMessage); override;
    function GetSelectedId: TDataGid; override;
    function GetSelectedText: String; override;
    function GetList: TVirtualStringTree; override;
  public
    procedure InitializeFrame(AAdditionalData: TObject; AOutputData: Pointer); override;
    destructor Destroy; override;
    class function GetTitle: String; override;
  end;

implementation

uses CDataObjects, CAccountFormUnit, CConfigFormUnit, CInfoFormUnit, GraphUtil,
  CFrameFormUnit;

{$R *.dfm}

destructor TCAccountsFrame.Destroy;
begin
  FAccountObjects.Free;
  inherited;
end;

class function TCAccountsFrame.GetTitle: String;
begin
  Result := 'Konta';
end;

procedure TCAccountsFrame.InitializeFrame(AAdditionalData: TObject; AOutputData: Pointer);
begin
  inherited InitializeFrame(AAdditionalData, AOutputData);
  ReloadAccounts;
end;

procedure TCAccountsFrame.MessageAccountAdded(AId: TDataGid);
var xDataobject: TAccount;
    xNode: PVirtualNode;
begin
  xDataobject := TAccount(TAccount.LoadObject(AccountProxy, AId, True));
  FAccountObjects.Add(xDataobject);
  xNode := AccountList.AddChild(Nil, xDataobject);
  AccountList.Sort(xNode, AccountList.Header.SortColumn, AccountList.Header.SortDirection);
  AccountList.FocusedNode := xNode;
  AccountList.Selected[xNode] := True;
end;

procedure TCAccountsFrame.MessageAccountDeleted(AId: TDataGid);
var xNode: PVirtualNode;
begin
  xNode := FindDataobjectNode(AId, AccountList);
  if xNode <> Nil then begin
    AccountList.DeleteNode(xNode);
    FAccountObjects.Remove(TAccount(AccountList.GetNodeData(xNode)^));
  end;
end;

procedure TCAccountsFrame.MessageAccountEdited(AId: TDataGid);
var xDataobject: TAccount;
    xNode: PVirtualNode;
begin
  xNode := FindDataobjectNode(AId, AccountList);
  if xNode <> Nil then begin
    xDataobject := TAccount(AccountList.GetNodeData(xNode)^);
    xDataobject.ReloadObject;
    AccountList.InvalidateNode(xNode);
    AccountList.Sort(xNode, AccountList.Header.SortColumn, AccountList.Header.SortDirection);
  end;
end;

procedure TCAccountsFrame.ReloadAccounts;
begin
  FAccountObjects := TDataObject.GetList(TAccount, AccountProxy, 'select * from account');
  AccountList.BeginUpdate;
  AccountList.Clear;
  AccountList.RootNodeCount := FAccountObjects.Count;
  AccountListFocusChanged(AccountList, AccountList.FocusedNode, 0);
  AccountList.EndUpdate;
end;

procedure TCAccountsFrame.WndProc(var Message: TMessage);
var xDataGid: TDataGid;
begin
  inherited WndProc(Message);
  with Message do begin
    if Msg = WM_DATAOBJECTADDED then begin
      xDataGid := PDataGid(WParam)^;
      MessageAccountAdded(xDataGid);
    end else if Msg = WM_DATAOBJECTEDITED then begin
      xDataGid := PDataGid(WParam)^;
      MessageAccountEdited(xDataGid);
    end else if Msg = WM_DATAOBJECTDELETED then begin
      xDataGid := PDataGid(WParam)^;
      MessageAccountDeleted(xDataGid);
    end;
  end;
end;

procedure TCAccountsFrame.AccountListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  TDataObject(AccountList.GetNodeData(Node)^) := FAccountObjects.Items[Node.Index];
end;

procedure TCAccountsFrame.AccountListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TDataObject);
end;

procedure TCAccountsFrame.AccountListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var xData: TAccount;
begin
  xData := TAccount(AccountList.GetNodeData(Node)^);
  if Column = 0 then begin
    CellText := xData.name;
  end else if Column = 1 then begin
    if xData.accountType = CCashAccount then begin
      CellText := 'Gotówkowe';
    end else begin
      CellText := 'Bankowe';
    end;
  end else begin
    CellText := CurrencyToString(xData.cash);
  end;
end;

procedure TCAccountsFrame.AccountListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
begin
  CButtonEditAccount.Enabled := Node <> Nil;
  CButtonDelAccount.Enabled := Node <> Nil;
  if Owner.InheritsFrom(TCFrameForm) then begin
    TCFrameForm(Owner).BitBtnOk.Enabled := Node <> Nil;
  end;
end;

procedure TCAccountsFrame.AccountListHeaderClick(Sender: TVTHeader; Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
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

procedure TCAccountsFrame.AccountListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var xData1: TAccount;
    xData2: TAccount;
begin
  xData1 := TAccount(AccountList.GetNodeData(Node1)^);
  xData2 := TAccount(AccountList.GetNodeData(Node2)^);
  if Column = 0 then begin
    Result := AnsiCompareText(xData1.name, xData2.name);
  end else if Column = 1 then begin
    Result := AnsiCompareText(xData1.accountType, xData2.accountType);
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

procedure TCAccountsFrame.AccountListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
var xData: TAccount;
begin
  xData := TAccount(AccountList.GetNodeData(Node)^);
  HintText := xData.description;
  LineBreakStyle := hlbForceMultiLine;
end;

procedure TCAccountsFrame.ActionAddAccountExecute(Sender: TObject);
var xForm: TCAccountForm;
    xDataGid: TDataGid;
begin
  xForm := TCAccountForm.Create(Nil);
  xDataGid := xForm.ShowDataobject(coAdd, AccountProxy, Nil, True);
  if xDataGid <> CEmptyDataGid then begin
    SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTADDED, Integer(@xDataGid), 0);
  end;
  xForm.Free;
end;

procedure TCAccountsFrame.ActionEditAccountExecute(Sender: TObject);
var xForm: TCAccountForm;
    xDataGid: TDataGid;
begin
  xForm := TCAccountForm.Create(Nil);
  xDataGid := xForm.ShowDataobject(coEdit, AccountProxy, TAccount(AccountList.GetNodeData(AccountList.FocusedNode)^), True);
  if xDataGid <> CEmptyDataGid then begin
    SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTEDITED, Integer(@xDataGid), 0);
  end;
  xForm.Free;
end;

procedure TCAccountsFrame.ActionDelAccountExecute(Sender: TObject);
var xData: TDataObject;
begin
  xData := TDataObject(AccountList.GetNodeData(AccountList.FocusedNode)^);
  if TAccount.CanBeDeleted(xData.id) then begin
    if ShowInfo(itQuestion, 'Czy chcesz usun¹æ konto o nazwie "' + TAccount(xData).name + '" ?', '') then begin
      xData.DeleteObject;
      GDataProvider.CommitTransaction;
      SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTDELETED, Integer(@xData.id), 0);
    end;
  end;
end;

procedure TCAccountsFrame.AccountListBeforeItemErase(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var ItemColor: TColor; var EraseAction: TItemEraseAction);
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

function TCAccountsFrame.GetList: TVirtualStringTree;
begin
  Result := AccountList;
end;

function TCAccountsFrame.GetSelectedId: TDataGid;
begin
  Result := '';
  if AccountList.FocusedNode <> Nil then begin
    Result := TAccount(AccountList.GetNodeData(AccountList.FocusedNode)^).id;
  end;
end;

function TCAccountsFrame.GetSelectedText: String;
begin
  Result := '';
  if AccountList.FocusedNode <> Nil then begin
    Result := TAccount(AccountList.GetNodeData(AccountList.FocusedNode)^).name;
  end;
end;

procedure TCAccountsFrame.AccountListDblClick(Sender: TObject);
begin
  if AccountList.FocusedNode <> Nil then begin
    if Owner.InheritsFrom(TCFrameForm) then begin
      TCFrameForm(Owner).BitBtnOkClick(Nil);
    end;
  end;
end;

end.
