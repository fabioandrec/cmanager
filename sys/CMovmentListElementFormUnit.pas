unit CMovmentListElementFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  CComponents;

type
  TCMovmentListElementForm = class(TCConfigForm)
    GroupBox2: TGroupBox;
    RichEditDesc: TRichEdit;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    Label9: TLabel;
    CStaticCategory: TCStatic;
    CCurrEdit: TCCurrEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
 