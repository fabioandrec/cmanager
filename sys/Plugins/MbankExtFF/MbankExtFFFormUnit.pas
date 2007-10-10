unit MbankExtFFFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls, Buttons, MsHtml, ActiveX, Types;

type
  TMbankExtFFForm = class(TForm)
    Image: TImage;
    Label1: TLabel;
    OpenDialog: TOpenDialog;
    PanelButtons: TPanel;
    BitBtnOk: TBitBtn;
    BitBtnCancel: TBitBtn;
    EditName: TEdit;
    SpeedButton1: TSpeedButton;
    procedure BitBtnOkClick(Sender: TObject);
    procedure BitBtnCancelClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FExtOutput: String;
    function PrepareOutputHtml(AInpage: String; var AError: String): Boolean;
    function PrepareOutputCsv(AInpage: String; var AError: String): Boolean;
    function DecodeDate(AStr: String; AIsCreditCard: Boolean; var AStart, AEnd: TDateTime): Boolean;
  public
    property ExtOutput: String read FExtOutput;
  end;

implementation

uses CTools, DateUtils, CXml, CPluginConsts;

{$R *.dfm}

procedure TMbankExtFFForm.BitBtnOkClick(Sender: TObject);
var xStr: TStringList;
    xError: String;
    xExt: String;
    xRes: Boolean;
begin
  if Trim(EditName.Text) = '' then begin
    MessageBox(Handle, 'Nie podano nazwy pliku z wyci¹giem', 'B³¹d', MB_OK + MB_ICONERROR);
    EditName.SetFocus;
  end else if not FileExists(EditName.Text) then begin
    MessageBox(Handle, PChar('Brak pliku o nazwie ' + EditName.Text), 'B³¹d', MB_OK + MB_ICONERROR);
  end else begin
    xExt := AnsiLowerCase(ExtractFileExt(EditName.Text));
    if (xExt = '.txt') or (xExt = '.csv') or (xExt = '.htm') or (xExt = '.html') then begin
      xStr := TStringList.Create;
      try
        try
          xStr.LoadFromFile(EditName.Text);
          if (xExt = '.txt') or (xExt = '.csv') then begin
            xRes := PrepareOutputCsv(xStr.Text, xError);
          end else begin
            xRes := PrepareOutputHtml(xStr.Text, xError);
          end;
          if xRes then begin
            ModalResult := mrOk;
          end else begin
            MessageBox(Handle, PChar(xError), 'B³¹d', MB_OK + MB_ICONERROR);
          end;
        except
          on E: Exception do begin
            MessageBox(Handle, PChar('Nie mo¿na wczytaæ pliku ' + EditName.Text), 'B³¹d', MB_OK + MB_ICONERROR);
          end;
        end;
      finally
        xStr.Free;
      end;
    end else begin
      MessageBox(Handle, PChar('Nieznane rozszerzenie pliku z wyci¹giem. Plik powienien mieæ ' + sLineBreak +
                         'jedno z nastêpuj¹cych rozszerzeñ *.txt, *.csv, *.htm, *.html'), 'B³¹d', MB_OK + MB_ICONERROR);
    end;
  end;
end;

procedure TMbankExtFFForm.BitBtnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TMbankExtFFForm.SpeedButton1Click(Sender: TObject);
begin
  if OpenDialog.Execute then begin
    EditName.Text := OpenDialog.FileName;
  end;
end;

function TMbankExtFFForm.DecodeDate(AStr: String; AIsCreditCard: Boolean; var AStart, AEnd: TDateTime): Boolean;
var xMonth: Integer;
    xYear: Integer;
