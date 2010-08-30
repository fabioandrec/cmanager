unit CAccountsFrameUnit;

interface

uses CDataobjectFrameUnit, Classes, ActnList, VTHeaderPopup, Menus,
     ImgList, Controls, PngImageList, CComponents, VirtualTrees, StdCtrls,
     ExtCtrls, CDatabase, CDataobjectFormUnit, CImageListsUnit, Dialogs;

type
  TCAccountsFrame = class(TCDataobjectFrame)
    Label1: TLabel;
    CStaticStatusFilter: TCStatic;
    procedure CStaticStatusFilterGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticStatusFilterChanged(Sender: TObject);
  protected
    function IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean; override;
    function GetSelectedType: Integer; override;
  public
    class function GetTitle: String; override;
    function IsValidFilteredObject(AObject: TDataObject): Boolean; override;
    procedure ReloadDataobjects; override;
    function GetStaticFilter: TStringList; override;
    class function GetDataobjectClass(AOption: Integer): TDataObjectClass; override;
    class function GetDataobjectProxy(AOption: Integer): TDataProxy; override;
    function GetDataobjectForm(AOption: Integer): TCDataobjectFormClass; override;
    function GetHistoryText: String; override;
    procedure ShowHistory(AGid: ShortString); override;
  end;

implementation

uses CDataObjects, CAccountFormUnit, CConsts, CReports, CPluginConsts,
  CBaseFrameUnit, CListFrameUnit, StrUtils;

{$R *.dfm}

class function TCAccountsFrame.GetDataobjectClass(AOption: Integer): TDataObjectClass;
begin
  Result := TAccount;
end;

function TCAccountsFrame.GetDataobjectForm(AOption: Integer): TCDataobjectFormClass;
begin
  Result := TCAccountForm;
end;

class function TCAccountsFrame.GetDataobjectProxy(AOption: Integer): TDataProxy;
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
  Result := ((CStaticFilter.DataId = CFilterAllElements) or (TAccount(AObject).accountType = CStaticFilter.DataId)) and
            ((CStaticStatusFilter.DataId = CFilterAllElements) or (TAccount(AObject).accountState = CStaticStatusFilter.DataId));
end;

procedure TCAccountsFrame.ReloadDataobjects;
var xConditionFilter, xConditionStatus: String;
    xCondition: TConditionBuilder;
begin
  inherited ReloadDataobjects;
  xCondition := TConditionBuilder.Create;
  if CStaticFilter.DataId = CFilterAllElements then begin
    xConditionFilter := '';
  end else begin
    xConditionFilter := 'accountType = ''' + CStaticFilter.DataId + '''';
  end;
  xCondition.AddCondition(xConditionFilter);
  if CStaticStatusFilter.DataId = CFilterAllElements then begin
    xConditionStatus := '';
  end else begin
    xConditionStatus := 'accountState = ''' + CStaticStatusFilter.DataId + '''';
  end;
  xCondition.AddCondition(xConditionStatus);
  Dataobjects := TAccount.GetList(TAccount, AccountProxy, 'select * from account' + xCondition.AsWhere);
  xCondition.Free;
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

procedure TCAccountsFrame.CStaticStatusFilterGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
var xList: TStringList;
begin
  xList := TStringList.Create;
  xList.Values[CFilterAllElements] := '<dowolny>';
  xList.Values[CAccountStateActive] := '<' + CAccountStateActiveDesc + '>';
  xList.Values[CAccountStateClosed] := '<' + CAccountStateClosedDesc + '>';
  if xList <> Nil then begin
    AAccepted := ShowList(xList, ADataGid, AText, False);
  end;
end;

procedure TCAccountsFrame.CStaticStatusFilterChanged(Sender: TObject);
begin
  RefreshData;
end;

end.
