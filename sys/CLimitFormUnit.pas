unit CLimitFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  CComponents;

type
  TCLimitForm = class(TCDataobjectForm)
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    EditName: TEdit;
    RichEditDesc: TRichEdit;
    GroupBox1: TGroupBox;
    CStaticFilter: TCStatic;
    Label3: TLabel;
    GroupBox3: TGroupBox;
    Label4: TLabel;
    CIntEditDays: TCIntEdit;
    Label5: TLabel;
    ComboBoxDays: TComboBox;
    Label6: TLabel;
    Label7: TLabel;
    ComboBoxStatus: TComboBox;
    procedure ComboBoxDaysChange(Sender: TObject);
    procedure CStaticFilterGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
  protected
    procedure InitializeForm; override;
    function CanAccept: Boolean; override;
    procedure ReadValues; override;
  end;

implementation

uses CFrameFormUnit, CFilterFrameUnit, CInfoFormUnit, CDataObjects;

{$R *.dfm}

procedure TCLimitForm.ComboBoxDaysChange(Sender: TObject);
begin
  CIntEditDays.Enabled := (ComboBoxDays.ItemIndex = ComboBoxDays.Items.Count - 1);
end;

procedure TCLimitForm.InitializeForm;
begin
  inherited InitializeForm;
  ComboBoxDaysChange(ComboBoxDays);
end;

procedure TCLimitForm.CStaticFilterGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCFilterFrame, ADataGid, AText);
end;

function TCLimitForm.CanAccept: Boolean;
begin
  Result := inherited CanAccept;
  if Trim(EditName.Text) = '' then begin
    Result := False;
    ShowInfo(itError, 'Nazwa limitu nie mo¿e byæ pusta', '');
    EditName.SetFocus;
  end;
end;

procedure TCLimitForm.ReadValues;
begin
  inherited ReadValues;
  with TMovementLimit(Dataobject) do begin

  end;
end;

end.