begin
  AStart := 0;
  AEnd := 0;
  Result := False;
  if AIsCreditCard then begin
    AStart := YmdToDate(Copy(AStr, 1, 10), 0);
    AEnd := YmdToDate(Copy(AStr, Length(AStr) - 9, 10), 0);
    Result := (AStart <> 0) and (AEnd <> 0);
  end else begin
    xMonth := GetMonthNumber(Copy(AStr, 1, Length(AStr) - 5));
    if (xMonth > 0) and (xMonth <= 12) then begin
      xYear := StrToIntDef(Copy(AStr, Length(AStr) - 3, 4), 0);
      if xYear > 0 then begin
        Result := TryEncodeDate(xYear, xMonth, 1, AStart);
        if Result then begin
          Result := TryEncodeDate(xYear, xMonth, DaysInMonth(AStart), AEnd);
        end;
      end;
    end;
  end;
end;

function TMbankExtFFForm.PrepareOutputHtml(AInpage: String; var AError: String): Boolean;

  function AppendExtractionItem(ARootNode: ICXMLDOMNode; ARow: IHTMLElement; AIsCreditCard: Boolean; var AError: String): Boolean;
  var xAll: IHTMLElementCollection;
      xCount: Integer;
      xElement: IHTMLElement;
      xData: Integer;
      xDatesStr: TStringList;
      xTitlesStr: TStringList;
      xCashStr, xTitle: String;
      xRegDate, xAccountingDate: TDateTime;
      xCash: Currency;
      xCurrStr: String;
      xExtractionNode: ICXMLDOMNode;
      xAppenRow: Boolean;
  begin
    Result := True;
    AError := 'Nieokreœlono lub okreœlono niepoprawnie dane dla elementu wyci¹gu';
    xAll := ARow.all as IHTMLElementCollection;
    xCount := 0;
    xData := 0;
    xDatesStr := TStringList.Create;
    xTitlesStr := TStringList.Create;
    xCashStr := '';
    xAppenRow := False;
    if AIsCreditCard then begin
      if xAll.length > 1 then begin
        xElement := xAll.item(0, varEmpty) as IHTMLElement;
        if StrToIntDef(xElement.innerText, -1) >= 1 then begin
          xAppenRow := True;
          while (xCount <= xAll.length - 1) and Result do begin
            xElement := xAll.item(xCount, varEmpty) as IHTMLElement;
            if xCount = 1 then begin
              xDatesStr.Text := xElement.innerText;
            end else if xCount = 3 then begin
              xTitlesStr.Text := PolishConversion(splISO, splWindows, xElement.innerText);
            end else if xCount = 4 then begin
              if xTitlesStr.Text <> '' then begin
                xTitlesStr.Text := xTitlesStr.Text + ' ';
              end;
              xTitlesStr.Text := xTitlesStr.Text + PolishConversion(splISO, splWindows, xElement.innerText);
            end else if xCount = 5 then begin
              xCashStr := StringReplace(xElement.innerText, '.', '', [rfReplaceAll, rfIgnoreCase]);
              xCashStr := StringReplace(xCashStr, ' ', '', [rfReplaceAll, rfIgnoreCase]);
              xCurrStr := Copy(xCashStr, Length(xCashStr) - 2, 3);
              Delete(xCashStr, Length(xCashStr) - 2, 3);
            end;
            Inc(xCount);
          end;
        end;
      end;
    end else begin
      xCurrStr := 'PLN';
      xAppenRow := True;
      while (xCount <= xAll.length - 1) and Result do begin
        xElement := xAll.item(xCount, varEmpty) as IHTMLElement;
        if xElement.className = 'data' then begin
          if xData = 0 then begin
            xDatesStr.Text := xElement.innerText;
          end else if xData = 1 then begin
            xTitlesStr.Text := PolishConversion(splISO, splWindows, xElement.innerText);
          end else if xData = 2 then begin
            xCashStr := StringReplace(xElement.innerText, '.', '', [rfReplaceAll, rfIgnoreCase]);
          end;
          Inc(xData);
        end;
        Inc(xCount);
      end;
    end;
    if xAppenRow then begin
      if (xDatesStr.Text <> '') and (xTitlesStr.Text <> '') and (xCashStr <> '') then begin
        if xDatesStr.Count > 0 then begin
          if AIsCreditCard then begin
            xRegDate := YmdToDate(xDatesStr.Strings[0], 0);
          end else begin
            xRegDate := DmyToDate(xDatesStr.Strings[0], 0);
          end;
        end else begin
          xRegDate := 0;
        end;
        if xDatesStr.Count > 1 then begin
          if AIsCreditCard then begin
            xAccountingDate := YmdToDate(xDatesStr.Strings[1], 0);
          end else begin
            xAccountingDate := DmyToDate(xDatesStr.Strings[1], 0);
          end;
        end else begin
          xAccountingDate := 0;
        end;
        if (xRegDate <> 0) and (xAccountingDate <> 0) then begin
          xCash := StrToCurrencyDecimalDot(xCashStr);
          xTitle := xTitlesStr.Text;
          xExtractionNode := ARootNode.ownerDocument.createElement('extractionItem');
          ARootNode.appendChild(xExtractionNode);
          SetXmlAttribute('operationDate', xExtractionNode, FormatDateTime('yyyymmdd', xRegDate));
          SetXmlAttribute('accountingDate', xExtractionNode, FormatDateTime('yyyymmdd', xAccountingDate));
          if xCash > 0 then begin
            SetXmlAttribute('type', xExtractionNode, CEXTRACTION_INMOVEMENT);
          end else begin
            SetXmlAttribute('type', xExtractionNode, CEXTRACTION_OUTMOVEMENT);
          end;
          SetXmlAttribute('currency', xExtractionNode, xCurrStr);
          SetXmlAttribute('description', xExtractionNode, xTitle);
          SetXmlAttribute('cash', xExtractionNode, Trim(Format('%-10.4f', [xCash])));
        end else begin
          Result := False;
        end;
      end else begin
        Result := False;
      end;
    end;
    xDatesStr.Free;
    xTitlesStr.Free;
    if Result then begin
      AError := '';
    end;
  end;

