unit CStartupInfoFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFormUnit, ExtCtrls, VirtualTrees, StdCtrls, CComponents,
  ActnList, XPStyleActnCtrls, ActnMan, ImgList, PngImageList, CDatabase,
  Contnrs, CSchedules, Buttons, PngSpeedButton, CStartupInfoFrameUnit;

type
  TCStartupInfoForm = class(TCBaseForm)
    ActionManager1: TActionManager;
    Action1: TAction;
    Action2: TAction;
    PngImageList1: TPngImageList;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    CButton1: TCButton;
    CButton2: TCButton;
    procedure Action1Execute(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
  private
    FInfoFrame: TCStartupInfoFrame;
  public
    function PrepareInfoFrame: Boolean;
  end;

implementation

uses CPreferences, CConsts, DateUtils, CDataObjects;

{$R *.dfm}

procedure TCStartupInfoForm.Action1Execute(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TCStartupInfoForm.Action2Execute(Sender: TObject);
begin
  ModalResult := mrOk;
end;

function TCStartupInfoForm.PrepareInfoFrame: Boolean;
begin
  FInfoFrame := TCStartupInfoFrame.Create(Self);
  FInfoFrame.Parent := Panel2;
  FInfoFrame.InitializeFrame(Self, Nil, Nil, Nil, False);
  FInfoFrame.Visible := True;
  Result := GBasePreferences.startupInfoAlways or (FInfoFrame.RepaymentList.RootNodeCount <> 0)
end;

end.

