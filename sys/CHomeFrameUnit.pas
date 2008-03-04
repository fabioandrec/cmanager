unit CHomeFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, ImgList, PngImageList, ExtCtrls, StdCtrls,
  pngimage, ActnList, CComponents, Menus, VirtualTrees;

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
  end;

  TCHomeFrame = class(TCBaseFrame)
    Image1: TImage;
    Label1: TLabel;
    CButton1: TCButton;
    ActionListSimple: TActionList;
    ActionNewOperation: TAction;
    ActionNewCyclic: TAction;
    CButton2: TCButton;
    ActionOperationsList: TAction;
    CButton3: TCButton;
    ActionPreferences: TAction;
    CButton4: TCButton;
    Image2: TImage;
    Label2: TLabel;
    ActionSetProfile: TAction;
    CButton5: TCButton;
    CButton6: TCButton;
    ActionStartupInfo: TAction;
    CButton7: TCButton;
    ActionAddNewList: TAction;
    List: TCDataList;
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
  public
    constructor Create(AOwner: TComponent); override;
    procedure ShowFrame; override;
    procedure HideFrame; override;
    procedure InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean); override;
  end;

implementation

uses CMovementFormUnit, CDatabase, CConfigFormUnit, CDataObjects, CConsts,
  CMovementFrameUnit, CPlannedFormUnit, CPlannedFrameUnit,
  CPreferencesFormUnit, CFrameFormUnit, CProfileFrameUnit, CReports,
  CStartupInfoFrameUnit, CMovementListFormUnit, CDescpatternFormUnit,
  CTools;

{$R *.dfm}

constructor TCHomeFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Label1.Caption := Label1.Caption + ' - ' + FormatDateTime('dd MMMM yyyy', Now);
end;

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
  List.ReloadTree;
end;

procedure TCHomeFrame.ListCDataListReloadTree(Sender: TCDataList; ARootElement: TCListDataElement);
var xShr: TCListDataElement;
    xPrf: TCListDataElement;
begin
  ARootElement.Add(TCListDataElement.Create(False, List, THomeListElement.Create(Nil, ''), True));
  ARootElement.Add(TCListDataElement.Create(False, List, THomeListElement.Create(Nil, ''), True));
  xShr := TCListDataElement.Create(False, List, THomeListElement.Create(Nil, 'Na skróty'), True);
  ARootElement.Add(xShr);
  xShr.Add(TCListDataElement.Create(False, List, THomeListElement.Create(ActionStartupInfo), True));
  xShr.Add(TCListDataElement.Create(False, List, THomeListElement.Create(ActionNewOperation), True));
  xShr.Add(TCListDataElement.Create(False, List, THomeListElement.Create(ActionAddNewList), True));
  xShr.Add(TCListDataElement.Create(False, List, THomeListElement.Create(ActionNewCyclic), True));
  xShr.Add(TCListDataElement.Create(False, List, THomeListElement.Create(ActionOperationsList), True));
  xPrf := TCListDataElement.Create(False, List, THomeListElement.Create(Nil, 'Ustawienia i profile'), True);
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

end.
