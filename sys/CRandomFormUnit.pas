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
    Label4: TLabel;
    CIntEdit2: TCIntEdit;
    Label5: TLabel;
    CIntEdit3: TCIntEdit;
    Label6: TLabel;
    CIntEdit4: TCIntEdit;
    BitBtnOk: TBitBtn;
    BitBtn1: TBitBtn;
    GroupBox3: TGroupBox;
    Label3: TLabel;
    CIntEdit1: TCIntEdit;
    Label7: TLabel;
    CIntEdit5: TCIntEdit;
    Label8: TLabel;
    CIntEdit6: TCIntEdit;
    Label9: TLabel;
    CIntEdit7: TCIntEdit;
    Label10: TLabel;
    CIntEdit8: TCIntEdit;
    Label11: TLabel;
    CIntEdit9: TCIntEdit;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtnOkClick(Sender: TObject);
  public
    procedure FillDatabaseExampleData(ADateFrom, ADateTo: TDateTime; AOutCount, AInCount, ATransferCount, AAcountCount, ACashpointCount, AProductCount, ACurrenciesCount, AUnitdefsCount, AInstrumentsCount: Integer);
  end;

procedure FillDatabaseExampleData;

implementation

uses CDatabase, CDatatools, CDataObjects, CConsts, Math, DateUtils,
  CWaitFormUnit, CProgressFormUnit, CInfoFormUnit, CTools;

{$R *.dfm}

procedure FillDatabaseExampleData;
var xForm: TCRandomForm;
begin
  xForm := TCRandomForm.Create(Application);
  xForm.ShowModal;
  xForm.Free;
end;

procedure TCRandomForm.FillDatabaseExampleData(ADateFrom, ADateTo: TDateTime; AOutCount, AInCount, ATransferCount, AAcountCount, ACashpointCount, AProductCount, ACurrenciesCount, AUnitdefsCount, AInstrumentsCount: Integer);
var xCount: Integer;
    xDate: TDateTime;
    xAccounts: TDataObjectList;
    xCashpoints: TDataObjectList;
    xInproducts: TDataObjectList;
    xOutproducts: TDataObjectList;
    xCurdefs: TDataObjectList;
    xInstdefs: TDataObjectList;
    xUnitdefs: TDataObjectList;
    xProduct: TProduct;
    xAccount, xSourceAccount: TAccount;
    xCashpoint: TCashPoint;
    xTries: Integer;
    xA, xB: Integer;
    xRate, xPrevRate: TCurrencyRate;
    xSCurDef, xTCurDef, xMovementCurrency: TCurrencyDef;
    xRateCashpointId: TDataGid;
    xHelper: TCurrencyRateHelper;
    xCurInst: TInstrument;
    xInstValue: TInstrumentValue;
