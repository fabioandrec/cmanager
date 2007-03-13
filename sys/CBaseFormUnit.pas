unit CBaseFormUnit;

interface

uses
  Windows, Forms, Classes, ComCtrls, Graphics, SysUtils, Messages, CTemplates,
  Controls;

type
  TCBaseForm = class(TForm, IDescTemplateExpander)
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  protected
    procedure CloseForm; virtual;
    procedure WndProc(var Message: TMessage); override;
    procedure Loaded; override;
  public
    function ExpandTemplate(ATemplate: String): String; virtual;
  end;

implementation

uses CSettings, CBaseFrameUnit, CConsts, CComponents, CTools, DateUtils,
  CDatabase;

{$R *.dfm}

procedure TCBaseForm.CloseForm;
begin
  Close;
end;

procedure TCBaseForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then begin
    CloseForm;
  end;
end;

procedure TCBaseForm.FormDestroy(Sender: TObject);
begin
  SaveFormPosition(Self);
end;

procedure TCBaseForm.FormShow(Sender: TObject);
begin
  LoadFormPosition(Self);
end;

procedure TCBaseForm.WndProc(var Message: TMessage);
begin
  inherited WndProc(Message);
  if Message.Msg = WM_FORMMAXIMIZE then begin
    WindowState := wsMaximized;
  end else if Message.Msg = WM_FORMMINIMIZE then begin
    WindowState := wsMaximized;
  end;
end;

procedure TCBaseForm.Loaded;
var xCount: Integer;
begin
  inherited Loaded;
  for xCount := 0 to ComponentCount - 1 do begin
    if Components[xCount].InheritsFrom(TCStatic) then begin
      TCStatic(Components[xCount]).TabStop := True;
      TCStatic(Components[xCount]).Transparent := False;
    end else if Components[xCount].InheritsFrom(TRichEdit) then begin
      TRichEdit(Components[xCount]).Font.Name := 'Microsoft Sans Serif';
    end;
  end;
end;

function TCBaseForm.ExpandTemplate(ATemplate: String): String;
begin
  Result := '<nieznana>';
  if ATemplate = '@godz@' then begin
    Result := LPad(IntToStr(HourOf(Now)), '0', 2);
  end else if ATemplate = '@min@' then begin
    Result := LPad(IntToStr(MinuteOf(Now)), '0', 2);
  end else if ATemplate = '@czas@' then begin
    Result := GetFormattedTime(Now, 'HH:mm');
  end else if ATemplate = '@dzien@' then begin
    Result := LPad(IntToStr(DayOf(Now)), '0', 2);
  end else if ATemplate = '@miesiac@' then begin
    Result := LPad(IntToStr(MonthOf(Now)), '0', 2);
  end else if ATemplate = '@rok@' then begin
    Result := IntToStr(YearOf(Now));
  end else if ATemplate = '@rokkrotki@' then begin
    Result := Copy(IntToStr(YearOf(Now)), 3, 2);
  end else if ATemplate = '@dzientygodnia@' then begin
    Result := IntToStr(DayOfTheWeek(Now));
  end else if ATemplate = '@nazwadnia@' then begin
    Result := GetFormattedDate(Now, 'dddd');
  end else if ATemplate = '@nazwamiesiaca@' then begin
    Result := GetFormattedDate(Now, 'MMMM');
  end else if ATemplate = '@data@' then begin
    Result := GetFormattedDate(Now, 'yyyy-MM-dd');
  end else if ATemplate = '@dataczas@' then begin
    Result := GetFormattedDate(Now, 'yyyy-MM-dd') + ' ' + GetFormattedTime(Now, 'HH:mm');
  end else if ATemplate = '@wersja@' then begin
    Result := FileVersion(ParamStr(0));
  end;
end;

end.

