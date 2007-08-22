unit SqlConsoleFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdoInt, ExtCtrls, StdCtrls, ComCtrls, Contnrs, ActnList,
  XPStyleActnCtrls, ActnMan, ToolWin, ActnCtrls, ActnMenus, Buttons,
  ImgList, PngImageList, PngSpeedButton, Printers;

type
  TSqlConsoleForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Splitter: TSplitter;
    RichEditCommand: TRichEdit;
    RichEditResult: TRichEdit;
    ActionManager: TActionManager;
    ActionExecute: TAction;
    Panel4: TPanel;
    PngImageList: TPngImageList;
    ActionOpen: TAction;
    ActionSave: TAction;
    ActionPrint: TAction;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    PrinterSetupDialog: TPrinterSetupDialog;
    PngSpeedButton1: TPngSpeedButton;
    PngSpeedButton2: TPngSpeedButton;
    PngSpeedButton3: TPngSpeedButton;
    PngSpeedButton4: TPngSpeedButton;
    procedure RichEditCommandKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure ActionExecuteExecute(Sender: TObject);
    procedure Panel1ConstrainedResize(Sender: TObject; var MinWidth, MinHeight, MaxWidth, MaxHeight: Integer);
    procedure ActionPrintExecute(Sender: TObject);
    procedure ActionSaveExecute(Sender: TObject);
    procedure ActionOpenExecute(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean);
  private
    FConnection: _Connection;
    FRecordset: _Recordset;
    procedure ExecuteCommand;
  public
    procedure PrepareResultset(ASql: String);
    procedure UpdateResult(AResult: String);
    property Connection: _Connection read FConnection write FConnection;
  end;

var
  SqlConsoleForm: TSqlConsoleForm;

implementation

uses CRichtext, CTools, CAdotools;

{$R *.dfm}

procedure TSqlConsoleForm.PrepareResultset(ASql: String);
var xAffected: OleVariant;
    xOutput: String;
begin
  FRecordset := Nil;
  try
    FRecordset := FConnection.Execute(ASql, xAffected, 0);
    if FRecordset.State = adStateOpen then begin
      xOutput := GetRowsAsString(FRecordset, '');
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
begin
  if Key = VK_F5 then begin
    ExecuteCommand;
  end;
end;

procedure TSqlConsoleForm.UpdateResult(AResult: String);
begin
  AssignRichText(AResult, RichEditResult);
end;

procedure TSqlConsoleForm.FormCreate(Sender: TObject);
begin
  RichEditCommand.Text := '//pamiêtaj, ¿e bezpoœrednie dzia³anie na bazie danych CManager-a' + sLineBreak +
                          '//mo¿e doprowadziæ do nieodwracalnej utraty danych, zastanów siê' + sLineBreak +
                          '//zanim wykonasz komendy insert, update lub delete';
  RichEditCommand.SelectAll;
  RichEditCommand.DefAttributes.Name := 'Courier';
  RichEditResult.Clear;
end;

procedure TSqlConsoleForm.ExecuteCommand;
var xCommand: String;
begin
  if RichEditCommand.SelLength > 0 then begin
    xCommand := RichEditCommand.SelText;
  end else begin
    xCommand := RichEditCommand.Text;
  end;
  if Trim(xCommand) <> '' then begin
    PrepareResultset(xCommand);
  end;
end;

procedure TSqlConsoleForm.ActionExecuteExecute(Sender: TObject);
begin
  ExecuteCommand;
end;

procedure TSqlConsoleForm.Panel1ConstrainedResize(Sender: TObject; var MinWidth, MinHeight, MaxWidth, MaxHeight: Integer);
begin
  MinHeight := 143;
end;

procedure TSqlConsoleForm.ActionPrintExecute(Sender: TObject);
begin
  if Printer.Printers.Count > 0 then begin
    if PrinterSetupDialog.Execute then begin
      RichEditResult.Print('');
    end;
  end else begin
    MessageBox(Application.Handle, 'W systemie nie zainstalowano ¿adnej drukarki', 'Uwaga', MB_OK + MB_ICONEXCLAMATION);
  end;
end;

procedure TSqlConsoleForm.ActionSaveExecute(Sender: TObject);
begin
  if SaveDialog.Execute then begin
    try
      RichEditResult.Lines.SaveToFile(SaveDialog.FileName);
    except
      on E: Exception do begin
        MessageBox(Application.Handle, PChar(E.Message), 'Uwaga', MB_OK + MB_ICONERROR);
      end;
    end;
  end;
end;

procedure TSqlConsoleForm.ActionOpenExecute(Sender: TObject);
begin
  if OpenDialog.Execute then begin
    try
      RichEditCommand.Lines.LoadFromFile(OpenDialog.FileName);
    except
      on E: Exception do begin
        MessageBox(Application.Handle, PChar(E.Message), 'Uwaga', MB_OK + MB_ICONERROR);
      end;
    end;
  end;
end;

procedure TSqlConsoleForm.FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer; var Resize: Boolean);
begin
  Resize := NewWidth >= 562;
end;

end.
