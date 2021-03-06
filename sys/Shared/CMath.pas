unit CMath;

interface

uses Types, Classes, Contnrs;

procedure RegLin(ADBx, ADBy: TDoubleDynArray; var Aa, Ab: Double);
procedure ResLin(ADBx, ADBy: TDoubleDynArray; var Aa, Ab: Double);
procedure SupLin(ADBx, ADBy: TDoubleDynArray; var Aa, Ab: Double);
function MaxDoubleArray(const AList: TDoubleDynArray): Double;
function MinDoubleArray(const AList: TDoubleDynArray): Double;
function MaxPoint(const AX, AY: TDoubleDynArray): Integer;
function MinPoint(const AX, AY: TDoubleDynArray): Integer;
function SumDoubleArray(const AList: TDoubleDynArray): Extended;
function MultiDoubleArray(const AList: TDoubleDynArray): Extended;
procedure SortDoubleArray(var AList: TDoubleDynArray);
function AvgDoubleArray(const AList: TDoubleDynArray): Double;
function MedDoubleArray(const AList: TDoubleDynArray): Double;
function GeoDoubleArray(const AList: TDoubleDynArray): Double;
function WeightDoubleArray(const AList: TDoubleDynArray): Double;
function InSour(AValue, ABase, AEpsilon: Cardinal): Boolean;
function OutSour(AValue, ABase, AEpsilon: Cardinal): Boolean;

implementation

uses Math, CTools;

procedure RegLin(ADBx, ADBy: TDoubleDynArray; var Aa, Ab: Double);
var xSigX, xSigY : Double;
    xSigXY : Double;
    xSigSqrX : Double;
    xN, xI : Word;
begin
  Aa := 0;
  Ab := 0;
  if Length(ADBy) > 0 then begin
    try
      xN := High(ADBx) + 1;
      xSigX := 0;
      xSigY := 0;
      xSigXY := 0;
      xSigSqrX := 0;
      for xI := 0 to xN - 1 do begin
        xSigX := xSigX + ADBx[xI];
        xSigY := xSigY + ADBy[xI];
        xSigXY := xSigXY + (ADBx[xI] * ADBy[xI]);
        xSigSqrX := xSigSqrX + Sqr(ADBx[xI]);
      end;
      Aa := (xN * xSigXY - xSigX * xSigY) / (xN * xSigSqrX - Sqr(xSigX));
      Ab := 1/xN * (xSigY - Aa * xSigX);
    except
    end;
  end;
end;

procedure ResLin(ADBx, ADBy: TDoubleDynArray; var Aa, Ab: Double);
var xDBx, xDBy: TDoubleDynArray;
    xCount: Integer;
    xMaxCount: Integer;
begin
  Aa := 0;
  Ab := 0;
  if Length(ADBy) > 0 then begin
    SetLength(xDBx, 0);
    SetLength(xDBy, 0);
    xCount := Low(ADby) + 1;
    xMaxCount := High(ADby) - 1;
    while (xCount <= xMaxCount) do begin
      if (ADBy[xCount - 1] >= ADBy[xCount]) and (ADBy[xCount + 1] >= ADBy[xCount]) then begin
        SetLength(xDBx, Length(xDbx) + 1);
        SetLength(xDBy, Length(xDby) + 1);
        xDBx[High(xDbx)] := ADbx[xCount];
        xDBy[High(xDby)] := ADby[xCount];
      end;
      Inc(xCount);
    end;
    RegLin(xDBx, xDBy, Aa, Ab);
  end;
end;

procedure SupLin(ADBx, ADBy: TDoubleDynArray; var Aa, Ab: Double);
var xDBx, xDBy: TDoubleDynArray;
    xCount: Integer;
    xMaxCount: Integer;
