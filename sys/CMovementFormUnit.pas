unit CMovementFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  CComponents, CDatabase;

type
  TCMovementForm = class(TCDataobjectForm)
    GroupBox1: TGroupBox;
    Label3: TLabel;
    CDateTime: TCDateTime;
    GroupBox2: TGroupBox;
    RichEditDesc: TRichEdit;
    ComboBoxType: TComboBox;
    Label5: TLabel;
    GroupBox3: TGroupBox;
    PageControl: TPageControl;
    TabSheetInOutCyclic: TTabSheet;
    TabSheetTrans: TTabSheet;
    TabSheetInOutOnce: TTabSheet;
    Label4: TLabel;
    CStaticInoutOnceAccount: TCStatic;
    Label1: TLabel;
    CStaticInoutOnceCategory: TCStatic;
    Label2: TLabel;
    CStaticInoutOnceCashpoint: TCStatic;
    Label6: TLabel;
    CStaticTransSourceAccount: TCStatic;
    Label7: TLabel;
    CStaticTransDestAccount: TCStatic;
    Label8: TLabel;
    CCurrEditTrans: TCCurrEdit;
    Label9: TLabel;
    CCurrEditInoutOnce: TCCurrEdit;
    Label10: TLabel;
    CCurrEditInoutCyclic: TCCurrEdit;
    Label11: TLabel;
    CStaticInoutCyclic: TCStatic;
    Label14: TLabel;
    CStaticInoutCyclicAccount: TCStatic;
    Label12: TLabel;
    CStaticInoutCyclicCategory: TCStatic;
    Label13: TLabel;
    CStaticInoutCyclicCashpoint: TCStatic;
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
  protected
    procedure UpdateDescription;
    procedure InitializeForm; override;
    function ChooseAccount(var AId: String; var AText: String): Boolean;
    function ChooseCashpoint(var AId: String; var AText: String): Boolean;
    function ChooseProduct(var AId: String; var AText: String): Boolean;
    function ChoosePlanned(var AId: String; var AText: String): Boolean;
    procedure ReadValues; override;
    function GetDataobjectClass: TDataObjectClass; override;
    procedure FillForm; override;
    function CanAccept: Boolean; override;
    procedure AfterCommitData; override;
  end;

implementation

uses CAccountsFrameUnit, CFrameFormUnit, CCashpointsFrameUnit,
  CProductsFrameUnit, CDataObjects, DateUtils, StrUtils, Math,
  CConfigFormUnit, CBaseFrameUnit, CInfoFormUnit;

{$R *.dfm}

function TCMovementForm.ChooseAccount(var AId: String; var AText: String): Boolean;
begin
  Result := TCFrameForm.ShowFrame(TCAccountsFrame, AId, AText);
end;

procedure TCMovementForm.ComboBoxTypeChange(Sender: TObject);
begin
  if (ComboBoxType.ItemIndex = 0) or (ComboBoxType.ItemIndex = 1) then begin
    PageControl.ActivePage := TabSheetInOutOnce;
  end else if (ComboBoxType.ItemIndex = 3) or (ComboBoxType.ItemIndex = 4) then begin
    PageControl.ActivePage := TabSheetInOutCyclic;
  end else if (ComboBoxType.ItemIndex = 2) then begin
    PageControl.ActivePage := TabSheetTrans;
  end;
  UpdateDescription;
end;

procedure TCMovementForm.InitializeForm;
begin
  CDateTime.Value := GWorkDate;
  ComboBoxTypeChange(ComboBoxType);
  UpdateDescription;
end;

procedure TCMovementForm.CStaticInoutOnceAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseAccount(ADataGid, AText);
end;

procedure TCMovementForm.CStaticInoutCyclicAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseAccount(ADataGid, AText);
end;

procedure TCMovementForm.CStaticTransSourceAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseAccount(ADataGid, AText);
end;

procedure TCMovementForm.CStaticTransDestAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseAccount(ADataGid, AText);
end;

function TCMovementForm.ChooseCashpoint(var AId, AText: String): Boolean;
begin
  Result := TCFrameForm.ShowFrame(TCCashpointsFrame, AId, AText);
