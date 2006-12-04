unit CBaseFormUnit;

interface

uses
  Windows, Forms, Classes, ComCtrls, Graphics, SysUtils, Messages;

const
  CRtfSB = '<b>';
  CRtfEB = '</b>';
  CRtfSU = '<u>';
  CRtfEU = '</u>';
  CRtfSH = '<h>';
  CRtfEH = '</h>';
  CRtfSC = '<c>';
  CRtfEC = '</c>';
  CRtFLA = '<l>';
  CRtFRA = '<r>';
  CRtFCA = '<c>';

type
  TCBaseForm = class(TForm)
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  protected
    procedure CloseForm; virtual;
    procedure WndProc(var Message: TMessage); override;
    procedure Loaded; override;
  end;

procedure AssignRichText(AText: String; ARichEdit: TRichEdit);

implementation

uses CSettings, CBaseFrameUnit, CConsts, CComponents;

{$R *.dfm}

type
  TFormatStructure = record
    TheStart: Integer;
    TheEnd: Integer;
    StyleBits: Integer;
    TheColor: TColor;
    TheAlignment: TAlignment;
  end;
  TFormatStructureList = array of TFormatStructure;

const
  CStyleBold = 1;
  CStyleHigher = 2;
  CStyleCondensed = 4;
  CStyleUnderline = 8;

procedure TCBaseForm.CloseForm;
begin
  Close;
end;

procedure TCBaseForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then begin
    CloseForm;
  end;
end;

function PrepareRichTextLine(AText: String; var AAttributesList: TFormatStructureList): String;

  function FindFirstCode(ALine: String; var ACode: String): Integer;
  var xPos: Integer;
  begin
    Result := $FFFF;
    ACode := '';
    xPos := Pos(CRtfSB, ALine);
    if (xPos <> 0) and (xPos < Result) then begin
      Result := xPos;
      ACode := CRtfSB;
    end;
    xPos := Pos(CRtfEB, ALine);
    if (xPos <> 0) and (xPos < Result) then begin
      Result := xPos;
      ACode := CRtfEB;
    end;
    xPos := Pos(CRtfSU, ALine);
    if (xPos <> 0) and (xPos < Result) then begin
      Result := xPos;
      ACode := CRtfSU;
    end;
    xPos := Pos(CRtfEU, ALine);
    if (xPos <> 0) and (xPos < Result) then begin
      Result := xPos;
      ACode := CRtfEU;
    end;
    xPos := Pos(CRtfSH, ALine);
    if (xPos <> 0) and (xPos < Result) then begin
      Result := xPos;
      ACode := CRtfSH;
    end;
    xPos := Pos(CRtfEH, ALine);
    if (xPos <> 0) and (xPos < Result) then begin
      Result := xPos;
      ACode := CRtfEH;
    end;
    xPos := Pos(CRtfSC, ALine);
    if (xPos <> 0) and (xPos < Result) then begin
      Result := xPos;
      ACode := CRtfSC;
    end;
    xPos := Pos(CRtfEC, ALine);
    if (xPos <> 0) and (xPos < Result) then begin
      Result := xPos;
      ACode := CRtfEC;
    end;
    xPos := Pos(CRtFLA, ALine);
    if (xPos <> 0) and (xPos < Result) then begin
      Result := xPos;
      ACode := CRtFLA;
    end;
    xPos := Pos(CRtFRA, ALine);
    if (xPos <> 0) and (xPos < Result) then begin
      Result := xPos;
      ACode := CRtFRA;
    end;
    xPos := Pos(CRtFCA, ALine);
    if (xPos <> 0) and (xPos < Result) then begin
      Result := xPos;
      ACode := CRtFCA;
    end;
  end;

var xCurLine: String;
    xPos: Integer;
    xCurStart: Integer;
    xCurBits: Integer;
    xCode: String;
    xCurAl: TAlignment;
