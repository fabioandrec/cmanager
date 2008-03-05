unit CMovementFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, ImgList, StdCtrls, ExtCtrls, VirtualTrees,
  ActnList, CComponents, CDatabase, Menus, VTHeaderPopup, GraphUtil, AdoDb,
  Contnrs, PngImageList, CImageListsUnit, CDataObjects;

type
  TMovementTreeElementType = (mtObject, mtList);

  TMovementTreeElement = class(TTreeObject)
  private
    FelementType: TMovementTreeElementType;
    FcurrencyView: String;
    function GetDescription: String;
    function Getcash: Currency;
    function Getregdate: TDateTime;
    function GetmovementType: TBaseEnumeration;
    function GetidCurrencyDef: TDataGid;
    function GetisStated: Boolean;
    function GetId: TDataGid;
  public
    property elementType: TMovementTreeElementType read FelementType write FelementType;
    property description: String read GetDescription;
    property cash: Currency read Getcash;
    property regDate: TDateTime read Getregdate;
    property idCurrencyDef: TDataGid read GetidCurrencyDef;
    property movementType: TBaseEnumeration read GetmovementType;
    property isStated: Boolean read GetisStated;
    property currencyView: String read FcurrencyView write FcurrencyView;
    property id: TDataGid read GetId;
  end;

  TCMovementFrame = class(TCBaseFrame)
    PanelFrameButtons: TPanel;
    TodayList: TCList;
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
    SumList: TCList;
    Label2: TLabel;
    Label1: TLabel;
    CStaticPeriod: TCStatic;
    Label3: TLabel;
    CDateTimePerStart: TCDateTime;
    Label4: TLabel;
    CDateTimePerEnd: TCDateTime;
    Label5: TLabel;
    ActionAddList: TAction;
    CButton1: TCButton;
    CStaticViewCurrency: TCStatic;
    Label6: TLabel;
    PopupMenuSums: TPopupMenu;
    Ustawienialisty2: TMenuItem;
    procedure ActionMovementExecute(Sender: TObject);
    procedure ActionEditMovementExecute(Sender: TObject);
    procedure ActionDelMovementExecute(Sender: TObject);
    procedure TodayListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure TodayListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure TodayListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure TodayListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure TodayListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure TodayListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
    procedure CStaticFilterGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticFilterChanged(Sender: TObject);
    procedure SumListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure SumListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure SumListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure SumListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure CStaticPeriodGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CDateTimePerStartChanged(Sender: TObject);
    procedure TodayListDblClick(Sender: TObject);
    procedure TodayListGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
    procedure ActionAddListExecute(Sender: TObject);
    procedure TodayListInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
    procedure SumListInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
    procedure CStaticViewCurrencyGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticViewCurrencyChanged(Sender: TObject);
    procedure Ustawienialisty2Click(Sender: TObject);
    procedure TodayListGetRowPreferencesName(AHelper: TObject; var APrefname: String);
  private
    FTodayObjects: TDataObjectList;
    FTodayLists: TDataObjectList;
    FTreeHelper: TTreeObjectList;
    FSumRoot: TSumElement;
    procedure MessageMovementAdded(AId: TDataGid; AOption: Integer);
    procedure MessageMovementEdited(AId: TDataGid; AOption: Integer);
    procedure MessageMovementDeleted(AId: TDataGid; AOption: Integer);
    procedure UpdateCustomPeriod;
    procedure RecreateTreeHelper;
    function FindParentMovementList(AListGid: TDataGid): TTreeObjectList;
    function FindObjectNode(ADataGid: TDataGid; AType: Integer): PVirtualNode;
    procedure DeleteObjectsWithMovementList(AListId: TDataGid);
  protected
    procedure WndProc(var Message: TMessage); override;
    procedure GetFilterDates(var ADateFrom, ADateTo: TDateTime);
    function GetSelectedType: Integer; override;
    function GetSelectedId: ShortString; override;
    function IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean; override;
    function GetSelectedText: String; override;
    procedure DoRepaintLists; override;
  public
    procedure UpdateButtons(AIsSelectedSomething: Boolean); override;
    function GetList: TCList; override;
    procedure ReloadToday;
    procedure ReloadSums;
    constructor Create(AOwner: TComponent); override;
    procedure InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean); override;
    destructor Destroy; override;
    class function GetTitle: String; override;
    function IsValidFilteredObject(AObject: TDataObject): Boolean; override;
    class function GetPrefname: String; override;
  end;

implementation

