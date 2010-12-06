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
    GroupBox1: TGroupBox;
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
    GroupBox2: TGroupBox;
    EditSep: TEdit;
    ComboBoxSepType: TComboBox;
    Label5: TLabel;
    Label8: TLabel;
    ComboBoxDate: TComboBox;
    ComboBoxTime: TComboBox;
    Label7: TLabel;
    ComboBoxField: TComboBox;
    ComboBoxColumn: TComboBox;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    ComboBoxSearchType: TComboBox;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    ComboBoxIgnore: TComboBox;
    Label15: TLabel;
    EditChars: TEdit;
    Label16: TLabel;
    EditRegexp: TEdit;
    Label17: TLabel;
    CheckBoxNotregex: TCheckBox;
    procedure BitBtnOkClick(Sender: TObject);
    procedure BitBtnCancelClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditSepChange(Sender: TObject);
    procedure ComboBoxColumnChange(Sender: TObject);
    procedure ComboBoxSepTypeChange(Sender: TObject);
    procedure ComboBoxFieldChange(Sender: TObject);
  private
    FFieldSeparator: String;
    FDecimalSeparator: String;
    FDateSeparator: String;
    FTimeSeparator: String;
    FIdentColumn: String;
    FRegDateColumn: String;
    FRegTimeColumn: String;
    FValueColumn: String;
  end;

function EditSource(var AName, AUrl, ACashpoint,
                        AIso, AType, AFieldSeparator,
                        ADecimalSeparator, ADateSeparator, ATimeSeparator,
                        ADateFormat, ATimeFormat, ASearchType, AIgnoreChars, ARegex: String;
                    var ANotRegex: Boolean;
                    var AIgnoreLines, AIdentColumn, ARegDateColumn, ARegTimeColumn, AValueColumn: Integer): Boolean;

implementation

uses CXmlTlb, CPluginConsts, RegExpr;

{$R *.dfm}

procedure TMetastockEditForm.BitBtnOkClick(Sender: TObject);
var xRegexp: TRegExpr;
    xError: Boolean;
