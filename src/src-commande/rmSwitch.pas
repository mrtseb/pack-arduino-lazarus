unit rmSwitch;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TBorderType = (btNone, btRaised, btLowered, btSingle);
  TSwitchOrientation = (soHorizontal, soVertical);
  TSwitchStyle = (ssPushButton, ssSlideButton);
  TrmSwitch = class(TGraphicControl)
  private
    { Déclarations privées }
    FBmpBuffer: TBitmap;
    FSwitchStyle: TSwitchStyle;
    FBGColor: TColor;
    FBorderColor: TColor;
    FButtonBorderColor: TColor;
    FDisabledColor: TColor;
    FLitOnColor: TColor;
    FLitOffColor: TColor;
    FBorder: TBorderType;
    FButtonBorder: TBorderType;
    FHorzMargin: integer;
    FVertMargin: integer;
    FSwitchOn: boolean;
    FOrientation: TSwitchOrientation;
    FOnChange: TNotifyEvent;
    procedure SetSwitchStyle(value: TSwitchStyle);
    procedure SetBGColor(value: TColor);
    procedure SetBorderColor(value: TColor);
    procedure SetButtonBorderColor(value: TColor);
    procedure SetDisabledColor(value: TColor);
    procedure SetLitOnColor(value: TColor);
    procedure SetLitOffColor(value: TColor);
    procedure SetBorder(value: TBorderType);
    procedure SetButtonBorder(value: TBorderType);
    procedure SetHorzMargin(value: integer);
    procedure SetVertMargin(value: integer);
    procedure SetSwitchOn(value: boolean);
    procedure SetOrientation(value: TSwitchOrientation);
  protected
    { Déclarations protégées }
    procedure Paint; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure UpdateBmpBuffer;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
  public
    constructor Create(anOwner:TComponent); override;
    destructor Destroy; override;
    procedure Free;
    { Déclarations publiques }
  published
    { Déclarations publiées }
    property SwitchStyle: TSwitchStyle read FSwitchStyle write SetSwitchStyle;
    property BGColor: TColor read FBGColor write SetBGColor;
    property BorderColor: TColor read FBorderColor write SetBorderColor;
    property ButtonBorderColor: TColor read FButtonBorderColor write SetButtonBorderColor;
    property DisabledColor: TColor read FDisabledColor write SetDisabledColor;
    property LitOnColor: TColor read FLitOnColor write SetLitOnColor;
    property LitOffColor: TColor read FLitOffColor write SetLitOffColor;
    property Border: TBorderType read FBorder write SetBorder;
    property ButtonBorder: TBorderType read FButtonBorder write SetButtonBorder;
    property HorzMargin: integer read FHorzMargin write SetHorzMargin;
    property VertMargin: integer read FVertMargin write SetVertMargin;
    property SwitchOn: boolean read FSwitchOn write SetSwitchOn;
    property Orientation: TSwitchOrientation read FOrientation write SetOrientation;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;

    { Standard properties and events}
    // property Align;
    property Enabled;
    property Height;
    property Width;
    property PopupMenu;
    property Hint;
    property ShowHint;
    property Tag;
    property Visible;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('OptoElec', [TrmSwitch]);
end;

constructor TrmSwitch.Create(anOwner:TComponent);
begin
  Inherited Create(anOwner);
  FBmpBuffer := TBitmap.Create;
  width := 16;
  height := 29;
  FSwitchStyle := ssSlideButton;
  FBorder := btLowered;
  FButtonBorder := btRaised;
  FBGColor := clBlack;
  FBorderColor := clBlack;
  FDisabledColor := clSilver;
  FLitOnColor := clRed;
  FLitOffColor := clMaroon;
  FHorzMargin := 2;
  FVertMargin := 2;
  FSwitchOn := false;
  FOrientation := soVertical;
end;

destructor TrmSwitch.Destroy;
begin
  If FBmpBuffer <> NIL then FBmpBuffer.free;
  Inherited Destroy;
end;

procedure TrmSwitch.Free;
begin
  FBmpBuffer.Free;
  Inherited Free;
end;

procedure TrmSwitch.SetBounds(aLeft, aTop, aWidth, aHeight: Integer);
begin
  Inherited ;
  If FBmpBuffer <> NIL then begin
    FBmpBuffer.Destroy;
    FBmpBuffer := TBitmap.Create;
    FBmpBuffer.Height := aHeight;
    FBmpBuffer.Width := aWidth;
  end;
