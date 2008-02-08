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
    FTries: Integer;
    procedure SetFilename(const Value: String);
  protected
    function CanAccept: Boolean; override;
    procedure DoAccept; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Filename: String write SetFilename;
  end;

function ConnectToDatabaseWithPassword(AFilename: String): Boolean;

implementation

{$R *.dfm}

uses FileCtrl, CConsts, CInfoFormUnit;

function ConnectToDatabaseWithPassword(AFilename: String): Boolean;
var xDialog: TCInitializeProviderForm;
begin
  xDialog := TCInitializeProviderForm.Create(Application);
  xDialog.Filename := AFilename;
  Result := xDialog.ShowConfig(coEdit);
  if not Result then begin
    GLastUsedPassword := '';
    GLastUsedPasswordPresent := False;
  end;
  xDialog.Free;
end;

function TCInitializeProviderForm.CanAccept: Boolean;
var xNativeErrorCode: Integer;
begin
  GLastUsedPassword := EditPassword.Text;
  GLastUsedPasswordPresent := True;
  Result := GDataProvider.OpenConnection(xNativeErrorCode, FFilename);
  if not Result then begin
    ShowInfo(itError, 'Podczas otwierania pliku danych wyst¹pi³ b³¹d', GDataProvider.LastError);
    EditPassword.SetFocus;
  end;
  Inc(FTries);
end;

constructor TCInitializeProviderForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTries := 0;
end;

procedure TCInitializeProviderForm.DoAccept;
begin
  inherited DoAccept;
  if (not Accepted) and (FTries = 3) then begin
    Close;
  end;
end;

procedure TCInitializeProviderForm.SetFilename(const Value: String);
begin
  FFilename := Value;
  Label3.Caption := MinimizeName(FFilename, Label3.Canvas, Label3.Width);
end;

end.
