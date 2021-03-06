library AccountChart;

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
  DateUtils,
  CPluginTypes in '..\CPluginTypes.pas',
  CPluginConsts in '..\CPluginConsts.pas',
  CXmlTlb in '..\..\Shared\CXmlTlb.pas',
  CXml in '..\..\Shared\CXml.pas',
  CTools in '..\..\Shared\CTools.pas';

var CManInterface: ICManagerInterface;
    CConnection: _Connection;

function Plugin_Initialize(ACManagerInterface: ICManagerInterface): Boolean; stdcall; export;
begin
  CManInterface := ACManagerInterface;
  with CManInterface do begin
    Application.Handle := GetAppHandle;
    SetType(CPLUGINTYPE_CHARTREPORT);
    SetCaption('Wykres stanu posiadania');
    SetDescription('Wykres stanu posiadania');
  end;
  Result := True;
end;

function Plugin_Execute: OleVariant; stdcall; export;
var xXml: ICXMLDOMDocument;
    xOutRoot: ICXMLDOMNode;
    xCount: Integer;
    xChart, xSerie, xItem: ICXMLDOMNode;
    xAccounts: _Recordset;
    xOut: OleVariant;
    xOldDecimal: Char;
    xCurDefs: TStringList;
begin
  VarClear(Result);
  xOldDecimal := DecimalSeparator;
  DecimalSeparator := '.';
  CConnection := CManInterface.GetConnection as _Connection;
  if CConnection <> Nil then begin
    xXml := GetXmlDocument;
    xOutRoot := xXml.createElement('charts');
    xXml.appendChild(xOutRoot);
    xAccounts := CConnection.Execute('select sum(cash) as cash, name, idCurrencyDef from account group by idCurrencyDef, name', xOut, 0);
    xAccounts.MoveFirst;
    xCurDefs := TStringList.Create;
    xCurDefs.Sorted := True;
    xCurDefs.Duplicates := dupIgnore;
    while not xAccounts.EOF do begin
      xCurDefs.Add(xAccounts.Fields.Item['idCurrencyDef'].Value);
      xAccounts.MoveNext;
    end;
    for xCount := 0 to xCurDefs.Count - 1 do begin
      xChart := xXml.createElement('chart');
      xOutRoot.appendChild(xChart);
      SetXmlAttribute('symbol', xChart, xCurDefs.Strings[xCount]);
      SetXmlAttribute('thumbTitle', xChart, CManInterface.GetCurrencyIso(xCurDefs.Strings[xCount]));
      SetXmlAttribute('chartTitle', xChart, 'Wykres stanu posiadania');
      SetXmlAttribute('chartFooter', xChart, CManInterface.GetName + ' wer. ' + CManInterface.GetVersion + ', ' + DateTimeToStr(Now));
      SetXmlAttribute('axisx', xChart, 'tytu� osi x');
      SetXmlAttribute('axisy', xChart, 'tytu� osi y');
      xSerie := xXml.createElement('serie');
      xChart.appendChild(xSerie);
      SetXmlAttribute('type', xSerie, CSERIESTYPE_PIE);
      SetXmlAttribute('title', xSerie, 'Seria 1');
      SetXmlAttribute('domain', xSerie, CSERIESDOMAIN_FLOAT);
      xAccounts.Filter := 'idCurrencyDef = ''' + xCurDefs.Strings[xCount] + '''';
      xAccounts.MoveFirst;
      while not xAccounts.EOF do begin
        xItem := xXml.createElement('item');
        xSerie.appendChild(xItem);
        SetXmlAttribute('value', xItem, StringReplace(xAccounts.Fields.Item['cash'].Value, ',', '.', [rfIgnoreCase, rfReplaceAll]));
        SetXmlAttribute('label', xItem, xAccounts.Fields.Item['name'].Value);
        xAccounts.MoveNext;
      end;
    end;
    xCurDefs.Free;
    xAccounts := Nil;
    xChart := xXml.createElement('chart');
    xOutRoot.appendChild(xChart);
    SetXmlAttribute('symbol', xChart, 'LINIOWY');
    SetXmlAttribute('thumbTitle', xChart, 'thumbTitle');
    SetXmlAttribute('chartTitle', xChart, 'Wykres liniowy posiadania z datami');
    SetXmlAttribute('chartFooter', xChart, CManInterface.GetName + ' wer. ' + CManInterface.GetVersion + ', ' + DateTimeToStr(Now));
    SetXmlAttribute('axisx', xChart, 'tytu� osi x');
    SetXmlAttribute('axisy', xChart, 'tytu� osi y');
    xSerie := xXml.createElement('serie');
    xChart.appendChild(xSerie);
    SetXmlAttribute('type', xSerie, CSERIESTYPE_LINE);
    SetXmlAttribute('title', xSerie, 'Seria 2');
    SetXmlAttribute('domain', xSerie, CSERIESDOMAIN_DATETIME);
    for xCount := 1 to 5 do begin
      xItem := xXml.createElement('item');
      xSerie.appendChild(xItem);
      SetXmlAttribute('domain', xItem, FormatDateTime('yyyy-mm-dd', EncodeDate(YearOf(Now), MonthOf(Now), xCount)));
      SetXmlAttribute('value', xItem, Trim(StringReplace(Format('%-10.4f', [Random(1000)/(1 + Random(10))]), ',', '.', [rfIgnoreCase, rfReplaceAll])));
      SetXmlAttribute('label', xItem, 'item ' + IntToStr(xCount));
    end;
    xSerie := xXml.createElement('serie');
    xChart.appendChild(xSerie);
    SetXmlAttribute('type', xSerie, CSERIESTYPE_BAR);
    SetXmlAttribute('title', xSerie, 'Seria 3');
    SetXmlAttribute('domain', xSerie, CSERIESDOMAIN_DATETIME);
    for xCount := 1 to 5 do begin
      xItem := xXml.createElement('item');
      xSerie.appendChild(xItem);
      SetXmlAttribute('domain', xItem, FormatDateTime('yyyy-mm-dd', EncodeDate(YearOf(Now), MonthOf(Now), xCount)));
      SetXmlAttribute('value', xItem, Trim(StringReplace(Format('%-10.4f', [Random(1000)/(1 + Random(10))]), ',', '.', [rfIgnoreCase, rfReplaceAll])));
      SetXmlAttribute('label', xItem, '');
      SetXmlAttribute('mark', xItem, 'opis znacznika ' + IntToStr(xCount));
    end;
    Result := GetStringFromDocument(xXml);
  end;
  DecimalSeparator := xOldDecimal;
end;

exports
  Plugin_Initialize,
  Plugin_Execute;
end.
