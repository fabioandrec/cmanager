unit CMovementStateFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, CDatabase, CDataobjects,
  CComponents;

type
  TMovementStateRecord = class(TObject)
  private
    FAccountId: TDataGid;
    FStated: Boolean;
    FExtrId: TDataGid;
    procedure SetAccountId(const Value: TDataGid);
  public
    constructor Create(AAccount: TDataGid; AState: Boolean; AExtrId: TDataGid);
  published
    property AccountId: TDataGid read FAccountId write SetAccountId;
    property Stated: Boolean read FStated write FStated;
    property ExtrId: TDataGid read FExtrId write FExtrId;
  end;

  TCMovementStateForm = class(TCConfigForm)
    GroupBox1: TGroupBox;
    ComboBoxStatus: TComboBox;
    GroupBox2: TGroupBox;
    Label20: TLabel;
    Label17: TLabel;
    CStaticExtItem: TCStatic;
    CStaticAccountExt: TCStatic;
    procedure ComboBoxStatusChange(Sender: TObject);
  private
    FRecord: TMovementStateRecord;
    FHasExts: Boolean;
  public
    { Public declarations }
  end;

function ShowMovementState(var ARecord: TMovementStateRecord): Boolean;

implementation

uses CConsts, Math;

{$R *.dfm}

function ShowMovementState(var ARecord: TMovementStateRecord): Boolean;
var xForm: TCMovementStateForm;
    xExt: TExtractionItem;
begin
  xForm := TCMovementStateForm.Create(Nil);
  with xForm do begin
    FRecord := ARecord;
    GDataProvider.BeginTransaction;
    FHasExts := TAccount(TAccount.LoadObject(AccountProxy, FRecord.FAccountId, False)).accountType <> CCashAccount;
    if ARecord.ExtrId <> CEmptyDataGid then begin
      xExt := TExtractionItem(TExtractionItem.LoadObject(ExtractionItemProxy, ARecord.ExtrId, False));
      CStaticExtItem.DataId := xExt.id;
      CStaticExtItem.Caption := xExt.description;
      CStaticAccountExt.DataId := xExt.idAccountExtraction;
      CStaticAccountExt.Caption := TAccountExtraction(TAccountExtraction.LoadObject(AccountExtractionProxy, xExt.idAccountExtraction, False)).description;
    end;
    GDataProvider.RollbackTransaction;
    ComboBoxStatus.ItemIndex := IfThen(ARecord.Stated, 1, 0);
  end;
  xForm.ComboBoxStatusChange(xForm.ComboBoxStatus);
  Result := xForm.ShowConfig(coEdit);
  if Result then begin
    ARecord.Stated := xForm.ComboBoxStatus.ItemIndex = 1;
    ARecord.ExtrId := xForm.CStaticExtItem.DataId;
  end;
  xForm.Free;
end;

procedure TCMovementStateForm.ComboBoxStatusChange(Sender: TObject);
begin
  CStaticExtItem.Enabled := FHasExts and (ComboBoxStatus.ItemIndex = 1);
  CStaticAccountExt.Enabled := CStaticExtItem.Enabled;
  if not CStaticExtItem.Enabled then begin
    CStaticExtItem.DataId := CEmptyDataGid;
  end;
  if not CStaticAccountExt.Enabled then begin
    CStaticAccountExt.DataId := CEmptyDataGid;
  end;
end;

constructor TMovementStateRecord.Create(AAccount: TDataGid; AState: Boolean; AExtrId: TDataGid);
begin
  inherited Create;
  FAccountId := AAccount;
  FStated := AState;
  FExtrId := AExtrId;
end;

procedure TMovementStateRecord.SetAccountId(const Value: TDataGid);
begin
  FAccountId := Value;
  FStated := False;
  FExtrId := CEmptyDataGid;
end;

end.