begin
  BitBtnOk.Enabled := False;
  BitBtn1.Enabled := False;
  Application.ProcessMessages;
  GDataProvider.BeginTransaction;
  ShowWaitForm(wtProgressbar, 'Trwa generowanie konfiguracji...', 0, ACurrenciesCount + ACashpointCount + AAcountCount + AProductCount + AUnitdefsCount + AInstrumentsCount);
  for xCount := 1 to ACurrenciesCount do begin
    with TCurrencyDef.CreateObject(CurrencyDefProxy, False) do begin
      name := 'Waluta ' + IntToStr(xCount);
      description := name;
      symbol := 'W' + IntToStr(xCount);
      iso := symbol;
      isBase := False;
      StepWaitForm(1);
    end;
  end;
  for xCount := 1 to AUnitdefsCount do begin
    with TUnitDef.CreateObject(UnitDefProxy, False) do begin
      name := 'Jednostka ' + IntToStr(xCount);
      description := name;
      symbol := 'jm' + IntToStr(xCount);
      StepWaitForm(1);
    end;
  end;
  GDataProvider.PostProxies;
  Randomize;
  xCurdefs := TCurrencyDef.GetList(TCurrencyDef, CurrencyDefProxy, 'select * from currencyDef');
  xUnitdefs := TUnitDef.GetList(TUnitDef, UnitDefProxy, 'select * from unitDef');
  for xCount := 1 to AAcountCount do begin
    with TAccount.CreateObject(AccountProxy, False) do begin
      accountType := CCashAccount;
      name := 'konto ' + IntToStr(xCount);
      description := name;
      initialBalance := 0;
      idCurrencyDef := xCurdefs.Items[Random(xCurdefs.Count)].id;
      cash := 0;
      StepWaitForm(1);
    end;
  end;
  for xCount := 1 to ACashpointCount do begin
    with TCashPoint.CreateObject(CashPointProxy, False) do begin
      name := 'kontrahent ' + IntToStr(xCount);
      description := name;
      cashpointType := CCashpointTypeAll;
      StepWaitForm(1);
    end;
  end;
  Randomize;
  xCashpoints := TCashPoint.GetList(TCashPoint, CashPointProxy, 'select * from cashpoint');
  for xCount := 1 to AInstrumentsCount do begin
    with TInstrument.CreateObject(InstrumentProxy, False) do begin
      name := 'instrument ' + IntToStr(xCount);
      description := name;
      instrumentType := RandomFrom(StringToStringArray(CInstrumentTypeIndex + '|' +
                                                       CInstrumentTypeStock + '|' +
                                                       CInstrumentTypeBond + '|' +
                                                       CInstrumentTypeFundinv + '|' +
                                                       CInstrumentTypeFundret + '|' +
                                                       CInstrumentTypeUndefined, '|'));
      idCurrencyDef := xCurdefs.Items[Random(xCurdefs.Count)].id;
      idCashpoint := xCashpoints.Items[Random(xCashpoints.Count)].id;
      StepWaitForm(1);
    end;
  end;
  Randomize;
  for xCount := 1 to AProductCount do begin
    with TProduct.CreateObject(ProductProxy, False) do begin
      name := 'Produkt ' + IntToStr(xCount);
      description := name;
      idParentProduct := CEmptyDataGid;
      productType := IfThen(Random(2) = 0, CInMovement, COutMovement);
      if Random(10) < 7 then begin
        idUnitDef := xUnitdefs.Items[Random(xUnitdefs.Count)].id;
      end else begin
        idUnitDef := CEmptyDataGid;
      end;
      StepWaitForm(1);
    end;
  end;
  StepWaitForm(0, 'Zatwierdzanie zmian...');
  GDataProvider.CommitTransaction;
  xCurdefs.Free;
  xCashpoints.Free;
  GDataProvider.BeginTransaction;
  xRateCashpointId := GDataProvider.GetSqlString('select idCashpoint from cashpoint where name = ''NBP''', CEmptyDataGid);
  if xRateCashpointId = CEmptyDataGid then begin
    xCashpoint := TCashPoint.CreateObject(CashPointProxy, False);
    xCashpoint.name := 'NBP';
    xCashpoint.description := xCashpoint.name;
    xCashpoint.cashpointType := CCashpointTypeAll;
    xRateCashpointId := xCashpoint.id;
  end;
  xCurdefs := TCurrencyDef.GetList(TCurrencyDef, CurrencyDefProxy, 'select * from currencyDef');
  InitWaitForm('Trwa generowanie kursów...', 0, xCurdefs.Count);
  for xA := 0 to xCurdefs.Count - 1 do begin
    for xB := 0 to xCurdefs.Count - 1 do begin
      if xA <> xB then begin
        xDate := ADateFrom;
        xPrevRate := Nil;
        while (xDate <= ADateTo) do begin
          xSCurDef := TCurrencyDef(xCurdefs.Items[xA]);
          xTCurDef := TCurrencyDef(xCurdefs.Items[xB]);
          xRate := TCurrencyRate.FindRate(CCurrencyRateTypeAverage, xSCurDef.id, xTCurDef.id, xRateCashpointId, xDate);
          if xRate = Nil then begin
            xRate := TCurrencyRate.CreateObject(CurrencyRateProxy, False);
            xRate.idCashpoint := xRateCashpointId;
            xRate.idSourceCurrencyDef := xSCurDef.id;
            xRate.idTargetCurrencyDef := xTCurDef.id;
            xRate.rateType := CCurrencyRateTypeAverage;
            xRate.description := xSCurDef.iso + '/' + xTCurDef.iso;
            xRate.bindingDate := xDate;
            if xPrevRate = Nil then begin
              xRate.quantity := 1;
              xRate.rate := 1 + RandomRange(1, 4) / RandomRange(1, 5);
              xPrevRate := xRate;
            end else begin
              xRate.quantity := xPrevRate.quantity;
              xRate.rate := xPrevRate.rate + IfThen(RandomRange(1, 2) = 1, 1, -1) * (RandomRange(1, 10) / 100) * xPrevRate.rate;
            end;
          end;
          xDate := IncDay(xDate);
        end;
      end;
    end;
    GDataProvider.PostProxies;
    StepWaitForm(1);
  end;
  xInstdefs := TInstrument.GetList(TInstrument, InstrumentProxy, 'select * from instrument');
  InitWaitForm('Trwa generowanie notowañ...', 0, xCurdefs.Count);
  for xA := 0 to xInstdefs.Count - 1 do begin
    xDate := ADateFrom;
    xCurInst := TInstrument(xInstdefs.Items[xA]);
    while (xDate <= ADateTo) do begin
      for xB := 0 to 23 do begin
        xInstValue := TInstrumentValue.CreateObject(InstrumentValueProxy, False);
        xInstValue.idInstrument := xCurInst.id;
        xInstValue.description := xCurInst.name;
        xInstValue.regDateTime := xDate + EncodeTime(xB, 0, 0, 0);
        xInstValue.valueOf := 1 + RandomRange(1, 5) / RandomRange(1, 5);
      end;
      xDate := IncDay(xDate);
    end;
    GDataProvider.PostProxies;
    StepWaitForm(1);
  end;
  StepWaitForm(0, 'Zatwierdzanie zmian...');
  GDataProvider.CommitTransaction;
  xCurdefs.Free;
  xInstdefs.Free;
  InitWaitForm('Trwa generowanie danych...', 0, DaysBetween(ADateFrom, ADateTo));
  xDate := ADateFrom;
  xAccounts := TAccount.GetList(TAccount, AccountProxy, 'select * from account');
  xCashpoints := TCashPoint.GetList(TCashPoint, CashPointProxy, 'select * from cashpoint');
  xInproducts := TProduct.GetList(TProduct, ProductProxy, 'select * from product where productType = ''' + CInProduct + '''');
  xOutproducts := TProduct.GetList(TProduct, ProductProxy, 'select * from product where productType = ''' + COutProduct + '''');
  xCurdefs := TCurrencyDef.GetList(TCurrencyDef, CurrencyDefProxy, 'select * from currencyDef');
  while (xDate <= ADateTo) do begin
    for xCount := 1 to AOutCount do begin
      GDataProvider.BeginTransaction;
      with TBaseMovement.CreateObject(BaseMovementProxy, False) do begin
        xAccount := TAccount(xAccounts.Items[Random(xAccounts.Count)]);
        xMovementCurrency := TCurrencyDef(xCurdefs.Items[Random(xCurdefs.Count)]);
        idAccountCurrencyDef := xAccount.idCurrencyDef;
        idMovementCurrencyDef := xMovementCurrency.id;
        xProduct := TProduct(xOutproducts.Items[Random(xOutproducts.Count)]);
        idUnitDef := xProduct.idUnitDef;
        if idUnitDef <> CEmptyDataGid then begin
          quantity := RandomRange(1, 20);
        end;
        xCashpoint := TCashPoint(xCashpoints.Items[Random(xCashpoints.Count)]);
        description := xProduct.name;
        if idMovementCurrencyDef <> idAccountCurrencyDef then begin
          xRate := TCurrencyRate.FindRate(CCurrencyRateTypeAverage, idMovementCurrencyDef, idAccountCurrencyDef, xRateCashpointId, xDate);
          currencyQuantity := xRate.quantity;
          currencyRate := xRate.rate;
          rateDescription := xRate.description;
          idCurrencyRate := xRate.id;
        end else begin
          currencyQuantity := 1;
          currencyRate := 1;
          rateDescription := '';
          idCurrencyRate := CEmptyDataGid;
        end;
        movementCash := Random(50) + RandomRange(1, 99) / 100;
        if idMovementCurrencyDef <> idAccountCurrencyDef then begin
          xHelper := TCurrencyRateHelper.Create(currencyQuantity, currencyRate, rateDescription, idMovementCurrencyDef, idAccountCurrencyDef);
          cash := xHelper.ExchangeCurrency(movementCash, idAccountCurrencyDef, idMovementCurrencyDef);
          xHelper.Free;
        end else begin
           cash := movementCash;
        end;
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
        xMovementCurrency := TCurrencyDef(xCurdefs.Items[Random(xCurdefs.Count)]);
        idAccountCurrencyDef := xAccount.idCurrencyDef;
        idMovementCurrencyDef := xMovementCurrency.id;
        xProduct := TProduct(xInproducts.Items[Random(xInproducts.Count)]);
        idUnitDef := xProduct.idUnitDef;
        if idUnitDef <> CEmptyDataGid then begin
          quantity := RandomRange(1, 20);
        end;
        xCashpoint := TCashPoint(xCashpoints.Items[Random(xCashpoints.Count)]);
        description := xProduct.name;
        if idMovementCurrencyDef <> idAccountCurrencyDef then begin
          xRate := TCurrencyRate.FindRate(CCurrencyRateTypeAverage, idMovementCurrencyDef, idAccountCurrencyDef, xRateCashpointId, xDate);
          currencyQuantity := xRate.quantity;
          currencyRate := xRate.rate;
          rateDescription := xRate.description;
          idCurrencyRate := xRate.id;
        end else begin
          currencyQuantity := 1;
          currencyRate := 1;
          rateDescription := '';
          idCurrencyRate := CEmptyDataGid;
        end;
        movementCash := Random(50) + RandomRange(1, 99) / 100;
        if idMovementCurrencyDef <> idAccountCurrencyDef then begin
          xHelper := TCurrencyRateHelper.Create(currencyQuantity, currencyRate, rateDescription, idMovementCurrencyDef, idAccountCurrencyDef);
          cash := xHelper.ExchangeCurrency(movementCash, idAccountCurrencyDef, idMovementCurrencyDef);
          xHelper.Free;
        end else begin
           cash := movementCash;
        end;
        movementType := CInMovement;
        idAccount := xAccount.id;
        regDate := xDate;
        idCashPoint := xCashpoint.id;
        idProduct := xProduct.id;
      end;
      GDataProvider.CommitTransaction;
    end;
    for xCount := 1 to ATransferCount do begin
      GDataProvider.BeginTransaction;
      xTries := 0;
      repeat
        xAccount := TAccount(xAccounts.Items[Random(xAccounts.Count)]);
        xSourceAccount := TAccount(xAccounts.Items[Random(xAccounts.Count)]);
        Inc(xTries);
      until (xTries > 3) or (xAccount.id <> xSourceAccount.id);
      if xAccount.id <> xSourceAccount.id then begin
        with TBaseMovement.CreateObject(BaseMovementProxy, False) do begin
          idAccount := xAccount.id;
          idAccountCurrencyDef := xAccount.idCurrencyDef;
          idSourceAccount := xSourceAccount.id;
          idMovementCurrencyDef := xSourceAccount.idCurrencyDef;
          if (idMovementCurrencyDef <> idAccountCurrencyDef) then begin
            xRate := TCurrencyRate.FindRate(CCurrencyRateTypeAverage, idAccountCurrencyDef, idMovementCurrencyDef, xRateCashpointId, xDate);
            currencyQuantity := xRate.quantity;
            currencyRate := xRate.rate;
            rateDescription := xRate.description;
            idCurrencyRate := xRate.id;
          end else begin
            currencyQuantity := 1;
            currencyRate := 1;
            rateDescription := '';
            idCurrencyRate := CEmptyDataGid;
          end;
          idUnitDef := CEmptyDataGid;
          description := 'Transfer z ' + xSourceAccount.name + ' do ' + xAccount.name;
          movementCash := Random(500) + RandomRange(1, 99) / 100;
          if idMovementCurrencyDef <> idAccountCurrencyDef then begin
            xHelper := TCurrencyRateHelper.Create(currencyQuantity, currencyRate, rateDescription, idMovementCurrencyDef, idAccountCurrencyDef);
            cash := xHelper.ExchangeCurrency(movementCash, idAccountCurrencyDef, idMovementCurrencyDef);
            xHelper.Free;
          end else begin
            cash := movementCash;
          end;
          movementType := CTransferMovement;
          regDate := xDate;
        end;
      end;
      GDataProvider.CommitTransaction;
    end;
    StepWaitForm(1);
    xDate := IncDay(xDate);
  end;
  xCurdefs.Free;
  xAccounts.Free;
  xCashpoints.Free;
  xInproducts.Free;
  xOutproducts.Free;
  xUnitdefs.Free;
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
  if ShowInfo(itQuestion, 'Czy rzeczywiœcie chcesz wype³niæ aktualny plik danych losowymi operacjami i innymi danymi konfiguracyjnymi?', '') then begin
    FillDatabaseExampleData(CDateTime1.Value, CDateTime2.Value, CIntEdit1.Value, CIntEdit5.Value, CIntEdit6.Value, CIntEdit2.Value, CIntEdit3.Value, CIntEdit4.Value, CIntEdit7.Value, CIntEdit8.Value, CIntEdit9.Value);
    CloseForm;
  end;
end;

end.
