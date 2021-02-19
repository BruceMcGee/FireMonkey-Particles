unit ufrmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, System.UIConsts,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls,
  uParticles;

type

  TfrmMain = class(TForm)
    PaintBox1: TPaintBox;
    Timer1: TTimer;
    lblBrand: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject; Canvas: TCanvas);
    procedure Timer1Timer(Sender: TObject);
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
  FParticles.MouseActivity := TMouseActivity.Repel;
end;

// ----------------------------------------------------------------------------
procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FParticles.Free;
end;

// ----------------------------------------------------------------------------
procedure TfrmMain.PaintBox1Paint(Sender: TObject; Canvas: TCanvas);
begin
  FParticles.Update;
  FParticles.Paint;
end;

// ----------------------------------------------------------------------------
procedure TfrmMain.Timer1Timer(Sender: TObject);
begin
  PaintBox1.Repaint;
end;

end.
