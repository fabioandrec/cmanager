unit CDoneFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, CComponents,
  ComCtrls, CDoneFrameUnit;

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
    procedure ComboBoxStatusSelect(Sender: TObject);
  private
    FData: TPlannedTreeItem;
  protected
    procedure FillForm; override;
  public
    property TreeElement: TPlannedTreeItem read FData write FData;
  end;

implementation

uses CDatabase, CDataObjects;

{$R *.dfm}

procedure TCDoneForm.FillForm;
begin
  GDataProvider.BeginTransaction;
  CDateTimePlanned.Value := FData.triggerDate;
  RichEditOperation.Text := FData.planned.description;
  CDateTime.Value := GWorkDate;
  if FData.done = Nil then begin
    ComboBoxStatus.ItemIndex := 0;
  end else begin
    if FData.done.doneState = CDoneAccepted then begin
      ComboBoxStatus.ItemIndex := 1;
    end else begin
      ComboBoxStatus.ItemIndex := 2;
    end;
    RichEditDesc.Text := FData.done.description;
  end;
  GDataProvider.RollbackTransaction;
  ComboBoxStatusSelect(Nil);
end;

procedure TCDoneForm.ComboBoxStatusSelect(Sender: TObject);
begin
  Label3.Enabled := ComboBoxStatus.ItemIndex <> 0;
  CDateTime.Enabled := ComboBoxStatus.ItemIndex <> 0;
end;

end.