var xDoc: IHTMLDocument2;
    xVar: Variant;
    xBody, xElement: IHTMLElement;
    xAll: IHTMLElementCollection;
    xCount: Integer;
    xFinished: Boolean;
    xTabCount, xPos: Integer;
    xTabHeader, xTabBase, xTabOperations: IHTMLTable;
    xBaseRow: IHTMLElement;
    xPeriodStr: String;
    xStartDate, xEndDate: TDateTime;
    xOutXml: ICXMLDOMDocument;
    xDocElement: ICXMLDOMElement;
    xIsCreditCard: Boolean;
    xStr: String;
begin
  Result := False;
  FExtOutput := '';
  xIsCreditCard := Pos('RACHUNKU KARTY KREDYTOWEJ', AInpage) > 0;
  try
    xDoc := CoHTMLDocument.Create as IHTMLDocument2;
    try
      try
        xDoc.designMode := 'on';
        while xDoc.readyState <> 'complete' do begin
          Application.ProcessMessages;
        end;
        xVar := VarArrayCreate([0, 0], VarVariant);
        xVar[0] := AInpage;
        xDoc.Write(PSafeArray(System.TVarData(xVar).VArray));
        xDoc.designMode := 'off';
        while xDoc.readyState <> 'complete' do begin
          Application.ProcessMessages;
        end;
        AError := 'Wskazany plik nie jest poprawnym wyci¹giem mBanku';
        xBody := xDoc.body;
        if xBody <> Nil then begin
          xAll := xBody.all as IHTMLElementCollection;
          if xAll <> Nil then begin
            if not xIsCreditCard then begin
              xCount := 0;
              xFinished := False;
              xTabCount := 0;
              xTabHeader := Nil;
              xTabBase := Nil;
              while (xCount <= xAll.length - 1) and (not xFinished) do begin
                xElement := xAll.item(xCount, varEmpty) as IHTMLElement;
                if AnsiLowerCase(xElement.tagName) = 'table' then begin
                  Inc(xTabCount);
                end;
                if (xTabCount = 3) and (xTabHeader = Nil) then begin
                  xTabHeader := xElement as IHTMLTable;
                end;
                if (xTabCount = 6) and (xTabBase = Nil) then begin
                  xTabBase := xElement as IHTMLTable;
                end;
                Inc(xCount);
                xFinished := (xTabHeader <> Nil) and (xTabBase <> Nil);
              end;
              if (xTabHeader <> Nil) and (xTabBase <> Nil) then begin
                xPeriodStr := AnsiUpperCase((xTabHeader.rows.item(0, varEmpty) as IHTMLElement).innerText);
                xPos := Pos('ZA', xPeriodStr);
                if xPos > 0 then begin
                  xPeriodStr := Copy(xPeriodStr, xPos + 3, MaxInt);
                  if DecodeDate(xPeriodStr, False, xStartDate, xEndDate) then begin
                    xOutXml := GetXmlDocument;
                    xDocElement := xOutXml.createElement('accountExtraction');
                    xOutXml.appendChild(xDocElement);
                    SetXmlAttribute('creationDate', xDocElement, FormatDateTime('yyyymmdd', xEndDate));
                    SetXmlAttribute('startDate', xDocElement, FormatDateTime('yyyymmdd', xStartDate));
                    SetXmlAttribute('endDate', xDocElement, FormatDateTime('yyyymmdd', xEndDate));
                    SetXmlAttribute('description', xDocElement, PolishConversion(splISO, splWindows, (xTabHeader.rows.item(0, varEmpty) as IHTMLElement).innerText));
                    if xTabBase.rows.length >= 4 then begin
                      xBaseRow := (xTabHeader.rows.item(3, varEmpty) as IHTMLElement);
                      xAll := xBaseRow.all as IHTMLElementCollection;
                      xTabOperations := Nil;
                      xCount := 0;
                      while (xCount <= xAll.length - 1) and (xTabOperations = Nil) do begin
                        xElement := xAll.item(xCount, varEmpty) as IHTMLElement;
                        if AnsiLowerCase(xElement.tagName) = 'table' then begin
                          xTabOperations := xElement as IHTMLTable;
                        end;;
                        Inc(xCount);
                      end;
                      if xTabOperations <> Nil then begin
                        xCount := 0;
                        Result := True;
                        while (xCount <= xTabOperations.rows.length - 1) and Result do begin
                          if (xCount > 1) and (xCount < xTabOperations.rows.length - 1) then begin
                            xElement := xTabOperations.rows.item(xCount, varEmpty) as IHTMLElement;
                            Result := AppendExtractionItem(xDocElement, xElement, False, AError);
                          end;
                          Inc(xCount);
                        end;
                      end;
                    end;
                    if Result then begin
                      FExtOutput := GetStringFromDocument(xOutXml);
                    end;
                  end;
                end;
              end;
            end else begin
              xCount := 0;
              xFinished := False;
              xTabCount := 0;
              xTabHeader := Nil;
              xTabBase := Nil;
              while (xCount <= xAll.length - 1) and (not xFinished) do begin
                xElement := xAll.item(xCount, varEmpty) as IHTMLElement;
                if AnsiLowerCase(xElement.tagName) = 'table' then begin
                  Inc(xTabCount);
                end;
                if (xTabCount = 3) and (xTabHeader = Nil) then begin
                  xTabHeader := xElement as IHTMLTable;
                end;
                if (xTabCount = 9) and (xTabBase = Nil) then begin
                  xTabBase := xElement as IHTMLTable;
                end;
                Inc(xCount);
                xFinished := (xTabHeader <> Nil) and (xTabBase <> Nil);
              end;
              if (xTabHeader <> Nil) and (xTabBase <> Nil) then begin
                xPeriodStr := AnsiUpperCase((xTabHeader.rows.item(0, varEmpty) as IHTMLElement).innerText);
                xPos := Pos('ZA OKRES OD', xPeriodStr);
                if xPos > 0 then begin
                  xPeriodStr := Copy(xPeriodStr, xPos + 12, MaxInt);
                  if DecodeDate(xPeriodStr, True, xStartDate, xEndDate) then begin
                    xOutXml := GetXmlDocument;
                    xDocElement := xOutXml.createElement('accountExtraction');
                    xOutXml.appendChild(xDocElement);
                    SetXmlAttribute('creationDate', xDocElement, FormatDateTime('yyyymmdd', xEndDate));
                    SetXmlAttribute('startDate', xDocElement, FormatDateTime('yyyymmdd', xStartDate));
                    SetXmlAttribute('endDate', xDocElement, FormatDateTime('yyyymmdd', xEndDate));
                    xStr := PolishConversion(splISO, splWindows, (xTabHeader.rows.item(0, varEmpty) as IHTMLElement).innerText);
                    SetXmlAttribute('description', xDocElement, TrimStr(xStr, sLineBreak));
                    if xTabBase.rows <> Nil then begin
                      if xTabBase.rows.length >= 0 then begin
                        xCount := 0;
                        Result := True;
                        while (xCount <= xTabBase.rows.length - 1) and Result do begin
                          if (xCount >= 1) and (xCount < xTabBase.rows.length - 1) then begin
                            xElement := xTabBase.rows.item(xCount, varEmpty) as IHTMLElement;
                            if AnsiLowerCase(xElement.className) <> 'head' then begin
                              Result := AppendExtractionItem(xDocElement, xElement, True, AError);
                            end;
                          end;
                          Inc(xCount);
                        end;
                      end;
                    end;
                    if Result then begin
                      FExtOutput := GetStringFromDocument(xOutXml);
                    end;
                  end;
                end;
              end;
            end;
          end;
        end;
      except
        AError := 'B³¹d wczytywania pliku zawieraj¹cego wyci¹g';
      end;
    finally
      xDoc := Nil;
    end;
  except
    AError := 'Brak obiektu IHTMLDocument2';
  end;
