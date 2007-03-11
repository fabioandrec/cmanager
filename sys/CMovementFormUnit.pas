unit CMovementFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  CComponents, CDatabase, CBaseFrameUnit, ActnList, XPStyleActnCtrls,
  ActnMan, CImageListsUnit, Contnrs;

type
  TMovementAdditionalData = class(TAdditionalData)
  private
    FtriggerDate: TDateTime;
    Fplanned: TDataObject;
  public
    constructor Create(ATriggerDate: TDateTime; APlanned: TDataObject);
  published
    property triggerDate: TDateTime read FtriggerDate write FtriggerDate;
    property planned: TDataObject read Fplanned write Fplanned;
  end;

  TCMovementForm = class(TCDataobjectForm)
    GroupBox1: TGroupBox;
    Label3: TLabel;
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
    GroupBox4: TGroupBox;
    Label15: TLabel;
    Label16: TLabel;
    CDateTime: TCDateTime;
    ActionManager: TActionManager;
    ActionAdd: TAction;
    CButton1: TCButton;
    ActionTemplate: TAction;
    CButton2: TCButton;
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
    procedure CStaticInoutCyclicGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticInoutCyclicChanged(Sender: TObject);
    procedure ActionTemplateExecute(Sender: TObject);
    procedure ActionAddExecute(Sender: TObject);
  private
    FbaseAccount: TDataGid;
    FsourceAccount: TDataGid;
    FbaseList: TDataGid;
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
    procedure UpdateFrames(ADataGid: TDataGid; AMessage, AOption: Integer); override;
    function GetUpdateFrameOption: Integer; override;
    function GetUpdateFrameClass: TCBaseFrameClass; override;
  end;

implementation

uses CAccountsFrameUnit, CFrameFormUnit, CCashpointsFrameUnit,
  CProductsFrameUnit, CDataObjects, DateUtils, StrUtils, Math,
  CConfigFormUnit, CInfoFormUnit, CPlannedFrameUnit,
  CDoneFrameUnit, CConsts, CMovementFrameUnit, CDescpatternFormUnit,
  CTemplates;

{$R *.dfm}

function TCMovementForm.ChooseAccount(var AId: String; var AText: String): Boolean;
begin
  Result := TCFrameForm.ShowFrame(TCAccountsFrame, AId, AText);
end;

procedure TCMovementForm.ComboBoxTypeChange(Sender: TObject);
var xProfile: TProfile;
begin
  Caption := 'Operacja';
  if (ComboBoxType.ItemIndex = 0) or (ComboBoxType.ItemIndex = 1) then begin
    PageControl.ActivePage := TabSheetInOutOnce;
    if Operation = coAdd then begin
      if GActiveProfileId <> CEmptyDataGid then begin
        GDataProvider.BeginTransaction;
        xProfile := TProfile(TProfile.LoadObject(ProfileProxy, GActiveProfileId, False));
        Caption := Caption + ' - ' + xProfile.name;
        CStaticInoutOnceAccount.DataId := xProfile.idAccount;
        CStaticInoutOnceAccount.Caption := TAccount(TAccount.LoadObject(AccountProxy, xProfile.idAccount, False)).name;
        CStaticInoutOnceCashpoint.DataId := xProfile.idCashPoint;
        CStaticInoutOnceCashpoint.Caption := TCashPoint(TCashPoint.LoadObject(CashPointProxy, xProfile.idCashPoint, False)).name;
        CStaticInoutOnceCategory.DataId := xProfile.idProduct;
        CStaticInoutOnceCategory.Caption := TProduct(TProduct.LoadObject(ProductProxy, xProfile.idProduct, False)).name;
        GDataProvider.RollbackTransaction;
      end;
    end;
  end else if (ComboBoxType.ItemIndex = 3) or (ComboBoxType.ItemIndex = 4) then begin
    PageControl.ActivePage := TabSheetInOutCyclic;
  end else if (ComboBoxType.ItemIndex = 2) then begin
    PageControl.ActivePage := TabSheetTrans;
  end;
  UpdateDescription;
