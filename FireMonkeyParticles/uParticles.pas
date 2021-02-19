unit uParticles;

interface

uses
  System.SysUtils, System.Types, System.Classes, System.UITypes,
  System.Math.Vectors,
  FMX.Graphics, FMX.Types, FMX.Controls;

type
  TMouseActivity = (Ignore, Repel, Attract);

  TParticle = record
    Position: TPointF;
    Velocity: TVector;
    procedure Init(const AMaxSize: TSizeF);
  end;

  TParticles = class(TObject)
  private
    FBackgroundColor: TAlphaColor;
    FControl: TControl;
    FLineColor: TAlphaColor;
    FLineDistance: Integer;
    FMouseActivity: TMouseActivity;
    FMousePosition: TPointF;
    FMouseRadius: Integer;
    FOldMouseLeave: TNotifyEvent;
    FOldMouseMove: TMouseMoveEvent;
    FParticleList: TArray<TParticle>;
    procedure ControlMouseLeave(Sender: TObject);
    procedure ControlMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    function GetParticleCount: Integer;
    procedure SetParticleCount(const Value: Integer);
    function MouseIsVisible: Boolean;
  protected
  public
    property BackgroundColor: TAlphaColor read FBackgroundColor write FBackgroundColor;
    property LineColor: TAlphaColor read FLineColor write FLineColor;
    property LineDistance: Integer read FLineDistance write FLineDistance;
    property MouseActivity: TMouseActivity read FMouseActivity write FMouseActivity;
    property MouseRadius: Integer read FMouseRadius write FMouseRadius;
    property ParticleCount: Integer read GetParticleCount write SetParticleCount;
    constructor Create; overload;
    constructor Create(AControl: TControl; AParticleCount: Integer = 125;
      AMouseBehavior: TMouseActivity = TMouseActivity.Ignore); overload;
    destructor Destroy; override;
    procedure Paint;
    procedure Update;
  end;

implementation


// TParticle
// ============================================================================
procedure TParticle.Init(const AMaxSize: TSizeF);
begin
  Position.X := Random * AMaxSize.Width;
  Position.Y := Random * AMaxSize.Height;
  Velocity.X := (Random - 0.5) * 1.5;
  Velocity.Y := (Random - 0.5) * 1.5;
end;


// TParticles
// ============================================================================
constructor TParticles.Create;
begin
  raise Exception.Create('Call the other constructor');
end;

// ----------------------------------------------------------------------------
constructor TParticles.Create(AControl: TControl; AParticleCount: Integer = 125;
  AMouseBehavior: TMouseActivity = TMouseActivity.Ignore);
begin
  FBackgroundColor := $FF424242;
  FLineColor := TAlphaColorRec.White;
  FLineDistance := 80;
  FMouseActivity := AMouseBehavior;
  FMouseRadius := 150;
  FMousePosition := PointF(-1, -1);

  FControl := AControl;
  FOldMouseLeave := FControl.OnMouseLeave;
  FOldMouseMove := FControl.OnMouseMove;
  FControl.OnMouseLeave := ControlMouseLeave;
  FControl.OnMouseMove := ControlMouseMove;

  ParticleCount := AParticleCount;
end;

// ----------------------------------------------------------------------------
destructor TParticles.Destroy;
begin
  FControl.OnMouseLeave := FOldMouseLeave;
  FControl.OnMouseMove := FOldMouseMove;

  inherited Destroy;
end;

// ----------------------------------------------------------------------------
function TParticles.GetParticleCount: Integer;
begin
  Result := Length(FParticleList);
end;

// ----------------------------------------------------------------------------
procedure TParticles.SetParticleCount(const Value: Integer);
var
  i: Integer;
  LOriginalCount: Integer;
begin
  LOriginalCount := GetParticleCount;
  if Value = LOriginalCount then
    Exit;

  SetLength(FParticleList, Value);
  for i := LOriginalCount to Length(FParticleList) - 1 do
    FParticleList[i].Init(FControl.Size.Size);
