unit CExtractionItemFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, CDataObjects, CDatabase,
  ComCtrls, CComponents, ActnList, XPStyleActnCtrls, ActnMan, Contnrs;

type
  TExtractionListElement = class(TCListDataElement)
  private
    FIsNew: Boolean;
    Fid: TDataGid;
    FmovementType: TBaseEnumeration;
    Fdescription: TBaseDescription;
    Fcash: Currency;
    FidAccount: TDataGid;
    FregTime: TDateTime;
    FaccountingDate: TDateTime;
    FidCurrencyDef: TDataGid;
  public
    constructor Create;
  published
    property id: TDataGid read Fid write Fid;
    property movementType: TBaseEnumeration read FmovementType write FmovementType;
    property description: TBaseDescription read Fdescription write Fdescription;
    property cash: Currency read Fcash write Fcash;
    property idCurrencyDef: TDataGid read FidCurrencyDef write FidCurrencyDef;
    property idAccount: TDataGid read FidAccount write FidAccount;
    property isNew: Boolean read FIsNew write FIsNew;
    property regTime: TDateTime read FregTime write FregTime;
    property accountingDate: TDateTime read FaccountingDate write FaccountingDate;
  end;

  TCExtractionItemForm = class(TCConfigForm)
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label5: TLabel;
    ComboBoxType: TComboBox;
    CDateTime: TCDateTime;
    GroupBox2: TGroupBox;
    CButton1: TCButton;
    CButton2: TCButton;
    RichEditDesc: TCRichedit;
    ComboBoxTemplate: TComboBox;
    ActionManager: TActionManager;
    ActionAdd: TAction;
    ActionTemplate: TAction;
    Label20: TLabel;
    CStaticMovementCurrency: TCStatic;
    Label1: TLabel;
    CCurrEditMovement: TCCurrEdit;
    Label2: TLabel;
    CDateTimeAcc: TCDateTime;
    procedure CDateTimeChanged(Sender: TObject);
    procedure CStaticMovementCurrencyChanged(Sender: TObject);
    procedure ComboBoxTypeChange(Sender: TObject);
    procedure CStaticMovementCurrencyGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure ActionAddExecute(Sender: TObject);
    procedure ActionTemplateExecute(Sender: TObject);
    procedure CDateTimeAccChanged(Sender: TObject);
  private
    Felement: TExtractionListElement;
    procedure UpdateDescription;
  protected
    procedure FillForm; override;
    procedure ReadValues; override;
  public
    constructor CreateFormElement(AOwner: TComponent; AElement: TExtractionListElement);
    function ExpandTemplate(ATemplate: String): String; override;
  end;

implementation

uses CCurrencydefFrameUnit, CFrameFormUnit, Math, CRichtext, StrUtils,
  CConsts, CTemplates, CDescpatternFormUnit, CPreferences, CTools;

{$R *.dfm}

constructor TExtractionListElement.Create;
var xGuid: TGUID;
begin
  inherited Create(False, Nil, Nil, False, False);
  FIsNew := False;
  CreateGUID(xGuid);
  Fid := GUIDToString(xGuid);
end;

constructor TCExtractionItemForm.CreateFormElement(AOwner: TComponent; AElement: TExtractionListElement);
begin
  inherited Create(AOwner);
  Felement := AElement;
end;

procedure TCExtractionItemForm.CDateTimeChanged(Sender: TObject);
begin
  UpdateDescription;
end;

procedure TCExtractionItemForm.UpdateDescription;
var xDesc: String;
begin
  if ComboBoxTemplate.ItemIndex = 1 then begin
    xDesc := GDescPatterns.GetPattern(CDescPatternsKeys[6][0], '');
    if xDesc <> '' then begin
      xDesc := GBaseTemlatesList.ExpandTemplates(xDesc, Self);
      xDesc := GExtractionItemTemplatesList.ExpandTemplates(xDesc, Self);
      SimpleRichText(xDesc, RichEditDesc);
    end;
  end;
end;