begin
  if Trim(EditName.Text) = '' then begin
    MessageBox(0, 'Nazwa ürÛd≥a nie moøe byÊ pusta', 'B≥πd', MB_OK + MB_ICONERROR);
    EditName.SetFocus;
  end else if Trim(EditUrl.Text) = '' then begin
    MessageBox(0, 'èrÛd≥o notowaÒ nie moøe byÊ puste', 'B≥πd', MB_OK + MB_ICONERROR);
    EditUrl.SetFocus;
  end else if Trim(EditUrl.Text) = '' then begin
    MessageBox(0, 'èrÛd≥o notowaÒ nie moøe byÊ puste', 'B≥πd', MB_OK + MB_ICONERROR);
    EditUrl.SetFocus;
  end else if Trim(EditCashpoint.Text) = '' then begin
    MessageBox(0, 'Miejsce notowaÒ nie moøe byÊ puste', 'B≥πd', MB_OK + MB_ICONERROR);
    EditCashpoint.SetFocus;
  end else if Trim(FFieldSeparator) = '' then begin
    MessageBox(0, 'Separator pÛl musi byÊ wype≥niony', 'B≥πd', MB_OK + MB_ICONERROR);
    ComboBoxSepType.ItemIndex := 0;
    ComboBoxSepTypeChange(Nil);
    EditSep.SetFocus;
  end else if Trim(FDecimalSeparator) = '' then begin
    MessageBox(0, 'Separator dziesiÍtny musi byÊ wype≥niony', 'B≥πd', MB_OK + MB_ICONERROR);
    ComboBoxSepType.ItemIndex := 1;
    ComboBoxSepTypeChange(Nil);
    EditSep.SetFocus;
  end else if StrToIntDef(ComboBoxIgnore.Text, -1) < 0 then begin
    MessageBox(0, 'IloúÊ ignorowanych poczπtkowych linii musi byÊ liczbπ wiÍkszπ lub rÛwnπ 0', 'B≥πd', MB_OK + MB_ICONERROR);
    ComboBoxIgnore.SetFocus;
  end else if StrToIntDef(FIdentColumn, -1) < 1 then begin
    MessageBox(0, 'Kolumna dla identyfikatora musi byÊ liczbπ wiÍkszπ od 0', 'B≥πd', MB_OK + MB_ICONERROR);
    ComboBoxField.ItemIndex := 0;
    ComboBoxFieldChange(Nil);
    ComboBoxColumn.SetFocus;
  end else if StrToIntDef(FRegDateColumn, -1) < 1 then begin
    MessageBox(0, 'Kolumna dla daty notowania musi byÊ liczbπ wiÍkszπ od 0', 'B≥πd', MB_OK + MB_ICONERROR);
    ComboBoxField.ItemIndex := 1;
    ComboBoxFieldChange(Nil);
    ComboBoxColumn.SetFocus;
  end else if StrToIntDef(FValueColumn, -1) < 1 then begin
    MessageBox(0, 'Kolumna dla wartoúci notowania musi byÊ liczbπ wiÍkszπ od 0', 'B≥πd', MB_OK + MB_ICONERROR);
    ComboBoxField.ItemIndex := 3;
    ComboBoxFieldChange(Nil);
    ComboBoxColumn.SetFocus;
  end else if FIdentColumn = FValueColumn then begin
    MessageBox(0, 'Kolumna dla wartoúci musi byÊ inna niø kolumna dla identyfikatora', 'B≥πd', MB_OK + MB_ICONERROR);
    ComboBoxField.ItemIndex := 3;
    ComboBoxFieldChange(Nil);
    ComboBoxColumn.SetFocus;
  end else if FIdentColumn = FRegDateColumn then begin
    MessageBox(0, 'Kolumna dla daty musi byÊ inna niø kolumna dla identyfikatora', 'B≥πd', MB_OK + MB_ICONERROR);
    ComboBoxField.ItemIndex := 1;
    ComboBoxFieldChange(Nil);
    ComboBoxColumn.SetFocus;
  end else if FIdentColumn = FRegTimeColumn then begin
    MessageBox(0, 'Kolumna dla czasu musi byÊ inna niø kolumna dla identyfikatora', 'B≥πd', MB_OK + MB_ICONERROR);
    ComboBoxField.ItemIndex := 2;
    ComboBoxFieldChange(Nil);
    ComboBoxColumn.SetFocus;
  end else if FRegDateColumn = FValueColumn then begin
    MessageBox(0, 'Kolumna dla wartoúci musi byÊ inna niø kolumna dla daty', 'B≥πd', MB_OK + MB_ICONERROR);
    ComboBoxField.ItemIndex := 3;
    ComboBoxFieldChange(Nil);
    ComboBoxColumn.SetFocus;
  end else if FRegTimeColumn = FValueColumn then begin
    MessageBox(0, 'Kolumna dla wartoúci musi byÊ inna niø kolumna dla czasu', 'B≥πd', MB_OK + MB_ICONERROR);
    ComboBoxField.ItemIndex := 3;
    ComboBoxFieldChange(Nil);
    ComboBoxColumn.SetFocus;
  end else begin
    if Trim(EditRegexp.Text) <> '' then begin
      xError := False;
      xRegexp := TRegExpr.Create;
      try
        try
          xRegexp.Expression := EditRegexp.Text;
          xRegexp.Compile;
        except
          xError := True;
        end;
      finally
        xRegexp.Free;
      end;
      if xError then begin
        MessageBox(0, 'Wprowadzone wyraøenie nie jest poprawnym wyraøeniem regularnym', 'B≥πd', MB_OK + MB_ICONERROR);
      end else begin
        ModalResult := mrOk;
      end;
    end else begin
      ModalResult := mrOk;
    end;
  end;
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

function EditSource(var AName, AUrl, ACashpoint,
                        AIso, AType, AFieldSeparator,
                        ADecimalSeparator, ADateSeparator, ATimeSeparator,
                        ADateFormat, ATimeFormat, ASearchType, AIgnoreChars, ARegex: String;
                    var ANotRegex: Boolean;
                    var AIgnoreLines, AIdentColumn, ARegDateColumn, ARegTimeColumn, AValueColumn: Integer): Boolean;
