unit CRandomFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFormUnit, StrUtils, StdCtrls, CComponents, ComCtrls,
  Buttons;

type
  TCRandomForm = class(TCBaseForm)
    GroupBox1: TGroupBox;
    CDateTime1: TCDateTime;
    CDateTime2: TCDateTime;
    Label1: TLabel;
    Label2: TLabel;
    GroupBox2: TGroupBox;
    CIntEdit1: TCIntEdit;
    Label3: TLabel;
    Label4: TLabel;
    CIntEdit2: TCIntEdit;
    Label5: TLabel;
    CIntEdit3: TCIntEdit;
    Label6: TLabel;
    CIntEdit4: TCIntEdit;
    BitBtnOk: TBitBtn;
    BitBtn1: TBitBtn;
    Label7: TLabel;
    CIntEdit5: TCIntEdit;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtnOkClick(Sender: TObject);
  public
    procedure FillDatabaseExampleData(ADateFrom, ADateTo: TDateTime; AOutCount, AInCount, AAcountCount, ACashpointCount, AProductCount: Integer);
  end;

procedure FillDatabaseExampleData;

implementation

uses CDatabase, CDatatools, CDataObjects, CConsts, Math, DateUtils,
  CWaitFormUnit, CProgressFormUnit;

{$R *.dfm}

procedure FillDatabaseExampleData;
var xForm: TCRandomForm;
begin
  xForm := TCRandomForm.Create(Application);
  xForm.ShowModal;
  xForm.Free;
end;

procedure TCRandomForm.FillDatabaseExampleData(ADateFrom, ADateTo: TDateTime; AOutCount, AInCount, AAcountCount, ACashpointCount, AProductCount: Integer);
var xCount: Integer;
    xDate: TDateTime;
    xAccounts: TDataObjectList;
    xCashpoints: TDataObjectList;
    xInproducts: TDataObjectList;
    xOutproducts: TDataObjectList;
    xProduct: TProduct;
    xAccount: TAccount;
    xCashpoint: TCashPoint;
begin
  BitBtnOk.Enabled := False;
  BitBtn1.Enabled := False;
  Application.ProcessMessages;
  GDataProvider.BeginTransaction;
  ShowWaitForm(wtProgressbar, 'Trwa generowanie danych...', 0, DaysBetween(ADateTo, ADateFrom));
  for xCount := 1 to AAcountCount do begin
    with TAccount.CreateObject(AccountProxy, False) do begin
      accountType := CCashAccount;
      name := 'konto ' + IntToStr(xCount);
      description := name;
      initialBalance := 0;
      idCurrencyDef := CCurrencyDefGid_PLN;
      cash := 0;
    end;
  end;
  for xCount := 1 to ACashpointCount do begin
    with TCashPoint.CreateObject(CashPointProxy, False) do begin
      name := 'kontrahent ' + IntToStr(xCount);
      description := name;
      cashpointType := CCashpointTypeAll;
    end;
  end;
  for xCount := 1 to AProductCount do begin
    with TProduct.CreateObject(ProductProxy, False) do begin
      name := 'Produkt ' + IntToStr(xCount);
      description := name;
      idParentProduct := CEmptyDataGid;
      productType := IfThen(Random(2) = 0, CInMovement, COutMovement);
    end;
  end;
  GDataProvider.CommitTransaction;
  xDate := ADateFrom;
  xAccounts := TAccount.GetList(TAccount, AccountProxy, 'select * from account');
  xCashpoints := TCashPoint.GetList(TCashPoint, CashPointProxy, 'select * from cashpoint');
  xInproducts := TProduct.GetList(TProduct, ProductProxy, 'select * from product where productType = ''' + CInProduct + '''');
  xOutproducts := TProduct.GetList(TProduct, ProductProxy, 'select * from product where productType = ''' + COutProduct + '''');
  while (xDate <= ADateTo) do begin
    for xCount := 1 to AOutCount do begin
      GDataProvider.BeginTransaction;
      with TBaseMovement.CreateObject(BaseMovementProxy, False) do begin
        xAccount := TAccount(xAccounts.Items[Random(xAccounts.Count)]);
        idAccountCurrencyDef := xAccount.idCurrencyDef;
        idMovementCurrencyDef := idAccountCurrencyDef;
        currencyQuantity := 1;
        currencyRate := 1;
        rateDescription := '';
        idCurrencyRate := CEmptyDataGid;
        xProduct := TProduct(xOutproducts.Items[Random(xOutproducts.Count)]);
        xCashpoint := TCashPoint(xCashpoints.Items[Random(xCashpoints.Count)]);
        description := xProduct.name;
        cash := Random(50) + Random;
        movementCash := cash;
        movementType := COutMovement;
        idAccount := xAccount.id;
        regDate := xDate;
        idCashPoint := xCashpoint.id;
        idProduct := xProduct.id;
      end;
      GDataProvider.CommitTransaction;
    end;
    for xCount := 1 to AInCount do begin
      GDataProvider.BeginTransaction;
      with TBaseMovement.CreateObject(BaseMovementProxy, False) do begin
        xAccount := TAccount(xAccounts.Items[Random(xAccounts.Count)]);
        idAccountCurrencyDef := xAccount.idCurrencyDef;
        idMovementCurrencyDef := idAccountCurrencyDef;
        currencyQuantity := 1;
        currencyRate := 1;
        rateDescription := '';
        idCurrencyRate := CEmptyDataGid;
        xProduct := TProduct(xInproducts.Items[Random(xInproducts.Count)]);
        xCashpoint := TCashPoint(xCashpoints.Items[Random(xCashpoints.Count)]);
        description := xProduct.name;
        cash := Random(500) + Random;
        movementCash := cash;
        movementType := CInMovement;
        idAccount := xAccount.id;
        regDate := xDate;
        idCashPoint := xCashpoint.id;
        idProduct := xProduct.id;
      end;
      GDataProvider.CommitTransaction;
    end;
    StepWaitForm(1);
    xDate := IncDay(xDate);
  end;
  xAccounts.Free;
  xCashpoints.Free;
  xInproducts.Free;
  xOutproducts.Free;
  HideWaitForm;
  BitBtnOk.Enabled := True;
  BitBtn1.Enabled := True;
end;

procedure TCRandomForm.FormCreate(Sender: TObject);
begin
  CDateTime1.Value := GWorkDate;
  CDateTime2.Value := GWorkDate;
end;

procedure TCRandomForm.BitBtn1Click(Sender: TObject);
begin
  CloseForm;
end;

procedure TCRandomForm.BitBtnOkClick(Sender: TObject);
begin
  FillDatabaseExampleData(CDateTime1.Value, CDateTime2.Value, CIntEdit1.Value, CIntEdit5.Value, CIntEdit2.Value, CIntEdit3.Value, CIntEdit4.Value);
end;

end.
