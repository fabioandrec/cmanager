unit CPlannedFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  CComponents, CDatabase, ActnList, CScheduleFormUnit, CBaseFrameUnit;

type
  TCPlannedForm = class(TCDataobjectForm)
    GroupBox2: TGroupBox;
    RichEditDesc: TRichEdit;
    GroupBox3: TGroupBox;
    GroupBox1: TGroupBox;
    Label5: TLabel;
    ComboBoxType: TComboBox;
    Label4: TLabel;
    CStaticAccount: TCStatic;
    Label2: TLabel;
    CStaticCategory: TCStatic;
    Label6: TLabel;
    CStaticCashpoint: TCStatic;
    Label9: TLabel;
    CCurrEdit: TCCurrEdit;
    Label7: TLabel;
    ComboBoxStatus: TComboBox;
    Label1: TLabel;
    CStaticSchedule: TCStatic;
    procedure ComboBoxTypeChange(Sender: TObject);
    procedure CStaticAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticInoutCyclicAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticTransSourceAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticTransDestAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticInoutCyclicCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticInoutCyclicCategoryGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticCategoryGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticAccountChanged(Sender: TObject);
    procedure ComboBoxModeChange(Sender: TObject);
    procedure CStaticScheduleGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
  private
    FSchedule: TSchedule;
  protected
    procedure UpdateDescription;
    procedure InitializeForm; override;
    function ChooseAccount(var AId: String; var AText: String): Boolean;
    function ChooseCashpoint(var AId: String; var AText: String): Boolean;
    function ChooseProduct(var AId: String; var AText: String): Boolean;
    procedure ReadValues; override;
    function GetDataobjectClass: TDataObjectClass; override;
    procedure FillForm; override;
    function CanAccept: Boolean; override;
    function GetUpdateFrameClass: TCBaseFrameClass; override;
  public
    destructor Destroy; override;
  end;

implementation

uses CAccountsFrameUnit, CFrameFormUnit, CCashpointsFrameUnit,
  CProductsFrameUnit, CDataObjects, DateUtils, StrUtils, Math,
  CConfigFormUnit, CInfoFormUnit, CConsts, CPlannedFrameUnit;

{$R *.dfm}

function TCPlannedForm.ChooseAccount(var AId: String; var AText: String): Boolean;
begin
  Result := TCFrameForm.ShowFrame(TCAccountsFrame, AId, AText);
end;

procedure TCPlannedForm.ComboBoxTypeChange(Sender: TObject);
begin
  UpdateDescription;
end;

procedure TCPlannedForm.InitializeForm;
begin
  FSchedule := TSchedule.Create;
  ComboBoxTypeChange(ComboBoxType);
  UpdateDescription;
  CStaticSchedule.Caption := FSchedule.AsString;
end;

procedure TCPlannedForm.CStaticAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseAccount(ADataGid, AText);
end;

procedure TCPlannedForm.CStaticInoutCyclicAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseAccount(ADataGid, AText);
end;

procedure TCPlannedForm.CStaticTransSourceAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseAccount(ADataGid, AText);
end;

procedure TCPlannedForm.CStaticTransDestAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseAccount(ADataGid, AText);
end;

function TCPlannedForm.ChooseCashpoint(var AId, AText: String): Boolean;
begin
  Result := TCFrameForm.ShowFrame(TCCashpointsFrame, AId, AText);
end;

procedure TCPlannedForm.CStaticCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseCashpoint(ADataGid, AText);
end;

procedure TCPlannedForm.CStaticInoutCyclicCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseCashpoint(ADataGid, AText);
end;

function TCPlannedForm.ChooseProduct(var AId, AText: String): Boolean;
var xProd: String;
begin
  if (ComboBoxType.ItemIndex = 0) or (ComboBoxType.ItemIndex = 3) then begin
    xProd := COutProduct;
  end else begin
    xProd := CInProduct;
  end;
  Result := TCFrameForm.ShowFrame(TCProductsFrame, AId, AText, TProductsFrameAdditionalData.Create(xProd));
end;

procedure TCPlannedForm.CStaticInoutCyclicCategoryGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseProduct(ADataGid, AText);
end;

procedure TCPlannedForm.CStaticCategoryGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseProduct(ADataGid, AText);
end;

procedure TCPlannedForm.UpdateDescription;
var xI: Integer;
    xText: String;
