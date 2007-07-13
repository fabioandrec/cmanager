unit CExtractionFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CDataobjectFormUnit, StdCtrls, Buttons, ExtCtrls, CComponents,
  ComCtrls, ActnList, XPStyleActnCtrls, ActnMan, VirtualTrees, Contnrs,
  CDatabase, CBaseFrameUnit, CExtractionItemFormUnit;

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
    MovementList: TCList;
    procedure CStaticAccountGetDataId(var ADataGid, AText: String; var AAccepted: Boolean);
    procedure CStaticAccountChanged(Sender: TObject);
    procedure CDateTime1Changed(Sender: TObject);
    procedure CDateTime2Changed(Sender: TObject);
    procedure CDateTimeChanged(Sender: TObject);
    procedure ComboBoxStateChange(Sender: TObject);
    procedure ActionAddExecute(Sender: TObject);
    procedure ActionTemplateExecute(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
    procedure Action3Execute(Sender: TObject);
  private
    Fmovements: TObjectList;
    Fdeleted: TObjectList;
    Fmodified: TObjectList;
    Fadded: TObjectList;
    procedure UpdateDescription;
    procedure UpdateButtons;
    procedure MessageMovementAdded(AData: TExtractionListElement);
    procedure MessageMovementEdited(AData: TExtractionListElement);
    procedure MessageMovementDeleted(AData: TExtractionListElement);
    function FindNodeByData(AData: TExtractionListElement): PVirtualNode;
  protected
    procedure InitializeForm; override;
    function CanAccept: Boolean; override;
    function GetDataobjectClass: TDataObjectClass; override;
    procedure FillForm; override;
    procedure ReadValues; override;
    function GetUpdateFrameClass: TCBaseFrameClass; override;
    procedure WndProc(var Message: TMessage); override;
    procedure AfterCommitData; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
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
    UpdateButtons;
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

constructor TCExtractionForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Fadded := TObjectList.Create(False);
  Fmovements := TObjectList.Create(True);
  Fmodified := TObjectList.Create(False);
  Fdeleted := TObjectList.Create(True);
end;

destructor TCExtractionForm.Destroy;
begin
  Fadded.Free;
  Fdeleted.Free;
  Fmodified.Free;
  Fmovements.Free;
  inherited Destroy;
end;

procedure TCExtractionForm.Action1Execute(Sender: TObject);
var xForm: TCExtractionItemForm;
    xElement: TExtractionListElement;
begin
  if CStaticAccount.DataId = CEmptyDataGid then begin
    if ShowInfo(itQuestion, 'Nie wybrano konta dotycz¹cego wyci¹gu. Czy wyœwietliæ listê teraz ?', '') then begin
      CStaticAccount.DoGetDataId;
    end;
  end else begin
    xElement := TExtractionListElement.Create;
    xElement.isNew := True;
    xElement.movementType := CInMovement;
    xElement.idAccount := CStaticAccount.DataId;
    xElement.idCurrencyDef := CCurrencyDefGid_PLN;
    xElement.regTime := GWorkDate;
    xForm := TCExtractionItemForm.CreateFormElement(Application, xElement);
    if xForm.ShowConfig(coAdd) then begin
      Perform(WM_DATAOBJECTADDED, Integer(xElement), 0);
      UpdateButtons;
    end else begin
      xElement.Free;
    end;
    xForm.Free;
  end;
end;

procedure TCExtractionForm.UpdateButtons;
begin
end;

procedure TCExtractionForm.Action2Execute(Sender: TObject);
var xForm: TCExtractionItemForm;
    xElement: TExtractionListElement;
begin
  if MovementList.FocusedNode <> Nil then begin
    xElement := TExtractionListElement(MovementList.GetNodeData(MovementList.FocusedNode)^);
    xForm := TCExtractionItemForm.CreateFormElement(Application, xElement);
    if xForm.ShowConfig(coEdit) then begin
      Perform(WM_DATAOBJECTEDITED, Integer(xElement), 0);
      UpdateButtons;
    end;
    xForm.Free;
  end;
end;

procedure TCExtractionForm.Action3Execute(Sender: TObject);
var xElement: TExtractionListElement;
begin
  if ShowInfo(itQuestion, 'Czy chcesz usun¹æ wybran¹ operacjê ?', '') then begin
    xElement := TExtractionListElement(MovementList.GetNodeData(MovementList.FocusedNode)^);
    Perform(WM_DATAOBJECTDELETED, Integer(xElement), 0);
    UpdateButtons;
  end;
end;

procedure TCExtractionForm.MessageMovementAdded(AData: TExtractionListElement);
var xNode: PVirtualNode;
begin
  Fmovements.Add(AData);
  Fadded.Add(AData);
  xNode := MovementList.AddChild(Nil, AData);
  MovementList.Sort(xNode, MovementList.Header.SortColumn, MovementList.Header.SortDirection);
  MovementList.FocusedNode := xNode;
  MovementList.Selected[xNode] := True;
end;

procedure TCExtractionForm.MessageMovementDeleted(AData: TExtractionListElement);
var xNode: PVirtualNode;
    xData: TExtractionListElement;
begin
  xNode := FindNodeByData(AData);
  if xNode <> Nil then begin
    MovementList.BeginUpdate;
    if Fmodified.IndexOf(AData) <> -1 then begin
      Fmodified.Remove(AData);
    end;
    if Fadded.IndexOf(AData) <> -1 then begin
      Fadded.Remove(AData);
    end;
    xData := TExtractionListElement(Fmovements.Extract(AData));
    if not xData.isNew then begin
      Fdeleted.Add(xData);
    end;
    MovementList.DeleteNode(xNode);
    MovementList.EndUpdate;
  end;
end;

procedure TCExtractionForm.MessageMovementEdited(AData: TExtractionListElement);
var xNode:  PVirtualNode;
begin
  if (Fmodified.IndexOf(AData) = -1) and (Fadded.IndexOf(AData) = -1) then begin
    Fmodified.Add(AData);
  end;
  xNode := FindNodeByData(AData);
  MovementList.InvalidateNode(xNode);
  MovementList.Sort(xNode, MovementList.Header.SortColumn, MovementList.Header.SortDirection);
end;

function TCExtractionForm.FindNodeByData(AData: TExtractionListElement): PVirtualNode;
var xCurNode: PVirtualNode;
begin
  Result := Nil;
  xCurNode := MovementList.GetFirst;
  while (xCurNode <> Nil) and (Result = Nil) do begin
    if TExtractionListElement(MovementList.GetNodeData(xCurNode)^) = AData then begin
      Result := xCurNode;
    end else begin
      xCurNode := MovementList.GetNextSibling(xCurNode);
    end;
  end;
end;

procedure TCExtractionForm.WndProc(var Message: TMessage);
var xData: TExtractionListElement;
begin
  inherited WndProc(Message);
  with Message do begin
    if Msg = WM_DATAOBJECTADDED then begin
      xData := TExtractionListElement(WParam);
      MessageMovementAdded(xData);
    end else if Msg = WM_DATAOBJECTEDITED then begin
      xData := TExtractionListElement(WParam);
      MessageMovementEdited(xData);
    end else if Msg = WM_DATAOBJECTDELETED then begin
      xData := TExtractionListElement(WParam);
      MessageMovementDeleted(xData);
    end;
  end;
end;

procedure TCExtractionForm.AfterCommitData;
var xCount: Integer;
    xItem: TExtractionItem;
begin
  inherited AfterCommitData;
  GDataProvider.BeginTransaction;
  for xCount := 0 to Fadded.Count - 1 do begin
    with TExtractionListElement(Fadded.Items[xCount]) do begin
      xItem := TExtractionItem.CreateObject(ExtractionItemProxy, False);
      xItem.id := id;
      xItem.description := description;
      xItem.cash := cash;
      xItem.movementType := movementType;
      xItem.regDate := regTime;
      xItem.idCurrencyDef := idCurrencyDef;
      xItem.idAccountExtraction := Dataobject.id;
    end;
  end;
  for xCount := 0 to Fmodified.Count - 1 do begin
    with TExtractionListElement(Fmodified.Items[xCount]) do begin
      xItem := TExtractionItem(TExtractionItem.LoadObject(ExtractionItemProxy, id, False));
      xItem.description := description;
      xItem.cash := cash;
      xItem.movementType := movementType;
      xItem.regDate := regTime;
      xItem.idCurrencyDef := idCurrencyDef;
    end;
  end;
  for xCount := 0 to Fdeleted.Count - 1 do begin
    with TExtractionListElement(Fdeleted.Items[xCount]) do begin
      xItem := TExtractionItem(TExtractionItem.LoadObject(ExtractionItemProxy, id, False));
      xItem.DeleteObject;
    end;
  end;
  GDataProvider.CommitTransaction;
end;

end.
