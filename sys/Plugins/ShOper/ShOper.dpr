library ShOper;

{$R *.res}

uses
  Windows,
  Dialogs,
  Forms,
  Variants,
  SysUtils,
  Classes,
  AdoInt,
  CPluginTypes in '..\CPluginTypes.pas',
  CPluginConsts in '..\CPluginConsts.pas',
  CTools in '..\..\Shared\CTools.pas';

var CManInterface: ICManagerInterface;
    CConnection: _Connection;

function Plugin_Initialize(ACManagerInterface: ICManagerInterface): Boolean; stdcall; export;
begin
  CManInterface := ACManagerInterface;
  with CManInterface do begin
    Application.Handle := GetAppHandle;
    SetType(CPLUGINTYPE_SELECTEDITEM or
               CSELECTEDITEM_BASEMOVEMENT or
               CSELECTEDITEM_MOVEMENTLIST or
               CSELECTEDITEM_ACCOUNT or
               CSELECTEDITEM_EXTRACTIONITEM);
    SetCaption('Poka¿ zaznaczenie');
    SetDescription('Pozwala pokazaæ zaznaczenie');
  end;
  Result := True;
end;

function Plugin_Execute: OleVariant; stdcall; export;
var xType: Integer;
    xGid: OleVariant;
begin
  VarClear(Result);
  CConnection := CManInterface.GetConnection as _Connection;
  if CConnection <> Nil then begin
    xType := CManInterface.GetSelectedType;
    xGid :=  CManInterface.GetSelectedId;
    if not VarIsEmpty(xGid) then begin
      if xType = CSELECTEDITEM_BASEMOVEMENT then begin
        CManInterface.ShowReportBox('Informacja', '<html><body>Typ: <b>Operacja</b></div>Gid: <b>' + xGid + '</b></body><html>');
      end else if xType = CSELECTEDITEM_MOVEMENTLIST then begin
        CManInterface.ShowReportBox('Informacja', '<html><body>Typ: <b>Lista operacji</b></div>Gid: <b>' + xGid + '</b></body><html>');
      end else begin
        CManInterface.ShowDialogBox('Wtyczka otrzyma³a nieobs³ugiwany typ obiektu', CDIALOGBOX_ERROR);
      end;
    end else begin
      CManInterface.ShowDialogBox('Wtyczka otrzyma³a pusty identyfikator obiektu', CDIALOGBOX_ERROR);
    end;
  end;
end;

exports
  Plugin_Initialize,
  Plugin_Execute;
end.
