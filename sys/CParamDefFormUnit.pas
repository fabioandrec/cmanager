unit CParamDefFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, CReports,
  CComponents, MsXml;

type
  TCParamDefForm = class(TCConfigForm)
    GroupBox1: TGroupBox;
    Label5: TLabel;
    ComboBoxGroup: TComboBox;
    Label1: TLabel;
    EditName: TEdit;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    ComboBoxType: TComboBox;
    Label3: TLabel;
    EditDesc: TEdit;
    Label4: TLabel;
    ComboBoxReq: TComboBox;
    Label6: TLabel;
    ComboBoxFrameType: TComboBox;
    Label7: TLabel;
    ComboBoxMultiple: TComboBox;
    CIntDecimal: TCIntEdit;
    Label8: TLabel;
    ComboBoxPropertyType: TComboBox;
    procedure ComboBoxTypeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FParamDef: TReportDialgoParamDef;
    procedure RefreshControls;
  protected
    function CanAccept: Boolean; override;
    procedure FillForm; override;
    procedure ReadValues; override;
  published
    property paramDef: TReportDialgoParamDef read FParamDef write FParamDef;
  end;

implementation

uses CInfoFormUnit, CConsts, Math, CBaseFrameUnit, CXml;

{$R *.dfm}

function TCParamDefForm.CanAccept: Boolean;
var xParam: TReportDialgoParamDef;
begin
  if Trim(ComboBoxGroup.Text) = '' then begin
    Result := False;
    ShowInfo(itError, 'Grupa, do której ma nale¿eæ parametr nie mo¿e byæ pusta', '');
    ComboBoxGroup.SetFocus;
  end else if Trim(EditName.Text) = '' then begin
    Result := False;
    ShowInfo(itError, 'Nazwa parametru nie mo¿e byæ pusta', '');
    EditName.SetFocus;
  end else if Pos(',', EditName.Text) > 0 then begin
    Result := False;
    ShowInfo(itError, 'Nazwa parametru nie mo¿e zawieraæ przecinka', '');
    EditName.SetFocus;
  end else begin
    xParam := FParamDef.parentParamsDefs.ByName[EditName.Text];
    Result := xParam = Nil;
    if (not Result) and (Operation = coEdit) then begin
      Result := xParam = FParamDef;
    end;
    if not Result then begin
      ShowInfo(itError, 'Istnieje ju¿ parametr o nazwie "' + EditName.Text + '". Wybierz inn¹ nazwê dla parametru.', '');
      EditName.SetFocus;
    end;
  end;
end;

procedure TCParamDefForm.FillForm;
var xCount: Integer;
    xIndexType, xIndexFrame, xIndexProperty: Integer;
    xRegs: TRegisteredFrameClass;
    xXml: IXMLDOMDocument;
    xNode: IXMLDOMNode;
begin
  inherited FillForm;
  for xCount := 0 to FParamDef.parentParamsDefs.groups.Count - 1 do begin
    ComboBoxGroup.Items.Add(FParamDef.parentParamsDefs.groups.Strings[xCount]);
  end;
  xIndexFrame := 0;
  for xCount := 0 to GRegisteredClasses.Count - 1 do begin
    xRegs := TRegisteredFrameClass(GRegisteredClasses.Items[xCount]);
    if xRegs.isReportParamAvaliable then begin
      ComboBoxFrameType.Items.AddObject(xRegs.frameClass.GetTitle, xRegs);
      if Operation = coEdit then begin
        if FParamDef.frameType = xRegs.frameType then begin
          xIndexFrame := xCount;
        end;
      end;
    end;
  end;
  xIndexProperty := 0;
  xXml := GetReportPropertyItems;
  for xCount := 0 to xXml.documentElement.childNodes.length - 1 do begin
    xNode := xXml.documentElement.childNodes.item[xCount];
    ComboBoxPropertyType.Items.Add(GetXmlAttribute('name', xNode, ''));
    if Operation = coEdit then begin
      if FParamDef.propertyType = xCount then begin
        xIndexProperty := xCount;
      end;
    end;
  end;
  xIndexType := 0;
  for xCount := Low(CReportParamTypes) to High(CReportParamTypes) do begin
    ComboBoxType.Items.Add(CReportParamTypes[xCount][0]);
    if Operation = coEdit then begin
      if FParamDef.paramType = CReportParamTypes[xCount][1] then begin
        xIndexType := xCount;
      end;
    end;
  end;
  ComboBoxType.ItemIndex := xIndexType;
  ComboBoxFrameType.ItemIndex := xIndexFrame;
  ComboBoxPropertyType.ItemIndex := xIndexProperty;
  if Operation = coEdit then begin
    EditName.Text := FParamDef.name;
    EditDesc.Text := FParamDef.desc;
    ComboBoxGroup.Text := FParamDef.group;
    ComboBoxReq.ItemIndex := IfThen(FParamDef.isRequired, 0, 1);
    ComboBoxMultiple.ItemIndex := IfThen(FParamDef.isMultiple, 0, 1);
    CIntDecimal.Text := IntToStr(FParamDef.decimalLen);
  end;
  RefreshControls;
end;

procedure TCParamDefForm.ReadValues;
begin
  inherited ReadValues;
  with FParamDef do begin
    name := EditName.Text;
    desc := EditDesc.Text;
    group := ComboBoxGroup.Text;
    paramType := CReportParamTypes[ComboBoxType.ItemIndex][1];
    isRequired := ComboBoxReq.ItemIndex = 0;
    isMultiple := ComboBoxMultiple.ItemIndex = 0;
    frameType := TRegisteredFrameClass(ComboBoxFrameType.Items.Objects[ComboBoxFrameType.ItemIndex]).frameType;
    decimalLen := CIntDecimal.Value;
    propertyType := ComboBoxPropertyType.ItemIndex;
  end;
end;

procedure TCParamDefForm.ComboBoxTypeChange(Sender: TObject);
begin
  RefreshControls;
end;

procedure TCParamDefForm.RefreshControls;
var xWithDataobject: Boolean;
    xWithDecimal: Boolean;
    xWithProperty: Boolean;
begin
  xWithDataobject := (CReportParamTypes[ComboBoxType.ItemIndex][1] = CParamTypeDataobject);
  xWithProperty := (CReportParamTypes[ComboBoxType.ItemIndex][1] = CParamTypeProperty);
  xWithDecimal := (CReportParamTypes[ComboBoxType.ItemIndex][1] = CParamTypeDecimal);
  ComboBoxType.Width := IfThen(xWithDataobject or xWithProperty, 153, 393);
  ComboBoxFrameType.Visible := xWithDataobject;
  ComboBoxPropertyType.Visible := xWithProperty;
  Label6.Visible := ComboBoxFrameType.Visible or ComboBoxPropertyType.Visible;
  ComboBoxMultiple.Visible := xWithDataobject or xWithProperty;
  Label7.Visible := ComboBoxMultiple.Visible;
  if xWithDataobject then begin
    Label6.Caption := 'Klasa obiektu';
  end else if xWithProperty then begin
    Label6.Caption := 'Rodzaj cechy';
  end;
  Label8.Visible := xWithDecimal;
  CIntDecimal.Visible := xWithDecimal
end;

procedure TCParamDefForm.FormCreate(Sender: TObject);
begin
  inherited;
  Label8.Top := Label7.Top;
  CIntDecimal.Top := ComboBoxMultiple.Top;
end;

end.
