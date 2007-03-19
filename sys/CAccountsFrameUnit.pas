unit CAccountsFrameUnit;

interface

uses CDataobjectFrameUnit, Classes, ActnList, VTHeaderPopup, Menus,
     ImgList, Controls, PngImageList, CComponents, VirtualTrees, StdCtrls,
     ExtCtrls, CDatabase, CDataobjectFormUnit, CImageListsUnit;

type
  TCAccountsFrame = class(TCDataobjectFrame)
  public
    class function GetTitle: String; override;
    function IsValidFilteredObject(AObject: TDataObject): Boolean; override;
    procedure ReloadDataobjects; override;
    function GetStaticFilter: TStringList; override;
    function GetDataobjectClass(AOption: Integer): TDataObjectClass; override;
    function GetDataobjectProxy(AOption: Integer): TDataProxy; override;
    function GetDataobjectForm(AOption: Integer): TCDataobjectFormClass; override;
  end;

implementation

uses CDataObjects, CAccountFormUnit, CConsts;

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

function TCAccountsFrame.GetStaticFilter: TStringList;
begin
  Result := TStringList.Create;
  with Result do begin
    Add(CFilterAllElements + '=<wszystkie elementy>');
    Add(CCashAccount + '=<konta gotówkowe>');
    Add(CBankAccount + '=<konta bankowe>');
  end;
end;

class function TCAccountsFrame.GetTitle: String;
begin
  Result := 'Konta';
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
  end else if CStaticFilter.DataId = CCashAccount then begin
    xCondition := ' where accountType = ''' + CCashAccount + '''';
  end else if CStaticFilter.DataId = CBankAccount then begin
    xCondition := ' where accountType = ''' + CBankAccount + '''';
  end;
  Dataobjects := TAccount.GetList(TAccount, AccountProxy, 'select * from account' + xCondition);
end;

end.
