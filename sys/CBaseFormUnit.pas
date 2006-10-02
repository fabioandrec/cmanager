unit CBaseFormUnit;

interface

uses
  Windows, Forms, Classes;

type
  TCBaseForm = class(TForm)
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  protected
    procedure CloseForm; virtual;
  end;

implementation

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

end.

