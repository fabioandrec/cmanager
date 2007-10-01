unit CInstrumentFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  CComponents, CDataObjects, CDatabase, CBaseFrameUnit;

type
  TCInstrumentForm = class(TCDataobjectForm)
    GroupBoxAccountType: TGroupBox;
    Label6: TLabel;
    CButton1: TCButton;
    ComboBoxType: TComboBox;
    GroupBoxBank: TGroupBox;
    Label4: TLabel;
    CStaticBank: TCStatic;
    Label1: TLabel;
    EditName: TEdit;
    Label2: TLabel;
    RichEditDesc: TCRichedit;
    Label5: TLabel;
    CStaticCurrency: TCStatic;
    procedure ComboBoxTypeChange(Sender: TObject);
    procedure CStaticBankGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticCurrencyGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
  protected
    procedure ReadValues; override;
    function GetDataobjectClass: TDataObjectClass; override;
    procedure FillForm; override;
    function CanAccept: Boolean; override;
    function GetUpdateFrameClass: TCBaseFrameClass; override;
    procedure InitializeForm; override;
  end;

implementation

uses CConsts, CInstrumentFrameUnit, CRichtext, CInfoFormUnit,
  CConfigFormUnit, CDatatools, CTools, CCashpointsFrameUnit,
  CFrameFormUnit, CCurrencydefFrameUnit;

{$R *.dfm}

function TCInstrumentForm.CanAccept: Boolean;
var xIns: TInstrument;
begin
  if Trim(EditName.Text) = '' then begin
    Result := False;
    ShowInfo(itError, 'Nazwa instrumentu inwestycyjnego nie mo�e by� pusta', '');
    EditName.SetFocus;
  end else if CStaticBank.DataId = CEmptyDataGid then begin
    Result := False;
    if ShowInfo(itQuestion, 'Nie wybrano instytucji prowadz�cej notowania. Czy wy�wietli� list� teraz ?', '') then begin
      CStaticBank.DoGetDataId;
    end;
  end else if CStaticBank.DataId = CEmptyDataGid then begin
    Result := False;
    if ShowInfo(itQuestion, 'Nie wybrano instytucji prowadz�cej notowania. Czy wy�wietli� list� teraz ?', '') then begin
      CStaticBank.DoGetDataId;
    end;
  end else if (CStaticCurrency.DataId = CEmptyDataGid) then begin
    Result := False;
    if ShowInfo(itQuestion, 'Nie wybrano waluty konta. Czy wy�wietli� list� teraz ?', '') then begin
      CStaticCurrency.DoGetDataId;
    end;
  end else begin
    xIns := TInstrument.FindByName(EditName.Text);
    Result := xIns = Nil;
    if (not Result) and (Operation = coEdit) then begin
      Result := xIns.id = Dataobject.id;
    end;
    if not Result then begin
      ShowInfo(itError, 'Istnieje ju� instrument inwestycyjny o nazwie "' + EditName.Text + '"', '');
      EditName.SetFocus;
    end;
  end;
end;

procedure TCInstrumentForm.ComboBoxTypeChange(Sender: TObject);
begin
  CStaticCurrency.Enabled := ComboBoxType.ItemIndex <> 0;
  Label5.Enabled := CStaticCurrency.Enabled;
end;

procedure TCInstrumentForm.FillForm;
begin
  with TInstrument(Dataobject) do begin
    EditName.Text := name;
    SimpleRichText(description, RichEditDesc);
    if instrumentType = CInstrumentTypeIndex then begin
      ComboBoxType.ItemIndex := 0;
    end else if instrumentType = CInstrumentTypeStock then begin
      ComboBoxType.ItemIndex := 1;
    end else if instrumentType = CInstrumentTypeBond then begin
      ComboBoxType.ItemIndex := 2;
    end else if instrumentType = CInstrumentTypeFund then begin
      ComboBoxType.ItemIndex := 3;
    end;
    CStaticCurrency.DataId := idCurrencyDef;
    CStaticCurrency.Caption := TCurrencyDef(TCurrencyDef.LoadObject(CurrencyDefProxy, idCurrencyDef, False)).GetElementText;
    CStaticBank.DataId := idCashpoint;
    CStaticBank.Caption := TCashPoint(TCashPoint.LoadObject(CashPointProxy, idCashpoint, False)).GetElementText;
  end;
end;

function TCInstrumentForm.GetDataobjectClass: TDataObjectClass;
begin
  Result := TInstrument;
end;

function TCInstrumentForm.GetUpdateFrameClass: TCBaseFrameClass;
begin
  Result := TCInstrumentFrame;
end;

procedure TCInstrumentForm.InitializeForm;
begin
  inherited InitializeForm;
  ComboBoxTypeChange(Nil);
  if Operation = coAdd then begin
    CStaticCurrency.DataId := CCurrencyDefGid_PLN;
    CStaticCurrency.Caption := TCurrencyDef(TCurrencyDef.LoadObject(CurrencyDefProxy, CStaticCurrency.DataId, False)).GetElementText;
  end;
end;

procedure TCInstrumentForm.ReadValues;
begin
  inherited ReadValues;
  with TInstrument(Dataobject) do begin
    name := EditName.Text;
    description := RichEditDesc.Text;
    if ComboBoxType.ItemIndex = 0 then begin
      instrumentType := CInstrumentTypeIndex;
    end else if ComboBoxType.ItemIndex = 1 then begin
      instrumentType := CInstrumentTypeStock;
    end else if ComboBoxType.ItemIndex = 2 then begin
      instrumentType := CInstrumentTypeBond;
    end else if ComboBoxType.ItemIndex = 3 then begin
      instrumentType := CInstrumentTypeFund;
    end;
    idCashpoint := CStaticBank.DataId;
    idCurrencyDef := CStaticCurrency.DataId;
  end;
end;

procedure TCInstrumentForm.CStaticBankGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCCashpointsFrame, ADataGid, AText);
end;

procedure TCInstrumentForm.CStaticCurrencyGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCCurrencydefFrame, ADataGid, AText);
end;

end.