end;

// ----------------------------------------------------------------------------
function TParticles.MouseIsVisible: Boolean;
begin
  if MouseActivity = TMouseActivity.Ignore then
    Exit(False);

  Result := (FMousePosition.X > -1) and (FMousePosition.Y > -1);
end;

// ----------------------------------------------------------------------------
procedure TParticles.ControlMouseLeave(Sender: TObject);
begin
  FMousePosition := PointF(-1, -1);

  if Assigned(FOldMouseLeave) then
    FOldMouseLeave(Sender);
end;

// ----------------------------------------------------------------------------
procedure TParticles.ControlMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
begin
  FMousePosition := PointF(X, Y);

  if Assigned(FOldMouseMove) then
    FOldMouseMove(Sender, Shift, X, Y);
end;

// ----------------------------------------------------------------------------
procedure TParticles.Paint;
var
  i, j: Integer;
  LStartParticle, LEndParticle: TParticle;
  LDistance: Single;
  LLineOpacity: Single;
  LParticleRect: TRectF;

  LCanvas: TCanvas;
begin
  LCanvas := FControl.Canvas;

  LCanvas.Fill.Color := FBackgroundColor;
  LCanvas.FillRect(FControl.ClipRect, 0, 0, AllCorners, 1);

  LCanvas.Stroke.Kind := TBrushKind.Solid;
  LCanvas.Stroke.Color := FLineColor;
  LCanvas.Fill.Color := FLineColor;

  for i := 0 to Length(FParticleList) - 1 do
  begin
    LStartParticle := FParticleList[i];
    for j := i + 1 to Length(FParticleList) - 1 do
    begin
      LEndParticle := FParticleList[j];
      LDistance := LStartParticle.Position.Distance(LEndParticle.Position);
      if LDistance <= FLineDistance then
      begin
        LLineOpacity := 1 - (LDistance / FLineDistance);
        LCanvas.DrawLine(LStartParticle.Position, LEndParticle.Position, LLineOpacity);
      end;
    end;

    LParticleRect := RectF(LStartParticle.Position.X, LStartParticle.Position.Y,
      LStartParticle.Position.X, LStartParticle.Position.Y);
    InflateRect(LParticleRect, 1, 1);
    LCanvas.FillEllipse(LParticleRect, 1);
  end;
end;

// ----------------------------------------------------------------------------
procedure TParticles.Update;
var
  i: Integer;
  LX: Single;
  LY: Single;
  LDistanceToMouse: Single;
  LMouseIsVisible: Boolean;
  LMouseForce: TVector;
  LMouseScale: Single;
begin
  LMouseIsVisible := MouseIsVisible;

  for i := 0 to Length(FParticleList) - 1 do
  begin
    // Apply particle's velocity
    FParticleList[i].Position := FParticleList[i].Position + PointF(FParticleList[i].Velocity);

    // Apply mouse force
    if LMouseIsVisible then
    begin
      LDistanceToMouse := FParticleList[i].Position.Distance(FMousePosition);
      if LDistanceToMouse <= FMouseRadius then
      begin
        LMouseScale := (1 / (LDistanceToMouse * LDistanceToMouse)) * LDistanceToMouse*5;
        LMouseForce := (FMousePosition - FParticleList[i].Position) * LMouseScale;

        if MouseActivity = TMouseActivity.Repel then
          LMouseForce := -1 * PointF(LMouseForce);

        FParticleList[i].Position := FParticleList[i].Position + PointF(LMouseForce);
      end;
    end;

    // If necessary, handle particles that cross edges
    LX := FParticleList[i].Position.X + FControl.Size.Width;
    FParticleList[i].Position.X := Frac(LX / FControl.Size.Width) * FControl.Size.Width;

    LY := FParticleList[i].Position.Y + FControl.Size.Height;
    FParticleList[i].Position.Y := Frac(LY / FControl.Size.Height) * FControl.Size.Height;
  end;
end;

end.
