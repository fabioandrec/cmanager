unit CDepositInvestmentFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFrameUnit, ActnList, VTHeaderPopup, Menus, ImgList,
  PngImageList, CComponents, VirtualTrees, StdCtrls, ExtCtrls, CImageListsUnit, CDatabase, CDataObjects,
  CDataobjectFormUnit;

type
  TCDepositInvestmentFrame = class(TCDataobjectFrame)
    CButtonDetails: TCButton;
    ActionDetails: TAction;
    CButton1: TCButton;
    ActionPay: TAction;
    procedure ActionDetailsExecute(Sender: TObject);
    procedure ActionPayExecute(Sender: TObject);
  protected
    function IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean; override;
    function GetSelectedType: Integer; override;
    procedure DoActionDeleteExecute; override;
  public
    class function GetTitle: String; override;
    function GetStaticFilter: TStringList; override;
    class function GetDataobjectClass(AOption: Integer): TDataObjectClass; override;
    class function GetDataobjectProxy(AOption: Integer): TDataProxy; override;
    function GetDataobjectForm(AOption: Integer): TCDataobjectFormClass; override;
    function IsValidFilteredObject(AObject: TDataObject): Boolean; override;
    procedure ReloadDataobjects; override;
    function GetHistoryText: String; override;
    procedure ShowHistory(AGid: ShortString); override;
    procedure UpdateButtons(AIsSelectedSomething: Boolean); override;
    function CanAcceptSelectedObject: Boolean; override;
  end;

implementation

uses CPluginConsts, CConsts, CDepositInvestmentFormUnit,
  CDepositMovementFrameUnit, CFrameFormUnit, CDepositInvestmentPayFormUnit,
  CConfigFormUnit, CBaseFrameUnit, CMovementFrameUnit, CAccountsFrameUnit,
  CInfoFormUnit, CTools;

{$R *.dfm}

class function TCDepositInvestmentFrame.GetDataobjectClass(AOption: Integer): TDataObjectClass;
begin
  Result := TDepositInvestment;
end;

function TCDepositInvestmentFrame.GetDataobjectForm(AOption: Integer): TCDataobjectFormClass;
begin
  Result := TCDepositInvestmentForm;
end;

class function TCDepositInvestmentFrame.GetDataobjectProxy(AOption: Integer): TDataProxy;
begin
  Result := DepositInvestmentProxy;
end;

function TCDepositInvestmentFrame.GetHistoryText: String;
begin
  Result := 'Wszystkie operacje';
end;

function TCDepositInvestmentFrame.GetSelectedType: Integer;
begin
  if List.FocusedNode <> Nil then begin
    Result := CSELECTEDITEM_DEPOSITINVESTMENT;
  end else begin
    Result := CSELECTEDITEM_INCORRECT;
  end;
end;

function TCDepositInvestmentFrame.GetStaticFilter: TStringList;
begin
  Result := TStringList.Create;
  with Result do begin
    Add(CFilterAllElements + '=<wszystkie elementy>');
    Add(CDepositInvestmentActive + '=<aktywne>');
    Add(CDepositInvestmentClosed + '=<zamkniêta>');
    Add(CDepositInvestmentInactive + '=<nieaktywne>');
  end;
end;

class function TCDepositInvestmentFrame.GetTitle: String;
begin
  Result := 'Lokaty';
end;

function TCDepositInvestmentFrame.IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean;
begin
  Result := (APluginSelectedItemTypes and CSELECTEDITEM_DEPOSITINVESTMENT) = CSELECTEDITEM_DEPOSITINVESTMENT;
end;

function TCDepositInvestmentFrame.IsValidFilteredObject(AObject: TDataObject): Boolean;
begin
  Result := (inherited IsValidFilteredObject(AObject)) or
            (TDepositInvestment(AObject).depositState = CStaticFilter.DataId);
end;

