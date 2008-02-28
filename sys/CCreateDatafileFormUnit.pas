unit CCreateDatafileFormUnit;

interface

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
    CRicheditWelcome: TCRichedit;
    CImage: TCImage;
    PngImageList: TPngImageList;
    procedure FormCreate(Sender: TObject);
  private
  public
  end;

function CreateDatafileWithWizard(var AFilename: String): Boolean;

implementation

{$R *.dfm}

function CreateDatafileWithWizard(var AFilename: String): Boolean;
begin
  with TCCreateDatafileForm.Create(Application) do begin
    Result := ShowModal = mrOk;
    Free;
  end;
end;

procedure TCCreateDatafileForm.FormCreate(Sender: TObject);
begin
  inherited;
  CImage.ImageIndex := 0;
end;

end.
