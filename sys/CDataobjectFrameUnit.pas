unit CDataobjectFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, Menus, ImgList, PngImageList, VirtualTrees,
  CComponents, ExtCtrls, VTHeaderPopup, CDatabase, ActnList, CDataobjectFormUnit,
  StdCtrls, CImageListsUnit;

type
  TCDataobjectFrameData = class(TObject)
  private
    FFilterId: String;
  public
    constructor CreateWithFilter(AFilterId: String);
    property FilterId: String read FFilterId;
  end;

  TCDataobjectFrame = class(TCBaseFrame)
    FilterPanel: TPanel;
    List: TCDataList;
    Bevel: TBevel;
    ButtonPanel: TPanel;
    VTHeaderPopupMenu: TVTHeaderPopupMenu;
    ActionListButtons: TActionList;
    ActionAdd: TAction;
    ActionEdit: TAction;
    ActionDelete: TAction;
    CButtonAdd: TCButton;
    CButtonEdit: TCButton;
    CButtonDelete: TCButton;
    Label2: TLabel;
    CStaticFilter: TCStatic;
    Dodaj1: TMenuItem;
    Edytuj1: TMenuItem;
    Usu1: TMenuItem;
    CButtonHistory: TCButton;
    ActionListHistory: TActionList;
    ActionHistory: TAction;
    Historia1: TMenuItem;
    procedure ListCDataListReloadTree(Sender: TCDataList; ARootElement: TCListDataElement);
    procedure ListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure ActionAddExecute(Sender: TObject);
    procedure ActionEditExecute(Sender: TObject);
    procedure ActionDeleteExecute(Sender: TObject);
    procedure CStaticFilterChanged(Sender: TObject);
    procedure CStaticFilterGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure ListDblClick(Sender: TObject);
    procedure ListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure ActionHistoryExecute(Sender: TObject);
  protected
    procedure UpdateButtons(AIsSelectedSomething: Boolean); virtual;
    procedure WndProc(var Message: TMessage); override;
    procedure MessageMovementAdded(AId: TDataGid; AOptions: Integer); virtual;
    procedure MessageMovementEdited(AId: TDataGid; AOptions: Integer); virtual;
    procedure MessageMovementDeleted(AId: TDataGid; AOptions: Integer); virtual;
    procedure RefreshData; virtual;
  public
    Dataobjects: TDataObjectList;
    procedure RecreateTreeHelper; virtual;
    procedure ReloadDataobjects; virtual;
    procedure ClearDataobjects; virtual;
    procedure InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList); override;
    destructor Destroy; override;
    function GetList: TCList; override;
    function GetSelectedId: TDataGid; override;
    function GetSelectedText: String; override;
    function GetHistoryText: String; virtual;
    procedure ShowHistory(AGid: TDataGid); virtual;
    function GetInitialiFilter: String; virtual;
    function GetDataobjectClass(AOption: Integer): TDataObjectClass; virtual; abstract;
    function GetDataobjectProxy(AOption: Integer): TDataProxy; virtual; abstract;
    function GetDataobjectForm(AOption: Integer): TCDataobjectFormClass; virtual; abstract;
    function GetDataobjectParent(ADataobject: TDataObject): TCListDataElement; virtual;
    function GetStaticFilter: TStringList; virtual;
    procedure ReloadSums; virtual;
    function IsValidFilteredObject(AObject: TDataObject): Boolean; override;
    function FindNodeId(ANode: PVirtualNode): ShortString; override;
    function FindNode(ADataId: TDataGid; AList: TCList): PVirtualNode; override;
    procedure ShowFrame; override;
    procedure HideFrame; override;
  end;

implementation

uses CFrameFormUnit, CConsts, CConfigFormUnit, CInfoFormUnit, CDatatools,
  CListFrameUnit;

{$R *.dfm}

procedure TCDataobjectFrame.ClearDataobjects;
begin
  if Assigned(Dataobjects) then begin
    FreeAndNil(Dataobjects);
  end;
end;

destructor TCDataobjectFrame.Destroy;
begin
  ClearDataobjects;
  inherited Destroy;
end;

function TCDataobjectFrame.GetList: TCList;
begin
  Result := List;
end;

function TCDataobjectFrame.GetSelectedId: TDataGid;
begin
  Result := List.SelectedId;
end;

function TCDataobjectFrame.GetSelectedText: String;
begin
  Result := List.SelectedText;
end;

procedure TCDataobjectFrame.InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList);
var xFilters: TStringList;
    xHistory: String;
