unit CSchedules;

interface

uses CDataObjects, Contnrs, CDatabase, SysUtils, Math;

type
  TPlannedTreeItem = class(TObject)
  private
    FPlanned: TPlannedMovement;
    FDone: TPlannedDone;
    FtriggerDate: TDateTime;
  public
    constructor Create(APlanned: TPlannedMovement; ADone: TPlannedDone; ATriggerDate: TDateTime);
  published
    property planned: TPlannedMovement read FPlanned write FPlanned;
    property done: TPlannedDone read FDone write FDone;
    property triggerDate: TDateTime read FtriggerDate write FtriggerDate;
  end;

  TScheduledObjectStates = (sosPlanned, sosDone, sosBoth);

function SortTreeHelperByDate(Item1, Item2: Pointer): Integer;
procedure GetScheduledObjects(AList: TObjectList; APlannedObjects, ADoneObjects: TDataObjectList; ADateFrom, ADateTo: TDateTime; AScheduledObjectStates: TScheduledObjectStates);

implementation

uses DateUtils, CConsts;

function SortTreeHelperByDate(Item1, Item2: Pointer): Integer;
var xI1, xI2: TPlannedTreeItem;
begin
  xI1 := TPlannedTreeItem(Item1);
  xI2 := TPlannedTreeItem(Item2);
  if xI1.triggerDate > xI2.triggerDate then begin
    Result := 1;
  end else if xI1.triggerDate < xI2.triggerDate then begin
    Result := -1;
  end else begin
    Result := 0;
  end;
end;

constructor TPlannedTreeItem.Create(APlanned: TPlannedMovement; ADone: TPlannedDone; ATriggerDate: TDateTime);
begin
  inherited Create;
  FPlanned := APlanned;
  FDone := ADone;
  FtriggerDate := ATriggerDate;
end;

procedure GetScheduledObjects(AList: TObjectList; APlannedObjects, ADoneObjects: TDataObjectList; ADateFrom, ADateTo: TDateTime; AScheduledObjectStates: TScheduledObjectStates);

  function FindPlannedDone(APlannedMovement: TPlannedMovement; ATriggerDate: TDateTime): TPlannedDone;
  var xCount: Integer;
      xCur: TPlannedDone;
  begin
    Result := Nil;
    xCount := 0;
    while (Result = Nil) and (xCount <= ADoneObjects.Count - 1) do begin
      xCur := TPlannedDone(ADoneObjects.Items[xCount]);
      if (xCur.idPlannedMovement = APlannedMovement.id) and (xCur.triggerDate = ATriggerDate) then begin
        Result := xCur;
      end;
      Inc(xCount);
    end;
  end;

  procedure RecreatePlannedMovements(AMovement: TPlannedMovement; AFromDate, AToDate: TDateTime);
  var xCurDate: TDateTime;
      xValid: Boolean;
      xTimes: Integer;
      xElement: TPlannedTreeItem;
      xDone: TPlannedDone;
  begin
    xCurDate := AFromDate;
    xTimes := AMovement.doneCount;
    while (xCurDate <= AToDate) do begin
      if AMovement.scheduleType = CScheduleTypeOnce then begin
        xValid := AMovement.scheduleDate = xCurDate;
      end else begin
        if AMovement.triggerType = CTriggerTypeWeekly then begin
          xValid := DayOfTheWeek(xCurDate) = (AMovement.triggerDay + 1);
        end else begin
          xValid := (DayOfTheMonth(xCurDate) = AMovement.triggerDay) or ((DayOfTheMonth(xCurDate) = DaysInMonth(xCurDate)) and (AMovement.triggerDay = 0));
        end;
        if AMovement.endCondition = CEndConditionTimes then begin
          xValid := xValid and (xTimes < AMovement.endCount);
          if xValid then begin
            Inc(xTimes);
          end;
        end else if AMovement.endCondition = CEndConditionDate then begin
          xValid := xValid and (xCurDate <= AMovement.endDate);
        end;
      end;
      if xValid then begin
        xDone := FindPlannedDone(AMovement, xCurDate);
        if ((xDone <> Nil) and (AScheduledObjectStates in [sosBoth, sosDone])) or ((xDone = Nil) and (AScheduledObjectStates in [sosBoth, sosPlanned])) then begin
          xElement := TPlannedTreeItem.Create(AMovement, xDone, xCurDate);
          AList.Add(xElement);
        end;
      end;
      xCurDate := IncDay(xCurDate, 1);
    end;
  end;

var xCount: Integer;
begin
  AList.Clear;
  for xCount := 0 to APlannedObjects.Count - 1 do begin
    RecreatePlannedMovements(TPlannedMovement(APlannedObjects.Items[xCount]), ADateFrom, ADateTo);
  end;
  AList.Sort(SortTreeHelperByDate);
end;

end.
