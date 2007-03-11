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
    GMovementTemplatesList: TDescTemplateList;

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
  GMovementTemplatesList := TDescTemplateList.Create('Mnemoniko wykonanych operacji');
  with GBaseTemlatesList do begin
    AddTemplate('@godz', 'aktualna godzina w formacie HH');
  end;
  with GMovementTemplatesList do begin
    AddTemplate('@data', 'data operacji w formacie DD-MM-RRRR');
  end;
finalization
  GBaseTemlatesList.Free;
  GMovementTemplatesList.Free;
end.