begin
  inherited InitializeFrame(AOwner, AAdditionalData, AOutputData, AMultipleCheck);
  Dataobjects := Nil;
  xHistory := GetHistoryText;
  if xHistory <> '' then begin
    ActionHistory.Caption := xHistory;
    CButtonHistory.Width := CButtonHistory.Canvas.TextWidth(ActionHistory.Caption) + CButtonHistory.PicOffset + ActionListHistory.Images.Width + 10;
    CButtonHistory.Left := ButtonPanel.Width - CButtonHistory.Width - 15;
    CButtonHistory.Anchors := [akTop, akRight];
  end;
  ActionHistory.Visible := xHistory <> '';
  CStaticFilter.DataId := GetInitialiFilter;
  xFilters := GetStaticFilter;
  if xFilters <> Nil then begin
    if AAdditionalData <> Nil then begin
      CStaticFilter.DataId := TCDataobjectFrameData(AAdditionalData).FilterId;
      CStaticFilter.Caption := xFilters.Values[CStaticFilter.DataId];
    end;
    FilterPanel.Visible := True;
  end else begin
    FilterPanel.Visible := False;
  end;
  xFilters.Free;
  RefreshData;
end;

procedure TCDataobjectFrame.ListCDataListReloadTree(Sender: TCDataList; ARootElement: TCListDataElement);
begin
  ReloadDataobjects;
  RecreateTreeHelper;
end;

procedure TCDataobjectFrame.ListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
begin
  UpdateButtons(Node <> Nil);
end;

procedure TCDataobjectFrame.MessageMovementAdded(AId: TDataGid; AOptions: Integer);
var xDataobject: TDataObject;
    xElement: TCListDataElement;
    xNode: PVirtualNode;
begin
  xDataobject := GetDataobjectClass(AOptions).LoadObject(GetDataobjectProxy(AOptions), AId, True);
  if IsValidFilteredObject(xDataobject) then begin
    xElement := TCListDataElement.Create(List, xDataobject);
    Dataobjects.Add(xDataobject);
    xNode := GetDataobjectParent(xDataobject).AppendDataElement(xElement);
    if MultipleChecks <> Nil then begin
      xNode.CheckType := ctCheckBox;
      xNode.CheckState := csCheckedNormal;
    end;
  end else begin
    xDataobject.Free;
  end;
  ReloadSums;
end;

procedure TCDataobjectFrame.MessageMovementDeleted(AId: TDataGid; AOptions: Integer);
begin
  List.RootElement.DeleteDataElement(AId, GetDataobjectClass(WMOPT_NONE).ClassName);
  ReloadSums;
end;

procedure TCDataobjectFrame.MessageMovementEdited(AId: TDataGid; AOptions: Integer);
var xElement: TCListDataElement;
    xDataobject: TDataObject;
begin
  xElement := List.RootElement.FindDataElement(AId, GetDataobjectClass(WMOPT_NONE).ClassName);
  if xElement <> Nil then begin
    xDataobject := xElement.Data as TDataObject;
    if IsValidFilteredObject(xDataobject) then begin
      List.RootElement.RefreshDataElement(AId, xDataobject.ClassName);
    end else begin
      List.RootElement.DeleteDataElement(AId, xDataobject.ClassName);
      Dataobjects.Remove(xDataobject);
    end;
  end;
  ReloadSums;
end;

procedure TCDataobjectFrame.ReloadSums;
begin
end;

procedure TCDataobjectFrame.UpdateButtons(AIsSelectedSomething: Boolean);
begin
  ActionAdd.Enabled := True;
  ActionEdit.Enabled := List.FocusedNode <> Nil;
  ActionDelete.Enabled := List.FocusedNode <> Nil;
  if Owner.InheritsFrom(TCFrameForm) then begin
    if TCFrameForm(Owner).IsChoice then begin
      TCFrameForm(Owner).BitBtnOk.Enabled := AIsSelectedSomething or (MultipleChecks <> Nil);
    end else begin
      TCFrameForm(Owner).BitBtnOk.Enabled := True;
    end;
  end;
end;

procedure TCDataobjectFrame.WndProc(var Message: TMessage);
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
    end else if Msg = WM_DATAREFRESH then begin
      RefreshData;
    end;
  end;
end;

procedure TCDataobjectFrame.ActionAddExecute(Sender: TObject);
var xForm: TCDataobjectForm;
begin
  xForm := GetDataobjectForm(WMOPT_NONE).Create(Nil);
  xForm.ShowDataobject(coAdd, GetDataobjectProxy(WMOPT_NONE), Nil, True);
  xForm.Free;
end;

procedure TCDataobjectFrame.ActionEditExecute(Sender: TObject);
var xForm: TCDataobjectForm;
begin
  xForm := GetDataobjectForm(WMOPT_NONE).Create(Nil);
  xForm.ShowDataobject(coEdit, GetDataobjectProxy(WMOPT_NONE), TDataObject(List.SelectedElement.Data), True);
  xForm.Free;
end;

procedure TCDataobjectFrame.ActionDeleteExecute(Sender: TObject);
var xData: TDataObject;
    xBase: TDataObject;
