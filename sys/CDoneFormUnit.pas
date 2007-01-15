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
    RichEditDesc: TRichEdit;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    CDateTimePlanned: TCDateTime;
    RichEditOperation: TRichEdit;
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

uses CDatabase, CDataObjects, CConsts;

{$R *.dfm}

procedure TCDoneForm.FillForm;
begin
  GDataProvider.BeginTransaction;
  CDateTimePlanned.Value := FData.triggerDate;
  RichEditOperation.Text := FData.planned.description;
  CDateTime.Value := GWorkDate;
  CCurrCash.Value := FData.planned.cash;
  if FData.done = Nil then begin
    ComboBoxStatus.ItemIndex := 0;
  end else begin
    if FData.done.doneState = CDoneAccepted then begin
      ComboBoxStatus.ItemIndex := 1;
    end else begin
      ComboBoxStatus.ItemIndex := 2;
    end;
    RichEditDesc.Text := FData.done.description;
    CCurrCash.Value := FData.done.cash;
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
