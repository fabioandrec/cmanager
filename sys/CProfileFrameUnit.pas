unit CProfileFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, Menus, ImgList, PngImageList, VTHeaderPopup,
  ActnList, CComponents, ExtCtrls, VirtualTrees, CDatabase,
  CImageListsUnit;

type
  TCProfileFrame = class(TCBaseFrame)
    ProfileList: TCList;
    PanelFrameButtons: TPanel;
    CButtonAddProfile: TCButton;
    CButtonEditProfile: TCButton;
    CButtonDelProfile: TCButton;
    ActionList: TActionList;
    ActionAddProfile: TAction;
    ActionEditProfile: TAction;
    ActionDelProfile: TAction;
    VTHeaderPopupMenu: TVTHeaderPopupMenu;
    procedure ActionAddProfileExecute(Sender: TObject);
    procedure ActionEditProfileExecute(Sender: TObject);
    procedure ActionDelProfileExecute(Sender: TObject);
    procedure ProfileListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure ProfileListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
    procedure ProfileListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
    procedure ProfileListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure ProfileListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure ProfileListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
    procedure ProfileListDblClick(Sender: TObject);
  private
    FProfileObjects: TDataObjectList;
    procedure ReloadProfiles;
    procedure MessageProfileAdded(AId: TDataGid);
    procedure MessageProfileEdited(AId: TDataGid);
    procedure MessageProfileDeleted(AId: TDataGid);
  protected
    procedure WndProc(var Message: TMessage); override;
    function GetSelectedId: TDataGid; override;
    function GetSelectedText: String; override;
  public
    function GetList: TCList; override;
    procedure InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList); override;
    destructor Destroy; override;
    class function GetTitle: String; override;
  end;

implementation

uses CConfigFormUnit, CDataObjects, CProfileFormUnit, CConsts,
  CInfoFormUnit, CFrameFormUnit, GraphUtil;

{$R *.dfm}

procedure TCProfileFrame.ActionAddProfileExecute(Sender: TObject);
var xForm: TCProfileForm;
begin
  xForm := TCProfileForm.Create(Nil);
  xForm.ShowDataobject(coAdd, ProfileProxy, Nil, True);
  xForm.Free;
end;

procedure TCProfileFrame.ActionEditProfileExecute(Sender: TObject);
var xForm: TCProfileForm;
begin
  xForm := TCProfileForm.Create(Nil);
  xForm.ShowDataobject(coEdit, ProfileProxy, TProfile(ProfileList.GetNodeData(ProfileList.FocusedNode)^), True);
  xForm.Free;
end;

procedure TCProfileFrame.ActionDelProfileExecute(Sender: TObject);
var xData: TDataObject;
    xBase: TDataObject;
begin
  xBase := TDataObject(ProfileList.GetNodeData(ProfileList.FocusedNode)^);
  if TMovementFilter.CanBeDeleted(xBase.id) then begin
    if ShowInfo(itQuestion, 'Czy chcesz usun¹æ profil o nazwie "' + TProfile(xBase).name + '" ?', '') then begin
      xData := TProfile.LoadObject(ProfileProxy, xBase.id, False);
      xData.DeleteObject;
      GDataProvider.CommitTransaction;
      SendMessageToFrames(TCProfileFrame, WM_DATAOBJECTDELETED, Integer(@xBase.id), 0);
    end;
  end;
end;

procedure TCProfileFrame.ProfileListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  TDataObject(ProfileList.GetNodeData(Node)^) := FProfileObjects.Items[Node.Index];
  if MultipleChecks <> Nil then begin
    Node.CheckType := ctCheckBox;
    Node.CheckState := csCheckedNormal;
  end;
end;

procedure TCProfileFrame.ProfileListGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TDataObject);
end;

procedure TCProfileFrame.ProfileListGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var CellText: WideString);
var xData: TProfile;
begin
  xData := TProfile(ProfileList.GetNodeData(Node)^);
  CellText := xData.name;
end;

procedure TCProfileFrame.ProfileListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
var xProfile: TProfile;
begin
  if Node <> Nil then begin
    xProfile := TProfile(ProfileList.GetNodeData(Node)^);
    CButtonEditProfile.Enabled := xProfile.id <> CEmptyDataGid;
    CButtonDelProfile.Enabled := xProfile.id <> CEmptyDataGid;
  end else begin
    CButtonEditProfile.Enabled := False;
    CButtonDelProfile.Enabled := False;
  end;
  if Owner.InheritsFrom(TCFrameForm) then begin
    TCFrameForm(Owner).BitBtnOk.Enabled := (Node <> Nil) or (MultipleChecks <> Nil);
  end;
end;

procedure TCProfileFrame.ProfileListCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var xData1: TProfile;
    xData2: TProfile;
