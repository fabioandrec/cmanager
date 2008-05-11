unit CTemplates;

interface

uses Contnrs, CComponents;

type
  IDescTemplateExpander = interface
    function ExpandTemplate(ATemplate: String): String;
  end;

  TDescTemplate = class(TCListDataElement)
  private
    Fsymbol: String;
    Fdescription: String;
  public
    constructor Create(ASymbol, ADescription: String);
    function GetValue(AExpander: IDescTemplateExpander): String;
  published
    property symbol: String read Fsymbol;
    property description: String read Fdescription;
  end;

  TDescTemplateList = class(TCListDataElement)
  private
    Fname: String;
    function GetItems(AIndex: Integer): TDescTemplate;
    procedure SetItems(AIndex: Integer; const Value: TDescTemplate);
  public
    constructor Create(AName: String);
    function ExpandTemplates(ADescription: String; AExpander: IDescTemplateExpander): String;
    procedure AddTemplate(ASymbol: String; ADescription: String);
    property Items[AIndex: Integer]: TDescTemplate read GetItems write SetItems;
  published
    property name: String read Fname;
  end;

var GBaseTemlatesList: TDescTemplateList;
    GBaseMovementTemplatesList: TDescTemplateList;
    GMovementListTemplatesList: TDescTemplateList;
    GMovementListElementsTemplatesList: TDescTemplateList;
    GPlannedMovementTemplatesList: TDescTemplateList;
    GCurrencydefTemplatesList: TDescTemplateList;
    GAccountExtractionTemplatesList: TDescTemplateList;
    GExtractionItemTemplatesList: TDescTemplateList;
    GInstrumentValueTemplatesList: TDescTemplateList;
    GInvestmentMovementTemplatesList: TDescTemplateList;
    GDepositInvestmentTemplatesList: TDescTemplateList;

implementation

uses Classes, SysUtils;

constructor TDescTemplate.Create(ASymbol, ADescription: String);
begin
  inherited Create(False, Nil, Nil, False, False);
  Fsymbol := ASymbol;
  Fdescription := ADescription;
end;

function TDescTemplate.GetValue(AExpander: IDescTemplateExpander): String;
begin
  Result := AExpander.ExpandTemplate(Fsymbol);
end;

procedure TDescTemplateList.AddTemplate(ASymbol, ADescription: String);
begin
  Add(TDescTemplate.Create(ASymbol, ADescription));
end;

constructor TDescTemplateList.Create(AName: String);
begin
  inherited Create(False, Nil, Nil, False, False);
  Fname := AName;
end;

function TDescTemplateList.ExpandTemplates(ADescription: String; AExpander: IDescTemplateExpander): String;
var xCount: Integer;
    xItem: TDescTemplate;
    xValue: String;
begin
  Result := ADescription;
  for xCount := 0 to Count - 1 do begin
    xItem := Items[xCount];
    if Pos(xItem.symbol, Result) > 0 then begin
      xValue := xItem.GetValue(AExpander);
      Result := StringReplace(Result, xItem.symbol, xValue, [rfReplaceAll, rfIgnoreCase]);
    end;
  end;
end;

function TDescTemplateList.GetItems(AIndex: Integer): TDescTemplate;
begin
  Result := TDescTemplate(inherited Items[AIndex]);
end;

procedure TDescTemplateList.SetItems(AIndex: Integer; const Value: TDescTemplate);
begin
  inherited Items[AIndex] := Value;
end;

