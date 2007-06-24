unit CLimitFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  CComponents, CDatabase, CBaseFrameUnit;

type
  TCLimitForm = class(TCDataobjectForm)
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    EditName: TEdit;
    RichEditDesc: TCRichEdit;
    GroupBox1: TGroupBox;
    CStaticFilter: TCStatic;
    Label3: TLabel;
    Label7: TLabel;
    ComboBoxStatus: TComboBox;
    Label6: TLabel;
    ComboBoxDays: TComboBox;
    Label4: TLabel;
    CIntEditDays: TCIntEdit;
    Label5: TLabel;
    ComboBoxCondition: TComboBox;
    Label8: TLabel;
    Label10: TLabel;
    CCurrEditBound: TCCurrEdit;
    Label9: TLabel;
    ComboBoxSum: TComboBox;
    Label20: TLabel;
    CStaticCurrency: TCStatic;
    procedure ComboBoxDaysChange(Sender: TObject);
    procedure CStaticFilterGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticCurrencyGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticCurrencyChanged(Sender: TObject);
  protected
    procedure InitializeForm; override;
    function CanAccept: Boolean; override;
    procedure ReadValues; override;
    function GetDataobjectClass: TDataObjectClass; override;
    procedure FillForm; override;
    function GetUpdateFrameClass: TCBaseFrameClass; override;
  end;

implementation

uses CFrameFormUnit, CFilterFrameUnit, CInfoFormUnit, CDataObjects,
  CConsts, Math, CRichtext, CLimitsFrameUnit, CCurrencydefFrameUnit,
  CConfigFormUnit;

{$R *.dfm}

procedure TCLimitForm.ComboBoxDaysChange(Sender: TObject);
begin
  CIntEditDays.Enabled := (ComboBoxDays.ItemIndex = ComboBoxDays.Items.Count - 1);
end;

procedure TCLimitForm.InitializeForm;
begin
  inherited InitializeForm;
  if Operation = coAdd then begin
    CStaticCurrency.DataId := CCurrencyDefGid_PLN;
    CStaticCurrency.Caption := TCurrencyDef(TCurrencyDef.LoadObject(CurrencyDefProxy, CCurrencyDefGid_PLN, False)).GetElementText;
    CCurrEditBound.SetCurrencyDef(CCurrencyDefGid_PLN, GCurrencyCache.GetSymbol(CCurrencyDefGid_PLN));
  end;
  ComboBoxDaysChange(ComboBoxDays);
end;

procedure TCLimitForm.CStaticFilterGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCFilterFrame, ADataGid, AText);
end;

function TCLimitForm.CanAccept: Boolean;
begin
  Result := inherited CanAccept;
  if Trim(EditName.Text) = '' then begin
    Result := False;
    ShowInfo(itError, 'Nazwa limitu nie mo¿e byæ pusta', '');
    EditName.SetFocus;
  end else if CStaticCurrency.DataId = CEmptyDataGid then begin
    Result := False;
    if ShowInfo(itQuestion, 'Nie wybrano waluty operacji. Czy wyœwietliæ listê teraz ?', '') then begin
      CStaticCurrency.DoGetDataId;
    end;
  end;
end;

procedure TCLimitForm.ReadValues;
var xI: Integer;
begin
  inherited ReadValues;
  with TMovementLimit(Dataobject) do begin
    isActive := (ComboBoxStatus.ItemIndex = 0);
    name := EditName.Text;
    description := RichEditDesc.Text;
    idFilter := CStaticFilter.DataId;
    idCurrencyDef := CStaticCurrency.DataId;
    boundaryAmount := CCurrEditBound.Value;
    boundaryDays := CIntEditDays.Value;
    xI := ComboBoxSum.ItemIndex;
    if xI = 0 then begin
      sumType := CLimitSumtypeOut;
    end else if xI = 1 then begin
      sumType := CLimitSumtypeIn;
    end else begin
      sumType := CLimitSumtypeBalance;
    end;
    xI := ComboBoxDays.ItemIndex;
    if xI = 1 then begin
      boundaryType := CLimitBoundaryTypeWeek;
    end else if xI = 2 then begin
      boundaryType := CLimitBoundaryTypeMonth;
    end else if xI = 3 then begin
      boundaryType := CLimitBoundaryTypeQuarter;
    end else if xI = 4 then begin
      boundaryType := CLimitBoundaryTypeHalfyear;
    end else if xI = 5 then begin
      boundaryType := CLimitBoundaryTypeYear;
    end else if xI = 6 then begin
      boundaryType := CLimitBoundaryTypeDays;
    end else begin
      boundaryType := CLimitBoundaryTypeToday;
    end;
    xI := ComboBoxCondition.ItemIndex;
    if xI = 0 then begin
      boundaryCondition := CLimitBoundaryCondGreater;
    end else if xI = 1 then begin
      boundaryCondition := CLimitBoundaryCondGreaterEqual;
    end else if xI = 2 then begin
      boundaryCondition := CLimitBoundaryCondLess;
    end else if xI = 3 then begin
      boundaryCondition := CLimitBoundaryCondLessEqual;
    end else begin
      boundaryCondition := CLimitBoundaryCondEqual;
    end;
  end;
