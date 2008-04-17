unit CBaseFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, Contnrs, CDatabase, VirtualTrees, PngImageList, Menus,
  CConfigFormUnit, CBaseFormUnit, CComponents, ComCtrls, CPreferences;

type
  TCBaseFrameClass = class of TCBaseFrame;
  TCheckChanged = procedure (ASender: TObject) of object;

  TCBaseFrame = class(TFrame)
    ImageList: TPngImageList;
    ListPopupMenu: TPopupMenu;
    N1: TMenuItem;
    Ustawienialisty1: TMenuItem;
    Wywietljakoraport1: TMenuItem;
    Eksportuj1: TMenuItem;
    ExportSaveDialog: TSaveDialog;
    JakoplikTXT1: TMenuItem;
    JakoplikRTF1: TMenuItem;
    JakoplikHTML1: TMenuItem;
    plikExcel1: TMenuItem;
    N2: TMenuItem;
    Zaznaczwszystkie1: TMenuItem;
    Odznaczwszystkie1: TMenuItem;
    Odwrzaznaczenie1: TMenuItem;
    N3: TMenuItem;
    procedure Ustawienialisty1Click(Sender: TObject);
    procedure Wywietljakoraport1Click(Sender: TObject);
    procedure JakoplikTXT1Click(Sender: TObject);
    procedure JakoplikRTF1Click(Sender: TObject);
    procedure JakoplikHTML1Click(Sender: TObject);
    procedure plikExcel1Click(Sender: TObject);
    procedure Zaznaczwszystkie1Click(Sender: TObject);
    procedure Odznaczwszystkie1Click(Sender: TObject);
    procedure Odwrzaznaczenie1Click(Sender: TObject);
  private
    FFramePreferences: TFramePref;
    FOnCheckChanged: TCheckChanged;
    FAdditionalData: TObject;
    FOutputData: Pointer;
    FMultipleChecks: TStringList;
    FOwner: TComponent;
    FWithButtons: Boolean;
    FPreparingChecks: Boolean;
    function ExportTree(AType: Integer): String;
  protected
    procedure SetOnCheckChanged(const Value: TCheckChanged); virtual;
    procedure IncrementalSearch(Sender: TBaseVirtualTree; Node: PVirtualNode; const SearchText: WideString; var Result: Integer);
    function GetSelectedId: TDataGid; virtual;
    procedure SetSelectedId(const Value: TDataGid); virtual;
    function GetSelectedType: Integer; virtual;
    function GetSelectedText: String; virtual;
    procedure WndProc(var Message: TMessage); override;
    procedure DoRepaintLists; virtual;
    function GetBaseForm: TCBaseForm;
    procedure Loaded; override;
    procedure DoCheckChanged; virtual;
    procedure ListChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure UpdateSelectedItemPlugins;
    function IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean; virtual;
    procedure ExecuteSelectedPluginAction(ASender: TObject);
  public
    function CanAcceptSelectedObject: Boolean; virtual;
    procedure UpdateButtons(AIsSelectedSomething: Boolean); virtual;
    procedure HideFrame; virtual;
    procedure ShowFrame; virtual;
    procedure SaveColumns;
    procedure SaveFramePreferences; virtual;
    procedure LoadColumns;
    procedure LoadFramePreferences; virtual;
    function GetList: TCList; virtual;
    procedure UpdateOutputData; virtual;
    function FindNode(ADataId: TDataGid; AList: TCList): PVirtualNode; virtual;
    procedure InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean); virtual;
    procedure FinalizeFrame; virtual;
    procedure PrepareCheckStates; virtual;
    function GetCheckType(ANode: PVirtualNode): TCheckType; virtual;
    class function GetTitle: String; virtual;
    class function GetOperation: TConfigOperation; virtual;
    class function GetPrefname: String; virtual;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function IsValidFilteredObject(AObject: TDataObject): Boolean; virtual;
    function FindNodeId(ANode: PVirtualNode): TDataGid; virtual;
    property OutputData: Pointer read FOutputData;
    function MustFreeAdditionalData: Boolean; virtual;
    function IsAllElementChecked(ACheckedCount: Integer): Boolean; virtual;
    function IsAnyElementChecked: Boolean; virtual;
    property OnCheckChanged: TCheckChanged read FOnCheckChanged write SetOnCheckChanged;
    class function GetDataobjectClass(AOption: Integer): TDataObjectClass; virtual; abstract;
    class function GetDataobjectProxy(AOption: Integer): TDataProxy; virtual; abstract;
  published
    property SelectedId: TDataGid read GetSelectedId write SetSelectedId;
    property SelectedText: String read GetSelectedText;
    property SelectedType: Integer read GetSelectedType;
    property List: TCList read GetList;
    property AdditionalData: TObject read FAdditionalData;
    property MultipleChecks: TStringList read FMultipleChecks write FMultipleChecks;
    property FrameOwner: TComponent read FOwner;
    property FramePreferences: TFramePref read FFramePreferences;
  end;

  TRegisteredFrameClass = class(TObject)
  private
    FframeClass: TCBaseFrameClass;
    FframeType: Integer;
    FisReportParamAvaliable: Boolean;
  public
    property frameClass: TCBaseFrameClass read FframeClass write FframeClass;
    property frameType: Integer read FframeType write FframeType;
    property isReportParamAvaliable: Boolean read FisReportParamAvaliable write FisReportParamAvaliable;
  end;

  TRegisteredFrameClasses = class(TObjectList)
  public
    procedure AddClass(AFrameClass: TCBaseFrameClass; AFrameType: Integer; AisReportParamAvaliable: Boolean);
    function FindClass(AFrameType: Integer): TCBaseFrameClass;
  end;

