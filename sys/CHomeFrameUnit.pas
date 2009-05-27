unit CHomeFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, ImgList, PngImageList, ExtCtrls, StdCtrls,
  pngimage, ActnList, CComponents, Menus, VirtualTrees, StrUtils;

type
  THomeListElement = class(TCDataListElementObject)
  private
    Faction: TAction;
    Fcaption: String;
    FimageIndex: Integer;
  public
    constructor Create(AAction: TAction; ACaption: String = ''; AImageIndex: Integer = -1);
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String; override;
    function GetColumnImage(AColumnIndex: Integer): Integer; override;
    property Action: TAction read Faction;
  end;

  TCHomeFrame = class(TCBaseFrame)
    ActionListSimple: TActionList;
    ActionNewOperation: TAction;
    ActionNewCyclic: TAction;
    ActionOperationsList: TAction;
    ActionPreferences: TAction;
    ActionSetProfile: TAction;
    ActionStartupInfo: TAction;
    ActionAddNewList: TAction;
    List: TCDataList;
    MenuItemBigIcons: TMenuItem;
    MenuItemSmallIcons: TMenuItem;
    PanelShortcutsTitle: TCPanel;
    ImageList16: TPngImageList;
    N4: TMenuItem;
    procedure ActionNewOperationExecute(Sender: TObject);
    procedure ActionNewCyclicExecute(Sender: TObject);
    procedure ActionPreferencesExecute(Sender: TObject);
    procedure ActionSetProfileExecute(Sender: TObject);
    procedure ActionOperationsListExecute(Sender: TObject);
    procedure ActionStartupInfoExecute(Sender: TObject);
    procedure ActionAddNewListExecute(Sender: TObject);
    procedure ListCDataListReloadTree(Sender: TCDataList; ARootElement: TCListDataElement);
    procedure ListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure ListExpanding(Sender: TBaseVirtualTree; Node: PVirtualNode; var Allowed: Boolean);
    procedure ListCollapsing(Sender: TBaseVirtualTree; Node: PVirtualNode; var Allowed: Boolean);
    procedure MenuItemBigIconsClick(Sender: TObject);
    procedure MenuItemSmallIconsClick(Sender: TObject);
    procedure ListGetRowPreferencesName(AHelper: TObject; var APrefname: String);
    procedure ListHotChange(Sender: TBaseVirtualTree; OldNode, NewNode: PVirtualNode);
    procedure ListClick(Sender: TObject);
  public
    procedure ShowFrame; override;
    procedure HideFrame; override;
    procedure InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean); override;
    function GetList: TCList; override;
    class function GetPrefname: String; override;
  end;

implementation

uses CMovementFormUnit, CDatabase, CConfigFormUnit, CDataObjects, CConsts,
  CMovementFrameUnit, CPlannedFormUnit, CPlannedFrameUnit,
  CPreferencesFormUnit, CFrameFormUnit, CProfileFrameUnit, CReports,
  CStartupInfoFrameUnit, CMovementListFormUnit, CDescpatternFormUnit,
  CTools, CPreferences;

{$R *.dfm}

procedure TCHomeFrame.ActionNewOperationExecute(Sender: TObject);
var xForm: TCMovementForm;
begin
  xForm := TCMovementForm.Create(Nil);
  xForm.ShowDataobject(coAdd, BaseMovementProxy, Nil, True);
  xForm.Free;
end;

procedure TCHomeFrame.ActionNewCyclicExecute(Sender: TObject);
var xForm: TCPlannedForm;
begin
  xForm := TCPlannedForm.Create(Nil);
  xForm.ShowDataobject(coAdd, PlannedMovementProxy, Nil, True);
  xForm.Free;
end;

procedure TCHomeFrame.ActionPreferencesExecute(Sender: TObject);
var xPrefs: TCPreferencesForm;
begin
  xPrefs := TCPreferencesForm.Create(Nil);
  xPrefs.ShowPreferences;
  xPrefs.Free;
end;

procedure TCHomeFrame.ActionSetProfileExecute(Sender: TObject);
var xText: String;
    xProfileId: String;
begin
  xProfileId := GActiveProfileId;
  if TCFrameForm.ShowFrame(TCProfileFrame, xProfileId, xText) then begin
    GActiveProfileId := xProfileId;
  end;
end;

procedure TCHomeFrame.ActionOperationsListExecute(Sender: TObject);
var xRep: TTodayOperationsListReport;
begin
  xRep := TTodayOperationsListReport.CreateReport(Nil);
  xRep.ShowReport;
  xRep.Free;
end;

procedure TCHomeFrame.ActionStartupInfoExecute(Sender: TObject);
var xData, xText: String;
begin
  TCFrameForm.ShowFrame(TCStartupInfoFrame, xData, xText);
end;

procedure TCHomeFrame.ActionAddNewListExecute(Sender: TObject);
var xForm: TCMovementListForm;
begin
  xForm := TCMovementListForm.Create(Nil);
  xForm.ShowDataobject(coAdd, MovementListProxy, Nil, True);
  xForm.Free;
end;

procedure TCHomeFrame.HideFrame;
begin
  inherited HideFrame;
  ActionNewOperation.ShortCut := 0;
  ActionAddNewList.ShortCut := 0;
end;

