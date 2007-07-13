unit CExtractionItemFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, CDataObjects, CDatabase,
  ComCtrls, CComponents, ActnList, XPStyleActnCtrls, ActnMan;

type
  TExtractionListElement = class(TObject)
  private
    FIsNew: Boolean;
    Fid: TDataGid;
    FmovementType: TBaseEnumeration;
    Fdescription: TBaseDescription;
    Fcash: Currency;
    FidAccount: TDataGid;
    FregTime: TDateTime;
    FidCurrencyDef: TDataGid;
  public
    constructor Create;
  published
    property id: TDataGid read Fid write Fid;
    property movementType: TBaseEnumeration read FmovementType write FmovementType;
    property description: TBaseDescription read Fdescription write Fdescription;
    property cash: Currency read Fcash write Fcash;
    property idCurrencyDef: TDataGid read FidCurrencyDef write FidCurrencyDef;
    property idAccount: TDataGid read FidAccount write FidAccount;
    property isNew: Boolean read FIsNew write FIsNew;
    property regTime: TDateTime read FregTime write FregTime;
  end;

  TCExtractionItemForm = class(TCConfigForm)
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label5: TLabel;
    ComboBoxType: TComboBox;
    CDateTime: TCDateTime;
    GroupBox2: TGroupBox;
    CButton1: TCButton;
    CButton2: TCButton;
    RichEditDesc: TCRichedit;
    ComboBoxTemplate: TComboBox;
    ActionManager: TActionManager;
    ActionAdd: TAction;
    ActionTemplate: TAction;
    Label20: TLabel;
    CStaticMovementCurrency: TCStatic;
    Label1: TLabel;
    CCurrEditMovement: TCCurrEdit;
  private
    Felement: TExtractionListElement;
  public
    constructor CreateFormElement(AOwner: TComponent; AElement: TExtractionListElement);
  end;

implementation

{$R *.dfm}

constructor TExtractionListElement.Create;
var xGuid: TGUID;
begin
  inherited Create;
  FIsNew := False;
  CreateGUID(xGuid);
  Fid := GUIDToString(xGuid);
end;

constructor TCExtractionItemForm.CreateFormElement(AOwner: TComponent; AElement: TExtractionListElement);
begin
  inherited Create(AOwner);
  Felement := AElement;
end;

end.
