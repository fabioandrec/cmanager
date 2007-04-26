library AccountChart;

{$R *.res}

uses
  Windows,
  MsXml,
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
  CXml in '..\..\CXml.pas';

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
var xXml: IXMLDOMDocument;
    xOutRoot: IXMLDOMNode;
    xSerie, xItem: IXMLDOMNode;
    xAccounts: _Recordset;
    xOut: OleVariant;
    xOldDecimal: Char;
begin
  VarClear(Result);
  xOldDecimal := DecimalSeparator;
  DecimalSeparator := '.';
  CConnection := CManInterface.GetConnection as _Connection;
  if CConnection <> Nil then begin
    xXml := GetXmlDocument;
    xOutRoot := xXml.createElement('chart');
    xXml.appendChild(xOutRoot);
    SetXmlAttribute('title', xOutRoot, 'Wykres stanu posiadania');
    SetXmlAttribute('footer', xOutRoot, CManInterface.GetName + ' wer. ' + CManInterface.GetVersion + ', ' + DateTimeToStr(Now));
    SetXmlAttribute('axisx', xOutRoot, 'tytu³ osi x');
    SetXmlAttribute('axisy', xOutRoot, 'tytu³ osi y');
    xSerie := xXml.createElement('serie');
    xOutRoot.appendChild(xSerie);
    SetXmlAttribute('type', xSerie, CSERIESTYPE_PIE);
    SetXmlAttribute('title', xSerie, 'Wszystkie dane');
    SetXmlAttribute('domain', xSerie, CSERIESDOMAIN_FLOAT);
    xAccounts := CConnection.Execute('select * from account', xOut, 0);
    while not xAccounts.EOF do begin
      xItem := xXml.createElement('item');
      xSerie.appendChild(xItem);
      SetXmlAttribute('domain', xItem, '');
      SetXmlAttribute('value', xItem, StringReplace(xAccounts.Fields.Item['cash'].Value, ',', '.', [rfIgnoreCase, rfReplaceAll]));
      SetXmlAttribute('label', xItem, xAccounts.Fields.Item['name'].Value);
      xAccounts.MoveNext;
    end;
    xAccounts := Nil;
    Result := GetStringFromDocument(xXml);
  end;
  DecimalSeparator := xOldDecimal;
end;

exports
  Plugin_Initialize,
  Plugin_Execute;
end.