end;

procedure TCMovementForm.InitializeForm;
var xAdd: TMovementAdditionalData;
    xPlan: TPlannedMovement;
    xText: String;
begin
  CDateTime.Value := GWorkDate;
  if AdditionalData <> Nil then begin
    xAdd := TMovementAdditionalData(AdditionalData);
    xPlan := TPlannedMovement(xAdd.planned);
    if xPlan.movementType = CInMovement then begin
      ComboBoxType.ItemIndex := 4;
      xText := xPlan.description + ' (wp³yw do ' + DateToStr(xAdd.triggerDate) + ')'
    end else if xPlan.movementType = COutMovement then begin
      ComboBoxType.ItemIndex := 3;
      xText := xPlan.description + ' (p³atne do ' + DateToStr(xAdd.triggerDate) + ')'
    end;
    CStaticInoutCyclic.DataId := xPlan.id + '|' + DatetimeToDatabase(xAdd.triggerDate, False);
    CStaticInoutCyclic.Caption := xText;
    CStaticInoutCyclicChanged(CStaticInoutCyclic);
  end;
  FbaseAccount := CEmptyDataGid;
  FbaseList := CEmptyDataGid;
  FsourceAccount := CEmptyDataGid;
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
var xCt: String;
begin
  if (ComboBoxType.ItemIndex = 0) or (ComboBoxType.ItemIndex = 3) then begin
    xCt := CCashpointTypeOut;
  end else if (ComboBoxType.ItemIndex = 1) or (ComboBoxType.ItemIndex = 4) then begin
    xCt := CCashpointTypeIn;
  end;
  Result := TCFrameForm.ShowFrame(TCCashpointsFrame, AId, AText, TCashpointFrameAdditionalData.Create(xCt));
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
    end;
  end;
end;

procedure TCMovementForm.FillForm;
var xI: Integer;
    xD: TPlannedDone;
    xM: TPlannedMovement;
begin
  with TBaseMovement(Dataobject) do begin
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
    CStaticInoutCyclic.Enabled := False;
    ComboBoxTypeChange(ComboBoxType);
    GDataProvider.BeginTransaction;
    if idMovementList <> CEmptyDataGid then begin
      CDateTime.Enabled := False;
      CStaticInoutOnceAccount.Enabled := False;
      CStaticInoutOnceCashpoint.Enabled := False;
      Caption := Caption + ' - Lista - ' + TMovementList(TMovementList.LoadObject(MovementListProxy, idMovementList, False)).description;
    end;
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
        xD := TPlannedDone(TPlannedDone.LoadObject(PlannedDoneProxy, idPlannedDone, False));
        xM := TPlannedMovement(TPlannedMovement.LoadObject(PlannedMovementProxy, xD.idPlannedMovement, False));
        if movementType = COutMovement then begin
          CStaticInoutCyclic.Caption := xM.description + ' (p³atne do ' + DateToStr(xD.triggerDate) + ')';
        end else begin
          CStaticInoutCyclic.Caption := xM.description + ' (wp³yw do ' + DateToStr(xD.triggerDate) + ')'
        end;
      end;
      FbaseAccount := idAccount;
    end else if (movementType = CTransferMovement) then begin
      CCurrEditTrans.Value := cash;
      CStaticTransDestAccount.DataId := idAccount;
      CStaticTransDestAccount.Caption := TAccount(TAccount.LoadObject(AccountProxy, idAccount, False)).name;
      CStaticTransSourceAccount.DataId := idSourceAccount;
      CStaticTransSourceAccount.Caption := TAccount(TAccount.LoadObject(AccountProxy, idSourceAccount, False)).name;
      FbaseAccount := idAccount;
      FsourceAccount := idSourceAccount;
    end;
    GDataProvider.RollbackTransaction;
    CDateTime.Value := regDate;
    RichEditDesc.Text := description;
    FbaseList := idMovementList;
  end;
