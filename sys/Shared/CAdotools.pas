unit CAdotools;

interface

uses AdoInt, Contnrs, Classes, Variants;

function GetRowsAsObjectList(ARecordset: _Recordset): TObjectList;
function GetRowsAsString(ARecordset: _Recordset; AFieldDelimeter: String): String;
function GetRowsAsXml(ARecordset: _Recordset): String;
function GetFieldType(AField: Field): String;

implementation

uses Math, CTools, StrUtils, CXml;

function GetRowsAsObjectList(ARecordset: _Recordset): TObjectList;
var xCf: Integer;
    xValue: String;
    xColumns: TStringList;
begin
  Result := TObjectList.Create(True);
  xColumns := TStringList.Create;
  for xCf := 0 to ARecordset.Fields.Count - 1 do begin
    xColumns.Add(ARecordset.Fields.Item[xCf].Name);
  end;
  Result.Add(xColumns);
  while not ARecordset.Eof do begin
    xColumns := TStringList.Create;
    for xCf := 0 to ARecordset.Fields.Count - 1 do begin
      try
        if VarIsNull(ARecordset.Fields.Item[xCf].Value) then begin
          xValue := 'null';
        end else begin
          xValue := ARecordset.Fields.Item[xCf].Value;
        end;
      except
        xValue := '<b³¹d>';
      end;
      xColumns.Add(xValue);
    end;
    Result.Add(xColumns);
    ARecordset.MoveNext;
  end;
end;

function GetRowsAsString(ARecordset: _Recordset; AFieldDelimeter: String): String;
var xList: TObjectList;
    xWidths: Array of Integer;
    xCf, xRc, xCc: Integer;
    xRow: TStringList;
    xValue: String;
begin
  xList := GetRowsAsObjectList(ARecordset);
  if AFieldDelimeter = '' then begin
    SetLength(xWidths, ARecordset.Fields.Count);
    for xCf := Low(xWidths) to High(xWidths) do begin
      xWidths[xCf] := -1;
    end;
    for xRc := 0 to xList.Count - 1 do begin
      xRow := TStringList(xList.Items[xRc]);
      for xCc := 0 to xRow.Count - 1 do begin
        xWidths[xCc] := Max(xWidths[xCc], Length(xRow.Strings[xCc]));
      end;
    end;
  end;
  Result := '';
  for xRc := 0 to xList.Count - 1 do begin
    xRow := TStringList(xList.Items[xRc]);
    for xCc := 0 to xRow.Count - 1 do begin
      xValue := xRow.Strings[xCc];
      if AFieldDelimeter = '' then begin
        Result := Result + RPad(xValue, ' ', xWidths[xCc]) + IfThen(xCc = xRow.Count - 1, '', ' ');
      end else begin
        Result := Result + xValue + IfThen(xCc = xRow.Count - 1, '', AFieldDelimeter);
      end;
    end;
    if xRc <> xList.Count - 1 then begin
      Result := Result + sLineBreak;
    end;
  end;
end;

function GetRowsAsXml(ARecordset: _Recordset): String;
var xDoc: ICXMLDOMDocument;
    xRoot: ICXMLDOMNode;
    xHeader: ICXMLDOMNode;
    xData: ICXMLDOMNode;
    xRow: ICXMLDOMNode;
    xCf: Integer;
    xColumn: ICXMLDOMNode;
    xValue: String;