begin
  xI := ComboBoxType.ItemIndex;
  GDataProvider.BeginTransaction;
  if (xI = 0) then begin
    if CStaticCategory.DataId <> CEmptyDataGid then begin
      xText := TProduct(TProduct.LoadObject(ProductProxy, CStaticCategory.DataId, False)).name;
    end else begin
      xText := '[kategoria rozchodu]';
    end;
  end else if (xI = 1) then begin
    if CStaticCategory.DataId <> CEmptyDataGid then begin
      xText := TProduct(TProduct.LoadObject(ProductProxy, CStaticCategory.DataId, False)).name;
    end else begin
      xText := '[kategoria przychodu]';
    end;
  end;
  RichEditDesc.Text := xText;
  GDataProvider.RollbackTransaction;
end;

procedure TCPlannedForm.CStaticAccountChanged(Sender: TObject);
begin
  UpdateDescription;
end;


function TCPlannedForm.CanAccept: Boolean;
begin
  Result := True;
  if CStaticCategory.DataId = CEmptyDataGid then begin
    Result := False;
    if ShowInfo(itQuestion, 'Nie wybrano kategorii operacji. Czy wyœwietliæ listê teraz ?', '') then begin
      CStaticCategory.DoGetDataId;
    end;
  end;
end;

procedure TCPlannedForm.FillForm;
begin
  with TPlannedMovement(Dataobject) do begin
    RichEditDesc.Text := description;
    CCurrEdit.Value := cash;
    ComboBoxType.ItemIndex := IfThen(movementType = COutMovement, 0, 1);
    ComboBoxStatus.ItemIndex := IfThen(isActive, 0, 1);
    CStaticAccount.DataId := idAccount;
    if idAccount <> CEmptyDataGid then begin
      CStaticAccount.Caption := TAccount(TAccount.LoadObject(AccountProxy, idAccount, False)).name;
    end;
    CStaticCashpoint.DataId := idCashPoint;
    if idCashPoint <> CEmptyDataGid then begin
      CStaticCashpoint.Caption := TCashPoint(TCashPoint.LoadObject(CashPointProxy, idCashPoint, False)).name;
    end;
    CStaticCategory.DataId := idProduct;
    CStaticCategory.Caption := TProduct(TProduct.LoadObject(ProductProxy, idProduct, False)).name;
    FSchedule.scheduleType := scheduleType;
    FSchedule.scheduleDate := scheduleDate;
    FSchedule.endCondition := endCondition;
    FSchedule.endCount := endCount;
    FSchedule.endDate := endDate;
    FSchedule.triggerType := triggerType;
    FSchedule.triggerDay := triggerDay;
    ComboBoxTypeChange(ComboBoxType);
    CStaticSchedule.Caption := FSchedule.AsString;
  end;
end;

function TCPlannedForm.GetDataobjectClass: TDataObjectClass;
begin
  Result := TPlannedMovement;
end;

procedure TCPlannedForm.ReadValues;
begin
  with TPlannedMovement(Dataobject) do begin
    description := RichEditDesc.Text;
    cash := CCurrEdit.Value;
    movementType := IfThen(ComboBoxType.ItemIndex = 0, COutMovement, CInMovement);
    isActive := ComboBoxStatus.ItemIndex = 0;
    idAccount := CStaticAccount.DataId;
    idCashPoint := CStaticCashpoint.DataId;
    idProduct := CStaticCategory.DataId;
    scheduleType := FSchedule.scheduleType;
    scheduleDate := FSchedule.scheduleDate;
    endCondition := FSchedule.endCondition;
    endCount := FSchedule.endCount;
    endDate := FSchedule.endDate;
    triggerType := FSchedule.triggerType;
    triggerDay := FSchedule.triggerDay;
  end;
end;

procedure TCPlannedForm.ComboBoxModeChange(Sender: TObject);
begin
  UpdateDescription;
end;

procedure TCPlannedForm.CStaticScheduleGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := GetSchedule(FSchedule);
  if AAccepted then begin
    ADataGid := '1';
    AText := FSchedule.AsString;
  end;
end;

destructor TCPlannedForm.Destroy;
begin
  FSchedule.Free;
  inherited Destroy;
end;

function TCPlannedForm.GetUpdateFrameClass: TCBaseFrameClass;
begin
  Result := TCPlannedFrame;
end;

end.
