unit CFrameFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, CBaseFrameUnit,
  CComponents;

type
  TCFrameForm = class(TCConfigForm)
    PanelFrame: TPanel;
  private
    FFrame: TCBaseFrame;
    FAdditionalData: TObject;
    FOutData: Pointer;
    FIsChoice: Boolean;
  public
    constructor CreateFrame(AOwner: TComponent; AFrameClass: TCBaseFrameClass; AAdditionalData: TObject = Nil; AOutData: TObject = Nil; AMultipleCheck: TStringList = Nil; AIsChoice: Boolean = True);
    class function ShowFrame(AFrameClass: TCBaseFrameClass; var ADataId: String; var AText: String; AAdditionalData: Pointer = Nil; ARect: PRect = Nil; AOutData: Pointer = Nil; AMultipleCheck: TStringList = Nil; AIsChoice: Boolean = True): Boolean;
    destructor Destroy; override;
  published
    property IsChoice: Boolean read FIsChoice;
  end;

implementation

uses CCashpointsFrameUnit, CDatabase, VirtualTrees, CConsts;

{$R *.dfm}

constructor TCFrameForm.CreateFrame(AOwner: TComponent; AFrameClass: TCBaseFrameClass; AAdditionalData: TObject = Nil; AOutData: TObject = Nil; AMultipleCheck: TStringList = Nil; AIsChoice: Boolean = True);
begin
  inherited Create(AOwner);
  FAdditionalData := AAdditionalData;
  FOutData := AOutData;
  FIsChoice := AIsChoice;
  FFrame := AFrameClass.Create(Self);
  FFrame.Visible := False;
  FFrame.DisableAlign;
  FFrame.InitializeFrame(Self, AAdditionalData, AOutData, AMultipleCheck);
  if FFrame.GetList <> Nil then begin
    FFrame.GetList.TabStop := True;
  end;
  FFrame.PrepareCheckStates;
  FFrame.Parent := PanelFrame;
  FFrame.EnableAlign;
  FFrame.Show;
  Caption := FFrame.GetTitle;
end;

destructor TCFrameForm.Destroy;
begin
  FreeAndNil(FFrame);
  if Assigned(FAdditionalData) then begin
    FAdditionalData.Free;
  end;
  inherited Destroy;
end;

class function TCFrameForm.ShowFrame(AFrameClass: TCBaseFrameClass; var ADataId, AText: String; AAdditionalData: Pointer = Nil; ARect: PRect = Nil; AOutData: Pointer = Nil; AMultipleCheck: TStringList = Nil; AIsChoice: Boolean = True): Boolean;
var xForm: TCFrameForm;
    xNode: PVirtualNode;
    xList: TCList;
begin
  Result := False;
  xForm := TCFrameForm.CreateFrame(Nil, AFrameClass, AAdditionalData, AOutData, AMultipleCheck, AIsChoice);
  xList := xForm.FFrame.List;
  if (ADataId <> CEmptyDataGid) and (xList <> Nil) then begin
    xNode := xForm.FFrame.FindNode(ADataId, xList);
    if xNode <> Nil then begin
      xList.FocusedNode := xNode;
      xList.Selected[xNode] := True;
    end;
  end;
  if ARect <> Nil then begin
    xForm.SetBounds(ARect^.Left, ARect^.Top, ARect^.Right, ARect^.Bottom);
  end;
  if xForm.ShowConfig(AFrameClass.GetOperation, True) then begin
    ADataId := xForm.FFrame.SelectedId;
    AText := xForm.FFrame.SelectedText;
    if (AOutData <> Nil) or (AMultipleCheck <> Nil) then begin
      xForm.FFrame.UpdateOutputData;
    end;
    Result := True;
  end;
  xForm.Free;
end;

end.
