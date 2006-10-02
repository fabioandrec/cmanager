unit CComponents;

interface

uses Windows, Messages, Graphics, Controls, ActnList, Classes, CommCtrl, ImgList,
     Buttons, StdCtrls, ExtCtrls, SysUtils, ComCtrls, IntfUIHandlers, ShDocVw,
     ActiveX;

type
  TPicturePosition = (ppLeft, ppTop);

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
  end;

  TCImage = class(TGraphicControl)
  private
    FImageList: TImageList;
    FImageIndex: Integer;
    procedure SetImageIndex(const Value: Integer);
    procedure SetImageList(const Value: TImageList);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property ImageList: TImageList read FImageList write SetImageList;
    property ImageIndex: Integer read FImageIndex write SetImageIndex;
  end;

  TOnGetDataId = procedure (var ADataGid: String; var AText: String; var AAccepted: Boolean) of Object;

  TCStatic = class(TStaticText)
  private
    FDataId: string;
    FOnGetDataId: TOnGetDataId;
    FOnChanged: TNotifyEvent;
    FTextOnEmpty: string;
    FHotTrack: Boolean;
    FOldColor: TColor;
    procedure SetDataId(const Value: string);
    procedure SetTextOnEmpty(const Value: string);
  protected
    procedure CMMouseenter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseleave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure Loaded; override;
    procedure Click; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure DoGetDataId;
  published
    property DataId: string read FDataId write SetDataId;
    property TextOnEmpty: string read FTextOnEmpty write SetTextOnEmpty;
    property Action;
    property OnKeyDown;
    property OnKeyPress;
    property Enabled;
    property OnGetDataId: TOnGetDataId read FOnGetDataId write FOnGetDataId;
    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
    property HotTrack: Boolean read FHotTrack write FHotTrack;
  end;

  TCDateTime = class(TStaticText)
  private
    FValue: TDateTime;
    FOnChanged: TNotifyEvent;
    FHotTrack: Boolean;
    FOldColor: TColor;
    procedure SetValue(const Value: TDateTime);
    procedure UpdateCaption;
  protected
    procedure CMMouseenter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseleave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure Click; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Value: TDateTime read FValue write SetValue;
    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
    property HotTrack: Boolean read FHotTrack write FHotTrack;
  end;

  TCEditError = class(Exception);

  TCCurrEdit = class(TCustomEdit)
  private
    FAlign: TAlignment;
    FValue: Currency;
    FMaxDigits: smallint;
    FDecimals: smallint;
    FCurrencyStr: string;
    FOldText: string;
    FShowKSeps: boolean;
    FEditMode: boolean;
    procedure SetTextFromValue;
    function FormatIt(Value: Currency; ShowMode: boolean): string;
    function LeftStr(OrgStr: string; CharCount: smallint): string;
    function RightStr(OrgStr: string; CharCount: smallint): string;
    function InsertChars(OrgStr, InsChars: string; CharPos: smallint): string;
    function DeleteChars(OrgStr: string; CharPos, CharCount: smallint): string;
    function ReplaceChars(OrgStr, ReplChars: string; CharPos: smallint): string;
    function ReplaceChars2(OrgStr: string; ReplChar: Char; CharPos, CharCount: smallint): string;
    function GetDecimals: smallint;
    procedure SetDecimals(Value: smallint);
    function GetValue: Currency;
    procedure SetValue(Value: Currency);
    function GetCurrStr: string;
    procedure SetCurrStr(CurrStr: string);
  protected
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure DoEnter; override;
    procedure DoExit; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Update; override;
    function AsCurrency: Currency;
    function AsFloat: double;
    function AsString: string;
  published
    property AutoSelect;
    property AutoSize;
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
    property Value: Currency read GetValue write SetValue;
    property CurrencyStr: string read GetCurrStr write SetCurrStr;
    property ThousandSep: Boolean read FShowKSeps write FShowKSeps;
    property BevelEdges;
    property BevelKind;
    property BevelOuter;
    property BevelInner;
    property BevelWidth;
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
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure DoExit; override;
    procedure DoEnter; override;
  public
    property Value: Integer read GetValue;
  end;

procedure Register;

implementation

uses Forms, CCalendarFormUnit, Types;

