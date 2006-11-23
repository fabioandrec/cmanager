unit CFilterFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  ImgList, CComponents, CDatabase, AdoDB;

type
  TCFilterForm = class(TCDataobjectForm)
    GroupBox2: TGroupBox;
    EditName: TEdit;
    Label1: TLabel;
    RichEditDesc: TRichEdit;
    Label2: TLabel;
    GroupBox1: TGroupBox;
    Label14: TLabel;
    CStaticAccount: TCStatic;
    Label3: TLabel;
    CStaticCashpoint: TCStatic;
    Label4: TLabel;
    CStaticProducts: TCStatic;
    procedure CStaticAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticProductsGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
  private
    FFilterAccounts: TStringList;
    FFilterProducts: TStringList;
    FFilterCashpoints: TStringList;
    procedure FillFilterList(AList: TStringList; AQuery: TADOQuery);
  protected
    procedure ReadValues; override;
    function GetDataobjectClass: TDataObjectClass; override;
    procedure FillForm; override;
    function CanAccept: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

uses CDataObjects, CInfoFormUnit, CFrameFormUnit, CAccountsFrameUnit,
  CCashpointsFrameUnit, CProductsFrameUnit;

{$R *.dfm}

function TCFilterForm.CanAccept: Boolean;
begin
  Result := inherited CanAccept;
  if Trim(EditName.Text) = '' then begin
    Result := False;
    ShowInfo(itError, 'Nazwa filtru nie mo¿e byæ pusta', '');
    EditName.SetFocus;
  end;
end;

procedure TCFilterForm.FillForm;
var xQ: TADOQuery;
begin
  with TMovementFilter(Dataobject) do begin
    EditName.Text := name;
    RichEditDesc.Text := description;
    xQ := GDataProvider.OpenSql('select idAccount as filtered from accountFilter where idMovementFilter = ' + DataGidToDatabase(id));
    FillFilterList(FFilterAccounts, xQ);
    xQ.Free;
    if FFilterAccounts.Count = 0 then begin
      CStaticAccount.Caption := '<wszystkie konta>';
    end else begin
      CStaticAccount.Caption := '<wybrano ' + IntToStr(FFilterAccounts.Count) + '>';
    end;
    xQ := GDataProvider.OpenSql('select idCashpoint as filtered from cashpointFilter where idMovementFilter = ' + DataGidToDatabase(id));
    FillFilterList(FFilterCashpoints, xQ);
    xQ.Free;
    if FFilterCashpoints.Count = 0 then begin
      CStaticCashpoint.Caption := '<wszyscy kontrahenci>';
    end else begin
      CStaticCashpoint.Caption := '<wybrano ' + IntToStr(FFilterCashpoints.Count) + '>';
    end;
    xQ := GDataProvider.OpenSql('select idProduct as filtered from productFilter where idMovementFilter = ' + DataGidToDatabase(id));
    FillFilterList(FFilterProducts, xQ);
    xQ.Free;
    if FFilterProducts.Count = 0 then begin
      CStaticProducts.Caption := '<wszystkie kategorie>';
    end else begin
      CStaticProducts.Caption := '<wybrano ' + IntToStr(FFilterProducts.Count) + '>';
    end;
  end;
end;

function TCFilterForm.GetDataobjectClass: TDataObjectClass;
begin
  Result := TMovementFilter;
end;

procedure TCFilterForm.ReadValues;
var xCount: Integer;
begin
  inherited ReadValues;
  with TMovementFilter(Dataobject) do begin
    name := EditName.Text;
    description := RichEditDesc.Text;
    GDataProvider.ExecuteSql('delete from accountFilter where idMovementFilter = ' + DataGidToDatabase(id));
    GDataProvider.ExecuteSql('delete from cashpointFilter where idMovementFilter = ' + DataGidToDatabase(id));
    GDataProvider.ExecuteSql('delete from productFilter where idMovementFilter = ' + DataGidToDatabase(id));
    for xCount := 0 to FFilterProducts.Count - 1 do begin
      GDataProvider.ExecuteSql(Format(
             'insert into productFilter (idMovementFilter, idProduct) values (%s, %s)',
             [DataGidToDatabase(id), DataGidToDatabase(FFilterProducts.Strings[xCount])]));
    end;
    for xCount := 0 to FFilterAccounts.Count - 1 do begin
      GDataProvider.ExecuteSql(Format(
             'insert into accountFilter (idMovementFilter, idAccount) values (%s, %s)',
             [DataGidToDatabase(id), DataGidToDatabase(FFilterAccounts.Strings[xCount])]));
    end;
    for xCount := 0 to FFilterCashpoints.Count - 1 do begin
      GDataProvider.ExecuteSql(Format(
             'insert into cashpointFilter (idMovementFilter, idCashpoint) values (%s, %s)',
             [DataGidToDatabase(id), DataGidToDatabase(FFilterCashpoints.Strings[xCount])]));
    end;
  end;
end;

procedure TCFilterForm.CStaticAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
var xDataGid: String;
begin
  xDataGid := FFilterAccounts.Text;
  AAccepted := TCFrameForm.ShowFrame(TCAccountsFrame, xDataGid, AText, Nil, Nil, Nil, FFilterAccounts);
  ADataGid := FFilterAccounts.Text;
  if ADataGid = '' then begin
    AText := '<wszystkie konta>';
  end else begin
    AText := '<wybrano ' + IntToStr(FFilterAccounts.Count) + '>';
  end;
end;

procedure TCFilterForm.CStaticCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
var xDataGid: String;
begin
  xDataGid := FFilterCashpoints.Text;
  AAccepted := TCFrameForm.ShowFrame(TCCashpointsFrame, xDataGid, AText, Nil, Nil, Nil, FFilterCashpoints);
  ADataGid := FFilterCashpoints.Text;
  if ADataGid = '' then begin
    AText := '<wszyscy kontrahenci>';
  end else begin
    AText := '<wybrano ' + IntToStr(FFilterCashpoints.Count) + '>';
  end;
end;

procedure TCFilterForm.CStaticProductsGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
var xDataGid: String;
begin
  xDataGid := FFilterProducts.Text;
  AAccepted := TCFrameForm.ShowFrame(TCProductsFrame, xDataGid, AText, Nil, Nil, Nil, FFilterProducts);
  ADataGid := FFilterProducts.Text;
  if ADataGid = '' then begin
    AText := '<wszystkie kategorie>';
  end else begin
    AText := '<wybrano ' + IntToStr(FFilterProducts.Count) + '>';
  end;
end;

constructor TCFilterForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFilterAccounts := TStringList.Create;
  FFilterProducts := TStringList.Create;
  FFilterCashpoints := TStringList.Create;
end;

destructor TCFilterForm.Destroy;
begin
  FFilterAccounts.Free;
  FFilterProducts.Free;
  FFilterCashpoints.Free;
  inherited Destroy;
end;

procedure TCFilterForm.FillFilterList(AList: TStringList; AQuery: TADOQuery);
begin
  AList.Clear;
  while not AQuery.Eof do begin
    AList.Add(AQuery.FieldByName('filtered').AsString);
    AQuery.Next;
  end;
end;

end.
