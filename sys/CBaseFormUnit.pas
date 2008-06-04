unit CBaseFormUnit;

interface

uses
  Windows, Forms, Classes, ComCtrls, Graphics, SysUtils, Messages, CTemplates,
  Controls, VirtualTrees;

type
  TCBaseForm = class(TForm, IDescTemplateExpander)
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  protected
    procedure CloseForm; virtual;
    procedure WndProc(var Message: TMessage); override;
    procedure Loaded; override;
  public
    function ExpandTemplate(ATemplate: String): String; virtual;
  end;

implementation

uses CSettings, CBaseFrameUnit, CConsts, CComponents, CTools, DateUtils,
  CDatabase, CPreferences, Math, CDataObjects;

{$R *.dfm}

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
    end else if Components[xCount].InheritsFrom(TRichEdit) then begin
      TRichEdit(Components[xCount]).Font.Name := 'Microsoft Sans Serif';
    end else if Components[xCount].InheritsFrom(TCCurrEdit) then begin
      TCCurrEdit(Components[xCount]).CurrencyId := GDefaultCurrencyId;
    end;
  end;
end;

function TCBaseForm.ExpandTemplate(ATemplate: String): String;
begin
  Result := GBasePreferences.ExpandTemplate(ATemplate);
end;

end.

