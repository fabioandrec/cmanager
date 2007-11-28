unit CInvestmentWalletFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFrameUnit, ActnList, VTHeaderPopup, Menus, ImgList,
  PngImageList, CComponents, VirtualTrees, StdCtrls, ExtCtrls, CDatabase,
  CDataobjectFormUnit;

type
  TCInvestmentWalletFrame = class(TCDataobjectFrame)
  protected
    function IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean; override;
    function GetSelectedType: Integer; override;
  public
    class function GetTitle: String; override;
    procedure ReloadDataobjects; override;
    class function GetDataobjectClass(AOption: Integer): TDataObjectClass; override;
    class function GetDataobjectProxy(AOption: Integer): TDataProxy; override;
    function GetDataobjectForm(AOption: Integer): TCDataobjectFormClass; override;
  end;

implementation

uses CDataObjects, CInvestmentWalletFormUnit, CConsts, CPluginConsts;

{$R *.dfm}

class function TCInvestmentWalletFrame.GetDataobjectClass(AOption: Integer): TDataObjectClass;
begin
  Result := TInvestmentWallet;
end;

function TCInvestmentWalletFrame.GetDataobjectForm(AOption: Integer): TCDataobjectFormClass;
begin
  Result := TCInvestmentWalletForm;
end;

class function TCInvestmentWalletFrame.GetDataobjectProxy(AOption: Integer): TDataProxy;
begin
  Result := InvestmentWalletProxy;
end;

function TCInvestmentWalletFrame.GetSelectedType: Integer;
begin
  if List.FocusedNode <> Nil then begin
    Result := CSELECTEDITEM_INVESTMENTWALLET;
  end else begin
    Result := CSELECTEDITEM_INCORRECT;
  end;
end;

class function TCInvestmentWalletFrame.GetTitle: String;
begin
  Result := 'Portfele inwestycyjne';
end;

function TCInvestmentWalletFrame.IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean;
begin
  Result := (APluginSelectedItemTypes and CSELECTEDITEM_INVESTMENTWALLET) = CSELECTEDITEM_INVESTMENTWALLET;
end;

procedure TCInvestmentWalletFrame.ReloadDataobjects;
begin
  inherited ReloadDataobjects;
  Dataobjects := TInvestmentWallet.GetAllObjects(InvestmentWalletProxy);
end;

end.
 