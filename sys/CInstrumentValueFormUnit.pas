unit CInstrumentValueFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, CComponents,
  ComCtrls, ActnList, XPStyleActnCtrls, ActnMan, Contnrs;

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
    procedure UpdateDescription;
  protected
    procedure InitializeForm; override;
  public
    function ExpandTemplate(ATemplate: String): String; override;
  end;

implementation

uses CTemplates, CDescpatternFormUnit, CConsts, CPreferences, CRichtext,
  CInstrumentFrameUnit, CFrameFormUnit, CDatabase, CTools, CDataObjects,
  DateUtils;

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
      end else if xType = CInstrumentTypeFund then begin
        Result := CInstrumentTypeFundDesc;
      end;
      GDataProvider.RollbackTransaction;
    end;
  end;
end;

end.
