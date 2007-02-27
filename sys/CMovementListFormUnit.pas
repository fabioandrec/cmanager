unit CMovementListFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, CComponents,
  ComCtrls, VirtualTrees, ActnList, XPStyleActnCtrls, ActnMan;

type
  TCMovementListForm = class(TCDataobjectForm)
    GroupBox4: TGroupBox;
    Label15: TLabel;
    Label16: TLabel;
    CDateTime1: TCDateTime;
    ComboBox1: TComboBox;
    GroupBox2: TGroupBox;
    RichEditDesc: TRichEdit;
    Label4: TLabel;
    CStaticInoutOnceAccount: TCStatic;
    Label2: TLabel;
    CStaticInoutOnceCashpoint: TCStatic;
    ActionManager1: TActionManager;
    Action1: TAction;
    Action2: TAction;
    Action3: TAction;
    GroupBox1: TGroupBox;
    Panel1: TPanel;
    Bevel1: TBevel;
    Panel2: TPanel;
    CButtonOut: TCButton;
    CButtonEdit: TCButton;
    CButtonDel: TCButton;
    TodayList: TVirtualStringTree;
    procedure CStaticInoutOnceAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticInoutOnceCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses CFrameFormUnit, CAccountsFrameUnit, CCashpointsFrameUnit;

{$R *.dfm}

procedure TCMovementListForm.CStaticInoutOnceAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCAccountsFrame, ADataGid, AText);
end;

procedure TCMovementListForm.CStaticInoutOnceCashpointGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCCashpointsFrame, ADataGid, AText);
end;

end.
 