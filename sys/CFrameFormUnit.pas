unit CFrameFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, CBaseFrameUnit;

type
  TCFrameForm = class(TCConfigForm)
    PanelFrame: TPanel;
  private
    FFrame: TCBaseFrame;
    FAdditionalData: TObject;
  public
    constructor CreateFrame(AOwner: TComponent; AFrameClass: TCBaseFrameClass; AAdditionalData: TObject = Nil);
    class function ShowFrame(AFrameClass: TCBaseFrameClass; var ADataId: String; var AText: String; AAdditionalData: Pointer = Nil; ARect: PRect = Nil): Boolean;
    destructor Destroy; override;
  end;

implementation

uses CCashpointsFrameUnit, CDatabase, VirtualTrees;

{$R *.dfm}

constructor TCFrameForm.CreateFrame(AOwner: TComponent; AFrameClass: TCBaseFrameClass; AAdditionalData: TObject = Nil);
begin
  inherited Create(AOwner);
  FAdditionalData := AAdditionalData;
  FFrame := AFrameClass.Create(Self);
  FFrame.Visible := False;
  FFrame.DisableAlign;
  FFrame.InitializeFrame(AAdditionalData);
  FFrame.Parent := PanelFrame;
  FFrame.EnableAlign;
  FFrame.Show;
  Caption := FFrame.GetTitle;
end;

destructor TCFrameForm.Destroy;
begin
  if Assigned(FAdditionalData) then begin
    FAdditionalData.Free;
  end;
  inherited Destroy;
end;

class function TCFrameForm.ShowFrame(AFrameClass: TCBaseFrameClass; var ADataId, AText: String; AAdditionalData: Pointer = Nil; ARect: PRect = Nil): Boolean;
var xForm: TCFrameForm;
    xNode: PVirtualNode;
    xList: TVirtualStringTree;
begin
  Result := False;
  xForm := TCFrameForm.CreateFrame(Application, AFrameClass, AAdditionalData);
  xList := xForm.FFrame.List;
  if (ADataId <> CEmptyDataGid) and (xList <> Nil) then begin
    xNode := FindDataobjectNode(ADataId, xList);
    if xNode <> Nil then begin
      xList.FocusedNode := xNode;
      xList.Selected[xNode] := True;
    end;
  end;
  if ARect <> Nil then begin
    xForm.SetBounds(ARect^.Left, ARect^.Top, ARect^.Right, ARect^.Bottom);
  end;
  if xForm.ShowConfig(coEdit) then begin
    ADataId := xForm.FFrame.SelectedId;
    AText := xForm.FFrame.SelectedText;
    Result := True;
  end;
  xForm.Free;
end;

end.
