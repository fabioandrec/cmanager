unit CBaseFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, Contnrs, CDatabase, VirtualTrees, PngImageList, Menus,
  CConfigFormUnit, CBaseFormUnit, CComponents, ComCtrls;

type
  TCBaseFrameClass = class of TCBaseFrame;

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
    FAdditionalData: TObject;
    FOutputData: Pointer;
    FMultipleChecks: TStringList;
    FOwner: TComponent;
    FWithButtons: Boolean;
    function ExportTree(AType: Integer): String;
  protected
    procedure IncrementalSearch(Sender: TBaseVirtualTree; Node: PVirtualNode; const SearchText: WideString; var Result: Integer);
    function GetSelectedId: TDataGid; virtual;
    function GetSelectedText: String; virtual;
    procedure WndProc(var Message: TMessage); override;
    function GetBaseForm: TCBaseForm;
    procedure Loaded; override;
  public
    procedure HideFrame; virtual;
    procedure ShowFrame; virtual;
    procedure SaveColumns;
    procedure LoadColumns;
    function GetList: TCList; virtual;
    procedure UpdateOutputData; virtual;
    function FindNode(ADataId: TDataGid; AList: TCList): PVirtualNode; virtual;
    procedure InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean); virtual;
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

uses CConsts, CListPreferencesFormUnit, CReports, CPreferences, Math,
  CDatatools, CInfoFormUnit;

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

procedure TCBaseFrame.InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean);
var xList: TCList;
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
    end;
    Odwrzaznaczenie1.Visible := AMultipleCheck <> Nil;
    Odznaczwszystkie1.Visible := AMultipleCheck <> Nil;
    Zaznaczwszystkie1.Visible := AMultipleCheck <> Nil;
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
        xPrefname := FOwner.Name + '|' + Self.ClassName + '|' + xList.Name + '|' + IntToStr(xCount);
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
var xTree: TVirtualStringTree;
    xColumn: TColumnIndex;
    xText: String;
begin
  xTree := TVirtualStringTree(Sender);
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
  end;
end;

initialization
  GFrames := TObjectList.Create(False);
finalization
  GFrames.Free;
end.
