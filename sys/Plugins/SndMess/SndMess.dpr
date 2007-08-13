library SndMess;

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
    SetType(CPLUGINTYPE_JUSTEXECUTE);
    SetCaption('Dodaj konto');
    SetDescription('Pozwala dodaæ nowe konto');
  end;
  Result := True;
end;

function Plugin_Execute: OleVariant; stdcall; export;
var xGid: OleVariant;
    xOut: OleVariant;
begin
  VarClear(Result);
  CConnection := CManInterface.GetConnection as _Connection;
  if CConnection <> Nil then begin
    xGid := CreateNewGuid;
    CConnection.Execute(
      'insert into account (idAccount, created, modified, name, description, accountType, cash, initialBalance, idCurrencyDef) values (' +
      DataGidToDatabase(xGid) + ', ' +
      DatetimeToDatabase(Now, True) + ', ' +
      'null, ' +
      '''ca³kiem nowe konto'', ' +
      '''zupe³nie nowe konto'', ' +
      '''C'', ' +
      CurrencyToDatabase(0) + ', ' +
      CurrencyToDatabase(0) + ', ' +
      DataGidToDatabase('{00000000-0000-0000-0000-000000000001}') + ')', xOut, 0);
    CManInterface.SendFrameMessage(CFRAMEMESSAGE_ITEMADDED, CFRAMETYPE_ACCOUNTSFRAME, xGid, CFRAMEOPTPARAM_NULL);
  end;
end;

exports
  Plugin_Initialize,
  Plugin_Execute;
end.