end;

procedure TCMovementForm.CStaticInoutOnceCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseCashpoint(ADataGid, AText);
end;

procedure TCMovementForm.CStaticInoutCyclicCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseCashpoint(ADataGid, AText);
end;

function TCMovementForm.ChooseProduct(var AId, AText: String): Boolean;
var xProd: String;
begin
  if (ComboBoxType.ItemIndex = 0) or (ComboBoxType.ItemIndex = 3) then begin
    xProd := COutProduct;
  end else begin
    xProd := CInProduct;
  end;
  Result := TCFrameForm.ShowFrame(TCProductsFrame, AId, AText, TProductsFrameAdditionalData.Create(xProd));
end;

procedure TCMovementForm.CStaticInoutCyclicCategoryGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseProduct(ADataGid, AText);
end;

procedure TCMovementForm.CStaticInoutOnceCategoryGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChooseProduct(ADataGid, AText);
end;

procedure TCMovementForm.UpdateDescription;
var xI: Integer;
    xText: String;
begin
  xI := ComboBoxType.ItemIndex;
  GDataProvider.BeginTransaction;
  if (xI = 0) then begin
    if CStaticInoutOnceCategory.DataId <> CEmptyDataGid then begin
      xText := TProduct(TProduct.LoadObject(ProductProxy, CStaticInoutOnceCategory.DataId, False)).name;
    end else begin
      xText := '[kategoria rozchodu]';
    end;
  end else if (xI = 1) then begin
    if CStaticInoutOnceCategory.DataId <> CEmptyDataGid then begin
      xText := TProduct(TProduct.LoadObject(ProductProxy, CStaticInoutOnceCategory.DataId, False)).name;
    end else begin
      xText := '[kategoria przychodu]';
    end;
  end else if (xI = 2) then begin
    xText := 'Transfer z ';
    if CStaticTransSourceAccount.DataId <> CEmptyDataGid then begin
      xText := xText + TAccount(TAccount.LoadObject(AccountProxy, CStaticTransSourceAccount.DataId, False)).name;
    end else begin
      xText := xText + '[konto Ÿród³owe]';
    end;
    if CStaticTransDestAccount.DataId <> CEmptyDataGid then begin
      xText := xText + ' do ' + TAccount(TAccount.LoadObject(AccountProxy, CStaticTransDestAccount.DataId, False)).name;
    end else begin
      xText := xText + ' do ' + '[konto docelowe]';
    end;
  end else if (xI = 3) then begin
    if CStaticInoutCyclicCategory.DataId <> CEmptyDataGid then begin
      xText := TProduct(TProduct.LoadObject(ProductProxy, CStaticInoutCyclicCategory.DataId, False)).name;
    end else begin
      xText := '[kategoria rozchodu]';
    end;
  end else if (xI = 4) then begin
    if CStaticInoutCyclicCategory.DataId <> CEmptyDataGid then begin
      xText := TProduct(TProduct.LoadObject(ProductProxy, CStaticInoutCyclicCategory.DataId, False)).name;
    end else begin
      xText := '[kategoria przychodu]';
    end;
  end;
  RichEditDesc.Text := xText;
  GDataProvider.RollbackTransaction;
end;

procedure TCMovementForm.CStaticInoutOnceAccountChanged(Sender: TObject);
begin
  UpdateDescription;
end;


