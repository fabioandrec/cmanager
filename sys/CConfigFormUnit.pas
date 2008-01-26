unit CConfigFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFormUnit, ComCtrls, StdCtrls, ExtCtrls, Buttons, Themes,
  ImgList;

type
  TConfigOperation = (coNone, coAdd, coEdit);
  TCConfigForm = class(TCBaseForm)
    PanelConfig: TPanel;
    PanelButtons: TPanel;
    BitBtnOk: TBitBtn;
    BitBtnCancel: TBitBtn;
    procedure BitBtnOkClick(Sender: TObject);
    procedure BitBtnCancelClick(Sender: TObject);
  private
    FAccepted: Boolean;
    FOperation: TConfigOperation;
  protected
    function CanAccept: Boolean; virtual;
    function CanModifyValues: Boolean; virtual;
    procedure FillForm; virtual;
    procedure ReadValues; virtual;
    procedure DisableComponents; virtual;
  public
    function ShowConfig(AOperation: TConfigOperation; ACanResize: Boolean = False): Boolean; virtual;
    constructor Create(AOwner: TComponent); override;
  published
    property Operation: TConfigOperation read FOperation write FOperation;
    property Accepted: Boolean read FAccepted write FAccepted;
  end;

implementation

uses Math;

{$R *.dfm}

procedure TCConfigForm.BitBtnOkClick(Sender: TObject);
begin
  if CanAccept then begin
    FAccepted := True;
    Close;
  end;
end;

function TCConfigForm.CanAccept: Boolean;
begin
  Result := True;
end;

function TCConfigForm.ShowConfig(AOperation: TConfigOperation; ACanResize: Boolean = False): Boolean;
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
    BitBtnCancel.Caption := '&Wyjœcie';
  end;
  FillForm;
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
      if (xControl.Parent <> PanelButtons) then begin
        xControl.Enabled := False;
      end;
    end;
  end;
end;

constructor TCConfigForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

end.
