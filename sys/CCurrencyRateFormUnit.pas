unit CCurrencyRateFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, CComponents,
  ActnList, XPStyleActnCtrls, ActnMan, ComCtrls;

type
  TCCurrencyRateForm = class(TCDataobjectForm)
    GroupBox4: TGroupBox;
    Label15: TLabel;
    CDateTime1: TCDateTime;
    GroupBox2: TGroupBox;
    CButton1: TCButton;
    CButton2: TCButton;
    RichEditDesc: TRichEdit;
    ComboBoxTemplate: TComboBox;
    ActionManager: TActionManager;
    ActionAdd: TAction;
    ActionTemplate: TAction;
    Label2: TLabel;
    CStaticInoutOnceCashpoint: TCStatic;
    CIntEditTimes: TCIntEdit;
    CStaticInoutOnceAccount: TCStatic;
    CStatic1: TCStatic;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
 