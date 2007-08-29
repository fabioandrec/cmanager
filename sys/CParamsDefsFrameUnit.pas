unit CParamsDefsFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, Menus, ImgList, PngImageList, ExtCtrls,
  VirtualTrees, CComponents, VTHeaderPopup, ActnList, CImageListsUnit, ActiveX;

type
  TCParamsDefsFrame = class(TCBaseFrame)
    ActionListButtons: TActionList;
    ActionAdd: TAction;
    ActionEdit: TAction;
    ActionDelete: TAction;
    VTHeaderPopupMenu: TVTHeaderPopupMenu;
    List: TCDataList;
    ButtonPanel: TPanel;
    CButtonAdd: TCButton;
    CButtonEdit: TCButton;
    CButtonDelete: TCButton;
    CButtonHistory: TCButton;
    Bevel: TBevel;
    ActionPreview: TAction;
    procedure ListCDataListReloadTree(Sender: TCDataList; ARootElement: TCListDataElement);
    procedure ActionAddExecute(Sender: TObject);
    procedure ActionEditExecute(Sender: TObject);
    procedure ActionDeleteExecute(Sender: TObject);
    procedure ListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
    procedure ActionPreviewExecute(Sender: TObject);
    procedure ListDragOver(Sender: TBaseVirtualTree; Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
    procedure ListDragDrop(Sender: TBaseVirtualTree; Source: TObject; DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
  protected
    procedure UpdateButtons(AIsSelectedSomething: Boolean); override;
  public
    function GetList: TCList; override;
    procedure InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean); override;
    function MustFreeAdditionalData: Boolean; override;
  end;

implementation

uses CReports, CParamDefFormUnit, CConfigFormUnit, CInfoFormUnit,
  CChooseByParamsDefsFormUnit;

{$R *.dfm}

function TCParamsDefsFrame.GetList: TCList;
begin
  Result := List;
end;

procedure TCParamsDefsFrame.InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean);
begin
  inherited InitializeFrame(AOwner, AAdditionalData, AOutputData, AMultipleCheck, AWithButtons);
  CButtonHistory.Width := CButtonHistory.Canvas.TextWidth(ActionPreview.Caption) + CButtonHistory.PicOffset + ActionListButtons.Images.Width + 10;
  CButtonHistory.Left := ButtonPanel.Width - CButtonHistory.Width - 15;
  CButtonHistory.Anchors := [akTop, akRight];
  List.ReloadTree;
  UpdateButtons(List.FocusedNode <> Nil);
end;

function TCParamsDefsFrame.MustFreeAdditionalData: Boolean;
begin
  Result := False;
end;

procedure TCParamsDefsFrame.ListCDataListReloadTree(Sender: TCDataList; ARootElement: TCListDataElement);
var xDefs: TReportDialogParamsDefs;
    xCount: Integer;
begin
  xDefs := TReportDialogParamsDefs(AdditionalData);
  for xCount := 0 to xDefs.Count - 1 do begin
    ARootElement.AppendDataElement(TCListDataElement.Create(False, List, xDefs.Items[xCount]));
  end;
end;

procedure TCParamsDefsFrame.ActionAddExecute(Sender: TObject);
var xForm: TCParamDefForm;
    xParam: TReportDialgoParamDef;
begin
  xForm := TCParamDefForm.Create(Nil);
  xParam := TReportDialgoParamDef.Create(TReportDialogParamsDefs(AdditionalData));
  xForm.paramDef := xParam;
  if xForm.ShowConfig(coEdit) then begin
    TReportDialogParamsDefs(AdditionalData).AddParam(xParam);
    List.RootElement.AppendDataElement(TCListDataElement.Create(False, List, xParam));
  end else begin
    xParam.Free;
  end;
  xForm.Free;
end;

procedure TCParamsDefsFrame.ActionEditExecute(Sender: TObject);
var xForm: TCParamDefForm;
    xParam: TReportDialgoParamDef;
begin
  xForm := TCParamDefForm.Create(Nil);
  xParam := TReportDialgoParamDef(List.SelectedElement.Data);
  xForm.paramDef := xParam;
  if xForm.ShowConfig(coEdit) then begin
    List.RepaintNode(List.SelectedElement.Node);
  end;
  xForm.Free;
end;

procedure TCParamsDefsFrame.ActionDeleteExecute(Sender: TObject);
var xParam: TReportDialgoParamDef;
begin
  xParam := TReportDialgoParamDef(List.SelectedElement.Data);
  if ShowInfo(itQuestion, 'Czy chcesz usun¹æ parametr o nazwie "' + xParam.GetElementText + '" ?', '') then begin
    List.RootElement.DeleteDataElement(xParam.name);
    TReportDialogParamsDefs(AdditionalData).RemoveParam(xParam);
  end;
end;

procedure TCParamsDefsFrame.UpdateButtons(AIsSelectedSomething: Boolean);
begin
  inherited UpdateButtons(AIsSelectedSomething);
  ActionEdit.Enabled := AIsSelectedSomething;
  ActionDelete.Enabled := AIsSelectedSomething;
end;

procedure TCParamsDefsFrame.ListFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex);
begin
  UpdateButtons(Node <> Nil);
end;

procedure TCParamsDefsFrame.ActionPreviewExecute(Sender: TObject);
var xParams: TReportDialogParamsDefs;
begin
  xParams := TReportDialogParamsDefs(AdditionalData);
  if xParams.Count = 0 then begin
    ShowInfo(itInfo, 'Brak zdefiniowanych parametrów raportu, formatka przyk³adowa nie zostanie wyœwietlona.\nPrzy uruchomieniu ' +
                     'raportu CManager przejdzie od razu do przygotowania i wyœwietlenia raportu', '');
  end else begin
    ChooseByParamsDefs(xParams);
  end;
end;

procedure TCParamsDefsFrame.ListDragOver(Sender: TBaseVirtualTree; Source: TObject; Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode; var Effect: Integer; var Accept: Boolean);
begin
  Accept := (Sender = Source);
end;

procedure TCParamsDefsFrame.ListDragDrop(Sender: TBaseVirtualTree; Source: TObject; DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState; Pt: TPoint; var Effect: Integer; Mode: TDropMode);
var xAttachmode: TVTNodeAttachMode;
    xNodes: TNodeArray;
    xCount: Integer;
    xDefs: TReportDialogParamsDefs;
    xData: TCListDataElement;
    xCurIndex, xNewIndex: Integer;
begin
  if DataObject = Nil then begin
    case Mode of
      dmAbove: xAttachMode := amInsertBefore;
      dmOnNode: xAttachMode := amInsertAfter;
      dmBelow: xAttachMode := amInsertAfter;
      else xAttachMode := amNowhere;
    end;
    xNodes := List.GetSortedSelection(True);
    xDefs := TReportDialogParamsDefs(AdditionalData);
    for xCount := 0 to High(xNodes) do begin
      List.MoveTo(xNodes[xCount], Sender.DropTargetNode, xAttachMode, False);
      xData := TCListDataElement(List.GetNodeData(xNodes[xCount])^);
      xCurIndex := xDefs.IndexOf(xData.Data);
      xNewIndex := xNodes[xCount].Index;
      if (xCurIndex > -1) and (xNewIndex > -1) then begin
        xDefs.Move(xCurIndex, xNewIndex);
      end;
    end;
  end;
end;

end.
