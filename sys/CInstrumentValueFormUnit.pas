unit CInstrumentValueFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, CComponents,
  ComCtrls, ActnList, XPStyleActnCtrls, ActnMan, Contnrs, CDataObjects,
  CBaseFrameUnit, CDatabase;

type
  TCInstrumentValueForm = class(TCDataobjectForm)
    GroupBox1: TGroupBox;
    Label3: TLabel;
    CDateTime: TCDateTime;
    Label1: TLabel;
    CStaticInstrument: TCStatic;
    Label15: TLabel;
    CCurrEditValue: TCCurrEdit;
    ActionManager: TActionManager;
    ActionAdd: TAction;
    ActionTemplate: TAction;
    GroupBox2: TGroupBox;
    CButton1: TCButton;
    CButton2: TCButton;
    RichEditDesc: TCRichedit;
    ComboBoxTemplate: TComboBox;
    procedure ActionAddExecute(Sender: TObject);
    procedure ActionTemplateExecute(Sender: TObject);
    procedure CStaticInstrumentGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticInstrumentChanged(Sender: TObject);
    procedure CDateTimeChanged(Sender: TObject);
  private
    FValueToReplaceId: TDataGid;
    procedure UpdateDescription;
  protected
    procedure ReadValues; override;
    function GetDataobjectClass: TDataObjectClass; override;
    procedure FillForm; override;
    function CanAccept: Boolean; override;
    function GetUpdateFrameClass: TCBaseFrameClass; override;
    procedure InitializeForm; override;
    procedure AfterCommitData; override;
  public
    function ExpandTemplate(ATemplate: String): String; override;
  end;

implementation

uses CTemplates, CDescpatternFormUnit, CConsts, CPreferences, CRichtext,
  CInstrumentFrameUnit, CFrameFormUnit, CTools, DateUtils,
  CInstrumentValueFrameUnit, CInstrumentFormUnit, CInfoFormUnit, Math,
  CConfigFormUnit;

{$R *.dfm}

procedure TCInstrumentValueForm.ActionAddExecute(Sender: TObject);
var xData: TObjectList;
begin
  xData := TObjectList.Create(False);
  xData.Add(GBaseTemlatesList);
  xData.Add(GInstrumentValueTemplatesList);
  EditAddTemplate(xData, Self, RichEditDesc, True);
  xData.Free;
end;

procedure TCInstrumentValueForm.ActionTemplateExecute(Sender: TObject);
var xPattern: String;
begin
  if EditDescPattern(CDescPatternsKeys[7][0], xPattern) then begin
    UpdateDescription;
  end;
end;

procedure TCInstrumentValueForm.InitializeForm;
begin
  inherited InitializeForm;
  FValueToReplaceId := CEmptyDataGid;
  CDateTime.Value := GWorkDate + TimeOf(Now);
  CCurrEditValue.SetCurrencyDef(CEmptyDataGid, '');
  UpdateDescription;
end;

procedure TCInstrumentValueForm.UpdateDescription;
var xDesc: String;
begin
  if ComboBoxTemplate.ItemIndex = 1 then begin
    xDesc := GDescPatterns.GetPattern(CDescPatternsKeys[7][0], '');
    if xDesc <> '' then begin
      xDesc := GBaseTemlatesList.ExpandTemplates(xDesc, Self);
      xDesc := GInstrumentValueTemplatesList.ExpandTemplates(xDesc, Self);
      SimpleRichText(xDesc, RichEditDesc);
    end;
  end;
end;

procedure TCInstrumentValueForm.CStaticInstrumentGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCInstrumentFrame, ADataGid, AText);
end;

procedure TCInstrumentValueForm.CStaticInstrumentChanged(Sender: TObject);
var xIdCur: TDataGid;
begin
  if CStaticInstrument.DataId <> CEmptyDataGid then begin
    GDataProvider.BeginTransaction;
    xIdCur := TInstrument(TInstrument.LoadObject(InstrumentProxy, CStaticInstrument.DataId, False)).idCurrencyDef;
    GDataProvider.RollbackTransaction;
    CCurrEditValue.SetCurrencyDef(xIdCur, GCurrencyCache.GetSymbol(xIdCur));
  end else begin
    CCurrEditValue.SetCurrencyDef(CEmptyDataGid, '');
  end;
  UpdateDescription;
end;

procedure TCInstrumentValueForm.CDateTimeChanged(Sender: TObject);
begin
  UpdateDescription;
end;

