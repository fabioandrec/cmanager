unit CCurrencydefFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFrameUnit, ActnList, VTHeaderPopup, Menus, ImgList,
  PngImageList, CComponents, VirtualTrees, StdCtrls, ExtCtrls, CDatabase, CDataobjects,
  CDataobjectFormUnit, CImageListsUnit;

type
  TCCurrencydefFrame = class(TCDataobjectFrame)
  protected
    function GetSelectedType: Integer; override;
    function IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean; override;
  public
    class function GetTitle: String; override;
    procedure ReloadDataobjects; override;
    function GetDataobjectClass(AOption: Integer): TDataObjectClass; override;
    function GetDataobjectProxy(AOption: Integer): TDataProxy; override;
    function GetDataobjectForm(AOption: Integer): TCDataobjectFormClass; override;
    function GetHistoryText: String; override;
    procedure ShowHistory(AGid: ShortString); override;
  end;

implementation

uses CCurrencydefFormUnit, CReports, CPluginConsts, CBaseFrameUnit;

{$R *.dfm}

function TCCurrencydefFrame.GetDataobjectClass(AOption: Integer): TDataObjectClass;
begin
  Result := TCurrencyDef;
end;

function TCCurrencydefFrame.GetDataobjectForm(AOption: Integer): TCDataobjectFormClass;
begin
  Result := TCCurrencydefForm;
end;

function TCCurrencydefFrame.GetDataobjectProxy(AOption: Integer): TDataProxy;
begin
  Result := CurrencyDefProxy;
end;

function TCCurrencydefFrame.GetHistoryText: String;
begin
  Result := 'Historia waluty';
end;

function TCCurrencydefFrame.GetSelectedType: Integer;
begin
  if List.FocusedNode <> Nil then begin
    Result := CSELECTEDITEM_CURRENCY;
  end else begin
    Result := CSELECTEDITEM_INCORRECT;
  end;
end;

class function TCCurrencydefFrame.GetTitle: String;
begin
  Result := 'Waluty';
end;

function TCCurrencydefFrame.IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean;
begin
  Result := (APluginSelectedItemTypes and CSELECTEDITEM_CURRENCY) = CSELECTEDITEM_CURRENCY;
end;

procedure TCCurrencydefFrame.ReloadDataobjects;
begin
  inherited ReloadDataobjects;
  Dataobjects := TDataObject.GetList(TCurrencyDef, CurrencyDefProxy, 'select * from currencyDef');
end;

procedure TCCurrencydefFrame.ShowHistory(AGid: ShortString);
var xReport: TCurrencyRatesHistoryReport;
    xParams: TCReportParams;
begin
  xParams := TCWithGidParams.Create(AGid);
  xReport := TCurrencyRatesHistoryReport.CreateReport(xParams);
  xReport.ShowReport;
  xReport.Free;
  xParams.Free;
end;

end.
