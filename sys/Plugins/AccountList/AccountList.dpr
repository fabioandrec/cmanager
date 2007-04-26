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
  CPluginConsts in '..\CPluginConsts.pas';

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
      xSum: Currency;
  begin
    xBody := TStringList.Create;
    xAccounts := CConnection.Execute('select * from account', xOut, 0);
    with xAccounts, xBody do begin
      Add('<table class="base" colspan=2>');
      Add('<tr class="base">');
      Add('<td class="headtext" width="75%">Nazwa konta</td>');
      Add('<td class="headcash" width="25%">Saldo</td>');
      Add('</tr>');
      Add('</table><hr><table class="base" colspan=2>');
      xSum := 0;
      while not xAccounts.EOF do begin
        if not Odd(xAccounts.AbsolutePosition) then begin
          Add('<tr class="base" bgcolor=' + ColToRgb(GetHighLightColor(clWhite, -10)) + '>');
        end else begin
          Add('<tr class="base">');
        end;
        Add('<td class="text" width="75%">' + xAccounts.Fields.Item['name'].Value + '</td>');
        Add('<td class="cash" width="25%">' + CurrToStrF(xAccounts.Fields.Item['cash'].Value, ffCurrency, 2) + '</td>');
        Add('</tr>');
        xSum := xSum + xAccounts.Fields.Item['cash'].Value;
        xAccounts.MoveNext;
      end;
      Add('</table><hr><table class="base" colspan=2>');
      Add('<tr class="base">');
      Add('<td class="sumtext" width="75%">Razem</td>');
      Add('<td class="sumcash" width="25%">' + CurrToStrF(xSum, ffCurrency, 2) + '</td>');
      Add('</tr>');
      Add('</table>');
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
