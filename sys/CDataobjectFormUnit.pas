unit CDataobjectFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, CDatabase;

type
  TCDataobjectFormClass = class of TCDataobjectForm;

  TAdditionalData = class(TObject);

  TCDataobjectForm = class(TCConfigForm)
    procedure FormDestroy(Sender: TObject);
  private
    FDataobject: TDataObject;
    FAdditionalData: TAdditionalData;
  protected
    function GetDataobjectClass: TDataObjectClass; virtual; abstract;
    procedure AfterCommitData; virtual;
    procedure InitializeForm; virtual;
  public
    function ShowDataobject(AOperation: TConfigOperation; AProxy: TDataProxy; ADataobject: TDataObject; ACreateStatic: Boolean; AAdditionalData: TAdditionalData = Nil): TDataGid;
    property Dataobject: TDataObject read FDataobject write FDataobject;
    function ShowConfig(AOperation: TConfigOperation): Boolean; override;
    property AdditionalData: TAdditionalData read FAdditionalData;
  end;

implementation

{$R *.dfm}

procedure TCDataobjectForm.AfterCommitData;
begin
end;

procedure TCDataobjectForm.InitializeForm;
begin
end;

function TCDataobjectForm.ShowConfig(AOperation: TConfigOperation): Boolean;
begin
  Accepted := False;
  Operation := AOperation;
  if Operation = coNone then begin
    BitBtnOk.Visible := False;
    BitBtnCancel.Default := True;
    BitBtnCancel.Caption := '&Wyjœcie';
  end;
  if Operation = coEdit then begin
    FillForm;
  end;
  ShowModal;
  Result := Accepted;
end;

function TCDataobjectForm.ShowDataobject(AOperation: TConfigOperation; AProxy: TDataProxy; ADataobject: TDataObject; ACreateStatic: Boolean; AAdditionalData: TAdditionalData = Nil): TDataGid;
begin
  Result := CEmptyDataGid;
  FAdditionalData := AAdditionalData;
  InitializeForm;
  if AOperation = coEdit then begin
    FDataobject := ADataobject
  end;
  if ShowConfig(AOperation) then begin
    if Operation = coAdd then begin
      FDataobject := GetDataobjectClass.CreateObject(AProxy, ACreateStatic);
    end;
    ReadValues;
    GDataProvider.CommitTransaction;
    AfterCommitData;
    Result := FDataobject.id;
  end else begin
    GDataProvider.RollbackTransaction;
  end;
  if (AOperation = coAdd) and Accepted then begin
    FreeAndNil(FDataobject);
  end;
end;

procedure TCDataobjectForm.FormDestroy(Sender: TObject);
begin
  if Assigned(FAdditionalData) then begin
    FreeAndNil(FAdditionalData);
  end;
  inherited;
end;

end.

