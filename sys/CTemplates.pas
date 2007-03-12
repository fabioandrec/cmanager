unit CTemplates;

interface

uses Contnrs;

type
  IDescTemplateExpander = interface
    function ExpandTemplate(ATemplate: String): String;
  end;

  TDescTemplate = class(TObject)
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

  TDescTemplateList = class(TObjectList)
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

implementation

uses Classes, SysUtils;

constructor TDescTemplate.Create(ASymbol, ADescription: String);
begin
  inherited Create;
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
  inherited Create(True);
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
  GMovementListTemplatesList := TDescTemplateList.Create('Mnemoniki list operacji');
  GPlannedMovementTemplatesList := TDescTemplateList.Create('Mnemoniki planowanych operacji');
  GMovementListElementsTemplatesList := TDescTemplateList.Create('Mnemoniki elementów listy operacji');
  with GBaseTemlatesList do begin
    AddTemplate('@godz', 'aktualna godzina w formacie HH');
    AddTemplate('@min', 'aktualna minuta w formacie MM');
    AddTemplate('@czas', 'aktualny czas w formacie HH:MM');
    AddTemplate('@dzien', 'aktualny dzieñ w formacie DD');
    AddTemplate('@miesiac', 'aktualny miesiac w formacie MM');
    AddTemplate('@rok', 'aktualny rok w formacie RRRR');
    AddTemplate('@rokkrotki', 'aktualny rok w formacie RR');
    AddTemplate('@dzientygodnia', 'numer dnia w tygodni');
    AddTemplate('@nazwadnia', 'nazwa dnia');
    AddTemplate('@nazwamiesiaca', 'nazwa miesi¹ca');
    AddTemplate('@data', 'aktualna data w formacie DD-MM-RRRR');
    AddTemplate('@dataczas', 'aktualna data i czas w formacie DD-MM-RRRR HH:MM');
    AddTemplate('@wersja', 'wersja programu CManager');
  end;
  with GBaseMovementTemplatesList do begin
    AddTemplate('@dataoperacji', 'data operacji w formacie DD-MM-RRRR');
    AddTemplate('@rodzaj', 'rodzaj operacji');
    AddTemplate('@kontozrodlowe', 'nazwa konta Ÿród³owego dla operacji');
    AddTemplate('@kontodocelowe', 'nazwa konta docelowego dla operacji');
    AddTemplate('@kategria', 'nazwa kategorii wybranej w operacji');
    AddTemplate('@kontrahent', 'nazwa kontrahenta wybranego w operacji');
  end;
finalization
  GMovementListElementsTemplatesList.Free;
  GBaseTemlatesList.Free;
  GPlannedMovementTemplatesList.Free;
  GBaseMovementTemplatesList.Free;
  GMovementListTemplatesList.Free;
end.
