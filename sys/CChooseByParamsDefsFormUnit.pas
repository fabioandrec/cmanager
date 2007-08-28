unit CChooseByParamsDefsFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, CReports, Contnrs,
  CComponents;

type
  TDialogParamControl = class(TObjectList)
  private
    FdescLabel: TLabel;
    Fcontrol: TWinControl;
    Fparam: TReportDialgoParamDef;
    function GetNextTop: Integer;
    function GetIsValid: String;
    function GetValue: Variant;
  public
    constructor Create(ADescLabel: TLabel; AParam: TReportDialgoParamDef; AControl: TWinControl);
    function FindChildByParamName(AParamName: String): TDialogParamControl;
    function FindChildByGriupName(AGroupName: String): TDialogParamControl;
    property descLabel: TLabel read FdescLabel write FdescLabel;
    property control: TWinControl read Fcontrol write Fcontrol;
    property param: TReportDialgoParamDef read Fparam write Fparam;
    property nextTop: Integer read GetNextTop;
    property isValid: String read GetIsValid;
    property value: Variant read GetValue;
  end;

  TCChooseByParamsDefsForm = class(TCConfigForm)
  private
    FParams: TReportDialogParamsDefs;
    Fgroups: TDialogParamControl;
  protected
    function CanAccept: Boolean; override;
  public
    procedure PrepareFromParams(AParams: TReportDialogParamsDefs);
    destructor Destroy; override;
    constructor Create(AOwner: TComponent); override;
  end;

function ChooseByParamsDefs(var AParams: TReportDialogParamsDefs): Boolean;

implementation

uses CConsts, CInfoFormUnit;

{$R *.dfm}

function ChooseByParamsDefs(var AParams: TReportDialogParamsDefs): Boolean;
var xForm: TCChooseByParamsDefsForm;
begin
  Result := AParams.Count = 0;
  if not Result then begin
    xForm := TCChooseByParamsDefsForm.Create(Nil);
    xForm.PrepareFromParams(AParams);
    Result := xForm.ShowConfig(coEdit);
    xForm.Free;
  end;
end;

function TCChooseByParamsDefsForm.CanAccept: Boolean;
var xCountGroup, xCount: Integer;
    xParent: TDialogParamControl;
    xErrorText: String;
begin
  Result := inherited CanAccept;
  if Result then begin
    xCountGroup := 0;
    while Result and (xCountGroup <= Fgroups.Count - 1) do begin
      xParent := TDialogParamControl(Fgroups.Items[xCountGroup]);
      xCount := 0;
      while Result and (xCount <= xParent.Count - 1) do begin
        xErrorText := TDialogParamControl(xParent.Items[xCount]).isValid;
        Result := xErrorText = '';
        if not Result then begin
          ShowInfo(itError, xErrorText, '');
          TDialogParamControl(xParent.Items[xCount]).control.SetFocus;
        end else begin
          TDialogParamControl(xParent.Items[xCount]).param.paramValue := TDialogParamControl(xParent.Items[xCount]).value;
        end;
        Inc(xCount);
      end;
      Inc(xCountGroup);
    end;
  end;
end;

constructor TCChooseByParamsDefsForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Fgroups := TDialogParamControl.Create(Nil, Nil, Self);
end;

destructor TCChooseByParamsDefsForm.Destroy;
begin
  Fgroups.Free;
  inherited Destroy;
end;

procedure TCChooseByParamsDefsForm.PrepareFromParams(AParams: TReportDialogParamsDefs);
var xCount, xCountGroup: Integer;
    xGbox: TGroupBox;
    xParam: TReportDialgoParamDef;
    xParent: TDialogParamControl;
    xCurrent: TDialogParamControl;
    xMaxLabelWidth: Integer;
    xLabel: TLabel;
    xControl: TWinControl;
    xControlHeight, xControlTop: Integer;
    xGbTop: Integer;
