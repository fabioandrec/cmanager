unit SqlConsoleFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdoInt, ExtCtrls, StdCtrls, ComCtrls, Contnrs;

type
  TSqlConsoleForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Splitter: TSplitter;
    RichEditCommand: TRichEdit;
    RichEditResult: TRichEdit;
    Panel3: TPanel;
    procedure RichEditCommandKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    FConnection: _Connection;
    FRecordset: _Recordset;
  public
    procedure PrepareResultset(ASql: String);
    procedure UpdateResult(AResult: String);
    property Connection: _Connection read FConnection write FConnection;
  end;

var
  SqlConsoleForm: TSqlConsoleForm;

implementation

uses CRichtext, CTools;

{$R *.dfm}

procedure TSqlConsoleForm.PrepareResultset(ASql: String);
var xAffected: OleVariant;
    xOutput: String;
    xCf: Integer;
    xValue: String;
    xRows: TObjectList;
    xColumns: TStringList;
    xWidths: Array of Integer;
    xRc, xCc: Integer;
begin
  FRecordset := Nil;
  try
    FRecordset := FConnection.Execute(ASql, xAffected, 0);
    if FRecordset.State = adStateOpen then begin
      xRows := TObjectList.Create(True);
      SetLength(xWidths, FRecordset.Fields.Count);
      for xCf := Low(xWidths) to High(xWidths) do begin
        xWidths[xCf] := -1;
      end;
      xColumns := TStringList.Create;
      for xCf := 0 to FRecordset.Fields.Count - 1 do begin
        xColumns.Add(FRecordset.Fields.Item[xCf].Name);
        if xWidths[xCf] < Length(FRecordset.Fields.Item[xCf].Name) then begin
          xWidths[xCf] := Length(FRecordset.Fields.Item[xCf].Name);
        end;
      end;
      xRows.Add(xColumns);
      while not FRecordset.Eof do begin
        xColumns := TStringList.Create;
        for xCf := 0 to FRecordset.Fields.Count - 1 do begin
          try
            if VarIsNull(FRecordset.Fields.Item[xCf].Value) then begin
              xValue := 'null';
            end else begin
              xValue := FRecordset.Fields.Item[xCf].Value;
            end;
          except
            xValue := '<b³¹d>';
          end;
          if xWidths[xCf] < Length(xValue) then begin
            xWidths[xCf] := Length(xValue);
          end;
          xColumns.Add(xValue);
        end;
        xRows.Add(xColumns);
        FRecordset.MoveNext;
      end;
      xOutput := '';
      for xRc := 0 to xRows.Count - 1 do begin
        xColumns := TStringList(xRows.Items[xRc]);
        for xCc := 0 to xColumns.Count - 1 do begin
          xOutput := xOutput + RPad(xColumns.Strings[xCc], ' ', xWidths[xCc]);
          if xColumns.Count - 1 <> xCc then begin
            xOutput := xOutput + '  ';
          end;
        end;
        xOutput := xOutput + sLineBreak;
      end;
    end else begin
      xOutput := 'Wykonano dla ' + IntToStr(xAffected) + ' wierszy/a';
    end;
  except
    on E: Exception do begin
      xOutput := E.Message;
    end;
  end;
  UpdateResult(xOutput);
end;

procedure TSqlConsoleForm.RichEditCommandKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var xCommand: String;
begin
  if Key = VK_F5 then begin
    if RichEditCommand.SelLength > 0 then begin
      xCommand := RichEditCommand.SelText;
    end else begin
      xCommand := RichEditCommand.Text;
    end;
    if Trim(xCommand) <> '' then begin
      PrepareResultset(xCommand);
    end;
  end;
end;

procedure TSqlConsoleForm.UpdateResult(AResult: String);
begin
  AssignRichText(AResult, RichEditResult);
end;

procedure TSqlConsoleForm.FormCreate(Sender: TObject);
begin
  RichEditCommand.Text := '//pamiêtaj, ¿e bezpoœrednie dzia³anie na bazie danych CManager-a' + sLineBreak +
                          '//mo¿e doprowadziæ do nieodwracalnej utraty danych, zastanów siê zanim' + sLineBreak +
                          '//wykonasz komendy insert, update lub delete';
  RichEditCommand.SelectAll;
  RichEditCommand.DefAttributes.Name := 'Courier';
  RichEditResult.Clear;
end;

end.
