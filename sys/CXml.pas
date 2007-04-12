unit CXml;

interface

uses ActiveX, MsXml, Classes;

procedure SetXmlAttribute(AName: String; ANode: IXMLDOMNode; AValue: OleVariant);
function GetXmlAttribute(AName: String; ANode: IXMLDOMNode; ADefault: OleVariant): OleVariant;
function GetDocumentFromString(AString: String): IXMLDOMDocument;

implementation

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
