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

function ChooseByParamsDefs(var AParams: TReportDialogParamsDefs): Boolean;

implementation

uses CConsts, CInfoFormUnit, StrUtils, CBaseFrameUnit, CFrameFormUnit,
  CDatabase, CDataObjects, CDatatools;

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
    end else if xParam.paramType = CParamTypeDate then begin
      xControl := TCDateTime.Create(Self);
      xControl.Name := 'DateEdit' + IntToStr(xCount);
      TCDateTime(xControl).Parent := TGroupBox(xParent.control);
      TCDateTime(xControl).BevelKind := bkTile;
    end else if xParam.paramType = CParamTypeDataobject then begin
      xControl := TCStatic.Create(Self);
      xControl.Name := 'StaticEdit' + IntToStr(xCount);
      TCStatic(xControl).Parent := TGroupBox(xParent.control);
      TCStatic(xControl).BevelKind := bkTile;
      TCStatic(xControl).OnGetDataId := xCurrent.ChooseDataobject;
    end else if xParam.paramType = CParamTypeMultiobject then begin
      xControl := TCStatic.Create(Self);
      xControl.Name := 'StaticEdit' + IntToStr(xCount);
      TCStatic(xControl).Parent := TGroupBox(xParent.control);
      TCStatic(xControl).BevelKind := bkTile;
      TCStatic(xControl).OnGetDataId := xCurrent.ChooseDataobject;
      TCStatic(xControl).TextOnEmpty := '<wszystkie elementy>';
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
      xLabel.Top := xControlTop + ((xControlHeight - xLabel.Height) div 2);
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
      Result := IfThen(values[Low(values)] = 0, 'Parametr "' + Fparam.desc + '" nie mo¿e byæ równy 0', '');
    end else if Fparam.paramType = CParamTypeFloat then begin
      Result := IfThen(values[Low(values)] = 0.00, 'Parametr "' + Fparam.desc + '" nie mo¿e byæ równy 0.00', '');
    end else if Fparam.paramType = CParamTypeDate then begin
      Result := IfThen(values[Low(values)] = 0, 'Parametr "' + Fparam.desc + '" nie mo¿e byæ pusty', '');
    end else if Fparam.paramType = CParamTypeDataobject then begin
      Result := IfThen(Trim(values[Low(values)]) = CEmptyDataGid, 'Parametr "' + Fparam.desc + '" nie mo¿e byæ pusty', '');
    end else if Fparam.paramType = CParamTypeMultiobject then begin
      Result := '';
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
    SetLength(Result, 1);
    Result[Low(Result)] := TCIntEdit(control).Value;
  end else if Fparam.paramType = CParamTypeFloat then begin
    SetLength(Result, 1);
    Result[Low(Result)] := TCCurrEdit(control).Value;
  end else if Fparam.paramType = CParamTypeDate then begin
    SetLength(Result, 1);
    Result[Low(Result)] := TCDateTime(control).Value;
  end else if Fparam.paramType = CParamTypeDataobject then begin
    SetLength(Result, 2);
    Result[Low(Result)] := TCStatic(control).DataId;
    Result[High(Result)] := TCStatic(control).Caption;
  end else if Fparam.paramType = CParamTypeMultiobject then begin
    Result := StringToVariantArray(TCStatic(control).DataId, sLineBreak);
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
      AAccepted := TCFrameForm.ShowFrame(xClass, ADataGid, AText);
    end else if Fparam.paramType = CParamTypeMultiobject then begin
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
    end;
  end;
end;


end.
