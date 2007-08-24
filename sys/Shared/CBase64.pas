unit CBase64;

interface

{$RANGECHECKS OFF}

uses Classes;

function DecodeBase64(const InStream: TStream; OutStream: TStream): Boolean;
function EncodeBase64(const InStream: TStream; OutStream: TStream): Boolean;

function DecodeBase64Buffer(const ABuffer: String; var ABufferOut: String): Boolean;
function EncodeBase64Buffer(const ABuffer: String; var ABufferOut: String): Boolean;

implementation

uses Windows, Zlib;

const
  EncodeBase64Table: array[0..63] of Char = (#65, #66, #67, #68, #69,
    #70, #71, #72, #73, #74, #75, #76, #77, #78, #79,
    #80, #81, #82, #83, #84, #85, #86, #87, #88, #89,
    #90, #97, #98, #99, #100, #101, #102, #103, #104, #105,
    #106, #107, #108, #109, #110, #111, #112, #113, #114, #115,
    #116, #117, #118, #119, #120, #121, #122, #48, #49, #50,
    #51, #52, #53, #54, #55, #56, #57, #43, #47);

  DecodeBase64Table: array[43..122] of Byte = ($3E, $7F, $7F, $7F, $3F, $34,
    $35, $36, $37, $38, $39, $3A, $3B, $3C, $3D, $7F, $7F, $7F, $7F,
    $7F, $7F, $7F, $00, $01, $02, $03, $04, $05, $06, $07, $08, $09,
    $0A, $0B, $0C, $0D, $0E, $0F, $10, $11, $12, $13, $14, $15, $16,
    $17, $18, $19, $7F, $7F, $7F, $7F, $7F, $7F, $1A, $1B, $1C, $1D,
    $1E, $1F, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $2A,
    $2B, $2C, $2D, $2E, $2F, $30, $31, $32, $33);

function DecodeBase64(const InStream: TStream; OutStream: TStream): Boolean;
var I, O, Count, c1, c2, c3: Byte;
    InBuf: array[0..87] of Byte;
    OutBuf: array[0..65] of Byte;
begin
  InStream.Position := 0;
  Result := True;
  repeat
    O := 0;
    I := 0;
    Count := InStream.Read(InBuf, SizeOf(InBuf));
    if (Count = 0) then Break;
    while I < Count do begin
      if (InBuf[I] < 43) or (InBuf[I] > 122) or
        (InBuf[I + 1] < 43) or (InBuf[I + 1] > 122) or
        (InBuf[I + 2] < 43) or (InBuf[I + 2] > 122) or
        (InBuf[I + 3] < 43) or (InBuf[I + 3] > 122) then begin
        Result := False;
        Exit;
      end;
      c1 := DecodeBase64Table[InBuf[I]];
      c2 := DecodeBase64Table[InBuf[I + 1]];
      c3 := DecodeBase64Table[InBuf[I + 2]];
      OutBuf[O] := ((c1 shl 2) or (c2 shr 4));
      Inc(O);
      if Char(InBuf[I + 2]) <> '=' then begin
        OutBuf[O] := ((c2 shl 4) or (c3 shr 2));
        Inc(O);
        if Char(InBuf[I + 3]) <> '=' then begin
          OutBuf[O] := ((c3 shl 6) or DecodeBase64Table[InBuf[I + 3]]);
          Inc(O);
        end;
      end;
      Inc(I, 4);
    end;
    OutStream.Write(OutBuf, O);
  until Count < SizeOf(InBuf);
  OutStream.Position := 0;
end;

function EncodeBase64(const InStream: TStream; OutStream: TStream): Boolean;
var I, O, Count: Integer;
    InBuf: array[1..45] of Byte;
    OutBuf: array[0..62] of Char;
    Temp: Byte;
begin
  InStream.Position := 0;
  Result := True;
  FillChar(OutBuf, Sizeof(OutBuf), #0);
  repeat
    Count := InStream.Read(InBuf, SizeOf(InBuf));
    if Count = 0 then Break;
    I := 1;
    O := 0;
    while I <= (Count - 2) do begin
      Temp := (InBuf[I] shr 2);
      OutBuf[O] := Char(EncodeBase64Table[Temp and $3F]);
      Temp := (InBuf[I] shl 4) or (InBuf[I + 1] shr 4);
      OutBuf[O + 1] := Char(EncodeBase64Table[Temp and $3F]);
      Temp := (InBuf[I + 1] shl 2) or (InBuf[I + 2] shr 6);
      OutBuf[O + 2] := Char(EncodeBase64Table[Temp and $3F]);
      Temp := (InBuf[I + 2] and $3F);
      OutBuf[O + 3] := Char(EncodeBase64Table[Temp]);
      Inc(I, 3);
      Inc(O, 4);
    end;
    if (I <= Count) then begin
      Temp := (InBuf[I] shr 2);
      OutBuf[O] := Char(EncodeBase64Table[Temp and $3F]);
      if I = Count then begin
        Temp := (InBuf[I] shl 4) and $30;
        OutBuf[O + 1] := Char(EncodeBase64Table[Temp and $3F]);
        OutBuf[O + 2] := '=';
      end else begin
        Temp := ((InBuf[I] shl 4) and $30) or ((InBuf[I + 1] shr 4) and $0F);
        OutBuf[O + 1] := Char(EncodeBase64Table[Temp and $3F]);
        Temp := (InBuf[I + 1] shl 2) and $3C;
        OutBuf[O + 2] := Char(EncodeBase64Table[Temp and $3F]);
      end;
      OutBuf[O + 3] := '=';
      Inc(O, 4);
    end;
    OutStream.Write(OutBuf, O);
  until Count < SizeOf(InBuf);
  OutStream.Position := 0;
end;

function CompressData(AData: String): String;
var xBuffer: Pointer;
    xOutLen: Integer;
begin
  if Length(AData) > 0 then begin
    CompressBuf(@AData[1], Length(AData), xBuffer, xOutLen);
    SetLength(Result, xOutLen);
    CopyMemory(@Result[1], xBuffer, xOutLen);
    FreeMem(xBuffer)
  end else begin
    Result := '';
  end;
end;

function DecompressData(AData: String): String;
var xBuffer: Pointer;
    xOutLen: Integer;
begin
  if Length(AData) > 0 then begin
    DecompressBuf(@AData[1], Length(AData), 0, xBuffer, xOutLen);
    SetLength(Result, xOutLen);
    CopyMemory(@Result[1], xBuffer, xOutLen);
    FreeMem(xBuffer)
  end else begin
    Result := '';
  end;
end;

function DecodeBase64Buffer(const ABuffer: String; var ABufferOut: String): Boolean;
var xInStream: TMemoryStream;
    xOutStream: TStringStream;
begin
  ABufferOut := '';
  Result := Length(ABuffer) = 0;
  if not Result then begin
    xInStream := TMemoryStream.Create;
    xOutStream := TStringStream.Create('');
    try
      try
        if xInStream.Write(ABuffer[1], Length(ABuffer)) = Length(ABuffer) then begin
          if DecodeBase64(xInStream, xOutStream) then begin
            ABufferOut := DecompressData(xOutStream.DataString);
            Result := True;
          end;
        end;
      except
      end;
    finally
      xOutStream.Free;
      xInStream.Free;
    end;
  end;
end;

function EncodeBase64Buffer(const ABuffer: String; var ABufferOut: String): Boolean;
var xInStream: TStringStream;
    xOutStream: TMemoryStream;
begin
  ABufferOut := '';
  Result := Length(ABuffer) = 0;
  if not Result then begin
    xInStream := TStringStream.Create(CompressData(ABuffer));
    xOutStream := TMemoryStream.Create;
    try
      try
        Result := EncodeBase64(xInStream, xOutStream);
        if Result then begin
          SetLength(ABufferOut, xOutStream.Size);
          xOutStream.Read(ABufferOut[1], xOutStream.Size);
          Result := True;
        end;
      except
      end;
    finally
      xOutStream.Free;
      xInStream.Free;
    end;
  end;
end;

end.