procedure Register;
begin
  RegisterComponents('CManager', [TCButton, TCImage, TCStatic, TCCurrEdit, TCDateTime, TCBrowser, TCIntEdit]);
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
var
  xDC: HDC;
  xTextHeight: Integer;
  xTextWidth: Integer;
  xImgX, xImgY: Integer;
  xTxtX, xTxtY: Integer;
  xImages: TCustomImageList;
begin
  xDC := Canvas.Handle;
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
    if TCustomAction(Action).ImageIndex <> -1 then begin
      ImageList_Draw(xImages.Handle, TCustomAction(Action).ImageIndex, xDC, xImgX, xImgY, ILD_NORMAL);
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
    ImageList_Draw(FImageList.Handle, FImageIndex, Canvas.Handle, xImgX, xImgY, ILD_NORMAL + ILD_TRANSPARENT);
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

procedure TCImage.SetImageList(const Value: TImageList);
begin
  if FImageList <> Value then begin
    FImageList := Value;
    FImageIndex := -1;
    Invalidate;
  end;
end;

procedure TCStatic.Click;
var xId, xText: String;
    xAccepted: Boolean;
begin
  inherited Click;
  if Assigned(FOnGetDataId) then begin
    xId := DataId;
    xText := Caption;
    FOnGetDataId(xId, xText, xAccepted);
    if xAccepted then begin
      Caption := xText;
      DataId := xId;
    end;
  end;
end;

procedure TCStatic.CMMouseenter(var Message: TMessage);
begin
  if FHotTrack and Enabled and (not (csDesigning in ComponentState)) then begin
    Font.Style := Font.Style + [fsUnderline];
    FOldColor := Font.Color;
    Font.Color := clNavy;
  end;
end;

procedure TCStatic.CMMouseleave(var Message: TMessage);
begin
  if FHotTrack and Enabled and (not (csDesigning in ComponentState)) then begin
    Font.Style := Font.Style - [fsUnderline];
    Font.Color := FOldColor;
  end;
end;

constructor TCStatic.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AutoSize := False;
  Height := 21;
  Width := 150;
  BorderStyle := sbsNone;
  BevelKind := bkTile;
  Cursor := crHandPoint;
  ParentColor := False;
  Color := clWindow;
  FTextOnEmpty := '<kliknij tutaj aby wybraæ>';
  Caption := FTextOnEmpty;
  FDataId := '';
  FHotTrack := True;
end;

procedure TCStatic.DoGetDataId;
begin
  Click;
end;

procedure TCStatic.Loaded;
begin
  inherited Loaded;
  if FDataId = '' then begin
    Caption := FTextOnEmpty;
  end;
end;

procedure TCStatic.SetDataId(const Value: string);
begin
  if FDataId <> Value then begin
    FDataId := Value;
    if FDataId = '' then begin
      Caption := FTextOnEmpty;
    end;
    if Assigned(FOnChanged) then begin
      FOnChanged(Self);
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

constructor TCCurrEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCurrencyStr := 'z³';
  FValue := 0;
  FDecimals := 2;
  FMaxDigits := 17 - FDecimals;
  FAlign := taRightJustify;
  FShowKSeps := True;
  FEditMode := False;
  SetTextFromValue;
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
  FOldText := Text; //Backup the Text (for Undo with Esc)
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
var
  txt: string;
  tlen, cPos: integer;
  InputParsed: Boolean;
  DoBeep: Boolean;
