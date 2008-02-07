unit CInitializeProviderFormUnit;

interface

{$WARN UNIT_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, CComponents, CDatabase;

type
  TCInitializeProviderForm = class(TCConfigForm)
    Label1: TLabel;
    EditPassword: TEdit;
    Label3: TLabel;
    Image1: TImage;
  private
    FFilename: String;
    procedure SetFilename(const Value: String);
  protected
    function CanAccept: Boolean; override;
  published
    property Filename: String write SetFilename;
  end;

function ConnectToDatabaseWithPassword(AFilename: String): Boolean;

implementation

{$R *.dfm}

uses FileCtrl, CConsts;

function ConnectToDatabaseWithPassword(AFilename: String): Boolean;
var xDialog: TCInitializeProviderForm;
begin
  xDialog := TCInitializeProviderForm.Create(Application);
  xDialog.Filename := AFilename;
  Result := xDialog.ShowConfig(coEdit);
  xDialog.Free;
end;

function TCInitializeProviderForm.CanAccept: Boolean;
var xNativeErrorCode: Integer;
begin
  Result := GDataProvider.ConnectToDatabase(Format(CDefaultConnectionStringWithPass, [FFilename, EditPassword.Text]), xNativeErrorCode);
end;

procedure TCInitializeProviderForm.SetFilename(const Value: String);
begin
  FFilename := Value;
  Label3.Caption := MinimizeName(FFilename, Label3.Canvas, Label3.Width);
end;

end.
