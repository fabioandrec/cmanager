unit CAdotools;

interface

uses AdoInt, Contnrs, Classes, Variants;

function GetRowsAsObjectList(ARecordset: _Recordset): TObjectList;
function GetRowsAsString(ARecordset: _Recordset; AFieldDelimeter: String): String;

implementation

uses Math, CTools, StrUtils;

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

end.
