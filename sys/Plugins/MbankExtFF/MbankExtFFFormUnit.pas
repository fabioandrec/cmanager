unit MbankExtFFFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls, Buttons, MsHtml, ActiveX, MsXml;

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
  private
    FExtOutput: String;
    function PrepareOutput(AInpage: String; var AError: String): Boolean;
  public
    property ExtOutput: String read FExtOutput;
  end;

implementation

uses CTools, DateUtils, CXml, CPluginConsts;

{$R *.dfm}

procedure TMbankExtFFForm.BitBtnOkClick(Sender: TObject);
var xStr: TStringList;
    xError: String;
begin
  if Trim(EditName.Text) = '' then begin
    MessageBox(Handle, 'Nie podano nazwy pliku z wyci¹giem', 'B³¹d', MB_OK + MB_ICONERROR);
    EditName.SetFocus;
  end else if not FileExists(EditName.Text) then begin
    MessageBox(Handle, PChar('Brak pliku o nazwie ' + EditName.Text), 'B³¹d', MB_OK + MB_ICONERROR);
  end else begin
    xStr := TStringList.Create;
    try
      try
        xStr.LoadFromFile(EditName.Text);
        if PrepareOutput(xStr.Text, xError) then begin
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

function TMbankExtFFForm.PrepareOutput(AInpage: String; var AError: String): Boolean;

  function DecodeDate(AStr: String; var AStart, AEnd: TDateTime): Boolean;
  var xMonth: Integer;
      xYear: Integer;
  begin
    AStart := 0;
    AEnd := 0;
    Result := False;
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

  function AppendExtractionItem(ARootNode: IXMLDOMNode; ARow: IHTMLElement; var AError: String): Boolean;
  var xAll: IHTMLElementCollection;
      xCount: Integer;
      xElement: IHTMLElement;
      xData: Integer;
      xDatesStr: TStringList;
      xTitlesStr: TStringList;
      xCashStr, xTitle: String;
      xRegDate, xAccountingDate: TDateTime;
      xCash: Currency;
      xExtractionNode: IXMLDOMNode;
  begin
    Result := True;
    AError := 'Nieokreœlono lub okreœlono niepoprawnie dane dla elementu wyci¹gu';
    xAll := ARow.all as IHTMLElementCollection;
    xCount := 0;
    xData := 0;
    xDatesStr := TStringList.Create;
    xTitlesStr := TStringList.Create;
    xCashStr := '';
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
    if (xDatesStr.Text <> '') and (xTitlesStr.Text <> '') and (xCashStr <> '') then begin
      if xDatesStr.Count > 0 then begin
        xRegDate := DmyToDate(xDatesStr.Strings[0], 0);
      end else begin
        xRegDate := 0;
      end;
      if xDatesStr.Count > 1 then begin
        xAccountingDate := DmyToDate(xDatesStr.Strings[1], 0);
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
        SetXmlAttribute('currency', xExtractionNode, 'PLN');
        SetXmlAttribute('description', xExtractionNode, xTitle);
        SetXmlAttribute('cash', xExtractionNode, Trim(Format('%-10.4f', [xCash])));
      end else begin
        Result := False;
      end;
    end else begin
      Result := False;
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
    xOutXml: IXMLDOMDocument;
    xDocElement: IXMLDOMElement;
begin
  Result := False;
  FExtOutput := '';
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
                if DecodeDate(xPeriodStr, xStartDate, xEndDate) then begin
                  xOutXml := GetXmlDocument;
                  xDocElement := xOutXml.createElement('accountExtraction');
                  xOutXml.appendChild(xDocElement);
                  SetXmlAttribute('creationDate', xDocElement, FormatDateTime('yyyymmdd', xEndDate));
                  SetXmlAttribute('startDate', xDocElement, FormatDateTime('yyyymmdd', xStartDate));
                  SetXmlAttribute('endDate', xDocElement, FormatDateTime('yyyymmdd', xEndDate));
                  SetXmlAttribute('description', xDocElement, (xTabHeader.rows.item(0, varEmpty) as IHTMLElement).innerText);
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
                          Result := AppendExtractionItem(xDocElement, xElement, AError);
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

end.
