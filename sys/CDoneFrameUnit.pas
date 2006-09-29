unit CDoneFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, ImgList, VirtualTrees, StdCtrls, CComponents,
  ExtCtrls;

type
  TCDoneFrame = class(TCBaseFrame)
    Panel: TPanel;
    Label1: TLabel;
    CStaticPeriod: TCStatic;
    TodayList: TVirtualStringTree;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
 