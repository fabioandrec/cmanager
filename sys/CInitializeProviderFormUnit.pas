unit CInitializeProviderFormUnit;

interface

{$WARN UNIT_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, CComponents, pngimage, AdoDb;

type
  TInitializeProviderResult = (iprSuccess, iprCancelled, iprError);

  TCInitializeProviderForm = class(TCConfigForm)
    Image1: TImage;
    Label2: TLabel;
    LabelFilename: TLabel;
    EditPassword: TEdit;
  private
    FFilename: String;
    FTries: Integer;
    FConnection: TADOConnection;
    procedure SetFilename(const Value: String);
  protected
    function CanAccept: Boolean; override;
    procedure DoAccept; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Filename: String write SetFilename;
    property Connection: TADOConnection write FConnection;
  end;

function ConnectToDatabase(AFilename: String; var APassword: String; AConnection: TADOConnection): TInitializeProviderResult;

implementation

{$R *.dfm}

uses FileCtrl, CConsts, CInfoFormUnit, CAdox, CDatabase;

function ConnectToDatabase(AFilename: String; var APassword: String; AConnection: TADOConnection): TInitializeProviderResult;
var xDialog: TCInitializeProviderForm;
    xError: String;
    xNativeError: Integer;
begin
  if AConnection.Connected then begin
    AConnection.Close;
  end;
  if DbConnectDatabase(AFilename, APassword, AConnection, xError, xNativeError, False) then begin
    Result := iprSuccess;
  end else begin
    if (xNativeError = CProviderErrorCodeInvalidPassword) then begin
      xDialog := TCInitializeProviderForm.Create(Application);
      xDialog.Filename := AFilename;
      xDialog.Connection := AConnection;
      if xDialog.ShowConfig(coEdit) then begin
        Result := iprSuccess;
        APassword := xDialog.EditPassword.Text;
      end else begin
        Result := iprCancelled;
      end;
      xDialog.Free;
    end else begin
      ShowInfo(itError, 'Nie uda³o siê otworzyæ pliku danych ' + AFilename + '.', xError);
      Result := iprError;
    end;
  end;
end;

function TCInitializeProviderForm.CanAccept: Boolean;
var xNativeErrorCode: Integer;
    xError: String;
begin
  Result := DbConnectDatabase(FFilename, EditPassword.Text, FConnection, xError, xNativeErrorCode, False);
  if not Result then begin
    ShowInfo(itError, 'Podczas otwierania pliku danych wyst¹pi³ b³¹d', xError);
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
  LabelFilename.Caption := MinimizeName(FFilename, LabelFilename.Canvas, LabelFilename.Width);
end;

end.
