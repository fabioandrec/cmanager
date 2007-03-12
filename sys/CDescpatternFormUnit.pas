unit CDescpatternFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, CComponents,
  ComCtrls, CPreferences, ActnList, XPStyleActnCtrls, ActnMan, ImgList,
  PngImageList, Menus, Contnrs, CImageListsUnit, CTemplates;

type
  TCDescpatternForm = class(TCConfigForm)
    GroupBox1: TGroupBox;
    Label5: TLabel;
    Label7: TLabel;
    ComboBoxOperation: TComboBox;
    ComboBoxType: TComboBox;
    GroupBox2: TGroupBox;
    RichEditDesc: TRichEdit;
    CButton1: TCButton;
    ActionManager: TActionManager;
    ActionAdd: TAction;
    procedure ComboBoxOperationChange(Sender: TObject);
    procedure ComboBoxTypeChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure RichEditDescChange(Sender: TObject);
    procedure ActionAddExecute(Sender: TObject);
  private
    FDescPatterns: TDescPatterns;
    FKeyName: String;
  protected
    procedure ReadValues; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

function EditDescPattern(AName: String; var APattern: String): Boolean;
function EditAddTemplate(ATemplates: TObjectList; AExpander: IDescTemplateExpander; ARiched: TRichEdit; AInserValue: Boolean): Boolean;

implementation

uses CConsts, CFrameFormUnit, CDescTemplatesFrameUnit, CRichtext;

{$R *.dfm}

procedure TCDescpatternForm.ComboBoxOperationChange(Sender: TObject);
var xCount: Integer;
begin
  ComboBoxType.Items.BeginUpdate;
  ComboBoxType.Items.Clear;
  for xCount := Low(CDescPatternsNames[ComboBoxOperation.ItemIndex]) to High(CDescPatternsNames[ComboBoxOperation.ItemIndex]) do begin
    if CDescPatternsNames[ComboBoxOperation.ItemIndex][xCount] <> '' then begin
      ComboBoxType.Items.Add(CDescPatternsNames[ComboBoxOperation.ItemIndex][xCount]);
    end;
  end;
  ComboBoxType.Items.EndUpdate;
  if ComboBoxType.Items.Count > 0 then begin
    ComboBoxType.ItemIndex := 0;
  end;
  ComboBoxTypeChange(Nil);
end;

procedure TCDescpatternForm.ComboBoxTypeChange(Sender: TObject);
begin
  AssignRichText(FDescPatterns.GetPattern(CDescPatternsKeys[ComboBoxOperation.ItemIndex][ComboBoxType.ItemIndex], ''), RichEditDesc);
end;

constructor TCDescpatternForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDescPatterns := TDescPatterns.Create(False);
  FDescPatterns.Text := GDescPatterns.Text;
  FKeyName := '';
end;

destructor TCDescpatternForm.Destroy;
begin
  FDescPatterns.Free;
  inherited Destroy;
end;

procedure TCDescpatternForm.FormShow(Sender: TObject);
var xO, xT: Integer;
begin
  inherited FormShow(Sender);
  if FKeyName <> '' then begin
    xO := GDescPatterns.GetPatternOperation(FKeyName);
    xT := GDescPatterns.GetPattetnType(FKeyName);
    if xO <> -1 then begin
      ComboBoxOperation.ItemIndex := xO;
    end;
    ComboBoxOperationChange(Nil);
    if xT <> -1 then begin
      ComboBoxType.ItemIndex := xT;
    end;
    ComboBoxTypeChange(Nil);
  end else begin
    ComboBoxOperationChange(Nil);
  end;
end;


procedure TCDescpatternForm.ReadValues;
var xCount: Integer;
    xName: String;
begin
  inherited ReadValues;
  for xCount := 0 to FDescPatterns.Count - 1 do begin
    xName := FDescPatterns.Names[xCount];
    GDescPatterns.SetPattern(xName, FDescPatterns.Values[xName]);
  end;
end;

function EditDescPattern(AName: String; var APattern: String): Boolean;
var xForm: TCDescpatternForm;
begin
  xForm := TCDescpatternForm.Create(Application);
  xForm.FKeyName := AName;
  Result := xForm.ShowConfig(coEdit);
  if Result then begin
    APattern := xForm.RichEditDesc.Text;
  end;
  xForm.Free;
end;

procedure TCDescpatternForm.RichEditDescChange(Sender: TObject);
begin
  FDescPatterns.SetPattern(CDescPatternsKeys[ComboBoxOperation.ItemIndex][ComboBoxType.ItemIndex], RichEditDesc.Text);
end;

procedure TCDescpatternForm.ActionAddExecute(Sender: TObject);
var xData: TObjectList;
begin
  xData := TObjectList.Create(False);
  xData.Add(GBaseTemlatesList);
  if ComboBoxOperation.ItemIndex = 0 then begin
    xData.Add(GBaseMovementTemplatesList);
  end else if ComboBoxOperation.ItemIndex = 1 then begin
    xData.Add(GMovementListTemplatesList);
  end else if ComboBoxOperation.ItemIndex = 2 then begin
    xData.Add(GPlannedMovementTemplatesList);
  end else if ComboBoxOperation.ItemIndex = 3 then begin
    xData.Add(GMovementListElementsTemplatesList);
  end;
  EditAddTemplate(xData, Self, RichEditDesc, False);
  xData.Free;
end;

function EditAddTemplate(ATemplates: TObjectList; AExpander: IDescTemplateExpander; ARiched: TRichEdit; AInserValue: Boolean): Boolean;
var xId, xText, xDesc: String;
    xSelStart, xSelLength: Integer;
    xData: TDescAdditionalData;
begin
  xData := TDescAdditionalData.Create(ATemplates);
  Result := TCFrameForm.ShowFrame(TCDescTemplatesFrame, xId, xText, xData);
  if Result then begin
    ARiched.Lines.BeginUpdate;
    xDesc := ARiched.Text;
    xSelStart := ARiched.SelStart + 1;
    xSelLength := ARiched.SelLength;
    System.Delete(xDesc, xSelStart, xSelLength);
    if AInserValue then begin
      xId := AExpander.ExpandTemplate(xId);
    end;
    xDesc := Copy(xDesc, 1, xSelStart - 1) + xId + Copy(xDesc, xSelStart, MaxInt);
    ARiched.Text := xDesc;
    ARiched.SelStart := xSelStart + Length(xId) - 1;
    ARiched.SelLength := 0;
    ARiched.Lines.EndUpdate
  end;
end;

end.