end;

function TCMovementForm.GetDataobjectClass: TDataObjectClass;
begin
  Result := TBaseMovement;
end;

procedure TCMovementForm.ReadValues;
var xI: Integer;
    xDone: TPlannedDone;
    xTrDate: TDateTime;
    xTrMove: TDataGid;
    xPos: Integer;
begin
  with TBaseMovement(Dataobject) do begin
    regDate := CDateTime.Value;
    description := RichEditDesc.Text;
    xI := ComboBoxType.ItemIndex;
    if (xI = 0) or (xI = 1) then begin
      movementType := IfThen(xI = 0, COutMovement, CInMovement);
      cash := CCurrEditInoutOnce.Value;
      idAccount := CStaticInoutOnceAccount.DataId;
      idSourceAccount := CEmptyDataGid;
      idCashPoint := CStaticInoutOnceCashpoint.DataId;
      idProduct := CStaticInoutOnceCategory.DataId;
      idPlannedDone := CEmptyDataGid;
    end else if (xI = 2) then begin
      movementType := CTransferMovement;
      cash := CCurrEditTrans.Value;
      idAccount := CStaticTransDestAccount.DataId;
      idSourceAccount := CStaticTransSourceAccount.DataId;
      idCashPoint := CEmptyDataGid;
      idProduct := CEmptyDataGid;
      idPlannedDone := CEmptyDataGid;
    end else if (xI = 3) or (xI = 4) then begin
      movementType := IfThen(xI = 3, COutMovement, CInMovement);
      cash := CCurrEditInoutCyclic.Value;
      idAccount := CStaticInoutCyclicAccount.DataId;
      idSourceAccount := CEmptyDataGid;
      idCashPoint := CStaticInoutCyclicCashpoint.DataId;
      idProduct := CStaticInoutCyclicCategory.DataId;
      if Operation = coAdd then begin
        xPos := Pos('|', CStaticInoutCyclic.DataId);
        xTrMove := Copy(CStaticInoutCyclic.DataId, 1, xPos - 1);
        xTrDate := DatabaseToDatetime(Copy(CStaticInoutCyclic.DataId, xPos + 1, MaxInt));
        xDone := TPlannedDone.CreateObject(PlannedDoneProxy, False);
        xDone.idPlannedMovement := xTrMove;
        xDone.triggerDate := xTrDate;
        xDone.doneState := CDoneOperation;
        xDone.doneDate := regDate;
        xDone.description := description;
        xDone.cash := cash;
        idPlannedDone := xDone.id;
      end else begin
        xDone := TPlannedDone(TPlannedDone.LoadObject(PlannedDoneProxy, idPlannedDone, False));
        xDone.cash := cash;
        xDone.description := description;
        xDone.doneDate := regDate;
      end;
    end;
  end;
end;

function TCMovementForm.ChoosePlanned(var AId, AText: String): Boolean;
var xType: TBaseEnumeration;
begin
  if (ComboBoxType.ItemIndex = 3) then begin
    xType := COutProduct;
  end else begin
    xType := CInProduct;
  end;
  Result := TCFrameForm.ShowFrame(TCDoneFrame, AId, AText, TDoneFrameAdditionalData.Create(xType));
end;

procedure TCMovementForm.CStaticInoutCyclicGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := ChoosePlanned(ADataGid, AText);
end;

procedure TCMovementForm.CStaticInoutCyclicChanged(Sender: TObject);
var xId: TDataGid;
    xPos: Integer;
    xPlan: TPlannedMovement;