begin
  SetLength(AAttributesList, 0);
  xCurLine := AText;
  xCurStart := 1;
  xCurBits := 0;
  xCurAl := taLeftJustify;
  repeat
    xPos := FindFirstCode(xCurLine, xCode);
    SetLength(AAttributesList, Length(AAttributesList) + 1);
    AAttributesList[High(AAttributesList)].theStart := xCurStart;
    AAttributesList[High(AAttributesList)].theEnd := xCurStart + xPos - 1;
    AAttributesList[High(AAttributesList)].styleBits := xCurBits;
    AAttributesList[High(AAttributesList)].TheAlignment := xCurAl;
    if xPos <> $FFFF then begin
      Delete(xCurLine, 1, xPos + Length(xCode) - 1);
      if xCode = CRtfSB then begin
        xCurBits := xCurBits or CStyleBold;
      end else if xCode = CRtfEB then begin
        xCurBits := xCurBits and (not CStyleBold);
      end else if xCode = CRtfSU then begin
        xCurBits := xCurBits or CStyleUnderline;
      end else if xCode = CRtfEU then begin
        xCurBits := xCurBits and (not CStyleUnderline);
      end else if xCode = CRtfSH then begin
        xCurBits := xCurBits or CStyleHigher;
      end else if xCode = CRtfEH then begin
        xCurBits := xCurBits and (not CStyleHigher);
      end else if xCode = CRtfSC then begin
        xCurBits := xCurBits or CStyleCondensed;
      end else if xCode = CRtfEC then begin
        xCurBits := xCurBits and (not CStyleCondensed);
      end else if xCode = CRtFLA then begin
        xCurAl := taLeftJustify;
      end else if xCode = CRtFRA then begin
        xCurAl := taRightJustify;
      end else if xCode = CRtFCA then begin
        xCurAl := taCenter;
      end;
    end else begin
      Delete(xCurLine, 1, Length(xCurLine));
    end;
    xCurStart := xCurStart + xPos - 1;
  until (Length(xCurLine) = 0);
  Result := StringReplace(AText, CRtfSB, '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, CRtfEB, '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, CRtfSU, '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, CRtfEU, '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, CRtfSH, '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, CRtfEH, '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, CRtfSC, '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, CRtfEC, '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, CRtFLA, '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, CRtFRA, '', [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, CRtFCA, '', [rfReplaceAll, rfIgnoreCase]);
end;

procedure AssignRichText(AText: String; ARichEdit: TRichEdit);
var xLines: TStringList;
    xCount_1, xCount_2: Integer;
    xCurLine: String;
    xArrayOfAttributes: TFormatStructureList;
    xCurPos: Integer;
    xRtfSize: Integer;
    xRtfStyle: TFontStyles;
begin
  SendMessage(ARichEdit.Handle, $400 + 120, 0, 0);
  ARichEdit.Lines.BeginUpdate;
  ARichEdit.Lines.Clear;
  if Pos('{\rtf1', AText) = 0 then begin
    xLines := TStringList.Create;
    xLines.Text := AText;
    xCurPos := 0;
    SetLength(xArrayOfAttributes, 0);
    for xCount_1 := 0 to xLines.Count - 1 do begin
      xCurLine := PrepareRichTextLine(xLines.Strings[xCount_1], xArrayOfAttributes);
      ARichEdit.Lines.Add(xCurLine);
      for xCount_2 := Low(xArrayOfAttributes) to High(xArrayOfAttributes) do begin
        with xArrayOfAttributes[xCount_2] do begin
          xRtfStyle := ARichEdit.DefAttributes.Style;
          xRtfSize := ARichEdit.DefAttributes.Size;
          if StyleBits and CStyleBold = CStyleBold then begin
            xRtfStyle := xRtfStyle + [fsBold];
          end;
          if StyleBits and CStyleUnderline = CStyleUnderline then begin
            xRtfStyle := xRtfStyle + [fsUnderline];
          end;
          if StyleBits and CStyleHigher = CStyleHigher then begin
            xRtfSize := xRtfSize + 2;
          end;
          if StyleBits and CStyleCondensed = CStyleCondensed then begin
            xRtfSize := xRtfSize - 2;
          end;
          ARichEdit.SelStart := xCurPos + TheStart - 1;
          ARichEdit.SelLength := TheEnd - TheStart;
          ARichEdit.SelAttributes.Style := xRtfStyle;
          ARichEdit.SelAttributes.Size := xRtfSize;
          ARichEdit.Paragraph.Alignment := TheAlignment;
        end;
      end;
      inc(xCurPos, Length(xCurLine) + 2);
    end;
    xLines.Free;
  end else begin
    ARichEdit.Text := AText;
  end;
  ARichEdit.Lines.EndUpdate;
end;

procedure TCBaseForm.FormDestroy(Sender: TObject);
begin
  SaveFormPosition(Self);
end;

procedure TCBaseForm.FormShow(Sender: TObject);
begin
  LoadFormPosition(Self);
end;

procedure TCBaseForm.WndProc(var Message: TMessage);
begin
  inherited WndProc(Message);
  if Message.Msg = WM_FORMMAXIMIZE then begin
    WindowState := wsMaximized;
  end else if Message.Msg = WM_FORMMINIMIZE then begin
    WindowState := wsMaximized;
  end;
end;

procedure TCBaseForm.Loaded;
var xCount: Integer;
begin
  inherited Loaded;
  for xCount := 0 to ComponentCount - 1 do begin
    if Components[xCount].InheritsFrom(TCStatic) then begin
      TCStatic(Components[xCount]).TabStop := True;
      TCStatic(Components[xCount]).Transparent := False;
    end;
  end;
end;

end.