initialization
  GBaseTemlatesList := TDescTemplateList.Create('Mnemoniki podstawowe');
  GBaseMovementTemplatesList := TDescTemplateList.Create('Mnemoniki wykonanych operacji');
  GAccountExtractionTemplatesList := TDescTemplateList.Create('Mnemoniki wyci¹gów');
  GExtractionItemTemplatesList := TDescTemplateList.Create('Mnemoniki elementów wyci¹gu');
  GMovementListTemplatesList := TDescTemplateList.Create('Mnemoniki list operacji');
  GPlannedMovementTemplatesList := TDescTemplateList.Create('Mnemoniki planowanych operacji');
  GMovementListElementsTemplatesList := TDescTemplateList.Create('Mnemoniki elementów listy operacji');
  GCurrencydefTemplatesList := TDescTemplateList.Create('Mnemoniki kursów walut');
  GInstrumentValueTemplatesList := TDescTemplateList.Create('Mnemoniki notowañ instrumentów inwestycyjnych');
  GInvestmentMovementTemplatesList := TDescTemplateList.Create('Mnemoniki operacji inwestycyjnych');
  GDepositInvestmentTemplatesList :=  TDescTemplateList.Create('Mnemoniki lokat');
  with GBaseTemlatesList do begin
    AddTemplate('@godz@', 'aktualna godzina w formacie HH');
    AddTemplate('@min@', 'aktualna minuta w formacie MM');
    AddTemplate('@czas@', 'aktualny czas w formacie HH:MM');
    AddTemplate('@dzien@', 'aktualny dzieñ w formacie DD');
    AddTemplate('@miesiac@', 'aktualny miesiac w formacie MM');
    AddTemplate('@rok@', 'aktualny rok w formacie RRRR');
    AddTemplate('@rokkrotki@', 'aktualny rok w formacie RR');
    AddTemplate('@dzientygodnia@', 'numer dnia w tygodniu');
    AddTemplate('@nazwadnia@', 'nazwa dnia');
    AddTemplate('@nazwamiesiaca@', 'nazwa miesi¹ca');
    AddTemplate('@data@', 'aktualna data w formacie RRRR-MM-DD');
    AddTemplate('@dataczas@', 'aktualna data i czas w formacie RRRR-MM-DD HH:MM');
    AddTemplate('@wersja@', 'wersja programu CManager');
  end;
  with GBaseMovementTemplatesList do begin
    AddTemplate('@dataoperacji@', 'data operacji w formacie RRRR-MM-DD');
    AddTemplate('@rodzaj@', 'rodzaj operacji');
    AddTemplate('@kontozrodlowe@', 'nazwa konta Ÿród³owego dla operacji');
    AddTemplate('@kontodocelowe@', 'nazwa konta docelowego dla operacji');
    AddTemplate('@kategoria@', 'nazwa kategorii wybranej w operacji');
    AddTemplate('@pelnakategoria@', 'pe³na nazwa kategorii wybranej w operacji');
    AddTemplate('@kontrahent@', 'nazwa kontrahenta wybranego w operacji');
    AddTemplate('@isowalutykonta@', 'iso waluty konta');
    AddTemplate('@isowalutyoperacji@', 'iso waluty operacji');
    AddTemplate('@symbolwalutykonta@', 'symbol waluty konta');
    AddTemplate('@symbolwalutyoperacji@', 'symbol waluty operacji');
    AddTemplate('@przelicznik@', 'opis przelicznika waluty');
  end;
  with GMovementListTemplatesList do begin
    AddTemplate('@dataoperacji@', 'data operacji w formacie RRRR-MM-DD');
    AddTemplate('@rodzaj@', 'rodzaj operacji');
    AddTemplate('@kontozrodlowe@', 'nazwa konta Ÿród³owego dla operacji');
    AddTemplate('@kontrahent@', 'nazwa kontrahenta wybranego w operacji');
    AddTemplate('@isowalutykonta@', 'iso waluty konta');
    AddTemplate('@symbolwalutykonta@', 'symbol waluty konta');
  end;
  with GPlannedMovementTemplatesList do begin
    AddTemplate('@status@', 'aktywnoœæ planowanej operacji');
    AddTemplate('@rodzaj@', 'rodzaj operacji');
    AddTemplate('@kontozrodlowe@', 'nazwa konta Ÿród³owego dla operacji');
    AddTemplate('@kontodocelowe@', 'nazwa konta docelowego dla operacji');
    AddTemplate('@kategoria@', 'nazwa kategorii wybranej w operacji');
    AddTemplate('@pelnakategoria@', 'pe³na nazwa kategorii wybranej w operacji');
    AddTemplate('@kontrahent@', 'nazwa kontrahenta wybranego w operacji');
    AddTemplate('@harmonogram@', 'opis harmonogramu wykonywania');
    AddTemplate('@pelnakategoria@', 'pe³na nazwa kategorii wybranej w operacji');
  end;
  with GMovementListElementsTemplatesList do begin
    AddTemplate('@kategoria@', 'nazwa kategorii wybranej w operacji');
    AddTemplate('@pelnakategoria@', 'pe³na nazwa kategorii wybranej w operacji');
    AddTemplate('@dataoperacji@', 'data operacji w formacie RRRR-MM-DD');
    AddTemplate('@rodzaj@', 'rodzaj operacji');
    AddTemplate('@kontozrodlowe@', 'nazwa konta Ÿród³owego dla operacji');
    AddTemplate('@kontrahent@', 'nazwa kontrahenta wybranego w operacji');
    AddTemplate('@isowalutykonta@', 'iso waluty konta');
    AddTemplate('@isowalutyoperacji@', 'iso waluty operacji');
    AddTemplate('@symbolwalutykonta@', 'symbol waluty konta');
    AddTemplate('@symbolwalutyoperacji@', 'symbol waluty operacji');
    AddTemplate('@przelicznik@', 'opis przelicznika waluty');
  end;
  with GCurrencydefTemplatesList do begin
    AddTemplate('@datakursu@', 'data kursu w formacie RRRR-MM-DD');
    AddTemplate('@isobazowej@', 'symbol ISO waluty bazowej');
    AddTemplate('@isodocelowej@', 'symbol ISO waluty docelowej');
    AddTemplate('@symbolbazowej@', 'symbol waluty bazowej');
    AddTemplate('@symboldocelowej@', 'symbol waluty docelowej');
    AddTemplate('@kontrahent@', 'kontrahent okreœlaj¹cy kurs');
    AddTemplate('@typ@', 'typ kursu');
    AddTemplate('@ilosc@', 'iloœæ waluty bazowej');
    AddTemplate('@kurs@', 'kurs waluty');
  end;
  with GExtractionItemTemplatesList do begin
    AddTemplate('@dataoperacji@', 'data operacji w formacie RRRR-MM-DD');
    AddTemplate('@dataksiêgowania@', 'data ksiêgowania w formacie RRRR-MM-DD');
    AddTemplate('@rodzaj@', 'rodzaj operacji');
    AddTemplate('@konto@', 'nazwa konta, którego dotyczy wyci¹g');
    AddTemplate('@isowaluty@', 'iso waluty operacji');
    AddTemplate('@symbolwaluty@', 'symbol waluty operacji');
  end;
  with GAccountExtractionTemplatesList do begin
    AddTemplate('@datawyciagu@', 'data wyci¹gu w formacie RRRR-MM-DD');
    AddTemplate('@oddaty@', 'data pocz¹tku wyci¹gu w formacie RRRR-MM-DD');
    AddTemplate('@dodaty@', 'data koñca wyci¹gu w formacie RRRR-MM-DD');
    AddTemplate('@konto@', 'nazwa konta, którego dotyczy wyci¹g');
    AddTemplate('@status@', 'status wyci¹gu');
  end;
  with GInstrumentValueTemplatesList do begin
    AddTemplate('@datanotowania@', 'data notowania w formacie RRRR-MM-DD');
    AddTemplate('@dataczasnotowania@', 'data i czas notowania w formacie RRRR-MM-DD HH:MM');
    AddTemplate('@symbol@', 'symbol instrumentu inwestycyjnego');
    AddTemplate('@instrument@', 'nazwa instrumentu inwestycyjnego');
    AddTemplate('@rodzaj@', 'rodzaj instrumentu inwestycyjnego');
  end;
  with GInvestmentMovementTemplatesList do begin
    AddTemplate('@dataoperacji@', 'data notowania w formacie RRRR-MM-DD');
    AddTemplate('@dataczasoperacji@', 'data i czas notowania w formacie RRRR-MM-DD HH:MM');
    AddTemplate('@symbol@', 'symbol instrumentu inwestycyjnego');
    AddTemplate('@instrument@', 'nazwa instrumentu inwestycyjnego');
    AddTemplate('@rodzaj@', 'rodzaj operacji');
    AddTemplate('@konto@', 'nazwa konta Ÿród³owego dla operacji');
    AddTemplate('@kategoria@', 'nazwa kategorii wybranej w operacji');
    AddTemplate('@pelnakategoria@', 'pe³na nazwa kategorii wybranej w operacji');
  end;
  with GDepositInvestmentTemplatesList do begin
    AddTemplate('@data@', 'data otwarcia lokaty w formacie RRRR-MM-DD');
    AddTemplate('@stan@', 'stan lokaty');
    AddTemplate('@operacja@', 'nazwa operacji');
    AddTemplate('@nazwa@', 'nazwa lokaty');
    AddTemplate('@konto@', 'nazwa konta operacji');
    AddTemplate('@kontrahent@', 'nazwa kontrahenta prowadz¹cego lokatê');
    AddTemplate('@kategoria@', 'nazwa kategorii wybranej przy zak³adaniu lokaty');
    AddTemplate('@pelnakategoria@', 'pe³na nazwa kategorii wybranej przy zak³adaniu lokaty');
    AddTemplate('@isowaluty@', 'iso waluty lokaty');
    AddTemplate('@symbolwaluty@', 'symbol waluty lokaty');
    AddTemplate('@iloscOkres@', 'czas trwania lokaty, iloœæ okresów');
    AddTemplate('@typOkres@', 'czas trwania lokaty, typ okresu');
    AddTemplate('@iloscOdsetki@', 'naliczaj odsetki, iloœæ okresów');
    AddTemplate('@typOdsetki@', 'naliczaj odsetki, typ okresu');
  end;
  
finalization
  GDepositInvestmentTemplatesList.Free;
  GInstrumentValueTemplatesList.Free;
  GMovementListElementsTemplatesList.Free;
  GBaseTemlatesList.Free;
  GPlannedMovementTemplatesList.Free;
  GBaseMovementTemplatesList.Free;
  GMovementListTemplatesList.Free;
  GCurrencydefTemplatesList.Free;
  GAccountExtractionTemplatesList.Free;
  GExtractionItemTemplatesList.Free;
  GInvestmentMovementTemplatesList.Free
end.
