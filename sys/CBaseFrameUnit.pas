unit CBaseFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, Contnrs, CDatabase, VirtualTrees, PngImageList, Menus,
  CConfigFormUnit, CBaseFormUnit, CComponents;

type
  TCBaseFrameClass = class of TCBaseFrame;

  TCBaseFrame = class(TFrame)
    ImageList: TPngImageList;
    ListPopupMenu: TPopupMenu;
    N1: TMenuItem;
    Ustawienialisty1: TMenuItem;
    Wywietljakoraport1: TMenuItem;
    procedure Ustawienialisty1Click(Sender: TObject);
    procedure Wywietljakoraport1Click(Sender: TObject);
  private
    FAdditionalData: TObject;
    FOutputData: Pointer;
    FMultipleChecks: TStringList;
    FOwner: TComponent;
  protected
    function GetSelectedId: TDataGid; virtual;
    function GetSelectedText: String; virtual;
    procedure WndProc(var Message: TMessage); override;
    function GetBaseForm: TCBaseForm;
  public
    procedure SaveColumns;
    procedure LoadColumns;
    function GetList: TCList; virtual;
    procedure UpdateOutputData; virtual;
    function FindNode(ADataId: TDataGid; AList: TCList): PVirtualNode; virtual;
    procedure InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList); virtual;
    procedure PrepareCheckStates; virtual;
    class function GetTitle: String; virtual;
    class function GetOperation: TConfigOperation; virtual;
    class function GetPrefname: String; virtual;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function IsValidFilteredObject(AObject: TDataObject): Boolean; virtual;
    function FindNodeId(ANode: PVirtualNode): TDataGid; virtual;
    property OutputData: Pointer read FOutputData;
  published
    property SelectedId: TDataGid read GetSelectedId;
    property SelectedText: String read GetSelectedText;
    property List: TCList read GetList;
    property AdditionalData: TObject read FAdditionalData;
    property MultipleChecks: TStringList read FMultipleChecks;
    property FrameOwner: TComponent read FOwner;
  end;

var GFrames: TObjectList;

procedure SendMessageToFrames(AFrameClass: TCBaseFrameClass; AMsg: Cardinal; AWParam: Cardinal; ALParam: Cardinal);
function FindDataobjectNode(AGid: TDataGid; AList: TCList): PVirtualNode;
function FindTreeobjectNode(AGid: TDataGid; AList: TCList): PVirtualNode;

implementation

uses CConsts, CListPreferencesFormUnit, CReports, CPreferences, Math;

{$R *.dfm}

procedure SendMessageToFrames(AFrameClass: TCBaseFrameClass; AMsg: Cardinal; AWParam: Cardinal; ALParam: Cardinal);
var xCount: Integer;
begin
  for xCount := 0 to GFrames.Count - 1 do begin
    if GFrames.Items[xCount].InheritsFrom(AFrameClass) then begin
       TCBaseFrame(GFrames.Items[xCount]).Perform(AMsg, AWParam, ALParam);
    end;
  end;
end;

function FindDataobjectNode(AGid: TDataGid; AList: TCList): PVirtualNode;
var xCurNode: PVirtualNode;
    xDataobject: TDataObject;
begin
  Result := Nil;
  xCurNode := AList.GetFirst;
  while (Result = Nil) and (xCurNode <> Nil) do begin
    xDataobject := TDataObject(AList.GetNodeData(xCurNode)^);
    if xDataobject.id = AGid then begin
      Result := xCurNode;
    end else begin
      xCurNode := AList.GetNext(xCurNode);
    end;
  end;
end;

function FindTreeobjectNode(AGid: TDataGid; AList: TCList): PVirtualNode;
var xCurNode: PVirtualNode;
    xTreeobject: TTreeObject;
begin
  Result := Nil;
  xCurNode := AList.GetFirst;
  while (Result = Nil) and (xCurNode <> Nil) do begin
    xTreeobject := TTreeObject(AList.GetNodeData(xCurNode)^);
    if xTreeobject.Dataobject.id = AGid then begin
      Result := xCurNode;
    end else begin
      xCurNode := AList.GetNext(xCurNode);
    end;
  end;
end;

constructor TCBaseFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  GFrames.Add(Self);
end;

destructor TCBaseFrame.Destroy;
begin
  SaveColumns;
  GFrames.Remove(Self);
  inherited Destroy;
end;

function TCBaseFrame.FindNode(ADataId: TDataGid; AList: TCList): PVirtualNode;
begin
  Result := FindDataobjectNode(ADataId, AList);
end;

function TCBaseFrame.FindNodeId(ANode: PVirtualNode): TDataGid;
begin
  Result := CEmptyDataGid;
end;

function TCBaseFrame.GetList: TCList;
begin
  Result := Nil;
end;

function TCBaseFrame.GetSelectedId: TDataGid;
begin
  Result := '';
end;

function TCBaseFrame.GetSelectedText: String;
begin
  Result := '';
end;

class function TCBaseFrame.GetTitle: String;
begin
  Result := '';
end;

procedure TCBaseFrame.InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList);
var xList: TCList;
begin
  FOwner := AOwner;
  FAdditionalData := AAdditionalData;
  FMultipleChecks := AMultipleCheck;
  FOutputData := AOutputData;
  xList := GetList;
  if xList <> Nil then begin
    xList.PopupMenu := ListPopupMenu;
    Ustawienialisty1.Visible := GetPrefname <> '';
    if (AMultipleCheck <> Nil) then begin
      xList.TreeOptions.MiscOptions := xList.TreeOptions.MiscOptions + [toCheckSupport];
      xList.CheckImageKind := ckDarkTick;
    end;
  end;
  LoadColumns;
