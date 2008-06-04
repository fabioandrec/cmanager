unit CAccountFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, ImgList,
  ComCtrls, CComponents, CDatabase, CBaseFrameUnit, ActnList,
  XPStyleActnCtrls, ActnMan, CImageListsUnit;

type
  TCAccountForm = class(TCDataobjectForm)
    GroupBoxAccountType: TGroupBox;
    ComboBoxType: TComboBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    EditName: TEdit;
    RichEditDesc: TCRichEdit;
    CCurrEditCash: TCCurrEdit;
    LabelCash: TLabel;
    GroupBoxBank: TGroupBox;
    Label3: TLabel;
    EditNumber: TEdit;
    CStaticBank: TCStatic;
    Label4: TLabel;
    Label5: TLabel;
    CStaticCurrency: TCStatic;
    Label6: TLabel;
    ActionManager: TActionManager;
    Action1: TAction;
    CButton1: TCButton;
    procedure FormCreate(Sender: TObject);
    procedure CStaticBankGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure ComboBoxTypeChange(Sender: TObject);
    procedure CStaticCurrencyGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticCurrencyChanged(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
  private
    FmovementCount: Integer;
    Frules: TStringList;
  protected
    procedure ReadValues; override;
    function GetDataobjectClass: TDataObjectClass; override;
    procedure FillForm; override;
    function CanAccept: Boolean; override;
    function GetUpdateFrameClass: TCBaseFrameClass; override;
    procedure InitializeForm; override;
    procedure AfterCommitData; override;
  public
    destructor Destroy; override;
  end;

implementation

uses CDataObjects, CInfoFormUnit, CConfigFormUnit, CFrameFormUnit,
  CCashpointsFrameUnit, CConsts, CAccountsFrameUnit, CRichtext,
  CCurrencydefFormUnit, CCurrencydefFrameUnit, CAccountCurrencyFormUnit,
  CTools, StrUtils;

{$R *.dfm}

function TCAccountForm.CanAccept: Boolean;
begin
  Result := inherited CanAccept;
  if Trim(EditName.Text) = '' then begin
    Result := False;
    ShowInfo(itError, 'Nazwa konta nie mo¿e byæ pusta', '');
    EditName.SetFocus;
  end else if (ComboBoxType.ItemIndex = 1) and (CStaticBank.DataId = CEmptyDataGid) then begin
    Result := False;
    if ShowInfo(itQuestion, 'Nie wybrano banku prowadz¹cego konto. Czy wyœwietliæ listê teraz ?', '') then begin
      CStaticBank.DoGetDataId;
    end;
  end else if (CStaticCurrency.DataId = CEmptyDataGid) then begin
    Result := False;
    if ShowInfo(itQuestion, 'Nie wybrano waluty konta. Czy wyœwietliæ listê teraz ?', '') then begin
      CStaticCurrency.DoGetDataId;
    end;
  end;
end;

procedure TCAccountForm.FillForm;
var xCashPoint: TCashPoint;
    xRules: TDataObjectList;
    xCount: Integer;
    xRule: TAccountCurrencyRule;
begin
  with TAccount(Dataobject) do begin
    EditName.Text := name;
    SimpleRichText(description, RichEditDesc);
    if accountType = CBankAccount then begin
      ComboBoxType.ItemIndex := 1;
    end else if accountType = CInvestmentAccount then begin
      ComboBoxType.ItemIndex := 2;
    end else begin
      ComboBoxType.ItemIndex := 0;
    end;
    CStaticCurrency.DataId := idCurrencyDef;
    CStaticCurrency.Caption := TCurrencyDef(TCurrencyDef.LoadObject(CurrencyDefProxy, idCurrencyDef, False)).GetElementText;
    CCurrEditCash.SetCurrencyDef(idCurrencyDef, GCurrencyCache.GetSymbol(idCurrencyDef));
    FmovementCount := GetMovementCount(id);
    if (Operation = coAdd) or (FmovementCount = 0) then begin
      LabelCash.Caption := 'Œrodki pocz¹tkowe';
      CCurrEditCash.Value := initialBalance;
      ComboBoxType.Enabled := True;
      CStaticCurrency.Enabled := True;
    end else begin
      LabelCash.Caption := 'Dostêpne œrodki';
      CCurrEditCash.Enabled := False;
      CCurrEditCash.Value := cash;
      ComboBoxType.Enabled := False;
      CStaticCurrency.Enabled := False;
    end;
    if idCashPoint <> CEmptyDataGid then begin
      CStaticBank.DataId := idCashPoint;
      xCashPoint := TCashPoint(TCashPoint.LoadObject(CashPointProxy, idCashPoint, True));
      CStaticBank.Caption := xCashPoint.name;
      xCashPoint.Free;
    end;
    EditNumber.Text := accountNumber;
    xRules := TAccountCurrencyRule.FindRules(id);
    for xCount := 0 to xRules.Count - 1 do begin
      xRule := TAccountCurrencyRule(xRules.Items[xCount]);
      Frules.Values[xRule.movementType] := xRule.rateType + IfThen(xRule.useOldRates, 'T', 'N') + xRule.idCashPoint;
    end;
    xRules.Free;
    ComboBoxTypeChange(Nil);
  end;
end;

procedure TCAccountForm.FormCreate(Sender: TObject);
begin
  inherited;
  ComboBoxType.ItemIndex := 0;
  ComboBoxTypeChange(Nil);
end;

function TCAccountForm.GetDataobjectClass: TDataObjectClass;
begin
  Result := TAccount;
end;

procedure TCAccountForm.ReadValues;
begin
  inherited ReadValues;
  with TAccount(Dataobject) do begin
    name := EditName.Text;
    description := RichEditDesc.Text;
    if ComboBoxType.ItemIndex = 0 then begin
      accountType := CCashAccount;
    end else if ComboBoxType.ItemIndex = 1 then begin
      accountType := CBankAccount;
    end else begin
      accountType := CInvestmentAccount;
    end;
    if (Operation = coAdd) or (FmovementCount = 0) then begin
      cash := CCurrEditCash.Value;
      initialBalance := CCurrEditCash.Value;
    end;
    idCashPoint := CStaticBank.DataId;
    idCurrencyDef := CStaticCurrency.DataId;
    accountNumber := EditNumber.Text;
  end;
end;

procedure TCAccountForm.CStaticBankGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCCashpointsFrame, ADataGid, AText);
end;

