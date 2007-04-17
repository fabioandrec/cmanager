unit CImageListsUnit;

interface

uses
  SysUtils, Classes, ImgList, Controls, PngImageList, PngFunctions, Graphics, PngImage;

type
  TCImageLists = class(TDataModule)
    MainImageList24x24: TPngImageList;
    MainImageList16x16: TPngImageList;
    MainImageList32x32: TPngImageList;
    AccountFrameImageList24x24: TPngImageList;
    CashpointImageList24x24: TPngImageList;
    CategoryImageList24x24: TPngImageList;
    OperationsImageList24x24: TPngImageList;
    CyclicImageList24x24: TPngImageList;
    DoneImageList24x24: TPngImageList;
    StatsImageList24x24: TPngImageList;
    FilterImageList24x24: TPngImageList;
    MovementIcons16x16: TPngImageList;
    ProfileImageList24x24: TPngImageList;
    DoneImageList16x16: TPngImageList;
    PlannedImageList16x16: TPngImageList;
    TemplateImageList16x16: TPngImageList;
    LimitsImageList24x24: TPngImageList;
    StatusbarImagesList16x16: TPngImageList;
    ActionImageList: TPngImageList;
    CurrencyDefImageList24x24: TPngImageList;
    CurrencyRateImageList24x24: TPngImageList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var CImageLists: TCImageLists;

implementation

{$R *.dfm}

initialization
  CImageLists := TCImageLists.Create(Nil);
finalization
  CImageLists.Free;
end.