var GFrames: TObjectList;
    GRegisteredClasses: TRegisteredFrameClasses;

procedure SendMessageToFrames(AFrameClass: TCBaseFrameClass; AMsg: Cardinal; AWParam: Cardinal; ALParam: Cardinal);
function FindDataobjectNode(AGid: TDataGid; AList: TCList): PVirtualNode;
function FindTreeobjectNode(AGid: TDataGid; AList: TCList): PVirtualNode;
procedure InitializeFrameGlobals;
procedure FinalizeFrameGlobals;

implementation

uses CConsts, CListPreferencesFormUnit, CReports, Math,
  CDatatools, CInfoFormUnit, CPluginConsts, CPlugins, CFrameFormUnit,
  CTools, CAccountsFrameUnit, CCashpointsFrameUnit, CCurrencydefFrameUnit,
  CCurrencyRateFrameUnit, CDoneFrameUnit, CExtractionItemFrameUnit,
  CExtractionsFrameUnit, CFilterFrameUnit, CLimitsFrameUnit,
  CMovementFrameUnit, CPlannedFrameUnit, CProductsFrameUnit,
  CProfileFrameUnit, CUnitdefFormUnit, CUpdateCurrencyRatesFormUnit,
  CUnitDefFrameUnit, CInstrumentFrameUnit, CInstrumentValueFrameUnit,
  CInvestmentMovementFrameUnit, CInvestmentPortfolioFrameUnit,
  CReportsFrameUnit, CQuickpatternFrameUnit, CDepositInvestmentFrameUnit;

{$R *.dfm}

procedure SendMessageToFrames(AFrameClass: TCBaseFrameClass; AMsg: Cardinal; AWParam: Cardinal; ALParam: Cardinal);
var xCount: Integer;
    xSend: Boolean;
begin
  for xCount := 0 to GFrames.Count - 1 do begin
    xSend := AFrameClass = Nil;
    if not xSend then begin
      xSend := GFrames.Items[xCount].InheritsFrom(AFrameClass);
    end;
    if xSend then begin
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
  FPreparingChecks := False;
  GFrames.Add(Self);
