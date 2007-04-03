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
    procedure CStaticCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticBaseCurrencydefGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticTargetCurrencydefGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
  protected
    procedure ReadValues; override;
    function GetDataobjectClass: TDataObjectClass; override;
    procedure FillForm; override;
    function CanAccept: Boolean; override;
    function GetUpdateFrameClass: TCBaseFrameClass; override;
    procedure InitializeForm; override;
  end;

implementation

uses CDataObjects, CCurrencyRateFrameUnit, CRichtext, CConsts,
  CFrameFormUnit, CCashpointsFrameUnit, CDataobjectFrameUnit,
  CCurrencydefFrameUnit, CInfoFormUnit;

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
  end else if CStaticTargetCurrencydef.DataId = CStaticTargetCurrencydef.DataId then begin
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
    CDateTime.Value := bindingDate;
    CIntQuantity.Text := IntToStr(quantity);
    CCurrRate.Value := rate;
    CStaticBaseCurrencydef.DataId := idSourceCurrencyDef;
    CStaticBaseCurrencydef.Caption := sourceIso;
    CStaticTargetCurrencydef.DataId := idTargetCurrencyDef;
    CStaticTargetCurrencydef.Caption := targetIso;
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
end;

procedure TCCurrencyRateForm.ReadValues;
begin
  inherited ReadValues;
  with TCurrencyRate(Dataobject) do begin
    idSourceCurrencyDef := CStaticBaseCurrencydef.DataId;
    sourceIso := CStaticBaseCurrencydef.Caption;
    idTargetCurrencyDef := CStaticTargetCurrencydef.DataId;
    targetIso := CStaticTargetCurrencydef.Caption;
    idCashpoint := CStaticCashpoint.DataId;
    quantity := CIntQuantity.Value;
    rate := CCurrRate.Value;
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

end.
 