procedure TCHomeFrame.ShowFrame;
begin
  inherited ShowFrame;
  ActionNewOperation.ShortCut := ShortCut(Word('N'), [ssCtrl]);
  ActionAddNewList.ShortCut := ShortCut(Word('L'), [ssCtrl]);
end;

procedure TCHomeFrame.InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean);
begin
  inherited InitializeFrame(AOwner, AAdditionalData, AOutputData, AMultipleCheck, AWithButtons);
  if GBasePreferences.homeListSmall then begin
    MenuItemSmallIcons.Click;
  end;
  List.ReloadTree;
end;

procedure TCHomeFrame.ListCDataListReloadTree(Sender: TCDataList; ARootElement: TCListDataElement);
var xShr: TCListDataElement;
    xPrf: TCListDataElement;
begin
  ARootElement.Add(TCListDataElement.Create(False, List, THomeListElement.Create(Nil), True));
  xShr := TCListDataElement.Create(False, List, THomeListElement.Create(Nil, 'Na skróty - ' + FormatDateTime('dd MMMM yyyy', Now), 6), True);
  ARootElement.Add(xShr);
  xShr.Add(TCListDataElement.Create(False, List, THomeListElement.Create(ActionStartupInfo), True));
  xShr.Add(TCListDataElement.Create(False, List, THomeListElement.Create(ActionNewOperation), True));
  xShr.Add(TCListDataElement.Create(False, List, THomeListElement.Create(ActionAddNewList), True));
  xShr.Add(TCListDataElement.Create(False, List, THomeListElement.Create(ActionNewCyclic), True));
  xShr.Add(TCListDataElement.Create(False, List, THomeListElement.Create(ActionOperationsList), True));
  xPrf := TCListDataElement.Create(False, List, THomeListElement.Create(Nil, 'Ustawienia i profile', 6), True);
  ARootElement.Add(xPrf);
  xPrf.Add(TCListDataElement.Create(False, List, THomeListElement.Create(ActionSetProfile), True));
  xPrf.Add(TCListDataElement.Create(False, List, THomeListElement.Create(ActionPreferences), True));
end;

constructor THomeListElement.Create(AAction: TAction; ACaption: String = ''; AImageIndex: Integer = -1);
begin
  inherited Create;
  Faction := AAction;
  Fcaption := ACaption;
  FimageIndex := AImageIndex;
  if (Fcaption = '') and (Faction <> Nil) then begin
    Fcaption := Faction.Caption;
  end;
  if (FimageIndex = -1) and (Faction <> Nil) then begin
    FimageIndex := Faction.ImageIndex;
  end;
end;

function THomeListElement.GetColumnImage(AColumnIndex: Integer): Integer;
begin
  Result := FimageIndex;
end;

function THomeListElement.GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String;
begin
  Result := Fcaption;
end;

procedure TCHomeFrame.ListInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  InitialStates := InitialStates + [ivsExpanded];
end;

procedure TCHomeFrame.ListExpanding(Sender: TBaseVirtualTree; Node: PVirtualNode; var Allowed: Boolean);
begin
  Allowed := True;
end;

procedure TCHomeFrame.ListCollapsing(Sender: TBaseVirtualTree; Node: PVirtualNode; var Allowed: Boolean);
begin
  Allowed := False;
end;

function TCHomeFrame.GetList: TCList;
begin
  Result := List;
end;

class function TCHomeFrame.GetPrefname: String;
begin
  Result := CFontPreferencesHomelist;
end;

procedure TCHomeFrame.MenuItemBigIconsClick(Sender: TObject);
begin
  with List do begin
    Images := ImageList;
    MenuItemBigIcons.Checked := True;
    ReinitNode(RootNode, True);
    Repaint;
    GBasePreferences.homeListSmall := False;
  end;
end;

procedure TCHomeFrame.MenuItemSmallIconsClick(Sender: TObject);
begin
  with List do begin
    Images := ImageList16;
    MenuItemSmallIcons.Checked := True;
    ReinitNode(RootNode, True);
    Repaint;
    GBasePreferences.homeListSmall := True;
  end;
end;

procedure TCHomeFrame.ListGetRowPreferencesName(AHelper: TObject; var APrefname: String);
var xData: TCListDataElement;
begin
  xData := TCListDataElement(AHelper);
  APrefname := IfThen(MenuItemBigIcons.Checked, 'B', 'S') + IfThen(THomeListElement(xData.Data).Action <> Nil, 'A', 'G');
end;

procedure TCHomeFrame.ListHotChange(Sender: TBaseVirtualTree; OldNode, NewNode: PVirtualNode);
var xData: TCListDataElement;
begin
  if NewNode <> Nil then begin
    xData := TCListDataElement(List.GetNodeData(NewNode)^);
    if THomeListElement(xData.Data).Action <> Nil then begin
      List.TreeOptions.PaintOptions := List.TreeOptions.PaintOptions + [toHotTrack];
    end else begin
      List.TreeOptions.PaintOptions := List.TreeOptions.PaintOptions - [toHotTrack];
    end;
  end;
end;

procedure TCHomeFrame.ListClick(Sender: TObject);
var xSelected: TCListDataElement;
begin
  xSelected := List.SelectedElement;
  if xSelected <> Nil then begin
    if THomeListElement(xSelected.Data).Action <> Nil then begin
      THomeListElement(xSelected.Data).Action.Execute;
    end;
  end;
end;

end.