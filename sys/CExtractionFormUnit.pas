unit CExtractionFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, CComponents,
  ComCtrls, ActnList, XPStyleActnCtrls, ActnMan, VirtualTrees;

type
  TCExtractionForm = class(TCDataobjectForm)
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label5: TLabel;
    CDateTime: TCDateTime;
    CStaticAccount: TCStatic;
    Label1: TLabel;
    ComboBoxState: TComboBox;
    Label2: TLabel;
    CDateTime1: TCDateTime;
    Label4: TLabel;
    CDateTime2: TCDateTime;
    ActionManager: TActionManager;
    ActionAdd: TAction;
    ActionTemplate: TAction;
    GroupBox2: TGroupBox;
    CButton1: TCButton;
    CButton2: TCButton;
    RichEditDesc: TCRichedit;
    ComboBoxTemplate: TComboBox;
    ActionManager1: TActionManager;
    Action1: TAction;
    Action2: TAction;
    Action3: TAction;
    GroupBox3: TGroupBox;
    Panel1: TPanel;
    Bevel1: TBevel;
    Panel2: TPanel;
    CButtonOut: TCButton;
    CButtonEdit: TCButton;
    CButtonDel: TCButton;
    List: TCList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
