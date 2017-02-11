{see rmDGraph.txt for more details}

unit rmDGraph;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFnDEF FPC}
  WinProcs,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  //WinTypes,
  Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs,  ExtCtrls;

type
  TBorderType = (btNone, btRaised, btLowered, btSingle);
  TGridType = (gtNone, gtVertical, gtHorizontal, gtBoth);
  TValuePosition = (vpPixels, vpFullWidth);
  TTextType = (stLeft, stRight, stBottom, stTop);
  TScaleText = set of TTextType;

  TrmDGraph = class(TGraphicControl)
  private
    FNumTraces: word;
    FSpacing: integer;
    FTraceLabels: string;
    FGridType: TGridType;
    FCTL3D: boolean;
    FValuePosition: TValuePosition;
    FBmpBuffer: TBitmap;
    FBGColor: TColor;
    FBorder: TBorderType;
    FGraphColor: TColor;
    FGridColor: TColor;
    FTracesColor: TColor;
    FLeftMargin, FRightMargin, FTopMargin, FBottomMargin: integer;
    FRightOffset: integer;
    FHorzMinVal, FHorzMaxVal: single;
    FHorzUnit: string;
    FHorzDecNum: integer;
    FHorzDiv: integer;
    FScaleText: TScaleText;
    FTextColor: TColor;
    FTextSize: integer;
    FMaxItems: integer;
    procedure SetNumTraces(value: word);
    procedure SetSpacing(value: integer);
    procedure SetTraceLabels(value: string);
    procedure SetGridType(value: TGridType);
    procedure SetCTL3D(value: boolean);
    procedure SetValuePosition(value: TValuePosition);
    procedure SetValues(value: TStringList);
    procedure SetBGColor(value: TColor);
    procedure SetBorder(value: TBorderType);
    procedure SetGraphColor(value: TColor);
    procedure SetGridColor(value: TColor);
    procedure SetTracesColor(value: TColor);
    procedure SetLeftMargin(value: integer);
    procedure SetRightMargin(value: integer);
    procedure SetTopMargin(value: integer);
    procedure SetBottomMargin(value: integer);
    procedure SetRightOffset(value: integer);
    procedure SetHorzMinVal(value: single);
    procedure SetHorzMaxVal(value: single);
    procedure SetHorzUnit(value: string);
    procedure SetHorzDecNum(value: integer);
    procedure SetHorzDiv(value: integer);
    procedure SetScaleText(value: TScaleText);
    procedure SetTextColor(value: TColor);
    procedure SetTextSize(value: integer);
    procedure SetMaxItems(value: integer);
  protected
    procedure Paint; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure UpdateBmpBuffer(colored: boolean);
  public
    constructor Create(anOwner:TComponent); override;
    destructor Destroy; override;
    procedure Free;
  published
    LstValues: TStringList;
    property NumTraces: word read FNumTraces write SetNumTraces;
    property Spacing: integer read FSpacing write SetSpacing;
    property TraceLabels: string read FTraceLabels write SetTraceLabels;
    property GridType: TGridType read FGridType write SetGridType;
    property ValuePosition: TValuePosition read FValuePosition write SetValuePosition;
    // property Values: TStringList read FValues write SetValues;
    property BGColor: TColor read FBGColor write SetBGColor;
    property CTL3D: boolean read FCTL3D write SetCTL3D;
    property Border: TBorderType read FBorder write SetBorder;
    property GraphColor: TColor read FGraphColor write SetGraphColor;
    property GridColor: TColor read FGridColor write SetGridColor;
    property TracesColor: TColor read FTracesColor write SetTracesColor;
    property LeftMargin: integer read FLeftMargin write SetLeftMargin;
    property RightMargin: integer read FRightMargin write SetRightMargin;
    property TopMargin: integer read FTopMargin write SetTopMargin;
    property BottomMargin: integer read FBottomMargin write SetBottomMargin;
    property RightOffset: integer read FRightOffset write SetRightOffset;
    property HorzMinVal: single read FHorzMinVal write SetHorzMinVal;
    property HorzMaxVal: single read FHorzMaxVal write SetHorzMaxVal;
    property HorzUnit: string read FHorzUnit write SetHorzUnit;
    property HorzDiv: integer read FHorzDiv write SetHorzDiv;
    property HorzDecNum: integer read FHorzDecNum write SetHorzDecNum;
    property ScaleText: TScaleText read FScaleText write SetScaleText;
    property TextColor: TColor read FTextColor write SetTextColor;
    property TextSize: integer read FTextSize write SetTextSize;
    property MaxItems: integer read FMaxItems write SetMaxItems;
    procedure SaveGraphToFile(sFile: TFileName);
    {
    procedure CopyGraphToClipboard;
    }
    procedure Clear;
    function AddValues(s: string; refresh: boolean): integer;
    function DeleteValues(i: integer; refresh: boolean): integer;
    { Standard properties }
    property Align;
    property Height;
    property Width;
    { Standard events }
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnClick;
    property OnDblClick;
  end;

  procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('OptoElec', [TrmDGraph]);
