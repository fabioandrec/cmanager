unit CHomeFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, ImgList, PngImageList, ExtCtrls, StdCtrls,
  pngimage;

type
  TCHomeFrame = class(TCBaseFrame)
    Panel1: TPanel;
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.dfm}

constructor TCHomeFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Panel1.Caption := '  ' + FormatDateTime('dd MMMM yyyy', Now);
end;

end.
