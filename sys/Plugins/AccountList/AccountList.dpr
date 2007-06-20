library AccountList;

{$R *.res}

uses
  Windows,
  Dialogs,
  Forms,
  Variants,
  SysUtils,
  Classes,
  AdoInt,
  GraphUtil,
  Graphics,
  CPluginTypes in '..\CPluginTypes.pas',
  CPluginConsts in '..\CPluginConsts.pas',
  CTools in '..\..\Shared\CTools.pas';

var CManInterface: ICManagerInterface;
    CConnection: _Connection;

function Plugin_Initialize(ACManagerInterface: ICManagerInterface): Boolean; stdcall; export;
begin
  CManInterface := ACManagerInterface;
  with CManInterface do begin
    Application.Handle := GetAppHandle;
    SetType(CPLUGINTYPE_HTMLREPORT);
    SetCaption('Aktualny stan posiadania');
    SetDescription('Aktualny stan posiadania');
  end;
  Result := True;
end;

function ColToRgb(AColor: TColor): String;
var xRgb: Integer;
begin
  xRgb := ColorToRGB(AColor);
  Result := '"#' + Format('%.2x%.2x%.2x', [GetRValue(xRgb), GetGValue(xRgb), GetBValue(xRgb)]) + '"';
end;

function Plugin_Execute: OleVariant; stdcall; export;

  function GetBody: String;
  var xBody: TStringList;
      xAccounts: _Recordset;
      xOut: OleVariant;
      xSums: TSumList;
      xIdCurrency: String;
      xCash: Currency;
      xCount: Integer;
  begin
    xBody := TStringList.Create;
    xAccounts := CConnection.Execute('select a.*, c.iso from account a left outer join currencyDef c on c.idCurrencyDef = a.idCurrencyDef', xOut, 0);
    with xAccounts, xBody do begin
      Add('<table class="base" colspan=3>');
      Add('<tr class="head">');
      Add('<td class="headtext" width="65%">Nazwa konta</td>');
      Add('<td class="headcash" width="10%">Waluta</td>');
      Add('<td class="headcash" width="25%">Saldo</td>');
      Add('</tr>');
      Add('</table><hr><table class="base" colspan=3>');
      xCount := 0;
      xSums := TSumList.Create(True);
      while not xAccounts.EOF do begin
        Add('<tr class="' + IsEvenToStr(xCount) + 'base">');
        xCash := xAccounts.Fields.Item['cash'].Value;
        Add('<td class="text" width="65%">' + xAccounts.Fields.Item['name'].Value + '</td>');
        Add('<td class="cash" width="10%">' + xAccounts.Fields.Item['iso'].Value + '</td>');
        Add('<td class="cash" width="25%">' + CurrToStrF(xCash, ffNumber, 2) + '</td>');
        Add('</tr>');
        xIdCurrency := xAccounts.Fields.Item['idCurrencyDef'].Value;
        xSums.AddSum(xIdCurrency, xCash);
        xAccounts.MoveNext;
        Inc(xCount);
      end;
      Add('</table><hr><table class="base" colspan=3>');
      for xCount := 0 to xSums.Count - 1 do begin
        Add('<tr class="' + IsEvenToStr(xCount) + 'sum">');
        if xCount = 0 then begin
          Add('<td class="sumtext" width="65%">Razem</td>');
        end else begin
          Add('<td class="sumtext" width="65%"></td>');
        end;
        Add('<td class="sumcash" width="10%">' + CManInterface.GetCurrencyIso(xSums.Items[xCount].name) + '</td>');
        Add('<td class="sumcash" width="25%">' + CurrToStrF(xSums.Items[xCount].value, ffNumber, 2) + '</td>');
        Add('</tr>');
      end;
      Add('</table>');
      xSums.Free;
    end;
    xAccounts := Nil;
    Result := xBody.Text;
    xBody.Free;
  end;

var xCss: String;
begin
  VarClear(Result);
  CConnection := CManInterface.GetConnection as _Connection;
  if CConnection <> Nil then begin
    Result := CManInterface.GetReportText;
    xCss := CManInterface.GetReportCss;
    Result := StringReplace(Result, '[repstyle]', xCss, [rfReplaceAll, rfIgnoreCase]);
    Result := StringReplace(Result, '[repfooter]', CManInterface.GetName + ' wer. ' + CManInterface.GetVersion + ', ' + DateTimeToStr(Now), [rfReplaceAll, rfIgnoreCase]);
    Result := StringReplace(Result, '[reptitle]', 'Aktualny stan posiadania', [rfReplaceAll, rfIgnoreCase]);
    Result := StringReplace(Result, '[repbody]', GetBody, [rfReplaceAll, rfIgnoreCase]);
  end;
end;

exports
  Plugin_Initialize,
  Plugin_Execute;
end.
