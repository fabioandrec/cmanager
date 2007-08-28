unit CParamDefFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, CReports;

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
  private
    FParamDef: TReportDialgoParamDef;
  protected
    function CanAccept: Boolean; override;
    procedure FillForm; override;
    procedure ReadValues; override;
  published
    property paramDef: TReportDialgoParamDef read FParamDef write FParamDef;
  end;

implementation

uses CInfoFormUnit, CConsts;

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
    xIndex: Integer;
begin
  inherited FillForm;
  for xCount := 0 to FParamDef.parentParamsDefs.groups.Count - 1 do begin
    ComboBoxGroup.Items.Add(FParamDef.parentParamsDefs.groups.Strings[xCount]);
  end;
  xIndex := 0;
  for xCount := Low(CReportParamTypes) to High(CReportParamTypes) do begin
    ComboBoxType.Items.Add(CReportParamTypes[xCount][0]);
    if Operation = coEdit then begin
      if FParamDef.paramType = CReportParamTypes[xCount][1] then begin
        xIndex := xCount;
      end;
    end;
  end;
  ComboBoxType.ItemIndex := xIndex;
  if Operation = coEdit then begin
    EditName.Text := FParamDef.name;
    EditDesc.Text := FParamDef.desc;
    ComboBoxGroup.Text := FParamDef.group;
  end;
end;

procedure TCParamDefForm.ReadValues;
begin
  inherited ReadValues;
  with FParamDef do begin
    name := EditName.Text;
    desc := EditDesc.Text;
    group := ComboBoxGroup.Text;
    paramType := CReportParamTypes[ComboBoxType.ItemIndex][1];
  end;
end;

end.
