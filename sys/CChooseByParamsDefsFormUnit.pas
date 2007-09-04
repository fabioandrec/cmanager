unit CChooseByParamsDefsFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, CReports, Contnrs,
  CComponents, CTools;

type
  TDialogParamControl = class(TObjectList)
  private
    FdescLabel: TLabel;
    Fcontrol: TWinControl;
    Fparam: TReportDialgoParamDef;
    function GetNextTop: Integer;
    function GetIsValid: String;
    function GetValues: TVariantDynArray;
    procedure ChooseDataobject(var ADataGid, AText: String; var AAccepted: Boolean);
  public
    constructor Create(ADescLabel: TLabel; AParam: TReportDialgoParamDef; AControl: TWinControl);
    function FindChildByParamName(AParamName: String): TDialogParamControl;
    function FindChildByGriupName(AGroupName: String): TDialogParamControl;
    property descLabel: TLabel read FdescLabel write FdescLabel;
    property control: TWinControl read Fcontrol write Fcontrol;
    property param: TReportDialgoParamDef read Fparam write Fparam;
    property nextTop: Integer read GetNextTop;
    property isValid: String read GetIsValid;
    property values: TVariantDynArray read GetValues;
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

  TCPeriod = class(TCustomPanel)
  private
    FcomboControl: TComboBox;
    FstartLabel: TLabel;
    FstartDateControl: TCDateTime;
    FendLabel: TLabel;
    FendDateControl: TCDateTime;
    procedure ComboChanged(Sender: TObject);
    procedure GetFilterDates(var ADateFrom, ADateTo: TDateTime);
  protected
    procedure UpdateDateControls;
    procedure SetParent(AParent: TWinControl); override;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
  public
    constructor Create(AOwner: TComponent); override;
  end;

function ChooseByParamsDefs(var AParams: TReportDialogParamsDefs): Boolean;

implementation

uses CConsts, CInfoFormUnit, StrUtils, CBaseFrameUnit, CFrameFormUnit,
  CDatabase, CDataObjects, CDatatools, Types, DateUtils;

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
          TDialogParamControl(xParent.Items[xCount]).param.paramValues := TDialogParamControl(xParent.Items[xCount]).values;
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
    xCurrent := TDialogParamControl.Create(Nil, xParam, Nil);
    if xParam.paramType = CParamTypeText then begin
      xControl := TEdit.Create(Self);
      xControl.Name := 'Edit' + IntToStr(xCount);
      TEdit(xControl).Parent := TGroupBox(xParent.control);
      TEdit(xControl).BevelKind := bkTile;
      TEdit(xControl).BorderStyle := bsNone;
      TEdit(xControl).Text := '';
    end else if xParam.paramType = CParamTypeDecimal then begin
      if xParam.decimalLen = 0 then begin
        xControl := TCIntEdit.Create(Self);
        xControl.Name := 'IntEdit' + IntToStr(xCount);
        TCIntEdit(xControl).Parent := TGroupBox(xParent.control);
        TCIntEdit(xControl).BevelKind := bkTile;
        TCIntEdit(xControl).BorderStyle := bsNone;
        TCIntEdit(xControl).Text := '0';
      end else begin
        xControl := TCCurrEdit.Create(Self);
        xControl.Name := 'CurrEdit' + IntToStr(xCount);
        TCCurrEdit(xControl).Parent := TGroupBox(xParent.control);
        TCCurrEdit(xControl).BevelKind := bkTile;
        TCCurrEdit(xControl).BorderStyle := bsNone;
        TCCurrEdit(xControl).Decimals := xParam.decimalLen;
        TCCurrEdit(xControl).CurrencyStr := '';
        TCCurrEdit(xControl).CurrencyId := '';
      end;
    end else if xParam.paramType = CParamTypeDate then begin
      xControl := TCDateTime.Create(Self);
      xControl.Name := 'DateEdit' + IntToStr(xCount);
      TCDateTime(xControl).Parent := TGroupBox(xParent.control);
      TCDateTime(xControl).BevelKind := bkTile;
    end else if xParam.paramType = CParamTypePeriod then begin
      xControl := TCPeriod.Create(Self);
      xControl.Name := 'PeriodEdit' + IntToStr(xCount);
      TCPeriod(xControl).Parent := TGroupBox(xParent.control);
    end else if xParam.paramType = CParamTypeDataobject then begin
      xControl := TCStatic.Create(Self);
      xControl.Name := 'StaticEdit' + IntToStr(xCount);
      TCStatic(xControl).Parent := TGroupBox(xParent.control);
      TCStatic(xControl).BevelKind := bkTile;
      TCStatic(xControl).OnGetDataId := xCurrent.ChooseDataobject;
      if xParam.isMultiple then begin
        TCStatic(xControl).TextOnEmpty := '<wszystkie elementy>';
      end;
    end else begin
      xControl := Nil;
    end;
    xLabel := TLabel.Create(Self);
    xLabel.Name := 'Label' + IntToStr(xCount);
    xLabel.Alignment := taRightJustify;
    xLabel.Parent := TGroupBox(xParent.control);
    xLabel.Caption := xParam.desc;
    if xMaxLabelWidth < xLabel.Width then begin
      xMaxLabelWidth := xLabel.Width;
    end;
    xCurrent.descLabel := xLabel;
    xCurrent.control := xControl;
    if xControl <> Nil then begin
      xControl.Top := xControlTop;
      xControl.Width := 250;
      xControlHeight := xControl.Height;
      if xControl is TCPeriod then begin
        xLabel.Top := xControlTop + 5;
      end else begin
        xLabel.Top := xControlTop + ((xControlHeight - xLabel.Height) div 2);
      end;
    end;
    xParent.Add(xCurrent);
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
  if Fparam.isRequired then begin
    if Fparam.paramType = CParamTypeText then begin
      Result := IfThen(Trim(values[Low(values)]) = '', 'Parametr "' + Fparam.desc + '" nie mo¿e byæ pusty', '');
    end else if Fparam.paramType = CParamTypeDecimal then begin
      Result := IfThen(values[Low(values)] = 0, 'Parametr "' + Fparam.desc + '" nie mo¿e byæ równy zero', '');
    end else if Fparam.paramType = CParamTypePeriod then begin
      Result := '';
    end else if Fparam.paramType = CParamTypeDate then begin
      Result := IfThen(values[Low(values)] = 0, 'Parametr "' + Fparam.desc + '" nie mo¿e byæ pusty', '');
    end else if Fparam.paramType = CParamTypeDataobject then begin
      if Fparam.isMultiple then begin
        Result := '';
      end else begin
        Result := IfThen(Trim(values[Low(values)]) = CEmptyDataGid, 'Parametr "' + Fparam.desc + '" nie mo¿e byæ pusty', '');
      end;
    end;
  end;
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

