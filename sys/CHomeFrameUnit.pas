unit CHomeFrameUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, CBaseFrameUnit, ImgList, PngImageList, ExtCtrls, StdCtrls,
  pngimage, ActnList, CComponents, Menus;

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
    Image2: TImage;
    Label2: TLabel;
    ActionSetProfile: TAction;
    CButton5: TCButton;
    CButton6: TCButton;
    ActionStartupInfo: TAction;
    CButton7: TCButton;
    ActionAddNewList: TAction;
    procedure ActionNewOperationExecute(Sender: TObject);
    procedure ActionNewCyclicExecute(Sender: TObject);
    procedure ActionPreferencesExecute(Sender: TObject);
    procedure ActionSetProfileExecute(Sender: TObject);
    procedure ActionOperationsListExecute(Sender: TObject);
    procedure ActionStartupInfoExecute(Sender: TObject);
    procedure ActionAddNewListExecute(Sender: TObject);
  private
  public
    constructor Create(AOwner: TComponent); override;
    procedure ShowFrame; override;
    procedure HideFrame; override;
  end;

implementation

uses CMovementFormUnit, CDatabase, CConfigFormUnit, CDataObjects, CConsts,
  CMovementFrameUnit, CPlannedFormUnit, CPlannedFrameUnit,
  CPreferencesFormUnit, CFrameFormUnit, CProfileFrameUnit, CReports,
  CStartupInfoFrameUnit, CMovementListFormUnit, CDescpatternFormUnit;

{$R *.dfm}

constructor TCHomeFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Label1.Caption := Label1.Caption + ' - ' + FormatDateTime('dd MMMM yyyy', Now);
end;

procedure TCHomeFrame.ActionNewOperationExecute(Sender: TObject);
var xForm: TCMovementForm;
begin
  xForm := TCMovementForm.Create(Nil);
  xForm.ShowDataobject(coAdd, BaseMovementProxy, Nil, True);
  xForm.Free;
end;

procedure TCHomeFrame.ActionNewCyclicExecute(Sender: TObject);
var xForm: TCPlannedForm;
begin
  xForm := TCPlannedForm.Create(Nil);
  xForm.ShowDataobject(coAdd, PlannedMovementProxy, Nil, True);
  xForm.Free;
end;

procedure TCHomeFrame.ActionPreferencesExecute(Sender: TObject);
var xPrefs: TCPreferencesForm;
begin
  xPrefs := TCPreferencesForm.Create(Nil);
  xPrefs.ShowPreferences;
  xPrefs.Free;
end;

procedure TCHomeFrame.ActionSetProfileExecute(Sender: TObject);
var xText: String;
    xProfileId: String;
    xMark: TProfile;
begin
  xProfileId := GActiveProfileId;
  xMark := TProfile.Create(True);
  xMark.id := CEmptyDataGid;
  xMark.name := '<usuñ aktywny profil>';
  if TCFrameForm.ShowFrame(TCProfileFrame, xProfileId, xText, xMark) then begin
    GActiveProfileId := xProfileId;
  end;
end;

procedure TCHomeFrame.ActionOperationsListExecute(Sender: TObject);
var xRep: TTodayOperationsListReport;
begin
  xRep := TTodayOperationsListReport.CreateReport(Nil);
  xRep.ShowReport;
  xRep.Free;
end;

procedure TCHomeFrame.ActionStartupInfoExecute(Sender: TObject);
var xData, xText: String;
begin
  TCFrameForm.ShowFrame(TCStartupInfoFrame, xData, xText);
end;

procedure TCHomeFrame.ActionAddNewListExecute(Sender: TObject);
var xForm: TCMovementListForm;
begin
  xForm := TCMovementListForm.Create(Nil);
  xForm.ShowDataobject(coAdd, MovementListProxy, Nil, True);
  xForm.Free;
end;

procedure TCHomeFrame.HideFrame;
begin
  inherited HideFrame;
  ActionNewOperation.ShortCut := 0;
  ActionAddNewList.ShortCut := 0;
end;

procedure TCHomeFrame.ShowFrame;
begin
  inherited ShowFrame;
  ActionNewOperation.ShortCut := ShortCut(Word('N'), [ssCtrl]);
  ActionAddNewList.ShortCut := ShortCut(Word('L'), [ssCtrl]);
end;

end.