end;

function r2s(dec: integer; r: real): string;
var
  s: string;
begin
  str(r:0:dec, s);
  result := s;
end;

constructor TrmDGraph.Create(anOwner:TComponent);
begin
  Inherited Create(anOwner);
  FBmpBuffer := TBitmap.Create;
  LstValues := TStringList.Create;
  FNumTraces := 12;
  FSpacing := 12;
  FTraceLabels := '';
  FBorder := btRaised;
  FCTL3D := true;
  FBGColor := clSilver;
  FGraphColor := clBlack;
  FGridColor := clGreen;
  FTracesColor := clAqua;
  Height := 305;
  Width := 433;
  FGridType := gtBoth;
  FValuePosition := vpPixels;
  FLeftMargin := 55;
  FRightMargin := 4;
  FTopMargin := 4;
  FBottomMargin := 4;
  FRightOffset := 2;
  FHorzMinVal := 0;
  FHorzMaxVal := 100;
  FHorzUnit := 'ms';
  FHorzDecNum := 0;
  FHorzDiv := 10;
  FScaleText := [stLeft];
  FTextColor := clBlue;
  FTextSize := 8;
  FMaxItems := 0;
end;

destructor TrmDGraph.Destroy;
begin
  If FBmpBuffer <> NIL then FBmpBuffer.free;
  if LstValues <> nil then LstValues.Free;
  Inherited Destroy;
end;

procedure TrmDGraph.Free;
begin
  FBmpBuffer.Free;
  LstValues.free;
  Inherited Free;
end;

procedure TrmDGraph.SetBounds(aLeft, aTop, aWidth, aHeight: Integer);
begin
  Inherited ;
  If FBmpBuffer <> NIL then begin
    FBmpBuffer.Destroy;
    FBmpBuffer := TBitmap.Create;
    FBmpBuffer.Height := aHeight;
    FBmpBuffer.Width := aWidth;
  end;
end;

procedure TrmDGraph.UpdateBmpBuffer(colored: boolean);
var
  i, j: integer;
  val: real;
  sep: integer;
  s, lbl: string;
  HPos, VPos, TruePos, FalsePos: integer;
  GraphHeight, GraphWidth: integer;
  Bit, oldBit, Empty: boolean;
  UpOver, DownOver: boolean;