function TDialogParamControl.GetValues: TVariantDynArray;
begin
  SetLength(Result, 0);
  if Fparam.paramType = CParamTypeText then begin
    SetLength(Result, 1);
    Result[Low(Result)] := TEdit(control).Text;
  end else if Fparam.paramType = CParamTypeDecimal then begin
    if Fparam.decimalLen = 0 then begin
      SetLength(Result, 1);
      Result[Low(Result)] := TCIntEdit(control).Value;
    end else begin
      SetLength(Result, 1);
      Result[Low(Result)] := TCCurrEdit(control).Value;
    end;
  end else if Fparam.paramType = CParamTypeDate then begin
    SetLength(Result, 1);
    Result[Low(Result)] := TCDateTime(control).Value;
  end else if Fparam.paramType = CParamTypePeriod then begin
    SetLength(Result, 2);
    Result[Low(Result)] := TCPeriod(control).FstartDateControl.Value;
    Result[High(Result)] := TCPeriod(control).FendDateControl.Value;
  end else if Fparam.paramType = CParamTypeDataobject then begin
    if Fparam.isMultiple then begin
      Result := StringToVariantArray(TCStatic(control).DataId, sLineBreak);
    end else begin
      SetLength(Result, 2);
      Result[Low(Result)] := TCStatic(control).DataId;
      Result[High(Result)] := TCStatic(control).Caption;
    end;
  end;
end;

procedure TDialogParamControl.ChooseDataobject(var ADataGid, AText: String; var AAccepted: Boolean);
var xClass: TCBaseFrameClass;
    xList: TStringList;
    xDataGid: String;
begin
  xClass := GRegisteredClasses.FindClass(Fparam.frameType);
  if xClass <> Nil then begin
    if Fparam.paramType = CParamTypeDataobject then begin
      if Fparam.isMultiple then begin
        xDataGid := '';
        xList := TStringList.Create;
        xList.Text := ADataGid;
        AAccepted := TCFrameForm.ShowFrame(xClass, xDataGid, AText, Nil, Nil, Nil, xList);
        ADataGid := xList.Text;
        if ADataGid = '' then begin
          AText := '<wszystkie elementy>';
        end else begin
          AText := '<wybrano ' + IntToStr(xList.Count) + '>';
        end;
        xList.Free;
      end else begin
        AAccepted := TCFrameForm.ShowFrame(xClass, ADataGid, AText);
      end;
    end;
  end;
end;

procedure TCPeriod.ComboChanged(Sender: TObject);
begin
  UpdateDateControls;
end;

constructor TCPeriod.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  BevelInner := bvNone;
  BevelOuter := bvNone;
  BevelKind := bkNone;
  Caption := '';
  FcomboControl := TComboBox.Create(Self);
  FcomboControl.Name := 'ComboControl';
  FcomboControl.BevelInner := bvNone;
  FcomboControl.BevelKind := bkTile;
  FcomboControl.Style := csDropDownList;
  FstartDateControl := TCDateTime.Create(Self);
  FstartDateControl.Name := 'StartDateControl';
  FendDateControl := TCDateTime.Create(Self);
  FendDateControl.Name := 'EndDateControl';
  FcomboControl.OnChange := ComboChanged;
  FstartLabel := TLabel.Create(Self);
  FendLabel := TLabel.Create(Self);
  Height := Height + 20;
