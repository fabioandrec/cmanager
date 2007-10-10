unit CXml;

interface

uses ActiveX, CXmlTlb, Classes;

procedure SetXmlAttribute(AName: String; ANode: IXMLDOMNode; AValue: OleVariant);
function GetXmlAttribute(AName: String; ANode: IXMLDOMNode; ADefault: OleVariant): OleVariant;
function GetDocumentFromString(AString: String; AXsd: IXMLDOMDocument2 = Nil): IXMLDOMDocument2;
function GetDocumentFromFile(AFilename: String; AXsd: IXMLDOMDocument2 = Nil): IXMLDOMDocument2;
function GetStringFromDocument(ADocument: IXMLDOMDocument2): String;
function GetXmlNodeValue(ANodeName: String; ARootNode: IXMLDOMNode; ADefault: String): String;
function GetXmlDocument(AEncoding: String = 'Windows-1250'): IXMLDOMDocument2;
procedure AppendEncoding(var AXml: IXMLDOMDocument2; AEncoding: String = 'Windows-1250');
function GetParseErrorDescription(AError: IXMLDOMParseError; AWithLinebraks: Boolean): String;

implementation

uses SysUtils, StrUtils;

procedure AppendEncoding(var AXml: IXMLDOMDocument2; AEncoding: String = 'Windows-1250');
var xProc: IXMLDOMProcessingInstruction;
begin
  xProc := AXml.createProcessingInstruction('xml', 'version="1.0" encoding="' + AEncoding + '"');
  if AXml.hasChildNodes then begin
    AXml.insertBefore(xProc, AXml.firstChild);
  end else begin
    AXml.appendChild(xProc);
  end;
end;

function GetXmlDocument(AEncoding: String = 'Windows-1250'): IXMLDOMDocument2;
begin
  Result := CoDOMDocument40.Create;
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

function GetDocumentFromFile(AFilename: String; AXsd: IXMLDOMDocument2 = Nil): IXMLDOMDocument2;
var xStr: TStringList;
begin
  xStr := TStringList.Create;
  try
    try
      xStr.LoadFromFile(AFilename);
      Result := GetDocumentFromString(xStr.Text, AXsd);
    except
      Result := Nil;
    end;
  finally
    xStr.Free;
  end;
end;

function GetDocumentFromString(AString: String; AXsd: IXMLDOMDocument2 = Nil): IXMLDOMDocument2;
var xStream: TStringStream;
    xHelper: TStreamAdapter;
    xXsdCache: IXMLDOMSchemaCollection2;
begin
  Result := GetXmlDocument;
  if Result <> Nil then begin
    Result.validateOnParse := True;
    Result.resolveExternals := True;
    if AXsd <> Nil then begin
      xXsdCache := CoXMLSchemaCache40.Create;
      xXsdCache.add('', AXsd);
      Result.schemas := xXsdCache;
    end;
    xStream := TStringStream.Create(AString);
    xHelper := TStreamAdapter.Create(xStream);
    try
      Result.load(xHelper as IStream);
    finally
      xStream.Free;
    end;
  end;
end;

function GetStringFromDocument(ADocument: IXMLDOMDocument2): String;
var xStream: TStringStream;
    xHelper: TStreamAdapter;
begin
  xStream := TStringStream.Create('');
  xHelper := TStreamAdapter.Create(xStream);
  ADocument.save(xHelper as IStream);
  Result := xStream.DataString;
  xStream.Free;
end;

function GetParseErrorDescription(AError: IXMLDOMParseError; AWithLinebraks: Boolean): String;
begin
  Result := '';
  if AError <> Nil then begin
    if AError.errorCode <> 0 then begin
      Result := Trim(AError.reason);
      if RightStr(Result, 1) <> '.' then begin
        Result := Result + '.';
      end;
      Result := Result + ' Linia ' + IntToStr(AError.line) +
                         ', wiersz ' + IntToStr(AError.linepos) +
                         ',' + IfThen(AWithLinebraks, '\n', ' ') + 'Ÿród³o b³êdu ' + Trim(AError.srcText);
    end;
  end;
end;

end.