function TCMovementForm.CanAccept: Boolean;
var xI: Integer;
begin
  Result := True;
  xI := ComboBoxType.ItemIndex;
  if (xI = 0) or (xI = 1) then begin
    if CStaticInoutOnceAccount.DataId = CEmptyDataGid then begin
      Result := False;
      if ShowInfo(itQuestion, 'Nie wybrano konta operacji. Czy wyœwietliæ listê teraz ?', '') then begin
        CStaticInoutOnceAccount.DoGetDataId;
      end;
    end else if CStaticInoutOnceCategory.DataId = CEmptyDataGid then begin
      Result := False;
      if ShowInfo(itQuestion, 'Nie wybrano kategorii operacji. Czy wyœwietliæ listê teraz ?', '') then begin
        CStaticInoutOnceCategory.DoGetDataId;
      end;
    end else if CStaticInoutOnceCashpoint.DataId = CEmptyDataGid then begin
      Result := False;
      if ShowInfo(itQuestion, 'Nie wybrano kontrahenta operacji. Czy wyœwietliæ listê teraz ?', '') then begin
        CStaticInoutOnceCashpoint.DoGetDataId;
      end;
    end else if CCurrEditInoutOnce.Value = 0 then begin
      Result := False;
      ShowInfo(itError, 'Kwota operacji nie mo¿e byæ zerowa', '');
      CCurrEditInoutOnce.SetFocus;
    end;
  end else if xI = 2 then begin
    if CStaticTransSourceAccount.DataId = CEmptyDataGid then begin
      Result := False;
      if ShowInfo(itQuestion, 'Nie wybrano konta Ÿród³owego. Czy wyœwietliæ listê teraz ?', '') then begin
        CStaticTransSourceAccount.DoGetDataId;
      end;
    end else if CStaticTransDestAccount.DataId = CEmptyDataGid then begin
      Result := False;
      if ShowInfo(itQuestion, 'Nie wybrano konta docelowego. Czy wyœwietliæ listê teraz ?', '') then begin
        CStaticTransDestAccount.DoGetDataId;
      end;
    end else if CStaticTransDestAccount.DataId = CStaticTransSourceAccount.DataId then begin
      Result := False;
      ShowInfo(itError, 'Konto Ÿród³owe nie mo¿e byæ kontem docelowym', '');
    end else if CCurrEditTrans.Value = 0 then begin
      Result := False;
      ShowInfo(itError, 'Kwota transferu nie mo¿e byæ zerowa', '');
      CCurrEditTrans.SetFocus;
    end;
  end else if (xI = 3) or (xI = 4) then begin
    if CStaticInoutCyclic.DataId = CEmptyDataGid then begin
      Result := False;
      if ShowInfo(itQuestion, 'Nie wybrano planowanej operacji. Czy wyœwietliæ listê teraz ?', '') then begin
        CStaticInoutCyclic.DoGetDataId;
      end;
    end else if CStaticInoutCyclicAccount.DataId = CEmptyDataGid then begin
      Result := False;
      if ShowInfo(itQuestion, 'Nie wybrano konta operacji. Czy wyœwietliæ listê teraz ?', '') then begin
        CStaticInoutCyclicAccount.DoGetDataId;
      end;
    end else if CStaticInoutCyclicCategory.DataId = CEmptyDataGid then begin
      Result := False;
      if ShowInfo(itQuestion, 'Nie wybrano kategorii operacji. Czy wyœwietliæ listê teraz ?', '') then begin
        CStaticInoutCyclicCategory.DoGetDataId;
      end;
    end else if CStaticInoutCyclicCashpoint.DataId = CEmptyDataGid then begin
      Result := False;
      if ShowInfo(itQuestion, 'Nie wybrano kontrahenta operacji. Czy wyœwietliæ listê teraz ?', '') then begin
        CStaticInoutCyclicCashpoint.DoGetDataId;
      end;
    end else if CCurrEditInoutCyclic.Value = 0 then begin
      Result := False;
      ShowInfo(itError, 'Kwota operacji nie mo¿e byæ zerowa', '');
      CCurrEditInoutCyclic.SetFocus;
    end;
  end;
end;