begin
  xBase := TDataObject(List.SelectedElement.Data);
  if xBase.CanBeDeleted(xBase.id) then begin
    if ShowInfo(itQuestion, 'Czy chcesz usun¹æ obiekt o nazwie "' + xBase.GetElementText + '" ?', '') then begin
      xData := GetDataobjectClass(WMOPT_NONE).LoadObject(GetDataobjectProxy(WMOPT_NONE), xBase.id, False);
      xData.DeleteObject;
      GDataProvider.CommitTransaction;
      SendMessageToFrames(TCBaseFrameClass(ClassType), WM_DATAOBJECTDELETED, Integer(@xBase.id), 0);
    end;
  end;
end;

procedure TCDataobjectFrame.RecreateTreeHelper;
begin
  CopyListToTreeHelper(Dataobjects, List.RootElement);
end;

procedure TCDataobjectFrame.CStaticFilterChanged(Sender: TObject);
begin
  RefreshData;
end;

procedure TCDataobjectFrame.CStaticFilterGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
var xList: TStringList;
    xGid, xText: String;
    xRect: TRect;
begin
  xList := GetStaticFilter;
  if xList <> Nil then begin
    xGid := CEmptyDataGid;
    xText := '';
    xRect := Rect(10, 10, 300, 500);
    AAccepted := TCFrameForm.ShowFrame(TCListFrame, xGid, xText, xList, @xRect);
    if AAccepted then begin
      ADataGid := xGid;
      AText := xText;
    end;
  end;
end;

function TCDataobjectFrame.GetStaticFilter: TStringList;
begin
  Result := Nil;
end;

constructor TCDataobjectFrameData.CreateWithFilter(AFilterId: String);
begin
  inherited Create;
  FFilterId := AFilterId;
end;

procedure TCDataobjectFrame.ListDblClick(Sender: TObject);
begin
  if List.FocusedNode <> Nil then begin
    if Owner.InheritsFrom(TCFrameForm) then begin
      TCFrameForm(Owner).BitBtnOkClick(Nil);
    end else begin
      ActionEdit.Execute;
    end;
  end;
end;

procedure TCDataobjectFrame.ReloadDataobjects;
begin
  if Dataobjects <> Nil then begin
    FreeAndNil(Dataobjects);
  end;
end;

function TCDataobjectFrame.IsValidFilteredObject(AObject: TDataObject): Boolean;
begin
  Result := (CStaticFilter.DataId = CFilterAllElements);
end;

procedure TCDataobjectFrame.RefreshData;
begin
  List.ReloadTree;
  ListFocusChanged(List, List.FocusedNode, 0);
  ReloadSums;
end;

procedure TCDataobjectFrame.ListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var xFirst, xSecond: TCDataListElementObject;
begin
  if Column <> -1 then begin
    xFirst := List.GetTreeElement(Node1).Data;
    xSecond := List.GetTreeElement(Node2).Data;
    Result := xFirst.GetElementCompare(Column, xSecond);
  end;
end;

function TCDataobjectFrame.GetDataobjectParent(ADataobject: TDataObject): TCListDataElement;
begin
  Result := List.RootElement;
end;

function TCDataobjectFrame.FindNodeId(ANode: PVirtualNode): ShortString;
begin
  Result := List.GetTreeElement(ANode).Data.GetElementId;
end;

function TCDataobjectFrame.FindNode(ADataId: TDataGid; AList: TCList): PVirtualNode;
var xCurNode: PVirtualNode;
    xData: TCListDataElement;
begin
  Result := Nil;
  xCurNode := AList.GetFirst;
  while (Result = Nil) and (xCurNode <> Nil) do begin
    xData := TCDataList(AList).GetTreeElement(xCurNode);
    if xData.Data.GetElementId = ADataId then begin
      Result := xCurNode;
    end else begin
      xCurNode := AList.GetNext(xCurNode);
    end;
  end;
end;

function TCDataobjectFrame.GetInitialiFilter: String;
begin
  Result := CFilterAllElements;
end;

function TCDataobjectFrame.GetHistoryText: String;
begin
  Result := '';
end;

procedure TCDataobjectFrame.ActionHistoryExecute(Sender: TObject);
begin
  ShowHistory(GetSelectedId);
end;

procedure TCDataobjectFrame.ShowHistory(AGid: TDataGid);
begin
end;

procedure TCDataobjectFrame.HideFrame;
begin
  inherited HideFrame;
  ActionAdd.ShortCut := 0;
  ActionEdit.ShortCut := 0;
  ActionDelete.ShortCut := 0;
end;

procedure TCDataobjectFrame.ShowFrame;
begin
  inherited ShowFrame;
  ActionAdd.ShortCut := ShortCut(Word('D'), [ssCtrl]);
  ActionEdit.ShortCut := ShortCut(Word('E'), [ssCtrl]);
  ActionDelete.ShortCut := ShortCut(Word('U'), [ssCtrl]);
end;

end.