function TCAccountForm.GetUpdateFrameClass: TCBaseFrameClass;
begin
  Result := TCAccountsFrame;
end;

procedure TCAccountForm.ComboBoxTypeChange(Sender: TObject);
begin
  Label3.Enabled := ComboBoxType.ItemIndex <> 0;
  EditNumber.Enabled := ComboBoxType.ItemIndex <> 0;
  Label4.Enabled := ComboBoxType.ItemIndex <> 0;
  CStaticBank.Enabled := ComboBoxType.ItemIndex <> 0;
end;

procedure TCAccountForm.InitializeForm;
begin
  inherited InitializeForm;
  Frules := TStringList.Create;
  if Operation = coAdd then begin
    CStaticCurrency.DataId := GDefaultCurrencyId;
    CStaticCurrency.Caption := TCurrencyDef(TCurrencyDef.LoadObject(CurrencyDefProxy, CStaticCurrency.DataId, False)).GetElementText;
    CCurrEditCash.SetCurrencyDef(GDefaultCurrencyId, GCurrencyCache.GetSymbol(GDefaultCurrencyId));
  end;
end;

procedure TCAccountForm.CStaticCurrencyGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCCurrencydefFrame, ADataGid, AText);
end;

procedure TCAccountForm.CStaticCurrencyChanged(Sender: TObject);
begin
  CCurrEditCash.SetCurrencyDef(CStaticCurrency.DataId, GCurrencyCache.GetSymbol(CStaticCurrency.DataId));
end;

procedure TCAccountForm.Action1Execute(Sender: TObject);
begin
  ShowRules(Frules);
end;

procedure TCAccountForm.AfterCommitData;
var xCount: Integer;
    xRule: TAccountCurrencyRule;
begin
  GDataProvider.BeginTransaction;
  TAccountCurrencyRule.DeleteRules(Dataobject.id);
  for xCount := 0 to Frules.Count - 1 do begin
    xRule := TAccountCurrencyRule.CreateObject(AccountCurrencyRuleProxy, False);
    xRule.idAccount := Dataobject.id;
    xRule.movementType := Frules.Names[xCount];
    xRule.rateType := Copy(Frules.ValueFromIndex[xCount], 1, 1);
    xRule.useOldRates := Copy(Frules.ValueFromIndex[xCount], 2, 1) = 'T';
    xRule.idCashPoint := Copy(Frules.ValueFromIndex[xCount], 3, MaxInt);
  end;
  GDataProvider.CommitTransaction;
  inherited AfterCommitData;
end;

destructor TCAccountForm.Destroy;
begin
  Frules.Free;
  inherited Destroy;
end;

end.