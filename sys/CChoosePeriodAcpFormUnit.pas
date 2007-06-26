unit CChoosePeriodAcpFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CChoosePeriodFormUnit, StdCtrls, Buttons, CComponents, ExtCtrls,
  CDatabase;

type
  TCChoosePeriodAcpForm = class(TCChoosePeriodForm)
    GroupBox2: TGroupBox;
    Label14: TLabel;
    CStatic: TCStatic;
    procedure CStaticGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
  private
    FCanBeEmpty: Boolean;
    FAcp: String;
    procedure SetAcp(const Value: String);
  protected
    function CanAccept: Boolean; override;
  public
    property CanBeEmpty: Boolean read FCanBeEmpty write FCanBeEmpty;
    property Acp: String read FAcp write SetAcp;
  end;

function ChoosePeriodACPByForm(AAcp: String; var AStartDate, AEndDate: TDateTime; var AIdAccount: TDataGid; ACurrencyView: PChar; ACanBeEmpty: Boolean = False): Boolean;

implementation

uses CConfigFormUnit, CFrameFormUnit, CAccountsFrameUnit, CInfoFormUnit,
  CConsts, CCashpointsFrameUnit, CProductsFrameUnit;

{$R *.dfm}

function ChoosePeriodACPByForm(AAcp: String; var AStartDate, AEndDate: TDateTime; var AIdAccount: TDataGid; ACurrencyView: PChar; ACanBeEmpty: Boolean = False): Boolean;
var xForm: TCChoosePeriodAcpForm;
    xList: TList;
    xData: String;
begin
  xForm := TCChoosePeriodAcpForm.Create(Nil);
  xForm.CanBeEmpty := ACanBeEmpty;
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
    AIdAccount := xForm.CStatic.DataId;
    if ACurrencyView <> Nil then begin
      xData := xForm.CStaticCurrencyView.DataId[1];
      CopyMemory(ACurrencyView, @xData[1], 1);
    end;
  end;
  xForm.Free;
end;

function TCChoosePeriodAcpForm.CanAccept: Boolean;
var xText: String;
begin
  Result := True;
  if (CStatic.DataId = CEmptyDataGid) and (not FCanBeEmpty) then begin
    Result := False;
    if FAcp = CGroupByAccount then begin
      xText := 'Nie wybrano konta';
    end else if FAcp = CGroupByCashpoint then begin
      xText := 'Nie wybrano kontrahenta';
    end else if FAcp = CGroupByProduct then begin
      xText := 'Nie wybrano kategorii';
    end;
    if ShowInfo(itQuestion, xText + '. Czy wyœwietliæ listê teraz ?', '') then begin
      CStatic.DoGetDataId;
    end;
  end;
end;

procedure TCChoosePeriodAcpForm.CStaticGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  if FAcp = CGroupByAccount then begin
    AAccepted := TCFrameForm.ShowFrame(TCAccountsFrame, ADataGid, AText);
  end else if FAcp = CGroupByCashpoint then begin
    AAccepted := TCFrameForm.ShowFrame(TCCashpointsFrame, ADataGid, AText);
  end else if FAcp = CGroupByProduct then begin
    AAccepted := TCFrameForm.ShowFrame(TCProductsFrame, ADataGid, AText);
  end;
end;

procedure TCChoosePeriodAcpForm.SetAcp(const Value: String);
begin
  FAcp := Value;
  if FAcp = CGroupByAccount then begin
    GroupBox2.Caption := ' Konto ';
    CStatic.TextOnEmpty := '<wybierz konto z listy>';
  end else if FAcp = CGroupByCashpoint then begin
    GroupBox2.Caption := ' Kontrahent ';
    CStatic.TextOnEmpty := '<wybierz kontrahenta z listy>';
  end else if FAcp = CGroupByProduct then begin
    GroupBox2.Caption := ' Kategoria ';
    CStatic.TextOnEmpty := '<wybierz kategoriê z listy>';
  end;
end;

end.
