unit CDescpatternFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, CComponents,
  ComCtrls, CPreferences;

type
  TCDescpatternForm = class(TCConfigForm)
    GroupBox1: TGroupBox;
    Label5: TLabel;
    Label7: TLabel;
    ComboBoxOperation: TComboBox;
    ComboBoxType: TComboBox;
    GroupBox2: TGroupBox;
    RichEditDesc: TRichEdit;
    procedure ComboBoxOperationChange(Sender: TObject);
    procedure ComboBoxTypeChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RichEditDescChange(Sender: TObject);
  private
    FDescPatterns: TDescPatterns;
    FKeyName: String;
  protected
    procedure ReadValues; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

function EditDescPattern(AName: String; var APattern: String): Boolean;

implementation

uses CConsts;

{$R *.dfm}

procedure TCDescpatternForm.ComboBoxOperationChange(Sender: TObject);
var xCount: Integer;
begin
  ComboBoxType.Items.BeginUpdate;
  ComboBoxType.Items.Clear;
  for xCount := Low(CDescPatternsNames[ComboBoxOperation.ItemIndex]) to High(CDescPatternsNames[ComboBoxOperation.ItemIndex]) do begin
    if CDescPatternsNames[ComboBoxOperation.ItemIndex][xCount] <> '' then begin
      ComboBoxType.Items.Add(CDescPatternsNames[ComboBoxOperation.ItemIndex][xCount]);
    end;
  end;
  ComboBoxType.Items.EndUpdate;
  if ComboBoxType.Items.Count > 0 then begin
    ComboBoxType.ItemIndex := 0;
  end;
  ComboBoxTypeChange(Nil);
end;

procedure TCDescpatternForm.ComboBoxTypeChange(Sender: TObject);
begin
  RichEditDesc.Text := FDescPatterns.GetPattern(CDescPatternsKeys[ComboBoxOperation.ItemIndex][ComboBoxType.ItemIndex], '');
end;

constructor TCDescpatternForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDescPatterns := TDescPatterns.Create(False);
  FDescPatterns.Text := GDescPatterns.Text;
  FKeyName := '';
end;

destructor TCDescpatternForm.Destroy;
begin
  FDescPatterns.Free;
  inherited Destroy;
end;

procedure TCDescpatternForm.FormShow(Sender: TObject);
var xO, xT: Integer;
begin
  inherited FormShow(Sender);
  if FKeyName <> '' then begin
    xO := GDescPatterns.GetPatternOperation(FKeyName);
    xT := GDescPatterns.GetPattetnType(FKeyName);
    if xO <> -1 then begin
      ComboBoxOperation.ItemIndex := xO;
      ComboBoxOperation.Enabled := False;
    end;
    ComboBoxOperationChange(Nil);
    if xT <> -1 then begin
      ComboBoxType.ItemIndex := xT;
      ComboBoxType.Enabled := False;
    end;
    ComboBoxTypeChange(Nil);
  end else begin
    ComboBoxOperationChange(Nil);
  end;
end;


procedure TCDescpatternForm.ReadValues;
var xCount: Integer;
    xName: String;
begin
  inherited ReadValues;
  for xCount := 0 to FDescPatterns.Count - 1 do begin
    xName := FDescPatterns.Names[xCount];
    GDescPatterns.SetPattern(xName, FDescPatterns.Values[xName]);
  end;
end;

function EditDescPattern(AName: String; var APattern: String): Boolean;
var xForm: TCDescpatternForm;
begin
  xForm := TCDescpatternForm.Create(Application);
  xForm.FKeyName := AName;
  Result := xForm.ShowConfig(coEdit);
  if Result then begin
    APattern := xForm.RichEditDesc.Text;
  end;
  xForm.Free;
end;

procedure TCDescpatternForm.RichEditDescChange(Sender: TObject);
begin
  FDescPatterns.SetPattern(CDescPatternsKeys[ComboBoxOperation.ItemIndex][ComboBoxType.ItemIndex], RichEditDesc.Text);
end;

end.