function TCInstrumentValueForm.ExpandTemplate(ATemplate: String): String;
var xType: TBaseEnumeration;
begin
  Result := inherited ExpandTemplate(ATemplate);
  if ATemplate = '@datanotowania@' then begin
    Result := GetFormattedDate(CDateTime.Value, 'yyyy-MM-dd');
  end else if ATemplate = '@dataczasnotowania@' then begin
    Result := GetFormattedDate(Now, 'yyyy-MM-dd') + ' ' + GetFormattedTime(Now, 'HH:mm');
  end else if ATemplate = '@instrument@' then begin
    Result := '<instrument inwestycyjny>';
    if CStaticInstrument.DataId <> CEmptyDataGid then begin
      Result := CStaticInstrument.Caption;
    end;
  end else if ATemplate = '@symbol@' then begin
    Result := '<symbol instrumentu>';
    if CStaticInstrument.DataId <> CEmptyDataGid then begin
      GDataProvider.BeginTransaction;
      Result := TInstrument(TInstrument.LoadObject(InstrumentProxy, CStaticInstrument.DataId, False)).symbol;
      GDataProvider.RollbackTransaction;
    end;
  end else if ATemplate = '@rodzaj@' then begin
    Result := '<rodzaj instrumentu inwestycyjnego>';
    if CStaticInstrument.DataId <> CEmptyDataGid then begin
      GDataProvider.BeginTransaction;
      xType := TInstrument(TInstrument.LoadObject(InstrumentProxy, CStaticInstrument.DataId, False)).instrumentType;
      if xType = CInstrumentTypeIndex then begin
        Result := CInstrumentTypeIndexDesc;
      end else if xType = CInstrumentTypeStock then begin
        Result := CInstrumentTypeStockDesc;
      end else if xType = CInstrumentTypeBond then begin
        Result := CInstrumentTypeBondDesc;
      end else if xType = CInstrumentTypeFundinv then begin
        Result := CInstrumentTypeFundinvDesc;
      end else if xType = CInstrumentTypeFundret then begin
        Result := CInstrumentTypeFundretDesc;
      end else if xType = CInstrumentTypeUndefined then begin
        Result := CInstrumentTypeUndefinedDesc;
      end;
      GDataProvider.RollbackTransaction;
    end;
  end;
end;

function TCInstrumentValueForm.CanAccept: Boolean;
var xValue: TInstrumentValue;
    xText: String;
begin
  Result := inherited CanAccept;
  if CStaticInstrument.DataId = CEmptyDataGid then begin
    Result := False;
    if ShowInfo(itQuestion, 'Nie wybrano instrumentu inswestycyjnego. Czy wyœwietliæ listê teraz ?', '') then begin
      CStaticInstrument.DoGetDataId;
    end;
  end else begin
    GDataProvider.BeginTransaction;
    xValue := TInstrumentValue.FindValue(CStaticInstrument.DataId, CDateTime.Value);
    if xValue <> Nil then begin
      xText := 'Istnieje ju¿ notowanie instrumentu "' + CStaticInstrument.Caption + '" z ' + Date2StrDate(CDateTime.Value, True) + '\n' +
               'Czy chcesz je zast¹piæ ?';
      Result := ShowInfo(itQuestion, xText, '');
      if Result then begin
        FValueToReplaceId := xValue.id;
      end;
    end;
    GDataProvider.RollbackTransaction;
  end;
end;

procedure TCInstrumentValueForm.FillForm;
begin
  with TInstrumentValue(Dataobject) do begin
    ComboBoxTemplate.ItemIndex := IfThen(Operation = coEdit, 0, 1);
    CDateTime.Value := regDateTime;
    CCurrEditValue.Value := valueOf;
    CStaticInstrument.DataId := idInstrument;
    CStaticInstrument.Caption := TInstrument(TInstrument.LoadObject(InstrumentProxy, idInstrument, False)).GetElementText;
    if idCurrencyDef <> CEmptyDataGid then begin
      CCurrEditValue.SetCurrencyDef(idCurrencyDef, GCurrencyCache.GetSymbol(idCurrencyDef));
    end;
    SimpleRichText(description, RichEditDesc);
  end;
end;

function TCInstrumentValueForm.GetDataobjectClass: TDataObjectClass;
begin
  Result := TInstrumentValue;
end;

function TCInstrumentValueForm.GetUpdateFrameClass: TCBaseFrameClass;
begin
  Result := TCInstrumentValueFrame;
end;

procedure TCInstrumentValueForm.ReadValues;
begin
  inherited ReadValues;
  with TInstrumentValue(Dataobject) do begin
    description := RichEditDesc.Text;
    idInstrument := CStaticInstrument.DataId;
    regDateTime := CDateTime.Value;
    valueOf := CCurrEditValue.Value;
  end;
end;

procedure TCInstrumentValueForm.AfterCommitData;
var xValue: TInstrumentValue;
begin
  if FValueToReplaceId <> CEmptyDataGid then begin
    GDataProvider.BeginTransaction;
    xValue := TInstrumentValue(TInstrumentValue.LoadObject(InstrumentValueProxy, FValueToReplaceId, False));
    xValue.DeleteObject;
    GDataProvider.CommitTransaction;
    SendMessageToFrames(TCInstrumentValueFrame, WM_DATAOBJECTDELETED, Integer(@FValueToReplaceId), 0);
  end;
end;

end.