begin
  if ReadOnly then Exit;

  DoBeep := False; //Defaults
  InputParsed := False;

  if Key = VK_DELETE then {//del-button only} begin
    cPos := SelStart;
    txt := FormatIt(StrToCurr(Text), False);
    tlen := Length(txt);

    if ((cPos = tlen) or (cPos = tlen - FDecimals - 1)) then {//forbidden Del-Positions} begin
      InputParsed := True; //Job done
      DoBeep := True; //Input Error
    end;

    if ((not InputParsed) and (SelStart = 0) and (SelLength = tlen)) then {//Delete complete} begin
      txt := FormatIt(0, False);
      InputParsed := True;
    end;

    if ((not InputParsed) and (cPos >= tlen - FDecimals - 1) and (cPos < tlen)) then {//Deleting in Decimal Area} begin
      if SelLength = 0 then begin
        if cPos < tlen - 1 then txt := DeleteChars(txt, cPos, 1) + '0' //Delete and Fillup with Zero
        else txt := ReplaceChars(txt, '0', cPos); //Replace Zero on Last Position

      end
      else begin
        txt := ReplaceChars2(txt, '0', cPos, SelLength);
      end;
      InputParsed := True; //Job done
    end;

    if ((not InputParsed) and (cPos <= tlen - FDecimals - 1)) then {//General Deleting-Handling} begin
      if SelLength = 0 then begin
        if LeftStr(txt, 1) <> '0' then {//No Leading Zero?} begin
          if tlen = FDecimals + 2 then txt := ReplaceChars(txt, '0', cPos) //Special-Handling for x.xx
          else txt := DeleteChars(txt, cPos, 1);
        end
        else begin
          DoBeep := True; //Cannot delete Leading Zero in this case!
        end;
      end
      else begin
        if cPos + SelLength <= tlen - FDecimals - 1 then begin
          txt := DeleteChars(txt, cPos, SelLength);
        end
        else begin
          DoBeep := True;
        end;
      end;
    end;
    if Text <> txt then begin
      cPos := SelStart;
      Text := FormatIt(StrToCurr(txt), False);
      SelStart := cPos;
      Modified := True;
    end;
    Key := 0; //Eat the Key
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
  txt := FormatIt(StrToCurr(Text), False);
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
      Text := FormatIt(StrToCurr(txt), False); //Reformat
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
  if ((Value >= 0) and (Value <= 4)) then begin
    FDecimals := Value;
  end
  else begin
    FDecimals := 2;
    raise TCEditError.Create('"' + IntToStr(Value) + '" is not valid for Decimals (0 to 4)');
  end;
  Update;
end;

function TCCurrEdit.GetValue: Currency;
begin
  result := FValue;
end;

procedure TCCurrEdit.SetValue(Value: Currency);
var
  test: string;
begin
  try
    test := FormatCurr('0.00', Value);
  except
    FValue := 0;
    raise TCEditError.Create('"' + FloatToStr(Value) + '" is not valid for Value');
  end;
  FValue := Value;
  Update;
end;

function TCCurrEdit.GetCurrStr: string;
begin
  result := FCurrencyStr;
end;

procedure TCCurrEdit.SetCurrStr(CurrStr: string);
begin
  FCurrencyStr := CurrStr;
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

//Special Public-Methods

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

function TCCurrEdit.FormatIt(Value: Currency; ShowMode: boolean): string;
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
    result := FormatCurr(mask, Value);
    if not ShowMode then FValue := StrToCurr(result);
  except
    result := '0' + DecimalSeparator + decimals;
    if not ShowMode then begin
      FValue := 0;
      SetTextFromValue;
    end;
    raise TCEditError.Create('"' + FloatToStr(Value) + '" is not a valid value');
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

procedure TCDateTime.Click;
var xDate: TDateTime;
begin
  inherited Click;
  xDate := FValue;
  if ShowCalendar(Self, xDate) then begin
    Value := xDate;
  end;
end;

procedure TCDateTime.CMMouseenter(var Message: TMessage);
begin
  if FHotTrack and Enabled and (not (csDesigning in ComponentState)) then begin
    Font.Style := Font.Style + [fsUnderline];
    FOldColor := Font.Color;
    Font.Color := clNavy;
  end;
end;

procedure TCDateTime.CMMouseleave(var Message: TMessage);
begin
  if FHotTrack and Enabled and (not (csDesigning in ComponentState)) then begin
    Font.Style := Font.Style - [fsUnderline];
    Font.Color := FOldColor;
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
  Cursor := crHandPoint;
  ParentColor := False;
  Color := clWindow;
  FValue := 0;
  FOnChanged := Nil;
  UpdateCaption;
  FHotTrack := True;
end;

procedure TCDateTime.SetValue(const Value: TDateTime);
begin
  if FValue <> Value then begin
    FValue := Value;
    UpdateCaption;
    if Assigned(FOnChanged) then begin
      FOnChanged(Self);
    end;
  end;
end;

procedure TCDateTime.UpdateCaption;
begin
  if FValue <> 0 then begin
    Caption := FormatDateTime('yyyy-mm-dd', FValue);
  end else begin
    Caption := '<wybierz datê>';
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

end.

