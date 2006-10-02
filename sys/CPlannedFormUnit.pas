unit CPlannedFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  CComponents, CDatabase, ActnList, CScheduleFormUnit;

type
  TCPlannedForm = class(TCDataobjectForm)
    GroupBox2: TGroupBox;
    RichEditDesc: TRichEdit;
    GroupBox3: TGroupBox;
    GroupBox1: TGroupBox;
    Label5: TLabel;
    ComboBoxType: TComboBox;
    Label4: TLabel;
    CStaticInoutOnceAccount: TCStatic;
    Label2: TLabel;
    CStaticInoutOnceCategory: TCStatic;
    Label6: TLabel;
    CStaticInoutOnceCashpoint: TCStatic;
    Label9: TLabel;
    CCurrEditInoutOnce: TCCurrEdit;
    Label7: TLabel;
    ComboBoxStatus: TComboBox;
    Label1: TLabel;
    CStaticSchedule: TCStatic;
    procedure ComboBoxTypeChange(Sender: TObject);
    procedure CStaticInoutOnceAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticInoutCyclicAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticTransSourceAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticTransDestAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticInoutOnceCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticInoutCyclicCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticInoutCyclicCategoryGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticInoutOnceCategoryGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticInoutOnceAccountChanged(Sender: TObject);
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
    procedure AfterCommitData; override;
  public
    destructor Destroy; override;
  end;

implementation

uses CAccountsFrameUnit, CFrameFormUnit, CCashpointsFrameUnit,
  CProductsFrameUnit, CDataObjects, DateUtils, StrUtils, Math,
  CConfigFormUnit, CBaseFrameUnit, CInfoFormUnit;

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
end;

procedure TCPlannedForm.CStaticInoutOnceAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
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

procedure TCPlannedForm.CStaticInoutOnceCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
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

procedure TCPlannedForm.CStaticInoutOnceCategoryGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseProduct(ADataGid, AText);
end;

procedure TCPlannedForm.UpdateDescription;
begin
end;

procedure TCPlannedForm.CStaticInoutOnceAccountChanged(Sender: TObject);
begin
  UpdateDescription;
end;


function TCPlannedForm.CanAccept: Boolean;
begin
  Result := False;
end;

procedure TCPlannedForm.FillForm;
begin
end;

function TCPlannedForm.GetDataobjectClass: TDataObjectClass;
begin
  Result := TPlannedMovement;
end;

procedure TCPlannedForm.ReadValues;
begin
end;

procedure TCPlannedForm.AfterCommitData;
begin
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

end.
