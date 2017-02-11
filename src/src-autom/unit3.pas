unit unit3;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, unit1;

type

  { TForm3 }

  TForm3 = class(TForm)
    Button1: TButton;
    cmbE1: TComboBox;
    cmbE2: TComboBox;
    cmbE3: TComboBox;
    cmbE4: TComboBox;
    cmbS1: TComboBox;
    cmbS2: TComboBox;
    cmbS3: TComboBox;
    cmbS4: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);

    procedure Label2Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.lfm}

{ TForm3 }

procedure TForm3.Label2Click(Sender: TObject);
begin

end;

procedure TForm3.Button1Click(Sender: TObject);
var f:textfile;
begin
  //sauver la configuration et parametrer les images
  assignfile(f,'config2.cfg');
  rewrite(f);

  writeln(f,copy(cmbE1.Text,1,3));
  writeln(f,copy(cmbE2.Text,1,3));
  writeln(f,copy(cmbE3.Text,1,3));
  writeln(f,copy(cmbE4.Text,1,3));

  writeln(f,copy(cmbS1.Text,1,3));
  writeln(f,copy(cmbS2.Text,1,3));
  writeln(f,copy(cmbS3.Text,1,3));
  writeln(f,copy(cmbS4.Text,1,3));
  closefile(f);
  form1.maj;
  form3.hide;
end;

procedure TForm3.FormCreate(Sender: TObject);
begin

end;



end.

