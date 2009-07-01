unit CConfigFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFormUnit, ComCtrls, StdCtrls, ExtCtrls, Buttons, Themes,
  ImgList, CComponents;

type
  TInfoIconType = (iitNone, iitWarning, iitError, iitInfo, iitQuestion);

  TConfigOperation = (coNone, coAdd, coEdit);
  TCConfigForm = class(TCBaseForm)
    PanelConfig: TCPanel;
    PanelButtons: TCPanel;
    BitBtnOk: TBitBtn;
    BitBtnCancel: TBitBtn;
    procedure BitBtnOkClick(Sender: TObject);
    procedure BitBtnCancelClick(Sender: TObject);
  private
    FInfoPanel: TCPanel;
    FInfoIcon: TImage;
    FInfoBevel: TBevel;
    FAccepted: Boolean;
    FOperation: TConfigOperation;
    FFilling: Integer;
    function GetIsFilling: Boolean;
  protected
    function CanAccept: Boolean; virtual;
    function CanModifyValues: Boolean; virtual;
    procedure DoAccept; virtual;
    function ShouldFillForm: Boolean; virtual;
    procedure FillForm; virtual;
    procedure ReadValues; virtual;
    procedure DisableComponents; virtual;
    procedure ShowInfoPanel(AHeight: Integer; AText: String; AFontColor: TColor; AFontStyle: TFontStyles; AInfoIconType: TInfoIconType);
  protected
    procedure BeginFilling; virtual;
    procedure EndFilling; virtual;
  public
    function ShowConfig(AOperation: TConfigOperation; ACanResize: Boolean = False; ANoneButtonCaption: String = ''): Boolean; virtual;
    constructor Create(AOwner: TComponent); override;
  published
    property Operation: TConfigOperation read FOperation write FOperation;
    property Accepted: Boolean read FAccepted write FAccepted;
    property Filling: Boolean read GetIsFilling;
  end;

implementation

uses Math;

{$R *.dfm}

procedure TCConfigForm.BitBtnOkClick(Sender: TObject);
begin
  DoAccept;
end;

function TCConfigForm.CanAccept: Boolean;
begin
  Result := True;
end;

function TCConfigForm.ShowConfig(AOperation: TConfigOperation; ACanResize: Boolean = False; ANoneButtonCaption: String = ''): Boolean;
begin
  if ACanResize then begin
    BorderStyle := bsSizeable;
    BorderIcons := [biSystemMenu, biMinimize, biMaximize];
  end;
  FAccepted := False;
  FOperation := AOperation;
  if FOperation = coNone then begin
    BitBtnOk.Visible := False;
    BitBtnCancel.Default := True;
    if ANoneButtonCaption = '' then begin
      BitBtnCancel.Caption := '&Wyjœcie';
    end else begin
      BitBtnCancel.Caption := ANoneButtonCaption;
    end;
  end;
  if ShouldFillForm then begin
    BeginFilling;
    FillForm;
    EndFilling;
  end;
  if not CanModifyValues then begin
    DisableComponents;
  end;
  ShowModal;
  if FAccepted then begin
    ReadValues;
  end;
  Result := FAccepted;
end;

procedure TCConfigForm.BitBtnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TCConfigForm.FillForm;
begin
end;

procedure TCConfigForm.ReadValues;
begin
end;

function TCConfigForm.CanModifyValues: Boolean;
begin
  Result := True;
end;

procedure TCConfigForm.DisableComponents;
var xCount: Integer;
    xComponent: TComponent;
    xControl: TControl;
begin
  for xCount := 0 to ComponentCount - 1  do begin
    xComponent := Components[xCount];
    if xComponent.InheritsFrom(TControl) then begin
      xControl := xComponent as TControl;
      if (xControl.Parent <> PanelButtons) and (xControl <> PanelButtons) and (xControl <> FInfoPanel) then begin
        xControl.Enabled := False;
      end;
    end;
  end;
  BitBtnOk.Visible := False;
  BitBtnCancel.Default := True;
  BitBtnCancel.Caption := '&Wyjœcie';
end;

constructor TCConfigForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FInfoPanel := TCPanel.Create(Self);
  FInfoPanel.BorderStyle := bsNone;
  FInfoPanel.BevelInner := bvNone;
  FInfoPanel.BevelOuter := bvNone;
  FInfoBevel := TBevel.Create(Self);
  FInfoBevel.Shape := bsBottomLine;
  FInfoBevel.Parent := FInfoPanel;
  FInfoBevel.Align := alBottom;
  FInfoBevel.Height := 3;
  FInfoIcon := TImage.Create(Self);
  FInfoIcon.Name := 'InfoPanelImage';
  FInfoIcon.Parent := FInfoPanel;
  FInfoIcon.Left := 16;
  FInfoIcon.Top := 8;
  FInfoIcon.Width := 32;
  FInfoIcon.Height := 32;
  FFilling := 0;
end;

procedure TCConfigForm.ShowInfoPanel(AHeight: Integer; AText: String; AFontColor: TColor; AFontStyle: TFontStyles; AInfoIconType: TInfoIconType);
var xIconRes: PChar;
begin
  FInfoPanel.Align := alTop;
  FInfoPanel.Height := AHeight;
  FInfoPanel.Caption := AText;
  FInfoPanel.Font.Color := AFontColor;
  FInfoPanel.Font.Style := AFontStyle;
  case AInfoIconType of
    iitWarning: begin
      xIconRes := IDI_EXCLAMATION;
    end;
    iitError: begin
      xIconRes := IDI_HAND;
    end;
    iitInfo: begin
      xIconRes := IDI_ASTERISK;
    end;
    iitQuestion: begin
      xIconRes := IDI_QUESTION;
    end;
    else begin
      xIconRes := Nil;
    end;
  end;
  DisableAlign;
  Height := Height + FInfoPanel.Height;
  EnableAlign;
  FInfoPanel.Parent := Self;
  if xIconRes <> Nil then begin
    FInfoIcon.Picture.Icon.Handle := LoadIcon(0, xIconRes);
    FInfoIcon.Left := FInfoPanel.GetTextLeft - FInfoIcon.Width - 40;
    FInfoIcon.Visible := True;
  end else begin
    FInfoIcon.Visible := False;
  end;
end;

procedure TCConfigForm.DoAccept;
begin
  if CanAccept then begin
    FAccepted := True;
    Close;
  end;
end;

procedure TCConfigForm.BeginFilling;
begin
  Inc(FFilling);
end;

procedure TCConfigForm.EndFilling;
begin
  Dec(FFilling);
end;

function TCConfigForm.GetIsFilling: Boolean;
begin
  Result := FFilling > 0;
end;

function TCConfigForm.ShouldFillForm: Boolean;
begin
  Result := True;
end;

end.