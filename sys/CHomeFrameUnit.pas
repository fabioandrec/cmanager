unit CHomeFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, ImgList, PngImageList, ExtCtrls, StdCtrls,
  pngimage, ActnList, CComponents;

type
  TCHomeFrame = class(TCBaseFrame)
    Image1: TImage;
    Label1: TLabel;
    CButton1: TCButton;
    ActionListSimple: TActionList;
    ActionNewOperation: TAction;
    ActionNewCyclic: TAction;
    CButton2: TCButton;
    ActionOperationsList: TAction;
    CButton3: TCButton;
    ActionPreferences: TAction;
    CButton4: TCButton;
    procedure ActionNewOperationExecute(Sender: TObject);
    procedure ActionNewCyclicExecute(Sender: TObject);
    procedure ActionPreferencesExecute(Sender: TObject);
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

uses CMovementFormUnit, CDatabase, CConfigFormUnit, CDataObjects, CConsts,
  CMovementFrameUnit, CPlannedFormUnit, CPlannedFrameUnit,
  CPreferencesFormUnit;

{$R *.dfm}

constructor TCHomeFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Label1.Caption := Label1.Caption + ' (' + FormatDateTime('dd MMMM yyyy', Now) + ')';
end;

procedure TCHomeFrame.ActionNewOperationExecute(Sender: TObject);
var xForm: TCMovementForm;
    xDataGid: TDataGid;
begin
  xForm := TCMovementForm.Create(Nil);
  xDataGid := xForm.ShowDataobject(coAdd, BaseMovementProxy, Nil, True);
  if xDataGid <> CEmptyDataGid then begin
    SendMessageToFrames(TCMovementFrame, WM_DATAOBJECTADDED, Integer(@xDataGid), 0);
  end;
  xForm.Free;
end;

procedure TCHomeFrame.ActionNewCyclicExecute(Sender: TObject);
var xForm: TCPlannedForm;
    xDataGid: TDataGid;
begin
  xForm := TCPlannedForm.Create(Nil);
  xDataGid := xForm.ShowDataobject(coAdd, PlannedMovementProxy, Nil, True);
  if xDataGid <> CEmptyDataGid then begin
    SendMessageToFrames(TCPlannedFrame, WM_DATAOBJECTADDED, Integer(@xDataGid), 0);
  end;
  xForm.Free;
end;

procedure TCHomeFrame.ActionPreferencesExecute(Sender: TObject);
var xPrefs: TCPreferencesForm;
begin
  xPrefs := TCPreferencesForm.Create(Nil);
  xPrefs.ShowPreferences;
  xPrefs.Free;
end;

end.
