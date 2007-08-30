unit CExtractionsFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFrameUnit, ActnList, VTHeaderPopup, Menus, ImgList,
  PngImageList, CComponents, VirtualTrees, StdCtrls, ExtCtrls, CDataObjects,
  CDatabase, CDataobjectFormUnit, CImageListsUnit;

type
  TCExtractionFrameData = class(TCDataobjectFrameData)
  private
    FidAccount: TDataGid;
  published
    property idAccount: TDataGid read FidAccount write FidAccount;
  end;

  TCExtractionsFrame = class(TCDataobjectFrame)
  protected
    function GetSelectedType: Integer; override;
    function IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean; override;
  public
    procedure ReloadDataobjects; override;
    function GetStaticFilter: TStringList; override;
    class function GetTitle: String; override;
    function IsValidFilteredObject(AObject: TDataObject): Boolean; override;
    class function GetDataobjectClass(AOption: Integer): TDataObjectClass; override;
    class function GetDataobjectProxy(AOption: Integer): TDataProxy; override;
    function GetDataobjectForm(AOption: Integer): TCDataobjectFormClass; override;
    class function GetPrefname: String; override;
    function GetHistoryText: String; override;
    procedure ShowHistory(AGid: ShortString); override;
  end;

implementation

uses CConsts, CExtractionFormUnit, CBaseFrameUnit, CReports, CPluginConsts,
  CTools;

{$R *.dfm}

class function TCExtractionsFrame.GetDataobjectClass(AOption: Integer): TDataObjectClass;
begin
  Result := TAccountExtraction;
end;

function TCExtractionsFrame.GetDataobjectForm(AOption: Integer): TCDataobjectFormClass;
begin
  Result := TCExtractionForm;
end;

class function TCExtractionsFrame.GetDataobjectProxy(AOption: Integer): TDataProxy;
begin
  Result := AccountExtractionProxy;
end;

function TCExtractionsFrame.GetHistoryText: String;
begin
  Result := 'Drukuj wyci¹g';
end;

class function TCExtractionsFrame.GetPrefname: String;
begin
  Result := 'accountExtraction';
end;

function TCExtractionsFrame.GetSelectedType: Integer;
begin
  if List.FocusedNode <> Nil then begin
    Result := CSELECTEDITEM_EXTRACTION;
  end else begin
    Result := CSELECTEDITEM_INCORRECT;
  end;
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

function TCExtractionsFrame.IsSelectedTypeCompatible(APluginSelectedItemTypes: Integer): Boolean;
begin
  Result := (APluginSelectedItemTypes and CSELECTEDITEM_EXTRACTION) = CSELECTEDITEM_EXTRACTION;
end;

function TCExtractionsFrame.IsValidFilteredObject(AObject: TDataObject): Boolean;
begin
  Result := (inherited IsValidFilteredObject(AObject)) or
            (TAccountExtraction(AObject).extractionState = CStaticFilter.DataId);
  if Result and (AdditionalData <> Nil) then begin
    Result := TCExtractionFrameData(AdditionalData).idAccount = TAccountExtraction(AObject).idAccount;
  end;
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
  if (AdditionalData <> Nil) then begin
    if xCondition = '' then begin
      xCondition := ' where idAccount = ' + DataGidToDatabase(TCExtractionFrameData(AdditionalData).idAccount);
    end else begin
      xCondition := ' and idAccount = ' + DataGidToDatabase(TCExtractionFrameData(AdditionalData).idAccount);
    end;
  end;
  Dataobjects := TDataObject.GetList(TAccountExtraction, AccountExtractionProxy, 'select * from accountExtraction' + xCondition);
end;

procedure TCExtractionsFrame.ShowHistory(AGid: ShortString);
var xReport: TAccountExtractionReport;
    xParams: TCReportParams;
begin
  xParams := TCWithGidParams.Create(AGid);
  xReport := TAccountExtractionReport.CreateReport(xParams);
  xReport.ShowReport;
  xReport.Free;
  xParams.Free;
end;

end.
