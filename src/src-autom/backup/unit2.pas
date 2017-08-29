unit Unit2;

{$mode objfpc}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, SdpoSerial, Registry, unit1,utils_serial;

type

  { Tform2 }

  Tform2 = class(TForm)
    btn_test: TButton;
    btn_test1: TButton;
    Button2: TButton;
    cb_in3: TComboBox;
    cb_in4: TComboBox;
    cb_out1: TComboBox;
    cb_out2: TComboBox;
    cb_out3: TComboBox;
    CheckBox1: TCheckBox;
    IdleTimer1: TIdleTimer;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    cb_com: TComboBox;
    cb_in1: TComboBox;
    cb_in2: TComboBox;
    cb_out0: TComboBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    test: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    serial: TSdpoSerial;
    procedure btn_test1Click(Sender: TObject);
    procedure btn_testClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure IdleTimer1Timer(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Memo2Change(Sender: TObject);
    procedure serialRxData(Sender: TObject);
  private
    { private declarations }
    a0,a1,a2,a3:string;
  public
    { public declarations }
    procedure analyse;

    procedure setoutput(num:integer; value:boolean);
  end;

var
  form2: Tform2;

implementation

{$R *.lfm}

{ Tform2 }

procedure Split(Delimiter: Char; Str: string; ListOfStrings: TStrings) ;
begin
   ListOfStrings.Clear;
   ListOfStrings.Delimiter       := Delimiter;
   ListOfStrings.StrictDelimiter := True; // Requires D2006 or newer.
   ListOfStrings.DelimitedText   := Str;
end;

{ TForm2 }
procedure Tform2.setoutput(num:integer; value:boolean);
var
  s:string;
begin
   //self.caption:= 'cb_out'+IntToStr(num);
   s:=(Findcomponent('cb_out'+IntToStr(num)) as TComboBox).Text;
   s:=s[2];
   self.caption:=s;
   if value then self.serial.WriteData(s+'-'+'255.') else self.serial.WriteData(s+'-'+'0.');

end;
procedure Tform2.analyse;
var
i:integer;

OutPutList: TStringList;
str,s:string;
begin
  str := StringReplace(memo2.text, sLineBreak, '', [rfReplaceAll]);
  test.caption :=str;
  OutPutList := TStringList.Create;
   try
     Split(';', str, OutPutList) ;
     //self.caption:=inttostr(OutPutList.count);
   finally
   end;
     if  OutPutList.count = 4 then begin
       a0:=OutPutList.Strings[0];
       a1:=OutPutList.Strings[1];
       a2:=OutPutList.Strings[2];
       a3:=OutPutList.Strings[3];

       if self.CheckBox1.checked then begin
         if trim(a0)='' then exit;

         if (strtofloat(a0)>600) then begin
            form1.entrees[1]:= (strtofloat(a0)>600);
            s:=path+'img\'+form1.p_entrees[(form1.imgE1 as Timage).tag]+'1.bmp';
            (form1.imgE1 as Timage).Picture.LoadFromFile(s);

         end else begin
            form1.entrees[1]:=false;
            s:=path+'img\'+form1.p_entrees[(form1.imgE1 as Timage).tag]+'0.bmp';
            (form1.imgE1 as Timage).Picture.LoadFromFile(s);
         end;
         if trim(a1)='' then exit;

         if (strtofloat(a1)>600) then begin
            form1.entrees[2]:= (strtofloat(a1)>600);
            s:=path+'img\'+form1.p_entrees[(form1.imgE2 as Timage).tag]+'1.bmp';
            (form1.imgE2 as Timage).Picture.LoadFromFile(s);

         end else begin
            form1.entrees[2]:=false;
            s:=path+'img\'+form1.p_entrees[(form1.imgE2 as Timage).tag]+'0.bmp';
            (form1.imgE2 as Timage).Picture.LoadFromFile(s);
         end;

         if trim(a2)='' then exit;
            if (strtofloat(a2)>600) then begin
            form1.entrees[3]:= (strtofloat(a2)>600);
            s:=path+'img\'+form1.p_entrees[(form1.imgE3 as Timage).tag]+'1.bmp';
            (form1.imgE3 as Timage).Picture.LoadFromFile(s);

         end else begin
            form1.entrees[3]:=false;
            s:=path+'img\'+form1.p_entrees[(form1.imgE3 as Timage).tag]+'0.bmp';
            (form1.imgE3 as Timage).Picture.LoadFromFile(s);
         end;

         if trim(a3)=''then exit;

         if (strtofloat(a3)>600) then begin
            form1.entrees[4]:= (strtofloat(a3)>600);
            s:=path+'img\'+form1.p_entrees[(form1.imgE4 as Timage).tag]+'1.bmp';
            (form1.imgE4 as Timage).Picture.LoadFromFile(s);

         end else begin
            form1.entrees[4]:=false;
            s:=path+'img\'+form1.p_entrees[(form1.imgE4 as Timage).tag]+'0.bmp';
            (form1.imgE4 as Timage).Picture.LoadFromFile(s);
         end;


       end;


     OutPutList.Free;
   end;
end;

procedure Tform2.FormCreate(Sender: TObject);
begin
  memo1.clear;
  if not fileexists('config.cfg') then exit;
  memo1.Lines.LoadFromFile('config.cfg');
  checkBox1.checked :=( form2.memo1.lines[0] = '1' );
  //cb_com.Text:=form2.memo1.lines[1];
  cb_in1.Text:=form2.memo1.lines[2];
  cb_in2.Text:=form2.memo1.lines[3];
  cb_in3.Text:=form2.memo1.lines[4];
  cb_in4.Text:=form2.memo1.lines[5];
  cb_out0.Text:=form2.memo1.lines[6];
  cb_out1.Text:=form2.memo1.lines[7];
  cb_out2.Text:=form2.memo1.lines[8];
  cb_out3.Text:=form2.memo1.lines[9];
  //btn_test.Click;
  IdleTimer1.Enabled:=self.CheckBox1.Checked;



end;

procedure Tform2.FormShow(Sender: TObject);
begin
  cb_com.Clear;
  cb_com.Items:=lire_com;
end;


procedure Tform2.IdleTimer1Timer(Sender: TObject);
begin
  memo2.Clear;
  self.serial.WriteData('@');

end;

procedure Tform2.Label2Click(Sender: TObject);
begin

end;

procedure Tform2.Memo2Change(Sender: TObject);
begin
  //self.analyse;
end;

procedure Tform2.serialRxData(Sender: TObject);
var rec:string;
begin
  rec:=serial.ReadData;
  Memo2.Append(rec);
  self.analyse;
end;

procedure Tform2.btn_testClick(Sender: TObject);
begin
  try
    if  self.cb_com.text='' then exit;
    serial.Device:=self.cb_com.text;
    serial.Active:=true;
    //self.caption:=self.cb_out0.Text[2];
    serial.WriteData(self.cb_out0.Text[2]+'-255.');
    serial.WriteData(self.cb_out0.Text[2]+'-0.');
   except
     on E : Exception do
     begin
       ShowMessage('Exception message = '+E.Message);
     end;
   end;

end;

procedure Tform2.btn_test1Click(Sender: TObject);
begin
  cb_com.Clear;
  cb_com.Items:=lire_com;
end;

procedure Tform2.Button2Click(Sender: TObject);
begin
  memo1.clear;
  memo1.lines.Add('0');
  memo1.lines.add( self.cb_com.Text);
  memo1.Lines.add( self.cb_in1.Text);
  memo1.Lines.add( self.cb_in2.Text);
  memo1.Lines.add( self.cb_in3.Text);
  memo1.Lines.add( self.cb_in4.Text);

  memo1.Lines.add( self.cb_out0.Text);
  memo1.Lines.add( self.cb_out1.Text);
  memo1.Lines.add( self.cb_out2.Text);
  memo1.Lines.add( self.cb_out3.Text);
  memo1.lines.SaveToFile('config.cfg');
end;

procedure Tform2.CheckBox1Change(Sender: TObject);
begin
  form1.imgE1.Enabled:=not checkbox1.Checked;
  form1.imgE2.Enabled:=not checkbox1.Checked;
  form1.imgE3.Enabled:=not checkbox1.Checked;
  form1.imgE4.Enabled:=not checkbox1.Checked;
end;

procedure Tform2.CheckBox1Click(Sender: TObject);
begin

  self.IdleTimer1.Enabled:=self.CheckBox1.Checked;
end;




end.