begin
  xDoc := GetXmlDocument;
  xRoot := xDoc.createElement('recordset');
  xDoc.appendChild(xRoot);
  xHeader := xDoc.createElement('header');
  xRoot.appendChild(xHeader);
  xData := xDoc.createElement('content');
  xRoot.appendChild(xData);
  for xCf := 0 to ARecordset.Fields.Count - 1 do begin
    xRow := xDoc.createElement('field');
    SetXmlAttribute('typeEnum', xRow, ARecordset.Fields[xCf].Type_);
    SetXmlAttribute('typeName', xRow, GetFieldType(ARecordset.Fields[xCf]));
    SetXmlAttribute('size', xRow, ARecordset.Fields[xCf].DefinedSize);
    xRow.text := ARecordset.Fields[xCf].Name;
    xHeader.appendChild(xRow);
  end;
  while not ARecordset.Eof do begin
    xRow := xDoc.createElement('row');
    xData.appendChild(xRow);
    for xCf := 0 to ARecordset.Fields.Count - 1 do begin
      try
        if VarIsNull(ARecordset.Fields.Item[xCf].Value) then begin
          xValue := 'null';
        end else begin
          xValue := ARecordset.Fields.Item[xCf].Value;
        end;
      except
        xValue := '<b³¹d>';
      end;
      xColumn := xDoc.createElement('field');
      xColumn.text := xValue;
      xRow.appendChild(xColumn);
    end;
    ARecordset.MoveNext;
  end;
  Result := GetStringFromDocument(xDoc);
end;

function GetFieldType(AField: Field): String;
var xType: DataTypeEnum;
begin
  xType := AField.Type_;
  if xType = adEmpty then begin
    Result := 'Empty';
  end else if xType = adTinyInt then begin
    Result := 'TinyInt';
  end else if xType = adSmallInt then begin
    Result := 'SmallInt';
  end else if xType = adInteger then begin
    Result := 'Integer';
  end else if xType = adBigInt then begin
    Result := 'BigInt';
  end else if xType = adUnsignedTinyInt then begin
    Result := 'UnsignedTinyInt';
  end else if xType = adUnsignedSmallInt then begin
    Result := 'UnsignedSmallInt';
  end else if xType = adUnsignedInt then begin
    Result := 'UnsignedInt';
  end else if xType = adUnsignedBigInt then begin
    Result := 'UnsignedBigInt';
  end else if xType = adSingle then begin
    Result := 'Single';
  end else if xType = adDouble then begin
    Result := 'Double';
  end else if xType = adCurrency then begin
    Result := 'Currency';
  end else if xType = adDecimal then begin
    Result := 'Decimal';
  end else if xType = adNumeric then begin
    Result := 'Numeric';
  end else if xType = adBoolean then begin
    Result := 'Boolean';
  end else if xType = adError then begin
    Result := 'Error';
  end else if xType = adUserDefined then begin
    Result := 'UserDefined';
  end else if xType = adVariant then begin
    Result := 'Variant';
  end else if xType = adIDispatch then begin
    Result := 'IDispatch';
  end else if xType = adIUnknown then begin
    Result := 'IUnknown';
  end else if xType = adGUID then begin
    Result := 'GUID';
  end else if xType = adDate then begin
    Result := 'Date';
  end else if xType = adDBDate then begin
    Result := 'DBDate';
  end else if xType = adDBTime then begin
    Result := 'DBTime';
  end else if xType = adDBTimeStamp then begin
    Result := 'DBTimeStamp';
  end else if xType = adBSTR then begin
    Result := 'BSTR';
  end else if xType = adChar then begin
    Result := 'Char';
  end else if xType = adVarChar then begin
    Result := 'VarChar';
  end else if xType = adLongVarChar then begin
    Result := 'LongVarChar';
  end else if xType = adWChar then begin
    Result := 'WChar';
  end else if xType = adVarWChar then begin
    Result := 'VarWChar';
  end else if xType = adLongVarWChar then begin
    Result := 'LongVarWChar';
  end else if xType = adBinary then begin
    Result := 'Binary';
  end else if xType = adVarBinary then begin
    Result := 'VarBinary';
  end else if xType = adLongVarBinary then begin
    Result := 'LongVarBinary';
  end else if xType = adChapter then begin
    Result := 'Chapter';
  end else if xType = adFileTime then begin
    Result := 'FileTime';
  end else if xType = adDBFileTime then begin
    Result := 'DBFileTime';
  end else if xType = adPropVariant then begin
    Result := 'PropVariant';
  end else if xType = adVarNumeric then begin
    Result := 'VarNumeric';
  end;
end;

end.