begin
  DownOver := false;
  UpOver := false;

  With FBmpBuffer.Canvas do begin
    GraphWidth := width - FLeftMargin - FRightMargin;
    GraphHeight := height - FTopMargin - FBottomMargin;

    // backGround
    {
    Brush.Color := FBGColor;
    if FBorder then Pen.Color := clBlack else Pen.Color := FBGColor;
    Rectangle(0, 0, width, height);
    }
      if colored then begin
        if (FBorder <> btSingle) then Pen.Color := FBGColor
        else Pen.Color := clBlack;
        Brush.Color := FBGColor;
      end else begin
        if (FBorder <> btNone) then Pen.Color := clBlack
        else pen.color := clWhite;
        Brush.Color := clWhite;
      end;
      Rectangle(0, 0, width, height);

      // 3D border only if colored
      if colored then begin
        if (FBorder = btRaised) or (FBorder = btLowered) then begin
          if FBorder = btRaised then Pen.Color := clWhite else pen.color := clGray;
          moveTo(0, height - 1);
          lineTo(0, 0);
          lineTo(width - 1, 0);
          if FBorder = btRaised then Pen.Color := clGray else pen.color := clWhite;
          lineTo(width - 1, height - 1);
          lineTo(0, height - 1);
        end;
      end;


    // graph BackGround
    Brush.Color := FGraphColor;
    Pen.Color := FGraphColor;
    Rectangle(FLeftMargin, FTopMargin, width - FRightMargin, Height - bottomMargin);

    // 3D Effect
    if FCTL3D then begin
      Pen.Color := clGray;
      moveTo(leftMargin - 1, TopMargin - 1);
      lineTo(leftMargin - 1, TopMargin + graphHeight);
      moveTo(leftMargin - 1, TopMargin - 1);
      lineTo(leftMargin + graphWidth, TopMargin - 1);
      Pen.Color := clWhite;
      moveTo(leftMargin + graphWidth, TopMargin - 1);
      lineTo(leftMargin + graphWidth, TopMargin + graphHeight + 1);
      moveTo(leftMargin - 1, TopMargin + graphHeight);
      lineTo(leftMargin + graphWidth, TopMargin + graphHeight);
    end;

    // grid
    if (FGridType = gtHorizontal) or (FGridType = gtBoth) then begin
      Pen.Color := FGridColor;
      for i := 1 to FHorzDiv - 1 do begin
        HPos := FLeftMargin + trunc((i * GraphWidth) / FHorzDiv);
        MoveTo(HPos, FTopMargin);
        LineTo(HPos, Height - FBottomMargin);
      end;
    end;
    if (FGridType = gtVertical) or (FGridType = gtBoth) then begin
      Pen.Color := FGridColor;
      for i := 1 to FNumTraces - 1 do begin
        VPos := FTopMargin + trunc((GraphHeight / FNumTraces) * i);
        MoveTo(FLeftMargin, VPos);
        LineTo(width - FRightMargin, VPos);
      end;
    end;

    // left and right scales
    if (stLeft in FScaleText) or (stRight in FScaleText) then begin
      brush.Color := FBGColor;
      font.Name := 'Arial';
      font.Color := FTextColor;
      font.Size := FTextSize;
      s := FTraceLabels;
      if copy(s, length(s), 1) <> ';' then s := s + ';';
      for i := 1 to FNumTraces do begin
        // trace labels extracted from FTraceLabels property
        lbl := copy(s, 1, pos(';', s) - 1);
        // if there is more traces than labels then new labels are created
        if lbl = '' then lbl := 'Trace ' + intToStr(i);
        delete(s, 1, pos(';', s));
        val := ((GraphHeight / FNumTraces) * i) - (GraphHeight / (FNumTraces * 2))- (textHeight(lbl) div 2);
        VPos := FTopMargin + trunc(val);
        if (stLeft in FScaleText) then
          textOut(FLeftMargin - 4 - textWidth(lbl), VPos, lbl);
        if (stRight in FScaleText) then
          textOut(FLeftMargin + graphWidth + 4, VPos, lbl);
      end;
    end;

    // top and bottom scales
    if (stTop in FScaleText) or (stBottom in FScaleText) then begin
      brush.Color := FBGColor;
      font.Name := 'Arial';
      font.Color := FTextColor;
      font.Size := FTextSize;
      for i := 0 to FHorzDiv do begin
        if (i = 0) or (i = FHorzDiv) then begin
          val := FHorzMinVal + ((FHorzMaxVal - FHorzMinVal) / FHorzDiv) * i;
          s := r2s(FHorzDecNum, val);
        end else begin
          val := FHorzMinVal + ((FHorzMaxVal - FHorzMinVal) / FHorzDiv) * i;
          s := r2s(FHorzDecNum, val) + FHorzUnit;
        end;
        if i = 0 then
          HPos := FLeftMargin - 2
        else if i = FHorzDiv then
          HPos := FLeftMargin + GraphWidth - textWidth(s)
        else
          HPos := FLeftMargin + trunc((i * GraphWidth) / FHorzDiv) - (textWidth(s) div 2);
        if (stTop in FScaleText) then
          textOut(HPos, FTopMargin - 4 - textHeight(s), s);
        if (stBottom in FScaleText) then
          textOut(HPos, FTopMargin + graphHeight + 4, s);
      end;
    end;

    // trace only in conception
    // not necessary but useful to view results
    // when changing property values in conception mode
    if csDesigning in ComponentState then begin
      brush.Color := GraphColor;
      font.size := FTextSize;
      pen.Color := TracesColor;
      for i := 1 to FNumTraces do begin
        Bit := false;
        Pen.Color := FTracesColor;
        TruePos := FTopMargin + trunc(((GraphHeight / FNumTraces) * (i - 1)) + (FSpacing / 2));
        FalsePos := FTopMargin + trunc(((GraphHeight / FNumTraces) * (i)) - (FSpacing / 2));
        moveTo(FLeftMargin , FalsePos);
        for j := 1 to FHorzDiv do begin
          Bit := not Bit;
          if Bit then begin
            lineTo(FLeftMargin + trunc(j * (GraphWidth / FHorzDiv)), FalsePos);
            if j < FHorzDiv then lineTo(FLeftMargin + trunc(j * (GraphWidth / FHorzDiv)), TruePos);
          end else begin
            lineTo(FLeftMargin + trunc(j * (GraphWidth / FHorzDiv)), TruePos);
            if j < FHorzDiv then lineTo(FLeftMargin + trunc(j * (GraphWidth / FHorzDiv)), FalsePos);
          end;
        end;
      end;
    end;

    // decode values in StringList FValues...
    if LstValues.Count > 0 then
    begin
      empty := false;
      Pen.Color := FTracesColor;
      for i := 1 to FNumTraces do
      begin
        oldBit := false;
        TruePos := FTopMargin + trunc(((GraphHeight / FNumTraces) * (i - 1)) + (FSpacing / 2));
        FalsePos := FTopMargin + trunc(((GraphHeight / FNumTraces) * (i)) - (FSpacing / 2));
        if empty then break;
        for j := 0 to LstValues.Count - 1 do
        begin
          s := copy(LstValues[j], i, 1);
          if (s <> '1') and (s <> '0') then break;
          bit := (s = '1');

          // calculate horizontal position
          if FValuePosition = vpPixels then
          begin
            if j > GraphWidth then break;
            HPos := FLeftMargin + j;
          end
          else begin
            if j < 2 then
              HPos := FLeftMargin
            else
              HPos := FLeftMargin + trunc((GraphWidth * j) / (LstValues.Count - 1));
          end;

          // first horizontal position
          if j = 0 then
            if bit then
              moveTo(FLeftMargin , TruePos)
            else
              moveTo(FLeftMargin , FalsePos);

          // draw lines
          if (not oldBit) and (not Bit) then
          begin
            lineTo(HPos - FRightOffset, FalsePos);
          end else if (not oldBit) and bit then
          begin
            lineTo(HPos - FRightOffset, FalsePos);
            if j < LstValues.Count then
              lineTo(HPos - FRightOffset, TruePos);
          end else if oldBit and (not bit) then
          begin
            lineTo(HPos - FRightOffset, TruePos);
            if j < LstValues.Count then
              lineTo(HPos - FRightOffset, FalsePos);
          end else if oldBit and bit then
          begin
            lineTo(HPos - FRightOffset, TruePos);
          end;
          oldBit := bit;

        end;
      end;
    end;
  end;