begin
  Aa := 0;
  Ab := 0;
  if Length(ADBy) > 0 then begin
    SetLength(xDBx, 0);
    SetLength(xDBy, 0);
    xCount := Low(ADby) + 1;
    xMaxCount := High(ADby) - 1;
    while (xCount <= xMaxCount) do begin
      if (ADBy[xCount - 1] <= ADBy[xCount]) and (ADBy[xCount + 1] <= ADBy[xCount]) then begin
        SetLength(xDBx, Length(xDbx) + 1);
        SetLength(xDBy, Length(xDby) + 1);
        xDBx[High(xDbx)] := ADbx[xCount];
        xDBy[High(xDby)] := ADby[xCount];
      end;
      Inc(xCount);
    end;
    RegLin(xDBx, xDBy, Aa, Ab);
  end;
end;

function SumDoubleArray(const AList: TDoubleDynArray): Extended;
var xI, xN: Integer;
begin
  Result := 0.0;
  xN := Length(AList);
  if xN <> 0 then begin
    Result := AList[0];
    for xI := 1 to xN - 1 do begin
      Result := Result + AList[xI];
    end;
  end;
end;

function MultiDoubleArray(const AList: TDoubleDynArray): Extended;
var xI, xN: Integer;
begin
  Result := 0.0;
  xN := Length(AList);
  if xN <> 0 then begin
    Result := AList[0];
    for xI := 1 to xN - 1 do begin
      Result := Result * AList[xI];
    end;
  end;
end;

function MinDoubleArray(const AList: TDoubleDynArray): Double;
var xI, xN: Integer;
begin
  Result := 0.0;
  xN := Length(AList);
  if xN <> 0 then begin
    Result := AList[0];
    for xI := 1 to xN - 1 do begin
      if AList[xI] < Result then begin
        Result := AList[xI];
      end;
    end;
  end;
end;

function MaxDoubleArray(const AList: TDoubleDynArray): Double;
var xI, xN: Integer;
begin
  Result := 0.0;
  xN := Length(AList);
  if xN <> 0 then begin
    Result := AList[0];
    for xI := 1 to xN - 1 do begin
      if AList[xI] > Result then begin
        Result := AList[xI];
      end;
    end;
  end;
end;

function CompareDouble(Item1, Item2: Pointer): Integer;
var xD1, xD2: Double;
begin
  Result := 0;
  xD1 := Double(Item1^);
  xD2 := Double(Item2^);
  if xD1 > xD2 then begin
    Result := 1;
  end else if xD1 < xD2 then begin
    Result := -1;
  end;
end;

procedure SortDoubleArray(var AList: TDoubleDynArray);
var xList: TList;
    xDouble: PDouble;
    xCount: Integer;
begin
  xList := TList.Create;
  for xCount := Low(AList) to High(AList) do begin
    GetMem(xDouble, SizeOf(Double));
    xDouble^ := AList[xCount];
    xList.Add(xDouble);
  end;
  xList.Sort(@CompareDouble);
  for xCount := 0 to xList.Count - 1 do begin
    AList[xCount] := Double(xList.Items[xCount]^);
  end;
  while (xList.Count <> 0) do begin
    xDouble := xList.Items[xList.Count - 1];
    xList.Delete(xList.Count - 1);
    FreeMem(xDouble);
  end;
  xList.Free;
end;

function AvgDoubleArray(const AList: TDoubleDynArray): Double;
begin
  Result := 0.0;
  if Length(AList) > 0 then begin
    Result := SumDoubleArray(AList) / Length(AList);
  end;
end;

function MedDoubleArray(const AList: TDoubleDynArray): Double;
var xSeriesArray: TDoubleDynArray;
begin
  Result := 0.0;
  if Length(AList) > 0 then begin
    xSeriesArray := AList;
    SortDoubleArray(xSeriesArray);
    if Odd(Length(xSeriesArray)) then begin
      Result := xSeriesArray[Length(xSeriesArray) div 2];
    end else begin
      Result := (xSeriesArray[Length(xSeriesArray) div 2] + xSeriesArray[(Length(xSeriesArray) div 2) + 1]) / 2;
    end;
  end;
end;

function GeoDoubleArray(const AList: TDoubleDynArray): Double;
begin
  Result := 0.0;
  if Length(AList) > 0 then begin
    try
      Result := Power(MultiDoubleArray(AList), 1 / Length(AList));
    except
      Result := 0.0;
    end
  end;
