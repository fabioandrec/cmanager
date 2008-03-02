unit CCreateDatafileFormUnit;

interface

{$WARN UNIT_PLATFORM OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFormUnit, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  CComponents, ImgList, PngImageList;

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
    procedure FormCreate(Sender: TObject);
    procedure BitBtnFinishClick(Sender: TObject);
    procedure BitBtnPrevClick(Sender: TObject);
    procedure BitBtnNextClick(Sender: TObject);
    procedure CStaticNameGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
  private
    procedure UpdateButtons;
  public
  end;

function CreateDatafileWithWizard(var AFilename: String): Boolean;

implementation

uses CRichtext, FileCtrl;

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
  UpdateButtons;
end;

procedure TCCreateDatafileForm.UpdateButtons;
begin
  BitBtnPrev.Enabled := PageControl.ActivePageIndex <> 0;
  CImage.ImageIndex := PageControl.ActivePageIndex;
  if PageControl.ActivePage = TabSheetDatafile then begin
    CStaticName.SetFocus;
  end else if PageControl.ActivePage = TabSheetSecurity then begin
    EditPassword.SetFocus;
  end else if PageControl.ActivePage = TabSheetDefault then begin
    ComboBoxDefault.SetFocus;
  end;
  if PageControl.ActivePage = TabSheetFinish then begin
    BitBtnNext.Caption := 'Utwórz';
    BitBtnNext.SetFocus;
  end else begin
    BitBtnNext.Caption := 'Dalej';
  end;
end;

procedure TCCreateDatafileForm.BitBtnFinishClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TCCreateDatafileForm.BitBtnPrevClick(Sender: TObject);
begin
  PageControl.SelectNextPage(False, False);
  UpdateButtons;
end;

procedure TCCreateDatafileForm.BitBtnNextClick(Sender: TObject);
begin
  PageControl.SelectNextPage(True, False);
  UpdateButtons;
end;

procedure TCCreateDatafileForm.CStaticNameGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := SaveDialog.Execute;
  if AAccepted then begin
    ADataGid := SaveDialog.FileName;
    AText := MinimizeName(ADataGid, CStaticName.Canvas, CStaticName.Width);
  end;
end;

end.