procedure TCMovementForm.FillForm;
var xI: Integer;
begin
  with TBaseMovement(Dataobject) do begin
    CDateTime.Value := regDate;
    RichEditDesc.Text := description;
    if (movementType = CInMovement) or (movementType = COutMovement) then begin
      if idPlannedDone = CEmptyDataGid then begin
        xI := IfThen(movementType = COutMovement, 0, 1);
      end else begin
        xI := IfThen(movementType = COutMovement, 3, 4);
      end;
    end else if (movementType = CTransferMovement) then begin
      xI := 2;
    end else begin
      xI := -1;
    end;
    ComboBoxType.ItemIndex := xI;
    ComboBoxType.Enabled := False;
    ComboBoxTypeChange(ComboBoxType);
    GDataProvider.BeginTransaction;
    if (movementType = COutMovement) or (movementType = CInMovement) then begin
      if idPlannedDone = CEmptyDataGid then begin
        CCurrEditInoutOnce.Value := cash;
        CStaticInoutOnceAccount.DataId := idAccount;
        CStaticInoutOnceAccount.Caption := TAccount(TAccount.LoadObject(AccountProxy, idAccount, False)).name;
        CStaticInoutOnceCashpoint.DataId := idCashPoint;
        CStaticInoutOnceCashpoint.Caption := TCashPoint(TCashPoint.LoadObject(CashPointProxy, idCashPoint, False)).name;
        CStaticInoutOnceCategory.DataId := idProduct;
        CStaticInoutOnceCategory.Caption := TProduct(TProduct.LoadObject(ProductProxy, idProduct, False)).name;
      end else begin
        CCurrEditInoutCyclic.Value := cash;
        CStaticInoutCyclicAccount.DataId := idAccount;
        CStaticInoutCyclicAccount.Caption := TAccount(TAccount.LoadObject(AccountProxy, idAccount, False)).name;
        CStaticInoutCyclicCashpoint.DataId := idCashPoint;
        CStaticInoutCyclicCashpoint.Caption := TCashPoint(TCashPoint.LoadObject(CashPointProxy, idCashPoint, False)).name;
        CStaticInoutCyclicCategory.DataId := idProduct;
        CStaticInoutCyclicCategory.Caption := TProduct(TProduct.LoadObject(ProductProxy, idProduct, False)).name;
        CStaticInoutCyclic.DataId := idPlannedDone;
      end;
    end else if (movementType = CTransferMovement) then begin
      CCurrEditTrans.Value := cash;
      CStaticTransDestAccount.DataId := idAccount;
      CStaticTransDestAccount.Caption := TAccount(TAccount.LoadObject(AccountProxy, idAccount, False)).name;
      CStaticTransSourceAccount.DataId := idSourceAccount;
      CStaticTransSourceAccount.Caption := TAccount(TAccount.LoadObject(AccountProxy, idSourceAccount, False)).name;
    end;
    GDataProvider.RollbackTransaction;
  end;
end;

function TCMovementForm.GetDataobjectClass: TDataObjectClass;
begin
  Result := TBaseMovement;
end;

procedure TCMovementForm.ReadValues;
var xI: Integer;
    xBa, xSa: TAccount;
