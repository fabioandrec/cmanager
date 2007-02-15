unit CXml;

interface

uses MsXml;

procedure SetXmlAttribute(AName: String; ANode: IXMLDOMNode; AValue: OleVariant);
function GetXmlAttribute(AName: String; ANode: IXMLDOMNode; ADefault: OleVariant): OleVariant;

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

end.
