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
  private
    FCanBeEmpty: Boolean;
  protected
    function CanAccept: Boolean; override;
  public
    property CanBeEmpty: Boolean read FCanBeEmpty write FCanBeEmpty;
  end;

function ChoosePeriodAccountByForm(var AStartDate, AEndDate: TDateTime; var AIdAccount: TDataGid; ACurrencyView: PChar; ACanBeEmpty: Boolean = False): Boolean;

implementation

uses CConfigFormUnit, CFrameFormUnit, CAccountsFrameUnit, CInfoFormUnit,
  CConsts;

{$R *.dfm}

function ChoosePeriodAccountByForm(var AStartDate, AEndDate: TDateTime; var AIdAccount: TDataGid; ACurrencyView: PChar; ACanBeEmpty: Boolean = False): Boolean;
var xForm: TCChoosePeriodAccountForm;
    xList: TList;
    xData: String;
begin
  xForm := TCChoosePeriodAccountForm.Create(Nil);
  xForm.CanBeEmpty := ACanBeEmpty;
  if ACurrencyView = Nil then begin
    xForm.GroupBoxView.Visible := False;
    xForm.Height := xForm.Height - xForm.GroupBoxView.Height - 15;
    xList := TList.Create;
    xForm.GetTabOrderList(xList);
    xForm.GroupBoxView.TabOrder := xList.Count;
    xList.Free;
  end;
  if (AStartDate = GWorkDate) and (AEndDate = GWorkDate) then begin
    xForm.ComboBoxPredefined.ItemIndex := 1;
    xForm.ComboBoxPredefinedChange(xForm.ComboBoxPredefined);
  end;
  Result := xForm.ShowConfig(coEdit);
  if Result then begin
    AStartDate := xForm.CDateTime1.Value;
    AEndDate := xForm.CDateTime2.Value;
    AIdAccount := xForm.CStaticAccount.DataId;
    if ACurrencyView <> Nil then begin
      xData := xForm.CStaticCurrencyView.DataId[1];
      CopyMemory(ACurrencyView, @xData[1], 1);
    end;
  end;
  xForm.Free;
end;

function TCChoosePeriodAccountForm.CanAccept: Boolean;
begin
  Result := True;
  if (CStaticAccount.DataId = CEmptyDataGid) and (not FCanBeEmpty) then begin
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
