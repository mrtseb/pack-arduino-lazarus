unit Unit1;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, rmSwitchLed, rmDGraph, StdCtrls, ExtCtrls, rmLed, Grids,
  ComCtrls, CPort;

type
  TForm1 = class(TForm)
    logicGraph: TrmDGraph;
    in1: TrmSwitchLed;
    in2: TrmSwitchLed;
    out: TrmLed;
    Panel1: TPanel;
    ComboBox1: TComboBox;
    Timer1: TTimer;
    StringGrid1: TStringGrid;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    RichEdit1: TMemo;
    Image2: TImage;
    Label5: TLabel;
    CheckBox1: TCheckBox;
    picaxe1: TComPort;
    Button1: TButton;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure in1Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  images:array[0..10] of string;
  Form1: TForm1;
  last:boolean;
  f,path:string;

implementation

{$IFnDEF FPC}
  {$IFnDEF FPC}
  {$IFnDEF FPC}
  {$R *.lfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}
{$ELSE}
  {$R *.lfm}
{$ENDIF}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

procedure TForm1.Timer1Timer(Sender: TObject);
var f,s:string;
    ordre:integer;

begin

s:='';
f:=path+'\images\';
if self.ComboBox1.itemindex <> -1 then f:=f+images[self.ComboBox1.itemindex] else f:=path+'\images\'+'rien.bmp' ;

f:=f+inttostr(integer(self.in2.SwitchOn))+inttostr(integer(self.in1.SwitchOn))+'.bmp';

self.in2.Visible := self.ComboBox1.ItemIndex>2;
if self.ComboBox1.ItemIndex<3 then self.StringGrid1.RowCount:=3 else self.StringGrid1.RowCount:=5;

case self.ComboBox1.ItemIndex of
0: begin f:=path+'\images\rien.bmp' ; end;
1: begin f:=path+'\images\oui'+inttostr(integer(self.in1.SwitchOn))+'.bmp' ; self.out.LedOn:=self.in1.SwitchOn; end;
2: begin f:=path+'\images\non'+inttostr(integer(self.in1.SwitchOn))+'.bmp' ; self.out.LedOn:=not(self.in1.SwitchOn); end;
3: begin self.out.LedOn:=self.in1.SwitchOn and self.in2.SwitchOn;

    end;
4: begin self.out.LedOn:=self.in1.SwitchOn or self.in2.SwitchOn ;  end;
5: begin self.out.LedOn:=self.in1.SwitchOn xor self.in2.SwitchOn ; end;
6: begin self.out.LedOn:=not(self.in1.SwitchOn and self.in2.SwitchOn) ; end;
7: begin self.out.LedOn:=not(self.in1.SwitchOn or self.in2.SwitchOn) ; end;
8: begin self.out.LedOn:=not(self.in1.SwitchOn xor self.in2.SwitchOn) ; end;
9: begin self.out.LedOn:=not(self.in1.SwitchOn) and self.in2.SwitchOn ; end;
10: begin
          if self.in1.SwitchOn and not self.in2.SwitchOn then self.out.LedOn:=true;
          if self.in2.SwitchOn and not self.in1.SwitchOn then self.out.LedOn:=false;
          if self.in1.SwitchOn and self.in2.SwitchOn then self.out.LedOn:=false;
          f:=path+'\images\'+images[self.ComboBox1.itemindex]+inttostr(integer(self.in1.SwitchOn))+inttostr(integer(self.in2.SwitchOn))+inttostr(integer(last))+'.bmp';

   end;




end;



if self.in1.SwitchOn then s:=s+'1' else s:=s+'0';
if self.in2.SwitchOn then s:=s+'1' else s:=s+'0';
if self.out.LedOn then s:=s+'1' else s:=s+'0';

self.logicGraph.AddValues(s,true);

  ordre:=1;
  if self.in1.SwitchOn then ordre:=ordre+1;
  if self.in2.SwitchOn then ordre:=ordre+2;
  self.StringGrid1.Cells[2,ordre]:=inttostr(integer(self.out.LedOn));

  //form1.caption:=f;
  if self.ComboBox1.ItemIndex <>-1 then self.Image1.Picture.LoadFromFile(f);
  self.Image2.Picture.LoadFromFile(path+'images\porte_rien.bmp');
  if self.ComboBox1.ItemIndex <11 then self.Image2.Picture.LoadFromFile(path+'images\porte_'+images[self.ComboBox1.itemindex]+'.bmp');


  last:=self.out.LedOn;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin

path:=ExtractFilePath(Application.ExeName);
images[0]:='rien';
images[1]:='oui';
images[2]:='non';
images[3]:='et';
images[4]:='ou';
images[5]:='ouex';
images[6]:='nonet';
images[7]:='nonou';
images[8]:='nonouex';
images[9]:='securite';
images[10]:='memoire';


self.ComboBox1.ItemIndex:=0;
self.ComboBox1Change(self);



last:=false;
self.logicGraph.AddValues('000',true);
self.StringGrid1.Cells[0,0] := 'IN2';
self.StringGrid1.Cells[1,0] := 'IN1';
self.StringGrid1.Cells[2,0] := 'OUT';

self.StringGrid1.Cells[0,1] := '0'; self.StringGrid1.Cells[1,1] := '0';
self.StringGrid1.Cells[0,2] := '0'; self.StringGrid1.Cells[1,2] := '1';
self.StringGrid1.Cells[0,3] := '1'; self.StringGrid1.Cells[1,3] := '0';
self.StringGrid1.Cells[0,4] := '1'; self.StringGrid1.Cells[1,4] := '1';

self.picaxe1.Open;
self.picaxe1.WriteStr('1'#13#10);

end;

procedure TForm1.in1Change(Sender: TObject);
var s:string;
    ordre:word;
begin
  ordre:=1;
  if self.in1.SwitchOn then ordre:=ordre+1;
  if self.in2.SwitchOn then ordre:=ordre+2;
  StringGrid1.Selection := TGridRect(Rect(0, ordre, 2, ordre))
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
var i,ordre:integer;
begin
for i:=1 to 4 do
    StringGrid1.Cells[2,i]:='?';

 if self.ComboBox1.ItemIndex <>-1 then self.RichEdit1.Lines.LoadFromFile( path+'\notices\'+images[self.ComboBox1.itemindex]+'.rtf');


end;
procedure TForm1.Button1Click(Sender: TObject);
begin
self.picaxe1.ShowSetupDialog;
self.picaxe1.Open;
end;

end.
