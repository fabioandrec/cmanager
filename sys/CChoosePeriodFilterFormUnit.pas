unit CChoosePeriodFilterFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CChoosePeriodFormUnit, CComponents, StdCtrls, Buttons, ExtCtrls,
  CDatabase;

type
  TCChoosePeriodFilterForm = class(TCChoosePeriodForm)
    GroupBox2: TGroupBox;
    Label14: TLabel;
    CStaticFilter: TCStatic;
    procedure CStaticFilterGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
  private
    FCanBeEmpty: Boolean;
  protected
    function CanAccept: Boolean; override;
  public
    property CanBeEmpty: Boolean read FCanBeEmpty write FCanBeEmpty;
  end;

function ChoosePeriodFilterByForm(var AStartDate, AEndDate: TDateTime; var AIdFilter: TDataGid; ACurrencyView: PChar; ACanBeEmpty: Boolean = False): Boolean;

implementation

uses CFilterFrameUnit, CFrameFormUnit, CConfigFormUnit, CInfoFormUnit,
     CConsts, CListFrameUnit, CFilterDetailFrameUnit, CDataObjects;

{$R *.dfm}

function ChoosePeriodFilterByForm(var AStartDate, AEndDate: TDateTime; var AIdFilter: TDataGid; ACurrencyView: PChar; ACanBeEmpty: Boolean = False): Boolean;
var xForm: TCChoosePeriodFilterForm;
    xData: String;
begin
  xForm := TCChoosePeriodFilterForm.Create(Nil);
  xForm.CanBeEmpty := ACanBeEmpty;
  if ACurrencyView = Nil then begin
    xForm.GroupBoxView.Visible := False;
    xForm.Height := xForm.Height - xForm.GroupBoxView.Height - 23;
  end;
  if (AStartDate = GWorkDate) and (AEndDate = GWorkDate) then begin
    xForm.ComboBoxPredefined.ItemIndex := 1;
    xForm.ComboBoxPredefinedChange(xForm.ComboBoxPredefined);
  end;
  Result := xForm.ShowConfig(coEdit);
  if Result then begin
    AStartDate := xForm.CDateTime1.Value;
    AEndDate := xForm.CDateTime2.Value;
    AIdFilter := xForm.CStaticFilter.DataId;
    if ACurrencyView <> Nil then begin
      xData := xForm.CStaticCurrencyView.DataId[1];
      CopyMemory(ACurrencyView, @xData[1], 1);
    end;
  end;
  xForm.Free;
end;

function TCChoosePeriodFilterForm.CanAccept: Boolean;
begin
  Result := True;
  if (CStaticFilter.DataId = CEmptyDataGid) and (not FCanBeEmpty) then begin
    Result := False;
    if ShowInfo(itQuestion, 'Nie wybrano filtru. Czy wyœwietliæ listê teraz ?', '') then begin
      CStaticFilter.DoGetDataId;
    end;
  end;
end;

procedure TCChoosePeriodFilterForm.CStaticFilterGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := DoTemporaryMovementFilter(ADataGid, AText);
end;

end.
