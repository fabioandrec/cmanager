unit CInvestmentWalletFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  ImgList, CComponents, CDatabase, CBaseFrameUnit;

type
  TCInvestmentWalletForm = class(TCDataobjectForm)
    GroupBox2: TGroupBox;
    EditName: TEdit;
    Label1: TLabel;
    RichEditDesc: TCRichEdit;
    Label2: TLabel;
    ComboBoxType: TComboBox;
    Label3: TLabel;
  protected
    procedure ReadValues; override;
    function GetDataobjectClass: TDataObjectClass; override;
    procedure FillForm; override;
    function CanAccept: Boolean; override;
    function GetUpdateFrameClass: TCBaseFrameClass; override;
  end;

implementation

uses CDataObjects, CInfoFormUnit, CCashpointsFrameUnit, CConsts, CRichtext,
  CLimitsFrameUnit, CInvestmentWalletFrameUnit;

{$R *.dfm}

function TCInvestmentWalletForm.CanAccept: Boolean;
begin
  Result := inherited CanAccept;
  if Trim(EditName.Text) = '' then begin
    Result := False;
    ShowInfo(itError, 'Nazwa kontrahenta nie mo¿e byæ pusta', '');
    EditName.SetFocus;
  end;
end;

procedure TCInvestmentWalletForm.FillForm;
begin
  with TCashPoint(Dataobject) do begin
    EditName.Text := name;
    SimpleRichText(description, RichEditDesc);
    if cashpointType = CCashpointTypeAll then begin
      ComboBoxType.ItemIndex := 0;
    end else if cashpointType = CCashpointTypeOut then begin
      ComboBoxType.ItemIndex := 1;
    end else if cashpointType = CCashpointTypeIn then begin
      ComboBoxType.ItemIndex := 2;
    end else if cashpointType = CCashpointTypeOther then begin
      ComboBoxType.ItemIndex := 3;
    end;
  end;
end;

function TCInvestmentWalletForm.GetDataobjectClass: TDataObjectClass;
begin
  Result := TCashpoint;
end;

function TCInvestmentWalletForm.GetUpdateFrameClass: TCBaseFrameClass;
begin
  Result := TCInvestmentWalletFrame;
end;

procedure TCInvestmentWalletForm.ReadValues;
begin
  inherited ReadValues;
  with TCashPoint(Dataobject) do begin
    name := EditName.Text;
    description := RichEditDesc.Text;
    if ComboBoxType.ItemIndex = 0 then begin
      cashpointType := CCashpointTypeAll;
    end else if ComboBoxType.ItemIndex = 1 then begin
      cashpointType := CCashpointTypeOut;
    end else if ComboBoxType.ItemIndex = 2 then begin
      cashpointType := CCashpointTypeIn;
    end else if ComboBoxType.ItemIndex = 3 then begin
      cashpointType := CCashpointTypeOther;
    end;
  end;
end;

end.