begin
  xData1 := TProfile(ProfileList.GetNodeData(Node1)^);
  xData2 := TProfile(ProfileList.GetNodeData(Node2)^);
  Result := AnsiCompareText(xData1.name, xData2.name);
end;

procedure TCProfileFrame.ProfileListGetHint(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle; var HintText: WideString);
var xData: TProfile;
begin
  xData := TProfile(ProfileList.GetNodeData(Node)^);
  HintText := xData.description;
  LineBreakStyle := hlbForceMultiLine;
end;

procedure TCProfileFrame.ProfileListDblClick(Sender: TObject);
begin
  if ProfileList.FocusedNode <> Nil then begin
    if Owner.InheritsFrom(TCFrameForm) then begin
      TCFrameForm(Owner).BitBtnOkClick(Nil);
    end else begin
      ActionEditProfile.Execute;
    end;
  end;
end;

procedure TCProfileFrame.ReloadProfiles;
begin
  ProfileList.BeginUpdate;
  ProfileList.Clear;
  if FProfileObjects <> Nil then begin
    FreeAndNil(FProfileObjects);
  end;
  FProfileObjects := TDataObject.GetList(TProfile, ProfileProxy, 'select * from profile');
  if AdditionalData <> Nil then begin
    FProfileObjects.Insert(0, AdditionalData);
  end;
  ProfileList.RootNodeCount := FProfileObjects.Count;
  ProfileListFocusChanged(ProfileList, ProfileList.FocusedNode, 0);
  ProfileList.EndUpdate;
end;

procedure TCProfileFrame.MessageProfileAdded(AId: TDataGid);
var xDataobject: TProfile;
    xNode: PVirtualNode;
begin
  xDataobject := TProfile(TProfile.LoadObject(ProfileProxy, AId, True));
  FProfileObjects.Add(xDataobject);
  xNode := ProfileList.AddChild(Nil, xDataobject);
  ProfileList.Sort(xNode, ProfileList.Header.SortColumn, ProfileList.Header.SortDirection);
  ProfileList.FocusedNode := xNode;
  ProfileList.Selected[xNode] := True;
end;

procedure TCProfileFrame.MessageProfileDeleted(AId: TDataGid);
var xNode: PVirtualNode;
begin
  xNode := FindDataobjectNode(AId, ProfileList);
  if xNode <> Nil then begin
    ProfileList.BeginUpdate;
    FProfileObjects.Remove(TProfile(ProfileList.GetNodeData(xNode)^));
    ProfileList.DeleteNode(xNode);
    ProfileList.EndUpdate;
  end;
end;

procedure TCProfileFrame.MessageProfileEdited(AId: TDataGid);
var xDataobject: TProfile;
    xNode: PVirtualNode;
begin
  xNode := FindDataobjectNode(AId, ProfileList);
  if xNode <> Nil then begin
    xDataobject := TProfile(ProfileList.GetNodeData(xNode)^);
    xDataobject.ReloadObject;
    ProfileList.InvalidateNode(xNode);
    ProfileList.Sort(xNode, ProfileList.Header.SortColumn, ProfileList.Header.SortDirection);
  end;
end;

procedure TCProfileFrame.WndProc(var Message: TMessage);
var xDataGid: TDataGid;
begin
  inherited WndProc(Message);
  with Message do begin
    if Msg = WM_DATAOBJECTADDED then begin
      xDataGid := PDataGid(WParam)^;
      MessageProfileAdded(xDataGid);
    end else if Msg = WM_DATAOBJECTEDITED then begin
      xDataGid := PDataGid(WParam)^;
      MessageProfileEdited(xDataGid);
    end else if Msg = WM_DATAOBJECTDELETED then begin
      xDataGid := PDataGid(WParam)^;
      MessageProfileDeleted(xDataGid);
    end;
  end;
end;

function TCProfileFrame.GetSelectedId: TDataGid;
begin
  Result := '';
  if ProfileList.FocusedNode <> Nil then begin
    Result := TProfile(ProfileList.GetNodeData(ProfileList.FocusedNode)^).id;
  end;
end;

function TCProfileFrame.GetSelectedText: String;
begin
  Result := '';
  if ProfileList.FocusedNode <> Nil then begin
    Result := TProfile(ProfileList.GetNodeData(ProfileList.FocusedNode)^).name;
  end;
end;

destructor TCProfileFrame.Destroy;
begin
  if AdditionalData <> Nil then begin
    FProfileObjects.Extract(AdditionalData);
  end;
  FProfileObjects.Free;
  inherited Destroy;
end;

function TCProfileFrame.GetList: TCList;
begin
  Result := ProfileList;
end;

class function TCProfileFrame.GetTitle: String;
begin
  Result := 'Profile';
end;

procedure TCProfileFrame.InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList);
begin
  inherited InitializeFrame(AOwner, AAdditionalData, AOutputData, AMultipleCheck);
  ReloadProfiles;
end;

end.
