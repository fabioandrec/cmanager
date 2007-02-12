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
    procedure FormShow(Sender: TObject);
  private
    procedure ReloadInfoTree;
  end;

implementation

uses CPreferences;

{$R *.dfm}

procedure TCStartupInfoForm.Action1Execute(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TCStartupInfoForm.Action2Execute(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TCStartupInfoForm.FormShow(Sender: TObject);
begin
  inherited;
  ReloadInfoTree;
end;

procedure TCStartupInfoForm.ReloadInfoTree;
begin
  RepaymentList.BeginUpdate;
  RepaymentList.Clear;
  RepaymentList.EndUpdate;
  PanelError.Visible := RepaymentList.RootNodeCount = 0;
end;

end.