uses CFrameFormUnit, CInfoFormUnit, CConfigFormUnit, CDataobjectFormUnit,
  CAccountsFrameUnit, DateUtils, CListFrameUnit, DB, CMovementFormUnit,
  Types, CDoneFormUnit, CDoneFrameUnit, CConsts, CPreferences,
  CListPreferencesFormUnit, CReports, CMovmentListElementFormUnit,
  CMovementListFormUnit, CTools, CPluginConsts;

{$R *.dfm}

procedure TCMovementFrame.ActionMovementExecute(Sender: TObject);
var xForm: TCMovementForm;
begin
  xForm := TCMovementForm.Create(Nil);
  xForm.ShowDataobject(coAdd, BaseMovementProxy, Nil, True);
  xForm.Free;
end;

function SortByDate(AItem1, AItem2: Pointer): Integer;
begin
  if TTreeObject(AItem1).Dataobject.created > TTreeObject(AItem2).Dataobject.created then begin
    Result := 1;
  end else if TTreeObject(AItem1).Dataobject.created < TTreeObject(AItem2).Dataobject.created then begin
    Result := -1;
  end else begin
    Result := 0;
  end;
end;

procedure TCMovementFrame.ActionEditMovementExecute(Sender: TObject);
var xForm: TCDataobjectForm;
    xBase: TMovementTreeElement;
begin
  if TodayList.FocusedNode <> Nil then begin
    xBase := TMovementTreeElement(TodayList.GetNodeData(TodayList.FocusedNode)^);
    if xBase.elementType = mtObject then begin
      xForm := TCMovementForm.Create(Nil);
      xForm.ShowDataobject(coEdit, BaseMovementProxy, xBase.Dataobject, True);
      xForm.Free;
    end else if xBase.elementType = mtList then begin
      xForm := TCMovementListForm.Create(Nil);
      xForm.ShowDataobject(coEdit, MovementListProxy, xBase.Dataobject, True);
      xForm.Free;
    end;
  end;
end;

procedure TCMovementFrame.ActionDelMovementExecute(Sender: TObject);
var xBase: TMovementTreeElement;
    xIdTemp1, xIdTemp2, xIdTemp3, xIdTemp4, xIdTemp5: TDataGid;
begin
  xBase := TMovementTreeElement(TodayList.GetNodeData(TodayList.FocusedNode)^);
  if xBase.elementType = mtObject then begin
    if not TBaseMovement(xBase.Dataobject).isInvestmentMovement then begin
      if ShowInfo(itQuestion, 'Czy chcesz usun¹æ wybran¹ operacjê ?', '') then begin
        xIdTemp1 := xBase.Dataobject.id;
        xIdTemp2 := TBaseMovement(xBase.Dataobject).idAccount;
        xIdTemp3 := TBaseMovement(xBase.Dataobject).idSourceAccount;
        xIdTemp4 :=  TBaseMovement(xBase.Dataobject).idMovementList;
        xIdTemp5 :=  TBaseMovement(xBase.Dataobject).idPlannedDone;
        xBase.Dataobject.DeleteObject;
        GDataProvider.CommitTransaction;
        SendMessageToFrames(TCMovementFrame, WM_DATAOBJECTDELETED, Integer(@xIdTemp1), WMOPT_BASEMOVEMENT);
        SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTEDITED, Integer(@xIdTemp2), WMOPT_BASEMOVEMENT);
        if (xIdTemp3 <> CEmptyDataGid) then begin
          SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTEDITED, Integer(@xIdTemp3), WMOPT_BASEMOVEMENT);
        end;
        if (xIdTemp4 <> CEmptyDataGid) then begin
          SendMessageToFrames(TCMovementFrame, WM_DATAOBJECTEDITED, Integer(@xIdTemp4), WMOPT_MOVEMENTLIST);
        end;
        if xIdTemp5 <> CEmptyDataGid then begin
          SendMessageToFrames(TCDoneFrame, WM_DATAREFRESH, 0, 0);
        end;
      end;
    end else begin
      ShowInfo(itWarning, 'Nie mo¿na usun¹æ operacji, gdy¿ powsta³a ona na bazie operacji inwestycyjnej', '')
    end;
  end else if xBase.elementType = mtList then begin
    if ShowInfo(itQuestion, 'Czy chcesz usun¹æ wybran¹ listê operacji ?', '') then begin
      xBase := TMovementTreeElement(TodayList.GetNodeData(TodayList.FocusedNode)^);
      xIdTemp1 := xBase.Dataobject.id;
      xIdTemp2 := TMovementList(xBase.Dataobject).idAccount;
      xBase.Dataobject.DeleteObject;
      GDataProvider.CommitTransaction;
      SendMessageToFrames(TCMovementFrame, WM_DATAOBJECTDELETED, Integer(@xIdTemp1), WMOPT_MOVEMENTLIST);
      SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTEDITED, Integer(@xIdTemp2), WMOPT_BASEMOVEMENT);
    end;
  end;
