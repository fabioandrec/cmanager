unit CXml;

interface

uses ActiveX, MsXml, Classes;

procedure SetXmlAttribute(AName: String; ANode: IXMLDOMNode; AValue: OleVariant);
function GetXmlAttribute(AName: String; ANode: IXMLDOMNode; ADefault: OleVariant): OleVariant;
function GetDocumentFromString(AString: String): IXMLDOMDocument;
function GetXmlNodeValue(ANodeName: String; ARootNode: IXMLDOMNode; ADefault: String): String;
function GetXmlDocument(AEncoding: String = 'Windows-1250'): IXMLDOMDocument;
procedure AppendEncoding(var AXml: IXMLDOMDocument; AEncoding: String = 'Windows-1250');

implementation

procedure AppendEncoding(var AXml: IXMLDOMDocument; AEncoding: String = 'Windows-1250');
var xProc: IXMLDOMProcessingInstruction;
begin
  xProc := AXml.createProcessingInstruction('xml', 'version="1.0" encoding="' + AEncoding + '"');
  if AXml.hasChildNodes then begin
    AXml.insertBefore(xProc, AXml.firstChild);
  end else begin
    AXml.appendChild(xProc);
  end;
end;

function GetXmlDocument(AEncoding: String = 'Windows-1250'): IXMLDOMDocument;
begin
  Result := CoDOMDocument.Create;
  AppendEncoding(Result, AEncoding);
end;

function GetXmlNodeValue(ANodeName: String; ARootNode: IXMLDOMNode; ADefault: String): String;
var xNode: IXMLDOMNode;
begin
  xNode := ARootNode.selectSingleNode(ANodeName);
  if xNode <> Nil then begin
    Result := xNode.text;
  end else begin
    Result := ADefault;
  end;
end;

function GetXmlAttribute(AName: String; ANode: IXMLDOMNode; ADefault: OleVariant): OleVariant;
var xNode: IXMLDOMNode;
begin
  xNode := ANode.attributes.getNamedItem(AName);
  if xNode <> Nil then begin
    Result := xNode.nodeValue;
  end else begin
    Result := ADefault;
  end;
end;

procedure SetXmlAttribute(AName: String; ANode: IXMLDOMNode; AValue: OleVariant);
var xNode: IXMLDOMNode;
begin
  xNode := ANode.ownerDocument.createAttribute(AName);
  ANode.attributes.setNamedItem(xNode);
  xNode.nodeValue := AValue;
end;

function GetDocumentFromString(AString: String): IXMLDOMDocument;
var xStream: TStringStream;
    xHelper: TStreamAdapter;
begin
  Result := CoDOMDocument.Create;
  Result.validateOnParse := True;
  Result.resolveExternals := True;
  xStream := TStringStream.Create(AString);
  xHelper := TStreamAdapter.Create(xStream);
  Result.load(xHelper as IStream);
  xStream.Free;
end;

end.
