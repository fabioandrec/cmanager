unit CCurrencydefFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFrameUnit, ActnList, VTHeaderPopup, Menus, ImgList,
  PngImageList, CComponents, VirtualTrees, StdCtrls, ExtCtrls, CDatabase, CDataobjects,
  CDataobjectFormUnit, CImageListsUnit;

type
  TCCurrencydefFrame = class(TCDataobjectFrame)
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

uses CCurrencydefFormUnit, CReports;

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

class function TCCurrencydefFrame.GetTitle: String;
begin
  Result := 'Waluty';
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
  xParams := TCCurrencyParamsParams.Create(AGid);
  xReport := TCurrencyRatesHistoryReport.CreateReport(xParams);
  xReport.ShowReport;
  xReport.Free;
  xParams.Free;
end;

end.
 