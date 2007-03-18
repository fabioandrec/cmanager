unit CLimitsFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, Menus, ImgList, PngImageList, CComponents,
  ExtCtrls, VirtualTrees, ActnList, VTHeaderPopup, CDataobjectFrameUnit, CDatabase,
  CDataObjectFormUnit, StdCtrls;

type
  TCLimitsFrame = class(TCDataobjectFrame)
  public
    procedure ReloadDataobjects; override;
    function GetDataobjectClass(AOption: Integer): TDataObjectClass; override;
    function GetDataobjectProxy(AOption: Integer): TDataProxy; override;
    function GetDataobjectForm(AOption: Integer): TCDataobjectFormClass; override;
    function GetStaticFilter: TStringList; override;
  end;

implementation

uses CDataObjects, CDatatools, CCashpointFormUnit;

{$R *.dfm}

function TCLimitsFrame.GetDataobjectClass(AOption: Integer): TDataObjectClass;
begin
  Result := TCashPoint;
end;

function TCLimitsFrame.GetDataobjectForm(AOption: Integer): TCDataobjectFormClass;
begin
  Result := TCCashpointForm;
end;

function TCLimitsFrame.GetDataobjectProxy(AOption: Integer): TDataProxy;
begin
  Result := CashPointProxy;
end;

function TCLimitsFrame.GetStaticFilter: TStringList;
begin
  Result := TStringList.Create;
  Result.Add('0=<wszystkie elementy>');
  Result.Add('1=<dostêpne wszêdzie>');
  Result.Add('2=<tylko rozchody>');
  Result.Add('3=<tylko przychody>');
  Result.Add('4=<pozosta³e>');
end;

procedure TCLimitsFrame.ReloadDataobjects;
begin
  Dataobjects := TCashPoint.GetList(TCashPoint, CashPointProxy, 'select * from cashpoint');
end;

end.
