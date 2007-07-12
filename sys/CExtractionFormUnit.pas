unit CExtractionFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, CComponents,
  ComCtrls, ActnList, XPStyleActnCtrls, ActnMan, VirtualTrees, Contnrs,
  CDatabase, CBaseFrameUnit;

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
    procedure CStaticAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticAccountChanged(Sender: TObject);
    procedure CDateTime1Changed(Sender: TObject);
    procedure CDateTime2Changed(Sender: TObject);
    procedure CDateTimeChanged(Sender: TObject);
    procedure ComboBoxStateChange(Sender: TObject);
    procedure ActionAddExecute(Sender: TObject);
    procedure ActionTemplateExecute(Sender: TObject);
  private
    procedure UpdateDescription;
  protected
    procedure InitializeForm; override;
    function CanAccept: Boolean; override;
    function GetDataobjectClass: TDataObjectClass; override;
    procedure FillForm; override;
    procedure ReadValues; override;
    function GetUpdateFrameClass: TCBaseFrameClass; override;
  public
  end;

implementation

uses CFrameFormUnit, CAccountsFrameUnit, CTemplates, CPreferences, CConsts,
  CRichtext, CDescpatternFormUnit, DateUtils, CInfoFormUnit, CDataObjects,
  Math, CConfigFormUnit, CExtractionsFrameUnit;

{$R *.dfm}

procedure TCExtractionForm.CStaticAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
begin
  AAccepted := TCFrameForm.ShowFrame(TCAccountsFrame, ADataGid, AText);
end;

procedure TCExtractionForm.CStaticAccountChanged(Sender: TObject);
begin
  UpdateDescription;
end;

procedure TCExtractionForm.UpdateDescription;
var xDesc: String;
begin
  if ComboBoxTemplate.ItemIndex = 1 then begin
    xDesc := GDescPatterns.GetPattern(CDescPatternsKeys[5][0], '');
    if xDesc <> '' then begin
      xDesc := GBaseTemlatesList.ExpandTemplates(xDesc, Self);
      xDesc := GAccountExtractionTemplatesList.ExpandTemplates(xDesc, Self);
      SimpleRichText(xDesc, RichEditDesc);
    end;
  end;
end;


procedure TCExtractionForm.InitializeForm;
begin
  inherited InitializeForm;
  CDateTime.Value := GWorkDate;
  CDateTime1.Value := StartOfTheMonth(GWorkDate);
  CDateTime2.Value := EndOfTheMonth(GWorkDate);
  UpdateDescription;
end;

procedure TCExtractionForm.CDateTime1Changed(Sender: TObject);
begin
  UpdateDescription;
end;

procedure TCExtractionForm.CDateTime2Changed(Sender: TObject);
begin
  UpdateDescription;
end;

procedure TCExtractionForm.CDateTimeChanged(Sender: TObject);
begin
  UpdateDescription;
end;

procedure TCExtractionForm.ComboBoxStateChange(Sender: TObject);
begin
  UpdateDescription;
end;

procedure TCExtractionForm.ActionAddExecute(Sender: TObject);
var xData: TObjectList;
begin
  xData := TObjectList.Create(False);
  xData.Add(GBaseTemlatesList);
  xData.Add(GAccountExtractionTemplatesList);
  EditAddTemplate(xData, Self, RichEditDesc, True);
  xData.Free;
end;

procedure TCExtractionForm.ActionTemplateExecute(Sender: TObject);
var xPattern: String;
begin
  if EditDescPattern(CDescPatternsKeys[5][0], xPattern) then begin
    UpdateDescription;
  end;
end;

function TCExtractionForm.CanAccept: Boolean;
begin
  Result := True;
  if CStaticAccount.DataId = CEmptyDataGid then begin
    Result := False;
    if ShowInfo(itQuestion, 'Nie wybrano konta z jakim bêdzie zwi¹zany wyci¹g. Czy wyœwietliæ listê teraz ?', '') then begin
      CStaticAccount.DoGetDataId;
    end;
  end;
end;

function TCExtractionForm.GetDataobjectClass: TDataObjectClass;
begin
  Result := TAccountExtraction;
end;

procedure TCExtractionForm.FillForm;
begin
  inherited FillForm;
  with TAccountExtraction(Dataobject) do begin
    ComboBoxTemplate.ItemIndex := IfThen(Operation = coEdit, 0, 1);
    GDataProvider.BeginTransaction;
    CStaticAccount.DataId := idAccount;
    CStaticAccount.Caption := TAccount(TAccount.LoadObject(AccountProxy, idAccount, False)).name;
    CDateTime.Value := regDate;
    CDateTime1.Value := startDate;
    CDateTime2.Value := endDate;
    SimpleRichText(description, RichEditDesc);
    if extractionState = CExtractionStateOpen then begin
      ComboBoxState.ItemIndex := 0;
    end else if extractionState = CExtractionStateClose then begin
      ComboBoxState.ItemIndex := 1;
    end else begin
      ComboBoxState.ItemIndex := 2;
    end;
    GDataProvider.RollbackTransaction;
  end;
end;

procedure TCExtractionForm.ReadValues;
begin
  inherited ReadValues;
  with TAccountExtraction(Dataobject) do begin
    description := RichEditDesc.Text;
    idAccount := CStaticAccount.DataId;
    regDate := CDateTime.Value;
    startDate := CDateTime1.Value;
    endDate := CDateTime2.Value;
    if ComboBoxState.ItemIndex = 0 then begin
      extractionState := CExtractionStateOpen;
    end else if ComboBoxState.ItemIndex = 1 then begin
      extractionState := CExtractionStateClose;
    end else begin
      extractionState := CExtractionStateStated;
    end;
  end;
end;

function TCExtractionForm.GetUpdateFrameClass: TCBaseFrameClass;
begin
  Result := TCExtractionsFrame;
end;

end.
