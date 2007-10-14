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
  CPluginTypes in '..\CPluginTypes.pas',
  CPluginConsts in '..\CPluginConsts.pas',
  CXmlTlb in '..\..\Shared\CXmlTlb.pas',
  CXml in '..\..\Shared\CXml.pas';

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
      SetXmlAttribute('axisx', xChart, 'tytu³ osi x');
      SetXmlAttribute('axisy', xChart, 'tytu³ osi y');
      xSerie := xXml.createElement('serie');
      xChart.appendChild(xSerie);
      SetXmlAttribute('type', xSerie, CSERIESTYPE_PIE);
      SetXmlAttribute('title', xSerie, 'Wszystkie dane');
      SetXmlAttribute('domain', xSerie, CSERIESDOMAIN_FLOAT);
      xAccounts.Filter := 'idCurrencyDef = ''' + xCurDefs.Strings[xCount] + '''';
      xAccounts.MoveFirst;
      while not xAccounts.EOF do begin
        xItem := xXml.createElement('item');
        xSerie.appendChild(xItem);
        SetXmlAttribute('domain', xItem, '');
        SetXmlAttribute('value', xItem, StringReplace(xAccounts.Fields.Item['cash'].Value, ',', '.', [rfIgnoreCase, rfReplaceAll]));
        SetXmlAttribute('label', xItem, xAccounts.Fields.Item['name'].Value);
        xAccounts.MoveNext;
      end;
    end;
    xCurDefs.Free;
    xAccounts := Nil;
    xXml.save('c:\a.xml');
    Result := GetStringFromDocument(xXml);
  end;
  DecimalSeparator := xOldDecimal;
end;

exports
  Plugin_Initialize,
  Plugin_Execute;
end.
