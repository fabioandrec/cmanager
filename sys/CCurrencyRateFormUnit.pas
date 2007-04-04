unit CCurrencyRateFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, CComponents,
  ActnList, XPStyleActnCtrls, ActnMan, ComCtrls, CDatabase, CBaseFrameUnit;

type
  TCCurrencyRateForm = class(TCDataobjectForm)
    GroupBox4: TGroupBox;
    Label15: TLabel;
    CDateTime: TCDateTime;
    Label2: TLabel;
    CStaticCashpoint: TCStatic;
    GroupBox1: TGroupBox;
    CIntQuantity: TCIntEdit;
    CStaticBaseCurrencydef: TCStatic;
    CStaticTargetCurrencydef: TCStatic;
    Label1: TLabel;
    CCurrRate: TCCurrEdit;
    ActionManager: TActionManager;
    ActionAdd: TAction;
    ActionTemplate: TAction;
    GroupBox2: TGroupBox;
    CButton1: TCButton;
    CButton2: TCButton;
    RichEditDesc: TRichEdit;
    ComboBoxTemplate: TComboBox;
    procedure CStaticCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticBaseCurrencydefGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticTargetCurrencydefGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure ActionAddExecute(Sender: TObject);
    procedure ActionTemplateExecute(Sender: TObject);
    procedure CDateTimeChanged(Sender: TObject);
    procedure CStaticCashpointChanged(Sender: TObject);
    procedure CIntQuantityChange(Sender: TObject);
    procedure CStaticBaseCurrencydefChanged(Sender: TObject);
    procedure CCurrRateChange(Sender: TObject);
    procedure CStaticTargetCurrencydefChanged(Sender: TObject);
  protected
    procedure ReadValues; override;
    function GetDataobjectClass: TDataObjectClass; override;
    procedure FillForm; override;
    function CanAccept: Boolean; override;
    function GetUpdateFrameClass: TCBaseFrameClass; override;
    procedure InitializeForm; override;
    procedure UpdateDescription;
  public
    function ExpandTemplate(ATemplate: String): String; override;
  end;

implementation

uses CDataObjects, CCurrencyRateFrameUnit, CRichtext, CConsts,
  CFrameFormUnit, CCashpointsFrameUnit, CDataobjectFrameUnit,
  CCurrencydefFrameUnit, CInfoFormUnit, CTemplates, CPreferences, Math,
  CConfigFormUnit, Contnrs, CDescpatternFormUnit;

{$R *.dfm}

function TCCurrencyRateForm.CanAccept: Boolean;
begin
  Result := True;
  if CIntQuantity.Value <= 0 then begin
    ShowInfo(itError, 'Iloœæ waluty bazowej musi byæ wiêksza od zera', '');
    CIntQuantity.SetFocus;
    Result := False;
  end else if CStaticBaseCurrencydef.DataId = CEmptyDataGid then begin
    Result := False;
    if ShowInfo(itQuestion, 'Nie wybrano waluty bazowej. Czy wyœwietliæ listê teraz ?', '') then begin
      CStaticBaseCurrencydef.DoGetDataId;
    end;
  end else if CStaticTargetCurrencydef.DataId = CEmptyDataGid then begin
    Result := False;
    if ShowInfo(itQuestion, 'Nie wybrano waluty docelowej. Czy wyœwietliæ listê teraz ?', '') then begin
      CStaticTargetCurrencydef.DoGetDataId;
    end;
  end else if CStaticTargetCurrencydef.DataId = CStaticBaseCurrencydef.DataId then begin
    ShowInfo(itError, 'Waluty bazowa i docelowa nie mog¹ byæ takie same', '');
    CStaticTargetCurrencydef.SetFocus;
    Result := False;
  end else if CCurrRate.Value = 0 then begin
    ShowInfo(itError, 'Wartoœæ kursu musi byæ wiêksza od zera', '');
    CCurrRate.SetFocus;
    Result := False;
  end;
end;

procedure TCCurrencyRateForm.FillForm;
begin
  with TCurrencyRate(Dataobject) do begin
    ComboBoxTemplate.ItemIndex := IfThen(Operation = coEdit, 0, 1);
    CDateTime.Value := bindingDate;
    CIntQuantity.Text := IntToStr(quantity);
    CCurrRate.Value := rate;
    SimpleRichText(description, RichEditDesc);
    CStaticBaseCurrencydef.DataId := idSourceCurrencyDef;
    CStaticBaseCurrencydef.Caption := TCurrencyDef(TCurrencyDef.LoadObject(CurrencyDefProxy, idSourceCurrencyDef, False)).iso;
    CStaticTargetCurrencydef.DataId := idTargetCurrencyDef;
    CStaticTargetCurrencydef.Caption := TCurrencyDef(TCurrencyDef.LoadObject(CurrencyDefProxy, idTargetCurrencyDef, False)).iso;
    if idCashpoint <> CEmptyDataGid then begin
      CStaticCashpoint.DataId := idCashpoint;
      CStaticCashpoint.Caption := TCashPoint(TCashPoint.LoadObject(CashPointProxy, idCashpoint, False)).name;
    end;
  end;
end;

function TCCurrencyRateForm.GetDataobjectClass: TDataObjectClass;
begin
  Result := TCurrencyRate;
end;

function TCCurrencyRateForm.GetUpdateFrameClass: TCBaseFrameClass;
begin
  Result := TCCurrencyRateFrame;
end;

