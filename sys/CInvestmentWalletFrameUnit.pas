unit CInvestmentWalletFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFrameUnit, ActnList, VTHeaderPopup, Menus, ImgList,
  PngImageList, CComponents, VirtualTrees, StdCtrls, ExtCtrls;

type
  TCInvestmentWalletFrame = class(TCDataobjectFrame)
  private
  public
    class function GetTitle: String; override;
    procedure ReloadDataobjects; override;
  end;

implementation

uses CDataObjects, CDatabase;

{$R *.dfm}

class function TCInvestmentWalletFrame.GetTitle: String;
begin
  Result := 'Portfele inwestycyjne';
end;

procedure TCInvestmentWalletFrame.ReloadDataobjects;
begin
  inherited ReloadDataobjects;
  Dataobjects := TInvestmentWallet.GetAllObjects(InvestmentWalletProxy);
end;

end.
 