end;

constructor TCMovementFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTodayObjects := Nil;
  FTodayLists := Nil;
  FSumRoot := TSumElement.Create;
end;

procedure TCMovementFrame.TodayListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
begin
  UpdateButtons(Node <> Nil);
end;

procedure TCMovementFrame.ReloadToday;
var xCondition: String;
    xDf, xDt: TDateTime;
begin
  TodayList.BeginUpdate;
  TodayList.Clear;
  GetFilterDates(xDf, xDt);
  xCondition := Format('regDate between %s and %s', [DatetimeToDatabase(xDf, False), DatetimeToDatabase(xDt, False)]);
  if CStaticFilter.DataId = '2' then begin
    xCondition := xCondition + Format(' and movementType = ''%s''', [COutMovement]);
  end else if CStaticFilter.DataId = '3' then begin
    xCondition := xCondition + Format(' and movementType = ''%s''', [CInMovement]);
  end else if CStaticFilter.DataId = '4' then begin
    xCondition := xCondition + ' and movementType = ''' + CTransferMovement + '''';
  end;
  if FTodayObjects <> Nil then begin
    FreeAndNil(FTodayObjects);
  end;
  if FTodayLists <> Nil then begin
    FreeAndNil(FTodayLists);
  end;
  FTodayObjects := TDataObject.GetList(TBaseMovement, BaseMovementProxy, 'select * from baseMovement where ' + xCondition + ' order by created');
  FTodayLists := TDataObject.GetList(TMovementList, MovementListProxy, 'select * from movementList where ' + xCondition + ' order by created');
  RecreateTreeHelper;
  TodayList.RootNodeCount := FTreeHelper.Count;
  TodayListFocusChanged(TodayList, TodayList.FocusedNode, 0);
  TodayList.EndUpdate;
end;

procedure TCMovementFrame.InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean);
begin
  inherited InitializeFrame(AOwner, AAdditionalData, AOutputData, AMultipleCheck, AWithButtons);
  CStaticPeriod.DataId := '1';
  FTreeHelper := TTreeObjectList.Create(True);
  UpdateCustomPeriod;
  Label5.Left := Panel.Width - 8;
  CDateTimePerEnd.Left := Label5.Left - CDateTimePerEnd.Width;
  Label4.Left := CDateTimePerEnd.Left - 15;
  CDateTimePerStart.Left := Label4.Left - CDateTimePerStart.Width;
  Label3.Left := CDateTimePerStart.Left - 18;
  Label6.Left := CStaticPeriod.Left + CStaticPeriod.Width;
  CStaticViewCurrency.Left := Label6.Left + Label6.Width + 4;
  CDateTimePerStart.Value := GWorkDate;
  CDateTimePerEnd.Value := GWorkDate;
  Label3.Anchors := [akRight, akTop];
  CDateTimePerStart.Anchors := [akRight, akTop];
  Label4.Anchors := [akRight, akTop];
  CDateTimePerEnd.Anchors := [akRight, akTop];
  Label5.Anchors := [akRight, akTop];
  if not AWithButtons then begin
    Bevel.Visible := False;
    Panel1.Visible := False;
  end;
  SumList.ViewPref := TViewPref(GViewsPreferences.ByPrefname[CFontPreferencesMovementListSum]);
  ReloadToday;
  ReloadSums;
end;

destructor TCMovementFrame.Destroy;
begin
  FTreeHelper.Free;
  FTodayObjects.Free;
  FTodayLists.Free;
  FSumRoot.Free;
  inherited Destroy;
end;

procedure TCMovementFrame.TodayListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
var xTreeList: TTreeObjectList;
    xTreeObject: TMovementTreeElement;
begin
  if ParentNode = Nil then begin
    xTreeList := FTreeHelper;
  end else begin
    xTreeList := TTreeObject(TodayList.GetNodeData(ParentNode)^).Childobjects;
  end;
  xTreeObject := TMovementTreeElement(xTreeList.Items[Node.Index]);
  TTreeObject(TodayList.GetNodeData(Node)^) := xTreeObject;
  if xTreeObject.Childobjects.Count > 0 then begin
    InitialStates := InitialStates + [ivsHasChildren, ivsExpanded];
  end;
  if MultipleChecks <> Nil then begin
    Node.CheckType := ctCheckBox;
    Node.CheckState := csCheckedNormal;
  end;
end;

procedure TCMovementFrame.TodayListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TMovementTreeElement);
end;

procedure TCMovementFrame.TodayListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var xData: TMovementTreeElement;
begin
  CellText := '';
  xData := TMovementTreeElement(TodayList.GetNodeData(Node)^);
  if Column = 0 then begin
    if TodayList.NodeParent[Node] = Nil then begin
      CellText := IntToStr(Node.Index + 1);
    end;
  end else if Column = 1 then begin
    CellText := GetDescText(xData.description);
  end else if Column = 2 then begin
    CellText := Date2StrDate(xData.regDate);
  end else if Column = 3 then begin
    CellText := CurrencyToString(xData.cash, xData.idCurrencyDef, False);
  end else if Column = 4 then begin
    CellText := GCurrencyCache.GetSymbol(xData.idCurrencyDef);
  end else if Column = 5 then begin
    if (xData.movementType = CInMovement) then begin
      CellText := CInMovementDescription;
    end else if (xData.movementType = COutMovement) then begin
      CellText := COutMovementDescription;
    end else begin
      CellText := CTransferMovementDescription;
    end;
  end else if Column = 6 then begin
    if xData.movementType = CTransferMovement then begin
      if TBaseMovement(xData.Dataobject).isStated and TBaseMovement(xData.Dataobject).isSourceStated then begin
        CellText := 'Uzgodniona';
      end else begin
        CellText := 'Do uzgodnienia';
      end;
    end else begin
      if xData.isStated then begin
        CellText := 'Uzgodniona';
      end else begin
        CellText := 'Do uzgodnienia';
      end;
    end;
  end;
end;

procedure TCMovementFrame.TodayListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var xData1: TMovementTreeElement;
    xData2: TMovementTreeElement;
begin
  xData1 := TMovementTreeElement(TodayList.GetNodeData(Node1)^);
  xData2 := TMovementTreeElement(TodayList.GetNodeData(Node2)^);
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
    Result := AnsiCompareText(xData1.idCurrencyDef, xData2.idCurrencyDef);
  end else if Column = 5 then begin
    Result := AnsiCompareText(xData1.movementType, xData2.movementType);
  end;
end;

procedure TCMovementFrame.TodayListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
var xData: TMovementTreeElement;
begin
  xData := TMovementTreeElement(TodayList.GetNodeData(Node)^);
  HintText := xData.description;
  LineBreakStyle := hlbForceMultiLine;
end;

procedure TCMovementFrame.MessageMovementAdded(AId: TDataGid; AOption: Integer);
var xDataobject: TDataObject;
    xNode: PVirtualNode;
    xTreeElement: TMovementTreeElement;
    xParent: PVirtualNode;
begin
  if AOption = WMOPT_BASEMOVEMENT then begin
    xDataobject := TBaseMovement.LoadObject(BaseMovementProxy, AId, True);
  end else begin
    xDataobject := TMovementList.LoadObject(MovementListProxy, AId, True);
  end;
  if IsValidFilteredObject(xDataobject) then begin
    xTreeElement := TMovementTreeElement.Create;
    xTreeElement.Dataobject := xDataobject;
    xTreeElement.currencyView := CStaticViewCurrency.DataId;
    if AOption = WMOPT_BASEMOVEMENT then begin
      xTreeElement.elementType := mtObject;
      FTodayObjects.Add(xDataobject);
    end else begin
      xTreeElement.elementType := mtList;
      FTodayLists.Add(xDataobject);
    end;
    if AOption = WMOPT_BASEMOVEMENT then begin
      if TBaseMovement(xDataobject).idMovementList <> CEmptyDataGid then begin
        xParent := FindObjectNode(TBaseMovement(xDataobject).idMovementList, WMOPT_MOVEMENTLIST);
        TMovementTreeElement(TodayList.GetNodeData(xParent)^).Childobjects.Add(xTreeElement);
      end else begin
        xParent := Nil;
        FTreeHelper.Add(xTreeElement);
      end;
    end else begin
      xParent := Nil;
      FTreeHelper.Add(xTreeElement);
    end;
    xNode := TodayList.AddChild(xParent, xTreeElement);
    TodayList.Sort(xNode, TodayList.Header.SortColumn, TodayList.Header.SortDirection);
    TodayList.FocusedNode := xNode;
    TodayList.Selected[xNode] := True;
  end else begin
    xDataobject.Free;
  end;
  ReloadSums;
end;

procedure TCMovementFrame.MessageMovementDeleted(AId: TDataGid; AOption: Integer);
var xNode: PVirtualNode;
    xTreeList: TTreeObjectList;
    xData: TMovementTreeElement;
begin
  xNode := FindObjectNode(AId, AOption);
  if xNode <> Nil then begin
    xData := TMovementTreeElement(TodayList.GetNodeData(xNode)^);
    if TodayList.NodeParent[xNode] = Nil then begin
      xTreeList := FTreeHelper;
    end else begin
      xTreeList := TTreeObject(TodayList.GetNodeData(xNode.Parent)^).Childobjects;
    end;
    TodayList.BeginUpdate;
    if AOption = WMOPT_BASEMOVEMENT then begin
      FTodayObjects.Remove(TMovementTreeElement(TodayList.GetNodeData(xNode)^).Dataobject);
    end else if AOption = WMOPT_MOVEMENTLIST then begin
      DeleteObjectsWithMovementList(TMovementTreeElement(TodayList.GetNodeData(xNode)^).Dataobject.id);
      FTodayLists.Remove(TMovementTreeElement(TodayList.GetNodeData(xNode)^).Dataobject)
    end;
    xTreeList.Remove(xData);
    TodayList.DeleteNode(xNode);
    TodayList.EndUpdate;
  end;
  ReloadSums;
end;

procedure TCMovementFrame.MessageMovementEdited(AId: TDataGid; AOption: Integer);
var xNode: PVirtualNode;
    xBase: TMovementTreeElement;
    xTreeList: TTreeObjectList;
begin
  xNode := FindObjectNode(AId, AOption);
  if xNode <> Nil then begin
    xBase := TMovementTreeElement(TodayList.GetNodeData(xNode)^);
    xBase.Dataobject.ReloadObject;
    if IsValidFilteredObject(xBase.Dataobject) then begin
      TodayList.InvalidateNode(xNode);
      TodayList.Sort(xNode, TodayList.Header.SortColumn, TodayList.Header.SortDirection);
    end else begin
      if TodayList.NodeParent[xNode] = Nil then begin
        xTreeList := FTreeHelper;
      end else begin
        xTreeList := TTreeObject(TodayList.GetNodeData(xNode.Parent)^).Childobjects;
      end;
      TodayList.BeginUpdate;
      if AOption = WMOPT_BASEMOVEMENT then begin
        FTodayObjects.Remove(TMovementTreeElement(TodayList.GetNodeData(xNode)^).Dataobject);
      end else if AOption = WMOPT_MOVEMENTLIST then begin
        DeleteObjectsWithMovementList(TMovementTreeElement(TodayList.GetNodeData(xNode)^).Dataobject.id);
        FTodayLists.Remove(TMovementTreeElement(TodayList.GetNodeData(xNode)^).Dataobject)
      end;
      xTreeList.Remove(xBase);
      TodayList.DeleteNode(xNode);
      TodayList.EndUpdate;
    end;
  end;
  ReloadSums;
end;

function TCMovementFrame.GetList: TCList;
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
      MessageMovementAdded(xDataGid, LParam);
    end else if Msg = WM_DATAOBJECTEDITED then begin
      xDataGid := PDataGid(WParam)^;
      MessageMovementEdited(xDataGid, LParam);
    end else if Msg = WM_DATAOBJECTDELETED then begin
      xDataGid := PDataGid(WParam)^;
      MessageMovementDeleted(xDataGid, LParam);
    end;
  end;
end;

class function TCMovementFrame.GetTitle: String;
begin
  Result := 'Operacje wykonane';
end;

function TCMovementFrame.IsValidFilteredObject(AObject: TDataObject): Boolean;
var xOt, xFt: String;
    xDf, xDt: TDateTime;
    xRd:  TDateTime;
begin
  if AObject.InheritsFrom(TBaseMovement) then begin
    xOt := TBaseMovement(AObject).movementType;
    xRd := TBaseMovement(AObject).regDate;
  end else begin
    xOt := TMovementList(AObject).movementType;
    xRd := TMovementList(AObject).regDate;
  end;
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
    Result := (xDf <= xRd) and (xRd <= xDt);
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
    xPar: TSumElement;
    xDf, xDt: TDateTime;
    xMultiCurrency: Boolean;
    xOneCurrency: TDataGid;
    xSumObj: TSumElement;
    xIs, xEs, xCs: String;
begin
  GetFilterDates(xDf, xDt);
  if CStaticViewCurrency.DataId = CCurrencyViewBaseMovements then begin
    xIs := 'movementIncome';
    xEs := 'movementExpense';
    xCs := 'idMovementCurrencyDef';
  end else begin
    xIs := 'income';
    xEs := 'expense';
    xCs := 'idAccountCurrencyDef';
  end;
  xSql := Format('select v.*, a.name from ' +
                 ' (select idAccount, %s as idCurrencyDef, sum(%s) as incomes, sum(%s) as expenses from balances where ' +
                 '   movementType <> ''%s'' and ' +
                 '   regDate between %s and %s group by idAccount, %s) as v ' +
                 '   left outer join account a on a.idAccount = v.idAccount',
       [xCs, xIs, xEs, CTransferMovement, DatetimeToDatabase(xDf, False), DatetimeToDatabase(xDt, False), xCs]);
  xDs := GDataProvider.OpenSql(xSql);
  xMultiCurrency := IsMultiCurrencyDataset(xDs, 'idCurrencyDef', xOneCurrency);
  SumList.BeginUpdate;
  SumList.Clear;
  FSumRoot.childs.Clear;
  if xMultiCurrency then begin
    xSumObj := Nil;
    while not xDs.Eof do begin
      xObj := FSumRoot.childs.FindSumObjectByCur(xDs.FieldByName('idCurrencyDef').AsString, False);
      if xObj = Nil then begin
        xObj := TSumElement.Create;
        xObj.id := '*';
        xObj.idCurrencyDef := xDs.FieldByName('idCurrencyDef').AsString;
        xObj.cashIn := 0;
        xObj.cashOut := 0;
        xObj.name := 'Razem w ' + GCurrencyCache.GetSymbol(xObj.idCurrencyDef);
        FSumRoot.AddChild(xObj);
      end;
      xDs.Next;
    end;
  end else begin
    xSumObj := TSumElement.Create;
    xSumObj.id := '*';
    xSumObj.idCurrencyDef := xOneCurrency;
    xSumObj.cashIn := 0;
    xSumObj.cashOut := 0;
    xSumObj.name := 'Razem wszystkie operacje';
    FSumRoot.AddChild(xSumObj);
  end;
  xDs.First;
  while not xDs.Eof do begin
    if xMultiCurrency then begin
      xPar := FSumRoot.childs.FindSumObjectByCur(xDs.FieldByName('idCurrencyDef').AsString, False);
    end else begin
      xPar := FSumRoot;
    end;
    if xPar <> Nil then begin
      xObj := xPar.childs.FindSumObjectById(xDs.FieldByName('idAccount').AsString, False);
      if xObj = Nil then begin
        xObj := TSumElement.Create;
        xPar.AddChild(xObj);
      end;
      xObj.id := xDs.FieldByName('idAccount').AsString;
      xObj.name := xDs.FieldByName('name').AsString;
      xObj.cashIn := xObj.cashIn + xDs.FieldByName('incomes').AsCurrency;
      xObj.idCurrencyDef := xDs.FieldByName('idCurrencyDef').AsString;
      xObj.cashOut := xObj.cashOut + xDs.FieldByName('expenses').AsCurrency;
      xPar.cashIn := xPar.cashIn + xObj.cashIn;
      xPar.cashOut := xPar.cashOut + xObj.cashOut;
      if not xMultiCurrency then begin
        with xSumObj do begin
          cashIn := cashIn + xObj.cashIn;
          cashOut := cashOut + xObj.cashOut;
        end;
      end;
    end;
    xDs.Next;
  end;
  SumList.RootNodeCount := FSumRoot.childs.Count;
  SumList.EndUpdate;
  xDs.Free;
end;

procedure TCMovementFrame.SumListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var xData1: TSumElement;
    xData2: TSumElement;
begin
  xData1 := TSumElement(SumList.GetNodeData(Node1)^);
  xData2 := TSumElement(SumList.GetNodeData(Node2)^);
  if (Copy(xData1.id, 1, 1) = '*') then begin
    if TCList(Sender).Header.SortDirection = sdAscending then begin
      Result := -1;
    end else begin
      Result := 1;
    end;
  end else if (Copy(xData2.id, 1, 1) = '*') then begin
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
    CellText := CurrencyToString(xData.cashOut, '', False);
  end else if Column = 2 then begin
    CellText := CurrencyToString(xData.cashIn, '', False);
  end else if Column = 3 then begin
    CellText := CurrencyToString(xData.cashIn - xData.cashOut, '', False);
  end else if Column = 4 then begin
    CellText := GCurrencyCache.GetSymbol(xData.idCurrencyDef);
  end;
end;

procedure TCMovementFrame.SumListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
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

procedure TCMovementFrame.CStaticPeriodGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
var xList: TStringList;
    xGid, xText: String;
    xRect: TRect;
begin
  xList := TStringList.Create;
  xList.Add('1=<tylko dziœ>');
  xList.Add('2=<w tym tygodniu>');
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

class function TCMovementFrame.GetPrefname: String;
begin
  Result := 'baseMovement';
end;

procedure TCMovementFrame.TodayListGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
var xBase: TMovementTreeElement;
begin
 xBase := TMovementTreeElement(TodayList.GetNodeData(Node)^);
  if Column = 5 then begin
    if xBase.movementType = CInMovement then begin
      ImageIndex := 0;
    end else if xBase.movementType = COutMovement then begin
      ImageIndex := 1;
    end else if xBase.movementType = CTransferMovement then begin
      ImageIndex := 2;
    end;
  end else if Column = 6 then begin
    if xBase.movementType = CTransferMovement then begin
      if TBaseMovement(xBase.Dataobject).isStated and TBaseMovement(xBase.Dataobject).isSourceStated then begin
        ImageIndex := 4;
      end else begin
        ImageIndex := 3;
      end;
    end else begin
      if xBase.isStated then begin
        ImageIndex := 4;
      end else begin
        ImageIndex := 3;
      end;
    end;
  end;
end;

procedure TCMovementFrame.RecreateTreeHelper;
var xCount: Integer;
    xItem: TMovementTreeElement;
    xParentList: TTreeObjectList;
begin
  FTreeHelper.Clear;
  for xCount := 0 to FTodayLists.Count - 1 do begin
    xItem := TMovementTreeElement.Create;
    xItem.elementType := mtList;
    xItem.Dataobject := FTodayLists.Items[xCount];
    xItem.currencyView := CStaticViewCurrency.DataId;
    FTreeHelper.Add(xItem);
  end;
  for xCount := 0 to FTodayObjects.Count - 1 do begin
    xItem := TMovementTreeElement.Create;
    xItem.elementType := mtObject;
    xItem.Dataobject := FTodayObjects.Items[xCount];
    xItem.currencyView := CStaticViewCurrency.DataId;
    if TBaseMovement(xItem.Dataobject).idMovementList <> CEmptyDataGid then begin
      xParentList := FindParentMovementList(TBaseMovement(xItem.Dataobject).idMovementList);
    end else begin
      xParentList := FTreeHelper;
    end;
    xParentList.Add(xItem);
  end;
  FTreeHelper.Sort(SortByDate);
end;

function TCMovementFrame.FindParentMovementList(AListGid: TDataGid): TTreeObjectList;
var xCount: Integer;
begin
  Result := Nil;
  xCount := 0;
  while (xCount <= FTreeHelper.Count - 1) and (Result = Nil) do begin
    if FTreeHelper.Items[xCount].Dataobject.id = AListGid then begin
      Result := FTreeHelper.Items[xCount].Childobjects;
    end;
    Inc(xCount);
  end;
end;

function TMovementTreeElement.Getcash: Currency;
begin
  if FelementType = mtObject then begin
    if FcurrencyView = CCurrencyViewBaseMovements then begin
      Result := TBaseMovement(Dataobject).movementCash;
    end else begin
      Result := TBaseMovement(Dataobject).cash;
    end;
  end else begin
    Result := TmovementList(Dataobject).cash;
  end;
end;

function TMovementTreeElement.GetDescription: String;
begin
  if FelementType = mtObject then begin
    Result := TBaseMovement(Dataobject).description;
  end else begin
    Result := TmovementList(Dataobject).description;
  end;
end;

function TMovementTreeElement.GetId: TDataGid;
begin
  Result := Dataobject.id;
end;

function TMovementTreeElement.GetidCurrencyDef: TDataGid;
begin
  if FelementType = mtObject then begin
    if FcurrencyView = CCurrencyViewBaseMovements then begin
      Result := TBaseMovement(Dataobject).idMovementCurrencyDef;
    end else begin
      Result := TBaseMovement(Dataobject).idAccountCurrencyDef;
    end;
  end else begin
    Result := TMovementList(Dataobject).idAccountCurrencyDef;
  end;
end;

function TMovementTreeElement.GetisStated: Boolean;
begin
  if FelementType = mtObject then begin
    Result := TBaseMovement(Dataobject).isStated
  end else begin
    Result := TMovementList(Dataobject).isStated;
  end;
end;

function TMovementTreeElement.GetmovementType: TBaseEnumeration;
begin
  if FelementType = mtObject then begin
    Result := TBaseMovement(Dataobject).movementType;
  end else begin
    Result := TMovementList(Dataobject).movementType;
  end;
end;

function TMovementTreeElement.Getregdate: TDateTime;
begin
  if FelementType = mtObject then begin
    Result := TBaseMovement(Dataobject).regDate;
  end else begin
    Result := TMovementList(Dataobject).regDate;
  end;
end;

procedure TCMovementFrame.ActionAddListExecute(Sender: TObject);
var xForm: TCMovementListForm;
begin
  xForm := TCMovementListForm.Create(Nil);
  xForm.ShowDataobject(coAdd, MovementListProxy, Nil, True);
  xForm.Free;
end;

procedure TCMovementFrame.TodayListInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
var xData: TMovementTreeElement;
begin
  xData := TMovementTreeElement(TodayList.GetNodeData(Node)^);
  ChildCount := xData.Childobjects.Count;
end;

function TCMovementFrame.FindObjectNode(ADataGid: TDataGid; AType: Integer): PVirtualNode;
var xNode: PVirtualNode;
    xBase: TMovementTreeElement;
begin
  Result := Nil;
  xNode :=TodayList.GetFirst;
  while (Result = Nil) and (xNode <> Nil) do begin
    xBase := TMovementTreeElement(TodayList.GetNodeData(xNode)^);
    if ((AType = WMOPT_BASEMOVEMENT) and (xBase.elementType = mtObject)) or ((AType = WMOPT_MOVEMENTLIST) and (xBase.elementType = mtList)) then begin
      if xBase.Dataobject.id = ADataGid then begin
        Result := xNode;
      end;
    end;
    xNode := TodayList.GetNext(xNode);
  end;
end;

procedure TCMovementFrame.DeleteObjectsWithMovementList(AListId: TDataGid);
var xCount: Integer;
begin
  for xCount := FTodayObjects.Count - 1 downto 0 do begin
    if TBaseMovement(FTodayObjects.Items[xCount]).idMovementList = AListId then begin
      FTodayObjects.Remove(FTodayObjects.Items[xCount]);
    end;
  end;
end;

procedure TCMovementFrame.SumListInitChildren(Sender: TBaseVirtualTree; Node: PVirtualNode; var ChildCount: Cardinal);
var xDate: TSumElement;
begin
  xDate := TSumElement(SumList.GetNodeData(Node)^);
  ChildCount := xDate.childs.Count;
end;

procedure TCMovementFrame.CStaticViewCurrencyGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ShowCurrencyViewTypeBaseMovement(ADataGid, AText);
end;

procedure TCMovementFrame.CStaticViewCurrencyChanged(Sender: TObject);
begin
  ReloadToday;
  ReloadSums;
end;

function TCMovementFrame.GetSelectedType: Integer;
var xData: TMovementTreeElement;
begin
  if TodayList.FocusedNode <> Nil then begin
    xData := TMovementTreeElement(TodayList.GetNodeData(TodayList.FocusedNode)^);
    if xData.elementType = mtObject then begin
      Result := CSELECTEDITEM_BASEMOVEMENT;
    end else begin
      Result := CSELECTEDITEM_MOVEMENTLIST;
    end;
  end else begin
    Result := CSELECTEDITEM_INCORRECT;
  end;
end;

function TCMovementFrame.GetSelectedId: ShortString;
begin
  if TodayList.FocusedNode <> Nil then begin
    Result := TMovementTreeElement(TodayList.GetNodeData(TodayList.FocusedNode)^).id;
  end else begin
    Result := CEmptyDataGid;
  end;
end;

function TCMovementFrame.IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean;
begin
  Result := ((APluginSelectedItemTypes and CSELECTEDITEM_BASEMOVEMENT) = CSELECTEDITEM_BASEMOVEMENT) or
            ((APluginSelectedItemTypes and CSELECTEDITEM_MOVEMENTLIST) = CSELECTEDITEM_MOVEMENTLIST);
end;

procedure TCMovementFrame.UpdateButtons(AIsSelectedSomething: Boolean);
begin
  inherited UpdateButtons(AIsSelectedSomething);
  CButtonEdit.Enabled := AIsSelectedSomething;
  CButtonDel.Enabled := AIsSelectedSomething;
end;

function TCMovementFrame.GetSelectedText: String;
begin
  if TodayList.FocusedNode <> Nil then begin
    Result := TMovementTreeElement(TodayList.GetNodeData(TodayList.FocusedNode)^).description;
  end else begin
    Result := '';
  end;
end;

procedure TCMovementFrame.DoRepaintLists;
begin
  inherited DoRepaintLists;
  SumList.ReinitNode(SumList.RootNode, True);
  SumList.Repaint;
end;

procedure TCMovementFrame.Ustawienialisty2Click(Sender: TObject);
var xPrefs: TCListPreferencesForm;
begin
  xPrefs := TCListPreferencesForm.Create(Nil);
  if xPrefs.ShowListPreferences(SumList.ViewPref) then begin
    SendMessageToFrames(TCBaseFrameClass(ClassType), WM_MUSTREPAINT, 0, 0);
  end;
  xPrefs.Free;
end;

procedure TCMovementFrame.TodayListGetRowPreferencesName(AHelper: TObject; var APrefname: String);
begin
  APrefname := TMovementTreeElement(AHelper).movementType;
  if TMovementTreeElement(AHelper).elementType = mtObject then begin
    if TBaseMovement(TMovementTreeElement(AHelper).Dataobject).idPlannedDone <> CEmptyDataGid then begin
      APrefname := 'C' + APrefname;
    end;
  end else begin
    APrefname := 'S' + APrefname;
  end;
end;

end.