begin
  with TBaseMovement(Dataobject) do begin
    xI := ComboBoxType.ItemIndex;
    if Operation = coEdit then begin
      if (xI = 0) or (xI = 1) then begin
        if (idAccount <> CStaticInoutOnceAccount.DataId) or (cash <> CCurrEditInoutOnce.Value) then begin
          xBa := TAccount(TAccount.LoadObject(AccountProxy, idAccount, False));
          if xI = 0 then begin
            xBa.cash := xBa.cash + cash;
          end else begin
            xBa.cash := xBa.cash - cash;
          end;
          xBa.ForceUpdate;
          SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTEDITED, Integer(@idAccount), 0);
        end
      end else if (xI = 2) then begin
        if (idAccount <> CStaticTransDestAccount.DataId) or (idSourceAccount <> CStaticTransSourceAccount.DataId) or (cash <> CCurrEditTrans.Value) then begin
          xBa := TAccount(TAccount.LoadObject(AccountProxy, idAccount, False));
          xSa := TAccount(TAccount.LoadObject(AccountProxy, idSourceAccount, False));
          xBa.cash := xBa.cash - cash;
          xSa.cash := xSa.cash + cash;
          xBa.ForceUpdate;
          xSa.ForceUpdate;
          SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTEDITED, Integer(@idAccount), 0);
          SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTEDITED, Integer(@idSourceAccount), 0);
        end;
      end else if (xI = 3) or (xI = 4) then begin
        if (idAccount <> CStaticInoutCyclicAccount.DataId) or (cash <> CCurrEditInoutCyclic.Value) then begin
          xBa := TAccount(TAccount.LoadObject(AccountProxy, idAccount, False));
          if xI = 3 then begin
            xBa.cash := xBa.cash + cash;
          end else begin
            xBa.cash := xBa.cash - cash;
          end;
          xBa.ForceUpdate;
          SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTEDITED, Integer(@idAccount), 0);
        end
      end;
    end;
    regDate := CDateTime.Value;
    description := RichEditDesc.Text;
    weekNumber := WeekOf(regDate);
    xI := ComboBoxType.ItemIndex;
    if (xI = 0) or (xI = 1) then begin
      movementType := IfThen(xI = 0, COutMovement, CInMovement);
      cash := CCurrEditInoutOnce.Value;
      idAccount := CStaticInoutOnceAccount.DataId;
      xBa := TAccount(TAccount.LoadObject(AccountProxy, idAccount, False));
      if xI = 0 then begin
        xBa.cash := xBa.cash - cash;
      end else begin
        xBa.cash := xBa.cash + cash;
      end;
      xBa.ForceUpdate;
      SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTEDITED, Integer(@idAccount), 0);
      idSourceAccount := CEmptyDataGid;
      idCashPoint := CStaticInoutOnceCashpoint.DataId;
      idProduct := CStaticInoutOnceCategory.DataId;
      idPlannedDone := CEmptyDataGid;
    end else if (xI = 2) then begin
      movementType := CTransferMovement;
      cash := CCurrEditTrans.Value;
      idAccount := CStaticTransDestAccount.DataId;
      idSourceAccount := CStaticTransSourceAccount.DataId;
      xBa := TAccount(TAccount.LoadObject(AccountProxy, idAccount, False));
      xSa := TAccount(TAccount.LoadObject(AccountProxy, idSourceAccount, False));
      xBa.cash := xBa.cash + cash;
      xSa.cash := xSa.cash - cash;
      xBa.ForceUpdate;
      xSa.ForceUpdate;
      SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTEDITED, Integer(@idAccount), 0);
      idCashPoint := CEmptyDataGid;
      idProduct := CEmptyDataGid;
      idPlannedDone := CEmptyDataGid;
    end else if (xI = 3) or (xI = 4) then begin
      movementType := IfThen(xI = 3, COutMovement, CInMovement);
      cash := CCurrEditInoutCyclic.Value;
      idAccount := CStaticInoutCyclicAccount.DataId;
      xBa := TAccount(TAccount.LoadObject(AccountProxy, idAccount, False));
      if xI = 0 then begin
        xBa.cash := xBa.cash - cash;
      end else begin
        xBa.cash := xBa.cash + cash;
      end;
      xBa.ForceUpdate;
      SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTEDITED, Integer(@idAccount), 0);
      idSourceAccount := CEmptyDataGid;
      idCashPoint := CStaticInoutCyclicCashpoint.DataId;
      idProduct := CStaticInoutCyclicCategory.DataId;
      idPlannedDone := CStaticInoutCyclic.DataId;
    end;
  end;
end;

procedure TCMovementForm.AfterCommitData;
var xId: TDataGid;
    xI: Integer;
begin
  xI := ComboBoxType.ItemIndex;
  if (xI = 0) or (xI = 1) then begin
    xId := CStaticInoutOnceAccount.DataId;
    SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTEDITED, Integer(@xId), 0);
  end else if (xI = 2) then begin
    xId := CStaticTransDestAccount.DataId;
    SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTEDITED, Integer(@xId), 0);
    xId := CStaticTransSourceAccount.DataId;
    SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTEDITED, Integer(@xId), 0);
  end else if (xI = 3) or (xI = 4) then begin
    xId := CStaticInoutCyclicAccount.DataId;
    SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTEDITED, Integer(@xId), 0);
  end;
end;

function TCMovementForm.ChoosePlanned(var AId, AText: String): Boolean;
begin
  //
end;

end.
