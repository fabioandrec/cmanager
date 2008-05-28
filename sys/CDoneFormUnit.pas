unit CDoneFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, CComponents,
  ComCtrls, CDoneFrameUnit, CSchedules;

type
  TCDoneForm = class(TCConfigForm)
    GroupBox1: TGroupBox;
    ComboBoxStatus: TComboBox;
    GroupBox2: TGroupBox;
    RichEditDesc: TCRichEdit;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    CDateTimePlanned: TCDateTime;
    RichEditOperation: TCRichEdit;
    Label3: TLabel;
    CDateTime: TCDateTime;
    Label10: TLabel;
    CCurrCash: TCCurrEdit;
    procedure ComboBoxStatusSelect(Sender: TObject);
  private
    FData: TPlannedTreeItem;
  protected
    procedure FillForm; override;
  public
    property TreeElement: TPlannedTreeItem read FData write FData;
  end;

implementation

uses CDatabase, CDataObjects, CConsts, CRichtext;

{$R *.dfm}

procedure TCDoneForm.FillForm;
begin
  GDataProvider.BeginTransaction;
  CDateTimePlanned.Value := FData.triggerDate;
  AssignRichText(FData.planned.description, RichEditOperation);
  AssignRichText(FData.planned.description, RichEditDesc);
  CDateTime.Value := GWorkDate;
  CCurrCash.Value := FData.planned.cash;
  if FData.done = Nil then begin
    ComboBoxStatus.ItemIndex := 0;
    CCurrCash.SetCurrencyDef(FData.planned.idMovementCurrencyDef, GCurrencyCache.GetSymbol(FData.planned.idMovementCurrencyDef));
  end else begin
    if FData.done.doneState = CDoneAccepted then begin
      ComboBoxStatus.ItemIndex := 1;
    end else begin
      ComboBoxStatus.ItemIndex := 2;
    end;
    AssignRichText(FData.done.description, RichEditDesc);
    CCurrCash.Value := FData.done.cash;
    CCurrCash.SetCurrencyDef(FData.done.idDoneCurrencyDef, GCurrencyCache.GetSymbol(FData.done.idDoneCurrencyDef));
    CDateTime.Value := FData.done.doneDate;
  end;
  GDataProvider.RollbackTransaction;
  ComboBoxStatusSelect(Nil);
end;

procedure TCDoneForm.ComboBoxStatusSelect(Sender: TObject);
begin
  CDateTime.Enabled := ComboBoxStatus.ItemIndex <> 0;
  CCurrCash.Enabled := ComboBoxStatus.ItemIndex <> 0;
  RichEditDesc.Enabled := ComboBoxStatus.ItemIndex <> 0;
end;

end.