unit CComponents;

interface

uses Windows, Messages, Graphics, Controls, Classes, CommCtrl, ImgList,
     Buttons, StdCtrls, ExtCtrls, SysUtils, ComCtrls, IntfUIHandlers, ShDocVw,
     ActiveX, PngImageList, VirtualTrees, GraphUtil, Contnrs, Types, RichEdit,
     ShellApi, CXml, PngImage, Menus, Dialogs, ActnList, Themes;

type
  TPicturePosition = (ppLeft, ppTop, ppRight);

  TPrefList = class;
  TPrefItemClass = class of TPrefItem;

  TPrefItem = class(TObject)
  private
    FPrefname: String;
    function FindNode(AParentNode: ICXMLDOMNode; ACanCreate: Boolean): ICXMLDOMNode;
  protected
    procedure LoadFromParentNode(AParentNode: ICXMLDOMNode);
    procedure SaveToParentNode(AParentNode: ICXMLDOMNode);
  public
    procedure LoadFromXml(ANode: ICXMLDOMNode); virtual;
    procedure SaveToXml(ANode: ICXMLDOMNode); virtual;
    procedure Clone(APrefItem: TPrefItem); virtual;
    constructor Create(APrefname: String); virtual;
    function GetNodeName: String; virtual; abstract;
  published
    property Prefname: String read FPrefname write FPrefname;
  end;

  TGetItemClassFunction = function (APrefname: String): TPrefItemClass of object;

  TPrefList = class(TObjectList)
  private
    FItemClass: TPrefItemClass;
    FGetItemClassFunction: TGetItemClassFunction;
    function GetItems(AIndex: Integer): TPrefItem;
    procedure SetItems(AIndex: Integer; const Value: TPrefItem);
    function GetByPrefname(APrefname: String): TPrefItem;
  public
    procedure Clone(APrefList: TPrefList);
    function Add(AObject: TObject; ACheckUniqe: Boolean): Integer;
    constructor Create(AItemClass: TPrefItemClass); overload;
    constructor Create(AGetItemClassFunction: TGetItemClassFunction); overload;
    procedure LoadFromParentNode(AParentNode: ICXMLDOMNode);
    procedure LoadAllFromParentNode(AParentNode: ICXMLDOMNode);
    function AppendNewPrefitem(APrefname: String): TPrefItem;
    procedure SavetToParentNode(AParentNode: ICXMLDOMNode);
    property Items[AIndex: Integer]: TPrefItem read GetItems write SetItems;
    property ByPrefname[APrefname: String]: TPrefItem read GetByPrefname;
  end;

  TFontPref = class(TPrefItem)
  private
    FBackground: TColor;
    FBackgroundEven: TColor;
    FRowHeight: Integer;
    FFont: TFont;
    FDesc: String;
  public
    procedure LoadFromXml(ANode: ICXMLDOMNode); override;
    procedure SaveToXml(ANode: ICXMLDOMNode); override;
    procedure Clone(APrefItem: TPrefItem); override;
    function GetNodeName: String; override;
    property Font: TFont read FFont;
    property Background: TColor read FBackground write FBackground;
    property BackgroundEven: TColor read FBackgroundEven write FBackgroundEven;
    property RowHeight: Integer read FRowHeight write FRowHeight;
    property Desc: String read FDesc;
    constructor Create(APrefname: String); override;
    constructor CreateFontPref(APrefname: String; ADesc: String);
    destructor Destroy; override;
  end;

  TViewColumnPref = class(TPrefItem)
  private
    Fposition: Integer;
    Fwidth: Integer;
    Fvisible: Integer;
    FsortOrder: Integer;
  public
    procedure LoadFromXml(ANode: ICXMLDOMNode); override;
    procedure SaveToXml(ANode: ICXMLDOMNode); override;
    procedure Clone(APrefItem: TPrefItem); override;
    function GetNodeName: String; override;
  published
    property position: Integer read Fposition write Fposition;
    property width: Integer read Fwidth write Fwidth;
    property visible: Integer read Fvisible write Fvisible;
    property sortOrder: Integer read FsortOrder write FsortOrder;
  end;

  TViewPref = class(TPrefItem)
  private
    FFontprefs: TPrefList;
    FFocusedBackgroundColor: TColor;
    FFocusedFontColor: TColor;
    FButtonSmall: Boolean;
  public
    procedure LoadFromXml(ANode: ICXMLDOMNode); override;
    procedure SaveToXml(ANode: ICXMLDOMNode); override;
    procedure Clone(APrefItem: TPrefItem); override;
    function GetNodeName: String; override;
    constructor Create(APrefname: String); override;
    destructor Destroy; override;
    property Fontprefs: TPrefList read FFontprefs;
    property FocusedBackgroundColor: TColor read FFocusedBackgroundColor write FFocusedBackgroundColor;
    property FocusedFontColor: TColor read FFocusedFontColor write FFocusedFontColor;
    property ButtonSmall: Boolean read FButtonSmall write FButtonSmall;
  end;

  TCButton = class(TGraphicControl)
  private
    FMouseIn: Boolean;
    FPicPosition: TPicturePosition;
    FPicOffset: Integer;
    FTxtOffset: Integer;
    FFramed: Boolean;
    procedure SetPicturePosition(const Value: TPicturePosition);
    procedure SetPicOffset(const Value: Integer);
    procedure SetTxtOffset(const Value: Integer);
    procedure SetFramed(const Value: Boolean);
  protected
    procedure Paint; override;
    procedure CMMouseenter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseleave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;
    procedure SetEnabled(Value: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    property Canvas;
  published
    property PicPosition: TPicturePosition read FPicPosition write SetPicturePosition;
    property PicOffset: Integer read FPicOffset write SetPicOffset;
    property TxtOffset: Integer read FTxtOffset write SetTxtOffset;
    property Framed: Boolean read FFramed write SetFramed;
    property Action;
    property Anchors;
    property Caption;
    property Enabled;
    property OnClick;
    property Color;
    property Font;
    property OnMouseDown;
  end;

  TCImage = class(TGraphicControl)
  private
    FImageList: TPngImageList;
    FImageIndex: Integer;
    procedure SetImageIndex(const Value: Integer);
    procedure SeTPngImageList(const Value: TPngImageList);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property ImageList: TPngImageList read FImageList write SeTPngImageList;
    property ImageIndex: Integer read FImageIndex write SetImageIndex;
  end;

  TOnGetDataId = procedure (var ADataGid: String; var AText: String; var AAccepted: Boolean) of Object;
  TOnClearDataId = procedure (ACurrentDataGid: String; var ACanClear: Boolean) of Object;

  TCStatic = class(TStaticText)
  private
    FDataId: string;
    FOnGetDataId: TOnGetDataId;
    FOnClearDataId: TOnClearDataId;
    FOnChanged: TNotifyEvent;
    FTextOnEmpty: string;
    FHotTrack: Boolean;
    FOldColor: TColor;
    FCanvas: TCanvas;
    FInternalIsFocused: Boolean;
    procedure SetDataId(const Value: string);
    procedure SetTextOnEmpty(const Value: string);
  protected
    procedure CMMouseenter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseleave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMTextchanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure Loaded; override;
    procedure Click; override;
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure WndProc(var Message: TMessage); override;
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure DoGetDataId;
    procedure DoClearDataId(var ACanAccept: Boolean);
    property Canvas: TCanvas read FCanvas;
    destructor Destroy; override;
    function CanFocus: Boolean; override;
  published
    property DataId: string read FDataId write SetDataId;
    property TextOnEmpty: string read FTextOnEmpty write SetTextOnEmpty;
    property Action;
    property OnKeyDown;
    property OnKeyPress;
    property Enabled;
    property OnGetDataId: TOnGetDataId read FOnGetDataId write FOnGetDataId;
    property OnClearDataId: TOnClearDataId read FOnClearDataId write FOnClearDataId;
    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
    property HotTrack: Boolean read FHotTrack write FHotTrack;
  end;

  TCDateTime = class(TStaticText)
  private
    FValue: TDateTime;
    FOnChanged: TNotifyEvent;
    FHotTrack: Boolean;
    FOldColor: TColor;
    FInternalIsFocused: Boolean;
    FCanvas: TCanvas;
    FWithtime: Boolean;
    procedure SetValue(const Value: TDateTime);
    procedure UpdateCaption;
    procedure SetWithtime(const Value: Boolean);
  protected
    procedure CMMouseenter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseleave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure Click; override;
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure WndProc(var Message: TMessage); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CanFocus: Boolean; override;
  published
    property Value: TDateTime read FValue write SetValue;
    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
    property HotTrack: Boolean read FHotTrack write FHotTrack;
    property Withtime: Boolean read FWithtime write SetWithtime;
  end;

  TCEditError = class(Exception);

  TCCurrEdit = class(TCustomEdit)
  private
    FAlign: TAlignment;
    FValue: Double;
    FMaxDigits: smallint;
    FDecimals: smallint;
    FCurrencyStr: string;
    FOldText: string;
    FShowKSeps: boolean;
    FEditMode: boolean;
    FWithCalculator: Boolean;
    FCurrencyId: String;
    procedure SetTextFromValue;
    function LeftStr(OrgStr: string; CharCount: smallint): string;
    function RightStr(OrgStr: string; CharCount: smallint): string;
    function InsertChars(OrgStr, InsChars: string; CharPos: smallint): string;
    function DeleteChars(OrgStr: string; CharPos, CharCount: smallint): string;
    function ReplaceChars(OrgStr, ReplChars: string; CharPos: smallint): string;
    function ReplaceChars2(OrgStr: string; ReplChar: Char; CharPos, CharCount: smallint): string;
    function GetDecimals: smallint;
    procedure SetDecimals(Value: smallint);
    function GetValue: Double;
    procedure SetValue(Value: Double);
    procedure SetCurrencyStr(const Value: String);
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure DoEnter; override;
    procedure DoExit; override;
  public
    function FormatIt(AValue: Double; ShowMode: boolean): string;
    constructor Create(AOwner: TComponent); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Update; override;
    function AsCurrency: Currency;
    function AsFloat: Double;
    function AsString: string;
    destructor Destroy; override;
    procedure SetCurrencyDef(AId, ASymbol: String);
  published
    property AutoSelect;
    property AutoSize;
    property Anchors;
    property BorderStyle;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property MaxLength;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property Decimals: smallint read GetDecimals write SetDecimals;
    property Value: Double read GetValue write SetValue;
    property ThousandSep: Boolean read FShowKSeps write FShowKSeps;
    property CurrencyStr: String read FCurrencyStr write SetCurrencyStr;
    property BevelEdges;
    property BevelKind;
    property BevelOuter;
    property BevelInner;
    property BevelWidth;
    property WithCalculator: Boolean read FWithCalculator write FWithCalculator;
    property CurrencyId: String read FCurrencyId write FCurrencyId;
  end;

  TCBrowser = class(TWebBrowser, IDocHostUIHandler)
  private
    FAutoVSize: Boolean;
    procedure SetAutoVSize(const Value: Boolean);
  public
    function LoadFromString(AInString: String): Boolean;
    function ShowContextMenu(const dwID: Cardinal; const ppt: PPoint; const pcmdtReserved: IInterface; const pdispReserved: IDispatch): HRESULT; stdcall;
    function GetHostInfo(var pInfo: TDocHostUIInfo): HRESULT; stdcall;
    function ShowUI(const dwID: Cardinal; const pActiveObject: IOleInPlaceActiveObject; const pCommandTarget: IOleCommandTarget; const pFrame: IOleInPlaceFrame; const pDoc: IOleInPlaceUIWindow): HRESULT; stdcall;
    function HideUI: HRESULT; stdcall;
    function EnableModeless(const fEnable: LongBool): HRESULT; stdcall;
    function UpdateUI: HRESULT; stdcall;
    function OnDocWindowActivate(const fActivate: BOOL): HResult; stdcall;
    function OnFrameWindowActivate(const fActivate: BOOL): HResult; stdcall;
    function ResizeBorder(const prcBorder: PRECT; const pUIWindow: IOleInPlaceUIWindow; const fFrameWindow: BOOL): HResult; stdcall;
    function TranslateAccelerator(const lpMsg: PMSG; const pguidCmdGroup: PGUID; const nCmdID: DWORD): HResult; stdcall;
    function GetOptionKeyPath(var pchKey: POLESTR; const dw: DWORD ): HResult; stdcall;
    function GetDropTarget(const pDropTarget: IDropTarget; out ppDropTarget: IDropTarget): HResult; stdcall;
    function GetExternal(out ppDispatch: IDispatch): HResult; stdcall;
    function TranslateUrl(const dwTranslate: DWORD; const pchURLIn: POLESTR; var ppchURLOut: POLESTR): HResult; stdcall;
    function FilterDataObject(const pDO: IDataObject; out ppDORet: IDataObject): HResult; stdcall;
    procedure WaitFor;
    procedure CancelRequest;
    constructor Create(AOwner: TComponent); override;
  published
    property AutoVSize: Boolean read FAutoVSize write SetAutoVSize;
  end;

  TCIntEdit = class(TEdit)
  private
    function GetValue: Integer;
    procedure SetValue(const Value: Integer);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DoExit; override;
    procedure DoEnter; override;
  public
    property Value: Integer read GetValue write SetValue;
  end;

  TCDataList = class;

  TCDataListElementObject = class
  public
    function GetElementType: String; virtual;
    function GetElementId: String; virtual;
    function GetElementText: String; virtual;
    function GetElementHint(AColumnIndex: Integer): String; virtual;
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String; virtual; abstract;
    function GetColumnImage(AColumnIndex: Integer): Integer; virtual;
    function GetElementCompare(AColumnIndex: Integer; ACompareWith: TCDataListElementObject; AViewTextSelector: String): Integer; virtual;
    procedure GetElementReload; virtual; 
  end;

  TCDataListSimpleString = class(TCDataListElementObject)
  private
    FCaption: String;
  public
    constructor Create(ACaption: String);
    function GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String; override;
  end;

  TCListDataElement = class(TObjectList)
  private
    FFreeDataOnClear: Boolean;
    FParentList: TCDataList;
    FData: TCDataListElementObject;
    FNode: PVirtualNode;
    FCheckState: Boolean;
    FCheckSupport: Boolean;
    function GetItems(AIndex: Integer): TCListDataElement;
    procedure SetItems(AIndex: Integer; const Value: TCListDataElement);
  public
    constructor Create(ACheckSupport: Boolean; AParentList: TCDataList; AData: TCDataListElementObject; AFreeDataOnClear: Boolean = False; ACheckState: Boolean = True);
    function FindDataElement(AId: String; AElementType: String = ''; ARecursive: Boolean = True): TCListDataElement;
    procedure DeleteDataElement(AId: String; AElementType: String = '');
    procedure RefreshDataElement(AId: String; AElementType: String = '');
    function AppendDataElement(ANodeData: TCListDataElement): PVirtualNode;
    property Items[AIndex: Integer]: TCListDataElement read GetItems write SetItems;
    property ParentList: TCDataList read FParentList write FParentList;
    property Data: TCDataListElementObject read FData write FData;
    property Node: PVirtualNode read FNode write FNode;
    property CheckState: Boolean read FCheckState write FCheckState;
    property CheckSupport: Boolean read FCheckSupport write FCheckSupport;
    destructor Destroy; override;
    property FreeDataOnClear: Boolean read FFreeDataOnClear write FFreeDataOnClear;
  end;

  TGetRowPreferencesName = procedure (AHelper: TObject; var APrefname: String) of object;

  TCList = class(TVirtualStringTree)
  private
    FAutoExpand: Boolean;
    FViewPref: TViewPref;
    FOnGetRowPreferencesName: TGetRowPreferencesName;
    procedure SetViewPref(const Value: TViewPref);
  protected
    procedure DoOnGetRowPreferencesName(AHelper: TObject; var APrefname: String); virtual;
    procedure DoBeforeItemErase(Canvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var Color: TColor; var EraseAction: TItemEraseAction); override;
    procedure DoHeaderClick(Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer); override;
    procedure DoViewPrefChanged; virtual;
    procedure DoMeasureItem(TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer); override;
    procedure DoPaintText(Node: PVirtualNode; const Canvas: TCanvas; Column: TColumnIndex; TextType: TVSTTextType); override;
  public
    constructor Create(AOwner: TComponent); override;
    function GetVisibleIndex(ANode: PVirtualNode): Integer;
    function SumColumn(AColumnIndex: TColumnIndex; var ASum: Extended): Boolean;
    destructor Destroy; override;
    procedure Repaint; override;
  published
    property AutoExpand: Boolean read FAutoExpand write FAutoExpand;
    property ViewPref: TViewPref read FViewPref write SetViewPref;
    property OnGetRowPreferencesName: TGetRowPreferencesName read FOnGetRowPreferencesName write FOnGetRowPreferencesName;
  end;

  TCPanel = class(TPanel)
  protected
    procedure Paint; override;
  public
    function GetTextLeft: Integer;
  published
    property BevelEdges;
  end;

  TCDataListOnReloadTree = procedure (Sender: TCDataList; ARootElement: TCListDataElement) of object;

  TCDataList = class(TCList)
  private
    FCOnReloadTree: TCDataListOnReloadTree;
    FRootElement: TCListDataElement;
    FViewTextSelector: String;
    function GetSelectedId: String;
    function GetSelectedText: String;
    function GetSelectedElement: TCListDataElement;
    procedure SetViewTextSelector(const Value: String);
  protected
    procedure ValidateNodeDataSize(var Size: Integer); override;
    procedure DoInitNode(Parent, Node: PVirtualNode; var InitStates: TVirtualNodeInitStates); override;
    procedure DoGetText(Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var Text: WideString); override;
    function DoGetImageIndex(Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var Index: Integer): TCustomImageList; override;
    procedure DoInitChildren(Node: PVirtualNode; var ChildCount: Cardinal); override;
    function DoGetNodeHint(Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle): WideString; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ReloadTree;
    function GetTreeElement(ANode: PVirtualNode): TCListDataElement;
    property RootElement: TCListDataElement read FRootElement;
    property SelectedId: String read GetSelectedId;
    property SelectedText: String read GetSelectedText;
    property SelectedElement: TCListDataElement read GetSelectedElement;
  published
    property OnCDataListReloadTree: TCDataListOnReloadTree read FCOnReloadTree write FCOnReloadTree;
    property ViewTextSelector: String read FViewTextSelector write SetViewTextSelector;
  end;

  TCStatusPanel = class(TStatusPanel)
  private
    FImageIndex: Integer;
    FClickable: Boolean;
    procedure SetImageIndex(const Value: Integer);
  public
    constructor Create(Collection: TCollection); override;
  published
    property ImageIndex: Integer read FImageIndex write SetImageIndex;
    property Clickable: Boolean read FClickable write FClickable;
  end;

  TCStatusBar = class(TStatusBar)
  private
    FImageList: TPngImageList;
  protected
    function GetPanelClass: TStatusPanelClass; override;
    procedure DrawPanel(Panel: TStatusPanel; const Rect: TRect); override;
    procedure CMMouseenter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseleave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure MouseMove(Shift: TShiftState; X: Integer; Y: Integer); override;
  public
    procedure SetPngImageList(const Value: TPngImageList);
    procedure UpdateCursor;
    function GeTCPanelWithMouse: TCStatusPanel;
    constructor Create(AOwner: TComponent); override;
  published
    property ImageList: TPngImageList read FImageList write SetPngImageList;
  end;

  TURLClickEvent = procedure(Sender :TObject; const URL: string) of object;

  TCRichedit = class(TRichEdit)
  private
    FOnURLClick: TURLClickEvent;
    procedure DoURLClick(const AURL: string);
  protected
    procedure CreateWnd; override;
    procedure CNNotify(var Message: TMessage); message CN_NOTIFY;
  published
    property OnURLClick: TURLClickEvent read FOnURLClick write FOnURLClick;
  end;

  TCSpeedButton = class(TSpeedButton)
  end;

function GetCurrencySymbol: string;
procedure SetCurrencySymbol(ACurrencyId: String; ACurrencySymbol: String; AComponentTag: Integer);
function FindNodeWithIndex(AIndex: Cardinal; AList: TVirtualStringTree): PVirtualNode;
procedure SetEvenListColors(AColorEven, AColorOdd: TColor);
function GetDarkerColor(ABaseColor: TColor): TColor;
function GetBrighterColor(ABaseColor: TColor): TColor;
function GetScaledPngImageList(APngImageList: TPngImageList; ANewWidth, ANewHeight: Integer): TPngImageList;
procedure SetSystemCustomColors(AColorDialog: TColorDialog);

var CurrencyComponents: TObjectList;
    ListComponents: TObjectList;

procedure Register;

implementation

uses Forms, CCalendarFormUnit, DateUtils, ComObj, CCalculatorFormUnit,
  Math, StrUtils;

var LOddColor: TColor;
    LEvenColor: TColor;

procedure Register;
begin
  RegisterComponents('CManager', [TCButton, TCImage, TCStatic, TCCurrEdit, TCDateTime, TCBrowser, TCIntEdit, TCList, TCDataList, TCStatusBar, TCRichedit, TCPanel, TCSpeedButton]);
end;

function GetBrighterColor(ABaseColor: TColor): TColor;
begin
  Result := RGB(Min(GetRValue(ColorToRGB(ABaseColor)) + 8, 255),
                Min(GetGValue(ColorToRGB(ABaseColor)) + 8, 255),
                Min(GetBValue(ColorToRGB(ABaseColor)) + 8, 255));
end;

function GetDarkerColor(ABaseColor: TColor): TColor;
begin
  Result := RGB(Max(GetRValue(ColorToRGB(ABaseColor)) - 8, 0),
                Max(GetGValue(ColorToRGB(ABaseColor)) - 8, 0),
                Max(GetBValue(ColorToRGB(ABaseColor)) - 8, 0));
end;

procedure TCButton.ActionChange(Sender: TObject; CheckDefaults: Boolean);
begin
  inherited ActionChange(Sender, CheckDefaults);
  Invalidate;
end;

procedure TCButton.CMMouseenter(var Message: TMessage);
begin
  if (not (csDesigning in ComponentState)) and Enabled then begin
    FMouseIn := True;
    Font.Style := Font.Style + [fsUnderline];
    Font.Color := clNavy;
    Invalidate;
  end;
end;

procedure TCButton.CMMouseleave(var Message: TMessage);
begin
  if (not (csDesigning in ComponentState)) and Enabled then begin
    FMouseIn := False;
    Font.Style := Font.Style - [fsUnderline];
    Font.Color := clWindowText;
    Invalidate;
  end;
end;

constructor TCButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Color := clBtnFace;
  FMouseIn := False;
  FPicPosition := ppTop;
  FPicOffset := 10;
  FTxtOffset := 15;
  FFramed := False;
  Cursor := crHandPoint;
  Color := clWindow;
end;

procedure TCButton.Paint;
var xTextHeight: Integer;
    xTextWidth: Integer;
    xImgX, xImgY: Integer;
    xTxtX, xTxtY: Integer;
    xImages: TCustomImageList;
begin
  if Action <> nil then begin
    xImages := TCustomAction(Action).ActionList.Images;
  end else begin
    xImages := nil;
  end;
  if FFramed then begin
    Canvas.Brush.Style := bsSolid;
    if (FMouseIn and Enabled) or (csDesigning in ComponentState) then begin
      Canvas.Brush.Color := clBtnFace;
      Canvas.Pen.Color := clAppWorkSpace;
      Canvas.RoundRect(0, 0, Width, Height, 10, 10);
    end;
  end;
  xImgX := 0;
  xImgY := 0;
  xTxtX := 0;
  xTxtY := 0;
  xTextHeight := Canvas.TextHeight(Caption);
  xTextWidth := Canvas.TextWidth(Caption);
  case FPicPosition of
    ppLeft: begin
        if xImages <> nil then begin
          xImgY := (Height - xImages.Height) div 2;
          xTxtX := xImgX + xImages.Width + FTxtOffset;
        end else begin
          xTxtX := FTxtOffset;
        end;
        xImgX := FPicOffset;
        xTxtY := (Height - xTextHeight) div 2;
      end;
    ppRight: begin
        if xImages <> nil then begin
          xImgY := (Height - xImages.Height) div 2;
          xTxtX := Width - (xImgX + xImages.Width + FTxtOffset) - Canvas.TextWidth(Caption);
        end else begin
          xTxtX := FTxtOffset;
        end;
        xImgX := Width - FPicOffset - xImages.Width;
        xTxtY := (Height - xTextHeight) div 2;
      end;
    ppTop: begin
        if xImages <> nil then begin
          xImgX := (Width - xImages.Width) div 2;
          xTxtY := xImgY + xImages.Height + FTxtOffset;
        end else begin
          xTxtY := FTxtOffset;
        end;
        xImgY := FPicOffset;
        xTxtX := (Width - xTextWidth) div 2;
      end;
  end;
  if (Action <> nil) then begin
    if (TCustomAction(Action).ImageIndex <> -1) and (xImages <> Nil) then begin
      Canvas.Draw(xImgX, xImgY, TPngImageList(xImages).PngImages.Items[TCustomAction(Action).ImageIndex].PngImage);
    end;
  end;
  Canvas.Brush.Style := bsClear;
  if (csDesigning in ComponentState) then begin
    Canvas.Brush.Color := Color;
  end else begin
    if FMouseIn and FFramed and Enabled then begin
      Canvas.Brush.Color := clBtnFace;
    end else begin
      Canvas.Brush.Color := Color;
    end;
  end;
  if Enabled then begin
    Canvas.Font.Color := Font.Color;
    Canvas.Font.Style := Font.Style;
  end else begin
    Canvas.Font.Color := clInactiveCaption;
    Canvas.Font.Style := [];
  end;
  Canvas.TextOut(xTxtX, xTxtY, Caption);
end;

procedure TCButton.SetEnabled(Value: Boolean);
begin
  inherited SetEnabled(Value);
  Invalidate;
end;

procedure TCButton.SetFramed(const Value: Boolean);
begin
  if FFramed <> Value then begin
    FFramed := Value;
    Invalidate;
  end;
end;

procedure TCButton.SetPicOffset(const Value: Integer);
begin
  if FPicOffset <> Value then begin
    FPicOffset := Value;
    Invalidate;
  end;
end;

procedure TCButton.SetPicturePosition(const Value: TPicturePosition);
begin
  if FPicPosition <> Value then begin
    FPicPosition := Value;
    Invalidate;
  end;
end;

procedure TCButton.SetTxtOffset(const Value: Integer);
begin
  if FTxtOffset <> Value then begin
    FTxtOffset := Value;
    Invalidate;
  end;
end;

constructor TCImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FImageList := nil;
  FImageIndex := -1;
end;

procedure TCImage.Paint;
var
  xImgX, xImgY: Integer;
begin
  if (FImageList <> nil) and (FImageIndex <> -1) then begin
    xImgX := (Width - FImageList.Width) div 2;
    xImgY := (Height - FImageList.Height) div 2;
    ImageList.Draw(Canvas, xImgX, xImgY, FImageIndex);
  end;
  if (csDesigning in ComponentState) then begin
    Canvas.Brush.Color := clBtnFace;
    Canvas.Pen.Color := clAppWorkSpace;
    Canvas.Rectangle(0, 0, Width, Height);
  end;
end;

procedure TCImage.SetImageIndex(const Value: Integer);
begin
  if FImageIndex <> Value then begin
    FImageIndex := Value;
    Invalidate;
  end;
end;

procedure TCImage.SeTPngImageList(const Value: TPngImageList);
begin
  if FImageList <> Value then begin
    FImageList := Value;
    FImageIndex := -1;
    Invalidate;
  end;
end;

function TCStatic.CanFocus: Boolean;
begin
  Result := (inherited CanFocus) and FHotTrack;
end;

procedure TCStatic.Click;
var xId, xText: String;
    xAccepted: Boolean;
begin
  inherited Click;
  if Enabled and FHotTrack then begin
    if Assigned(FOnGetDataId) then begin
      xId := DataId;
      xText := Caption;
      FOnGetDataId(xId, xText, xAccepted);
      if xAccepted then begin
        Caption := xText;
        DataId := xId;
        if Assigned(FOnChanged) then begin
          FOnChanged(Self);
        end;
      end;
    end;
  end;
end;

procedure TCStatic.CMMouseenter(var Message: TMessage);
begin
  if FHotTrack and Enabled and (not (csDesigning in ComponentState)) then begin
    Font.Style := Font.Style + [fsUnderline];
    FOldColor := Font.Color;
    Font.Color := clNavy;
    Cursor := crHandPoint;
  end;
end;

procedure TCStatic.CMMouseleave(var Message: TMessage);
begin
  if FHotTrack and Enabled and (not (csDesigning in ComponentState)) then begin
    Font.Style := Font.Style - [fsUnderline];
    Font.Color := FOldColor;
    Cursor := crDefault;
  end;
end;

procedure TCStatic.CMTextchanged(var Message: TMessage);
begin
  Hint := Caption;
end;

constructor TCStatic.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOnGetDataId := Nil;
  FOnClearDataId := Nil;
  FOnChanged := Nil;
  AutoSize := False;
  Height := 21;
  Width := 150;
  BorderStyle := sbsNone;
  BevelKind := bkTile;
  Cursor := crDefault;
  ParentColor := False;
  Color := clWindow;
  FTextOnEmpty := '<kliknij tutaj aby wybraæ>';
  Caption := FTextOnEmpty;
  FDataId := '';
  FHotTrack := True;
  FCanvas := TControlCanvas.Create;
  TabStop := True;
  Transparent := False;
  TControlCanvas(FCanvas).Control := Self;
end;

procedure TCStatic.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or SS_WORDELLIPSIS
end;

destructor TCStatic.Destroy;
begin
  FCanvas.Free;
  inherited Destroy;
end;

procedure TCStatic.DoClearDataId(var ACanAccept: Boolean);
begin
  ACanAccept := True;
  if Assigned(FOnClearDataId) then begin
    FOnClearDataId(FDataId, ACanAccept);
  end;
end;

procedure TCStatic.DoEnter;
begin
  inherited;
  FInternalIsFocused := True;
  Invalidate;
end;

procedure TCStatic.DoExit;
begin
  FInternalIsFocused := False;
  Invalidate;
  inherited;
end;

procedure TCStatic.DoGetDataId;
begin
  Click;
end;

procedure TCStatic.KeyDown(var Key: Word; Shift: TShiftState);
var xCanClear: Boolean;
begin
  inherited;
  if Key = VK_SPACE then begin
    Click;
  end else if Key = VK_DELETE then begin
    DoClearDataId(xCanClear);
    if xCanClear then begin
      DataId := '';
      if Assigned(FOnChanged) then begin
         FOnChanged(Self);
      end;
    end;
  end;
end;

procedure TCStatic.Loaded;
begin
  inherited Loaded;
  if FDataId = '' then begin
    Caption := FTextOnEmpty;
  end;
  ShowHint := True;
end;

procedure TCStatic.SetDataId(const Value: string);
begin
  if FDataId <> Value then begin
    FDataId := Value;
    if FDataId = '' then begin
      Caption := FTextOnEmpty;
    end;
  end else begin
    if Value = '' then begin
      Caption := FTextOnEmpty;
    end;
  end;
end;


procedure TCStatic.SetTextOnEmpty(const Value: string);
begin
  FTextOnEmpty := Value;
  if FDataId = '' then begin
    Caption := FTextOnEmpty;
  end;
end;

function GetCurrencySymbol: string;
var xRes: Cardinal;
    xPch: PChar;
begin
  xRes := GetLocaleInfo(GetUserDefaultLCID, LOCALE_SCURRENCY, nil, 0);
  GetMem(xPch, xRes);
  GetLocaleInfo(GetUserDefaultLCID, LOCALE_SCURRENCY, xPch, xRes);
  Result := StrPas(xPch);
  FreeMem(xPch);
end;

constructor TCCurrEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCurrencyStr := GetCurrencySymbol;
  FValue := 0;
  FDecimals := 2;
  FMaxDigits := 17 - FDecimals;
  FAlign := taRightJustify;
  FShowKSeps := True;
  FEditMode := False;
  FWithCalculator := True;
  FCurrencyId := '';
  SetTextFromValue;
  if not (csDesigning in ComponentState) then begin
    if CurrencyComponents <> Nil then begin
      CurrencyComponents.Add(Self);
    end;
  end;
end;

procedure TCCurrEdit.CreateParams(var Params: TCreateParams);
const
  Alignments: array[TAlignment] of Word = (ES_LEFT, ES_RIGHT, ES_CENTER);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or ES_NUMBER or ES_MULTILINE or Alignments[FAlign];
end;

procedure TCCurrEdit.Update;
begin
  inherited Update;
  SetTextFromValue;
end;

procedure TCCurrEdit.DoEnter;
begin
  FEditMode := True;
  SetTextFromValue;
  FOldText := Text;
  SelectAll;
  inherited DoEnter;
end;

procedure TCCurrEdit.DoExit;
begin
  FEditMode := False;
  SetTextFromValue;
  inherited DoExit;
end;

procedure TCCurrEdit.KeyDown(var Key: Word; Shift: TShiftState);
var txt: string;
    tlen, cPos: integer;
    InputParsed: Boolean;
    DoBeep: Boolean;
    xFromCalc: Double;
begin
  if ReadOnly then Exit;
  DoBeep := False;
  InputParsed := False;
  if Key = VK_DELETE then begin
    cPos := SelStart;
    txt := FormatIt(StrToFloat(Text), False);
    tlen := Length(txt);
    if ((cPos = tlen) or (cPos = tlen - FDecimals - 1)) then begin
      InputParsed := True;
      DoBeep := True;
    end;
    if ((not InputParsed) and (SelStart = 0) and (SelLength = tlen)) then begin
      txt := FormatIt(0, False);
      InputParsed := True;
    end;
    if ((not InputParsed) and (cPos >= tlen - FDecimals - 1) and (cPos < tlen)) then begin
      if SelLength = 0 then begin
        if cPos < tlen - 1 then txt := DeleteChars(txt, cPos, 1) + '0'
        else txt := ReplaceChars(txt, '0', cPos);
      end else begin
        txt := ReplaceChars2(txt, '0', cPos, SelLength);
      end;
      InputParsed := True;
    end;
    if ((not InputParsed) and (cPos <= tlen - FDecimals - 1)) then begin
      if SelLength = 0 then begin
        if LeftStr(txt, 1) <> '0' then begin
          if tlen = FDecimals + 2 then txt := ReplaceChars(txt, '0', cPos)
          else txt := DeleteChars(txt, cPos, 1);
        end else begin
          DoBeep := True;
        end;
      end else begin
        if cPos + SelLength <= tlen - FDecimals - 1 then begin
          txt := DeleteChars(txt, cPos, SelLength);
        end else begin
          DoBeep := True;
        end;
      end;
    end;
    if Text <> txt then begin
      cPos := SelStart;
      Text := FormatIt(StrToFloat(txt), False);
      SelStart := cPos;
      Modified := True;
    end;
    Key := 0;
  end else if ((Key = Ord('C')) or (Key = Ord('c'))) and FWithCalculator then begin
    ShowCalculator(Self, FDecimals, xFromCalc);
    Value := xFromCalc;
    Key := 0;
  end;
  if DoBeep then Beep;
  inherited KeyDown(Key, Shift);
end;

procedure TCCurrEdit.KeyPress(var Key: Char);
var
  txt: string;
  tlen, cPos: integer;
  DelPressed: boolean;
  ExitFlag: boolean;
  Negative: boolean;
  InputParsed: boolean;
begin
  if ReadOnly then exit;

  InputParsed := False; //Defaults
  ExitFlag := False;

  if LeftStr(Text, 1) = '-' then Negative := True //Negative-Flag
  else Negative := False;

  cPos := SelStart;
  txt := FormatIt(StrToFloat(Text), False);
  tlen := Length(txt);

  if not (Key in ['0'..'9', DecimalSeparator, '-', Char(#8)]) then {//Filter Keys} begin
    InputParsed := True; //Job done
  end;

  if ((not InputParsed) and (Key = Char(#8))) then begin
    DelPressed := True; //Del-Pressed-Flag
    InputParsed := True;
  end
  else begin
    DelPressed := False;
  end;

  if (((not InputParsed) or (DelPressed)) and (SelStart = 0) and (SelLength = tlen)) then {//Delete complete} begin
    txt := FormatIt(0, False);
    tlen := Length(txt);
    cPos := 0;
    SelLength := 0;
  end;

  if ((not InputParsed) and (Key = '-')) then {//Minus-Handling} begin
    if ((cPos = 0) and (not Negative)) then {//First Position and not Negative} begin
      if SelLength = 0 then begin
        txt := InsertChars(txt, '-', 0);
        cPos := cPos + 1; //New Cursor-Pos
        Negative := True;
      end
      else begin
        if cPos + SelLength <= tlen - FDecimals - 1 then begin
          txt := DeleteChars(txt, cPos, SelLength); //Replace Selection with '-'
          txt := InsertChars(txt, '-', 0);
          cPos := cPos + 1; //New Cursor-Pos
          Negative := True;
        end;
      end;
    end;
    InputParsed := True; //Job done
  end;

  if ((not InputParsed) and (Key = '0')) then {//leading zero not wanted} begin
    if ((cPos = 0) and (not Negative)) then {//positive case} begin
      InputParsed := True; //Job done
    end;

    if ((cPos < 2) and (Negative)) then {//negative case} begin
      InputParsed := True; //Job done
    end;

  end;

  if ((not InputParsed) and (FDecimals > 0) and (Key = DecimalSeparator)) then {//DecimalSeparator-Handling} begin
    if cPos < tlen - FDecimals then begin
      cPos := tlen - FDecimals; //Put Cursor to Decimals-Area
    end;
    InputParsed := True; //Job done
  end;

  if ((DelPressed) and (FDecimals > 0) and (cPos >= tlen - FDecimals - 1)) then {//Delete in Decimal Area} begin
    if SelLength = 0 then begin
      if cPos > tlen - FDecimals then begin
        txt := ReplaceChars(txt, '0', cPos - 1); //Replace '0' instead of Deleting
        cPos := cPos - 1; //New Cursor-Pos
      end;
    end
    else begin
      txt := ReplaceChars2(txt, '0', cPos, SelLength);
    end;
  end;

  if ((not InputParsed) and (FDecimals > 0) and (cPos >= tlen)) then {//Add no more Decimals at last Pos} begin
    InputParsed := True; //Job done
  end;

  if ((not InputParsed) and (FDecimals > 0) and (cPos >= tlen - FDecimals)) then begin
    if SelLength = 0 then begin
      txt := ReplaceChars(txt, Key, cPos); //Dont Insert, instead Overwrite Decimals in Decimal Area
      cPos := cPos + 1; //New Cursor-Pos
    end
    else begin
      if cpos >= tlen - FDecimals then begin
        txt := ReplaceChars2(txt, '0', cPos, SelLength);
        txt := ReplaceChars(txt, Key, cPos); //Dont Insert, instead Overwrite Decimals in Decimal Area
        cPos := cPos + 1; //New Cursor-Pos
      end;
    end;
    InputParsed := True; //Job done
  end;

  if ((DelPressed) and (cPos <= tlen - FDecimals - 1)) then {//General Delete-Handling} begin
    if SelLength = 0 then begin
      if cPos > 0 then begin
        if tlen = FDecimals + 2 then txt := ReplaceChars(txt, '0', cPos - 1) //Special-Handling for x.xx
        else txt := DeleteChars(txt, cPos - 1, 1);
        cPos := cPos - 1; //New Cursor-Pos
      end;
    end
    else begin
      if cPos + SelLength <= tlen - FDecimals - 1 then begin
        txt := DeleteChars(txt, cPos, SelLength);
        SelStart := cPos - 1;
      end;
    end;
  end;

  if ((not InputParsed) and (cPos <= tlen - FDecimals - 1)) then {//Input, Insert-Handling} begin
    if SelLength = 0 then begin
      if tlen < FMaxDigits then begin
        if (((LeftStr(txt, 1) = '0') and (cPos = 0) and (not Negative)) or ((LeftStr(txt, 2) = '-0') and (cPos = 1) and (Negative))) then begin
          txt := ReplaceChars(txt, Key, cPos); //Special Handling for -0.xx/0.xx
          cPos := cPos + 1; //New Cursor-Pos
        end
        else begin
          if ((Negative) and (cPos = 0)) then begin
          end
          else begin
            txt := InsertChars(txt, Key, cPos);
            cPos := cPos + 1; //New Cursor-Pos
          end;
        end;
      end;
    end
    else begin
      if cPos + SelLength <= tlen - FDecimals - 1 then begin
        txt := DeleteChars(txt, cPos, SelLength);
        txt := InsertChars(txt, Key, cPos);
      end;
    end;
    InputParsed := True; //Job done
  end;

  if ((not ExitFlag) and (InputParsed)) then begin
    if Text <> txt then begin
      Text := FormatIt(StrToFloat(txt), False); //Reformat
      if ((Negative) and (LeftStr(Text, 1) <> '-')) then Text := InsertChars(Text, '-', 0);
      Modified := True;
    end;
    SelStart := cPos;
    key := #0;
  end;

  inherited KeyPress(Key);

end;

function TCCurrEdit.GetDecimals: smallint;
begin
  result := FDecimals;
end;

procedure TCCurrEdit.SetDecimals(Value: smallint);
begin
  if ((Value >= 0) and (Value <= 6)) then begin
    FDecimals := Value;
  end
  else begin
    FDecimals := 2;
    raise TCEditError.Create('"' + IntToStr(Value) + '" is not valid for Decimals (0 to 6)');
  end;
  Update;
end;

function TCCurrEdit.GetValue: Double;
begin
  result := FValue;
end;

procedure TCCurrEdit.SetValue(Value: Double);
var xTest: string;
begin
  try
    xTest := FormatFloat('0.00', Value);
    FValue := Value;
  except
    FValue := 0;
    raise TCEditError.Create('"' + FloatToStr(Value) + '" is not valid for Value');
  end;
  Update;
end;

procedure TCCurrEdit.SetTextFromValue;
begin
  if FEditMode then begin
    Text := FormatIt(FValue, False);
  end else begin
    Text := FormatIt(FValue, True) + ' ' + FCurrencyStr;
  end;
end;

function TCCurrEdit.AsCurrency: Currency;
begin
  result := FValue;
end;

function TCCurrEdit.AsFloat: double;
begin
  result := FValue;
end;

function TCCurrEdit.AsString: string;
begin
  result := CurrToStr(FValue);
end;

function TCCurrEdit.FormatIt(AValue: Double; ShowMode: boolean): string;
var
  decimals, mask: string;
  x: smallint;
begin
  decimals := '';
  if ShowMode and FShowKSeps then mask := ',0.'
  else mask := '0.';
  for x := 0 to FDecimals - 1 do
    decimals := decimals + '0';
  mask := mask + decimals;
  try
    result := FormatFloat(mask, AValue);
    if not ShowMode then FValue := StrToFloat(result);
  except
    result := '0' + DecimalSeparator + decimals;
    if not ShowMode then begin
      FValue := 0;
      SetTextFromValue;
    end;
    raise TCEditError.Create('"' + FloatToStr(AValue) + '" is not a valid value');
  end;
end;

function TCCurrEdit.LeftStr(OrgStr: string; CharCount: smallint): string;
begin
  try
    result := Copy(OrgStr, 0, CharCount);
  except
    result := '';
  end;
end;

function TCCurrEdit.RightStr(OrgStr: string; CharCount: smallint): string;
begin
  result := Copy(OrgStr, (Length(OrgStr) - CharCount) + 1, Length(OrgStr));
end;

function TCCurrEdit.DeleteChars(OrgStr: string; CharPos, CharCount: smallint): string;
begin
  result := LeftStr(OrgStr, CharPos) + RightStr(OrgStr, Length(OrgStr) - CharPos - CharCount);
end;

function TCCurrEdit.InsertChars(OrgStr, InsChars: string; CharPos: smallint): string;
begin
  result := LeftStr(OrgStr, CharPos) + InsChars + RightStr(OrgStr, Length(OrgStr) - CharPos);
end;

function TCCurrEdit.ReplaceChars(OrgStr, ReplChars: string; CharPos: smallint): string;
begin
  result := LeftStr(OrgStr, CharPos) + ReplChars + RightStr(OrgStr, Length(OrgStr) - CharPos - Length(ReplChars));
end;

function TCCurrEdit.ReplaceChars2(OrgStr: string; ReplChar: Char; CharPos, CharCount: smallint): string;
var
  x: smallint;
begin
  result := OrgStr;
  for x := 0 to CharCount - 1 do begin
    result := ReplaceChars(result, ReplChar, CharPos + x);
  end;
end;

function TCDateTime.CanFocus: Boolean;
begin
  Result := (inherited CanFocus) and FHotTrack;
end;

procedure TCDateTime.Click;
var xDate: TDateTime;
begin
  inherited Click;
  if HotTrack then begin
    xDate := FValue;
    if FValue = 0 then begin
      xDate := Now;
    end;
    if ShowCalendar(Self, xDate, FWithtime) then begin
      Value := xDate;
      if Assigned(FOnChanged) then begin
        FOnChanged(Self);
      end;
    end;
  end;
end;

procedure TCDateTime.CMMouseenter(var Message: TMessage);
begin
  if FHotTrack and Enabled and (not (csDesigning in ComponentState)) then begin
    Font.Style := Font.Style + [fsUnderline];
    FOldColor := Font.Color;
    Font.Color := clNavy;
    Cursor := crHandPoint;
  end;
end;

procedure TCDateTime.CMMouseleave(var Message: TMessage);
begin
  if FHotTrack and Enabled and (not (csDesigning in ComponentState)) then begin
    Font.Style := Font.Style - [fsUnderline];
    Font.Color := FOldColor;
    Cursor := crDefault;
  end;
end;

constructor TCDateTime.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AutoSize := False;
  Height := 21;
  Width := 150;
  BorderStyle := sbsNone;
  BevelKind := bkTile;
  Cursor := crDefault;
  ParentColor := False;
  Color := clWindow;
  FValue := 0;
  FWithtime := False;
  FOnChanged := Nil;
  UpdateCaption;
  FHotTrack := True;
  FCanvas := TControlCanvas.Create;
  TabStop := True;
  Transparent := False;
  TControlCanvas(FCanvas).Control := Self;
end;

destructor TCDateTime.Destroy;
begin
  FCanvas.Free;
  inherited;
end;

procedure TCDateTime.DoEnter;
begin
  inherited;
  FInternalIsFocused := True;
  Invalidate;
end;

procedure TCDateTime.DoExit;
begin
  FInternalIsFocused := False;
  Invalidate;
  inherited;
end;

procedure TCDateTime.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = VK_SPACE then begin
    Click;
  end;
end;

procedure TCDateTime.SetValue(const Value: TDateTime);
begin
  if FValue <> Value then begin
    if FWithtime then begin
      FValue := Value;
    end else begin
      FValue := DateOf(Value);
    end;
    UpdateCaption;
  end;
end;

procedure TCDateTime.SetWithtime(const Value: Boolean);
begin
  FWithtime := Value;
  UpdateCaption;
end;

procedure TCDateTime.UpdateCaption;
begin
  if FValue <> 0 then begin
    Caption := FormatDateTime('yyyy-mm-dd' + IfThen(FWithtime, ' hh:nn', ''), FValue);
  end else begin
    Caption := '<wybierz datê ' + IfThen(FWithtime, ' i czas', '') + '>';
  end;
end;

procedure TCBrowser.CancelRequest;
begin
  if Busy then begin
    Stop;
  end;
end;

constructor TCBrowser.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Silent := True;
end;

function TCBrowser.EnableModeless(const fEnable: LongBool): HRESULT;
begin
  Result := S_OK;
end;

function TCBrowser.FilterDataObject(const pDO: IDataObject; out ppDORet: IDataObject): HResult;
begin
  ppDORet := nil;
  Result := S_FALSE;
end;

function TCBrowser.GetDropTarget(const pDropTarget: IDropTarget; out ppDropTarget: IDropTarget): HResult;
begin
  ppDropTarget := nil;
  Result := E_FAIL;
end;

function TCBrowser.GetExternal(out ppDispatch: IDispatch): HResult;
begin
  ppDispatch := nil;
  Result := E_FAIL;
end;

function TCBrowser.GetHostInfo(var pInfo: TDocHostUIInfo): HRESULT;
begin
  try
    ZeroMemory(@pInfo, SizeOf(TDocHostUIInfo));
    pInfo.cbSize := SizeOf(TDocHostUIInfo);
    pInfo.dwFlags := pInfo.dwFlags or DOCHOSTUIFLAG_NO3DBORDER;
    Result := S_OK;
  except
    Result := E_FAIL;
  end;
end;

function TCBrowser.GetOptionKeyPath(var pchKey: POLESTR; const dw: DWORD): HResult;
begin
  Result := E_FAIL;
end;

function TCBrowser.HideUI: HRESULT;
begin
  Result := S_OK;
end;

function TCBrowser.LoadFromString(AInString: String): Boolean;
var xPersistStreamInit: IPersistStreamInit;
    xStreamAdapter: IStream;
    xStream: TStringStream;
begin
  Result := False;
  if Document = Nil then begin
    Navigate('about:blank');
  end;
  if Document.QueryInterface(IPersistStreamInit, xPersistStreamInit) = S_OK then begin
    if xPersistStreamInit.InitNew = S_OK then begin
      xStream := TStringStream.Create(AInString);
      xStreamAdapter:= TStreamAdapter.Create(xStream, soOwned);
      Result := xPersistStreamInit.Load(xStreamAdapter) = S_OK;
    end;
  end;
end;

function TCBrowser.OnDocWindowActivate(const fActivate: BOOL): HResult;
begin
  Result := S_OK;
end;

function TCBrowser.OnFrameWindowActivate(const fActivate: BOOL): HResult;
begin
  Result := S_OK;
end;

function TCBrowser.ResizeBorder(const prcBorder: PRECT; const pUIWindow: IOleInPlaceUIWindow; const fFrameWindow: BOOL): HResult;
begin
  Result := S_FALSE;
end;

procedure TCBrowser.SetAutoVSize(const Value: Boolean);
begin
  FAutoVSize := Value;
end;

function TCBrowser.ShowContextMenu(const dwID: Cardinal; const ppt: PPoint; const pcmdtReserved: IInterface; const pdispReserved: IDispatch): HRESULT;
begin
  Result := S_OK
end;

function TCBrowser.ShowUI(const dwID: Cardinal; const pActiveObject: IOleInPlaceActiveObject; const pCommandTarget: IOleCommandTarget; const pFrame: IOleInPlaceFrame; const pDoc: IOleInPlaceUIWindow): HRESULT;
begin
  Result := S_OK;
end;

function TCBrowser.TranslateAccelerator(const lpMsg: PMSG; const pguidCmdGroup: PGUID; const nCmdID: DWORD): HResult;
begin
  Result := S_FALSE;
end;

function TCBrowser.TranslateUrl(const dwTranslate: DWORD; const pchURLIn: POLESTR; var ppchURLOut: POLESTR): HResult;
begin
  Result := E_FAIL;
end;

function TCBrowser.UpdateUI: HRESULT;
begin
  Result := S_OK;
end;

procedure TCBrowser.WaitFor;
begin
  while ReadyState <> READYSTATE_COMPLETE do begin
    Forms.Application.ProcessMessages;
  end;
end;

procedure TCIntEdit.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or ES_NUMBER or ES_MULTILINE or ES_RIGHT;
end;

procedure TCIntEdit.DoEnter;
begin
  SelStart := 0;
  SelLength := Length(Text);
  inherited;
end;

procedure TCIntEdit.DoExit;
begin
  if StrToIntDef(Text, -1) = -1 then begin
    Text := '0';
  end;
  inherited;
end;

function TCIntEdit.GetValue: Integer;
begin
  Result := StrToIntDef(Text, -1);
end;

procedure TCStatic.WndProc(var Message: TMessage);
var xRect: TRect;
begin
  inherited;
  if Message.Msg = WM_PAINT then begin
    if FInternalIsFocused and CanFocus then begin
      xRect := ClientRect;
      //InflateRect(xRect, -1, -1);
      DrawFocusRect(Canvas.Handle, xRect);
    end;
  end else if Message.Msg = WM_SETFOCUS then begin
    Invalidate;
  end;
end;

procedure TCDateTime.WndProc(var Message: TMessage);
var xRect: TRect;
begin
  inherited;
  if Message.Msg = WM_PAINT then begin
    if FInternalIsFocused and CanFocus then begin
      xRect := ClientRect;
      DrawFocusRect(FCanvas.Handle, xRect);
    end;
  end else if Message.Msg = WM_SETFOCUS then begin
    Invalidate;
  end;
end;

procedure TCCurrEdit.SetCurrencyStr(const Value: String);
begin
  FCurrencyStr := Value;
  SetTextFromValue;
end;

constructor TCList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAutoExpand := True;
  DefaultText := '';
  FViewPref := Nil;
  FOnGetRowPreferencesName := Nil;
  if not (csDesigning in ComponentState) then begin
    if ListComponents <> Nil then begin
      ListComponents.Add(Self);
    end;
  end;
end;

destructor TCList.Destroy;
begin
  if not (csDesigning in ComponentState) then begin
    if ListComponents <> Nil then begin
      ListComponents.Remove(Self);
    end;
  end;
  inherited Destroy;
end;

procedure TCList.DoBeforeItemErase(Canvas: TCanvas; Node: PVirtualNode; ItemRect: TRect; var Color: TColor; var EraseAction: TItemEraseAction);
var xIndex: Cardinal;
    xPrefname: String;
    xPref: TFontPref;
begin
  with Canvas do begin
    xIndex := GetVisibleIndex(Node);
    if Odd(xIndex) then begin
      Color := LOddColor;
    end else begin
      Color := LEvenColor;
    end;
    EraseAction := eaColor;
  end;
  if (FViewPref <> Nil) then begin
    xPrefname := '*';
    if NodeDataSize > 0 then begin
      DoOnGetRowPreferencesName(TObject(GetNodeData(Node)^), xPrefname);
    end else begin
      DoOnGetRowPreferencesName(Nil, xPrefname);
    end;
    if (xPrefname <> '') then begin
      xPref := TFontPref(FViewPref.Fontprefs.ByPrefname[xPrefname]);
      if xPref <> Nil then begin
        if Odd(xIndex) then begin
          Color := xPref.Background;
        end else begin
          Color := xPref.BackgroundEven;
        end;
      end;
    end;
  end;
  inherited DoBeforeItemErase(Canvas, Node, ItemRect, Color, EraseAction);
end;

procedure TCList.DoHeaderClick(Column: TColumnIndex; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then begin
    if Header.SortColumn <> Column then begin
      Header.SortColumn := Column;
      Header.SortDirection := sdAscending;
    end else begin
      case Header.SortDirection of
        sdAscending: Header.SortDirection := sdDescending;
        sdDescending: Header.SortDirection := sdAscending;
      end;
    end;
  end;
  inherited DoHeaderClick(Column, Button, Shift, X, Y);
end;

procedure TCList.DoMeasureItem(TargetCanvas: TCanvas; Node: PVirtualNode; var NodeHeight: Integer);
var xPrefname: String;
    xPref: TFontPref;
begin
  if (FViewPref <> Nil) then begin
    xPrefname := '*';
    if NodeDataSize > 0 then begin
      DoOnGetRowPreferencesName(TObject(GetNodeData(Node)^), xPrefname);
    end else begin
      DoOnGetRowPreferencesName(Nil, xPrefname);
    end;
    if (xPrefname <> '') then begin
      xPref := TFontPref(FViewPref.Fontprefs.ByPrefname[xPrefname]);
      if xPref <> Nil then begin
        NodeHeight := xPref.RowHeight;
      end;
    end;
  end;
  inherited DoMeasureItem(TargetCanvas, Node, NodeHeight);
end;

procedure TCList.DoOnGetRowPreferencesName(AHelper: TObject; var APrefname: String);
begin
  if Assigned(FOnGetRowPreferencesName) then begin
    FOnGetRowPreferencesName(AHelper, APrefname);
  end;
end;

procedure TCList.DoPaintText(Node: PVirtualNode; const Canvas: TCanvas; Column: TColumnIndex; TextType: TVSTTextType);
var xPrefname: String;
    xPref: TFontPref;
begin
  if (FViewPref <> Nil) then begin
    xPrefname := '*';
    if NodeDataSize > 0 then begin
      DoOnGetRowPreferencesName(TObject(GetNodeData(Node)^), xPrefname);
    end else begin
      DoOnGetRowPreferencesName(Nil, xPrefname);
    end;
    if (xPrefname <> '') then begin
      xPref := TFontPref(FViewPref.Fontprefs.ByPrefname[xPrefname]);
      if xPref <> Nil then begin
        Canvas.Font.Assign(xPref.Font);
      end;
      if Focused then begin
        if (Node = HotNode) and (toHotTrack in TreeOptions.PaintOptions) then begin
          Canvas.Font.Style := Canvas.Font.Style + [fsUnderline];
          if FocusedNode = Node then begin
            Canvas.Font.Color := ViewPref.FocusedFontColor;
          end;
        end else if Node = FocusedNode then begin
          Canvas.Font.Color := ViewPref.FocusedFontColor;
        end;
      end else if (Node = HotNode) and (toHotTrack in TreeOptions.PaintOptions) then begin
        if Selected[Node] then begin
          Canvas.Font.Color := ViewPref.FocusedFontColor;
        end else begin
          Canvas.Font.Color := Colors.HotColor;
        end;
        Canvas.Font.Style := Canvas.Font.Style + [fsUnderline];
      end else if (toHotTrack in TreeOptions.PaintOptions) then begin
        if Selected[Node] then begin
          Canvas.Font.Color := ViewPref.FocusedFontColor;
        end;
      end;
    end;
  end;
  inherited DoPaintText(Node, Canvas, Column, TextType);
end;

procedure TCList.DoViewPrefChanged;
begin
  if FViewPref <> Nil then begin
    Colors.FocusedSelectionColor := FViewPref.FocusedBackgroundColor;
    Colors.FocusedSelectionBorderColor := FViewPref.FocusedBackgroundColor;
    Colors.UnfocusedSelectionColor := FViewPref.FocusedBackgroundColor;
    Colors.UnfocusedSelectionBorderColor := FViewPref.FocusedBackgroundColor;
  end else begin
    Colors.FocusedSelectionColor := clHighlight;
    Colors.FocusedSelectionBorderColor := clHighlight;
    Colors.UnfocusedSelectionColor := clHighlight;
    Colors.UnfocusedSelectionBorderColor := clHighlight;
  end;
end;

function TCList.GetVisibleIndex(ANode: PVirtualNode): Integer;
begin
  Result := -1;
  while Assigned(ANode) do begin
    Inc(Result);
    ANode := GetPreviousVisible(ANode);
  end;
end;

procedure TCList.Repaint;
begin
  DoViewPrefChanged;
  inherited Repaint;
end;

procedure TCList.SetViewPref(const Value: TViewPref);
begin
  FViewPref := Value;
  DoViewPrefChanged;
end;

function TCList.SumColumn(AColumnIndex: TColumnIndex; var ASum: Extended): Boolean;
var xNode: PVirtualNode;
    xStr: String;
    xCode: Integer;
    xValue: Extended;
begin
  Result := True;
  ASum := 0;
  xNode := GetFirst;
  while (xNode <> Nil) and Result do begin
    xStr := Text[xNode, AColumnIndex];
    Val(StringReplace(xStr, ',', '.', [rfReplaceAll, rfIgnoreCase]), xValue, xCode);
    Result := Result and (xCode = 0);
    if Result then begin
      ASum := ASum + xValue;
    end;
    xNode := GetNext(xNode);
  end;
  if not Result then begin
    ASum := 0;
  end;
end;

function TCListDataElement.AppendDataElement(ANodeData: TCListDataElement): PVirtualNode;
begin
  FParentList.BeginUpdate;
  Result := FParentList.AddChild(Node, ANodeData);
  Add(ANodeData);
  TCListDataElement(FParentList.GetNodeData(Result)^).Node := Result;
  FParentList.FocusedNode := Result;
  FParentList.Selected[Result] := True;
  FParentList.Sort(Result, FParentList.Header.SortColumn, FParentList.Header.SortDirection);
  FParentList.EndUpdate;
end;

constructor TCListDataElement.Create(ACheckSupport: Boolean; AParentList: TCDataList; AData: TCDataListElementObject; AFreeDataOnClear: Boolean = False; ACheckState: Boolean = True);
begin
  inherited Create(True);
  FParentList := AParentList;
  FFreeDataOnClear := AFreeDataOnClear;
  FData := AData;
  FCheckState := ACheckState;
  FCheckSupport := ACheckSupport;
end;

procedure TCListDataElement.DeleteDataElement(AId, AElementType: String);
var xElement: TCListDataElement;
begin
  xElement := FindDataElement(AId, AElementType);
  if xElement <> Nil then begin
    FParentList.BeginUpdate;
    FParentList.DeleteNode(xElement.Node);
    Remove(xElement);
    FParentList.EndUpdate;
  end;
end;

destructor TCListDataElement.Destroy;
begin
  if FFreeDataOnClear and Assigned(FData) then begin
    FreeAndNil(FData);
  end;
  inherited Destroy;
end;

function TCListDataElement.FindDataElement(AId: String; AElementType: String = ''; ARecursive: Boolean = True): TCListDataElement;
var xCount: Integer;
    xElement: TCListDataElement;
begin
  xCount := 0;
  Result := Nil;
  while (xCount <= Count - 1) and (Result = Nil) do begin
    xElement := Items[xCount];
    if (xElement.Data.GetElementType = AElementType) and (xElement.Data.GetElementId = AId) then begin
      Result := xElement;
    end;
    Inc(xCount);
  end;
  if (Result = Nil) and ARecursive then begin
    xCount := 0;
    while (xCount <= Count - 1) and (Result = Nil) do begin
      Result := Items[xCount].FindDataElement(AId, AElementType, ARecursive);
      Inc(xCount);
    end;
  end;
end;

function TCListDataElement.GetItems(AIndex: Integer): TCListDataElement;
begin
  Result := TCListDataElement(inherited Items[AIndex]);
end;

procedure TCListDataElement.RefreshDataElement(AId, AElementType: String);
var xElement: TCListDataElement;
begin
  xElement := FindDataElement(AId, AElementType);
  if xElement <> Nil then begin
    FParentList.BeginUpdate;
    xElement.Data.GetElementReload;
    FParentList.InvalidateNode(xElement.Node);
    FParentList.Sort(xElement.Node, FParentList.Header.SortColumn, FParentList.Header.SortDirection);
    FParentList.EndUpdate;
  end;
end;

procedure TCListDataElement.SetItems(AIndex: Integer; const Value: TCListDataElement);
begin
  inherited Items[AIndex] := Value;
end;

constructor TCDataList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FRootElement := TCListDataElement.Create(False, Self, Nil);
  FCOnReloadTree := Nil;
  FViewTextSelector := '';
end;

destructor TCDataList.Destroy;
begin
  FRootElement.Free;
  inherited Destroy;
end;

procedure TCDataList.DoInitNode(Parent, Node: PVirtualNode; var InitStates: TVirtualNodeInitStates);
var xData: TCListDataElement;
    xParent: TCListDataElement;
begin
  inherited DoInitNode(Parent, Node, InitStates);
  if Parent = Nil then begin
    xData := FRootElement.Items[Node.Index];
  end else begin
    xParent := TCListDataElement(GetNodeData(Parent)^);
    xData := xParent.Items[Node.Index];
  end;
  TCListDataElement(GetNodeData(Node)^) := xData;
  xData.Node := Node;
  if xData.Count > 0 then begin
    InitStates := InitStates + [ivsHasChildren];
    if AutoExpand then begin
      InitStates := InitStates + [ivsExpanded];
    end;
  end;
  if xData.CheckState then begin
    Node.CheckState := csCheckedNormal;
  end else begin
    Node.CheckState := csUncheckedNormal;
  end;
  if xData.CheckSupport then begin
    Node.CheckType := ctCheckBox;
  end else begin
    Node.CheckType := ctNone;
  end;
end;

function TCDataList.GetTreeElement(ANode: PVirtualNode): TCListDataElement;
begin
  Result := TCListDataElement(GetNodeData(ANode)^);
end;

function TCDataList.GetSelectedId: String;
begin
  Result := '';
  if FocusedNode <> Nil then begin
    Result := GetTreeElement(FocusedNode).Data.GetElementId;
  end;
end;

function TCDataList.GetSelectedText: String;
begin
  Result := '';
  if FocusedNode <> Nil then begin
    Result := GetTreeElement(FocusedNode).Data.GetElementText;
  end;
end;

procedure TCDataList.ReloadTree;
begin
  BeginUpdate;
  Clear;
  FRootElement.Clear;
  if Assigned(FCOnReloadTree) then begin
    FCOnReloadTree(Self, FRootElement);
  end;
  RootNodeCount := FRootElement.Count;
  EndUpdate;
  UpdateScrollBars(False);
end;

procedure TCDataList.ValidateNodeDataSize(var Size: Integer);
begin
  Size := SizeOf(TCListDataElement);
end;

procedure TCDataList.DoGetText(Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType; var Text: WideString);
begin
  inherited DoGetText(Node, Column, TextType, Text);
  if Text = '' then begin
    if (Column >= 0) and (Column <= Header.Columns.Count - 1) then begin
      if Header.Columns.Items[Column].Text = 'Lp' then begin
        Text := IntToStr(Node.Index + 1);
      end else begin
        Text := GetTreeElement(Node).Data.GetColumnText(Column, TextType = ttStatic, FViewTextSelector);
      end;
    end;
  end;
end;

function TCDataList.DoGetImageIndex(Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex; var Ghosted: Boolean; var Index: Integer): TCustomImageList;
begin
  inherited DoGetImageIndex(Node, Kind, Column, Ghosted, Index);
  if Index = -1 then begin
    Index := GetTreeElement(Node).Data.GetColumnImage(Column);
  end;
  Result := Nil;
end;

function TCDataList.GetSelectedElement: TCListDataElement;
begin
  Result := Nil;
  if FocusedNode <> Nil then begin
    Result := GetTreeElement(FocusedNode);
  end;
end;

procedure TCDataList.DoInitChildren(Node: PVirtualNode; var ChildCount: Cardinal);
begin
  inherited DoInitChildren(Node, ChildCount);
  if ChildCount = 0 then begin
    ChildCount := GetTreeElement(Node).Count;
  end;
end;

function TCDataList.DoGetNodeHint(Node: PVirtualNode; Column: TColumnIndex; var LineBreakStyle: TVTTooltipLineBreakStyle): WideString;
begin
  Result := inherited DoGetNodeHint(Node, Column, LineBreakStyle);
  if Result = '' then begin
    Result := GetTreeElement(Node).Data.GetElementHint(Column);
    LineBreakStyle := hlbDefault;
  end;
end;

function TCDataListElementObject.GetColumnImage(AColumnIndex: Integer): Integer;
begin
  Result := -1;
end;

function TCDataListElementObject.GetElementCompare(AColumnIndex: Integer; ACompareWith: TCDataListElementObject; AViewTextSelector: String): Integer;
begin
  Result := AnsiCompareStr(GetColumnText(AColumnIndex, False, AViewTextSelector), ACompareWith.GetColumnText(AColumnIndex, False, AViewTextSelector));
end;

function TCDataListElementObject.GetElementHint(AColumnIndex: Integer): String;
begin
  Result := GetElementText;
end;

function TCDataListElementObject.GetElementId: String;
begin
  Result := '';
end;

procedure TCDataListElementObject.GetElementReload;
begin
end;

function TCDataListElementObject.GetElementText: String;
begin
  Result := GetElementId;
end;

function TCDataListElementObject.GetElementType: String;
begin
  Result := ClassName;
end;

procedure TCStatusBar.CMMouseenter(var Message: TMessage);
begin
  UpdateCursor;
end;

procedure TCStatusBar.CMMouseleave(var Message: TMessage);
begin
  if (not (csDesigning in ComponentState)) and Enabled then begin
    Cursor := crDefault;
  end;
end;

constructor TCStatusBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := ControlStyle + [csAcceptsControls];
  FImageList := Nil;
end;

procedure TCStatusBar.DrawPanel(Panel: TStatusPanel; const Rect: TRect);
var xImageIndex: Integer;
    xMargin: Integer;
begin
  inherited DrawPanel(Panel, Rect);
  if Panel.Style = psOwnerDraw then begin
    xMargin := 0;
    if (FImageList <> Nil) then begin
      xImageIndex := TCStatusPanel(Panel).ImageIndex;
      if xImageIndex <> -1 then begin
        ImageList.Draw(Canvas, Rect.Left + 2, Rect.Top, xImageIndex);
        xMargin := ImageList.Width + 4;
      end;
    end;
    Canvas.TextOut(Rect.Left + xMargin, 4, Panel.Text);
  end;
end;

function TCStatusBar.GetPanelClass: TStatusPanelClass;
begin
  Result := TCStatusPanel;
end;

function TCStatusBar.GeTCPanelWithMouse: TCStatusPanel;
var xP: TPoint;
    xCount: Integer;
    xRect: TRect;
begin
  Result := Nil;
  xP := Self.ScreenToClient(Mouse.CursorPos);
  xCount := 0;
  while (xCount <= Panels.Count - 1) and (Result = Nil) do begin
    if SendMessage(Handle, SB_GETRECT, xCount, Integer(@xRect)) = 1 then begin
      if (xP.X >= xRect.Left) and (xP.X <= xRect.Right) then begin
        Result := TCStatusPanel(Panels.Items[xCount]);
      end;
    end;
    Inc(xCount);
  end;
end;

procedure TCStatusBar.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  UpdateCursor;
end;

procedure TCStatusBar.SetPngImageList(const Value: TPngImageList);
begin
  if FImageList <> Value then begin
    FImageList := Value;
    Invalidate;
  end;
end;

constructor TCStatusPanel.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FImageIndex := -1;
  FClickable := False;
end;

procedure TCStatusPanel.SetImageIndex(const Value: Integer);
begin
  if FImageIndex <> Value then begin
    FImageIndex := Value;
    TStatusBar(TStatusPanels(Collection).Owner).Invalidate;
  end;
end;

procedure TCStatusBar.UpdateCursor;
var xPanel: TCStatusPanel;
begin
  if (not (csDesigning in ComponentState)) and Enabled then begin
    xPanel := GeTCPanelWithMouse;
    if (xPanel <> Nil) then begin
      if xPanel.Clickable then begin
        Cursor := crHandPoint;
      end else begin
        Cursor := crDefault;
      end;
    end;
  end;
end;

destructor TCCurrEdit.Destroy;
begin
  if not (csDesigning in ComponentState) then begin
    if CurrencyComponents <> Nil then begin
      CurrencyComponents.Remove(Self);
    end;
  end;
  inherited Destroy;
end;

procedure SetCurrencySymbol(ACurrencyId: String; ACurrencySymbol: String; AComponentTag: Integer);
var xCount: Integer;
    xCur: TCCurrEdit;
begin
  for xCount := 0 to CurrencyComponents.Count - 1 do begin
    xCur := TCCurrEdit(CurrencyComponents.Items[xCount]);
    if (xCur.CurrencyId = ACurrencyId) and (xCur.Tag = AComponentTag) then begin
      xCur.CurrencyStr := ACurrencySymbol;
    end;
  end;
end;

procedure TCCurrEdit.SetCurrencyDef(AId, ASymbol: String);
begin
  FCurrencyId := AId;
  CurrencyStr := ASymbol;
end;

function FindNodeWithIndex(AIndex: Cardinal; AList: TVirtualStringTree): PVirtualNode;
var xCur: PVirtualNode;
begin
  Result := Nil;
  xCur := AList.GetFirst;
  while (xCur <> Nil) and (Result = Nil) do begin
    if AList.AbsoluteIndex(xCur) = AIndex then begin
      Result := xCur;
    end;
    xCur := AList.GetNext(xCur);
  end;
end;

procedure TCRichedit.CNNotify(var Message: TMessage);
var xP: TENLink;
    xURL: string;
    xMsg: TWMNotify;
begin
  xMsg := TWMNotify(Message);
  if (xMsg.NMHdr^.code = EN_LINK) then begin
    xP := TENLink(Pointer(xMsg.NMHdr)^);
    if (xP.Msg = WM_LBUTTONDOWN) then begin
      try
        SendMessage(Handle, EM_EXSETSEL, 0, Longint(@(xP.chrg)));
        xURL := SelText;
        DoURLClick(xURL);
      except
      end;
    end;
  end;
  inherited;
end;

procedure TCRichedit.DoURLClick(const AURL: string);
begin
  if Assigned(FOnURLClick) then begin
    OnURLClick(Self, AURL);
  end else begin
    ShellExecute(0, nil, PChar(AURL), nil, nil, SW_SHOWNORMAL);
  end;
end;

procedure TCRichedit.CreateWnd;
var xMask: Integer;
begin
  inherited CreateWnd;
  xMask := SendMessage(Handle, EM_GETEVENTMASK, 0, 0);
  SendMessage(Handle, EM_SETEVENTMASK, 0, xMask or ENM_LINK);
  SendMessage(Handle, EM_AUTOURLDETECT, Integer(True), 0);
end;

procedure SetEvenListColors(AColorEven, AColorOdd: TColor);
var xCount: Integer;
    xRef: Boolean;
begin
  xRef := False;
  if AColorEven <> LEvenColor then begin
    LEvenColor := AColorEven;
    xRef := True;
  end;
  if AColorOdd <> LOddColor then begin
    LOddColor := AColorOdd;
    xRef := True;
  end;
  if xRef then begin
    for xCount := 0 to ListComponents.Count - 1 do begin
      TCList(ListComponents.Items[xCount]).Refresh;
    end;
  end;
end;

procedure TCDataList.SetViewTextSelector(const Value: String);
begin
  if FViewTextSelector <> Value then begin
    FViewTextSelector := Value;
    Refresh;
  end;
end;

procedure TPrefItem.Clone(APrefItem: TPrefItem);
begin
  FPrefname := APrefItem.Prefname;
end;

constructor TPrefItem.Create(APrefname: String);
begin
  inherited Create;
  FPrefname := APrefname;
end;

function TPrefItem.FindNode(AParentNode: ICXMLDOMNode; ACanCreate: Boolean): ICXMLDOMNode;
var xNode: ICXMLDOMNode;
begin
  xNode := AParentNode.firstChild;
  Result := Nil;
  while (xNode <> Nil) and (Result = Nil) do begin
    if xNode.nodeName = GetNodeName then begin
      if GetXmlAttribute('name', xNode, '') = FPrefname then begin
        Result := xNode;
      end;
    end;
    xNode := xNode.nextSibling;
  end;
  if ACanCreate and (Result = Nil) then begin
    Result := AParentNode.ownerDocument.createElement(GetNodeName);
    AParentNode.appendChild(Result);
    SetXmlAttribute('name', Result, FPrefname);
  end;
end;

procedure TPrefItem.LoadFromParentNode(AParentNode: ICXMLDOMNode);
var xNode: ICXMLDOMNode;
begin
  xNode := FindNode(AParentNode, False);
  if xNode <> Nil then begin
    LoadFromXml(xNode);
  end;
end;

procedure TPrefItem.LoadFromXml(ANode: ICXMLDOMNode);
begin
end;

procedure TPrefItem.SaveToParentNode(AParentNode: ICXMLDOMNode);
var xNode: ICXMLDOMNode;
begin
  xNode := FindNode(AParentNode, True);
  SaveToXml(xNode);
end;

function TPrefList.Add(AObject: TObject; ACheckUniqe: Boolean): Integer;
var xValid: Boolean;
begin
  if ACheckUniqe then begin
    xValid := ByPrefname[TPrefItem(AObject).Prefname] = Nil;
    if not xValid then begin
      raise Exception.Create('Brak unikalnej nazwy dla obiektu klasy PrefItem');
    end;
  end else begin
    xValid := True;
  end;
  if xValid then begin
    Result := inherited Add(AObject);
  end else begin
    Result := -1;
  end;
end;

function TPrefList.AppendNewPrefitem(APrefname: String): TPrefItem;
var xItemClass: TPrefItemClass;
begin
  Result := ByPrefname[APrefname];
  if Result = Nil then begin
    if FItemClass <> Nil then begin
      xItemClass := FItemClass;
    end else begin
      xItemClass := FGetItemClassFunction(APrefname);
    end;
    if xItemClass <> Nil then begin
      Result := xItemClass.Create(APrefname);
      Add(Result, True);
    end;
  end;
end;

procedure TPrefList.Clone(APrefList: TPrefList);
var xCount: Integer;
    xObj: TPrefItem;
    xSou: TPrefItem;
    xItemClass: TPrefItemClass;
begin
  for xCount := 0 to APrefList.Count - 1 do begin
    xSou := APrefList.Items[xCount];
    xObj := ByPrefname[xSou.Prefname];
    if xObj = Nil then begin
      if FItemClass <> Nil then begin
        xItemClass := FItemClass;
      end else begin
        xItemClass := FGetItemClassFunction(xSou.FPrefname);
      end;
      xObj := xItemClass.Create(xSou.FPrefname);
      xObj.Clone(xSou);
      Add(xObj, True);
    end else begin
      xObj.Clone(xSou);
    end;
  end;
end;

constructor TPrefList.Create(AItemClass: TPrefItemClass);
begin
  inherited Create(True);
  FItemClass := AItemClass;
  FGetItemClassFunction := Nil;
end;

constructor TPrefList.Create(AGetItemClassFunction: TGetItemClassFunction);
begin
  inherited Create(True);
  FGetItemClassFunction := AGetItemClassFunction;
  FItemClass := Nil;
end;

function TPrefList.GetByPrefname(APrefname: String): TPrefItem;
var xCount: Integer;
    xPrefname: String;
begin
  xCount := 0;
  xPrefname := AnsiLowerCase(APrefname);
  Result := Nil;
  while (xCount <= Count - 1) and (Result = Nil) do begin
    if AnsiLowerCase(Items[xCount].Prefname) = xPrefname then begin
      Result := Items[xCount];
    end;
    Inc(xCount);
  end;
end;

function TPrefList.GetItems(AIndex: Integer): TPrefItem;
begin
  Result := TPrefItem(inherited Items[AIndex]);
end;

procedure TPrefList.LoadAllFromParentNode(AParentNode: ICXMLDOMNode);
var xNode: ICXMLDOMNode;
    xItem: TPrefItem;
    xName: String;
    xItemClass: TPrefItemClass;
begin
  xNode := AParentNode.firstChild;
  while (xNode <> Nil) do begin
    xName := GetXmlAttribute('name', xNode, '');
    if FItemClass <> Nil then begin
      xItemClass := FItemClass;
    end else begin
      xItemClass := FGetItemClassFunction(xName);
    end;
    if xItemClass <> Nil then begin
      xItem := xItemClass.Create(xName);
      xItem.LoadFromXml(xNode);
      Add(xItem, True);
    end;
    xNode := xNode.nextSibling;
  end;
end;

procedure TPrefList.LoadFromParentNode(AParentNode: ICXMLDOMNode);
var xCount: Integer;
begin
  for xCount := 0 to Count - 1 do begin
    Items[xCount].LoadFromParentNode(AParentNode);
  end;
end;

procedure TPrefList.SavetToParentNode(AParentNode: ICXMLDOMNode);
var xCount: Integer;
begin
  for xCount := 0 to Count - 1 do begin
    Items[xCount].SaveToParentNode(AParentNode);
  end;
end;

procedure TPrefList.SetItems(AIndex: Integer; const Value: TPrefItem);
begin
  inherited Items[AIndex] := Value;
end;

procedure TPrefItem.SaveToXml(ANode: ICXMLDOMNode);
begin
end;

procedure SaveFontToXml(ANode: ICXMLDOMNode; AFont: TFont);
begin
  SetXmlAttribute('FontName', ANode, AFont.Name);
  SetXmlAttribute('Size', ANode, AFont.Size);
  SetXmlAttribute('Color', ANode, AFont.Color);
  SetXmlAttribute('IsBold', ANode, fsBold in AFont.Style);
  SetXmlAttribute('IsItalic', ANode, fsItalic in AFont.Style);
  SetXmlAttribute('IsUnderline', ANode, fsUnderline in AFont.Style);
  SetXmlAttribute('IsStrikeout', ANode, fsStrikeOut in AFont.Style);
end;

procedure LoadFontFromXml(ANode: ICXMLDOMNode; AFont: TFont);
begin
  AFont.Name := GetXmlAttribute('FontName', ANode, 'MS Sans Serif');
  AFont.Size := GetXmlAttribute('Size', ANode, 8);
  AFont.Color := GetXmlAttribute('Color', ANode, clWindowText);
  if GetXmlAttribute('IsBold', ANode, False) then begin
    AFont.Style := AFont.Style +  [fsBold];
  end else begin
    AFont.Style := AFont.Style - [fsBold];
  end;
  if GetXmlAttribute('IsItalic', ANode, False) then begin
    AFont.Style := AFont.Style + [fsItalic];
  end else begin
    AFont.Style := AFont.Style - [fsItalic];
  end;
  if GetXmlAttribute('IsUnderline', ANode, False) then begin
    AFont.Style := AFont.Style + [fsUnderline];
  end else begin
    AFont.Style := AFont.Style - [fsUnderline];
  end;
  if GetXmlAttribute('IsStrikeout', ANode, False) then begin
    AFont.Style := AFont.Style + [fsStrikeOut];
  end else begin
    AFont.Style := AFont.Style - [fsStrikeOut];
  end;
end;

procedure TViewPref.Clone(APrefItem: TPrefItem);
begin
  inherited Clone(APrefItem);
  FFocusedBackgroundColor := TViewPref(APrefItem).FocusedBackgroundColor;
  FFocusedFontColor := TViewPref(APrefItem).FocusedFontColor;
  FButtonSmall := TViewPref(APrefItem).ButtonSmall;
  FFontprefs.Clone(TViewPref(APrefItem).Fontprefs);
end;

constructor TViewPref.Create(APrefname: String);
begin
  inherited Create(APrefname);
  FFocusedBackgroundColor := clHighlight;
  FFocusedFontColor := clHighlightText;
  FFontprefs := TPrefList.Create(TFontPref);
  FButtonSmall := False;
end;

destructor TViewPref.Destroy;
begin
  FFontprefs.Free;
  inherited Destroy;
end;

function TViewPref.GetNodeName: String;
begin
  Result := 'viewpref';
end;

procedure TFontPref.Clone(APrefItem: TPrefItem);
begin
  inherited Clone(APrefItem);
  FBackground := TFontPref(APrefItem).Background;
  FBackgroundEven := TFontPref(APrefItem).BackgroundEven;
  FRowHeight := TFontPref(APrefItem).RowHeight;
  FFont.Assign(TFontPref(APrefItem).Font);
  FDesc := TFontPref(APrefItem).Desc;
end;

constructor TFontPref.Create(APrefname: String);
begin
  inherited Create(APrefname);
  FBackground := LOddColor;
  FBackgroundEven := LEvenColor;
  FFont := TFont.Create;
  FFont.Color := clWindowText;
  FFont.Style := [];
  FFont.Size := 8;
  FFont.Name := 'MS Sans Serif';
  FRowHeight := 24;
end;

constructor TFontPref.CreateFontPref(APrefname, ADesc: String);
begin
  Create(APrefname);
  FDesc := ADesc;
end;

destructor TFontPref.Destroy;
begin
  FFont.Free;
  inherited Destroy;
end;

function TFontPref.GetNodeName: String;
begin
  Result := 'fontpref';
end;

procedure TFontPref.LoadFromXml(ANode: ICXMLDOMNode);
begin
  FBackground := StringToColor(GetXmlAttribute('background', ANode, IntToStr(LOddColor)));
  FBackgroundEven := StringToColor(GetXmlAttribute('backgroundEven', ANode, IntToStr(LEvenColor)));
  FRowHeight := GetXmlAttribute('rowheight', ANode, FRowHeight);
  LoadFontFromXml(ANode, FFont);
end;

procedure TFontPref.SaveToXml(ANode: ICXMLDOMNode);
begin
  inherited SaveToXml(ANode);
  SetXmlAttribute('background', ANode, ColorToString(FBackground));
  SetXmlAttribute('backgroundEven', ANode, ColorToString(FBackgroundEven));
  SetXmlAttribute('rowheight', ANode, FRowHeight);
  SaveFontToXml(ANode, FFont);
end;

procedure TViewPref.LoadFromXml(ANode: ICXMLDOMNode);
var xFontprefs: ICXMLDOMNode;
begin
  inherited LoadFromXml(ANode);
  FFocusedBackgroundColor := StringToColor(GetXmlAttribute('focusedBackgroundColor', ANode, ColorToString(clHighlight)));
  FFocusedFontColor := StringToColor(GetXmlAttribute('focusedFontColor', ANode, ColorToString(clHighlightText)));
  FButtonSmall := GetXmlAttribute('buttonSmall', ANode, False);
  xFontprefs := ANode.selectSingleNode('fontprefs');
  if xFontprefs <> Nil then begin
    FFontprefs.LoadFromParentNode(xFontprefs);
  end;
end;

procedure TViewPref.SaveToXml(ANode: ICXMLDOMNode);
var xFontprefs: ICXMLDOMNode;
begin
  inherited SaveToXml(ANode);
  SetXmlAttribute('focusedBackgroundColor', ANode, ColorToString(FFocusedBackgroundColor));
  SetXmlAttribute('focusedFontColor', ANode, ColorToString(FFocusedFontColor));
  SetXmlAttribute('buttonSmall', ANode, FButtonSmall);
  xFontprefs := ANode.selectSingleNode('fontprefs');
  if xFontprefs = Nil then begin
    xFontprefs := ANode.ownerDocument.createElement('fontprefs');
    ANode.appendChild(xFontprefs);
  end;
  FFontprefs.SavetToParentNode(xFontprefs);
end;

procedure TViewColumnPref.Clone(APrefItem: TPrefItem);
begin
  inherited Clone(APrefItem);
  Fposition := TViewColumnPref(APrefItem).position;
  Fwidth := TViewColumnPref(APrefItem).width;
  Fvisible := TViewColumnPref(APrefItem).visible;
  FsortOrder := TViewColumnPref(APrefItem).sortOrder;
end;

function TViewColumnPref.GetNodeName: String;
begin
  Result := 'columnPref';
end;

procedure TViewColumnPref.LoadFromXml(ANode: ICXMLDOMNode);
begin
  inherited LoadFromXml(ANode);
  Fposition := GetXmlAttribute('position', ANode, -1);
  Fwidth := GetXmlAttribute('width', ANode, -1);
  Fvisible := GetXmlAttribute('visible', ANode, -1);
  FsortOrder := GetXmlAttribute('sortOrder', ANode, 0);
end;

procedure TViewColumnPref.SaveToXml(ANode: ICXMLDOMNode);
begin
  inherited SaveToXml(ANode);
  SetXmlAttribute('position', ANode, Fposition);
  SetXmlAttribute('width', ANode, Fwidth);
  SetXmlAttribute('visible', ANode, Fvisible);
  SetXmlAttribute('sortOrder', ANode, FsortOrder);
end;

constructor TCDataListSimpleString.Create(ACaption: String);
begin
  inherited Create;
  FCaption := ACaption;
end;

function TCDataListSimpleString.GetColumnText(AColumnIndex: Integer; AStatic: Boolean; AViewTextSelector: String): String;
begin
  Result := FCaption;
end;

procedure SmoothResize(apng:tpngobject; NuWidth,NuHeight:integer);
var
  xscale, yscale         : Single;
  sfrom_y, sfrom_x       : Single;
  ifrom_y, ifrom_x       : Integer;
  to_y, to_x             : Integer;
  weight_x, weight_y     : array[0..1] of Single;
  weight                 : Single;
  new_red, new_green     : Integer;
  new_blue, new_alpha    : Integer;
  new_colortype          : Integer;
  total_red, total_green : Single;
  total_blue, total_alpha: Single;
  IsAlpha                : Boolean;
  ix, iy                 : Integer;
  bTmp : TPNGObject;
  sli, slo : pRGBLine;
  ali, alo: pbytearray;
begin
  if not (apng.Header.ColorType in [COLOR_RGBALPHA, COLOR_RGB]) then
    raise Exception.Create('Only COLOR_RGBALPHA and COLOR_RGB formats' +
    ' are supported');
  IsAlpha := apng.Header.ColorType in [COLOR_RGBALPHA];
  if IsAlpha then new_colortype := COLOR_RGBALPHA else
    new_colortype := COLOR_RGB;
  bTmp := Tpngobject.CreateBlank(new_colortype, 8, NuWidth, NuHeight);
  xscale := bTmp.Width / (apng.Width-1);
  yscale := bTmp.Height / (apng.Height-1);
  for to_y := 0 to bTmp.Height-1 do begin
    sfrom_y := to_y / yscale;
    ifrom_y := Trunc(sfrom_y);
    weight_y[1] := sfrom_y - ifrom_y;
    weight_y[0] := 1 - weight_y[1];
    for to_x := 0 to bTmp.Width-1 do begin
      sfrom_x := to_x / xscale;
      ifrom_x := Trunc(sfrom_x);
      weight_x[1] := sfrom_x - ifrom_x;
      weight_x[0] := 1 - weight_x[1];
 
      total_red   := 0.0;
      total_green := 0.0;
      total_blue  := 0.0;
      total_alpha  := 0.0;
      for ix := 0 to 1 do begin
        for iy := 0 to 1 do begin
          sli := apng.Scanline[ifrom_y + iy];
          if IsAlpha then ali := apng.AlphaScanline[ifrom_y + iy];
          new_red := sli[ifrom_x + ix].rgbtRed;
          new_green := sli[ifrom_x + ix].rgbtGreen;
          new_blue := sli[ifrom_x + ix].rgbtBlue;
          if IsAlpha then new_alpha := ali[ifrom_x + ix] else new_alpha := 0;
          weight := weight_x[ix] * weight_y[iy];
          total_red   := total_red   + new_red   * weight;
          total_green := total_green + new_green * weight;
          total_blue  := total_blue  + new_blue  * weight;
          if IsAlpha then total_alpha  := total_alpha  + new_alpha  * weight;
        end;
      end;
      slo := bTmp.ScanLine[to_y];
      if IsAlpha then alo := bTmp.AlphaScanLine[to_y];
      slo[to_x].rgbtRed := Round(total_red);
      slo[to_x].rgbtGreen := Round(total_green);
      slo[to_x].rgbtBlue := Round(total_blue);
      if isAlpha then alo[to_x] := Round(total_alpha);
    end;
  end;
  apng.Assign(bTmp);
  bTmp.Free;
end;

function GetScaledPngImageList(APngImageList: TPngImageList; ANewWidth, ANewHeight: Integer): TPngImageList;
var xCount: Integer;
    xPng, xInPng: TPNGObject;
begin
  Result := TPngImageList.Create(Nil);
  Result.Width := ANewWidth;
  Result.Height := ANewHeight;
  for xCount := 0 to APngImageList.Count - 1 do begin
    xPng := APngImageList.PngImages.Items[xCount].Duplicate;
    SmoothResize(xPng, ANewWidth, ANewHeight);
    xInPng := Result.PngImages.Add.PngImage;
    xInPng.Assign(xPng);
    Result.InsertPng(0, xInPng);
    xPng.Free;
  end;
end;

procedure TCIntEdit.SetValue(const Value: Integer);
begin
  Text := IntToStr(Value);
end;

function TCPanel.GetTextLeft: Integer;
var xWidth: Integer;
begin
  xWidth := Canvas.TextWidth(Caption);
  if Alignment = taLeftJustify then begin
    Result := 0;
  end else if Alignment = taRightJustify then begin
    Result := Width - xWidth;
  end else begin
    Result := (Width - xWidth) div 2;
  end;
end;

procedure TCPanel.Paint;
const
  Alignments: array[TAlignment] of Longint = (DT_LEFT, DT_RIGHT, DT_CENTER);
var
  Rect: TRect;
  TopColor, BottomColor: TColor;
  FontHeight: Integer;
  Flags: Longint;

  procedure AdjustColors(Bevel: TPanelBevel);
  begin
    TopColor := clBtnHighlight;
    if Bevel = bvLowered then TopColor := clBtnShadow;
    BottomColor := clBtnShadow;
    if Bevel = bvLowered then BottomColor := clBtnHighlight;
  end;

begin
  Rect := GetClientRect;
  if not (beRight in BevelEdges) then begin
    Rect.Right := Rect.Right + 2;
  end;
  if not (beLeft in BevelEdges) then begin
    Rect.Left := Rect.Left - 2;
  end;
  if not (beTop in BevelEdges) then begin
    Rect.Top := Rect.Top - 2;
  end;
  if not (beBottom in BevelEdges) then begin
    Rect.Bottom := Rect.Bottom + 2;
  end;
  if BevelOuter <> bvNone then begin
    AdjustColors(BevelOuter);
    Frame3D(Canvas, Rect, TopColor, BottomColor, BevelWidth);
  end;
  Frame3D(Canvas, Rect, Color, Color, BorderWidth);
  if BevelInner <> bvNone then begin
    AdjustColors(BevelInner);
    Frame3D(Canvas, Rect, TopColor, BottomColor, BevelWidth);
  end;
  with Canvas do begin
    Brush.Color := Color;
    FillRect(Rect);
    Brush.Style := bsClear;
    Font := Self.Font;
    FontHeight := TextHeight('W');
    with Rect do begin
      Top := ((Bottom + Top) - FontHeight) div 2;
      Bottom := Top + FontHeight;
    end;
    Flags := DT_EXPANDTABS or DT_VCENTER or Alignments[Alignment];
    Flags := DrawTextBiDiModeFlags(Flags);
    DrawText(Handle, PChar(Caption), -1, Rect, Flags);
  end;
end;

procedure SetSystemCustomColors(AColorDialog: TColorDialog);
begin
  with AColorDialog.CustomColors do begin
    Clear;
    Add('ColorA=' + IntToHex(ColorToRGB(clWindow), 6));
    Add('ColorB=' + IntToHex(ColorToRGB(clBtnFace), 6));
    Add('ColorC=' + IntToHex(ColorToRGB(clWindowText), 6));
    Add('ColorD=' + IntToHex(ColorToRGB(clInactiveCaption), 6));
    Add('ColorE=' + IntToHex(ColorToRGB(clActiveCaption), 6));
    Add('ColorF=' + IntToHex(ColorToRGB(clAppWorkSpace), 6));
    Add('ColorG=' + IntToHex(ColorToRGB(clHighlight), 6));
    Add('ColorH=' + IntToHex(ColorToRGB(clBtnShadow), 6));
    Add('ColorI=' + IntToHex(ColorToRGB(clHotLight), 6));
    Add('ColorJ=' + IntToHex(ColorToRGB(clMenuBar), 6));
    Add('ColorK=' + IntToHex(ColorToRGB(clMenuHighlight), 6));
    Add('ColorL=' + IntToHex(ColorToRGB(clGrayText), 6));
    Add('ColorM=' + IntToHex(ColorToRGB(clActiveBorder), 6));
    Add('ColorN=' + IntToHex(ColorToRGB(clBackground), 6));
    Add('ColorO=' + IntToHex(ColorToRGB(clBtnHighlight), 6));
    Add('ColorP=' + IntToHex(ColorToRGB(clScrollBar), 6));
  end;
end;

{ TCSpeedButton }

initialization
  CurrencyComponents := TObjectList.Create(False);
  ListComponents := TObjectList.Create(False);
  LEvenColor := clWindow;
  LOddColor := GetDarkerColor(LEvenColor);
finalization
  FreeAndNil(CurrencyComponents);
  FreeAndNil(ListComponents);
end.
