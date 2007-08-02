unit CAccountsFrameUnit;

interface

uses CDataobjectFrameUnit, Classes, ActnList, VTHeaderPopup, Menus,
     ImgList, Controls, PngImageList, CComponents, VirtualTrees, StdCtrls,
     ExtCtrls, CDatabase, CDataobjectFormUnit, CImageListsUnit, Dialogs;

type
  TCAccountsFrame = class(TCDataobjectFrame)
  protected
    function IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean; override;
    function GetSelectedType: Integer; override;
  public
    class function GetTitle: String; override;
    function IsValidFilteredObject(AObject: TDataObject): Boolean; override;
    procedure ReloadDataobjects; override;
    function GetStaticFilter: TStringList; override;
    function GetDataobjectClass(AOption: Integer): TDataObjectClass; override;
    function GetDataobjectProxy(AOption: Integer): TDataProxy; override;
    function GetDataobjectForm(AOption: Integer): TCDataobjectFormClass; override;
    function GetHistoryText: String; override;
    procedure ShowHistory(AGid: ShortString); override;
  end;

implementation

uses CDataObjects, CAccountFormUnit, CConsts, CReports, CPluginConsts;

{$R *.dfm}

function TCAccountsFrame.GetDataobjectClass(AOption: Integer): TDataObjectClass;
begin
  Result := TAccount;
end;

function TCAccountsFrame.GetDataobjectForm(AOption: Integer): TCDataobjectFormClass;
begin
  Result := TCAccountForm;
end;

function TCAccountsFrame.GetDataobjectProxy(AOption: Integer): TDataProxy;
begin
  Result := AccountProxy;
end;

function TCAccountsFrame.GetHistoryText: String;
begin
  Result := 'Historia konta';
end;

function TCAccountsFrame.GetSelectedType: Integer;
begin
  if List.FocusedNode <> Nil then begin
    Result := CSELECTEDITEM_ACCOUNT;
  end else begin
    Result := CSELECTEDITEM_INCORRECT;
  end;
end;

function TCAccountsFrame.GetStaticFilter: TStringList;
begin
  Result := TStringList.Create;
  with Result do begin
    Add(CFilterAllElements + '=<wszystkie elementy>');
    Add(CCashAccount + '=<konta gotówkowe>');
    Add(CBankAccount + '=<rachunki bankowe>');
    Add(CInvestmentAccount + '=<rachunki inwestycyjne>');
  end;
end;

class function TCAccountsFrame.GetTitle: String;
begin
  Result := 'Konta';
end;

function TCAccountsFrame.IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean;
begin
  Result := (APluginSelectedItemTypes and CSELECTEDITEM_ACCOUNT) = CSELECTEDITEM_ACCOUNT;
end;

function TCAccountsFrame.IsValidFilteredObject(AObject: TDataObject): Boolean;
begin
  Result := (inherited IsValidFilteredObject(AObject)) or
            (TAccount(AObject).accountType = CStaticFilter.DataId);
end;

procedure TCAccountsFrame.ReloadDataobjects;
var xCondition: String;
begin
  inherited ReloadDataobjects;
  if CStaticFilter.DataId = CFilterAllElements then begin
    xCondition := '';
  end else begin
    xCondition := ' where accountType = ''' + CStaticFilter.DataId + '''';
  end;
  Dataobjects := TAccount.GetList(TAccount, AccountProxy, 'select * from account' + xCondition);
end;

procedure TCAccountsFrame.ShowHistory(AGid: ShortString);
var xReport: TAccountBalanceChartReport;
    xParams: TCReportParams;
begin
  xParams := TCWithGidParams.Create(AGid);
  xReport := TAccountBalanceChartReport.CreateReport(xParams);
  xReport.ShowReport;
  xReport.Free;
  xParams.Free;
end;

end.