procedure TCExtractionItemForm.FillForm;
begin
  inherited FillForm;
  ComboBoxTemplate.ItemIndex := IfThen(Operation = coEdit, 0, 1);
  ComboBoxType.ItemIndex := IfThen(Felement.movementType = COutMovement, 0, 1);
  CCurrEditMovement.SetCurrencyDef(Felement.idCurrencyDef, GCurrencyCache.GetSymbol(Felement.idCurrencyDef));
  CStaticMovementCurrency.DataId := Felement.idCurrencyDef;
  CStaticMovementCurrency.Caption := GCurrencyCache.GetIso(Felement.idCurrencyDef);
  CDateTime.Value := Felement.regTime;
  CDateTimeAcc.Value := Felement.accountingDate;
  if Operation = coEdit then begin
    CCurrEditMovement.Value := Felement.cash;
    SimpleRichText(Felement.description, RichEditDesc);
  end else begin
    UpdateDescription;
  end;
end;

procedure TCExtractionItemForm.ReadValues;
begin
  inherited ReadValues;
  Felement.description := RichEditDesc.Text;
  Felement.cash := CCurrEditMovement.Value;
  Felement.idCurrencyDef := CStaticMovementCurrency.DataId;
  Felement.regTime := CDateTime.Value;
  Felement.accountingDate := CDateTimeAcc.Value;
  Felement.movementType := IfThen(ComboBoxType.ItemIndex = 0, COutMovement, CInMovement);
end;

procedure TCExtractionItemForm.CStaticMovementCurrencyChanged(Sender: TObject);
begin
  CCurrEditMovement.SetCurrencyDef(CStaticMovementCurrency.DataId, GCurrencyCache.GetSymbol(CStaticMovementCurrency.DataId));
  UpdateDescription;
end;

procedure TCExtractionItemForm.ComboBoxTypeChange(Sender: TObject);
begin
  UpdateDescription;
end;

procedure TCExtractionItemForm.CStaticMovementCurrencyGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCCurrencydefFrame, ADataGid, AText);
end;

procedure TCExtractionItemForm.ActionAddExecute(Sender: TObject);
var xData: TObjectList;
begin
  xData := TObjectList.Create(False);
  xData.Add(GBaseTemlatesList);
  xData.Add(GExtractionItemTemplatesList);
  EditAddTemplate(xData, Self, RichEditDesc, True);
  xData.Free;
end;

procedure TCExtractionItemForm.ActionTemplateExecute(Sender: TObject);
var xPattern: String;
begin
  if EditDescPattern(CDescPatternsKeys[6][IfThen(Felement.movementType = COutMovement, 1, 0)], xPattern) then begin
    UpdateDescription;
  end;
end;

function TCExtractionItemForm.ExpandTemplate(ATemplate: String): String;
begin
  Result := inherited ExpandTemplate(ATemplate);
  if ATemplate = '@dataoperacji@' then begin
    Result := GetFormattedDate(CDateTime.Value, 'yyyy-MM-dd');
  end else if ATemplate = '@dataksiêgowania@' then begin
    Result := GetFormattedDate(CDateTimeAcc.Value, 'yyyy-MM-dd');
  end else if ATemplate = '@rodzaj@' then begin
    Result := ComboBoxType.Text;
  end else if ATemplate = '@konto@' then begin
    Result := '<konto>';
    if Felement.idAccount <> CEmptyDataGid then begin
      GDataProvider.BeginTransaction;
      Result := TAccount(TAccount.LoadObject(AccountProxy, Felement.idAccount, False)).name;
      GDataProvider.RollbackTransaction;
    end;
  end else if ATemplate = '@isowaluty@' then begin
    Result := '<iso waluty>';
    if CStaticMovementCurrency.DataId <> CEmptyDataGid then begin
      Result := GCurrencyCache.GetIso(CStaticMovementCurrency.DataId);
    end;
  end else if ATemplate = '@symbolwaluty@' then begin
    Result := '<symbol waluty>';
    if CStaticMovementCurrency.DataId <> CEmptyDataGid then begin
      Result := GCurrencyCache.GetSymbol(CStaticMovementCurrency.DataId);
    end;
  end;
end;

procedure TCExtractionItemForm.CDateTimeAccChanged(Sender: TObject);
begin
  UpdateDescription;
end;

end.