end;

destructor TCBaseFrame.Destroy;
begin
  SaveFramePreferences;
  SaveColumns;
  FinalizeFrame;
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
  Result := CEmptyDataGid;
end;

function TCBaseFrame.GetSelectedText: String;
begin
  Result := '';
end;

class function TCBaseFrame.GetTitle: String;
begin
  Result := '';
end;

procedure TCBaseFrame.InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean);
var xList: TCList;
    xViewPref: TViewPref;
begin
  FOwner := AOwner;
  FAdditionalData := AAdditionalData;
  FMultipleChecks := AMultipleCheck;
  FOutputData := AOutputData;
  FWithButtons := AWithButtons;
  xList := GetList;
  if xList <> Nil then begin
    xList.PopupMenu := ListPopupMenu;
    Ustawienialisty1.Visible := GetPrefname <> '';
    if (AMultipleCheck <> Nil) then begin
      xList.TreeOptions.MiscOptions := xList.TreeOptions.MiscOptions + [toCheckSupport];
      xList.CheckImageKind := ckDarkTick;
      xList.OnChecked := ListChecked;
    end;
    Odwrzaznaczenie1.Visible := AMultipleCheck <> Nil;
    Odznaczwszystkie1.Visible := AMultipleCheck <> Nil;
    Zaznaczwszystkie1.Visible := AMultipleCheck <> Nil;
    UpdateSelectedItemPlugins;
  end;
  LoadFramePreferences;
  LoadColumns;
  xViewPref := TViewPref(GViewsPreferences.ByPrefname[GetPrefname]);
  if (xViewPref <> Nil) then begin
    GetList.ViewPref := xViewPref;
  end;
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
  FPreparingChecks := True;
  xList := GetList;
  if (xList <> Nil) and (FMultipleChecks <> Nil) then begin
    xAll := FMultipleChecks.Count = 0;
    xNode := xList.GetFirst;
    while (xNode <> Nil) do begin
      xNode.CheckType := GetCheckType(xNode);
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
      xList.InvalidateNode(xNode);
      xNode := xList.GetNext(xNode);
    end;
  end;
  FPreparingChecks := False;
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
      if (xNode.CheckState = csCheckedNormal) or (xNode.CheckState = csMixedNormal) then begin
        FMultipleChecks.Add(FindNodeId(xNode));
      end else begin
        xAll := False;
      end;
      xNode := xList.GetNext(xNode);
    end;
    if xAll and IsAllElementChecked(FMultipleChecks.Count) then begin
      FMultipleChecks.Clear;
    end;
  end;
end;

procedure TCBaseFrame.WndProc(var Message: TMessage);
begin
  inherited WndProc(Message);
  if Message.Msg = WM_MUSTREPAINT then begin
    DoRepaintLists;
  end;
end;

procedure TCBaseFrame.Ustawienialisty1Click(Sender: TObject);
var xPrefs: TCListPreferencesForm;
begin
  xPrefs := TCListPreferencesForm.Create(Nil);
  if xPrefs.ShowListPreferences(TViewPref(GViewsPreferences.ByPrefname[GetPrefname])) then begin
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
    for xCount := 0 to xList.Header.Columns.Count - 1 do begin
      xPrefname := FOwner.Name + '|' + Self.ClassName + '|' + xList.Name + '|' + IntToStr(xCount);
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
        if xColumnPref.sortOrder = 1 then begin
          xList.Header.SortDirection := sdAscending;
          xList.Header.SortColumn := xCount;
        end else if xColumnPref.sortOrder = -1 then begin
          xList.Header.SortDirection := sdDescending;
          xList.Header.SortColumn := xCount;
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
    for xCount := 0 to xList.Header.Columns.Count - 1 do begin
      xPrefname := FOwner.Name + '|' + Self.ClassName + '|' + xList.Name + '|' + IntToStr(xCount);
      xColumnPref := TViewColumnPref(GColumnsPreferences.ByPrefname[xPrefname]);
      if xColumnPref = Nil then begin
        xColumnPref := TViewColumnPref.Create(xPrefname);
        GColumnsPreferences.Add(xColumnPref, True);
      end;
      xColumn := xList.Header.Columns.Items[xCount];
      xColumnPref.position := xColumn.Position;
      xColumnPref.width := xColumn.Width;
      xColumnPref.visible := IfThen(coVisible in xColumn.Options, 1, 0);
      if xCount = xList.Header.SortColumn then begin
        xColumnPref.sortOrder := IfThen(xList.Header.SortDirection = sdAscending, 1, -1);
      end else begin
        xColumnPref.sortOrder := 0;
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