end;

function TCBaseFrame.IsValidFilteredObject(AObject: TDataObject): Boolean;
begin
  Result := True;
end;

procedure TCBaseFrame.PrepareCheckStates;
var xNode: PVirtualNode;
    xList: TCList;
    xAll: Boolean;
    xId: TDataGid;
    xChecked: Boolean;
begin
  xList := GetList;
  if (xList <> Nil) and (FMultipleChecks <> Nil) then begin
    xAll := FMultipleChecks.Count = 0;
    xNode := xList.GetFirst;
    while (xNode <> Nil) do begin
      xNode.CheckType := ctCheckBox;
      xChecked := xAll;
      if not xChecked then begin
        xId := FindNodeId(xNode);
        xChecked := FMultipleChecks.IndexOf(xId) <> -1;
      end;
      if xChecked then begin
        xNode.CheckState := csCheckedNormal;
      end else begin
        xNode.CheckState := csUncheckedNormal;
      end;
      xNode := xList.GetNext(xNode);
    end;
  end;
end;

procedure TCBaseFrame.UpdateOutputData;
var xNode: PVirtualNode;
    xList: TCList;
    xAll: Boolean;
begin
  xList := GetList;
  if (FMultipleChecks <> Nil) and (xList <> Nil) then begin
    FMultipleChecks.Clear;
    xNode := xList.GetFirst;
    xAll := True;
    while (xNode <> Nil) do begin
      if xNode.CheckState = csCheckedNormal then begin
        FMultipleChecks.Add(FindNodeId(xNode));
      end else begin
        xAll := False;
      end;
      xNode := xList.GetNext(xNode);
    end;
    if xAll then begin
      FMultipleChecks.Clear;
    end;
  end;
end;

procedure TCBaseFrame.WndProc(var Message: TMessage);
begin
  inherited WndProc(Message);
  if Message.Msg = WM_MUSTREPAINT then begin
    if GetList <> Nil then begin
      GetList.Invalidate;
    end;
  end;
end;

procedure TCBaseFrame.Ustawienialisty1Click(Sender: TObject);
var xPrefs: TCListPreferencesForm;
begin
  xPrefs := TCListPreferencesForm.Create(Nil);
  if xPrefs.ShowListPreferences(GetPrefname, GViewsPreferences) then begin
    SendMessageToFrames(TCBaseFrameClass(ClassType), WM_MUSTREPAINT, 0, 0);
  end;
  xPrefs.Free;
end;

class function TCBaseFrame.GetPrefname: String;
begin
  Result := '';
end;

procedure TCBaseFrame.Wywietljakoraport1Click(Sender: TObject);
var xReport: TVirtualStringReport;
    xParams: TCVirtualStringTreeParams;
begin
  xParams := TCVirtualStringTreeParams.Create(GetList, GetTitle);
  xReport := TVirtualStringReport.CreateReport(xParams);
  xReport.ShowReport;
  xReport.Free;
  xParams.Free;
end;

class function TCBaseFrame.GetOperation: TConfigOperation;
begin
  Result := coEdit;
end;

procedure TCBaseFrame.LoadColumns;
var xList: TCList;
    xCount: Integer;
    xColumnPref: TViewColumnPref;
    xColumn: TVirtualTreeColumn;
    xPrefname: String;
begin
  xList := GetList;
  if xList <> Nil then begin
    if xList.Header.Columns.Count > 1 then begin
      for xCount := 0 to xList.Header.Columns.Count - 1 do begin
        xPrefname := FOwner.Name + '|' + xList.Name + '|' + IntToStr(xCount);
        xColumnPref := TViewColumnPref(GColumnsPreferences.ByPrefname[xPrefname]);
        if xColumnPref <> Nil then begin
          xColumn := xList.Header.Columns.Items[xCount];
          xColumn.Position := xColumnPref.position;
          xColumn.Width := xColumnPref.width;
          if xColumnPref.visible = 1 then begin
            xColumn.Options := xColumn.Options + [coVisible];
          end else if xColumnPref.visible = 0 then begin
            xColumn.Options := xColumn.Options - [coVisible];
          end;
        end;
      end;
    end;
  end;
end;

procedure TCBaseFrame.SaveColumns;
var xList: TCList;
    xCount: Integer;
    xColumnPref: TViewColumnPref;
    xColumn: TVirtualTreeColumn;
    xPrefname: String;
begin
  xList := GetList;
  if xList <> Nil then begin
    if xList.Header.Columns.Count > 1 then begin
      for xCount := 0 to xList.Header.Columns.Count - 1 do begin
        xPrefname := FOwner.Name + '|' + xList.Name + '|' + IntToStr(xCount);
        xColumnPref := TViewColumnPref(GColumnsPreferences.ByPrefname[xPrefname]);
        if xColumnPref = Nil then begin
          xColumnPref := TViewColumnPref.Create(xPrefname);
          GColumnsPreferences.Add(xColumnPref);
        end;
        xColumn := xList.Header.Columns.Items[xCount];
        xColumnPref.position := xColumn.Position;
        xColumnPref.width := xColumn.Width;
        xColumnPref.visible := IfThen(coVisible in xColumn.Options, 1, 0);
      end;
    end;
  end;
end;

function TCBaseFrame.GetBaseForm: TCBaseForm;
begin
  if FOwner.InheritsFrom(TCBaseForm) then begin
    Result := TCBaseForm(FOwner);
  end else begin
    Result := Nil;
  end;
end;

initialization
  GFrames := TObjectList.Create(False);
finalization
  GFrames.Free;
end.