procedure TCCurrencyRateForm.InitializeForm;
begin
  inherited InitializeForm;
  CDateTime.Value := GWorkDate;
  CCurrRate.CurrencyStr := '';
  UpdateDescription;  
end;

procedure TCCurrencyRateForm.ReadValues;
begin
  inherited ReadValues;
  with TCurrencyRate(Dataobject) do begin
    idSourceCurrencyDef := CStaticBaseCurrencydef.DataId;
    idTargetCurrencyDef := CStaticTargetCurrencydef.DataId;
    idCashpoint := CStaticCashpoint.DataId;
    quantity := CIntQuantity.Value;
    rate := CCurrRate.Value;
    description := RichEditDesc.Text;
    bindingDate := CDateTime.Value;
  end;
end;

procedure TCCurrencyRateForm.CStaticCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCCashpointsFrame, ADataGid, AText, TCDataobjectFrameData.CreateWithFilter(CCashpointTypeOther));
end;

procedure TCCurrencyRateForm.CStaticBaseCurrencydefGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCCurrencydefFrame, ADataGid, AText);
end;

procedure TCCurrencyRateForm.CStaticTargetCurrencydefGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCCurrencydefFrame, ADataGid, AText);
end;

procedure TCCurrencyRateForm.UpdateDescription;
var xDesc: String;
begin
  if not (csLoading in  ComponentState) then begin
    if ComboBoxTemplate.ItemIndex = 1 then begin
      xDesc := GDescPatterns.GetPattern(CDescPatternsKeys[4][0], '');
      if xDesc <> '' then begin
        xDesc := GBaseTemlatesList.ExpandTemplates(xDesc, Self);
        xDesc := GCurrencydefTemplatesList.ExpandTemplates(xDesc, Self);
        SimpleRichText(xDesc, RichEditDesc);
      end;
    end;
  end;
end;

procedure TCCurrencyRateForm.ActionAddExecute(Sender: TObject);
var xData: TObjectList;
begin
  xData := TObjectList.Create(False);
  xData.Add(GBaseTemlatesList);
  xData.Add(GCurrencydefTemplatesList);
  EditAddTemplate(xData, Self, RichEditDesc, True);
  xData.Free;
end;

procedure TCCurrencyRateForm.ActionTemplateExecute(Sender: TObject);
var xPattern: String;
begin
  if EditDescPattern(CDescPatternsKeys[4][0], xPattern) then begin
    UpdateDescription;
  end;
end;

procedure TCCurrencyRateForm.CDateTimeChanged(Sender: TObject);
begin
  UpdateDescription;
end;

procedure TCCurrencyRateForm.CStaticCashpointChanged(Sender: TObject);
begin
  UpdateDescription;
end;

procedure TCCurrencyRateForm.CIntQuantityChange(Sender: TObject);
begin
  UpdateDescription;
end;

procedure TCCurrencyRateForm.CStaticBaseCurrencydefChanged(Sender: TObject);
begin
  UpdateDescription;
end;

procedure TCCurrencyRateForm.CCurrRateChange(Sender: TObject);
begin
  UpdateDescription;
end;

procedure TCCurrencyRateForm.CStaticTargetCurrencydefChanged(Sender: TObject);
begin
  UpdateDescription;
end;

function TCCurrencyRateForm.ExpandTemplate(ATemplate: String): String;
begin
  Result := inherited ExpandTemplate(ATemplate);
  if ATemplate = '@datakursu@' then begin
    Result := GetFormattedDate(CDateTime.Value, 'yyyy-MM-dd');
  end else if ATemplate = '@isobazowej@' then begin
    Result := '<symbol ISO waluty bazowej>';
    if CStaticBaseCurrencydef.DataId <> CEmptyDataGid then begin
      Result := CStaticBaseCurrencydef.Caption;
    end;
  end else if ATemplate = '@isodocelowej@' then begin
    Result := '<symbol ISO waluty docelowej>';
    if CStaticTargetCurrencydef.DataId <> CEmptyDataGid then begin
      Result := CStaticTargetCurrencydef.Caption;
    end;
  end else if ATemplate = '@symbolbazowej@' then begin
    Result := '<symbol waluty bazowej>';
    if CStaticBaseCurrencydef.DataId <> CEmptyDataGid then begin
      Result := TCurrencyDef(TCurrencyDef.LoadObject(CurrencyDefProxy, CStaticBaseCurrencydef.DataId, False)).symbol;
    end;
  end else if ATemplate = '@symboldocelowej@' then begin
    Result := '<symbol waluty docelowejj>';
    if CStaticTargetCurrencydef.DataId <> CEmptyDataGid then begin
      Result := TCurrencyDef(TCurrencyDef.LoadObject(CurrencyDefProxy, CStaticTargetCurrencydef.DataId, False)).symbol;
    end;
  end else if ATemplate = '@kontrahent@' then begin
    Result := '<kontrahent>';
    if CStaticCashpoint.DataId <> CEmptyDataGid then begin
      Result := CStaticCashpoint.Caption;
    end;
  end else if ATemplate = '@ilosc@' then begin
    Result := '<iloœæ waluty bazowej>';
    if CIntQuantity.Value <> 0 then begin
      Result := CIntQuantity.Text;
    end;
  end else if ATemplate = '@kurs@' then begin
    Result := '<kurs waluty>';
    if CCurrRate.Value <> 0 then begin
      Result := CCurrRate.Text;
    end;
  end;
end;

end.