procedure TCDepositInvestmentFrame.ReloadDataobjects;
var xCondition: String;
begin
  inherited ReloadDataobjects;
  if CStaticFilter.DataId = CFilterAllElements then begin
    xCondition := '';
  end else begin
    xCondition := ' where depositState = ''' + CStaticFilter.DataId + '''';
  end;
  Dataobjects := TDepositInvestment.GetList(TDepositInvestment, DepositInvestmentProxy, 'select * from depositInvestment' + xCondition);
end;

procedure TCDepositInvestmentFrame.ShowHistory(AGid: ShortString);
var xGid, xText: String;
begin
  TCFrameForm.ShowFrame(TCDepositMovementFrame, xGid, xText, nil, nil, nil, nil, False);
end;

procedure TCDepositInvestmentFrame.UpdateButtons(AIsSelectedSomething: Boolean);
begin
  inherited UpdateButtons(AIsSelectedSomething);
  ActionHistory.Enabled := True;
  ActionDetails.Enabled := AIsSelectedSomething;
  if AIsSelectedSomething then begin
    ActionPay.Enabled :=  TDepositInvestment(List.SelectedElement.Data).depositState = CDepositInvestmentActive;
  end else begin
    ActionPay.Enabled := AIsSelectedSomething;
  end;
end;

procedure TCDepositInvestmentFrame.ActionDetailsExecute(Sender: TObject);
var xGid, xText, xIdDeposit: String;
begin
  xIdDeposit := TDepositInvestment(List.SelectedElement.Data).id;
  TCFrameForm.ShowFrame(TCDepositMovementFrame, xGid, xText, TCDepositFrameAdditionalData.Create(xIdDeposit, False), nil, nil, nil, False);
end;

procedure TCDepositInvestmentFrame.ActionPayExecute(Sender: TObject);
var xForm: TCDepositInvestmentPayForm;
begin
  xForm := TCDepositInvestmentPayForm.Create(Nil);
  xForm.ShowDataobject(coAdd, DepositMovementProxy, Nil, True, TDepositAdditionalData.Create(TDepositInvestment(List.SelectedElement.Data)));
  xForm.Free;
end;

procedure TCDepositInvestmentFrame.DoActionDeleteExecute;
var xData: TDepositInvestment;
    xCount: Integer;
    xMovements: TDataObjectList;
    xImove: TDepositMovement;
    xBmove: TBaseMovement;
begin
  xData := TDepositInvestment(List.SelectedElement.Data);
  if xData.CanBeDeleted(xData.id) then begin
    if ShowInfo(itQuestion, 'Czy chcesz usun¹æ lokatê "' + xData.GetElementText + '" ?' +
                           '\nPamiêtaj, ¿e usuniêcie wybranej lokaty spowoduje usuniêcie\nwszystkich zwi¹zanych z ni¹ operacji.', '') then begin
      xMovements := xData.GetDepositMovements;
      for xCount := 0 to xMovements.Count - 1 do begin
        xImove := TDepositMovement(xMovements.Items[xCount]);
        xImove.DeleteObject;
        if xImove.idBaseMovement <> CEmptyDataGid then begin
          xBmove := TBaseMovement(TBaseMovement.LoadObject(BaseMovementProxy, xImove.idBaseMovement, False));
          xBmove.DeleteObject;
        end;
      end;
      xData.DeleteObject;
      GDataProvider.CommitTransaction;
      xMovements.Free;
      AfterDeleteObject(xData);
      SendMessageToFrames(TCBaseFrameClass(ClassType), WM_DATAOBJECTDELETED, Integer(@xData.id), 0);
      SendMessageToFrames(TCMovementFrame, WM_DATAREFRESH, 0, 0);
      SendMessageToFrames(TCAccountsFrame, WM_DATAREFRESH, 0, 0);
    end;
  end;
end;

function TCDepositInvestmentFrame.CanAcceptSelectedObject: Boolean;
begin
  Result := inherited CanAcceptSelectedObject;
  if Result and (AdditionalData <> Nil) then begin
    if TCDepositFrameAdditionalData(AdditionalData).OnlyNonclosed then begin
      Result := TDepositInvestment(List.SelectedElement.Data).depositState <> CDepositInvestmentClosed;
      if not Result then begin
        ShowInfo(itWarning, 'Wybrana lokata jest zamkniêta. Operacje mo¿na dodawaæ tylko dla niezamkniêtych lokat', '');
      end;
    end;
  end;
end;

end.
