unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, ExtCtrls, Types;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    cond: TEdit;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    ordres: TEdit;
    Timer1: TIdleTimer;
    imgE1: TImage;
    imgE2: TImage;
    imgE3: TImage;
    imgE4: TImage;
    imgS1: TImage;
    imgS2: TImage;
    imgS3: TImage;
    imgS4: TImage;
    Label1: TLabel;
    Label2: TLabel;
    ledE3: TShape;
    ledE4: TShape;
    ledS1: TShape;
    ledS2: TShape;
    ledS3: TShape;
    ledS4: TShape;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    Panel16: TPanel;
    Panel17: TPanel;
    Panel18: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    shape1: TShape;
    ledE2: TShape;
    Panel9: TPanel;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Shape7: TShape;
    Shape8: TShape;
    ledE1: TShape;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure imgE1Click(Sender: TObject);
    procedure imgE4Click(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure Panel7Click(Sender: TObject);
    procedure TabSheet1ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure Timer1Timer(Sender: TObject);
  private
    { private declarations }
  function evaluer_condition(s:string):boolean;

  public
    { public declarations }
    p_entrees: Array[1..4] of string;
    p_sorties: Array[1..4] of string;

    entrees: Array[1..4] of boolean;
    sorties: Array[1..4] of boolean;

    procedure maj;

  end;

var
  Form1: TForm1;


  path:string;


implementation
uses unit2,unit3;
{$R *.lfm}

{ TForm1 }

procedure TForm1.Panel1Click(Sender: TObject);
begin

end;

procedure TForm1.imgE4Click(Sender: TObject);
begin

end;

procedure TForm1.maj;

var f:textfile;
    i:integer;
    s:string;

begin
  assignfile(f,'config2.cfg');
  reset(f);
  for i:= 1 to 4 do begin
      readln(f,s);
      p_entrees[i] := s ;

  end;

  imgE1.Picture.LoadFromFile(path+'img\'+p_entrees[1]+'0.bmp');
  imgE2.Picture.LoadFromFile(path+'img\'+p_entrees[2]+'0.bmp');
  imgE3.Picture.LoadFromFile(path+'img\'+p_entrees[3]+'0.bmp');
  imgE4.Picture.LoadFromFile(path+'img\'+p_entrees[4]+'0.bmp');

  for i:= 1 to 4 do begin
      readln(f,s);
      p_sorties[i] := s ;
  end;

  imgS1.Picture.LoadFromFile(path+'img\'+p_sorties[1]+'0.bmp');
  imgS2.Picture.LoadFromFile(path+'img\'+p_sorties[2]+'0.bmp');
  imgS3.Picture.LoadFromFile(path+'img\'+p_sorties[3]+'0.bmp');
  imgS4.Picture.LoadFromFile(path+'img\'+p_sorties[4]+'0.bmp');

  closefile(f);
end;

procedure TForm1.FormCreate(Sender: TObject);

begin
  path:=ExtractFilePath(Application.ExeName);
  timer1.Enabled:=false;
  self.maj;
  memo1.Lines.LoadFromFile(path+'aide\UTILISATION.TXT');
  memo2.lines.LoadFromFile(path+'aide\CONDITION.TXT');
  memo3.lines.LoadFromFile(path+'aide\ACTION.TXT');
end;

procedure TForm1.imgE1Click(Sender: TObject);
 var s:string;
begin
  if not timer1.Enabled then exit;
  entrees[(sender as Timage).tag] := not(entrees[(sender as Timage).tag]);
  if (entrees[(sender as Timage).tag]) then s:='1' else s:='0';

  s:=path+'img\'+p_entrees[(sender as Timage).tag]+s+'.bmp';
  (sender as Timage).Picture.LoadFromFile(s);
end;

procedure TForm1.Button2Click(Sender: TObject);
var i:integer;
begin
  timer1.Enabled:=false;
  ledE1.Brush.Color:=clRed;
  ledE2.Brush.Color:=clRed;
  ledE3.Brush.Color:=clRed;
  ledE4.Brush.Color:=clRed;
  ledS1.Brush.Color:=clRed;
  ledS2.Brush.Color:=clRed;
  ledS3.Brush.Color:=clRed;
  ledS4.Brush.Color:=clRed;



  for i:= 1 to 4 do
  begin
    entrees[i] := false;
    sorties[i] :=false;
  end;

  imgE1.Picture.LoadFromFile(path+'img\'+p_entrees[1]+'0.bmp');
  imgE2.Picture.LoadFromFile(path+'img\'+p_entrees[2]+'0.bmp');
  imgE3.Picture.LoadFromFile(path+'img\'+p_entrees[3]+'0.bmp');
  imgE4.Picture.LoadFromFile(path+'img\'+p_entrees[4]+'0.bmp');

  imgS1.Picture.LoadFromFile(path+'img\'+p_sorties[1]+'0.bmp');
  imgS2.Picture.LoadFromFile(path+'img\'+p_sorties[2]+'0.bmp');
  imgS3.Picture.LoadFromFile(path+'img\'+p_sorties[3]+'0.bmp');
  imgS4.Picture.LoadFromFile(path+'img\'+p_sorties[4]+'0.bmp');

  shape1.Brush.color:=clBlack;
  shape2.Brush.color:=clBlack;
  shape3.Brush.color:=clBlack;
  shape4.Brush.color:=clBlack;
  shape5.Brush.color:=clBlack;
  shape6.Brush.color:=clBlack;
  shape7.Brush.color:=clBlack;
  shape8.Brush.color:=clBlack;

  button2.enabled:=false;
  button1.Enabled:=true;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  form3.show;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  form2.show;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  timer1.Enabled:=true;
  button1.enabled:=false;
  button2.Enabled:=true;

end;

procedure TForm1.Panel7Click(Sender: TObject);
begin

end;

procedure TForm1.TabSheet1ContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

function TForm1.evaluer_condition(s:string):boolean;
var tmp:string;
    i:integer;
begin
   tmp :=s;
   for i:=1 to 4 do begin
     tmp  := StringReplace(tmp, 'E'+inttostr(i),inttostr(integer(entrees[i])), [rfReplaceAll, rfIgnoreCase]);
   end;
   tmp  := StringReplace(tmp, '/0','1', [rfReplaceAll, rfIgnoreCase]);
   tmp  := StringReplace(tmp, '/1','0', [rfReplaceAll, rfIgnoreCase]);
   tmp  := StringReplace(tmp, '0.0','0', [rfReplaceAll, rfIgnoreCase]);
   tmp  := StringReplace(tmp, '0.1','0', [rfReplaceAll, rfIgnoreCase]);
   tmp  := StringReplace(tmp, '1.0','0', [rfReplaceAll, rfIgnoreCase]);
   tmp  := StringReplace(tmp, '1.1','1', [rfReplaceAll, rfIgnoreCase]);
   tmp  := StringReplace(tmp, '0+0','0', [rfReplaceAll, rfIgnoreCase]);
   tmp  := StringReplace(tmp, '0+1','1', [rfReplaceAll, rfIgnoreCase]);
   tmp  := StringReplace(tmp, '1+0','1', [rfReplaceAll, rfIgnoreCase]);
   tmp  := StringReplace(tmp, '1+1','1', [rfReplaceAll, rfIgnoreCase]);
   //self.caption := tmp;
   result:= (tmp = '1');
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var t:boolean;
begin

  //gestion couleur entrees
  if entrees[1] then shape1.Brush.Color:=clGreen else shape1.Brush.Color:=clBlack ;
  if entrees[2] then shape2.Brush.Color:=clGreen else shape2.Brush.Color:=clBlack ;
  if entrees[3] then shape3.Brush.Color:=clGreen else shape3.Brush.Color:=clBlack ;
  if entrees[4] then shape4.Brush.Color:=clGreen else shape4.Brush.Color:=clBlack ;

  if entrees[1] then ledE1.Brush.Color:=clGreen else ledE1.Brush.Color:=clRed ;
  if entrees[2] then ledE2.Brush.Color:=clGreen else ledE2.Brush.Color:=clRed ;
  if entrees[3] then ledE3.Brush.Color:=clGreen else ledE3.Brush.Color:=clRed ;
  if entrees[4] then ledE4.Brush.Color:=clGreen else ledE4.Brush.Color:=clRed ;

  //evaluer les conditons
  t:=evaluer_condition(cond.text);
  if t then begin
  //self.caption := 'ok';
  //gerer les ordres
    if pos('S1',ordres.text)> 0 then imgS1.Picture.LoadFromFile(path+'img\'+p_sorties[1]+'1.bmp') else imgS1.Picture.LoadFromFile(path+'img\'+p_sorties[1]+'0.bmp') ;
    if pos('S2',ordres.text)> 0 then imgS2.Picture.LoadFromFile(path+'img\'+p_sorties[2]+'1.bmp') else imgS2.Picture.LoadFromFile(path+'img\'+p_sorties[2]+'0.bmp') ;
    if pos('S3',ordres.text)> 0 then imgS3.Picture.LoadFromFile(path+'img\'+p_sorties[3]+'1.bmp') else imgS3.Picture.LoadFromFile(path+'img\'+p_sorties[3]+'0.bmp') ;
    if pos('S4',ordres.text)> 0 then imgS4.Picture.LoadFromFile(path+'img\'+p_sorties[4]+'1.bmp') else imgS4.Picture.LoadFromFile(path+'img\'+p_sorties[4]+'0.bmp') ;

    if pos('S1',ordres.text)> 0 then shape5.Brush.Color:=clGreen;
    if pos('S2',ordres.text)> 0 then shape6.Brush.Color:=clGreen;
    if pos('S3',ordres.text)> 0 then shape7.Brush.Color:=clGreen;
    if pos('S4',ordres.text)> 0 then shape8.Brush.Color:=clGreen;

    if pos('S1',ordres.text)> 0 then ledS1.Brush.Color:=clGreen;
    if pos('S2',ordres.text)> 0 then ledS2.Brush.Color:=clGreen;
    if pos('S3',ordres.text)> 0 then ledS3.Brush.Color:=clGreen;
    if pos('S4',ordres.text)> 0 then ledS4.Brush.Color:=clGreen;

    if form2.CheckBox1.Checked = false then exit;
    form2.setoutput(0,pos('S1',ordres.text)>0);
    form2.setoutput(1,pos('S2',ordres.text)>0);
    form2.setoutput(2,pos('S3',ordres.text)>0);
    form2.setoutput(3,pos('S4',ordres.text)>0);

  end else begin
    imgS1.Picture.LoadFromFile(path+'img\'+p_sorties[1]+'0.bmp') ;
    imgS2.Picture.LoadFromFile(path+'img\'+p_sorties[2]+'0.bmp') ;
    imgS3.Picture.LoadFromFile(path+'img\'+p_sorties[3]+'0.bmp') ;
    imgS4.Picture.LoadFromFile(path+'img\'+p_sorties[4]+'0.bmp') ;
    self.Shape5.Brush.Color:=clBlack;
    self.Shape6.Brush.Color:=clBlack;
    self.Shape7.Brush.Color:=clBlack;
    self.Shape8.Brush.Color:=clBlack;
    ledS1.Brush.color:=clRed;
    ledS2.Brush.color:=clRed;
    ledS3.Brush.color:=clRed;
    ledS4.Brush.color:=clRed;

    form2.setoutput(0,false);
    form2.setoutput(1,false);
    form2.setoutput(2,false);
    form2.setoutput(3,false);

  end;



  //gerer les couleurs de sortie

end;

end.

