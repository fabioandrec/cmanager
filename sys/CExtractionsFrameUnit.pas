unit CExtractionsFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFrameUnit, ActnList, VTHeaderPopup, Menus, ImgList,
  PngImageList, CComponents, VirtualTrees, StdCtrls, ExtCtrls, CDataObjects,
  CDatabase, CDataobjectFormUnit;

type
  TCExtractionsFrame = class(TCDataobjectFrame)
  private
  public
    procedure ReloadDataobjects; override;
    function GetStaticFilter: TStringList; override;
    class function GetTitle: String; override;
    function IsValidFilteredObject(AObject: TDataObject): Boolean; override;
    function GetDataobjectClass(AOption: Integer): TDataObjectClass; override;
    function GetDataobjectProxy(AOption: Integer): TDataProxy; override;
    function GetDataobjectForm(AOption: Integer): TCDataobjectFormClass; override;
  end;

implementation

uses CConsts, CExtractionFormUnit;

{$R *.dfm}

function TCExtractionsFrame.GetDataobjectClass(AOption: Integer): TDataObjectClass;
begin
  Result := TAccountExtraction;
end;

function TCExtractionsFrame.GetDataobjectForm(AOption: Integer): TCDataobjectFormClass;
begin
  Result := TCExtractionForm;
end;

function TCExtractionsFrame.GetDataobjectProxy(AOption: Integer): TDataProxy;
begin
  Result := AccountExtractionProxy;
end;

function TCExtractionsFrame.GetStaticFilter: TStringList;
begin
  Result := TStringList.Create;
  with Result do begin
    Add(CFilterAllElements + '=<wszystkie elementy>');
    Add(CExtractionStateOpen + '=<otwarte>');
    Add(CExtractionStateClose + '=<zamkniête>');
    Add(CExtractionStateStated + '=<uzgodnione>');
  end;
end;

class function TCExtractionsFrame.GetTitle: String;
begin
  Result := 'Wyci¹gi';
end;

function TCExtractionsFrame.IsValidFilteredObject(AObject: TDataObject): Boolean;
begin
  Result := (inherited IsValidFilteredObject(AObject)) or
            (CStaticFilter.DataId = CCashpointTypeAll) or
            (TAccountExtraction(AObject).extractionState = CStaticFilter.DataId);
end;

procedure TCExtractionsFrame.ReloadDataobjects;
var xCondition: String;
begin
  inherited ReloadDataobjects;
  if CStaticFilter.DataId = CFilterAllElements then begin
    xCondition := '';
  end else if CStaticFilter.DataId = CExtractionStateOpen then begin
    xCondition := ' where state = ''' + CExtractionStateOpen + '''';
  end else if CStaticFilter.DataId = CExtractionStateClose then begin
    xCondition := ' where state = ''' + CExtractionStateClose + '''';
  end else if CStaticFilter.DataId = CExtractionStateStated then begin
    xCondition := ' where state = ''' + CExtractionStateStated + '''';
  end;
  xCondition := '';
  Dataobjects := TDataObject.GetList(TAccountExtraction, AccountExtractionProxy, 'select * from accountExtraction' + xCondition);
end;

end.
