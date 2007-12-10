unit CInvestmentMovementFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, CComponents,
  ComCtrls, ActnList, XPStyleActnCtrls, ActnMan;

type
  TCInvestmentMovementForm = class(TCDataobjectForm)
    GroupBox1: TGroupBox;
    Label5: TLabel;
    ComboBoxType: TComboBox;
    Label3: TLabel;
    CDateTime: TCDateTime;
    ActionManager: TActionManager;
    ActionAdd: TAction;
    ActionTemplate: TAction;
    GroupBox2: TGroupBox;
    CButton1: TCButton;
    CButton2: TCButton;
    RichEditDesc: TCRichedit;
    ComboBoxTemplate: TComboBox;
    GroupBox3: TGroupBox;
    Label4: TLabel;
    CStaticAccount: TCStatic;
    Label1: TLabel;
    CStaticInstrument: TCStatic;
    Label15: TLabel;
    CCurrEditOnceQuantity: TCCurrEdit;
    Label2: TLabel;
    CStatic1: TCStatic;
    Label6: TLabel;
    CCurrEditValue: TCCurrEdit;
    Label9: TLabel;
    CCurrEditInoutOnceMovement: TCCurrEdit;
    Label8: TLabel;
    CStaticInoutOnceCategory: TCStatic;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
 