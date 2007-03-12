unit CFilterFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  ImgList, CComponents, CDatabase, AdoDB, CBaseFrameUnit;

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
  protected
    procedure ReadValues; override;
    function GetDataobjectClass: TDataObjectClass; override;
    procedure FillForm; override;
    function CanAccept: Boolean; override;
    function GetUpdateFrameClass: TCBaseFrameClass; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

uses CDataObjects, CInfoFormUnit, CFrameFormUnit, CAccountsFrameUnit,
  CCashpointsFrameUnit, CProductsFrameUnit, CFilterFrameUnit, CRichtext;

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
begin
  with TMovementFilter(Dataobject) do begin
    EditName.Text := name;
    SimpleRichText(description, RichEditDesc);
    LoadSubfilters;
    FFilterAccounts.Text := accounts.Text;
    FFilterProducts.Text := products.Text;
    FFilterCashpoints.Text := cashpoints.Text;
    if accounts.Count = 0 then begin
      CStaticAccount.Caption := '<wszystkie konta>';
    end else begin
      CStaticAccount.Caption := '<wybrano ' + IntToStr(accounts.Count) + '>';
    end;
    if cashpoints.Count = 0 then begin
      CStaticCashpoint.Caption := '<wszyscy kontrahenci>';
    end else begin
      CStaticCashpoint.Caption := '<wybrano ' + IntToStr(cashpoints.Count) + '>';
    end;
    if products.Count = 0 then begin
      CStaticProducts.Caption := '<wszystkie kategorie>';
    end else begin
      CStaticProducts.Caption := '<wybrano ' + IntToStr(products.Count) + '>';
    end;
  end;
end;

function TCFilterForm.GetDataobjectClass: TDataObjectClass;
begin
  Result := TMovementFilter;
end;

procedure TCFilterForm.ReadValues;
begin
  inherited ReadValues;
  with TMovementFilter(Dataobject) do begin
    name := EditName.Text;
    description := RichEditDesc.Text;
    products := FFilterProducts;
    accounts := FFilterAccounts;
    cashpoints := FFilterCashpoints;
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

function TCFilterForm.GetUpdateFrameClass: TCBaseFrameClass;
begin
  Result := TCFilterFrame;
end;

end.