end;

procedure TCPeriod.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
  if not (csDestroying in ComponentState) then begin
    FcomboControl.parent := Self;
    FstartDateControl.Parent := Self;
    FendDateControl.Parent := Self;
    FstartLabel.Parent := Self;
    FendLabel.Parent := Self;
    with FcomboControl.Items do begin
      Clear;
      Add('tylko dziœ');
      Add('w tym tygodniu');
      Add('w tym miesi¹cu');
      Add('ostatnie 7 dni');
      Add('ostatnie 14 dni');
      Add('ostatnie 30 dni');
      Add('w przysz³ym tygodni');
      Add('w przysz³ym miesi¹cu');
      Add('nastêpne 7 dni');
      Add('nastêpne 14 dni');
      Add('nastêpne 30 dni');
      Add('dowolny');
    end;
    Caption := '';
    FstartLabel.Caption := 'Zakres od';
    FendLabel.Caption := 'do';
    FcomboControl.ItemIndex := 0;
    UpdateDateControls;
  end;
end;

procedure TCPeriod.UpdateDateControls;
var xIsCustom: Boolean;
    xDs, xDe: TDateTime;
begin
  xIsCustom := (FcomboControl.ItemIndex = FcomboControl.Items.Count -1);
  FstartDateControl.Enabled := xIsCustom;
  FendDateControl.Enabled := xIsCustom;
  if not xIsCustom then begin
    GetFilterDates(xDs, xDe);
    FstartDateControl.Value := xDs;
    FendDateControl.Value := xDe;
  end;
end;

procedure TCPeriod.WMSize(var Message: TWMSize);
begin
  if (not (csDestroying in ComponentState)) then begin
    FcomboControl.Top := 0;
    FcomboControl.Left := 0;
    FcomboControl.Width := Width;
    FcomboControl.Height := 21;
    FstartDateControl.Height := 21;
    FstartDateControl.Top := FcomboControl.BoundsRect.Bottom + 16;
    FstartDateControl.Width := (FcomboControl.Width div 2) - 40;
    FendDateControl.Height := 21;
    FendDateControl.Top := FcomboControl.BoundsRect.Bottom + 16;
    FendDateControl.Width := (FcomboControl.Width div 2) - 40;
    FendDateControl.Left := FcomboControl.BoundsRect.Right - FendDateControl.Width;
    FstartDateControl.Left := FendDateControl.Left - FstartDateControl.Width - 24;
    FstartLabel.Top := FstartDateControl.Top + ((FstartDateControl.Height - FstartLabel.Height) div 2);
    FstartLabel.Left := FstartDateControl.Left - FstartLabel.Width - 5;
    FendLabel.Top := FendDateControl.Top + ((FendDateControl.Height - FendLabel.Height) div 2);
    FendLabel.Left := FendDateControl.Left - FendLabel.Width - 5;
  end;
end;

procedure TCPeriod.GetFilterDates(var ADateFrom, ADateTo: TDateTime);
var xId: Integer;
begin
  ADateFrom := 0;
  ADateTo := 0;
  xId := FcomboControl.ItemIndex;
  if xId = 0 then begin
    ADateFrom := GWorkDate;
    ADateTo := GWorkDate;
  end else if xId = 1 then begin
    ADateFrom := StartOfTheWeek(GWorkDate);
    ADateTo := EndOfTheWeek(GWorkDate);
  end else if xId = 2 then begin
    ADateFrom := StartOfTheMonth(GWorkDate);
    ADateTo := EndOfTheMonth(GWorkDate);
  end else if xId = 3 then begin
    ADateFrom := IncDay(GWorkDate, -6);
    ADateTo := GWorkDate;
  end else if xId = 4 then begin
    ADateFrom := IncDay(GWorkDate, -13);
    ADateTo := GWorkDate;
  end else if xId = 5 then begin
    ADateFrom := IncDay(GWorkDate, -29);
    ADateTo := GWorkDate;
  end else if xId = 6 then begin
    ADateFrom := StartOfTheWeek(IncDay(GWorkDate, 7));
    ADateTo := EndOfTheWeek(IncDay(GWorkDate, 7));
  end else if xId = 7 then begin
    ADateFrom := StartOfTheMonth(IncDay(EndOfTheMonth(GWorkDate), 1));
    ADateTo := EndOfTheMonth(IncDay(EndOfTheMonth(GWorkDate), 1));
  end else if xId = 8 then begin
    ADateFrom := GWorkDate;
    ADateTo := IncDay(GWorkDate, 6);
  end else if xId = 9 then begin
    ADateFrom := GWorkDate;
    ADateTo := IncDay(GWorkDate, 13);
  end else if xId = 10 then begin
    ADateFrom := GWorkDate;
    ADateTo := IncDay(GWorkDate, 29);
  end else if xId = 11 then begin
    ADateFrom := FstartDateControl.Value;
    ADateTo := FendDateControl.Value;
  end;
end;

end.