end;

type
  TRange = class(TObject)
  public
    Left: Double;
    Right: Double;
    Counter: Integer;
    constructor Create(ALeft, ARight: Double);
  end;

  TRangeList = class(TObjectList)
  public
    function GetRange(AValue: Double): TRange;
  end;

function WeightDoubleArray(const AList: TDoubleDynArray): Double;
var xMin, xMax, xDelta, xCur, xWeightSum, xSum: Double;
    xRangeList: TRangeList;
    xRange: TRange;
    xCount: Integer;
begin
  Result := 0.0;
  if Length(AList) > 0 then begin
    xMin := MinDoubleArray(AList);
    xMax := MaxDoubleArray(AList);
    xDelta := (xMax - xMin) / 10;
    if xDelta <> 0 then begin
      xRangeList := TRangeList.Create(True);
      xCur := xMin;
      while (xCur <= xMax) do begin
        xRangeList.Add(TRange.Create(xCur, xCur + xDelta));
        xCur := xCur + xDelta;
      end;
      for xCount := Low(AList) to High(AList) do begin
        xCur := AList[xCount];
        xRange := TRange(xRangeList.GetRange(xCur));
        if xRange <> Nil then begin
          xRange.Counter := xRange.Counter + 1;
        end else begin
          {$IFDEF DEBUG}
          raise EInvalidArgument.Create('Brak range');
          {$ENDIF}
        end;
      end;
      xWeightSum := 0;
      xSum := 0;
      for xCount := Low(AList) to High(AList) do begin
        xCur := AList[xCount];
        xRange := TRange(xRangeList.GetRange(xCur));
        if xRange <> Nil then begin
          xWeightSum := xWeightSum + xRange.Counter;
          xSum := xSum + xRange.Counter * xCur;
        end else begin
          {$IFDEF DEBUG}
          raise EInvalidArgument.Create('Brak range');
          {$ENDIF}
        end;
      end;
      Result := xSum / xWeightSum;
      xRangeList.Free;
    end else begin
      Result := xMin;
    end;
  end;
end;

function TRangeList.GetRange(AValue: Double): TRange;
var xCount: Integer;
    xRange: TRange;
begin
  Result := Nil;
  xCount := 0;
  while (Result = Nil) and (xCount <= Count - 1) do begin
    xRange := TRange(Items[xCount]);
    if (xRange.Left <= AValue) and (AValue < xRange.Right) then begin
      Result := xRange;
    end;
    Inc(xCount);
  end;
end;

constructor TRange.Create(ALeft, ARight: Double);
begin
  inherited Create;
  Left := ALeft;
  Right := ARight;
end;

function MaxPoint(const AX, AY: TDoubleDynArray): Integer;
var xLen, xCount: Integer;
    xVal: Double;
begin
  Result := -1;
  xLen := Length(AX);
  if (xLen > 0) and (xLen = Length(AY)) then begin
    Result := 0;
    xVal := AY[Result];
    for xCount := 1 to xLen - 1 do begin
      if (xVal < AY[xCount]) then begin
        Result := xCount;
        xVal := AY[xCount];
      end;
    end;
  end;
end;

function MinPoint(const AX, AY: TDoubleDynArray): Integer;
var xLen, xCount: Integer;
    xVal: Double;
begin
  Result := -1;
  xLen := Length(AX);
  if (xLen > 0) and (xLen = Length(AY)) then begin
    Result := 0;
    xVal := AY[Result];
    for xCount := 1 to xLen - 1 do begin
      if (xVal > AY[xCount]) then begin
        Result := xCount;
        xVal := AY[xCount];
      end;
    end;
  end;
end;

function InSour(AValue, ABase, AEpsilon: Cardinal): Boolean;
begin
  Result := ((ABase - AEpsilon) >= AValue) and (AValue <= (ABase + AEpsilon));
end;

function OutSour(AValue, ABase, AEpsilon: Cardinal): Boolean;
begin
  Result := not InSour(AValue, ABase, AEpsilon);
end;

end.
