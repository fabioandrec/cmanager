unit CDepositInvestmentFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  CComponents, CDatabase, CBaseFrameUnit, ActnList, ActnMan, CImageListsUnit,
  Contnrs, CDataObjects, XPStyleActnCtrls;

type
  TCDepositInvestmentForm = class(TCDataobjectForm)
    GroupBox1: TGroupBox;
    Label3: TLabel;
    GroupBox2: TGroupBox;
    RichEditDesc: TCRichEdit;
    GroupBox3: TGroupBox;
    ActionManager: TActionManager;
    ActionAdd: TAction;
    CButton1: TCButton;
    ActionTemplate: TAction;
    CButton2: TCButton;
    ComboBoxTemplate: TComboBox;
    CDateTime: TCDateTime;
    Label5: TLabel;
    ComboBoxStatus: TComboBox;
    Label14: TLabel;
    CStaticAccount: TCStatic;
    Label1: TLabel;
    CStaticCashpoint: TCStatic;
    Label2: TLabel;
    EditName: TEdit;
    Label10: TLabel;
    CStaticCurrency: TCStatic;
    Label18: TLabel;
    CCurrEditCapital: TCCurrEdit;
    Label4: TLabel;
    CCurrEditRate: TCCurrEdit;
    Label6: TLabel;
    CIntEditPeriodCount: TCIntEdit;
    ComboBoxPeriodType: TComboBox;
    ComboBoxPeriodAction: TComboBox;
    Label7: TLabel;
    Label8: TLabel;
    ComboBoxDueMode: TComboBox;
    Label9: TLabel;
    CIntEditDueCount: TCIntEdit;
    ComboBoxDueType: TComboBox;
    Label11: TLabel;
    ComboBoxDueAction: TComboBox;
  protected
  public
  end;

implementation

{$R *.dfm}

end.