begin
  FParams := AParams;
  xMaxLabelWidth := 0;
  for xCount := 0 to FParams.Count - 1 do begin
    xParam := FParams.Items[xCount];
    if Fgroups.FindChildByGriupName(FParams.Items[xCount].group) = Nil then begin
      xGbox := TGroupBox.Create(Self);
      xGbox.Name := 'GroupBox' + IntToStr(xCount);
      xGbox.Caption := ' ' + FParams.Items[xCount].group + ' ';
      xGbox.Parent := PanelConfig;
      Fgroups.Add(TDialogParamControl.Create(Nil, xParam, xGbox));
    end;
  end;
  for xCount := 0 to FParams.Count - 1 do begin
    xParam := FParams.Items[xCount];
    xParent := TDialogParamControl(Fgroups.FindChildByGriupName(xParam.group));
    xControlTop := xParent.nextTop;
    if xParam.paramType = CParamTypeText then begin
      xControl := TEdit.Create(Self);
      xControl.Name := 'Edit' + IntToStr(xCount);
      TEdit(xControl).Parent := TGroupBox(xParent.control);
      TEdit(xControl).BevelKind := bkTile;
      TEdit(xControl).BorderStyle := bsNone;
      TEdit(xControl).Text := '';
    end else if xParam.paramType = CParamTypeDecimal then begin
      xControl := TCIntEdit.Create(Self);
      xControl.Name := 'IntEdit' + IntToStr(xCount);
      TCIntEdit(xControl).Parent := TGroupBox(xParent.control);
      TCIntEdit(xControl).BevelKind := bkTile;
      TCIntEdit(xControl).BorderStyle := bsNone;
      TCIntEdit(xControl).Text := '0';
    end else if xParam.paramType = CParamTypeFloat then begin
      xControl := TCCurrEdit.Create(Self);
      xControl.Name := 'CurrEdit' + IntToStr(xCount);
      TCCurrEdit(xControl).Parent := TGroupBox(xParent.control);
      TCCurrEdit(xControl).BevelKind := bkTile;
      TCCurrEdit(xControl).BorderStyle := bsNone;
      TCCurrEdit(xControl).CurrencyStr := '';
      TCCurrEdit(xControl).CurrencyId := '';
    end else begin
      xControl := Nil;
    end;
    if xControl <> Nil then begin
      xLabel := TLabel.Create(Self);
      xLabel.Name := 'Label' + IntToStr(xCount);
      xLabel.Alignment := taRightJustify;
      xLabel.Parent := TGroupBox(xParent.control);
      xLabel.Caption := xParam.desc;
      if xMaxLabelWidth < xLabel.Width then begin
        xMaxLabelWidth := xLabel.Width;
      end;
      xControl.Top := xControlTop;
      xControl.Width := 250;
      xControlHeight := xControl.Height;
      xLabel.Top := xControlTop + ((xControlHeight - xLabel.Height) div 2);
      xCurrent := TDialogParamControl.Create(xLabel, xParam, xControl);
      xParent.Add(xCurrent);
    end;
  end;
  xGbTop := 16;
  for xCountGroup := 0 to Fgroups.Count - 1 do begin
    xParent := TDialogParamControl(Fgroups.Items[xCountGroup]);
    xParent.control.Top := xGbTop;
    xParent.control.Left := 16;
    xParent.control.Width := 250 + xMaxLabelWidth + 50;
    for xCount := 0 to xParent.Count - 1 do begin
      xCurrent := TDialogParamControl(xParent.Items[xCount]);
      xCurrent.descLabel.Left := 20 + xMaxLabelWidth - xCurrent.descLabel.Width;
      xCurrent.control.Left := 26 + xMaxLabelWidth;
    end;
    xParent.control.Height := xParent.nextTop + 10;
    xGbTop := xGbTop + xParent.control.Height + 16;
    if xCountGroup = Fgroups.Count - 1 then begin
      Height := xGbTop + PanelButtons.Height + 20;
      Width := xMaxLabelWidth + 340
    end;
  end;
end;

constructor TDialogParamControl.Create(ADescLabel: TLabel; AParam: TReportDialgoParamDef; AControl: TWinControl);
begin
  inherited Create(True);
  FdescLabel := ADescLabel;
  Fcontrol := AControl;
  Fparam := AParam;
end;

function TDialogParamControl.FindChildByGriupName(AGroupName: String): TDialogParamControl;
var xCount: Integer;
begin
  Result := Nil;
  xCount := 0;
  while (Result = Nil) and (xCount <= Count - 1) do begin
    if TDialogParamControl(Items[xCount]).param.group = AGroupName then begin
      Result := TDialogParamControl(Items[xCount]);
    end;
    Inc(xCount);
  end;
end;

function TDialogParamControl.FindChildByParamName(AParamName: String): TDialogParamControl;
var xCount: Integer;
begin
  Result := Nil;
  xCount := 0;
  while (Result = Nil) and (xCount <= Count - 1) do begin
    if TDialogParamControl(Items[xCount]).param.name = AParamName then begin
      Result := TDialogParamControl(Items[xCount]);
    end;
    Inc(xCount);
  end;
end;

function TDialogParamControl.GetIsValid: String;
begin
  Result := '';
end;

function TDialogParamControl.GetNextTop: Integer;
var xCount: Integer;
    xControl: TDialogParamControl;
begin
  Result := 28;
  for xCount := 0 to Count - 1 do begin
    xControl := TDialogParamControl(Items[xCount]);
    Result := Result + xControl.control.Height + 14;
  end;
end;

function TDialogParamControl.GetValue: Variant;
begin
  VarClear(Result);
  if Fparam.paramType = CParamTypeText then begin
    Result := TEdit(control).Text;
  end else if Fparam.paramType = CParamTypeDecimal then begin
    Result := TCIntEdit(control).Value;
  end else if Fparam.paramType = CParamTypeFloat then begin
    Result := TCCurrEdit(control).Value;
  end;
end;

end.