end;

procedure TCLimitForm.FillForm;
var xI: Integer;
begin
  with TMovementLimit(Dataobject) do begin
    ComboBoxStatus.ItemIndex := IfThen(isActive, 0, 1);
    EditName.Text := name;
    SimpleRichText(description, RichEditDesc);
    CCurrEditBound.Value := boundaryAmount;
    CIntEditDays.Text := IntToStr(boundaryDays);
    CStaticCurrency.DataId := idCurrencyDef;
    CStaticCurrency.Caption := TCurrencyDef(TCurrencyDef.LoadObject(CurrencyDefProxy, idCurrencyDef, False)).GetElementText;
    CCurrEditBound.SetCurrencyDef(idCurrencyDef, GCurrencyCache.GetSymbol(idCurrencyDef));
    if idFilter <> CEmptyDataGid then begin
      GDataProvider.BeginTransaction;
      CStaticFilter.DataId := idFilter;
      CStaticFilter.Caption := TMovementFilter(TMovementFilter.LoadObject(MovementFilterProxy, idFilter, False)).name;
      GDataProvider.RollbackTransaction;
    end;
    if sumType = CLimitSumtypeOut then begin
      xI := 0;
    end else if sumType = CLimitSumtypeIn then begin
      xI := 1;
    end else begin
      xI := 2;
    end;
    ComboBoxSum.ItemIndex := xI;
    if boundaryType = CLimitBoundaryTypeWeek then begin
      xI := 1;
    end else if boundaryType = CLimitBoundaryTypeMonth then begin
      xI := 2;
    end else if boundaryType = CLimitBoundaryTypeQuarter then begin
      xI := 3;
    end else if boundaryType = CLimitBoundaryTypeHalfyear then begin
      xI := 4;
    end else if boundaryType = CLimitBoundaryTypeYear then begin
      xI := 5;
    end else if boundaryType = CLimitBoundaryTypeDays then begin
      xI := 6;
    end else begin
      xI := 0;
    end;
    ComboBoxDays.ItemIndex := xI;
    if xI = 0 then begin
      boundaryCondition := CLimitBoundaryCondGreater;
    end else if boundaryCondition = CLimitBoundaryCondGreaterEqual then begin
      xI := 1;
    end else if boundaryCondition = CLimitBoundaryCondLess then begin
      xI := 2;
    end else if boundaryCondition = CLimitBoundaryCondLessEqual then begin
      xI := 3;
    end else begin
      xI := 4;
    end;
    ComboBoxCondition.ItemIndex := xI;
    ComboBoxDaysChange(ComboBoxStatus);
  end;
end;

function TCLimitForm.GetDataobjectClass: TDataObjectClass;
begin
  Result := TMovementLimit;
end;

function TCLimitForm.GetUpdateFrameClass: TCBaseFrameClass;
begin
  Result := TCLimitsFrame;
end;

procedure TCLimitForm.CStaticCurrencyGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCCurrencydefFrame, ADataGid, AText);
end;

procedure TCLimitForm.CStaticCurrencyChanged(Sender: TObject);
begin
  CCurrEditBound.SetCurrencyDef(CStaticCurrency.DataId, GCurrencyCache.GetSymbol(CStaticCurrency.DataId));
end;

end.