end;

procedure TMbankExtFFForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then begin
    ModalResult := mrCancel;
  end;
end;

function TMbankExtFFForm.PrepareOutputCsv(AInpage: String; var AError: String): Boolean;

  function AppendExtractionItem(ARootNode: ICXMLDOMNode; ARow: TStringDynArray; AIsCreditCard: Boolean; var AError: String): Boolean;
  var xTitle, xCurrStr, xCashStr: String;
      xRegDate, xAccountingDate: TDateTime;
      xCash: Currency;
      xExtractionNode: ICXMLDOMNode;
  begin
    AError := 'Nieokreœlono lub okreœlono niepoprawnie dane dla elementu wyci¹gu';
    if AIsCreditCard then begin
      xRegDate := YmdToDate(ARow[Low(ARow) + 1], 0);
      xAccountingDate := YmdToDate(ARow[Low(ARow) + 2], 0);
      xTitle := Trim(ARow[Low(ARow) + 3]) + sLineBreak + Trim(ARow[Low(ARow) + 4]);
      xCashStr := StringReplace(Trim(ARow[Low(ARow) + 5]), '.', '', [rfReplaceAll, rfIgnoreCase]);
      xCashStr := StringReplace(xCashStr, ' ', '', [rfReplaceAll, rfIgnoreCase]);
      xCash := StrToCurrencyDecimalDot(xCashStr);
      xCurrStr := Trim(ARow[Low(ARow) + 6]);
      Result := (xRegDate <> 0) and (xAccountingDate <> 0);
    end else begin
      xRegDate := DmyToDate(ARow[Low(ARow)], 0);
      xAccountingDate := YmdToDate(ARow[Low(ARow) + 1], 0);
      xCashStr := StringReplace(Trim(ARow[Low(ARow) + 7]), '.', '', [rfReplaceAll, rfIgnoreCase]);
      xCashStr := StringReplace(xCashStr, ' ', '', [rfReplaceAll, rfIgnoreCase]);
      xCash := StrToCurrencyDecimalDot(xCashStr);
      xTitle := Trim(ARow[Low(ARow) + 2]) + sLineBreak + Trim(ARow[Low(ARow) + 3]) + sLineBreak +
                Trim(ARow[Low(ARow) + 4]) + sLineBreak + Trim(ARow[Low(ARow) + 5]) + sLineBreak +
                Trim(ARow[Low(ARow) + 6]);
      xCurrStr := 'PLN';
      Result := (xRegDate <> 0) and (xAccountingDate <> 0);
    end;
    if Result then begin
      xExtractionNode := ARootNode.ownerDocument.createElement('extractionItem');
      ARootNode.appendChild(xExtractionNode);
      SetXmlAttribute('operationDate', xExtractionNode, FormatDateTime('yyyymmdd', xRegDate));
      SetXmlAttribute('accountingDate', xExtractionNode, FormatDateTime('yyyymmdd', xAccountingDate));
      if xCash > 0 then begin
        SetXmlAttribute('type', xExtractionNode, CEXTRACTION_INMOVEMENT);
      end else begin
        SetXmlAttribute('type', xExtractionNode, CEXTRACTION_OUTMOVEMENT);
      end;
      SetXmlAttribute('currency', xExtractionNode, xCurrStr);
      SetXmlAttribute('description', xExtractionNode, xTitle);
      SetXmlAttribute('cash', xExtractionNode, Trim(Format('%-10.4f', [xCash])));
    end;
    if Result then begin
      AError := '';
    end;
  end;

  function SplitToArray(AString: String): TStringDynArray;
  var xStr: String;
      xPos: Integer;
      xPart: String;
  begin
    xStr := AString;
    SetLength(Result, 0);
    repeat
      xPos := Pos(';', xStr);
      if xPos > 0 then begin
        xPart := Trim(Copy(xStr, 1, xPos - 1));
        Delete(xStr, 1, xPos);
        SetLength(Result, Length(Result) + 1);
        Result[High(Result)] := xPart;
      end else begin
        xPart := Trim(xStr);
        if (xPart <> '') then begin
          SetLength(Result, Length(Result) + 1);
          Result[High(Result)] := xPart;
        end;
        xStr := '';
      end;
    until xStr = '';
  end;

