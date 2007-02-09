unit CStartupInfoFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFormUnit, ExtCtrls, VirtualTrees, StdCtrls, CComponents,
  ActnList, XPStyleActnCtrls, ActnMan, ImgList, PngImageList;

type
  TCStartupInfoForm = class(TCBaseForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    PanelError: TPanel;
    RepaymentList: TVirtualStringTree;
    ActionManager1: TActionManager;
    Action1: TAction;
    Action2: TAction;
    CButton1: TCButton;
    CButton2: TCButton;
    PngImageList1: TPngImageList;
    procedure Action1Execute(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TCStartupInfoForm.Action1Execute(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TCStartupInfoForm.Action2Execute(Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
