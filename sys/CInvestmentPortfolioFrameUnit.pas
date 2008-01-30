unit CInvestmentPortfolioFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFrameUnit, ActnList, VTHeaderPopup, Menus, ImgList,
  PngImageList, CComponents, VirtualTrees, StdCtrls, ExtCtrls, CDatabase,
  CDataobjectFormUnit;

type
  TCInvestmentPortfolioFrame = class(TCDataobjectFrame)
  protected
    function IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean; override;
    function GetSelectedType: Integer; override;
  public
    class function GetTitle: String; override;
    procedure ReloadDataobjects; override;
    function IsValidFilteredObject(AObject: TDataObject): Boolean; override;
    function GetStaticFilter: TStringList; override;
    procedure InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean); override;
    {
    class function GetDataobjectClass(AOption: Integer): TDataObjectClass; override;
    class function GetDataobjectProxy(AOption: Integer): TDataProxy; override;
    function GetDataobjectForm(AOption: Integer): TCDataobjectFormClass; override;
    function GetHistoryText: String; override;
    procedure ShowHistory(AGid: ShortString); override;
    }
  end;

implementation

uses CPluginConsts, CDataObjects, CConsts;

{$R *.dfm}

function TCInvestmentPortfolioFrame.GetSelectedType: Integer;
begin
  Result := CSELECTEDITEM_INVESTPORTFOLIO;
end;

function TCInvestmentPortfolioFrame.GetStaticFilter: TStringList;
begin
  Result := TStringList.Create;
  with Result do begin
    Add(CFilterAllElements + '=<wszystkie elementy>');
    Add(CInstrumentTypeIndex + '=<indeksy gie³dowe>');
    Add(CInstrumentTypeStock + '=<akcje>');
    Add(CInstrumentTypeBond + '=<obligacje>');
    Add(CInstrumentTypeFundinv + '=<fundusze inwestycyjne>');
    Add(CInstrumentTypeFundret + '=<fundusze emerytalne>');
    Add(CInstrumentTypeUndefined + '=<nieokreœlone>');
  end;
end;

class function TCInvestmentPortfolioFrame.GetTitle: String;
begin
  Result := 'Portfel inwestycyjny';
end;

procedure TCInvestmentPortfolioFrame.InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean);
begin
  Bevel.Visible := False;
  ButtonPanel.Visible := False;
  inherited InitializeFrame(AOwner, AAdditionalData, AOutputData, AMultipleCheck, AWithButtons);
end;

function TCInvestmentPortfolioFrame.IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean;
begin
  Result := (APluginSelectedItemTypes and CSELECTEDITEM_INVESTPORTFOLIO) = CSELECTEDITEM_INVESTPORTFOLIO;
end;

function TCInvestmentPortfolioFrame.IsValidFilteredObject(AObject: TDataObject): Boolean;
begin
  Result := (inherited IsValidFilteredObject(AObject)) or
            (TInvestmentPortfolio(AObject).instrumentType = CStaticFilter.DataId);
end;

procedure TCInvestmentPortfolioFrame.ReloadDataobjects;
var xCondition: String;
begin
  inherited ReloadDataobjects;
  if CStaticFilter.DataId = CFilterAllElements then begin
    xCondition := '';
  end else begin
    xCondition := ' where instrumentType = ''' + CStaticFilter.DataId + '''';
  end;
  Dataobjects := TDataObject.GetList(TInvestmentPortfolio, InvestmentPortfolioProxy, 'select * from StnInvestmentPortfolio' + xCondition);
end;

end.
