unit CChoosePeriodAccountFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CChoosePeriodFormUnit, StdCtrls, Buttons, CComponents, ExtCtrls,
  CDatabase;

type
  TCChoosePeriodAccountForm = class(TCChoosePeriodForm)
    GroupBox2: TGroupBox;
    Label14: TLabel;
    CStaticAccount: TCStatic;
    procedure CStaticAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
  protected
    function CanAccept: Boolean; override;
  end;

function ChoosePeriodAccountByForm(var AStartDate, AEndDate: TDateTime; var AIdAccount: TDataGid): Boolean;

implementation

uses CConfigFormUnit, CFrameFormUnit, CAccountsFrameUnit, CInfoFormUnit;

{$R *.dfm}

function ChoosePeriodAccountByForm(var AStartDate, AEndDate: TDateTime; var AIdAccount: TDataGid): Boolean;
var xForm: TCChoosePeriodAccountForm;
begin
  xForm := TCChoosePeriodAccountForm.Create(Nil);
  Result := xForm.ShowConfig(coEdit);
  if Result then begin
    AStartDate := xForm.CDateTime1.Value;
    AEndDate := xForm.CDateTime2.Value;
    AIdAccount := xForm.CStaticAccount.DataId;
  end;
  xForm.Free;
end;

function TCChoosePeriodAccountForm.CanAccept: Boolean;
begin
  Result := True;
  if CStaticAccount.DataId = CEmptyDataGid then begin
    Result := False;
    if ShowInfo(itQuestion, 'Nie wybrano konta. Czy wyœwietliæ listê teraz ?', '') then begin
      CStaticAccount.DoGetDataId;
    end;
  end;
end;

procedure TCChoosePeriodAccountForm.CStaticAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCAccountsFrame, ADataGid, AText);
end;

end.
