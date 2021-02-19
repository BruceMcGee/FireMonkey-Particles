unit ufrmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Controls.Presentation,
  uParticles, FMX.Edit;

type
  TfrmMain = class(TForm)
    PaintBox1: TPaintBox;
    lblBrand: TLabel;
    Timer1: TTimer;
    PaintBox2: TPaintBox;
    PaintBox3: TPaintBox;
    PaintBox4: TPaintBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject; Canvas: TCanvas);
    procedure Timer1Timer(Sender: TObject);
    procedure PaintBox2Paint(Sender: TObject; Canvas: TCanvas);
    procedure PaintBox3Paint(Sender: TObject; Canvas: TCanvas);
    procedure PaintBox4Paint(Sender: TObject; Canvas: TCanvas);
  private
    FParticles1: TParticles;
    FParticles2: TParticles;
    FParticles3: TParticles;
    FParticles4: TParticles;
  public
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}


procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FParticles1 := TParticles.Create(PaintBox1, 100, TMouseActivity.Repel);
  FParticles1.MouseRadius := 90;

  FParticles2 := TParticles.Create(PaintBox2, 50);
  FParticles2.BackgroundColor:=TAlphaColor($FF1D6FA5);
  FParticles2.LineColor:=TAlphaColor($80FFFFFF);

  FParticles3 := TParticles.Create(PaintBox3, 75);
  FParticles3.BackgroundColor:=TAlphaColor($FFB61924);
  FParticles3.LineColor:=TAlphaColor($80FFFFFF);

  FParticles4 := TParticles.Create(PaintBox4, 25);
  FParticles4.LineColor:=TAlphaColorRec.Black;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FParticles1.Free;
  FParticles2.Free;
  FParticles3.Free;
  FParticles4.Free;
end;

procedure TfrmMain.PaintBox1Paint(Sender: TObject; Canvas: TCanvas);
begin
  FParticles1.Update;
  FParticles1.Paint;
end;

procedure TfrmMain.PaintBox2Paint(Sender: TObject; Canvas: TCanvas);
begin
  FParticles2.Update;
  FParticles2.Paint;
end;

procedure TfrmMain.PaintBox3Paint(Sender: TObject; Canvas: TCanvas);
begin
  FParticles3.Update;
  FParticles3.Paint;
end;

procedure TfrmMain.PaintBox4Paint(Sender: TObject; Canvas: TCanvas);
begin
  FParticles4.Update;
  FParticles4.Paint;
end;

procedure TfrmMain.Timer1Timer(Sender: TObject);
begin
  PaintBox1.Repaint;
  PaintBox2.Repaint;
  PaintBox3.Repaint;
  PaintBox4.Repaint;
end;

end.
