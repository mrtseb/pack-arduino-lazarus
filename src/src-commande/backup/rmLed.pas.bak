unit rmLed;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TBorderType = (btNone, btRaised, btLowered, btSingle);
  TrmLed = class(TGraphicControl)
  private
    { Déclarations privées }
    FBmpBuffer: TBitmap;
    FBGColor: TColor;
    FBorderColor: TColor;
    FLedOnColor: TColor;
    FLedOffColor: TColor;
    FBorder: TBorderType;
    FBorderMargin: integer;
    FLedOn: boolean;
    procedure SetBGColor(value: TColor);
    procedure SetBorderColor(value: TColor);
    procedure SetLedOnColor(value: TColor);
    procedure SetLedOffColor(value: TColor);
    procedure SetBorder(value: TBorderType);
    procedure SetBorderMargin(value: integer);
    procedure SetLedOn(value: boolean);
  protected
    { Déclarations protégées }
    procedure Paint; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure UpdateBmpBuffer;
  public
    { Déclarations publiques }
    constructor Create(anOwner:TComponent); override;
    destructor Destroy; override;
    procedure Free;
  published
    { Déclarations publiées }
    property BGColor: TColor read FBGColor write SetBGColor;
    property BorderColor: TColor read FBorderColor write SetBorderColor;
    property LedOnColor: TColor read FLedOnColor write SetLedOnColor;
    property LedOffColor: TColor read FLedOffColor write SetLedOffColor;
    property Border: TBorderType read FBorder write SetBorder;
    property BorderMargin: integer read FBorderMargin write SetBorderMargin;
    property LedOn: boolean read FLedOn write SetLedOn;
    { Standard properties and events}
    property Align;
    property Height;
    property Width;
    property PopupMenu;
    property Hint;
    property ShowHint;
    property Tag;
    property Visible;
    property OnClick;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('OptoElec', [TrmLed]);
end;

constructor TrmLed.Create(anOwner:TComponent);
begin
  Inherited Create(anOwner);
  FBmpBuffer := TBitmap.Create;
  width := 13;
  height := 13;
  FBorder := btRaised;
  FBorderMargin := 3;
  FBGColor := clSilver;
  FBorderColor := clBlack;
  FLedOnColor := clLime;
  FLedOffColor := clGreen;
  FLedOn := false;
end;

destructor TrmLed.Destroy;
begin
  If FBmpBuffer <> NIL then FBmpBuffer.free;
  Inherited Destroy;
end;

procedure TrmLed.Free;
begin
  FBmpBuffer.Free;
  Inherited Free;
end;

procedure TrmLed.SetBounds(aLeft, aTop, aWidth, aHeight: Integer);
begin
  Inherited ;
  If FBmpBuffer <> NIL then begin
    FBmpBuffer.Destroy;
    FBmpBuffer := TBitmap.Create;
    FBmpBuffer.Height := aHeight;
    FBmpBuffer.Width := aWidth;
  end;
end;

procedure TrmLed.Paint;
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

procedure TrmLed.UpdateBmpBuffer;

  procedure DrawBackGround;
  begin
    With FBmpBuffer.Canvas do begin
      if Border = btSingle then
        Pen.Color := FBorderColor
      else
        Pen.Color := FBGColor;
      Brush.Color := FBGColor;
      Rectangle(0, 0, width, height);
    end;
  end;

  procedure DrawLed;
  begin
    With FBmpBuffer.Canvas do begin
      if LedOn then begin
        Pen.Color := FLedOnColor;
        Brush.Color := FLedOnColor;
      end else begin
        Pen.Color := FLedOffColor;
        Brush.Color := FLedOffColor;
      end;
      Rectangle(BorderMargin, BorderMargin, width - BorderMargin, height - BorderMargin);
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

begin
  DrawBackGround;
  DrawLed;
  Draw3DBorder;
end;

procedure TrmLed.SetBGColor(value: TColor);
begin
  if value <> FBGColor then
  begin
    FBGColor := value;
    Paint;
  end;
end;

procedure TrmLed.SetBorderColor(value: TColor);
begin
  if value <> FBorderColor then
  begin
    FBorderColor := value;
    Paint;
  end;
end;

procedure TrmLed.SetLedOnColor(value: TColor);
begin
  if value <> FLedOnColor then
  begin
    FLedOnColor := value;
    Paint;
  end;
end;

procedure TrmLed.SetLedOffColor(value: TColor);
begin
  if value <> FLedOffColor then
  begin
    FLedOffColor := value;
    Paint;
  end;
end;

procedure TrmLed.SetBorder(value: TBorderType);
begin
  if value <> FBorder then
  begin
    FBorder := value;
    Paint;
  end;
end;

procedure TrmLed.SetBorderMargin(value: integer);
begin
  if value <> FBorderMargin then
  begin
    FBorderMargin := value;
    Paint;
  end;
end;

procedure TrmLed.SetLedOn(value: boolean);
begin
  if value <> FLedOn then
  begin
    FLedOn := value;
    Paint;
  end;
end;



end.
