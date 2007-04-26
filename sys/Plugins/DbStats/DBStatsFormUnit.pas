unit DBStatsFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, ExtCtrls, CPluginTypes, AdoInt;

type
  TDBStatsForm = class(TForm)
    PanelButtons: TPanel;
    BitBtnCancel: TBitBtn;
    PanelConfig: TPanel;
    RichEdit: TRichEdit;
    procedure BitBtnCancelClick(Sender: TObject);
  private
    FIntf: _Connection;
  public
    procedure PrepareInfo;
    property Intf: _Connection read FIntf write FIntf;
  end;

var CManInterface: ICManagerInterface;

implementation

uses CRichtext, CTools;

{$R *.dfm}

procedure TDBStatsForm.BitBtnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TDBStatsForm.PrepareInfo;
var xTexts: TStringList;
    xFilename: String;
begin
  xFilename := CManInterface.GetDatafilename;
  xTexts := TStringList.Create;
  xTexts.Add('');
  xTexts.Add('Plik danych:'#9 + CRtfSB + xFilename + CRtfEB);
  xTexts.Add('Wielkoœæ:'#9#9 + CRtfSB + IntToStr(FileSize(xFilename) div 1024) + ' Kb' + CRtfEB);
  AssignRichText(xTexts.Text, RichEdit);
  xTexts.Free;
end;

end.
 