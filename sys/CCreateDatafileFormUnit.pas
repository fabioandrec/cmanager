unit CCreateDatafileFormUnit;

interface

{$WARN UNIT_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFormUnit, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  CComponents, ImgList, PngImageList, CXml;

type
  TCCreateDatafileForm = class(TCBaseForm)
    PanelButtons: TPanel;
    BitBtnNext: TBitBtn;
    BitBtnFinish: TBitBtn;
    BitBtnPrev: TBitBtn;
    PanelImage: TPanel;
    PageControl: TPageControl;
    TabSheetStart: TTabSheet;
    CImage: TCImage;
    PngImageList: TPngImageList;
    TabSheetDatafile: TTabSheet;
    CStaticName: TCStatic;
    Label2: TLabel;
    Label3: TLabel;
    Label1: TLabel;
    Label4: TLabel;
    SaveDialog: TSaveDialog;
    TabSheetSecurity: TTabSheet;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    EditPassword: TEdit;
    Label8: TLabel;
    TabSheetDefault: TTabSheet;
    Label9: TLabel;
    Label10: TLabel;
    ComboBoxDefault: TComboBox;
    CButtonShowDefault: TCButton;
    TabSheetFinish: TTabSheet;
    LabelInfo: TLabel;
    LabelFinish: TLabel;
    CStaticDesc: TCStatic;
    procedure FormCreate(Sender: TObject);
    procedure BitBtnFinishClick(Sender: TObject);
    procedure BitBtnPrevClick(Sender: TObject);
    procedure BitBtnNextClick(Sender: TObject);
    procedure CStaticNameGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure CButtonShowDefaultClick(Sender: TObject);
    procedure CStaticDescGetDataId(var ADataGid, AText: String;
      var AAccepted: Boolean);
  private
    FDefaultXml: ICXMLDOMDocument;
    FCheckedData: TStringList;
    FReportList: TStringList;
    FIsDisabled: Boolean;
    procedure UpdateButtons;
    procedure UpdateTabs;
    procedure LoadDefaultXmlData;
    function DoCreateDatafile: Boolean;
    function CanSelectNextPage: Boolean;
    function GetDisabled: Boolean;
    procedure SetDisabled(const Value: Boolean);
    procedure AddToReport(AText: String);
  public
    property Disabled: Boolean read GetDisabled write SetDisabled;
  end;

function CreateDatafileWithWizard(var AFilename: String): Boolean;

implementation

uses CRichtext, FileCtrl, CXmlFrameUnit, CInfoFormUnit, CReportFormUnit,
  CMemoFormUnit, CAdox;

{$R *.dfm}

function CreateDatafileWithWizard(var AFilename: String): Boolean;
begin
  with TCCreateDatafileForm.Create(Application) do begin
    SaveDialog.FileName := AFilename;
    CStaticName.Caption := MinimizeName(AFilename, CStaticName.Canvas, CStaticName.Width);
    CStaticName.DataId := AFilename;
    Result := ShowModal = mrOk;
    if Result then begin
      AFilename := CStaticName.DataId;
    end;
    Free;
  end;
end;

procedure TCCreateDatafileForm.FormCreate(Sender: TObject);
begin
  inherited;
  PageControl.ActivePage := TabSheetStart;
  FCheckedData := TStringList.Create;
  FReportList := TStringList.Create;
  FIsDisabled := False;
  LoadDefaultXmlData;
  UpdateButtons;
  UpdateTabs;
end;

procedure TCCreateDatafileForm.UpdateButtons;
begin
  BitBtnPrev.Enabled := (PageControl.ActivePageIndex <> 0) and (not FIsDisabled);
  BitBtnNext.Enabled := not FIsDisabled;
  BitBtnFinish.Enabled := not FIsDisabled;
end;

procedure TCCreateDatafileForm.BitBtnFinishClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TCCreateDatafileForm.BitBtnPrevClick(Sender: TObject);
begin
  PageControl.SelectNextPage(False, False);
  UpdateButtons;
  UpdateTabs;
end;

procedure TCCreateDatafileForm.BitBtnNextClick(Sender: TObject);
var xProceed: Boolean;
begin
  if PageControl.ActivePageIndex <> PageControl.PageCount - 1 then begin
    if CanSelectNextPage then begin
      PageControl.SelectNextPage(True, False);
      UpdateButtons;
      UpdateTabs;
    end;
  end else begin
    if FileExists(CStaticName.DataId) then begin
      xProceed := ShowInfo(itQuestion, 'Plik danych o nazwie "' + CStaticName.DataId + '" ju¿ istnieje.\nCzy chcesz go nadpisaæ?', '');
    end else begin
      xProceed := True;
    end;
    if xProceed then begin
      if DoCreateDatafile then begin
        ModalResult := mrOk;
      end else begin
        CImage.ImageIndex := 5;
        LabelFinish.Caption := 'CManager nie móg³ utworzyæ nowego pliku danych. SprawdŸ raport z wykonanych czynnoœci. Aby ponowiæ próbê tworzenia pliku wybierz przycisk "Utwórz". Aby zrezygnow¹æ wybierz przycisk "Wyjœcie".';
        LabelInfo.Caption := 'B³¹d tworzenia pliku danych';
      end;
    end;
  end;
end;

procedure TCCreateDatafileForm.CStaticNameGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := SaveDialog.Execute;
  if AAccepted then begin
    ADataGid := SaveDialog.FileName;
    AText := MinimizeName(ADataGid, CStaticName.Canvas, CStaticName.Width);
  end;
end;

procedure TCCreateDatafileForm.LoadDefaultXmlData;
var xResStream: TResourceStream;
    xXmlString: String;
begin
  xXmlString := '';
  xResStream := TResourceStream.Create(HInstance, 'SQLDEFS', RT_RCDATA);
  SetLength(xXmlString, xResStream.Size);
  if xResStream.Size > 0 then begin
    CopyMemory(@xXmlString[1], xResStream.Memory, xResStream.Size);
  end;
  FDefaultXml := GetDocumentFromString(xXmlString, Nil);
  xResStream.Free;
end;

procedure TCCreateDatafileForm.FormDestroy(Sender: TObject);
begin
  FCheckedData.Free;
  FReportList.Free;
  FDefaultXml := Nil;
  inherited;
end;

procedure TCCreateDatafileForm.CButtonShowDefaultClick(Sender: TObject);
begin
  ShowXmlFile(FDefaultXml, FCheckedData);
end;

function TCCreateDatafileForm.CanSelectNextPage: Boolean;
begin
  Result := True;
  if PageControl.ActivePage = TabSheetDatafile then begin
    if Trim(CStaticName.DataId) = '' then begin
      ShowInfo(itError, 'Nie wybra³eœ nazwy i lokalizacji dla nowego pliku danych', '');
      CStaticName.SetFocus;
      Result := False;
    end;
  end;
end;

function TCCreateDatafileForm.DoCreateDatafile: Boolean;
var xOverridenBackupFilename: String;
    xProceed: Boolean;
    xError: String;
begin
  Result := False;
  Disabled := True;
  if FileExists(CStaticName.DataId) then begin
    xOverridenBackupFilename := ChangeFileExt(CStaticName.DataId, '.' + FormatDateTime('yymmddhhnnss', Now));
    AddToReport('Wykonywanie kopii pliku ' + CStaticName.DataId + ' do pliku ' + xOverridenBackupFilename);
    if MoveFile(PChar(CStaticName.DataId), PChar(xOverridenBackupFilename)) then begin
      xProceed := True;
      AddToReport('Utworzono kopiê pliku ' + CStaticName.DataId);
    end else begin
      xProceed := False;
      AddToReport('Nie mo¿na utworzyæ kopii istniej¹cego pliku ' + CStaticName.DataId + '. ' + SysErrorMessage(GetLastError));
    end;
  end else begin
    xProceed := True;
  end;
  if xProceed then begin
    AddToReport('Tworzenie nowego pliku danych');
    if CreateDatabase(CStaticName.DataId, EditPassword.Text, xError) then begin
    end else begin
      AddToReport('B³¹d podczas tworzenia pliku danych');
      AddToReport(xError);
    end;
  end;
  if (xOverridenBackupFilename <> '') then begin
    if Result then begin
    end else begin
      AddToReport('Przywracanie pliku ' + CStaticName.DataId + ' z kopii ' + xOverridenBackupFilename);
      if MoveFile(PChar(xOverridenBackupFilename), PChar(CStaticName.DataId)) then begin
        AddToReport('Przywrócono kopiê pliku ' + CStaticName.DataId + ' z pliku ' + xOverridenBackupFilename);
      end else begin
        AddToReport('Nie mo¿na przywróciæ pliku ' + CStaticName.DataId + ' z kopii ' + xOverridenBackupFilename + '. ' + SysErrorMessage(GetLastError));
      end;
    end;
    CStaticDesc.Visible := True;
  end;
  Disabled := False;
end;

function TCCreateDatafileForm.GetDisabled: Boolean;
begin
  Result := FIsDisabled;
end;

procedure TCCreateDatafileForm.SetDisabled(const Value: Boolean);
var hMenu: THandle;
    xOpt: Cardinal;
begin
  FIsDisabled := Value;
  hMenu := GetSystemMenu(Handle, False);
  if Value then begin
    xOpt := MF_DISABLED + MF_GRAYED;
  end else begin
    xOpt := MF_ENABLED;
  end;
  EnableMenuItem(hMenu, SC_CLOSE, xOpt);
  UpdateButtons;
end;

procedure TCCreateDatafileForm.UpdateTabs;
begin
  CImage.ImageIndex := PageControl.ActivePageIndex;
  if PageControl.ActivePage = TabSheetDatafile then begin
    CStaticName.SetFocus;
  end else if PageControl.ActivePage = TabSheetSecurity then begin
    EditPassword.SetFocus;
  end else if PageControl.ActivePage = TabSheetDefault then begin
    ComboBoxDefault.SetFocus;
  end;
  if PageControl.ActivePage = TabSheetFinish then begin
    CStaticDesc.Visible := False;
    LabelFinish.Caption := 'CManager jest gotowy do utworzenia nowego pliku danych. Wybierz przycisk "Utwórz" aby rozpocz¹æ tworzenie pliku danych. Je¿eli chcesz zrezygnowaæ wybierz przycisk "Wyjœcie".';
    LabelInfo.Caption := 'PotwierdŸ utworzenie pliku danych';
    BitBtnNext.Caption := 'Utwórz';
    BitBtnNext.SetFocus;
  end else begin
    BitBtnNext.Caption := 'Dalej';
  end;
end;

procedure TCCreateDatafileForm.AddToReport(AText: String);
begin
  FReportList.Add(FormatDateTime('hh:nn:ss', Now) + ' ' + AText);
end;

procedure TCCreateDatafileForm.CStaticDescGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := False;
  ShowReport('Raport z wykonanych czynnoœci', FReportList.Text, 400, 300);
end;

end.
