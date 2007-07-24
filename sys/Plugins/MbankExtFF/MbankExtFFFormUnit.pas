unit MbankExtFFFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls, Buttons, MsHtml, ActiveX;

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

uses CTools, DateUtils;

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
begin
  Result := False;
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
                      ShowMessage(IntToStr(xTabOperations.rows.length));
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
  FExtOutput := '';
end;

end.
