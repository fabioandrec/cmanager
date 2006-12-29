unit CChooseDateAccountListFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CChooseDateFormUnit, StdCtrls, Buttons, CComponents, ExtCtrls;

type
  TCChooseDateAccountListForm = class(TCChooseDateForm)
    GroupBox2: TGroupBox;
    Label14: TLabel;
    CStaticAccount: TCStatic;
    procedure CStaticAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ChooseDateAccountListByForm(var ADate: TDateTime; var AIdAccounts: TStringList): Boolean;

implementation

uses CFrameFormUnit, CAccountsFrameUnit, CConfigFormUnit, CConsts,
  CDatabase;

{$R *.dfm}

function ChooseDateAccountListByForm(var ADate: TDateTime; var AIdAccounts: TStringList): Boolean;
var xForm: TCChooseDateAccountListForm;
begin
  xForm := TCChooseDateAccountListForm.Create(Nil);
  xForm.CDateTime1.Value := GWorkDate;
  Result := xForm.ShowConfig(coEdit);
  if Result then begin
    ADate := xForm.CDateTime1.Value;
    AIdAccounts.Text := xForm.CStaticAccount.DataId;
  end;
  xForm.Free;
end;


procedure TCChooseDateAccountListForm.CStaticAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
var xList: TStringList;
    xDataGid: String;
begin
  xList := TStringList.Create;
  xDataGid := '';
  xList.Text := ADataGid;
  AAccepted := TCFrameForm.ShowFrame(TCAccountsFrame, xDataGid, AText, Nil, Nil, Nil, xList);
  ADataGid := xList.Text;
  if ADataGid = '' then begin
    AText := '<wszystkie konta>';
  end else begin
    AText := '<wybrano ' + IntToStr(xList.Count) + '>';
  end;
  xList.Free;
end;

end.
 