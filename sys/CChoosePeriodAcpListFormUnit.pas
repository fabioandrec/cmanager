unit CChoosePeriodAcpListFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CChoosePeriodFormUnit, StdCtrls, Buttons, CComponents, ExtCtrls;

type
  TCChoosePeriodAcpListForm = class(TCChoosePeriodForm)
    GroupBox2: TGroupBox;
    Label14: TLabel;
    CStatic: TCStatic;
    procedure CStaticGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
  private
    FAcp: String;
    procedure SetAcp(const Value: String);
  public
    property Acp: String read FAcp write SetAcp;
  end;

function ChoosePeriodAcpListByForm(AAcp: String; var AStartDate, AEndDate: TDateTime; var AIdAcps: TStringList; ACurrencyView: PChar): Boolean;

implementation

uses CFrameFormUnit, CAccountsFrameUnit, CConfigFormUnit,
     CChoosePeriodAcpFormUnit, CDataObjects, CDatabase, CConsts,
  CCashpointsFrameUnit, CProductsFrameUnit;

{$R *.dfm}

function ChoosePeriodAcpListByForm(AAcp: String; var AStartDate, AEndDate: TDateTime; var AIdAcps: TStringList; ACurrencyView: PChar): Boolean;
var xForm: TCChoosePeriodAcpListForm;
    xList: TList;
    xData: String;
begin
  xForm := TCChoosePeriodAcpListForm.Create(Nil);
  xForm.Acp := AAcp;
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
    AIdAcps.Text := xForm.CStatic.DataId;
    if ACurrencyView <> Nil then begin
      xData := xForm.CStaticCurrencyView.DataId[1];
      CopyMemory(ACurrencyView, @xData[1], 1);
    end;
  end;
  xForm.Free;
end;

procedure TCChoosePeriodAcpListForm.CStaticGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
var xList: TStringList;
    xDataGid: String;
begin
  xList := TStringList.Create;
  xDataGid := '';
  xList.Text := ADataGid;
  if FAcp = CGroupByAccount then begin
    AAccepted := TCFrameForm.ShowFrame(TCAccountsFrame, xDataGid, AText, Nil, Nil, Nil, xList);
  end else if FAcp = CGroupByCashpoint then begin
    AAccepted := TCFrameForm.ShowFrame(TCCashpointsFrame, xDataGid, AText, Nil, Nil, Nil, xList);
  end else if FAcp = CGroupByProduct then begin
    AAccepted := TCFrameForm.ShowFrame(TCProductsFrame, xDataGid, AText, Nil, Nil, Nil, xList);
  end;
  ADataGid := xList.Text;
  if ADataGid = '' then begin
    if FAcp = CGroupByAccount then begin
      AText := '<wszystkie konta>';
    end else if FAcp = CGroupByCashpoint then begin
      AText := '<wszyscy kontrahenci>';
    end else if FAcp = CGroupByProduct then begin
      AText := '<wszystkie kategorie>';
    end;
  end else begin
    AText := '<wybrano ' + IntToStr(xList.Count) + '>';
  end;
  xList.Free;
end;

procedure TCChoosePeriodAcpListForm.SetAcp(const Value: String);
begin
  FAcp := Value;
  if FAcp = CGroupByAccount then begin
    GroupBox2.Caption := ' Lista kont ';
    CStatic.TextOnEmpty := '<wszystkie konta>';
  end else if FAcp = CGroupByCashpoint then begin
    GroupBox2.Caption := ' Lista kontrahentów ';
    CStatic.TextOnEmpty := '<wszyscy kontrahenci>';
  end else if FAcp = CGroupByProduct then begin
    GroupBox2.Caption := ' Lista kategorii ';
    CStatic.TextOnEmpty := '<wszystkie kategorie>';
  end;
end;

end.
