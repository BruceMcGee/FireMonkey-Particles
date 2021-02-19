unit ufrmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, System.UIConsts,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, System.Math.Vectors,
  uParticles, FMX.Colors, FMX.Edit, FMX.EditBox, FMX.ComboTrackBar, FMX.Layouts;

type

  TfrmMain = class(TForm)
    PaintBox1: TPaintBox;
    Timer1: TTimer;
    lblBrand: TLabel;
    colBackground: TColorPanel;
    tbLineDistance: TTrackBar;
    lblLineDistance: TLabel;
    rbIgnore: TRadioButton;
    rbRepell: TRadioButton;
    colLine: TColorPanel;
    rbAttract: TRadioButton;
    tbParticleCount: TTrackBar;
    lblParticleCount: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Layout1: TLayout;
    tbMouseRadius: TTrackBar;
    lblMouseRadius: TLabel;
    Label6: TLabel;
    lblBackground: TLabel;
    lblLine: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure colBackgroundChange(Sender: TObject);
    procedure colLineChange(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject; Canvas: TCanvas);
    procedure rbChange(Sender: TObject);
    procedure tbLineDistanceChange(Sender: TObject);
    procedure tbParticleCountChange(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure tbMouseRadiusChange(Sender: TObject);
  private
    FParticles: TParticles;
  public
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}


// TfrmMain
// ============================================================================
procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FParticles := TParticles.Create(PaintBox1);

  tbParticleCount.Value := FParticles.ParticleCount;
  tbLineDistance.Value := FParticles.LineDistance;
  tbMouseRadius.Value := FParticles.MouseRadius;

  colLine.Color := FParticles.LineColor;
  colBackground.Color := FParticles.BackgroundColor;
  lblBackground.Text := AlphaColorToString(FParticles.BackgroundColor);
  lblLine.Text := AlphaColorToString(FParticles.LineColor);

  if FParticles.MouseActivity = TMouseActivity.Ignore then
    rbIgnore.IsChecked := True;
  if FParticles.MouseActivity = TMouseActivity.Repel then
    rbRepell.IsChecked := True;
  if FParticles.MouseActivity = TMouseActivity.Attract then
    rbAttract.IsChecked := True;
end;

// ----------------------------------------------------------------------------
procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FParticles.Free;
end;

// ----------------------------------------------------------------------------
procedure TfrmMain.colBackgroundChange(Sender: TObject);
begin
  lblBackground.Text := AlphaColorToString(colBackground.Color);
  FParticles.BackgroundColor := colBackground.Color;
end;

// ----------------------------------------------------------------------------
procedure TfrmMain.colLineChange(Sender: TObject);
begin
  lblLine.Text := AlphaColorToString(colLine.Color);
  FParticles.LineColor := colLine.Color;
end;

// ----------------------------------------------------------------------------
procedure TfrmMain.PaintBox1Paint(Sender: TObject; Canvas: TCanvas);
begin
  FParticles.Update;
  FParticles.Paint;
end;

// ----------------------------------------------------------------------------
procedure TfrmMain.rbChange(Sender: TObject);
begin
  if rbIgnore.IsChecked then
    FParticles.MouseActivity := TMouseActivity.Ignore;
  if rbRepell.IsChecked then
    FParticles.MouseActivity := TMouseActivity.Repel;
  if rbAttract.IsChecked then
    FParticles.MouseActivity := TMouseActivity.Attract;
end;

// ----------------------------------------------------------------------------
procedure TfrmMain.tbLineDistanceChange(Sender: TObject);
begin
  lblLineDistance.Text := Trunc(tbLineDistance.Value).ToString;
  FParticles.LineDistance := Trunc(tbLineDistance.Value);
end;

// ----------------------------------------------------------------------------
procedure TfrmMain.tbMouseRadiusChange(Sender: TObject);
begin
  lblMouseRadius.Text := Trunc(tbMouseRadius.Value).ToString;
  FParticles.MouseRadius := Trunc(tbMouseRadius.Value);
end;

// ----------------------------------------------------------------------------
procedure TfrmMain.tbParticleCountChange(Sender: TObject);
begin
  lblParticleCount.Text := Trunc(tbParticleCount.Value).ToString;
  FParticles.ParticleCount := Trunc(tbParticleCount.Value);
end;

// ----------------------------------------------------------------------------
procedure TfrmMain.Timer1Timer(Sender: TObject);
begin
  PaintBox1.Repaint;
end;

end.