end;

procedure TrmDGraph.Paint;
begin
  try
    UpdateBmpBuffer(true);
  except
  end;
  try
    Canvas.Draw(0, 0, FBmpBuffer);
  except
  end;
end;

procedure TrmDGraph.SaveGraphToFile(sFile: TFileName);
begin
  if FBmpBuffer <> nil then begin
    try
      FBmpBuffer.SaveToFile(sFile);
    except
    end;
  end;
end;

{
procedure TrmDGraph.CopyGraphToClipboard;
begin
  if FBmpBuffer <> nil then begin
    try
      showMessage('Sorry, "CopyGraphToClipboard" procedure not implemented.');
    except
    end;
  end;
end;
}

procedure TrmDGraph.SetNumTraces(value: word);
begin
  if value <> FNumTraces then
  begin
    FNumTraces := value;
    Paint;
  end;
end;

procedure TrmDGraph.SetSpacing(value: integer);
begin
  if value <> FSpacing then
  begin
    FSpacing := value;
    Paint;
  end;
end;

procedure TrmDGraph.SetTraceLabels(value: string);
begin
  if value <> FTraceLabels then
  begin
    FTraceLabels := value;
    Paint;
  end;
end;

procedure TrmDGraph.SetValuePosition(value: TValuePosition);
begin
  if value <> FValuePosition then
  begin
    FValuePosition := value;
    Paint;
  end;
end;

procedure TrmDGraph.SetValues(value: TStringList);
begin
  if value <> LstValues then
  begin
    LstValues := value;
    Paint;
  end;
end;

procedure TrmDGraph.SetBGColor(value: TColor);
begin
  if value <> FBGColor then
  begin
    FBGColor := value;
    Paint;
  end;
end;