end;

procedure TrmSwitch.Paint;
begin
  try
    UpdateBmpBuffer;
  except
  end;
  try
    Canvas.Draw(0, 0, FBmpBuffer);
  except
  end;
end;

procedure TrmSwitch.UpdateBmpBuffer;

  procedure GetButtonCoordinates(var X1, Y1, X2, Y2: integer;
              Orient: TSwitchOrientation;
              ActiveState: Boolean);
  var
    ButtonHeight, ButtonWidth: integer;
  begin
    if (SwitchStyle = ssSlideButton) then begin
      if (Orient = soVertical) then begin
        ButtonHeight := round((height - (2 * FVertMargin)) / 2);
        ButtonWidth := width - (2 * FHorzMargin);
      end else if (Orient = soHorizontal) then begin
        ButtonHeight := height - (2 * FVertMargin);
        ButtonWidth := round((width - (2 * FHorzMargin)) / 2);
      end;
    end else if (SwitchStyle = ssPushButton) then begin
      ButtonHeight := height - (2 * FVertMargin);
      ButtonWidth := width - (2 * FHorzMargin);
    end;
    if (Orient = soVertical) and ActiveState then begin
      X1 := FHorzMargin;
      Y1 := FVertMargin;
      X2 := FHorzMargin + ButtonWidth;
      Y2 := FVertMargin + ButtonHeight;
    end else if (Orient = soVertical) and (not ActiveState) then begin
      X1 := FHorzMargin;
      Y1 := height - FVertMargin - ButtonHeight;
      X2 := FHorzMargin + ButtonWidth;
      Y2 := height - FVertMargin;
    end else if (Orient = soHorizontal) and ActiveState then begin
      X1 := width - FHorzMargin - ButtonWidth;
      Y1 := FVertMargin;
      X2 := width - FHorzMargin;
      Y2 := FVertMargin + ButtonHeight;
    end else if (Orient = soHorizontal) and (not ActiveState) then begin
      X1 := FHorzMargin;
      Y1 := FVertMargin;
      X2 := FHorzMargin + ButtonWidth;
      Y2 := FVertMargin + ButtonHeight;
    end;
  end;

  procedure DrawBackGround;
  begin
    With FBmpBuffer.Canvas do
    begin
      if Enabled then
      begin
        if Border = btSingle then
          Pen.Color := FBorderColor
        else
          Pen.Color := FBGColor;
        Brush.Color := FBGColor;
      end
      else begin
        if Border = btSingle then
          Pen.Color := FBorderColor
        else
          Pen.Color := FDisabledColor;
        Brush.Color := FDisabledColor;
      end;
      Rectangle(0, 0, width, height);
    end;
  end;

  procedure Draw3DBorder;
  begin
    With FBmpBuffer.Canvas do begin
      if (FBorder = btRaised) or (FBorder = btLowered) then begin
        if FBorder = btRaised then
          Pen.Color := clWhite
        else
          pen.color := clGray;
        moveTo(0, height - 1);
        lineTo(0, 0);
        lineTo(width - 1, 0);
        if FBorder = btRaised then
          Pen.Color := clGray
        else
          pen.color := clWhite;
        lineTo(width - 1, height - 1);
        lineTo(0, height - 1);
      end;
    end;
  end;

  procedure DrawButton;
  var
    X1, Y1, X2, Y2: integer;
    StateColor: TColor;
  begin
    GetButtonCoordinates(X1, Y1, X2, Y2, Orientation, SwitchOn);
    if Enabled then
    begin
      if SwitchOn then
        StateColor := FLitOnColor
      else
        StateColor := FLitOffColor;
    end
    else begin
      StateColor := FDisabledColor
    end;
    With FBmpBuffer.Canvas do begin
      if ButtonBorder = btSingle then
        Pen.Color := FButtonBorderColor
      else
        Pen.Color := StateColor;
      Brush.Color := StateColor;
      Rectangle(X1, Y1, X2, Y2);
    end;
  end;

  procedure Draw3DButtonBorder;
  var
    X1, Y1, X2, Y2: integer;
  begin
    With FBmpBuffer.Canvas do begin
      if (FButtonBorder = btRaised) or
         (FButtonBorder = btLowered) or
         (SwitchStyle = ssPushButton) then begin


        if ((SwitchStyle = ssSlideButton) and (FButtonBorder = btRaised)) or
           ((SwitchStyle = ssPushButton) and (not SwitchOn)) then
          Pen.Color := clWhite
        else if ((SwitchStyle = ssSlideButton) and (FButtonBorder = btLowered)) or
                ((SwitchStyle = ssPushButton) and (SwitchOn)) then
          pen.color := clGray;

        GetButtonCoordinates(X1, Y1, X2, Y2, Orientation, SwitchOn);

        moveTo(X1, Y2 - 1);
        lineTo(X1, Y1);
        lineTo(X2 - 1, Y1);
        if ((SwitchStyle = ssSlideButton) and (FButtonBorder = btRaised)) or
           ((SwitchStyle = ssPushButton) and (not SwitchOn)) then
          Pen.Color := clGray
        else if ((SwitchStyle = ssSlideButton) and (FButtonBorder = btLowered)) or
                ((SwitchStyle = ssPushButton) and (SwitchOn)) then
          pen.color := clWhite;
        lineTo(X2 - 1, Y2 - 1);
        lineTo(X1, Y2 - 1);
      end;
    end;
  end;

