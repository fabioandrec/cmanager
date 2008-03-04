unit CSchedules;

interface

uses CDataObjects, Contnrs, CDatabase, SysUtils, Math, CComponents;

type
  TPlannedTreeItem = class(TCListDataElement)
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

uses DateUtils, CConsts, CPreferences;

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
  inherited Create(False, Nil, Nil, False, False);
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
      xM, xY, xD: Word;
      xTriggerDate: TDateTime;
  begin
    xCurDate := AFromDate;
    xTimes := AMovement.doneCount;
    while (xCurDate <= AToDate) do begin
      DecodeDate(xCurDate, xY, xM, xD);
      if AMovement.scheduleType = CScheduleTypeOnce then begin
        xValid := AMovement.scheduleDate = xCurDate;
        xTriggerDate := xCurDate;
      end else begin
        xValid := xCurDate >= AMovement.scheduleDate;
        if xValid then begin
          if AMovement.triggerType = CTriggerTypeWeekly then begin
            xValid := DayOfTheWeek(xCurDate) = (AMovement.triggerDay + 1);
            xTriggerDate := xCurDate;
          end else begin
            if AMovement.triggerDay = 0 then begin
              xD := DaysInMonth(xCurDate);
            end else begin
              xD := AMovement.triggerDay;
            end;
            if TryEncodeDate(xY, xM, xD, xTriggerDate) then begin
              xTriggerDate := AMovement.GetboundaryDate(xTriggerDate);
              xValid := xCurDate = xTriggerDate;
            end else begin
              xValid := False;
            end;
          end;
          if AMovement.endCondition = CEndConditionTimes then begin
            xValid := xValid and (xTimes < AMovement.endCount);
            if xValid then begin
              Inc(xTimes);
            end;
          end else if AMovement.endCondition = CEndConditionDate then begin
            xValid := xValid and (xCurDate <= AMovement.endDate);
          end else begin
            xValid := xValid and (xCurDate >= AMovement.scheduleDate);
          end;
        end;
      end;
      if xValid then begin
        xDone := FindPlannedDone(AMovement, xTriggerDate);
        if ((xDone <> Nil) and (AScheduledObjectStates in [sosBoth, sosDone])) or ((xDone = Nil) and (AScheduledObjectStates in [sosBoth, sosPlanned])) then begin
          xElement := TPlannedTreeItem.Create(AMovement, xDone, xTriggerDate);
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
