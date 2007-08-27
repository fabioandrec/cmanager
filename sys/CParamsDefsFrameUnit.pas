unit CParamsDefsFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, Menus, ImgList, PngImageList, ExtCtrls,
  VirtualTrees, CComponents, VTHeaderPopup, ActnList, CImageListsUnit;

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
  private
  public
    function GetList: TCList; override;
    procedure InitializeFrame(AOwner: TComponent; AAdditionalData: TObject; AOutputData: Pointer; AMultipleCheck: TStringList; AWithButtons: Boolean); override;
    function MustFreeAdditionalData: Boolean; override;
  end;

implementation

uses CReports, CParamDefFormUnit, CConfigFormUnit, CInfoFormUnit;

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
    ARootElement.AppendDataElement(TCListDataElement.Create(List, xDefs.Items[xCount]));
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
    List.RootElement.AppendDataElement(TCListDataElement.Create(List, xParam));
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

end.