var xForm: TMetastockEditForm;
begin
  xForm := TMetastockEditForm.Create(Nil);
  xForm.Icon.Handle := SendMessage(Application.Handle, WM_GETICON, ICON_BIG, 0);
  with xForm do begin
    EditName.Text := AName;
    EditUrl.Text := AUrl;
    EditCashpoint.Text := ACashpoint;
    EditIso.Text := AIso;
    EditRegexp.Text := ARegex;
    CheckBoxNotregex.Checked := ANotRegex;
    if AType = CINSTRUMENTTYPE_INDEX then begin
      ComboBoxType.ItemIndex := 0;
    end else if AType = CINSTRUMENTTYPE_STOCK then begin
      ComboBoxType.ItemIndex := 1;
    end else if AType = CINSTRUMENTTYPE_BOND then begin
      ComboBoxType.ItemIndex := 2;
    end else if AType = CINSTRUMENTTYPE_FUNDINV then begin
      ComboBoxType.ItemIndex := 3;
    end else if AType = CINSTRUMENTTYPE_FUNDRET then begin
      ComboBoxType.ItemIndex := 4;
    end else begin
      ComboBoxType.ItemIndex := 5;
    end;
    if ASearchType = CINSTRUMENTSEARCHTYPE_BYNAME then begin
      ComboBoxSearchType.ItemIndex := 1;
    end else begin
      ComboBoxSearchType.ItemIndex := 0;
    end;
    FFieldSeparator := AFieldSeparator;
    FDecimalSeparator := ADecimalSeparator;
    FDateSeparator := ADateSeparator;
    FTimeSeparator := ATimeSeparator;
    FIdentColumn := IntToStr(AIdentColumn);
    FRegDateColumn := IntToStr(ARegDateColumn);
    FRegTimeColumn := IntToStr(ARegTimeColumn);
    FValueColumn := IntToStr(AValueColumn);
    ComboBoxIgnore.Text := IntToStr(AIgnoreLines);
    EditChars.Text := AIgnoreChars;
    ComboBoxDate.ItemIndex := ComboBoxDate.Items.IndexOf(ADateFormat);
    ComboBoxTime.ItemIndex := ComboBoxTime.Items.IndexOf(ATimeFormat);
    ComboBoxColumnChange(Nil);
    ComboBoxSepTypeChange(Nil);
    ComboBoxFieldChange(Nil);
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
        AType := CINSTRUMENTTYPE_FUNDINV;
      end else if ComboBoxType.ItemIndex = 4 then begin
        AType := CINSTRUMENTTYPE_FUNDRET;
      end else if ComboBoxType.ItemIndex = 5 then begin
        AType := CINSTRUMENTTYPE_UNDEFINED;
      end;
      AFieldSeparator := FFieldSeparator;
      ADecimalSeparator := FDecimalSeparator;
      ADateSeparator := FDateSeparator;
      ATimeSeparator := FTimeSeparator;
      AIdentColumn := StrToIntDef(FIdentColumn, 1);
      ARegDateColumn := StrToIntDef(FRegDateColumn, 2);
      ARegTimeColumn := StrToIntDef(FRegTimeColumn, 0);
      AValueColumn := StrToIntDef(FValueColumn, 3);
      ARegex := EditRegexp.Text;
      ADateFormat := ComboBoxDate.Text;
      ATimeFormat := ComboBoxTime.Text;
      AIgnoreLines := StrToIntDef(ComboBoxIgnore.Text, 0);
      AIgnoreChars := EditChars.Text;
      ANotRegex := CheckBoxNotregex.Checked;
      if ComboBoxSearchType.ItemIndex = 1 then begin
        ASearchType := CINSTRUMENTSEARCHTYPE_BYNAME;
      end else begin
        ASearchType := CINSTRUMENTSEARCHTYPE_BYSYMBOL;
      end;
    end;
  end;
  xForm.Free;
end;

procedure TMetastockEditForm.EditSepChange(Sender: TObject);
begin
  if ComboBoxSepType.ItemIndex = 0 then begin
    FFieldSeparator := EditSep.Text;
  end else if ComboBoxSepType.ItemIndex = 1 then begin
    FDecimalSeparator := EditSep.Text;
  end else if ComboBoxSepType.ItemIndex = 2 then begin
    FDateSeparator := EditSep.Text;
  end else if ComboBoxSepType.ItemIndex = 3 then begin
    FTimeSeparator := EditSep.Text;
  end;
end;

procedure TMetastockEditForm.ComboBoxColumnChange(Sender: TObject);
begin
  if ComboBoxField.ItemIndex = 0 then begin
    FIdentColumn := ComboBoxColumn.Text;
  end else if ComboBoxField.ItemIndex = 1 then begin
    FRegDateColumn := ComboBoxColumn.Text;
  end else if ComboBoxField.ItemIndex = 2 then begin
    FRegTimeColumn := ComboBoxColumn.Text;
  end else if ComboBoxField.ItemIndex = 3 then begin
    FValueColumn := ComboBoxColumn.Text;
  end;
end;

procedure TMetastockEditForm.ComboBoxSepTypeChange(Sender: TObject);
begin
  if ComboBoxSepType.ItemIndex = 0 then begin
    EditSep.Text := FFieldSeparator;
  end else if ComboBoxSepType.ItemIndex = 1 then begin
    EditSep.Text := FDecimalSeparator;
  end else if ComboBoxSepType.ItemIndex = 2 then begin
    EditSep.Text := FDateSeparator;;
  end else if ComboBoxSepType.ItemIndex = 3 then begin
    EditSep.Text := FTimeSeparator;
  end;
end;

procedure TMetastockEditForm.ComboBoxFieldChange(Sender: TObject);
begin
  if ComboBoxField.ItemIndex = 0 then begin
    ComboBoxColumn.Text := FIdentColumn;
  end else if ComboBoxField.ItemIndex = 1 then begin
    ComboBoxColumn.Text := FRegDateColumn;
  end else if ComboBoxField.ItemIndex = 2 then begin
    ComboBoxColumn.Text := FRegTimeColumn;
  end else if ComboBoxField.ItemIndex = 3 then begin
    ComboBoxColumn.Text := FValueColumn;
  end;
end;

end.