procedure TrmDGraph.SetBorder(value: TBorderType);
begin
  if value <> FBorder then
  begin
    FBorder := value;
    Paint;
  end;
end;

procedure TrmDGraph.SetCTL3D(value: boolean);
begin
  if value <> FCTL3D then
  begin
    FCTL3D := value;
    Paint;
  end;
end;

procedure TrmDGraph.SetGraphColor(value: TColor);
begin
  if value <> FGraphColor then
  begin
    FGraphColor := value;
    Paint;
  end;
end;

procedure TrmDGraph.SetGridColor(value: TColor);
begin
  if value <> FGridColor then
  begin
    FGridColor := value;
    Paint;
  end;
end;

procedure TrmDGraph.SetTracesColor(value: TColor);
begin
  if value <> FTracesColor then
  begin
    FTracesColor := value;
    Paint;
  end;
end;

procedure TrmDGraph.SetGridType(value: TGridType);
begin
  if value <> FGridType then
  begin
    FGridType := value;
    Paint;
  end;
end;

procedure TrmDGraph.SetLeftMargin(value: integer);
begin
  if value <> FLeftMargin then
  begin
    FLeftMargin := value;
    Paint;
  end;
end;

procedure TrmDGraph.SetRightMargin(value: integer);
begin
  if value <> FRightMargin then
  begin
    FRightMargin := value;
    Paint;
  end;
end;

procedure TrmDGraph.SetTopMargin(value: integer);
begin
  if value <> FTopMargin then
  begin
    FTopMargin := value;
    Paint;
  end;
end;

procedure TrmDGraph.SetBottomMargin(value: integer);
begin
  if value <> FBottomMargin then
  begin
    FBottomMargin := value;
    Paint;
  end;
end;

procedure TrmDGraph.SetRightOffset(value: integer);
begin
  if value <> FRightOffset then
  begin
    FRightOffset := value;
    Paint;
  end;
end;

procedure TrmDGraph.SetHorzMinVal(value: single);
begin
  if value <> FHorzMinVal then
  begin
    FHorzMinVal := value;
    Paint;
  end;
end;

procedure TrmDGraph.SetHorzMaxVal(value: single);
begin
  if value <> FHorzMaxVal then
  begin
    FHorzMaxVal := value;
    Paint;
  end;
end;

procedure TrmDGraph.SetHorzUnit(value: string);
begin
  if value <> FHorzUnit then
  begin
    FHorzUnit := value;
    Paint;
  end;
end;

procedure TrmDGraph.SetHorzDecNum(value: integer);
begin
  if value <> FHorzDecNum then
  begin
    FHorzDecNum := value;
    Paint;
  end;
end;

procedure TrmDGraph.SetHorzDiv(value: integer);
begin
  if value <> FHorzDiv then
  begin
    FHorzDiv := value;
    Paint;
  end;
end;

procedure TrmDGraph.SetScaleText(value: TScaleText);
begin
  if value <> FScaleText then
  begin
    FScaleText := value;
    Paint;
  end;
end;

procedure TrmDGraph.SetTextColor(value: TColor);
begin
  if value <> FTextColor then
  begin
    FTextColor := value;
    Paint;
  end;
end;

procedure TrmDGraph.SetTextSize(value: integer);
begin
  if value <> FTextSize then
  begin
    FTextSize := value;
    Paint;
  end;
end;

procedure TrmDGraph.SetMaxItems(value: integer);
var
  i: integer;
begin
  if value <> FMaxItems then
  begin
    FMaxItems := value;
    if (LstValues.Count > FMaxItems) and (FMaxItems > 0) then
      for i := 1 To (LstValues.Count - FMaxItems) do
        LstValues.Delete(0);
    Paint;
  end;
end;

procedure TrmDGraph.Clear;
begin
  LstValues.clear;
  Paint;
end;

function TrmDGraph.AddValues(s: string; refresh: boolean): integer;
var
  i: integer;
begin
  LstValues.add(s);
  if (LstValues.Count > FMaxItems) and (FMaxItems > 0) then
    for i := 1 To (LstValues.Count - FMaxItems) do
      LstValues.Delete(0);
  result := LstValues.count;
  if refresh then Paint;
end;

function TrmDGraph.DeleteValues(i: integer; refresh: boolean): integer;
begin
  if i > LstValues.Count - 1 then exit;
  LstValues.delete(i);
  result := LstValues.count;
  if refresh then Paint;
end;


end.