function TCBaseFrame.ExportTree(AType: Integer): String;
var xFilter: String;
    xStr: TStringList;
    xDef: String;
    xReport: TVirtualStringReport;
    xParams: TCVirtualStringTreeParams;
    xValid: Boolean;
begin
  case AType of
    0: begin
      xFilter := 'pliki HTML|*.html';
      xDef := '.html';
    end;
    1: begin
      xFilter := 'pliki RTF|*.rtf';
      xDef := '.rtf';
    end;
    2: begin
      xFilter := 'pliki TXT|*.txt';
      xDef := '.txt';
    end;
    3: begin
      xFilter := 'pliki xls|*.xls';
      xDef := '.xls';
    end;
  end;
  ExportSaveDialog.Filter := xFilter;
  ExportSaveDialog.DefaultExt := xDef;
  if ExportSaveDialog.Execute then begin
    if FileExists(ExportSaveDialog.FileName) then begin
      xValid := DeleteFile(ExportSaveDialog.FileName);
      if not xValid then begin
        ShowInfo(itError, 'Nie powiod³o siê usuniêcie pliku ' + ExtractFileName(ExportSaveDialog.FileName), SysErrorMessage(GetLastError));
      end;
    end else begin
      xValid := True;
    end;
    if xValid then begin
      if AType <> 3 then begin
        xStr := TStringList.Create;
        case AType of
          0: begin
            xParams := TCVirtualStringTreeParams.Create(GetList, GetTitle);
            xReport := TVirtualStringReport.CreateReport(xParams);
            xStr.Text := xReport.PrepareContent;
            xReport.Free;
            xParams.Free;
          end;
          1: xStr.Text := GetList.ContentToRTF(tstAll);
          2: xStr.Text := GetList.ContentToText(tstAll, #9);
        end;
        Result := xStr.Text;
        xStr.SaveToFile(ExportSaveDialog.FileName);
        xStr.Free;
      end else begin
        ExportListToExcel(GetList, ExportSaveDialog.FileName);
      end;
    end;
  end;
end;

procedure TCBaseFrame.JakoplikTXT1Click(Sender: TObject);
begin
  ExportTree(2);
end;

procedure TCBaseFrame.JakoplikRTF1Click(Sender: TObject);
begin
  ExportTree(1);
end;

procedure TCBaseFrame.JakoplikHTML1Click(Sender: TObject);
begin
  ExportTree(0);
end;

procedure TCBaseFrame.HideFrame;
begin
  Hide;
end;

procedure TCBaseFrame.ShowFrame;
begin
  Show;
end;

procedure TCBaseFrame.Loaded;
var xCount: Integer;
begin
  inherited Loaded;
  for xCount := 0 to ComponentCount - 1 do begin
    if Components[xCount].InheritsFrom(TCStatic) then begin
      TCStatic(Components[xCount]).TabStop := True;
      TCStatic(Components[xCount]).Transparent := False;
    end else if Components[xCount].InheritsFrom(TRichEdit) then begin
      TRichEdit(Components[xCount]).Font.Name := 'Microsoft Sans Serif';
    end else if Components[xCount].InheritsFrom(TVirtualStringTree) then begin
      TVirtualStringTree(Components[xCount]).IncrementalSearch := isAll;
      TVirtualStringTree(Components[xCount]).OnIncrementalSearch := IncrementalSearch;
    end;
  end;
end;

procedure TCBaseFrame.IncrementalSearch(Sender: TBaseVirtualTree; Node: PVirtualNode; const SearchText: WideString; var Result: Integer);
var xTree: TCList;
    xColumn: TColumnIndex;
    xText: String;
begin
  xTree := TCList(Sender);
  xColumn := xTree.Header.SortColumn;
  if xColumn = NoColumn then begin
    xColumn := xTree.Header.MainColumn;
  end;
  xText := xTree.Text[Node, xColumn];
  Result := IfThen(Pos(AnsiUpperCase(SearchText), AnsiUpperCase(xText)) = 1, 0, 1);
end;

procedure TCBaseFrame.plikExcel1Click(Sender: TObject);
begin
  ExportTree(3);
end;

procedure TCBaseFrame.Zaznaczwszystkie1Click(Sender: TObject);
var xNode: PVirtualNode;
begin
  if List <> Nil then begin
    xNode := List.GetFirst;
    while (xNode <> Nil) do begin
      List.CheckState[xNode] := csCheckedNormal;
      xNode := List.GetNext(xNode);
    end;
    UpdateButtons(List.SelectedCount > 0);
  end;
end;

procedure TCBaseFrame.Odznaczwszystkie1Click(Sender: TObject);
var xNode: PVirtualNode;
begin
  if List <> Nil then begin
    xNode := List.GetFirst;
    while (xNode <> Nil) do begin
      List.CheckState[xNode] := csUncheckedNormal;
      xNode := List.GetNext(xNode);
    end;
    UpdateButtons(List.SelectedCount > 0);
  end;
end;

procedure TCBaseFrame.Odwrzaznaczenie1Click(Sender: TObject);
var xNode: PVirtualNode;
    xState: TCheckState;
begin
  if List <> Nil then begin
    xNode := List.GetFirst;
    while (xNode <> Nil) do begin
      xState := List.CheckState[xNode];
      if xState = csUncheckedNormal then begin
        xState := csCheckedNormal;
      end else if xState = csCheckedNormal then begin
        xState := csUncheckedNormal;
      end;
      List.CheckState[xNode] := xState;
      xNode := List.GetNext(xNode);
    end;
    UpdateButtons(List.SelectedCount > 0);
  end;
end;

procedure TCBaseFrame.DoCheckChanged;
begin
  if Assigned(FOnCheckChanged) then begin
    FOnCheckChanged(Self);
  end;
end;

procedure TCBaseFrame.ListChecked(Sender: TBaseVirtualTree; Node: PVirtualNode);
begin
  if not FPreparingChecks then begin
    DoCheckChanged;
  end;
end;

procedure TCBaseFrame.SetOnCheckChanged(const Value: TCheckChanged);
begin
  FOnCheckChanged := Value;
end;

procedure TCBaseFrame.SetSelectedId(const Value: TDataGid);
var xNode: PVirtualNode;
begin
  if (GetList <> Nil) then begin
    xNode := FindNode(Value, GetList);
    if xNode <> Nil then begin
      GetList.FocusedNode := xNode;
      GetList.Selected[xNode] := True;
    end;
  end;
end;

function TCBaseFrame.GetSelectedType: Integer;
begin
  Result := CSELECTEDITEM_INCORRECT;
end;

procedure TCBaseFrame.UpdateSelectedItemPlugins;
var xCount: Integer;
    xPlugin: TCPlugin;
    xItemPopup: TMenuItem;
begin
  for xCount := 0 to GPlugins.Count - 1 do begin
    xPlugin := TCPlugin(GPlugins.Items[xCount]);
    if xPlugin.isTypeof[CPLUGINTYPE_SELECTEDITEM] and xPlugin.pluginIsEnabled and IsSelectedTypeCompatible(xPlugin.pluginType) then begin
      xItemPopup := TMenuItem.Create(Self);
      xItemPopup.Caption := xPlugin.pluginMenu;
      xItemPopup.Tag := xCount + 1024;
      xItemPopup.OnClick := ExecuteSelectedPluginAction;
      ListPopupMenu.Items.Add(xItemPopup);
    end;
  end;
end;

function TCBaseFrame.IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean;
begin
  Result := False;
end;

procedure TCBaseFrame.ExecuteSelectedPluginAction(ASender: TObject);
var xCount: Integer;
begin
  if ASender.InheritsFrom(TMenuItem) then begin
    xCount := TMenuItem(ASender).Tag - 1024;
    if (xCount >= 0) and (xCount <= GPlugins.Count - 1) then begin
      TCPlugin(GPlugins.Items[xCount]).Execute;
    end;
  end;
end;

procedure TCBaseFrame.UpdateButtons(AIsSelectedSomething: Boolean);
var xCount: Integer;
begin
  if Owner.InheritsFrom(TCFrameForm) then begin
    if TCFrameForm(Owner).IsChoice then begin
      TCFrameForm(Owner).BitBtnOk.Enabled := (AIsSelectedSomething and (MultipleChecks = Nil)) or ((MultipleChecks <> Nil) and IsAnyElementChecked);
    end else begin
      TCFrameForm(Owner).BitBtnOk.Enabled := True;
    end;
  end;
  for xCount := 0 to ListPopupMenu.Items.Count - 1 do begin
    if ListPopupMenu.Items.Items[xCount].Tag >= 1024 then begin
      ListPopupMenu.Items.Items[xCount].Enabled := AIsSelectedSomething;
    end;
  end;
end;

procedure TCBaseFrame.FinalizeFrame;
begin
end;

function TCBaseFrame.MustFreeAdditionalData: Boolean;
begin
  Result := True;
end;

procedure TRegisteredFrameClasses.AddClass(AFrameClass: TCBaseFrameClass; AFrameType: Integer; AisReportParamAvaliable: Boolean);
var xObj: TRegisteredFrameClass;
begin
  xObj := TRegisteredFrameClass.Create;
  xObj.frameClass := AFrameClass;
  xObj.frameType := AFrameType;
  xObj.isReportParamAvaliable := AisReportParamAvaliable;
  Add(xObj);
end;

function TRegisteredFrameClasses.FindClass(AFrameType: Integer): TCBaseFrameClass;
var xCount: Integer;
begin
  xCount := 0;
  Result := Nil;
  while (xCount <= Count - 1) and (Result = Nil) do begin
    if TRegisteredFrameClass(Items[xCount]).frameType = AFrameType then begin
      Result := TRegisteredFrameClass(Items[xCount]).frameClass;
    end;
    Inc(xCount);
  end;
end;

procedure InitializeFrameGlobals;
var xDefaultViewPrefs: TPrefList;
begin
  GFrames := TObjectList.Create(False);
  GRegisteredClasses := TRegisteredFrameClasses.Create(True);
  GRegisteredClasses.AddClass(TCAccountsFrame, CFRAMETYPE_ACCOUNTSFRAME, True);
  GRegisteredClasses.AddClass(TCCashpointsFrame, CFRAMETYPE_CASHPOINTSFRAME, True);
  GRegisteredClasses.AddClass(TCCurrencydefFrame, CFRAMETYPE_CURRENCYDEFFRAME, True);
  GRegisteredClasses.AddClass(TCCurrencyRateFrame, CFRAMETYPE_CURRENCYRATEFRAME, False);
  GRegisteredClasses.AddClass(TCDoneFrame, CFRAMETYPE_DONEFRAME, False);
  GRegisteredClasses.AddClass(TCExtractionItemFrame, CFRAMETYPE_EXTRACTIONITEMFRAME, False);
  GRegisteredClasses.AddClass(TCExtractionsFrame, CFRAMETYPE_EXTRACTIONSFRAME, True);
  GRegisteredClasses.AddClass(TCFilterFrame, CFRAMETYPE_FILTERFRAME, True);
  GRegisteredClasses.AddClass(TCLimitsFrame, CFRAMETYPE_LIMITSFRAME, True);
  GRegisteredClasses.AddClass(TCMovementFrame, CFRAMETYPE_MOVEMENTFRAME, False);
  GRegisteredClasses.AddClass(TCPlannedFrame, CFRAMETYPE_PLANNEDFRAME, False);
  GRegisteredClasses.AddClass(TCProductsFrame, CFRAMETYPE_PRODUCTSFRAME, True);
  GRegisteredClasses.AddClass(TCProfileFrame, CFRAMETYPE_PROFILEFRAME, True);
  GRegisteredClasses.AddClass(TCUnitDefFrame, CFRAMETYPE_UNITDEFFRAME, True);
  GRegisteredClasses.AddClass(TCInstrumentFrame, CFRAMETYPE_INSTRUMENT, True);
  GRegisteredClasses.AddClass(TCInstrumentValueFrame, CFRAMETYPE_INSTRUMENTVALUE, True);
  GRegisteredClasses.AddClass(TCInvestmentMovementFrame, CFRAMETYPE_INVESTMENTMOVEMENT, True);
  GRegisteredClasses.AddClass(TCInvestmentPortfolioFrame, CFRAMETYPE_INVESTMENTPORTFOLIO, True);
  GRegisteredClasses.AddClass(TCQuickpatternFrame, CFRAMETYPE_QUICKPATTERNS, True);
  GRegisteredClasses.AddClass(TCDepositInvestmentFrame, CFRAMETYPE_DEPOSITINVESTMENTFRAME, True);
  GRegisteredClasses.AddClass(TCReportsFrame, CFRAMETYPE_REPORTS, True);
  xDefaultViewPrefs := GetDefaultViewPreferences;
  GViewsPreferences.Clone(xDefaultViewPrefs);
  xDefaultViewPrefs.Free;
end;

procedure FinalizeFrameGlobals;
begin
  GFrames.Free;
  GRegisteredClasses.Free;
end;

function TCBaseFrame.IsAllElementChecked(ACheckedCount: Integer): Boolean;
begin
  Result := True;
end;

function TCBaseFrame.IsAnyElementChecked: Boolean;
var xNode: PVirtualNode;
begin
  Result := False;
  if GetList <> Nil then begin
    xNode := GetList.GetFirst;
    while (xNode <> Nil) and (not Result) do begin
      Result := ((xNode.CheckState = csCheckedNormal) or (xNode.CheckState = csMixedNormal)) and (xNode.CheckType <> ctNone);
      xNode := GetList.GetNext(xNode);
    end;
  end;
end;

function TCBaseFrame.CanAcceptSelectedObject: Boolean;
begin
  Result := True;
end;

procedure TCBaseFrame.DoRepaintLists;
begin
  if GetList <> Nil then begin
    GetList.ReinitNode(GetList.RootNode, True);
    GetList.Repaint;
  end;
end;

function TCBaseFrame.GetCheckType(ANode: PVirtualNode): TCheckType;
begin
  Result := ctCheckBox;
end;

procedure TCBaseFrame.LoadFramePreferences;
begin
  if GetPrefname <> '' then begin
    FFramePreferences := TFramePref(GFramePreferences.ByPrefname[GetPrefname]);
    if FFramePreferences = Nil then begin
      FFramePreferences := TFramePref(GFramePreferences.AppendNewPrefitem(GetPrefname));
    end;
  end;
end;

procedure TCBaseFrame.SaveFramePreferences;
begin
end;

initialization
finalization
  FinalizeFrameGlobals;
end.
