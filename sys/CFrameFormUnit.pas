unit CFrameFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CConfigFormUnit, StdCtrls, Buttons, ExtCtrls, CBaseFrameUnit,
  CComponents;

type
  TCFrameFormClass = class of TCFrameForm;

  TCFrameForm = class(TCConfigForm)
    PanelFrame: TPanel;
  private
    FFrame: TCBaseFrame;
    FAdditionalData: TObject;
    FOutData: Pointer;
    FIsChoice: Boolean;
  protected
    procedure WndProc(var Message: TMessage); override;
    function GetSelectedId: String;
    function GetSelectedType: Integer;
  public
    constructor CreateFrame(AOwner: TComponent; AFrameClass: TCBaseFrameClass; AAdditionalData: TObject = Nil; AOutData: TObject = Nil; AMultipleCheck: TStringList = Nil; AIsChoice: Boolean = True; AWithButtons: Boolean = True); virtual;
    class function ShowFrame(AFrameClass: TCBaseFrameClass; var ADataId: String; var AText: String; AAdditionalData: Pointer = Nil; ARect: PRect = Nil; AOutData: Pointer = Nil; AMultipleCheck: TStringList = Nil; AIsChoice: Boolean = True; AFormClass: TCFrameFormClass = Nil; ABordered: Boolean = True): Boolean;
    destructor Destroy; override;
  published
    property IsChoice: Boolean read FIsChoice;
    property Frame: TCBaseFrame read FFrame;
  end;

implementation

uses CCashpointsFrameUnit, CDatabase, VirtualTrees, CConsts, CPluginConsts,
  CTools;

{$R *.dfm}

constructor TCFrameForm.CreateFrame(AOwner: TComponent; AFrameClass: TCBaseFrameClass; AAdditionalData: TObject = Nil; AOutData: TObject = Nil; AMultipleCheck: TStringList = Nil; AIsChoice: Boolean = True; AWithButtons: Boolean = True);
begin
  inherited Create(AOwner);
  FAdditionalData := AAdditionalData;
  FOutData := AOutData;
  FIsChoice := AIsChoice;
  FFrame := AFrameClass.Create(Self);
  FFrame.Visible := False;
  FFrame.DisableAlign;
  FFrame.InitializeFrame(Self, AAdditionalData, AOutData, AMultipleCheck, AWithButtons);
  if FFrame.GetList <> Nil then begin
    FFrame.GetList.TabStop := True;
  end;
  FFrame.PrepareCheckStates;
  FFrame.Parent := PanelFrame;
  FFrame.EnableAlign;
  FFrame.ShowFrame;
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

function TCFrameForm.GetSelectedId: String;
begin
  Result := '';
  if FFrame <> Nil then begin
    if FFrame.InheritsFrom(TCBaseFrame) then begin
      Result := TCBaseFrame(FFrame).SelectedId;
    end;
  end;
end;

function TCFrameForm.GetSelectedType: Integer;
begin
  Result := CSELECTEDITEM_INCORRECT;
  if FFrame <> Nil then begin
    if FFrame.InheritsFrom(TCBaseFrame) then begin
      Result := TCBaseFrame(FFrame).SelectedType;
    end;
  end;
end;

class function TCFrameForm.ShowFrame(AFrameClass: TCBaseFrameClass; var ADataId, AText: String; AAdditionalData: Pointer = Nil; ARect: PRect = Nil; AOutData: Pointer = Nil; AMultipleCheck: TStringList = Nil; AIsChoice: Boolean = True; AFormClass: TCFrameFormClass = Nil; ABordered: Boolean = True): Boolean;
var xForm: TCFrameForm;
    xFormClass: TCFrameFormClass;
begin
  if AFormClass = Nil then begin
    xFormClass := TCFrameForm;
  end else begin
    xFormClass := AFormClass;
  end;
  Result := False;
  xForm := xFormClass.CreateFrame(Nil, AFrameClass, AAdditionalData, AOutData, AMultipleCheck, AIsChoice);
  if (ADataId <> CEmptyDataGid) then begin
    xForm.FFrame.SelectedId := ADataId;
  end;
  if not ABordered then begin
    xForm.PanelFrame.BevelOuter := bvNone;
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

procedure TCFrameForm.WndProc(var Message: TMessage);
var xGid: TDataGid;
begin
  inherited WndProc(Message);
  if Message.Msg = WM_GETSELECTEDTYPE then begin
    Message.Result := GetSelectedType;
  end else if Message.Msg = WM_GETSELECTEDID then begin
    xGid := GetSelectedId;
    Message.Result := Integer(@xGid);
  end;
end;

end.