begin
  DrawBackGround;
  Draw3DBorder;
  DrawButton;
  Draw3DButtonBorder;
end;

procedure TrmSwitch.SetSwitchStyle(value: TSwitchStyle);
begin
  if value <> FSwitchStyle then
  begin
    FSwitchStyle := value;
    if FSwitchStyle = ssPushButton then begin
      height := width;
    end else begin
      if FOrientation = soVertical then
        height := 2 * width
      else
        width := 2 * height;
    end;
    Paint;
  end;
end;

procedure TrmSwitch.SetBGColor(value: TColor);
begin
  if value <> FBGColor then
  begin
    FBGColor := value;
    Paint;
  end;
end;

procedure TrmSwitch.SetBorderColor(value: TColor);
begin
  if value <> FBorderColor then
  begin
    FBorderColor := value;
    Paint;
  end;
end;

procedure TrmSwitch.SetButtonBorderColor(value: TColor);
begin
  if value <> FButtonBorderColor then
  begin
    FButtonBorderColor := value;
    Paint;
  end;
end;

procedure TrmSwitch.SetDisabledColor(value: TColor);
begin
  if value <> FDisabledColor then
  begin
    FDisabledColor := value;
    Paint;
  end;
end;

procedure TrmSwitch.SetLitOnColor(value: TColor);
begin
  if value <> FLitOnColor then
  begin
    FLitOnColor := value;
    Paint;
  end;
end;

procedure TrmSwitch.SetLitOffColor(value: TColor);
begin
  if value <> FLitOffColor then
  begin
    FLitOffColor := value;
    Paint;
  end;
end;

procedure TrmSwitch.SetBorder(value: TBorderType);
begin
  if value <> FBorder then
  begin
    FBorder := value;
    Paint;
  end;
end;

procedure TrmSwitch.SetButtonBorder(value: TBorderType);
begin
  if value <> FButtonBorder then
  begin
    FButtonBorder := value;
    Paint;
  end;
end;

procedure TrmSwitch.SetHorzMargin(value: integer);
begin
  if value <> FHorzMargin then
  begin
    FHorzMargin := value;
    Paint;
  end;
end;

procedure TrmSwitch.SetVertMargin(value: integer);
begin
  if value <> FVertMargin then
  begin
    FVertMargin := value;
    Paint;
  end;
end;

procedure TrmSwitch.SetSwitchOn(value: boolean);
begin
  if value <> FSwitchOn then
  begin
    FSwitchOn := value;
    Paint;
    if assigned(FOnChange) then
      FOnChange(self);
  end;
end;

procedure TrmSwitch.SetOrientation(value: TSwitchOrientation);
var
  oldVal: integer;
begin
  if value <> FOrientation then
  begin
    FOrientation := value;

    if (csDesigning in ComponentState) and not(csReading in ComponentState) then begin
      // invert Width and Height
      oldVal := width;
      width := height;
      height := oldVal;
      // invert HorzMargin and VertMargin
      oldVal := HorzMargin;
      HorzMargin := VertMargin;
      VertMargin := oldVal;
    end;

    // redraw switch
    Paint;

  end;
end;

procedure TrmSwitch.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  if not enabled then exit;
  SwitchOn := not SwitchOn;
  paint;
end;


end.
