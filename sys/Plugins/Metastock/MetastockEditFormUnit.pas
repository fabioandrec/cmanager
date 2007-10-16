unit MetastockEditFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, CPluginTypes, ComCtrls, CXml;

type
  TMetastockEditForm = class(TForm)
    PanelConfig: TPanel;
    PanelButtons: TPanel;
    BitBtnOk: TBitBtn;
    BitBtnCancel: TBitBtn;
    Label1: TLabel;
    EditName: TEdit;
    Label2: TLabel;
    EditUrl: TEdit;
    Label3: TLabel;
    EditCashpoint: TEdit;
    Label4: TLabel;
    EditIso: TEdit;
    Label6: TLabel;
    ComboBoxType: TComboBox;
    procedure BitBtnOkClick(Sender: TObject);
    procedure BitBtnCancelClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  end;

function EditSource(var AName, AUrl, ACashpoint, AIso, AType: String): Boolean;

implementation

uses CXmlTlb, CPluginConsts;

{$R *.dfm}

procedure TMetastockEditForm.BitBtnOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TMetastockEditForm.BitBtnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TMetastockEditForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then begin
    Close;
  end;
end;

function EditSource(var AName, AUrl, ACashpoint, AIso, AType: String): Boolean;
var xForm: TMetastockEditForm;
begin
  xForm := TMetastockEditForm.Create(Nil);
  xForm.Icon.Handle := SendMessage(Application.Handle, WM_GETICON, ICON_BIG, 0);
  with xForm do begin
    EditName.Text := AName;
    EditUrl.Text := AUrl;
    EditCashpoint.Text := ACashpoint;
    EditIso.Text := AIso;
    if AType = CINSTRUMENTTYPE_INDEX then begin
      ComboBoxType.ItemIndex := 0;
    end else if AType = CINSTRUMENTTYPE_STOCK then begin
      ComboBoxType.ItemIndex := 1;
    end else if AType = CINSTRUMENTTYPE_BOND then begin
      ComboBoxType.ItemIndex := 2;
    end else if AType = CINSTRUMENTTYPE_FUND then begin
      ComboBoxType.ItemIndex := 3;
    end;
    Result := ShowModal = mrOk;
    if Result then begin
      AName := EditName.Text;
      AUrl := EditUrl.Text;
      ACashpoint := EditCashpoint.Text;
      AIso := EditIso.Text;
      if ComboBoxType.ItemIndex = 0 then begin
        AType := CINSTRUMENTTYPE_INDEX;
      end else if ComboBoxType.ItemIndex = 1 then begin
        AType := CINSTRUMENTTYPE_STOCK;
      end else if ComboBoxType.ItemIndex = 2 then begin
        AType := CINSTRUMENTTYPE_BOND;
      end else if ComboBoxType.ItemIndex = 3 then begin
        AType := CINSTRUMENTTYPE_FUND;
      end;
    end;
  end;
  xForm.Free;
end;

end.