begin
  GDataProvider.BeginTransaction;
  xPos := Pos('|', CStaticInoutCyclic.DataId);
  xId := Copy(CStaticInoutCyclic.DataId, 1, xPos - 1);
  xPlan := TPlannedMovement(TPlannedMovement.LoadObject(PlannedMovementProxy, xId, False));
  CStaticInoutCyclicAccount.DataId := xPlan.idAccount;
  if xPlan.idAccount <> CEmptyDataGid then begin
    CStaticInoutCyclicAccount.Caption := TAccount(TAccount.LoadObject(AccountProxy, xPlan.idAccount, False)).name;
  end;
  CStaticInoutCyclicCategory.DataId := xPlan.idProduct;
  if xPlan.idProduct <> CEmptyDataGid then begin
    CStaticInoutCyclicCategory.Caption := TProduct(TProduct.LoadObject(ProductProxy, xPlan.idProduct, False)).name;
  end;
  CStaticInoutCyclicCashpoint.DataId := xPlan.idCashPoint;
  if xPlan.idCashPoint <> CEmptyDataGid then begin
    CStaticInoutCyclicCashpoint.Caption := TCashPoint(TCashPoint.LoadObject(CashPointProxy, xPlan.idCashPoint, False)).name;
  end;
  CCurrEditInoutCyclic.Value := xPlan.cash;
  GDataProvider.RollbackTransaction;
  UpdateDescription;
end;

constructor TMovementAdditionalData.Create(ATriggerDate: TDateTime; APlanned: TDataObject);
begin
  inherited Create;
  FtriggerDate := ATriggerDate;
  Fplanned := APlanned;
end;

procedure TCMovementForm.UpdateFrames(ADataGid: TDataGid; AMessage, AOption: Integer);
var xId: TDataGid;
    xI: Integer;
begin
  inherited UpdateFrames(ADataGid, AMessage, AOption);
  xI := ComboBoxType.ItemIndex;
  if (xI = 0) or (xI = 1) then begin
    xId := CStaticInoutOnceAccount.DataId;
    SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTEDITED, Integer(@xId), 0);
    if Operation = coEdit then begin
      if FbaseAccount <> xId then begin
        SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTEDITED, Integer(@FbaseAccount), 0);
      end;
    end;
  end else if (xI = 2) then begin
    xId := CStaticTransDestAccount.DataId;
    SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTEDITED, Integer(@xId), 0);
    if Operation = coEdit then begin
      if FbaseAccount <> xId then begin
        SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTEDITED, Integer(@FbaseAccount), 0);
      end;
    end;
    xId := CStaticTransSourceAccount.DataId;
    SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTEDITED, Integer(@xId), 0);
    if Operation = coEdit then begin
      if FsourceAccount <> xId then begin
        SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTEDITED, Integer(@FsourceAccount), 0);
      end;
    end;
  end else if (xI = 3) or (xI = 4) then begin
    xId := CStaticInoutCyclicAccount.DataId;
    SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTEDITED, Integer(@xId), 0);
    if Operation = coEdit then begin
      if FbaseAccount <> xId then begin
        SendMessageToFrames(TCAccountsFrame, WM_DATAOBJECTEDITED, Integer(@FbaseAccount), 0);
      end;
    end;
    SendMessageToFrames(TCDoneFrame, WM_DATAREFRESH, 0, 0);
  end;
  if FbaseList <> CEmptyDataGid then begin
    SendMessageToFrames(TCMovementFrame, WM_DATAOBJECTEDITED, Integer(@FBaseList), WMOPT_MOVEMENTLIST);
  end;
end;

function TCMovementForm.GetUpdateFrameOption: Integer;
begin
  Result := WMOPT_BASEMOVEMENT;
end;

function TCMovementForm.GetUpdateFrameClass: TCBaseFrameClass;
begin
  Result := TCMovementFrame;
end;

procedure TCMovementForm.ActionTemplateExecute(Sender: TObject);
var xPattern: String;
begin
  if EditDescPattern(CDescPatternsKeys[0][ComboBoxType.ItemIndex], xPattern) then begin
  end;
end;

procedure TCMovementForm.ActionAddExecute(Sender: TObject);
var xData: TObjectList;
begin
  xData := TObjectList.Create(False);
  xData.Add(GBaseTemlatesList);
  xData.Add(GMovementTemplatesList);
  EditAddTemplate(xData, Self, RichEditDesc);
end;

end.
