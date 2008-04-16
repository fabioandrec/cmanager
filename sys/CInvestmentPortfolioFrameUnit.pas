unit CInvestmentPortfolioFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFrameUnit, ActnList, VTHeaderPopup, Menus, ImgList,
  PngImageList, CComponents, VirtualTrees, StdCtrls, ExtCtrls, CDatabase,
  CDataobjectFormUnit, CImageListsUnit;

type
  TCInvestmentPortfolioFrame = class(TCDataobjectFrame)
    CButtonAll: TCButton;
    ActionAllInvestmentMovements: TAction;
    procedure ActionAllInvestmentMovementsExecute(Sender: TObject);
  protected
    function IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean; override;
    function GetSelectedType: Integer; override;
    procedure DoActionEditExecute; override;
    procedure DoActionDeleteExecute; override;
  public
    class function GetTitle: String; override;
    procedure ReloadDataobjects; override;
    function IsValidFilteredObject(AObject: TDataObject): Boolean; override;
    function GetStaticFilter: TStringList; override;
    class function GetDataobjectClass(AOption: Integer): TDataObjectClass; override;
    class function GetDataobjectProxy(AOption: Integer): TDataProxy; override;
    function GetDataobjectForm(AOption: Integer): TCDataobjectFormClass; override;
  end;

implementation

uses CPluginConsts, CDataObjects, CConsts, CFrameFormUnit,
  CInvestmentMovementFrameUnit, CInvestmentMovementFormUnit, CInfoFormUnit,
  CBaseFrameUnit;

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

procedure TCInvestmentPortfolioFrame.ActionAllInvestmentMovementsExecute(Sender: TObject);
var xGid, xText: String;
begin
  TCFrameForm.ShowFrame(TCInvestmentMovementFrame, xGid, xText, nil, nil, nil, nil, False);
end;

class function TCInvestmentPortfolioFrame.GetDataobjectClass(AOption: Integer): TDataObjectClass;
begin
  Result := TInvestmentMovement;
end;

function TCInvestmentPortfolioFrame.GetDataobjectForm(AOption: Integer): TCDataobjectFormClass;
begin
  Result := TCInvestmentMovementForm;
end;

class function TCInvestmentPortfolioFrame.GetDataobjectProxy(AOption: Integer): TDataProxy;
begin
  Result := InvestmentMovementProxy;
end;

procedure TCInvestmentPortfolioFrame.DoActionEditExecute;
var xGid, xText, xIdAccount, xIdInstrument: String;
begin
  xIdAccount := TInvestmentPortfolio(List.SelectedElement.Data).idAccount;
  xIdInstrument := TInvestmentPortfolio(List.SelectedElement.Data).idInstrument;
  TCFrameForm.ShowFrame(TCInvestmentMovementFrame, xGid, xText, TCInvestmentFrameAdditionalData.Create(xIdAccount, xIdInstrument), nil, nil, nil, False);
end;

procedure TCInvestmentPortfolioFrame.DoActionDeleteExecute;
var xData: TDataObject;
    xBase: TDataObject;
begin
  xBase := TDataObject(List.SelectedElement.Data);
  if xBase.CanBeDeleted(xBase.id) then begin
    if ShowInfo(itQuestion, 'Czy chcesz usun¹æ inwestycjê "' + xBase.GetElementText + '" ?' +
                           '\nPamiêtaj, ¿e usuniêcie wybranej inwestycji spowoduje usuniêcie\nwszystkich zwi¹zanych z ni¹ operacji inwestycyjnych.', '') then begin
      xData := TInvestmentItem.LoadObject(InvestmentItemProxy, xBase.id, False);
      xData.DeleteObject;
      GDataProvider.CommitTransaction;
      AfterDeleteObject(xBase);
      SendMessageToFrames(TCBaseFrameClass(ClassType), WM_DATAREFRESH, 0, 0);
    end;
  end;
end;

end.
