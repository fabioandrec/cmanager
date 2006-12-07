unit CImageListsUnit;

interface

uses
  SysUtils, Classes, ImgList, Controls, PngImageList;

type
  TCImageLists = class(TDataModule)
    MainImageList24x24: TPngImageList;
    MainImageList16x16: TPngImageList;
    MainImageList32x32: TPngImageList;
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