var xIsCreditCard: Boolean;
    xLines: TStringList;
    xStartDate, xEndDate: TDateTime;
    xM, xY: Word;
    xCount: Integer;
    xSplit: TStringDynArray;
    xTitle: String;
    xOutXml: ICXMLDOMDocument;
    xDocElement: ICXMLDOMNode;
    xPeriodStr: String;
    xOperationsBlock: Boolean;
    xValid: Boolean;
begin
  FExtOutput := '';
  xLines := TStringList.Create;
  xOutXml := GetXmlDocument;
  xDocElement := xOutXml.createElement('accountExtraction');
  xOutXml.appendChild(xDocElement);
  try
    xLines.Text := AInpage;
    xIsCreditCard := Pos('Z RACHUNKU KARTY KREDYTOWEJ', AInpage) > 0;
    if xIsCreditCard then begin
      xCount := 0;
      xTitle := '';
      xOperationsBlock := False;
      xValid := True;
      while (xCount <= xLines.Count - 1) and xValid do begin
        xSplit := SplitToArray(xLines.Strings[xCount]);
        if Length(xSplit) > 0 then begin
          if xSplit[Low(xSplit)] = 'WYCI¥G NR' then begin
            xTitle := xSplit[Low(xSplit)] + ' ' + xSplit[High(xSplit)];
            Inc(xCount);
            if xCount <= xLines.Count then begin
              xSplit := SplitToArray(xLines.Strings[xCount]);
              if Length(xSplit) > 0 then begin
                xTitle := xTitle + ' ' + xSplit[Low(xSplit)];
              end;
            end;
            Inc(xCount);
            if xCount <= xLines.Count then begin
              xSplit := SplitToArray(xLines.Strings[xCount]);
              if Length(xSplit) > 0 then begin
                xTitle := xTitle + ' ' + xSplit[Low(xSplit)];
              end;
            end;
            Inc(xCount);
            if xCount <= xLines.Count then begin
              xSplit := SplitToArray(xLines.Strings[xCount]);
              if Length(xSplit) > 0 then begin
                xTitle := xTitle + sLineBreak + xSplit[Low(xSplit)];
                xPeriodStr := Trim(Copy(xSplit[Low(xSplit)], 13, MaxInt));
                DecodeDate(xPeriodStr, True, xStartDate, xEndDate);
              end;
            end;
          end;
          if xOperationsBlock then begin
            if Length(xSplit) = 8 then begin
              if StrToIntDef(Trim(xSplit[Low(xSplit)]), -1) > 0 then begin
                xValid := AppendExtractionItem(xDocElement, xSplit, True, AError);
              end else begin
                xOperationsBlock := False;
              end;
            end else begin
              xOperationsBlock := False;
            end;
          end;
          if AnsiUpperCase(xSplit[Low(xSplit)]) = '#NR OPER.' then begin
            xOperationsBlock := True;
          end;
        end else begin
          xOperationsBlock := False;
        end;
        Inc(xCount);
      end;
      Result := xValid and (xStartDate <> 0) and (xEndDate <> 0);
    end else begin
      xCount := 0;
      xTitle := '';
      xOperationsBlock := False;
      xValid := True;
      while (xCount <= xLines.Count - 1) and xValid do begin
        xSplit := SplitToArray(xLines.Strings[xCount]);
        if Length(xSplit) > 0 then begin
          if AnsiUpperCase(xSplit[Low(xSplit)]) = 'ELEKTRONICZNE ZESTAWIENIE OPERACJI ZA' then begin
            xY := StrToIntDef(Copy(xSplit[High(xSplit)], 1, 4), 0);
            xM := StrToIntDef(Copy(xSplit[High(xSplit)], 6, 2), 0);
            if (xY <> 0) and (xM <> 0) then begin
              xStartDate := EncodeDateTime(xY, xM, 1, 0, 0, 0, 0);
              xEndDate := EncodeDateTime(xY, xM, DaysInAMonth(xY, xM), 0, 0, 0, 0);
            end;
            xTitle := xSplit[Low(xSplit)] + ' ' + xSplit[High(xSplit)];
          end;
          if xOperationsBlock then begin
            if Length(xSplit) = 9 then begin
              xValid := AppendExtractionItem(xDocElement, xSplit, False, AError);
            end else begin
              xOperationsBlock := False;
            end;
          end;
          if AnsiUpperCase(xSplit[Low(xSplit)]) = '#DATA OPERACJI' then begin
            xOperationsBlock := True;
          end;
        end else begin
          xOperationsBlock := False;
        end;
        Inc(xCount);
      end;
      Result := xValid and (xStartDate <> 0) and (xEndDate <> 0);
    end;
    if Result then begin
      SetXmlAttribute('creationDate', xDocElement, FormatDateTime('yyyymmdd', xEndDate));
      SetXmlAttribute('startDate', xDocElement, FormatDateTime('yyyymmdd', xStartDate));
      SetXmlAttribute('endDate', xDocElement, FormatDateTime('yyyymmdd', xEndDate));
      SetXmlAttribute('description', xDocElement, xTitle);
      FExtOutput := GetStringFromDocument(xOutXml);
    end;
  finally
    xLines.Free;
    xOutXml := Nil;
  end;
end;

end.
