unit CChoosePeriodAccountListFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CChoosePeriodFormUnit, StdCtrls, Buttons, CComponents, ExtCtrls;

type
  TCChoosePeriodAccountListForm = class(TCChoosePeriodForm)
    GroupBox2: TGroupBox;
    Label14: TLabel;
    CStaticAccount: TCStatic;
    procedure CStaticAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
  private
  public
  end;

function ChoosePeriodAccountListByForm(var AStartDate, AEndDate: TDateTime; var AIdAccounts: TStringList; ACurrencyView: PChar): Boolean;

implementation

uses CFrameFormUnit, CAccountsFrameUnit, CConfigFormUnit,
  CChoosePeriodAccountFormUnit, CDataObjects, CDatabase;

{$R *.dfm}

function ChoosePeriodAccountListByForm(var AStartDate, AEndDate: TDateTime; var AIdAccounts: TStringList; ACurrencyView: PChar): Boolean;
var xForm: TCChoosePeriodAccountListForm;
    xList: TList;
    xData: String;
begin
  xForm := TCChoosePeriodAccountListForm.Create(Nil);
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
    AIdAccounts.Text := xForm.CStaticAccount.DataId;
    if ACurrencyView <> Nil then begin
      xData := xForm.CStaticCurrencyView.DataId[1];
      CopyMemory(ACurrencyView, @xData[1], 1);
    end;
  end;
  xForm.Free;
end;

procedure TCChoosePeriodAccountListForm.CStaticAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
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
